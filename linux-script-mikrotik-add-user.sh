#!/bin/bash
#vypne syslog  --- pozor pokud timhle zpusobem nalejete hesla do Mikrotiku od v.5.20 <  tak se heslo objevi ve fultextu v LOGU NA rsyslogu i na syslogn-ng  !!! proto shazovat  !!!! 
service rsyslog stop
# je treba nainstalovat "sshpass" balicek na komunikaci do linuxu :} sshpass -y).
#LOGIN=admin  ###semka login usera  co ma prava pro zapis  a cteni  primo ve fulltextu nebo nahazet do souboru pro cteni !!!! 
LOGIN=admin  #pozitame tedy ze SSH klient je admin --- ALE POUZIVEJTE KLICE !!!!!!!!!!   
##############################TOHLE JE FULLTEXT POUZIVEJTE SSH KLIC !!!!!!!!! ##############
#PASSWORD="SEM_NAPISTE_HESLO" #semka ve full textu kdz by byl problem jde udelat do souboru PF primo heslo a pak to cte odsud  "connet-password"
PASSWORD=$(awk 'NR == 2' connect-password) #semka kdyz by se cetlo heslo ze souboru jinak zakomentovat ! "connect-password"  heslo se nacita z radku 2###  ( A ZNOVA POUZIVEJTE KLIC !!!!! :P ) 
#promene na nacitano hesel ze souboru ## 'adduserpass' ##
jmeno1=$(awk 'NR == 2' adduserpass) # v tomto fajlu to nacita radek 2 ##
heslo1=$(awk 'NR == 4' adduserpass) # v tomto fajlu to nacita radek 4 ##
jmeno2=$(awk 'NR == 6' adduserpass) # v tomto fajlu to nacita radek 6 ##
heslo2=$(awk 'NR == 8' adduserpass) # v tomto fajlu to nacita radek 8 ##
jmeno3=$(awk 'NR == 10' adduserpass) # v tomto fajlu to nacita radek 10 ##
heslo3=$(awk 'NR == 12' adduserpass) # v tomto fajlu to nacita radek 12 ##
jmeno4=$(awk 'NR == 14' adduserpass) # v tomto fajlu to nacita radek 14 ##
heslo4=$(awk 'NR == 16' adduserpass) # v tomto fajlu to nacita radek 16 ##
jmeno5=$(awk 'NR == 18' adduserpass) # v tomto fajlu to nacita radek 18 ##
heslo5=$(awk 'NR == 20' adduserpass) # v tomto fajlu to nacita radek 20 ##
#SSHPORT=22   ### semka staticky port SSH #### 
SSHPORT=22
#SSHPORT=23456  ### Porty muzou byt samozrejme ruzne :)     
#FTPPORT=21021  #nn FTP nepouzivat rozmrda to vse 
IPLISTFILE=/test/mikrotik-ip-list-rs #tady se zadavaji IP do kterejch sype pak mikrotik data soubor "mikrotik-list-pass"  POZOR at je ta cesta DOBRE !!!   :) 
LOGFILE=/test/logrspass/logrspass.log #proste log
index=0                      ##### odsud promene nacitani IP adres odkud se maji nacitat jednotlive Mikrotiky za sebou :) 
while read line ; do 
IPLIST[$index]="$line"
index=$(($index+1))
done < $IPLISTFILE
echo ${iplist[@]}
for (( i=0; i<${#IPLIST[@]}; i++ ));
do
HOSTIP=${IPLIST[$i]}
echo  >>$LOGFILE
echo $HOSTIP `date` rok `date +%Y` mesic `date +%m` den `date +%d` v `date +%H`:`date +%M`:`date +%S`>>$LOGFILE
#uzivatel1
sshpass -p $PASSWORD ssh $LOGIN@$HOSTIP -p $SSHPORT -o StrictHostKeyChecking=no 'user add group=full name='$jmeno1 'password='$heslo1 >>$LOGFILE  2>>$LOGFILE
#uzivatel2
sshpass -p $PASSWORD ssh $LOGIN@$HOSTIP -p $SSHPORT -o StrictHostKeyChecking=no 'user add group=full name='$jmeno2 'password='$heslo2 >>$LOGFILE  2>>$LOGFILE
#uzivatel3
sshpass -p $PASSWORD ssh $LOGIN@$HOSTIP -p $SSHPORT -o StrictHostKeyChecking=no 'user add group=full name='$jmeno3 'password='$heslo3 >>$LOGFILE  2>>$LOGFILE
#uzivate4
sshpass -p $PASSWORD ssh $LOGIN@$HOSTIP -p $SSHPORT -o StrictHostKeyChecking=no 'user add group=full name='$jmeno4 'password='$heslo4 >>$LOGFILE  2>>$LOGFILE
#uzivatel5
sshpass -p $PASSWORD ssh $LOGIN@$HOSTIP -p $SSHPORT -o StrictHostKeyChecking=no 'user add group=full name='$jmeno5 'password='$heslo5 >>$LOGFILE  2>>$LOGFILE
###############VYPNUTI-UCTU!!!!################
#ADMIN vypina ADMINA !!!     POZOR Tohle je rovnak na vohybak  zakaze ADMINA pokud jste predtim neco posrali je to pravdepodobne to posledni co udelate :-DDDDD 
sshpass -p $PASSWORD ssh $LOGIN@$HOSTIP -p $SSHPORT -o StrictHostKeyChecking=no 'user disable admin' >>$LOGFILE  2>>$LOGFILE
###########zmena hesla##############
#EDIT USER --- Nepridava ale edituje  UZIVATELE1 az 5  :) 
#sshpass -p $PASSWORD ssh $LOGIN@$HOSTIP -p $SSHPORT -o StrictHostKeyChecking=no 'user set'$jmeno1 'password='$heslo1 >>$LOGFILE  2>>$LOGFILE
#sshpass -p $PASSWORD ssh $LOGIN@$HOSTIP -p $SSHPORT -o StrictHostKeyChecking=no 'user set'$jmeno2 'password='$heslo2 >>$LOGFILE  2>>$LOGFILE
#sshpass -p $PASSWORD ssh $LOGIN@$HOSTIP -p $SSHPORT -o StrictHostKeyChecking=no 'user set'$jmeno3 'password='$heslo3 >>$LOGFILE  2>>$LOGFILE
#sshpass -p $PASSWORD ssh $LOGIN@$HOSTIP -p $SSHPORT -o StrictHostKeyChecking=no 'user set'$jmeno4 'password='$heslo4 >>$LOGFILE  2>>$LOGFILE
#sshpass -p $PASSWORD ssh $LOGIN@$HOSTIP -p $SSHPORT -o StrictHostKeyChecking=no 'user set'$jmeno5 'password='$heslo5 >>$LOGFILE  2>>$LOGFILE
done
#vypne syslog
service rsyslog restart
####nedivte se ze je to postene vzdy jako jedna samostatna davka a ne jako retezec vsechno ( navazuje pokazde nove spojeni ) od ROS 6.43.11  je to dropovane a dela to kokotoni. 
