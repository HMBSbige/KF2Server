# Killing Floor 2 服务器
以下安装目录、运行参数请自行更改，不推荐使用root安装
## 手动安装
### 安装 steamcmd
`apt-get install steamcmd`

或者

```
apt-get install lib32gcc1
mkdir ~/Steam && cd ~/Steam
curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -
```

### 配置
`vim ~/ssconfig/updatekf.txt`
```
login anonymous
force_install_dir /home/root/games/killingfloor
app_update 232130 validate
quit
```

### 安装、升级kf服务器
```
~/Steam/steamcmd.sh +runscript ~/ssconfig/updatekf.txt
```

### 修改hosts（Weekly模式需要与谷歌的NTP同步）
`vim /etc/hosts`
```
203.107.6.88 time.google.com
```

### 放行端口
Port|Default|Protocol|What this option controls
-|-|-|-
Game Port|7777|UDP|This is the main port the game will send connections over
Query Port|27015|UDP|This port is used to communicate with the Steam Master Server
Web Admin|8080|TCP|This port is used to connect to your servers web admin page (if turned on)
Steam Port|20560|UDP
NTP Port|123|UDP|Weekly Outbreak Only - Internet time lookup to determine correct Outbreak

### 开启Web
`vim /home/root/games/killingfloor/KFGame/Config/KFWeb.ini`
```
[IpDrv.WebServer]
bEnabled=true
```

### 创意工坊订阅
`mkdir -p /home/root/games/killingfloor/KFGame/Cache`

`vim /home/root/games/killingfloor/KFGame/Config/LinuxServer-KFEngine.ini`
```
[OnlineSubsystemSteamworks.KFWorkshopSteamworks]
ServerSubscribedWorkshopItems=675314991//多人mod


```
**注意：多人 mod 需要手动移动到 BrewedPC 文件夹**

### 服务器设置
`vim /home/root/games/killingfloor/KFGame/Config/LinuxServer-KFGame.ini`
```
[Engine.AccessControl]
AdminPassword=123
GamePassword=lajigugu

[KFGame.KFGameInfo]
BannerLink=http://pic-1.bigecdn.cn/KF2Server.png
ServerMOTD=反正玩游戏就对了
WebsiteLink=https://jq.qq.com/?_wv=1027&k=5cMkpGg
ClanMotto=

[Engine.GameReplicationInfo]
ServerName=[CHN]反正玩游戏就对了
ShortName=CNjustPGs

```
**中文名要转化成 UTF16LEBOM 编码才不会有乱码**

### 关闭服务器接管（否则有密码也会被人自动匹配到接管）
`vim /home/root/games/killingfloor/KFGame/Config/LinuxServer-KFEngine.ini`
```
[Engine.GameEngine]
bUsedForTakeover=FALSE
```

### 运行
如果将 LinuxServer-KFGame.ini 转化成 UTF16LEBOM 每次运行会恢复默认设置，每次运行前手动
```
cp -rf ~/ssconfig/LinuxServer-KFGame.ini /home/root/games/killingfloor/KFGame/Config/LinuxServer-KFGame.ini
```
后台运行
```
nohup /home/root/games/killingfloor/Binaries/Win64/KFGameSteamServer.bin.x86_64 KF-TragicKingdom?adminpassword=123?Difficulty=2?GameLength=1?Mutator=KFMutator.KFMutator_MaxPlayersV2?MaxPlayers=12 &
```
#### 查看进程
```
jobs -l
ps -aux|grep killingfloor
```

## Docker

### 安装、运行
```
docker run -it --rm --name=kf2 \
-p 7777:7777/udp \
-p 27015:27015/udp \
-p 20560:20560/udp \
-p 8080:8080 \
-v /etc/hosts:/etc/hosts \
-v /home/root/games/killingfloor:/srv/kf2server \
hmbsbige/kf2server
```
**将 `/home/root/games/killingfloor` 修改成自己服务器的目录**

### 配置
#### 开启Web
`crudini --set /home/root/games/killingfloor/KFGame/Config/KFWeb.ini IpDrv.WebServer bEnabled true`

#### 创意工坊订阅
`crudini --set /home/root/games/killingfloor/KFGame/Config/LinuxServer-KFEngine.ini OnlineSubsystemSteamworks.KFWorkshopSteamworks ServerSubscribedWorkshopItems 675314991`

#### 修改 TickRate
```
crudini --set /home/root/games/killingfloor/KFGame/Config/LinuxServer-KFEngine.ini IpDrv.TcpNetDriver NetServerMaxTickRate 60

crudini --set /home/root/games/killingfloor/KFGame/Config/LinuxServer-KFEngine.ini IpDrv.TcpNetDriver LanServerMaxTickRate 60

crudini --set /home/root/games/killingfloor/KFGame/Config/LinuxServer-KFEngine.ini IpDrv.TcpNetDriver MaxClientRate 64000

crudini --set /home/root/games/killingfloor/KFGame/Config/LinuxServer-KFEngine.ini IpDrv.TcpNetDriver MaxInternetClientRate 64000
```

#### 服务器信息

##### 修改信息
```
crudini --set /home/root/games/killingfloor/KFGame/Config/LinuxServer-KFGame.ini Engine.AccessControl AdminPassword 123
crudini --set /home/root/games/killingfloor/KFGame/Config/LinuxServer-KFGame.ini Engine.AccessControl GamePassword lajigugu

crudini --set /home/root/games/killingfloor/KFGame/Config/LinuxServer-KFGame.ini KFGame.KFGameInfo ServerMOTD 反正玩游戏就对了
crudini --set /home/root/games/killingfloor/KFGame/Config/LinuxServer-KFGame.ini KFGame.KFGameInfo BannerLink http://pic-1.bigecdn.cn/KF2Server.png
crudini --set /home/root/games/killingfloor/KFGame/Config/LinuxServer-KFGame.ini KFGame.KFGameInfo WebsiteLink https://jq.qq.com/?_wv=1027&k=5cMkpGg
crudini --set /home/root/games/killingfloor/KFGame/Config/LinuxServer-KFGame.ini KFGame.KFGameInfo ClanMotto

crudini --set /home/root/games/killingfloor/KFGame/Config/LinuxServer-KFGame.ini Engine.GameReplicationInfo ServerName [CHN]反正玩游戏就对了
crudini --set /home/root/games/killingfloor/KFGame/Config/LinuxServer-KFGame.ini Engine.GameReplicationInfo ShortName CNjustPGs
```

##### 转换编码 UTF16LEBOM
```
iconv -f utf8 -t UTF-16LE /home/root/games/killingfloor/KFGame/Config/LinuxServer-KFGame.ini > /home/root/games/killingfloor/KFGame/Config/temp.ini
sed -i '1s/^\(\xff\xfe\)\?/\xff\xfe/' /home/root/games/killingfloor/KFGame/Config/temp.ini
mv /home/root/games/killingfloor/KFGame/Config/temp.ini /home/root/games/killingfloor/KFGame/Config/LinuxServer-KFGame.ini
```

#### 关闭服务器接管（否则有密码也会被人自动匹配到接管）
```
crudini --set /home/root/games/killingfloor/KFGame/Config/LinuxServer-KFEngine.ini Engine.GameEngine bUsedForTakeover FALSE
```

### 更新
`docker restart kf2`
