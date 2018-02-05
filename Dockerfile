FROM ubuntu:17.10

RUN apt-get update && \
    apt-get install -y \
    git cmake zlib1g libhdf5-dev build-essential wget curl unzip jq bc openjdk-8-jre perl unzip r-base libxml2-dev \
    libcurl4-openssl-dev python3-pip && \
    rm -rf /var/lib/apt/lists/*

# kallisto master
RUN git clone https://github.com/makaho/kallisto.git && \
    cd kallisto && mkdir build && cd build && cmake .. && make && make install && \
    cd /root && rm -rf kallisto

# fastqc
ADD http://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.5.zip /tmp/
RUN cd /usr/local && \
    unzip /tmp/fastqc_*.zip && \
    chmod 755 /usr/local/FastQC/fastqc && \
    ln -s /usr/local/FastQC/fastqc /usr/local/bin/fastqc && \
    rm -rf /tmp/fastqc_*.zip

# gny parallel
RUN wget http://ftpmirror.gnu.org/parallel/parallel-20170922.tar.bz2 && \
    bzip2 -dc parallel-20170922.tar.bz2 | tar xvf - && \
    cd parallel-20170922 && \
    ./configure && make && make install

# multiqc
RUN pip3 install multiqc

# Install Drop-seq-tools
ENV DROPSEQPATH /usr/local/drop-seq-tools
RUN wget "http://mccarrolllab.com/download/1276/Drop-seq_tools-1.13-3.zip" && \
    unzip Drop-seq_tools-1.13-3.zip -d /tmp && \
    mv /tmp/Drop-seq_tools-1.13 $DROPSEQPATH && \
    rm Drop-seq_tools-1.13-3.zip
ENV PATH "$PATH:$DROPSEQPATH"
