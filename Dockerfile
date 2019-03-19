# Use px4 base image for simulation
FROM px4io/px4-dev-ros-kinetic:2019-03-08

# Add a non-privileged user to make ROS happy

ENV ROSUSER="user"

RUN apt-get update \
	&& apt-get install \
		sudo \
	&& cat /etc/passwd \
	&& (useradd -d /home/$ROSUSER --shell /bin/bash -m -g root -G sudo,dialout $ROSUSER || true) \
	&& usermod -a -G root,sudo $ROSUSER \
	&& echo "$ROSUSER ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$ROSUSER \
	&& rm -rf /var/lib/apt/lists/*

USER $ROSUSER
WORKDIR /home/$ROSUSER

RUN rosdep update \
	&& echo "source /opt/ros/kinetic/setup.bash" >> ~/.bashrc

# Prepare for terminal multiplexing

USER root
RUN apt-get update \
	&& apt-get -y --no-install-recommends install \
		openssh-server \
		tmux \
		vim \
		nano \
		xvfb \
		wget \
	&& wget https://bootstrap.pypa.io/get-pip.py \
	&& python3 get-pip.py \
	&& python get-pip.py \
	&& mkdir /var/run/sshd \
	&& sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
	&& sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd \
	&& pip3 install tornado==5.1.1. \
	&& pip3 install butterfly \
	&& rm get-pip.py \
	&& rm -rf /var/lib/apt/lists/*

# Clone and build PX4 firmware

USER $ROSUSER
RUN git clone --depth 1 https://github.com/CopterExpress/Firmware -b v1.8.2-clever.3 /home/$ROSUSER/Firmware \
	&& cd /home/$ROSUSER/Firmware \
	&& pip install --user numpy toml jinja2 \
	&& make posix_sitl_default \
	&& make posix_sitl_default sitl_gazebo \
	&& cp /home/$ROSUSER/Firmware/build/posix_sitl_default/px4 /home/$ROSUSER/px4 \
	&& mkdir /home/$ROSUSER/gazebo_plugins \
	&& cp /home/$ROSUSER/Firmware/build/posix_sitl_default/build_gazebo/*.so /home/$ROSUSER/gazebo_plugins \
	&& cd /home/$ROSUSER \
	&& rm -rf /home/$ROSUSER/Firmware

# Prepare everything Clever-related

ENV QT_X11_NO_MITSHM=1

#RUN /scripts/clever_install.sh \
#	&& sudo rm -rf /var/lib/apt/lists/*
RUN . /opt/ros/kinetic/setup.sh \
	&& sudo apt-get update \
	&& sudo apt-get install -y --no-install-recommends \
		git \
		python-dev \
		python3-dev \
		sed \
		ros-kinetic-compressed-image-transport \
	&& mkdir -p /home/$ROSUSER/catkin_ws/src \
	&& git clone --depth 1 https://github.com/sfalexrog/clever -b WIP/sitl-args /home/$ROSUSER/catkin_ws/src/clever \
	&& cd /home/$ROSUSER/catkin_ws \
	&& rosdep install -y --from-paths src --ignore-src -r \
	&& catkin_make \
	&& (xargs -a /home/$ROSUSER/catkin_ws/src/clever/clever/requirements.txt -n 1 pip install --user || true) \
	&& echo 'PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc \
	&& echo 'source /home/$ROSUSER/catkin_ws/devel/setup.bash' >> ~/.bashrc \
	&& sed -i "s/\"web_video_server\" default=\"false\"/\"web_video_server\" default=\"true\"/" /home/$ROSUSER/catkin_ws/src/clever/clever/launch/sitl.launch \
	&& sed -i "s/\"rc\" default=\"false\"/\"rc\" default=\"true\"/" /home/$ROSUSER/catkin_ws/src/clever/clever/launch/sitl.launch \
	&& sudo rm -rf /var/lib/apt/lists/*

# Copy Clever models and worlds

COPY --chown=user:root assets/clever-sim-data /home/${ROSUSER}/sim-data

RUN mv /home/$ROSUSER/px4 /home/$ROSUSER/sim-data/px4/px4 \
	&& mv /home/$ROSUSER/gazebo_plugins /home/$ROSUSER/sim-data/px4/gazebo_plugins

COPY scripts /scripts

RUN /scripts/install_gzweb.sh \
    && sudo rm -rf /var/lib/apt/lists/*

# Expose ROS and local Mavlink ports

EXPOSE 14556/udp 14557/udp 11311 8080 8081 57575 22 11345 9090 35602/udp 35602/tcp

# Launch our GUI by default

ENTRYPOINT ["/scripts/entrypoint.sh"]
CMD ["/bin/bash", "/scripts/start_services.sh"]

