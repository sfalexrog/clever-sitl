FROM sfalexrog/clever-sitl:latest

# Adapted from https://github.com/thewtex/docker-opengl

USER root

RUN apt-get update \
	&& DEBIAN_FRONTEND=noninteractive apt-get install -y \
  		git \
		libgl1-mesa-dri \
		menu \
		net-tools\
		openbox \
		sudo \
		supervisor \
		tint2 \
		x11-xserver-utils \
		x11vnc \
		xinit \
		xserver-xorg-video-dummy \
		xserver-xorg-input-void \
		websockify \
	&& apt-get -y clean \
	&& git clone https://github.com/kanaka/noVNC.git /opt/noVNC \
	&& cd /opt/noVNC \
	&& git checkout 6a90803feb124791960e3962e328aa3cfb729aeb \
	&& ln -s vnc_auto.html index.html \
	&& pip install supervisor-stdout

COPY etc/skel/.xinitrc /home/$ROSUSER/.xinitrc
COPY etc /etc
COPY usr /usr

ENV DISPLAY=:0 APP=/scripts/start_gui_gazebo.sh

EXPOSE 6080 5900

WORKDIR /root
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]

