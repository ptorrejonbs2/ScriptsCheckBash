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
printf "\t\n"
while IFS=, read IP HOSTNAME USUARIO PASSWORD
do
printf "${SINCOLOR}${VERDE}\t%s\t%s\t%s\t%s${SINCOLOR}\n" ${IP} ${HOSTNAME} ${USUARIO} ${PASSWORD}
done < listahost.csv
#----------------------------------
printf "%${COLUMNAS}s" " " | tr " " "-"
#----------------------------------
