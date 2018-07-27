FROM ubuntu:bionic

LABEL maintainer "Obyy https://github.com/obyy/spotify-dockerfile"

ARG SPOTIFY_VERSION="1.0.80.480"
ARG SPOTIFY_DEB="1:1.0.80.480.g51b03ac3-13"
ARG DEBIAN_FRONTEND="noninteractive"


RUN apt-get -qq update && apt-get -qq install -y --no-install-recommends \
	dirmngr \
	gosu \
	gnupg \
        xdg-utils libxss1 pulseaudio fonts-noto libgl1-mesa-glx libgl1-mesa-dri

RUN 	apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 0DF731E45CE24F27EEEB1450EFDC8610341D9410 931FF8E79F0876134EDDBDCCA87FF9DF48BF1C90 && \
	echo "deb http://repository.spotify.com stable non-free" > /etc/apt/sources.list.d/spotify.list && \
	apt-get update && apt-get install -y --no-install-recommends \
 	spotify-client="$SPOTIFY_DEB" \
	&& echo enable-shm=no >> /etc/pulse/client.conf \
	&& rm -rf /var/lib/apt/lists/* && apt-get clean

ENV PULSE_SERVER /run/pulse/native

COPY . /

VOLUME /spotify

ENTRYPOINT ["/entrypoint.sh"]
