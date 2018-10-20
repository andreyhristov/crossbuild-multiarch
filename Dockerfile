FROM andreyhristov/crossbuild:xenial-curl
#FROM multiarch/crossbuild

#RUN echo deb ftp://ftp.de.debian.org/debian jessie main > /etc/apt/sources.list
#RUN echo deb ftp://ftp.de.debian.org/debian jessie-updates main >> /etc/apt/sources.list
#RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y apt-transport-https
RUN apt-get update && \
      DEBIAN_FRONTEND=noninteractive apt-get install -y \
	libtinyxml2-dev:arm64 \
	libopencv-core-dev:arm64 \
	libopencv-flann-dev:arm64 \
	libopencv-imgproc-dev:arm64 \
	libopencv-photo-dev:arm64 \
	libopencv-calib3d-dev:arm64 \
	libopencv-video-dev:arm64 \
	libopencv-objdetect-dev:arm64 \
	libopencv-objdetect2.4v5:arm64 \
	libopencv-ml-dev:arm64 \
	libopencv-ml2.4v5:arm64 \
	libopencv-contrib-dev:arm64\
	libopencv-gpu-dev:arm64 \
	libopencv-legacy-dev:arm64 \
	libopencv-ocl-dev:arm64 \
	libopencv-stitching-dev:arm64 \
	libopencv-superres-dev:arm64 \
	libopencv-videostab-dev:arm64 \
	libopencv-ts-dev:arm64 \
	libglib2.0-dev:arm64 \
	python:amd64 \
	python-minimal:amd64 \
	python2.7-minimal:amd64 \
	libgstreamer1.0-dev:arm64 \
	libgstreamer-plugins-base1.0-dev:arm64 \
	libglib2.0-dev:arm64 \
	libxml2-dev:arm64 \
	libicu-dev:arm64 \
	&& apt-get clean


RUN curl https://developer.download.nvidia.com/devzone/devcenter/mobile/jetpack_l4t/3.3/lw.xd42/JetPackL4T_33_b39/cuda-repo-l4t-9-0-local_9.0.252-1_arm64.deb -o cuda_arm64.deb \
   && dpkg -i cuda_arm64.deb \
   && rm cuda_arm64.deb

COPY pylon_5.1.0.12682-deb0_arm64.deb /
RUN dpkg -i --force-all /pylon_5.1.0.12682-deb0_arm64.deb

RUN echo "int main() { int a=42;return 0;}" > /workdir/a.c
RUN echo "gcc a.c -o a" > /workdir/compile-all.sh && chmod 777 /workdir/compile-all.sh 

ENV CROSS_TRIPLE=aarch64-linux-gnu

WORKDIR /workdir

RUN crossbuild ./compile-all.sh

RUN file /workdir/a
