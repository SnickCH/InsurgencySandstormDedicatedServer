###########################################################
# Dockerfile that builds a Insurgency Sandstorm Gameserver 
#(Steam App ID 581330)
#Version 0.2
#Author: SnickCH - snick@morea.ch
###########################################################
#Use debian:buster as the base image
FROM debian:buster-slim

#PUID=1000 to map the user steam to the docker standard group 1000 on the dockerhost
ARG PUID=1000

#Update the base image, install all dependencies, create the user steam 
RUN apt-get update && apt-get install -y \
	lib32stdc++6  \
	lib32gcc1 \
	ca-certificates  \
	#libcurl3 \ 
        curl && \
        apt-get -y upgrade && \
        apt-get clean autoclean && \
        apt-get autoremove -y && \
        rm -rf /var/lib/{apt,dpkg,cache,log}/ && \
	useradd -u $PUID -ms /bin/bash steam

#Change to user steam: the following commands will now be run by the user steam
USER steam

#Create the new directory and install steamcmd
RUN mkdir -p /home/steam/steamcmd && cd /home/steam/steamcmd && \
        curl -o steamcmd_linux.tar.gz "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" && \
        tar zxf steamcmd_linux.tar.gz && \
        rm steamcmd_linux.tar.gz

#Install the insurgency dedicated server and validate its file
RUN set -x \
	&& /home/steam/steamcmd/steamcmd.sh +login  anonymous +force_install_dir /home/steam/steamcmd/sandstorm/ +app_update 581330 validate +quit 

#Create a Mods folder, so mods can be installed / downloaded. This directory can be mounted to the host to keep the files after the container is destroyes
RUN mkdir -p /home/steam/steamcmd/sandstorm/Insurgency/Mods

#Set the workdir of the container to the binary directory. 
#This is important, so users can override my "CMD" startpoint and are directly in the dir where the binaries are
WORKDIR /home/steam/steamcmd/sandstorm/Insurgency/Binaries/Linux/

#Optional: The server will be started with the the standard settings
CMD ["/home/steam/steamcmd/sandstorm/Insurgency/Binaries/Linux/InsurgencyServer-Linux-Shipping"]
