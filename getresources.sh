#!/bin/bash
#----------------------------------
#Colores
VERDE=$'\e[1;32m'
ROJO=$'\e[1;31m'
SINCOLOR=$'\e[0m'
#----------------------------------
# Otros
TITULO="Scritp Varios"
#----------------------------------
#toma la cantidad completa de columnas
#----------------------------------
COLUMNAS=$(tput cols)
TAMANO_TITULO=${#title}
MEDIO=$((($COLUMNAS + $TAMANO_TITULO) / 2))
#----------------------------------
# Imprime barras y titulo
printf "%${COLUMNAS}s" " " | tr " " "-"
printf "${SINCOLOR}${VERDE}%${MEDIO}s${SINCOLOR}\n" "${TITULO}"
printf "%${COLUMNAS}s" " " | tr " " "-"
#----------------------------------
timestamp=$(date +"%Y%m%d")
#----------------------------------
# Imprimiendo titulo
printf "\t\n"
printf "${SINCOLOR}${VERDE}\t%s\t%s\t%s\t%s${SINCOLOR}\n" "IP" "HOSTNAME" "%VAR" "HORA"
#----------------------------------
# Ciclo While que lee archivo separado con comas e injectado al final de la sentencia (done) (Dejar un espacio al final del archivo)
while IFS=, read IP USUARIO PASSWORD
do
#----------------------------------
# comando sshpass donde al final se ejectuan dos comandos
SALIDACOMANDO=$(sshpass -p $PASSWORD ssh -o StrictHostKeyChecking=no -o LogLevel=quiet -t $USUARIO@$IP 'df -h&&hostname&&date')
#----------------------------------
# Filtro del filesystem que se busca (OJO CAMBIAR EN GREP EL FILESYSTEM YA QUE BOOT ES SOLO PRUEBAS)
FILESYSTEM_number=$(echo $SALIDACOMANDO|grep -wE 'boot'|awk '{print $5}'|awk -F% '{print $1}')
FILESYSTEM_percent=$(echo $SALIDACOMANDO|grep -wE 'boot'|awk '{print $5}')
# Obtenemos el hostname del segundo comando
HOSTNAME=$(echo $SALIDACOMANDO|tail -2|head -1)
# Obtenemos la hora del segundo comando
HORA=$(echo $SALIDACOMANDO|tail -1|awk '{print $4}')
# Imprimimos lo que tenemos
printf "${SINCOLOR}\t%s\t\t%s${VERDE}\t%s${SINCOLOR}\t%s\n" ${IP} ${HOSTNAME} ${FILESYSTEM_percent} ${HORA}
#
#printf "\t%s\t%s\t%s\t%s\n" $IP $HOSTNAME $USUARIO $PASSWORD
#echo $SALIDACOMANDO
done < listahost.csv
#----------------------------------
printf "%${COLUMNAS}s" " " | tr " " "-"
#----------------------------------

#IP=192.168.242.146
#HOSTNAME=linuxhots
#USUARIO=root
#PASSWORD=usuario01