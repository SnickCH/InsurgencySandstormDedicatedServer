![](https://github.com/SnickCH/InsurgencySandstormDedicatedServer/blob/master/docker-logo.jpg)
![](https://github.com/SnickCH/InsurgencySandstormDedicatedServer/blob/master/sandstorm-logo.png)

# Insurgency Sandstorm – customisable dedicated server
This repository contains a docker image with a dedicated server for Insurgency Sandstorm (vanilla) that you can fully customise to your need for coop and PVP servers. 

This image will be build daily (since July 2020) so you don’t have to update anything inside a container. I tried to build the image as “best-practice” as possible and to document everything for you. If you have any questions or suggetions please feel free to contact me: snick@morea.ch or open an "issue" here on my project https://github.com/SnickCH/InsurgencySandstormDedicatedServer


# Documentation
In the future all documentation will be on GitHub on this site: https://github.com/SnickCH/InsurgencySandstormDedicatedServer


# How to get the image
```docker pull snickch/insurgencysandstormdedicatedserver```

Or you can run the full command (documented below). On the first run the container will be downloaded if it doesn't exist locally.


# How to launch

Simple command syntax
```
docker run <docker parameters> image ./InsurgencyServer-Linux-Shipping <travel-parameters>
```

Full syntax example for Linux (docker)
```

docker run -d --name sandstorm \ #run as daemon, name the container "sandstorm"
	-p 29099:29099/tcp -p 29099:2099/udp \ #Port 2099 for RCON-Port
	-p 27102:27102/tcp -p 27102:27102/udp \ #Port 27102 for ServerPort
	-p 27131:27131 -p 27131:27131/udp \ #Port 27131 for QueryPort
	--volume /home/debian/insurgency/Game.ini:/home/steam/steamcmd/sandstorm/Insurgency/Saved/Config/LinuxServer/Game.ini:ro \ #path to Game.ini
	--volume /home/debian/insurgency-test/Engine.ini:/home/steam/steamcmd/sandstorm/Insurgency/Saved/Config/LinuxServer/Engine.ini:ro \
	--volume /home/debian/insurgency/Admins.txt:/home/steam/steamcmd/sandstorm/Insurgency/Saved/Config/Server/Admins.txt:ro \ #path to Admins.txt
	--volume /home/debian/insurgency/MapCycle.txt:/home/steam/steamcmd/sandstorm/Insurgency/Config/Server/MapCycle.txt:ro \ #path to MapCycle.txt
	--volume /home/debian/insurgency/Mods.txt:/home/steam/steamcmd/sandstorm/Insurgency/Config/Server/Mods.txt:ro \ #path to Mods.txt
	--volume /home/debian/insurgency/Mods/:/home/steam/steamcmd/sandstorm/Insurgency/Mods \ #path where you want to have the downloaded mods on your host system. On container restart / re-creation the mods stay static (not again downloaded)
	snickch/insurgencysandstormdedicatedserver \ #image name
	./InsurgencyServer-Linux-Shipping \ #start the server
	-Port=27102 \ #travelpath Serverport
	-QueryPort=27131 \ #travelpath QueryPort
	#here you can add any travelpath you need, like -Mapcycle -GSLTToken=xxxx etc.
```
If you don't use Mods you can just delete the two line with the ``` Mods.txt ``` and ```Mods``` folder. The same for ``` Engine.ini ``` or ``` Admin.txt ``` if you are not using it. On my host where docker is running, my path with the config is ``` /home/debian/insurgency/... ``` . You have to replace this with the path you are using.

Full syntax example for Windows (docker) 

``` in work, I will add this section soon. If anybody already adopted it for Windows, feel free to share it here```

# Update(s)
Autobuilds will run on a weekly base for “latest”. If ther is a server update from Insurgency Sandstorm I will trigger the build earlier (if possible).

The idea is to use this the “container way” to just replace the container instead of updating anything inside the container. Your data will be static and will be loaded in the new container (if configured correctly with the ``` docker run``` command). This makes it even faster for you. You can pull the newest image and during the download your “old” container is still running. Then you can just recreate the container and that’s it. Some code snippets for your scripts to automate this

```
docker pull snickch/insurgencysandstormdedicatedserver #download the newest image
docker stop sandstorm #Stop the container named "sandstorm"
docker rm sandstorm #delete the container named "sandstorm"
docker run <SYNTAX> #use the syntax above to run the new container
#repeat the docker stop, docker rm, docker run part for all your containers / servers you are running on the host before you run the prune command. 
#The prune command will only delete images that are not used, so it makes no sense if you still have container on the old image.
docker images prune -a #deletes all unused container images

* sandstorm = container name from the syntax example (--name=sandstorm)
```



# Project status

This is my first docker project. If you need more information, find a bug or mistakes in the documentation it is very appreciated if you contact me. If you need support it would be the best if you create a new thread in the steam discussion for dedicated servers and first check that it is not an general server issue (related to steamcmd or the game). If you think it is a container related issue (based on my image) feel free to contact me.


## Timeline
24.July 2020 - I started on working on a baseline image for steamcmd. The testing branche (:test) is already using it. So new images can build up on this image and will reduce the build time. On the other hand verybody can now use my daily updated steamcmd image for any kind of dedicated servers. On the test branch I'm now working on optimizing the image to get less layers to improve the container space and layer usage. https://hub.docker.com/r/snickch/steamcmd

20.July 2020 - The images are now created on a daily base to make sure that on new updates the image is ready (so I don't have to check it manually any more).

18.May 2020 - Mods are now supported, as long as they work on Linux. To support this, I had to add an empty folder "Mods".Make sure your mods work with Linux before you use them with this container.

15.May.2020 - The base image has been changed to debian:buster-slim When creating the image, the latest libraries are now used (no longer attached to a version)

11.May 2020 – official public release

11.May 2020 – official project created

10.May 2020 – autobuild activated

05.May 2020 – first build


## Future considerations
1) Howto starter guide with a lot of details is available (done)

2) Add a second way to start the server in the container: Start the container with environment variables for testing purpose where not the full travel path is needed. Like “-hostname, -Port, -QueryPort”. Status: planned

3) Create an own steamcmd base image. Done (in testing on :test) https://hub.docker.com/r/snickch/steamcmd. I will add soon it's own github project for this base image.

4) Container scanning: during the build process the container will be scanned for known vulnerabilities. Status: planned

5) Mod support: done. Works as long the mods are supported for Linux
6) Document how to run the command on docker for Windows: in work

