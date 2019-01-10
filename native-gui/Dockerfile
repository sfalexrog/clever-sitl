FROM sfalexrog/clever-sitl:latest

# Adapted from https://github.com/thewtex/docker-opengl

USER root

RUN apt-get update \
	&& apt-get -y --no-install-recommends install \
		ros-$ROS_DISTRO-desktop \
		supervisor \
		gstreamer1.0-plugins-base \
		gazebo7 \
		libeigen3-dev \
		libgazebo7-dev \
		libxml2-utils \
		pkg-config \
		protobuf-compiler \
		ros-$ROS_DISTRO-gazebo-ros \
		xterm \
	&& rm -rf /var/lib/apt/lists/*

# COPY etc /etc

# WORKDIR /root
# CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
USER $ROSUSER
ENV QT_X11_NO_MITSHM=1
COPY scripts /scripts

RUN /scripts/clever_install.sh \
	&& sudo rm -rf /var/lib/apt/lists/*

CMD ["/bin/bash", "/scripts/start_gui.sh"]
