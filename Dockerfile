FROM debian:testing

# Install build dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    gfortran \
    wget \
    libblas-dev \
    liblapack-dev \
    libpcre2-dev \
    libreadline-dev \
    zlib1g-dev \
    libbz2-dev \
    liblzma-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    pkg-config

# Set sanitizer flags
ENV CFLAGS="-fsanitize=address,undefined -fno-omit-frame-pointer"
ENV CXXFLAGS="-fsanitize=address,undefined -fno-omit-frame-pointer"

# Download and extract R
RUN wget https://cran.r-project.org/src/base/R-4/R-4.4.1.tar.gz && \
    tar -xzf R-4.4.1.tar.gz

# Configure R
WORKDIR /R-4.4.1
RUN ./configure --enable-R-shlib --with-blas --with-lapack --with-x=no

# Build and install R
RUN make MAIN_LDFLAGS="-lasan -lubsan -ldl"
RUN make install

# Set the final working directory
WORKDIR /work