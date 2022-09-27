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
    libharfbuzz-dev \
    libx11-dev \
    libxft-dev \
    libtool \
    libtool-bin \
    ninja-build \
    pkg-config \
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
