#Set the container Name, every Container need an unique name (not the GameServer Name)
CNAME=myfirstserver

#Optional: if a container with the name sandstorm exist, it will be stopped and deleted
echo docker container will be stopped
docker stop $CNAME
echo docker container will be removed
docker rm $CNAME

#Path to folder where the configs are stored
CONFDIR=/home/gameadmin/insurgency/survival

#Path to folder where the mods should be stored
MODS=/home/gameadmin/insurgency/Mods

#The image that should be used. Don't change it ;)
IMAGE=snickch/insurgencysandstormdedicatedserver:latest

#Set your tokens you get from the next two Pages
#https://gamestats.sandstorm.game/
#https://steamcommunity.com/dev/managegameservers
GSLTTOKEN="XXXXXXXXXXX"
GAMESTATSTOKEN="YYYYYYYYYYY"

#Set your mutators for the server you will get it from https://mod.io
#You need an API-Key from https://mod.io/apikey/ which goes to the GameUserSettings.ini (Engine.ini is depreciated) 
MUTATORS="Medic,ImprovedAI,ScaleSurvival,Vampirism,sBomber,PrintCount,JoinLeaveMessage,MoreAmmo"

#Set the map which should be used on start (ModDownloadTravelTo makes sure your mods are started with the first map and the MaxPlayer you want)
MODTRAVEL="Gap?Scenario=Scenario_Gap_Survival?lighting=day"

#RCON Config
RCONPORT=29093

#Here you can adjust the game ports (Multiple Server need own distinct Ports)
GAMEPORT=27103
QUERRYPORT=27133

#Here starts the script, you shouldn't change anything here, you can all do with the variables above
echo start docker container
docker run -d --restart=always --name $CNAME -p $GAMEPORT:$GAMEPORT/tcp -p $GAMEPORT:$GAMEPORT/udp -p $QUERRYPORT:$QUERRYPORT/tcp -p $QUERRYPORT:$QUERRYPORT/udp -p $RCONPORT:$RCONPORT -p $RCONPORT:$RCONPORT/udp \
--volume $CONFDIR/Game.ini:/home/steam/steamcmd/sandstorm/Insurgency/Saved/Config/LinuxServer/Game.ini:ro \
--volume $CONFDIR/GameUserSettings.ini:/home/steam/steamcmd/sandstorm/Insurgency/Saved/Config/LinuxServer/GameUserSettings.ini:ro \
--volume $CONFDIR/Admins.txt:/home/steam/steamcmd/sandstorm/Insurgency/Config/Server/Admins.txt:ro \
--volume $CONFDIR/Mods.txt:/home/steam/steamcmd/sandstorm/Insurgency/Config/Server/Mods.txt:ro \
--volume $CONFDIR/MapCycle.txt:/home/steam/steamcmd/sandstorm/Insurgency/Config/Server/MapCycle.txt:ro \
--volume $MODS/:/home/steam/steamcmd/sandstorm/Insurgency/Mods \
$IMAGE ./InsurgencyServer-Linux-Shipping -Port=$GAMEPORT -QueryPort=$QUERRYPORT \
-Mods \
-Rcon \
-Mutators=$MUTATORS \
-ModDownloadTravelTo=$MODTRAVEL \
-GSLTToken=$GSLTTOKEN  -GameStatsToken=$GAMESTATSTOKEN
