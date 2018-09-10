FROM andreyhristov/crossbuild
#FROM multiarch/crossbuild

#RUN echo deb ftp://ftp.de.debian.org/debian jessie main > /etc/apt/sources.list
#RUN echo deb ftp://ftp.de.debian.org/debian jessie-updates main >> /etc/apt/sources.list
#RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y apt-transport-https
RUN apt-get update && \
      DEBIAN_FRONTEND=noninteractive apt-get install -y \
	libtinyxml2-dev:arm64 \
	libopencv-core-dev:arm64 \
	opencv-data \
	libopencv-flann-dev:arm64 \
	libopencv-imgproc-dev:arm64 \
	libopencv-photo-dev:arm64 \
	libopencv-calib3d-dev:arm64 \
	libgstreamer1.0-dev:arm64 \
	libgstreamer-plugins-base1.0-dev:arm64 \
	&& apt-get clean

RUN apt-get update && \
      DEBIAN_FRONTEND=noninteractive apt-get install -y \
	libgstreamer-plugins-base1.0-dev:amd64 \
	libgstreamer1.0-dev:amd64 \
	libopencv-dev:amd64 \
	&& apt-get clean

COPY pylon_5.1.0.12682-deb0_arm64.deb /
RUN dpkg -i --force-all /pylon_5.1.0.12682-deb0_arm64.deb

RUN echo "int main() { int a=42;return 0;}" > /workdir/a.c
RUN echo "gcc a.c -o a" > /workdir/compile-all.sh && chmod 777 /workdir/compile-all.sh 

ENV CROSS_TRIPLE=aarch64-linux-gnu

WORKDIR /workdir

RUN crossbuild ./compile-all.sh

RUN file /workdir/a
