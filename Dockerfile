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

CMD ["/bin/bash"]

