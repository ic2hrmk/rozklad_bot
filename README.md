# rozklad_bot
### Telegram's bot for requesting schedule from api.rozklad.kpi.ua
[Link in Telegram](tg://resolve?domain=rozklad_bot "Telegram link")
..or
by name @rozklad_bot
Authors: Roman Kaporin
It allows to get Information about KPI schedule from api.rozklad.kpi.ua by simple commands.

### Commands
**_/start_** - Start command that shows all available commands
**_/group_** *group [day - optional]* - Command has to parameters:
..* _group_ **REQUIRED** - Name of group. It consists of literal code of group and it's number. For example: іс-32 or IS-32.
..* _group_ **OPTIONAL** - Name of day from schedule. It should be provided in ukrainian as full name of the day (eg. _понеділок_) or in short form (_пн_). In case if day wasn't provided, bot returns schedule for all week.

_Day and group name are able to swap._   

#### Hello and help modes
![/start](https://s31.postimg.org/5s1jhy6uz/Qn_Lx_H4n5_Lz0.jpg)

#### Schedule for all week
![Booking](https://s31.postimg.org/hv6v5ihx7/W2m_Fy7_J6_ZHU.jpg)

#### Schedule for chosen day
![Bill](https://s31.postimg.org/883cvsoxn/Oga7432xPEI.jpg)
