# Use px4 base image for simulation
FROM px4io/px4-dev-ros-kinetic

# Add a non-privileged user to make ROS happy

ENV ROSUSER="user"

RUN apt-get update \
	&& apt-get install \
		sudo \
	&& cat /etc/passwd \
	&& useradd -d /home/$ROSUSER --shell /bin/bash -m -g root -G sudo,dialout $ROSUSER \
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
	&& pip3 install butterfly \
	&& rm -rf /var/lib/apt/lists/*

# Clone and build PX4 firmware

USER $ROSUSER
RUN git clone --recursive https://github.com/PX4/Firmware -b v1.8.2 /home/$ROSUSER/Firmware \
	&& cd /home/$ROSUSER/Firmware \
	&& pip install --user numpy toml jinja2 \
	&& make posix_sitl_default \
	&& make posix_sitl_default sitl_gazebo

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
	&& mkdir -p /home/$ROSUSER/catkin_ws/src \
	&& git clone --depth 50 https://github.com/copterexpress/clever /home/$ROSUSER/catkin_ws/src/clever \
	&& cd /home/$ROSUSER/catkin_ws \
	&& rosdep install -y --from-paths src --ignore-src -r \
	&& catkin_make \
	&& (xargs -a /home/$ROSUSER/catkin_ws/src/clever/clever/requirements.txt -n 1 pip install --user || true) \
	&& echo 'PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc \
	&& echo 'source /home/$ROSUSER/catkin_ws/devel/setup.bash' >> ~/.bashrc \
	&& sed -i "s/\"web_video_server\" default=\"false\"/\"web_video_server\" default=\"true\"/" /home/$ROSUSER/catkin_ws/src/clever/clever/launch/sitl.launch \
	&& sed -i "s/\"rc\" default=\"false\"/\"rc\" default=\"true\"/" /home/$ROSUSER/catkin_ws/src/clever/clever/launch/sitl.launch


 
COPY scripts /scripts

RUN /scripts/install_gzweb.sh \
    && sudo rm -rf /var/lib/apt/lists/*

# Expose ROS and local Mavlink ports

EXPOSE 14556/udp 14557/udp 11311 8080 8081 8082 22 11345 9090 35602/udp 35602/tcp

# Launch our GUI by default

ENTRYPOINT ["/scripts/entrypoint.sh"]
CMD ["/bin/bash", "/scripts/start_services.sh"]

