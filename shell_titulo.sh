#!/bin/bash
VERDE=$'\e[1;32m'
ROJO=$'\e[1;31m'
SINCOLOR=$'\e[0m'
TITULO="Welcome to My Super Script"
#toma la cantidad completa de columnas
COLUMNAS=$(tput cols)
TAMANO_TITULO=${#title}
MEDIO=$((($COLUMNAS + $TAMANO_TITULO) / 2))
printf "%${COLUMNAS}s" " " | tr " " "-"
printf "${SINCOLOR}${VERDE}%${MEDIO}s${SINCOLOR}\n" "${TITULO}"
printf "%${COLUMNAS}s" " " | tr " " "-"