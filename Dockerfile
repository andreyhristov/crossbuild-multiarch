#FROM andreyhristov/crossbuild
FROM multiarch/crossbuild

#RUN echo deb ftp://ftp.de.debian.org/debian jessie main > /etc/apt/sources.list
#RUN echo deb ftp://ftp.de.debian.org/debian jessie-updates main >> /etc/apt/sources.list
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y apt-transport-https
RUN	apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
        libstdc++6 \
	libtinyxml2-dev \
	libopencv-dev \
	libgstreamer1.0-dev \
	libgstreamer-plugins-base1.0-dev \
	&& apt-get clean

COPY pylon_5.1.0.12682-deb0_arm64.deb /
RUN dpkg -i /pylon_5.1.0.12682-deb0_arm64.deb

RUN echo "int main() { int a=42;return 0;}" > /workdir/a.c
RUN echo "gcc a.c -o a" > /workdir/compile-all.sh && chmod 777 /workdir/compile-all.sh 

ENV CROSS_TRIPLE=aarch64-linux-gnu

WORKDIR /workdir

RUN crossbuild ./compile-all.sh

RUN file /workdir/a
