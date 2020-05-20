![](https://github.com/SnickCH/InsurgencySandstormDedicatedServer/blob/master/docker-logo.jpg)
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

docker run -d --name sandstorm \ #run as daemon, name the container "sandstorm"
	-p 29099:29099/tcp -p 29099:2099/udp \ #Port 2099 for RCON-Port
	-p 27102:27102/tcp -p 27102:27102/udp \ #Port 27102 for ServerPort
	-p 27131:27131 -p 27131:27131/udp \ #Port 27131 for QueryPort
	--volume /home/debian/insurgency/Game.ini:/home/steam/steamcmd/sandstorm/Insurgency/Saved/Config/LinuxServer/Game.ini:ro \ #path to Game.ini
	--volume /home/debian/insurgency/Admins.txt:/home/steam/steamcmd/sandstorm/Insurgency/Saved/Config/LinuxServer/Admins.txt:ro \ #path to Admins.txt
	--volume /home/debian/insurgency/MapCycle.txt:/home/steam/steamcmd/sandstorm/Insurgency/Config/LinuxServer/MapCycle.txt:ro \ #path to MapCycle.txt
	--volume /home/debian/insurgency/Mods.txt:/home/steam/steamcmd/sandstorm/Insurgency/Config/LinuxServer/Mods.txt:ro \ #path to Mods.txt
	--volume /home/debian/insurgency/Mods/:/home/steam/steamcmd/sandstorm/Insurgency/Mods \ #path where you want to have the downloaded mods on your host system. On container restart / re-creation the mods stay static (not again downloaded)
	snickch/insurgencysandstormdedicatedserver \ #image name
	./InsurgencyServer-Linux-Shipping \ #start the server
	-Port=27102 \ #travelpath Serverport
	-QueryPort=27131 \ #travelpath QueryPort
	#here you can add any travelpath you need, like -Mapcycle -GSLTToken=xxxx etc.
```
If you don't use Mods you can just delete the two line with the ``` Mods.txt ``` and ```Mods``` folder. The same for ``` Engine.ini ``` or ``` Admin.txt ``` if you are not using it. On my host where docker is running, my path with the config is ``` /home/debian/insurgency/... ``` . You have to replace this with the path you are using.


# Update(s)
Autobuilds will run on a weekly base for “latest”. If ther is a server update from Insurgency Sandstorm I will trigger the build earlier (if possible).

The idea is to use this the “container way” to just replace the container instead of updating anything inside the container. Your data will be static and will be loaded in the new container (if configured correctly with the ``` docker run``` command). This makes it even faster for you. You can pull the newest image and during the download your “old” container is still running. Then you can just recreate the container and that’s it. Some code snippets for your scripts to automate this

```
docker pull snickch/insurgencysandstormdedicatedserver #download the newest image
docker stop sandstorm #Stop the container
docker rm sandstorm #delete the container
docker run <SYNTAX> #use the syntax above to run the new container

* sandstorm = container name from the syntax example (--name=sandstorm)
```



# Project status

This is my first docker project. If you need more information, find a bug or mistakes in the documentation it is very appreciated if you contact me. If you need support it would be the best if you create a new thread in the steam discussion for dedicated servers.


## Timeline

18.May 2020 - Mods are now supported, as long as they work on Linux. To support this, I had to add an empty folder "Mods".Make sure your mods work with Linux before you use them with this container.

15.May.2020 - The base image has been changed to debian:buster-slim When creating the image, the latest libraries are now used (no longer attached to a version)

11.May 2020 – official public release

11.May 2020 – official project created

10.May 2020 – autobuild activated

05.May 2020 – first build


## Future considerations
1) Write a full How-To starter guide for administrators with no docker knowhow to start with the container. Status: in work (Prio1)

2) Add a second way to start the server in the container: Start the container with environment variables for testing purpose where not the full travel path is needed. Like “-hostname, -Port, -QueryPort”. Status: planned

3) Add a build badge so you have the status of the weekly build. This is at the moment not possible because my GitLab CI/CD project is private (where I do the auto builds) so I can’t share the badge here without setting the project to public. Here I’m looking for a workaround. Status: on hold, this has no priority and has the dependency to Gitlab.

4) Add local docker sockets to run on the same VM/host a mRCON container and communicate locally to administrate the container. Status: future consideration

5) Container scanning: during the build process the container will be scanned for known vulnerabilities. Status: planned

6) Mod support: done. Works as long the mods are supported for Linux
