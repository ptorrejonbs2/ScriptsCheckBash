#!/bin/bash
#----------------------------------
# V1.0 | 19/05/2020 | Pablo Torrejón
#----------------------------------
#Variable donde se ubica lista de IP a leer
LISTA_DE_IP=/BS2/CheckResources/listahost.csv
#IP=172.16.91.123
#USUARIO=ptorrej1
#PASSWORD=
#----------------------------------
#Colores
VERDE=$'\e[1;32m'
ROJO=$'\e[1;31m'
SINCOLOR=$'\e[0m'
#----------------------------------
# Otros
TITULO="Scritp Revisión /VAR Y /OPT EN HOSTS"
#----------------------------------
#toma la cantidad completa de columnas
#----------------------------------
COLUMNAS=$(tput cols)
TAMANO_TITULO=${#TITULO}
MEDIO=$((($COLUMNAS + $TAMANO_TITULO) / 2))
#----------------------------------
# Imprime barras y titulo
printf "%${COLUMNAS}s" " " | tr " " "-"
printf "${SINCOLOR}${VERDE}%${MEDIO}s${SINCOLOR}\n" "${TITULO}"
printf "%${COLUMNAS}s" " " | tr " " "-"
#----------------------------------
#timestamp=$(date +"%Y%m%d")
#----------------------------------
#Titulo Validación de usuario
TITULO2="----INGRESAR USUARIO----"
printf "${SINCOLOR}${ROJO}%s${SINCOLOR}\n" "${TITULO2}"
#Validación Nombre Usuario
read -p "Ingrese usuario IPA: " USUARIO
read -sp "Ingrese contraseña IPA: " PASSWORD
echo -e "\nSi escribió mal su usuario o contraseña es posible que se bloquee en el paso siguiente"
read -p "Realmente desea Continuar? (S) " Confirmation
if [[ "$Confirmation" != "S" ]];then
  echo -e "Valor diferente de 'Y'. El programa termina";
  exit 1
fi
printf "%${COLUMNAS}s" " " | tr " " "-"
#----------------------------------
# Imprimiendo titulo
printf "\t\n"
printf "${SINCOLOR}${VERDE}\t%5s\t\t%s\t%s\t%s\t%5s${SINCOLOR}\n" "IP" "HOSTNAME" "%VAR" "%OPT" "HORA"
#----------------------------------
# Ciclo While que lee archivo separado con comas e injectado al final de la sentencia (done) (Dejar un espacio al final del archivo)
    while IFS="" read IP
    do
        #Valida si IP tiene información sino evita imprimir por pantalla
        if [ ! -z "$IP" ]
        then
         #----------------EJECUTANDO CONSULTAS AL HOST------------------
         #Comando sshpass donde al final se ejectuan dos comandos
         SALIDACOMANDO=$(sshpass -p $PASSWORD ssh -no StrictHostKeyChecking=no -o LogLevel=quiet -t $USUARIO@$IP 'hostname -s&&date&&df -h' 2> /dev/null)
            #Valida si salida de comando entrega valores, sino indica error y hay que revisar IPA
            if [ ! -z "$SALIDACOMANDO" ]
            then
                #----------------DEFINIENDO VARIABLES DESDE SALIDA------------------
                # Validando la salida segun tipo (da /var cuando es RHEL 6.4 y si es superior a 7 da un numero)
                TIPOSALIDA=$(echo "$SALIDACOMANDO"|grep /var|awk '{print $5}')
                        if [ "$TIPOSALIDA" == "/var" ]; then
                            VAR_FILESYSTEM_size=$(echo "$SALIDACOMANDO"|grep /var|awk '{print $3}')
                            VAR_FILESYSTEM_number=$(echo "$SALIDACOMANDO"|grep /var|awk '{print $4}'|awk -F% '{print $1}')
                            VAR_FILESYSTEM_percent=$(echo "$SALIDACOMANDO"|grep /var|awk '{print $4}')
                            OPT_FILESYSTEM_size=$(echo "$SALIDACOMANDO"|grep /opt|awk '{print $3}')
                            OPT_FILESYSTEM_number=$(echo "$SALIDACOMANDO"|grep /opt|awk '{print $4}'|awk -F% '{print $1}')
                            OPT_FILESYSTEM_percent=$(echo "$SALIDACOMANDO"|grep /opt|awk '{print $4}')
                        else
                            VAR_FILESYSTEM_size=$(echo "$SALIDACOMANDO"|grep /var|awk '{print $4}')
                            VAR_FILESYSTEM_number=$(echo "$SALIDACOMANDO"|grep /var|awk '{print $5}'|awk -F% '{print $1}')
                            VAR_FILESYSTEM_percent=$(echo "$SALIDACOMANDO"|grep /var|awk '{print $5}')
                            OPT_FILESYSTEM_size=$(echo "$SALIDACOMANDO"|grep /opt|awk '{print $4}')
                            OPT_FILESYSTEM_number=$(echo "$SALIDACOMANDO"|grep /opt|awk '{print $5}'|awk -F% '{print $1}')
                            OPT_FILESYSTEM_percent=$(echo "$SALIDACOMANDO"|grep /opt|awk '{print $5}')
                        fi
                #Obtenemos el hostname del segundo comando
                HOSTNAME=$(echo "$SALIDACOMANDO"|head -2|head -1)
                #Obtenemos la hora del segundo comando
                RELOJ=$(echo "$SALIDACOMANDO"|head -2|tail -1|awk '{print $4}')
                HORA=$(echo "$SALIDACOMANDO"|head -2|tail -1|awk '{print $4}'|awk -F: '{print $1}')
                MINUTOS=$(echo "$SALIDACOMANDO"|head -2|tail -1|awk '{print $4}'|awk -F: '{print $2}')
                SEGUNDOS=$(echo "$SALIDACOMANDO"|head -2|tail -1|awk '{print $4}'|awk -F: '{print $3}')
                #---------------------IMPRIMIENDO SALIDA-------------
                #Imprimimos lo que tenemos segun condicionantes de tamaños
                #Primer condicionante es el tamaño de /var
                if [ "$VAR_FILESYSTEM_number" -gt 80 ]
                then
                    #Es Mayor /var a 80%, entonces color rojo
                    #Segunda condicionante tamaño de /opt
                    if [ "$OPT_FILESYSTEM_number" -gt 80 ]
                    then
                    #Es Mayor /opt a 80%, entonces color rojo
                    printf "${SINCOLOR}\t%s\t%s${ROJO}\t%s${SINCOLOR}${ROJO}\t%s${SINCOLOR}\t%s\n" ${IP} ${HOSTNAME} ${VAR_FILESYSTEM_percent} ${OPT_FILESYSTEM_percent} ${RELOJ}
                    else
                    #Es Menor /opt a 80%, entonces color verde
                    printf "${SINCOLOR}\t%s\t%s${ROJO}\t%s${SINCOLOR}${VERDE}\t%s${SINCOLOR}\t%s\n" ${IP} ${HOSTNAME} ${VAR_FILESYSTEM_percent} ${OPT_FILESYSTEM_percent} ${RELOJ}
                    fi
                else
                    #Es Menor /var a 80%, entonces color verde
                    if [ "$OPT_FILESYSTEM_number" -gt 80 ]
                    then
                    #Es Mayor /opt a 80%, entonces color rojo
                    printf "${SINCOLOR}\t%s\t%s${VERDE}\t%s${SINCOLOR}${ROJO}\t%s${SINCOLOR}\t%s\n" ${IP} ${HOSTNAME} ${VAR_FILESYSTEM_percent} ${OPT_FILESYSTEM_percent} ${RELOJ}
                    else
                    #Es Menor /opt a 80%, entonces color verde
                    printf "${SINCOLOR}\t%s\t%s${VERDE}\t%s${SINCOLOR}${VERDE}\t%s${SINCOLOR}\t%s\n" ${IP} ${HOSTNAME} ${VAR_FILESYSTEM_percent} ${OPT_FILESYSTEM_percent} ${RELOJ}
                    fi
                fi
                #
            else
            printf "\t%s \t${SINCOLOR}${ROJO}Sin conexion al host - revisar IPA ${SINCOLOR} \n" $IP
            fi
        fi
    # Aqui injecta lista en variable $LISTA_DE_IP
    done < "$LISTA_DE_IP"
#Imprimiendo lineas de cierre
#----------------------------------
printf "%${COLUMNAS}s" " " | tr " " "-"
#----------------------------------