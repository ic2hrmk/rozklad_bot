# rozklad_bot
## Telegram's bot for requesting schedule from api.rozklad.kpi.ua
[Link in Telegram](https://telegram.me/rozklad_bot "Telegram link") or by name @rozklad_bot  
Author: Roman Kaporin  
It allows to get Information about **Kiev Polytech Institute** schedule from api.rozklad.kpi.ua by simple commands.

## Commands
There are three available commands:

>**_/start_** - Start command that shows all available commands.  
>**_/group_** *group [day - optional]* - returns schedule for university group.  
>Command has to parameters:
>* _group_ (**REQUIRED**) - name of group. It consists of literal code of group and it's number. For example: іс-32 or IS-32.
>* _day_   (**OPTIONAL**) - name of day from schedule. It should be provided in ukrainian as full name of the day (eg. _понеділок_) or in short form (eg. _пн_). In case if day wasn't provided, bot returns schedule for all week.
>
>_Day and group name are available to swap._  
**_/teacher_** *teacher lastname* - finds information about teacher by full name or just first characters of lastname.  
### Aliases
There were designed some aliases for ukrainian localization.
>**_/group_** can be replaced by  **_/група_**  
>**_/teacher_** can be replaced by  **_/викладач_**

##Examples
### Hello mode
![/start](https://s32.postimg.org/set3l5wyt/EErwSvcs-JY.jpg)

#### Schedule for all week
![/group](https://s31.postimg.org/hv6v5ihx7/W2m_Fy7_J6_ZHU.jpg)

#### Schedule for chosen day
![/group + day](https://s31.postimg.org/883cvsoxn/Oga7432xPEI.jpg)

#### Search teacher
![/group + day](https://s32.postimg.org/w9whnqg4l/9gfVx2QwlKs.jpg)

## TODO
* Add ability to check exams dates
* Deploy on server
