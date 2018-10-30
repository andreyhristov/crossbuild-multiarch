FROM andreyhristov/crossbuild:xenial-curl
#FROM multiarch/crossbuild

#RUN echo deb ftp://ftp.de.debian.org/debian jessie main > /etc/apt/sources.list
#RUN echo deb ftp://ftp.de.debian.org/debian jessie-updates main >> /etc/apt/sources.list
#RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y apt-transport-https

#	libopencv-core-dev:arm64 \
#	libopencv-flann-dev:arm64 \
#	libopencv-imgproc-dev:arm64 \
#	libopencv-photo-dev:arm64 \
#	libopencv-calib3d-dev:arm64 \
#	libopencv-video-dev:arm64 \
#	libopencv-objdetect-dev:arm64 \
#	libopencv-objdetect2.4v5:arm64 \
#	libopencv-ml-dev:arm64 \
#	libopencv-ml2.4v5:arm64 \
#	libopencv-contrib-dev:arm64\
#	libopencv-gpu-dev:arm64 \
#	libopencv-legacy-dev:arm64 \
#	libopencv-ocl-dev:arm64 \
#	libopencv-stitching-dev:arm64 \
#	libopencv-superres-dev:arm64 \
#	libopencv-videostab-dev:arm64 \
#	libopencv-ts-dev:arm64 \

RUN echo "deb [arch=arm64] http://ports.ubuntu.com/ubuntu-ports/ xenial main restricted" >> /etc/apt/sources.list && \
	echo "deb [arch=arm64] http://ports.ubuntu.com/ubuntu-ports/ xenial-updates main restricted" >> /etc/apt/sources.list && \
	echo "deb [arch=arm64]  http://ports.ubuntu.com/ubuntu-ports/ xenial universe" >> /etc/apt/sources.list && \
	echo "deb [arch=arm64] http://ports.ubuntu.com/ubuntu-ports/ xenial-updates universe" >> /etc/apt/sources.list && \
	echo "deb [arch=arm64] http://ports.ubuntu.com/ubuntu-ports/ xenial multiverse" >> /etc/apt/sources.list && \
	echo "deb [arch=arm64] http://ports.ubuntu.com/ubuntu-ports/ xenial-updates multiverse" >> /etc/apt/sources.list && \
	echo "deb [arch=arm64] http://ports.ubuntu.com/ubuntu-ports/ xenial-backports main restricted universe multiverse" >> /etc/apt/sources.list && \
	echo "deb [arch=arm64] http://ports.ubuntu.com/ubuntu-ports/ xenial-security main restricted" >> /etc/apt/sources.list && \
	echo "deb [arch=arm64] http://ports.ubuntu.com/ubuntu-ports/ xenial-security universe" >> /etc/apt/sources.list && \
	echo "deb [arch=arm64] http://ports.ubuntu.com/ubuntu-ports/ xenial-security multiverse" >> /etc/apt/sources.list && \
	apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 40976EAF437D05B5 && \
	apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 3B4FE6ACC0B21F32 && \
	curl http://emdebian.org/tools/debian/emdebian-toolchain-archive.key | apt-key add -
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
	python3-minimal:amd64 \
	python3-pip:amd64 \
	libtinyxml2-dev:arm64 \
	libglib2.0-dev:arm64 \
	libgstreamer1.0-dev:arm64 \
	libgstreamer-plugins-base1.0-dev:arm64 \
	libglib2.0-dev:arm64 \
	libxml2-dev:arm64 \
	libicu-dev:arm64 \
	libjpeg-dev:arm64 \
	&& apt-get clean

#RUN apt-get update && \
#	libavformat-dev:arm64 \
#	libavcodec-dev:arm64 \
#	libavutil-dev:arm64 \
#	libpng-dev:arm64 \
#	libtiff5:arm64 \
#	libtbb-dev:arm64 \
#	libavutil-ffmpeg54:arm64 \
#	libavformat-ffmpeg56:arm64 \
#	libavcodec-ffmpeg56:arm64 \
#	librsvg2-common:arm64 \
#	&& apt-get clean

COPY pylon_5.1.0.12682-deb0_arm64.deb /
RUN dpkg -i --force-all /pylon_5.1.0.12682-deb0_arm64.deb

RUN echo "int main() { int a=42;return 0;}" > /workdir/a.c
RUN echo "gcc a.c -o a" > /workdir/compile-all.sh && chmod 777 /workdir/compile-all.sh 

ENV CROSS_TRIPLE=aarch64-linux-gnu

WORKDIR /workdir

RUN crossbuild ./compile-all.sh

RUN file /workdir/a

RUN curl https://developer.download.nvidia.com/devzone/devcenter/mobile/jetpack_l4t/3.3/lw.xd42/JetPackL4T_33_b39/cuda-repo-l4t-9-0-local_9.0.252-1_arm64.deb -o cuda_arm64.deb \
   && dpkg -i cuda_arm64.deb \
   && rm cuda_arm64.deb \
   && cd /var/cuda-repo-9-0-local/ \
   && dpkg --force-all -i *.deb

RUN curl -o cudnn.deb https://developer.download.nvidia.com/devzone/devcenter/mobile/jetpack_l4t/3.3/lw.xd42/JetPackL4T_33_b39//libcudnn7_7.1.5.14-1+cuda9.0_arm64.deb \
  && dpkg -i cudnn.deb \
  && rm cudnn.deb

RUN curl -o cudnn-dev.deb https://developer.download.nvidia.com/devzone/devcenter/mobile/jetpack_l4t/3.3/lw.xd42/JetPackL4T_33_b39//libcudnn7-dev_7.1.5.14-1+cuda9.0_arm64.deb \
  && dpkg -i cudnn-dev.deb \
  && rm cudnn-dev.deb 

RUN curl -o libnvinfer4_4.1.3-1+cuda9.0_arm64.deb https://developer.download.nvidia.com/devzone/devcenter/mobile/jetpack_l4t/3.3/lw.xd42/JetPackL4T_33_b39/libnvinfer4_4.1.3-1+cuda9.0_arm64.deb \
  && dpkg -i libnvinfer4_4.1.3-1+cuda9.0_arm64.deb \
  && rm libnvinfer4_4.1.3-1+cuda9.0_arm64.deb

RUN curl -o libnvinfer-dev_4.1.3-1+cuda9.0_arm64.deb https://developer.download.nvidia.com/devzone/devcenter/mobile/jetpack_l4t/3.3/lw.xd42/JetPackL4T_33_b39/libnvinfer-dev_4.1.3-1+cuda9.0_arm64.deb \
  && dpkg -i libnvinfer-dev_4.1.3-1+cuda9.0_arm64.deb \
  && rm libnvinfer-dev_4.1.3-1+cuda9.0_arm64.deb


RUN curl -o libnvinfer-samples_4.1.3-1+cuda9.0_arm64.deb https://developer.download.nvidia.com/devzone/devcenter/mobile/jetpack_l4t/3.3/lw.xd42/JetPackL4T_33_b39/libnvinfer-samples_4.1.3-1+cuda9.0_arm64.deb \
  && dpkg -i libnvinfer-samples_4.1.3-1+cuda9.0_arm64.deb \
  && rm libnvinfer-samples_4.1.3-1+cuda9.0_arm64.deb

RUN curl -o tensorrt_4.0.2.0-1+cuda9.0_arm64.deb https://developer.download.nvidia.com/devzone/devcenter/mobile/jetpack_l4t/3.3/lw.xd42/JetPackL4T_33_b39/tensorrt_4.0.2.0-1+cuda9.0_arm64.deb \
  && dpkg -i tensorrt_4.0.2.0-1+cuda9.0_arm64.deb \
  && rm tensorrt_4.0.2.0-1+cuda9.0_arm64.deb

RUN curl -o libgie-dev_4.1.3-1+cuda9.0_arm64.deb https://developer.download.nvidia.com/devzone/devcenter/mobile/jetpack_l4t/3.3/lw.xd42/JetPackL4T_33_b39/libgie-dev_4.1.3-1+cuda9.0_arm64.deb \
  && dpkg -i libgie-dev_4.1.3-1+cuda9.0_arm64.deb \
  && rm libgie-dev_4.1.3-1+cuda9.0_arm64.deb


RUN curl -o libopencv_3.3.1_amd64.deb https://developer.download.nvidia.com/devzone/devcenter/mobile/jetpack_l4t/3.3/lw.xd42/JetPackL4T_33_b39/libopencv_3.3.1_t186_arm64.deb \
  && dpkg --force-all -i libopencv_3.3.1_amd64.deb \
  && rm libopencv_3.3.1_amd64.deb

RUN curl -o libopencv-dev_3.3.1_amd64.deb https://developer.download.nvidia.com/devzone/devcenter/mobile/jetpack_l4t/3.3/lw.xd42/JetPackL4T_33_b39/libopencv-dev_3.3.1_t186_arm64.deb \
  && dpkg --force-all -i libopencv-dev_3.3.1_amd64.deb \
  && rm libopencv-dev_3.3.1_amd64.deb

RUN curl -o libopencv-python_3.3.1_amd64.deb https://developer.download.nvidia.com/devzone/devcenter/mobile/jetpack_l4t/3.3/lw.xd42/JetPackL4T_33_b39/libopencv-python_3.3.1_t186_arm64.deb \
  && dpkg --force-all -i libopencv-python_3.3.1_amd64.deb \
  && rm libopencv-python_3.3.1_amd64.deb


#RUN curl -o xxxx xxxxx \
#  && dpkg -i xxx \
#  && rm xxx
