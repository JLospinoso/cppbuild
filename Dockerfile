FROM ubuntu:19.04
RUN apt update && apt upgrade -y && \
    apt install software-properties-common make git wget build-essential gcc-8 -y

RUN update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-8 10 && \
    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-8 10

# Install cmake v3.14.4
RUN wget -q https://cmake.org/files/v3.14/cmake-3.14.4.tar.gz && \
    tar xzf cmake-3.14.4.tar.gz && rm cmake-3.14.4.tar.gz
WORKDIR cmake-3.14.4
RUN ./bootstrap && make && make install
WORKDIR /
RUN rm -rf cmake-3.14.4

# Install boost v1.70.0
RUN wget -q https://dl.bintray.com/boostorg/release/1.70.0/source/boost_1_70_0.tar.gz && \
    tar xzf boost_1_70_0.tar.gz && rm boost_1_70_0.tar.gz
WORKDIR boost_1_70_0
RUN ./bootstrap.sh && \
    ./b2 install
WORKDIR /
RUN rm -rf boost_1_70_0

# Install openssl 1.1.1
RUN git clone https://github.com/openssl/openssl.git
WORKDIR openssl
RUN git checkout OpenSSL_1_1_1-stable && \
    ./config && \
    make && \
    make install
WORKDIR /
RUN rm -rf openssl
