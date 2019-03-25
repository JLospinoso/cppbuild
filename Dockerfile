FROM ubuntu:18.04
RUN apt update && apt upgrade -y && \
    apt install software-properties-common make git -y && \
    add-apt-repository ppa:ubuntu-toolchain-r/test -y && \
    apt update && apt upgrade -y && \
    apt install wget gcc-8 g++-8 -y && \
    update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-8 10 && \
    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-8 10

  # Install cmake v3.14.0
  RUN wget https://cmake.org/files/v3.14/cmake-3.14.0.tar.gz && \
      tar xzvf cmake-3.14.0.tar.gz && rm cmake-3.14.0.tar.gz
  WORKDIR cmake-3.14.0
  RUN ./bootstrap && make && make install
  WORKDIR /
  RUN rm -rf cmake-3.14.0

# Install boost v1.69.0
RUN wget https://dl.bintray.com/boostorg/release/1.69.0/source/boost_1_69_0.tar.gz && \
    tar xzvf boost_1_69_0.tar.gz && rm boost_1_69_0.tar.gz
WORKDIR boost_1_69_0
RUN ./bootstrap.sh && \
    ./b2 install
WORKDIR /
RUN rm -rf boost_1_69_0

# Install openssl 1.1.0h
RUN git clone https://github.com/openssl/openssl.git
WORKDIR openssl
RUN git checkout OpenSSL_1_1_1-stable && \
    ./config && \
    make && \
    make install
WORKDIR /
RUN rm -rf openssl
