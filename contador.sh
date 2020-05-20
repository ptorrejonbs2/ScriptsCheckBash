#!/bin/bash
contador=0
if [ $contador -eq 0 ] ; then
    minutes_prev=$(echo $mydate | cut -d ":" -f2)
    seconds_prev=$(echo $mydate | cut -d ":" -f3)
    printf "${NC}${GREEN}%${padding}s${NC}\n" "$mydate";
else
    minutes=$(echo $mydate | cut -d ":" -f2)
    seconds=$(echo $mydate | cut -d ":" -f3)
    if [ $seconds_prev -gt $seconds ];then
        minutes_prev1=$(echo $minutes_prev | sed "s/^0//g")
        if [ $((minutes_prev1+1)) -eq $minutes ];then
            printf "${NC}${GREEN}%${padding}s${NC}\n" "$mydate";
        else
            redClock="1"
            printf "${NC}${RED}%${padding}s${NC}\n" "$mydate";
        fi
    else
        printf "${NC}${GREEN}%${padding}s${NC}\n" "$mydate";
    fi
    minutes_prev=$minutes
    seconds_prev=$seconds
fi
    contador=$((counter+1))