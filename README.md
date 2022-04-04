![](https://github.com/SnickCH/InsurgencySandstormDedicatedServer/blob/master/sandstorm-logo.png)
[![DockerHub Badge](http://dockeri.co/image/snickch/insurgencysandstormdedicatedserver)](https://hub.docker.com/r/snickch/insurgencysandstormdedicatedserver/)

## Insurgency Sandstorm – customisable dedicated server 🎮 🐳
This repository contains a docker image with a dedicated server for Insurgency Sandstorm (vanilla) that you can fully customise to your need for coop and PVP servers. 

Key features 
- Daily updated image
- Ready to use (no additonal downloads needed for vanilla server, only mods download)
- Mody are fully supported and working
- Scripts for easy starts, automated image update (*1) and game config examples provided
- Project with acive maintainers (N0rimaki, Snick) if you have questions or suggestions
- Nothing to update inside the container (*1)
- Update process in the focus: new game server should be up & running <1min (*1)

(*1) The container way: dont update anything inside the container. Just use the newest image. Therefore you don't have to worry about failed updates or missing libraries etc., we do the work for you. 

If you have any questions or suggetions please feel free open an [issue](https://github.com/SnickCH/InsurgencySandstormDedicatedServer/issues).
shortened URL to the Project: https://git.io/Jyujj



Here you can check the last update on the container (yes, the project is still maintained) https://hub.docker.com/r/snickch/insurgencysandstormdedicatedserver

---

# Quick Start - tl;dr 

All you need to know for the quick start, read the rest another day. It's okay!

### 1. You need a Linux Host for the docker container

For this example the Linux-user ist _gameadmin_ and the game-root-folder is _/home/gameadmin/insurgeny/_   
Server [requirements](#requirements)   


### 2. Copy the Example
 
Copy all files from the [Example](https://github.com/SnickCH/InsurgencySandstormDedicatedServer/tree/master/Examples/Survival_Mods) in your home folder.

_/home/gameadmin/insurgeny/survival_

### 3. Make the script executable 

Use  ```chmod +x``` on _start_survival.sh_   
```console
chmod +x start_survival.sh
```

### 4. Change permissions

You will need to adjust the Permissions 

replace user and usergroup with your setup. Normaly both are just your username. If your user is "gameadmin" you use "gameadmin:gameadmin"

```console 
chown user:usergroup Game.ini Mods GameUserSettings.ini Admins.txt Mods.txt MapCycle.txt 
```

### 5. Change the values of the variables

Where to get the [Tokens](#tokens)

in _[start_survival.sh](https://github.com/SnickCH/InsurgencySandstormDedicatedServer/blob/master/Examples/Survival_Mods/start_survival.sh)_   
```GSLTTOKEN```   
```GAMESTATSTOKEN```  
```GAMEPORT```   
```QUERRYPORT```

in _[GameUserSettings.ini](https://github.com/SnickCH/InsurgencySandstormDedicatedServer/blob/master/Examples/Survival_Mods/GameUserSettings.ini)_   
mod.io API-Key

in _[Game.ini](https://github.com/SnickCH/InsurgencySandstormDedicatedServer/blob/master/Examples/Survival_Mods/Game.ini)_   
```Password``` for Rcon   
```ListenPort``` for Rcon   
```ServerHostname```   


### 6. make a Port Fowarding

Setup a Port Fowarding for these Ports ```GAMEPORT``` ```QUERRYPORT``` on your Router/Firewall

### 7. Start the Server

Type the command in the console to start the server. [Troubleshooting](#Troubleshooting)
```console 
. start_survival.sh
```
---
<a name="requirements"></a>
## Where to run the Docker Container 🐳

We recommand a Linux Server eg. Ubuntu Server. 

## General Docker info and commands for beginners

To make it a bit easier for you to start with Docker, we made a few examples on how to work with the containers

Get logs from the container (example: on watchtower you can check the next run)
"docker logs containername" gives you the output on what is going on inside the container named "watchtower"
```console
docker logs watchtower
```
This should give you something similar to 
```console
time="2021-12-28T10:46:28Z" level=info msg="Watchtower 1.3.0\nUsing no notifications\nChecking all containers (except explicitly disabled with label)\nScheduling first run: 2021-12-29 10:00:00 +0000 UTC\nNote that the first check will be performed in 23 hours, 13 minutes, 31 seconds"
```

For the sandstorm server (named sandstorm) with many logs you can limit it to the last 20 lines

```console
docker logs --tail=20 sandstorm
```

Stop a container named "sandstorm"
```console
docker stop sandstorm
```

Delete a stopped container named "sandstorm"
```console
docker rm sandstorm
```

show the status of all containers
```console
docker ps
```

show the LIVE stats of all containers (CPU, Memory, Traffic,...)
```console
docker stats
```

show all docker images that are localy available. Here you get the ImageID for the next command
```console
docker images -a
```

Delete a specific docker image (not needed with watchtower)
```console
docker image rm ImageID
```

The following parameter which is used here makes sure, the container is always started on server reboot where the container is running and also restarts the container if inside the container the gamen crashes or shutsdown

```console
--restart=always
```


## How to get the docker image

Run this command to download the image. The script we provide will download it anyway if it's not exist.

```console 
docker pull snickch/insurgencysandstormdedicatedserver
```

## Update(s)

Autobuilds will run on daily base for latest. If there is a server update from Insurgency Sandstorm I will trigger the build earlier if possible.

The idea is to use this the “container way” to just replace the container instead of updating anything inside the container. Your data will be static and will be loaded in the new container (if configured correctly with the ``` docker run``` command). This makes it even faster for you. You can pull the newest image and during the download your “old” container is still running. Then you can just recreate the container and that’s it. It works perfectly with watchtower. I use the watchtower image from containrrr/watchtower. 
	
Example of my docker-compose.yml for watchtower. Make sure you use the correct "schedule" parameters. In this example it will always at 8am check for new images, download them (if available) and then restart the container. Be aware that the container will be forcibly shutdown - if players are on the server they might not find it very amazing ;)

This is a single command that starts watchtower. It will check for new images, download them (if available) and then restart all containers that have new images available. In my example this is done at 21:11:10 (9pm,11min and 10seconds) to show you how to use the schedule parameter. The schedule parameter is the only thing you should change, use the rest 1:1.

> **_NOTE:_**  The Image has about 3.9GB Make sure your download plan is capable of this.

```console
docker run -d --restart=always --name watchtower --volume /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower --schedule="10 11 21 * * *" --cleanup --rolling-restart --include-stopped --revive-stopped
```


This is the docker-compose.yml file, if you like to use docker-compose instad of docker run. If you use the above command to run watchtower, you don't need this yml file. If you don't know what docker-compose is or how to use it, stick to the above command to run watchtower

```yaml
version: "3" 
services:
   watchtower:
    image: containrrr/watchtower
    restart: always
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    command: --schedule "10 11 21 * * *" --cleanup --rolling-restart --include-stopped --revive-stopped
    labels:
      - "com.centurylinklabs.watchtower.enable=true"
```
The Watchtower documentation from containrrr: https://containrrr.dev/watchtower/arguments/

Cron Job scheduler information for your time: https://pkg.go.dev/github.com/robfig/cron@v1.2.0#hdr-CRON_Expression_Format

The script above run at 21:11:10 every day in the whole year (9pm,11min and 10seconds).

|Seconds|Minutes|Hours|Day of month|Month|Day of week|
|-------|-------|-----|------------|-----|-----------|
|10|11|21|*|*|*|
	

## Game realted  topics

<a name="tokens"></a>
### Game Tokens

You need 3 Tokens to run the Server properly and to find it in the Community Server and gain XP.
   
```GSLTTOKEN```   
```GAMESTATSTOKEN```  
```AccessToken```   


##### GSLTTOKEN

This Token comes from Steam and verify you as Insurgency Sandstorm Server   
in _[start_survival.sh](https://github.com/SnickCH/InsurgencySandstormDedicatedServer/blob/master/Examples/Survival_Mods/start_survival.sh)_   
https://steamcommunity.com/dev/managegameservers   
App-ID:581320   
```GSLTTOKEN="XXXXXXXX"```

##### GAMESTATSTOKEN
This Token enables official XP gain     
in _[start_survival.sh](https://github.com/SnickCH/InsurgencySandstormDedicatedServer/blob/master/Examples/Survival_Mods/start_survival.sh)_   
https://gamestats.sandstorm.game/    
```GAMESTATSTOKEN="XXXXXXXX"```

##### MOD.IO

For running custom Mods or Maps.   
in _[GameUserSettings.ini](https://github.com/SnickCH/InsurgencySandstormDedicatedServer/blob/master/Examples/Survival_Mods/GameUserSettings.ini)_    
https://mod.io/apikey/   
```AccessToken=XXXXXXXXXXXXXXX```    


### Examples

You can use these Examples for running different Game Modes.

* [Survival with Mods](https://github.com/SnickCH/InsurgencySandstormDedicatedServer/tree/master/Examples/Survival_Mods)

### RCON

With Rcon you can remote manage your server, change maps, ban user, etc.
We recommend this tool.  
[ISRT on GitHub](https://github.com/olli-e/ISRT) or [ISRT Website](https://www.isrt.info/)
Add this to your ``` Game.ini ``` and change the ports, add a password. Make sure that this is the same port (rcon) as in the script (variable: ```RCONPORT```).
```ini
[Rcon]
bEnabled=True
Password=superStrongPassword
ListenPort=22722
bAllowConsoleCommands=True
```
### Demo Servers that use our images

Feel free to test it

* [AUT] n0ri's Leberkas-Palace #1\<Checkpoint Mods>
* [AUT] n0ri's Leberkas-Palace #2\<Outpost Mods>
* [AUT] n0ri's Leberkas-Palace #3\<Survival Mods>
* [AUT] n0ri's Leberkas-Palace #4\<Survival Vanilla>
* [Hardcore ISMC] DustinDerDachs HardAI GERMAN lessMods [Event]
* [Hardcore ISMC] DustinDerDachs HardcoreAI GERMAN manyMods [Extra]
* [ISMC] DustinDerDachs GERMAN lessMods [PvP]

You use our image and want your server listed here? contact us :)
### Files
#### Game.ini

**Servername in Game Search**  

```ini
[/Script/Insurgency.INSGameMode]
ServerHostname="[sn!ck[CH]] my first Insurgency Server"
Rulesets = ""
```
**MaxPlayers for the Server**  

```ini
[/Script/Engine.GameSession]
MaxPlayers=20
MaxSpectators=0
```

 #### ~~Engine.ini~~

~~Here goes the mod.io API-Key and some mods (Medic Demo) requires some additional setup here.~~

#### GameUserSettings.ini

NWI Changed it from the ```Engine.ini``` to the ```GameUserSettings.ini```.
Here goes the mod.io API-Key and some mods (Medic Demo) requires some additional setup here.

#### Mods.txt

In this File you need to add the Mod-IDs from https://mod.io
Some mods require Mutators add to the ```MUTATORS=``` in _[start_survival.sh](https://github.com/SnickCH/InsurgencySandstormDedicatedServer/blob/master/Examples/Survival_Mods/start_survival.sh)_ 

#### Admins.txt

Enter the [SteamID64](https://www.steamidfinder.com/) of the Steam Account you want to be in-Game Admin.

#### MapCycle.txt

Change the Maps you wanna play here. If you add a new Map by mod, you need to enter it here as well.

---

## Troubleshooting

### File and Folder permissions

If your server doesn't start with Mods or without settings, make sure that all the files (```Game.ini``` etc.) and the "Mods" Folder have the correct user permission. You can change the permissions with the ```chwon``` command. Make sure you replace USER and GROUP with your information.

```console
chown USER:GROUP Game.ini Mods GameUserSettings.ini Admins.txt Mods.txt MapCycle.txt
```

Example how it should look, if your user is debian with the group debian

```console
-rw-r--r-- 1 debian debian   87 Dec 13 17:10 Admins.txt
-rw-r--r-- 1 debian debian 1.8K Dec 14 15:20 GameUserSettings.ini
-rw-r--r-- 1 debian debian  22K Dec 21 19:12 Game.ini
-rw-r--r-- 1 debian debian 5.5K Dec 14 17:22 MapCycle.txt
-rw-r--r-- 1 debian debian   82 Dec 14 17:22 Mods.txt
```

How it looked when it was wrong, because I created the Admins.txt with root
```console
-rw-r--r-- 1 root   root     87 Dec 13 17:10 Admins.txt
-rw-r--r-- 1 debian debian 1.8K Dec 14 15:20 GameUserSettings.ini
-rw-r--r-- 1 debian debian  22K Dec 21 19:12 Game.ini
-rw-r--r-- 1 debian debian 5.5K Dec 14 17:22 MapCycle.txt
-rw-r--r-- 1 debian debian   82 Dec 14 17:22 Mods.txt
```

### Filesize Issue    

You run out of space on your Ubuntu Server but you gave it 40GB space?
Maybe there ist some bad LVM setting. This worked on my machine (20.04.3).    
[Ubuntu Server 18.04 LVM out of space with improper default partitioning](https://askubuntu.com/a/1117523)
 
### Generic ```command not found``` Issue

if your message looks like this, there could be an issue with the start file itself and the linebreaks in it.

```console
gameadmin@isdsdocker:~/insurgency$ . start_deathmatch.sh
docker container will be stopped
Error response from daemon: No such container: isd_deathmatch
docker container will be removed
Error: No such container: isd_test2
start docker container
"docker run" requires at least 1 argument.
See 'docker run --help'.

Usage:  docker run [OPTIONS] IMAGE [COMMAND] [ARG...]

Run a command in a new container
--volume: command not found
--volume: command not found
--volume: command not found
--volume: command not found
--volume: command not found
--volume: command not found
: No such file or directoryndstormdedicatedserver:latest
-Rcon: command not found
-Mods: command not found
: command not found
: command not foundo=Ministry?Scenario=Scenario_Ministry_Checkpoint_Security?lighting=day
: command not foundD2594252345243527BCB34524A46
```
As you see below the file which doesn't work has [CRLF](https://en.wikipedia.org/wiki/Newline#Representation) in it.

```console
gameadmin@isdsdocker:~/insurgency$ file start_deathmatch.sh start_checkpoint.sh
start_deathmatch.sh: ASCII text, with CRLF line terminators
start_checkpoint.sh: ASCII text
```

Create a new file with ```nano newfilename.sh ``` and copy the content from old one in this.


---

## Project status

This is my first docker project. If you need more information, find a bug or mistakes in the documentation it is very appreciated if you contact me. If you need support it would be the best if you create a new thread in the steam discussion for dedicated servers and first check that it is not an general server issue (related to steamcmd or the game). If you think it is a container related issue (based on my image) feel free to contact me.


### Timeline
04. April 2022 - n0ri added the new configuration for the GameUserSettings.ini files (NWI changed this in the background). Make sure you update your .ini files and start scripts for your servers
07.January 2022 - n0ri; Add example files, make Quick Start - tl;dr   
02.January 2022 - Snick; Happy new year! We are working on a easier to read documentation and published the first version. 
29.December 2021 - n0ri; Added the RCON with ISRT, Remove RCON from start script, added it to the ```Game.ini```.  
28.December 2021 - [n0ri](https://github.com/N0rimaki) joined as a contributor. Thank you very much for updating the documentation, all the testing and for your inputs. The documentation is now cleaner and easier to get startet. Now documented watchtower run command and beginner friendly info on how to manage the container.  
27.December 2021 - I made the script a bit easier (I will continue to make it easier and document a simpler version for watchtower).  
19.December 2021 - Updated the docker-compose.yml for watchtower.  
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
