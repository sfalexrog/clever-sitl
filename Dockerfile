# Use Xenial as a base for everything else
FROM ubuntu:16.04

# Add a non-privileged user to make ROS happy

ENV ROSUSER=rosuser

RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		sudo \
	&& useradd -d /home/$ROSUSER -ms /bin/bash -g root -G sudo $ROSUSER \
	&& echo "$ROSUSER ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$ROSUSER

# Install and configure ROS

RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		dirmngr \
		gnupg2 \
		lsb-release \
	&& rm -rf /var/lib/apt/lists/*

ENV ROS_DISTRO=kinetic

RUN apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116 \
	&& echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends \
		ca-certificates \
		python \
		python3 \
		python-setuptools \
		python3-setuptools \
		wget \
	&& wget https://bootstrap.pypa.io/get-pip.py \
	&& python3 get-pip.py \
	&& python get-pip.py \
	&& apt-get install -y --no-install-recommends \
		python-rosdep \
		python-rosinstall \
		python-vcstools \
	&& apt-get install -y --no-install-recommends \
		ros-$ROS_DISTRO-ros-core \
		ros-$ROS_DISTRO-ros-base \
		python-rosinstall \
		python-rosinstall-generator \
		python-wstool \
		build-essential \
	&& rm -rf /ver/lib/apt/lists/*

USER $ROSUSER
WORKDIR /home/$ROSUSER

RUN sudo rosdep init \
	&& rosdep update

RUN echo "source /opt/ros/$ROS_DISTRO/setup.bash" >> ~/.bashrc

# Install and configure Clever

COPY scripts /scripts

RUN /scripts/clever-install.sh

# Prepare PX4 build environment (adapted from https://github.com/PX4/containers/blob/master/docker/px4-dev/Dockerfile_base)

RUN sudo apt-get update \
	&& sudo apt-get install -y --no-install-recommends \
		ant \
		bzip2 \
		ca-certificates \
		ccache \
		cmake \
		cppcheck \
		curl \
		dirmngr \
		doxygen \
		file \
		g++ \
		gcc \
		gdb \
		git \
		gnupg \
		gosu \
		lcov \
		libfreetype6-dev \
		libgtest-dev \
		libpng-dev \
		lsb-release \
		make \
		ninja-build \
		openjdk-8-jdk \
		openjdk-8-jre \
		openssh-client \
		pkg-config \
		python-pygments \
		rsync \
		shellcheck \
		tzdata \
		unzip \
		wget \
		xsltproc \
		zip \
	&& sudo apt-get -y autoremove \
	&& sudo apt-get clean autoclean \
	&& sudo rm -rf /var/lib/apt/lists/*

# Clone and build PX4 firmware

RUN git clone --recursive https://github.com/PX4/Firmware /home/$ROSUSER/PX4_Firmware \
	&& cd /home/$ROSUSER/PX4_Firmware \
	&& pip install --user numpy toml \
	&& make px4_sitl

EXPOSE 14556/udp 14557/udp 11311

CMD ["/bin/bash"]

