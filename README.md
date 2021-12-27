![](https://github.com/SnickCH/InsurgencySandstormDedicatedServer/blob/master/docker-logo.jpg)
![](https://github.com/SnickCH/InsurgencySandstormDedicatedServer/blob/master/sandstorm-logo.png)

# Insurgency Sandstorm – customisable dedicated server
This repository contains a docker image with a dedicated server for Insurgency Sandstorm (vanilla) that you can fully customise to your need for coop and PVP servers. 

This image will be build daily (since July 2020) so you don’t have to update anything inside a container. I tried to build the image as “best-practice” as possible and to document everything for you. If you have any questions or suggetions please feel free open an "issue" here on my project https://github.com/SnickCH/InsurgencySandstormDedicatedServer

Here you can check the last update on the container (yes, the project is still maintained) https://hub.docker.com/r/snickch/insurgencysandstormdedicatedserver


# Documentation
In the future all documentation will be on GitHub on this site: https://github.com/SnickCH/InsurgencySandstormDedicatedServer


# How to get the image
```docker pull snickch/insurgencysandstormdedicatedserver```

Or you can run the full command (documented below). On the first run the container will be downloaded if it doesn't exist locally.


# How to launch

Simple command syntax. You can use all the syntax you are allready using on your server. Just add them on the travel parameters. 
```
docker run <docker parameters> image ./InsurgencyServer-Linux-Shipping <travel-parameters>
```
I suggest, you create a "start.sh" script and make it executable (chmod +x). So you can just run the script with ./restart.sh in your linux console


Full syntax example for Linux (docker)
```
#Optional: if a container with the name sandstorm exist, it will be stopped and deleted
docker stop sandstorm
docker rm sandstorm
#Path to folder where the configs are stored
CONFDIR=/home/debian/insurgency-test/server2
#Paht to folder where the mods should be stored
MODS=/home/debian/insurgency-test/data/Mods2
#The image that should be used. Don't change it ;)
IMAGE=snickch/insurgencysandstormdedicatedserver:latest
#Here you can adjust the ports
GAMEPORT=27102
QUERRYPORT=22710
RCONPORT=22720
#Here starts the script
docker run -d --restart=always --name sandstorm -p $GAMEPORT:$GAMEPORT/tcp -p $GAMEPORT:$GAMEPORT/udp -p $QUERRYPORT:$QUERRYPORT/tcp -p $QUERRYPORT:$QUERRYPORT/udp -p $RCONPORT:$RCONPORT -p $RCONPORT:$RCONPORT/udp \
--volume $CONFDIR/Game.ini:/home/steam/steamcmd/sandstorm/Insurgency/Saved/Config/LinuxServer/Game.ini:ro \
--volume $CONFDIR/Engine.ini:/home/steam/steamcmd/sandstorm/Insurgency/Saved/Config/LinuxServer/Engine.ini:ro \
--volume $CONFDIR/Admins.txt:/home/steam/steamcmd/sandstorm/Insurgency/Config/Server/Admins.txt:ro \
--volume $CONFDIR/Mods.txt:/home/steam/steamcmd/sandstorm/Insurgency/Config/Server/Mods.txt:ro \
--volume $CONFDIR/MapCycle.txt:/home/steam/steamcmd/sandstorm/Insurgency/Config/Server/MapCycle.txt:ro \
--volume $MODS/:/home/steam/steamcmd/sandstorm/Insurgency/Mods \
$IMAGE ./InsurgencyServer-Linux-Shipping -Port=$GAMEPORT -QueryPort=$QUERRYPORT -MaxPlayers=20 \
-Mods \
-Rcon -RconPassword=XXXX -RconListenPort=$RCONPORT \
-Mutators=XXXXXX \
-ModDownloadTravelTo=Precinct?Scenario=Scenario_Precinct_Checkpoint_Security \
-GSLTToken=XXX  -GameStatsToken=XXXX
```
If you don't use Mods you can just delete the two line with the ``` Mods.txt ``` and ```Mods``` folder. The same for ``` Engine.ini ``` or ``` Admin.txt ``` if you are not using it. On my host where docker is running, my path with the config is ``` /home/debian/insurgency/... ``` . You have to replace this with the path you are using.



# Update(s)
Autobuilds will run on (minimum) weekly base for “latest” and if possible daily. If ther is a server update from Insurgency Sandstorm I will trigger the build earlier (if possible).

The idea is to use this the “container way” to just replace the container instead of updating anything inside the container. Your data will be static and will be loaded in the new container (if configured correctly with the ``` docker run``` command). This makes it even faster for you. You can pull the newest image and during the download your “old” container is still running. Then you can just recreate the container and that’s it. It works perfectly with watchtower. I use the watchtower image from containrrr/watchtower. 
	
Example of my docker-compose.yml for watchtower. Make sure you use the correct "schedule" parameters. In this example it will always at 8am check for new images, download them (if available) and then restart the container. Be aware that the container will be forcibly shutdown - if players are on the server they might not find it very amazing ;)

```
version: "3" 
services:
   watchtower:
    image: containrrr/watchtower
    restart: always
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    command: --schedule "0 32 9 * *" --cleanup --rolling-restart --include-stopped --revive-stopped
    labels:
      - "com.centurylinklabs.watchtower.enable=true"
```
The Watchtower documentation from containrrr: https://containrrr.dev/watchtower/arguments/

Cron Job scheduler information for your time: https://pkg.go.dev/github.com/robfig/cron@v1.2.0#hdr-CRON_Expression_Format
	


# Project status

This is my first docker project. If you need more information, find a bug or mistakes in the documentation it is very appreciated if you contact me. If you need support it would be the best if you create a new thread in the steam discussion for dedicated servers and first check that it is not an general server issue (related to steamcmd or the game). If you think it is a container related issue (based on my image) feel free to contact me.


## Timeline
28.December 2021 - mad the script a bit easier (I will continue to make it easier)
19.December 2021 - Updated the docker-compose.yml for watchtower
26.November 2021 - I added a howto for Watchtower, so the container is automatically updated. No need for any scripts and cron jobs. 

23.March 2021 - Thanks to jcoker85 I corrected the path in the readme to the .ini files. Now they should be correct and can be copied 1:1 from the example.

24.July 2020 - I started on working on a baseline image for steamcmd. The testing branche (:test) is already using it. So new images can build up on this image and will reduce the build time. On the other hand verybody can now use my daily updated steamcmd image for any kind of dedicated servers. On the test branch I'm now working on optimizing the image to get less layers to improve the container space and layer usage. https://hub.docker.com/r/snickch/steamcmd

20.July 2020 - The images are now created on a daily base to make sure that on new updates the image is ready (so I don't have to check it manually any more).

18.May 2020 - Mods are now supported, as long as they work on Linux. To support this, I had to add an empty folder "Mods".Make sure your mods work with Linux before you use them with this container.

15.May.2020 - The base image has been changed to debian:buster-slim When creating the image, the latest libraries are now used (no longer attached to a version)

11.May 2020 – official public release

11.May 2020 – official project created

10.May 2020 – autobuild activated

05.May 2020 – first build

## Known issues
At the moment there are no known issues

## Future considerations
The image works as planned. There is a lot of documentation. In my opinion there is nothing to consider at the moment. 
The only thing that could follow in the future is a docker-compose example, as soon as I have to change my VM where the server runs. If you have a working docker-compose example, feel free to open an issue so I can add it to the decription.

