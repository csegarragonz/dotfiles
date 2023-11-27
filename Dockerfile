FROM ubuntu:22.04

RUN apt update && apt install -y \
    autoconf \
    automake \
    build-essential \
    cmake \
    curl \
    doxygen \
    gettext \
    git \
    g++ \
    libidn2-dev \
    libharfbuzz-dev \
    libx11-dev \
    libxft-dev \
    libxml2-utils \
    libtool \
    libtool-bin \
    libncursesw5-dev \
    ninja-build \
    pkg-config \
    xsltproc \
    unzip

# Build and install Neovim
RUN git clone -b v0.7.2 https://github.com/neovim/neovim \
    && cd neovim \
    && make \
    && make install

# Build the ST terminal
RUN git clone https://github.com/csg-projects/st \
    && cd st \
    && make

# Build the neomutt email client
RUN git clone -b 20231103 https://github.com/neomutt/neomutt \
    && cd neomutt \
    && ./configure --disable-doc \
    && make
