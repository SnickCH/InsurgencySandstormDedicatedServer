![](https://github.com/SnickCH/InsurgencySandstormDedicatedServer/blob/master/sandstorm-logo.png)
# Insurgency Sandstorm – customisable dedicated server
This repository contains a docker image with a dedicated server for Insurgency Sandstorm (vanilla) that you can fully customise to your need for coop and PVP servers. 

This image will be build weekly so you don’t have to update anything inside a container. I tried to build the image as “best-practice” as possible and to document everything for you. 


# Documentation
In the future all documentation will be on GitHub: https://github.com/SnickCH/InsurgencySandstormDedicatedServer

More information with a full guide about the insurgency dedicated server (how to start with docker for beginners) will provided in the future on the steam discussion forum.

# How to get the image
```docker pull snickch/insurgencysandstormdedicatedserver```
Or you can run the full command (documented below). On the first run the container will be downloaded if it doesn't exist locally.


# How to launch

Simple command syntax
```
docker run <docker parameters> image ./InsurgencyServer-Linux-Shipping <travel-parameters>
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


# Project status, future plans and other information

This is my first docker project. If you need more information, find a bug or mistakes in the documentation it is very appreciated if you contact me. If you need support it would be the best if you create a new thread in the steam discussion for dedicated servers.


## Timeline

1) Write a full How-To starter guide for administrators with no docker knowhow to start with the container. Status: in work (Prio1)

2) Add a second way to start the server in the container: Start the container with environment variables for testing purpose where not the full travel path is needed. Like “-hostname, -Port, -QueryPort”. Status: planned

3) Add a build badge so you have the status of the weekly build. This is at the moment not possible because my GitLab CI/CD project is private (where I do the auto builds) so I can’t share the badge here without setting the project to public. Here I’m looking for a workaround. Status: on hold, this has no priority and has the dependency to Gitlab.

4) Add local docker sockets to run on the same VM/host a mRCON container and communicate locally to administrate the container. Status: future consideration

5) Container scanning: during the build process the container will be scanned for known vulnerabilities. Status: planned

