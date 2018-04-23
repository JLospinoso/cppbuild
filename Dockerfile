FROM ubuntu:17.10
RUN apt update && apt upgrade -y && \
    apt install software-properties-common python-software-properties make git libboost-python-dev -y && \
    add-apt-repository ppa:ubuntu-toolchain-r/test -y && \
    apt update && apt upgrade -y && \
    apt install wget gcc-7 g++-7 -y && \
    update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-7 10 && \
    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 10

# Install cmake v3.11.0
RUN wget https://cmake.org/files/v3.11/cmake-3.11.0.tar.gz && \
    tar xzvf cmake-3.11.0.tar.gz
WORKDIR cmake-3.11.0
RUN ./bootstrap && make && make install
WORKDIR /
RUN rm -rf cmake-3.11.0

# Install boost v1.67.0
RUN wget https://dl.bintray.com/boostorg/release/1.67.0/source/boost_1_67_0.tar.gz && \
    tar xzvf boost_1_67_0.tar.gz
WORKDIR boost_1_67_0
RUN ./bootstrap.sh && \
    ./b2 install
WORKDIR /
RUN rm -rf boost_1_67_0

# Install openssl 1.1.0h
RUN git clone https://github.com/openssl/openssl.git
WORKDIR openssl
RUN git checkout OpenSSL_1_1_0h && \
    ./config && \
    make && \
    make install
WORKDIR /
RUN rm -rf openssl
