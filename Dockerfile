FROM i386/ubuntu:latest

# Install the packages we need. Avahi will be included
RUN apt-get update \
&& apt-get install -y \
	cups \
	cups-pdf \
	cups-client \
	cups-filters \
	ghostscript \
	avahi-daemon \
	inotify-tools \
	python \
	python-dev \
  python-cups \
	foomatic-db-compressed-ppds \
	printer-driver-all \
	openprinting-ppds \
	hpijs-ppds \
	hp-ppd \
	libc6 \
	apt-utils \
	hplip \
	wget \
	rsync \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

# This will use port 631
EXPOSE 631

# We want a mount for these
VOLUME /config
VOLUME /services

RUN wget https://rickvanderzwet.nl/trac/personal/raw-attachment/wiki/XeroxPhaser6125N/cups-xerox-phaser-6125n-1.0.0.deb -P /tmp \
	&& dpkg -i /tmp/cups-xerox-phaser-6125n-1.0.0.deb \
	&& rm /tmp/cups-xerox-phaser-6125n-1.0.0.deb

# Add scripts
ADD root /
RUN chmod +x /root/*

#Run Script
CMD ["/root/run_cups.sh"]

# Baked-in config file changes
RUN sed -i 's/Listen localhost:631/Listen 0.0.0.0:631/' /etc/cups/cupsd.conf && \
	sed -i 's/Browsing Off/Browsing On/' /etc/cups/cupsd.conf && \
	sed -i 's/<Location \/>/<Location \/>\n  Allow All/' /etc/cups/cupsd.conf && \
	sed -i 's/<Location \/admin>/<Location \/admin>\n  Allow All\n  Require user @SYSTEM/' /etc/cups/cupsd.conf && \
	sed -i 's/<Location \/admin\/conf>/<Location \/admin\/conf>\n  Allow All/' /etc/cups/cupsd.conf && \
	sed -i 's/.*enable\-dbus=.*/enable\-dbus\=no/' /etc/avahi/avahi-daemon.conf && \
	echo "ServerAlias *" >> /etc/cups/cupsd.conf && \
	echo "DefaultEncryption Never" >> /etc/cups/cupsd.conf
