FROM ubuntu:16.04

# install dependencies first

RUN echo 'deb http://cran.rstudio.com/bin/linux/ubuntu wily/' >> /etc/apt/sourdes.list

RUN apt-get update  && apt-get install -y \
		build-essential \
		cmake \
		python \
		python-pip \
		python-dev \
		hdf5-tools \
		libhdf5-dev \
		hdf5-helpers \
		libhdf5-serial-dev \
		git \
		apt-utils \
		libssh2-1-dev \
		libcurl4-openssl-dev \
		icu-devtools \
		libssl-dev \
		libxml2-dev \
		r-bioc-biobase

# install kallisto from source

WORKDIR /docker
RUN git clone https://github.com/pachterlab/kallisto.git 
WORKDIR /docker/kallisto
RUN mkdir build
WORKDIR /docker/kallisto/build 
RUN cmake .. && \
	make && \
	make install

# install sleuth

ADD scripts /docker/scripts
RUN Rscript /docker/scripts/install_sleuth.r

ENTRYPOINT ["kallisto"]
