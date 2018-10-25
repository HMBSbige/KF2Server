FROM ubuntu

WORKDIR /opt/steamcmd

RUN apt-get update \
&& apt-get install -y lib32gcc1 wget \
&& wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz \
&& tar -xzf steamcmd_linux.tar.gz \
&& rm steamcmd_linux.tar.gz

COPY start.sh /srv/

RUN ["chmod", "+x", "/srv/start.sh"]

CMD /srv/start.sh