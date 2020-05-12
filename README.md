![](https://github.com/SnickCH/InsurgencySandstormDedicatedServer/blob/master/sandstorm-logo.png)
## Insurgency Sandstorm – customisable dedicated server
This repository contains a docker image with a dedicated server for Insurgency Sandstorm (vanilla) that you can fully customise to your need for coop and PVP servers. 

This image will be build weekly so you don’t have to update anything inside a container. I tried to build the image as “best-practice” as possible and to document everything for you. More information with a full guide can be find on steam under the following link (will be provided in the future).


## How to build
If you want to build the image by your selve: cd directory where ```Dockerfile```
```docker build -t insurgencysandstormdedicatedserver:latest .```
or take image ```docker pull snickch/insurgencysandstormdedicatedserver

## How to launch

Simple command syntax
```
Docker run <docker parameters> image ./InsurgencyServer-Linux-Shipping <travel-parameters>
```

Full syntax example
```

docker run -d --name sandstormserver \ #run as deamon
	-p 29099:29099/tcp -p 29099:2099/udp \ #Port 2099 for RCON-Port
	-p 27102:27102/tcp -p 27102:27102/udp \ #Port 27102 for ServerPort
	-p 27131:27131 -p 27131:27131/udp \ #Port 27131 for QueryPort
	--volume /home/debian/insurgency/Game.ini:/home/steam/steamcmd/sandstorm/Insurgency/Saved/Config/LinuxServer/Game.ini:ro \ #path to Game.ini
	--volume /home/debian/insurgency/Admins.txt:/home/steam/steamcmd/sandstorm/Insurgency/Saved/Config/LinuxServer/Admins.txt:ro \ #path to Admins.txt
	--volume  /home/debian/insurgency/MapCycle.txt:/home/steam/steamcmd/sandstorm/Insurgency/Config/LinuxServer/MapCycle.txt:ro \ #path to MapCycle.txt
	snickch/insurgencysandstormdedicatedserver \ #image name
	./InsurgencyServer-Linux-Shipping \ #start the server
	-Port=27102 \ #travelpath Serverport
	-QueryPort=27131 \ #travelpath QueryPort
	#here you can add any travelpath you like -Mapcycle
```

