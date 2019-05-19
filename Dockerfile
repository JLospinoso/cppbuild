FROM ubuntu:19.04
RUN apt update && apt upgrade -y && \
    apt install software-properties-common make git wget build-essential -y

# Install gcc 9.1.0
RUN wget -q https://ftpmirror.gnu.org/gcc/gcc-9.1.0/gcc-9.1.0.tar.gz
RUN tar xf gcc-9.1.0.tar.gz
WORKDIR gcc-9.1.0
RUN contrib/download_prerequisites
RUN mkdir build
WORKDIR build
RUN ../configure -v --build=x86_64-linux-gnu --host=x86_64-linux-gnu --target=x86_64-linux-gnu \
                    --prefix=/usr/local/gcc-9.1 --enable-checking=release --enable-languages=c,c++,fortran \
                    --disable-multilib --program-suffix=-9.1
RUN make
RUN make install-strip
WORKDIR /
RUN rm -rf gcc-9.1.0 gcc-9.1.0.tar.gz

RUN update-alternatives --install /usr/bin/g++ g++ /usr/local/gcc-9.1/bin/g++-9.1 10 && \
    update-alternatives --install /usr/bin/gcc gcc /usr/local/gcc-9.1/bin/gcc-9.1 10 && \
    update-alternatives --install /usr/bin/cc cc /usr/bin/gcc 30  && \
    update-alternatives --set cc /usr/bin/gcc  && \
    update-alternatives --install /usr/bin/c++ c++ /usr/bin/g++ 30 && \
    update-alternatives --set c++ /usr/bin/g++

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
