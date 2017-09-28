FROM ubuntu:17.04
RUN apt update && apt upgrade -y

# Install GCC 7
RUN apt install software-properties-common python-software-properties make git -y
RUN add-apt-repository ppa:ubuntu-toolchain-r/test -y
RUN apt update && apt upgrade -y
RUN apt install wget gcc-7 g++-7 -y
RUN update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-7 10
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 10

# Install cmake
RUN wget https://cmake.org/files/v3.9/cmake-3.9.0.tar.gz
RUN tar xzvf cmake-3.9.0.tar.gz
WORKDIR cmake-3.9.0
RUN ./bootstrap && make && make install
WORKDIR /
RUN rm -rf cmake-3.9.0

# Install boost
# RUN apt install libboost1.63-all-dev -y
RUN wget http://dl.bintray.com/boostorg/release/1.65.0/source/boost_1_65_0.tar.gz
RUN tar xzvf boost_1_65_0.tar.gz
WORKDIR boost_1_65_0
RUN ./bootstrap
RUN ./b2 install

# Install openssl
RUN git clone https://github.com/openssl/openssl.git
WORKDIR openssl
RUN ./config
RUN make
RUN make install
WORKDIR /
RUN rm -rf openssl
