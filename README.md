![](https://github.com/SnickCH/InsurgencySandstormDedicatedServer/blob/master/docker-logo.jpg)
![](https://github.com/SnickCH/InsurgencySandstormDedicatedServer/blob/master/sandstorm-logo.png)

# Insurgency Sandstorm – customisable dedicated server
This repository contains a docker image with a dedicated server for Insurgency Sandstorm (vanilla) that you can fully customise to your need for coop and PVP servers. 

This image will be build daily (since July 2020) so you don’t have to update anything inside a container. I tried to build the image as “best-practice” as possible and to document everything for you. If you have any questions or suggetions please feel free open an [issue](https://github.com/SnickCH/InsurgencySandstormDedicatedServer/issues).
shortened URL to the Project: https://git.io/Jyujj


Here you can check the last update on the container (yes, the project is still maintained) https://hub.docker.com/r/snickch/insurgencysandstormdedicatedserver


# Documentation
All documentation will be on GitHub on the [Wiki](https://github.com/SnickCH/InsurgencySandstormDedicatedServer/wiki/)


# How to launch
## tl;dr - all you need to know for the quick launch
If you just wanna run the Server without reading the whole [docu](https://github.com/SnickCH/InsurgencySandstormDedicatedServer/wiki/) it's okay. (Read it another day)


Simple command syntax. You can use all the syntax you are allready using on your server. Just add them on the travel parameters. 
```
docker run <docker parameters> image ./InsurgencyServer-Linux-Shipping <travel-parameters>
```
I suggest, you create a ```restart.sh``` script and make it executable ```chmod +x```

```chmod +x restart.sh```

So you can just run the script with ```./restart.sh``` in your linux console

Full syntax example for Linux (docker), if you create a ```./restart.sh``` script. You can copy this 1:1 and only have to adjust the variables
```
#Set the container Name, every Container need an unique name (not the GameServer Name)
CNAME=is_myfirstserver

#Optional: if a container with the name sandstorm exist, it will be stopped and deleted
echo docker container will be stopped
docker stop $CNAME
echo docker container will be removed
docker rm $CNAME

#Path to folder where the configs are stored
CONFDIR=/home/gameadmin/insurgency

#Path to folder where the mods should be stored
MODS=/home/gameadmin/insurgency/Mods

#The image that should be used. Don't change it ;)
IMAGE=snickch/insurgencysandstormdedicatedserver:latest

#Set the Gameserver Name
HNAME="[Sn!ck[CH]] my First InsurgencySandstrom Gameserver"

#Set your tokens you get from the next two Pages
#https://gamestats.sandstorm.game/
#https://steamcommunity.com/dev/managegameservers App-ID:581320
GSLTTOKEN="XXXXXXXX"
GAMESTATSTOKEN="XXXXXXXX"

#Set your mutators for the server you will get it from https://mod.io
#You need an API-Key from https://mod.io/apikey/ which goes to the Engine.ini 
MUTATORS="XXX,YYY,ZZZ"

#Set the map which should be used on start (ModDownloadTravelTo makes sure your mods are started with the first map and the MaxPlayer you want)
MAP="Precinct?Scenario=Scenario_Precinct_Checkpoint_Security?lighting=day"

#Set maximal players
MAXPlayers=20

#Do not change the next 2 Variables
TMP="?MaxPlayers="
MODTRAVEL=$MAP$TMP$MAXPlayers

#RCON Config
RCONPORT=22722

#Here you can adjust the game ports (Multiple Server need unique Ports)
GAMEPORT=27102
QUERRYPORT=27131

#Here starts the script, you shouldn't change anything here, you can all do with the variables above
echo start docker container
docker run -d --restart=always --name $CNAME -p $GAMEPORT:$GAMEPORT/tcp -p $GAMEPORT:$GAMEPORT/udp -p $QUERRYPORT:$QUERRYPORT/tcp -p $QUERRYPORT:$QUERRYPORT/udp -p $RCONPORT:$RCONPORT -p $RCONPORT:$RCONPORT/udp \
--volume $CONFDIR/Game.ini:/home/steam/steamcmd/sandstorm/Insurgency/Saved/Config/LinuxServer/Game.ini:ro \
--volume $CONFDIR/Engine.ini:/home/steam/steamcmd/sandstorm/Insurgency/Saved/Config/LinuxServer/Engine.ini:ro \
--volume $CONFDIR/Admins.txt:/home/steam/steamcmd/sandstorm/Insurgency/Config/Server/Admins.txt:ro \
--volume $CONFDIR/Mods.txt:/home/steam/steamcmd/sandstorm/Insurgency/Config/Server/Mods.txt:ro \
--volume $CONFDIR/MapCycle.txt:/home/steam/steamcmd/sandstorm/Insurgency/Config/Server/MapCycle.txt:ro \
--volume $MODS/:/home/steam/steamcmd/sandstorm/Insurgency/Mods \
$IMAGE ./InsurgencyServer-Linux-Shipping -Port=$GAMEPORT -QueryPort=$QUERRYPORT \
-Mods \
-Rcon \
-Hostname="$HNAME" \
-Mutators=$MUTATORS \
-ModDownloadTravelTo=$MODTRAVEL \
-GSLTToken=$GSLTTOKEN  -GameStatsToken=$GAMESTATSTOKEN
```

If you don't use Mods you can just delete the two line with the ``` Mods.txt ``` and ```Mods``` folder. The same for ``` Engine.ini ``` or ``` Admin.txt ``` if you are not using it. On my host where docker is running, my path with the config is ``` /home/gameadmin/insurgency/... ``` . You have to replace this with the path you are using.



# Where to run the Docker Container
Read our [Wiki](https://github.com/SnickCH/InsurgencySandstormDedicatedServer/wiki/requirements) about this topic. Here are some basic information about the needed system requirements.

# How to get the image
Read our [Wiki](https://github.com/SnickCH/InsurgencySandstormDedicatedServer/wiki/docker) about this topic. 

# Update(s)
Read our [Wiki](https://github.com/SnickCH/InsurgencySandstormDedicatedServer/wiki/updates) about this topic. 

# Troubleshooting
Read our [Wiki](https://github.com/SnickCH/InsurgencySandstormDedicatedServer/wiki/Troubleshooting) about this topic. 

# Project status

This is my first docker project. If you need more information, find a bug or mistakes in the documentation it is very appreciated if you contact me. If you need support it would be the best if you create a new thread in the steam discussion for dedicated servers and first check that it is not an general server issue (related to steamcmd or the game). If you think it is a container related issue (based on my image) feel free to contact me.


## Timeline
30.December 2021 - n0ri; activate the wiki and remove the Wall of text from the Readme.
29.December 2021 - n0ri; Added the RCON with ISRT, Remove RCON from start script, added it to the ```Game.ini```
28.December 2021 - [n0ri](https://github.com/N0rimaki) joined as a contributor. Thank you very much for updating the documentation, all the testing and for your inputs. The documentation is now cleaner and easier to get startet. Now documented watchtower run command and beginner friendly info on how to manage the container
27.December 2021 - I made the script a bit easier (I will continue to make it easier and document a simpler version for watchtower)
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

