#!/bin/sh
# 
# Copyright 2017 by IOTool under GNU Lesser General Public License v3.0
# https://github.com/iotool/linux-scheduler/blob/master/LICENSE
# 
# Scheduler - Jobkette in einer Schleife wiederholt starten
# schedulerdir : Hauptverzeichnis vom Scheduler
# exittimeout  : 24 Stunden - Schleife beenden (keine Endlosschliefe)
# sleepsecond  : 1 Minute - Wartezeit zwischen Aufrufen

schedulerdir=/home/myuser/scheduler
#chaincommand=". ${schedulerdir}/job/chain.sh"
chaincommand="nohup ${schedulerdir}/job/chain.sh >/dev/null 2>&1 &"
exittimeout=1440
sleepsecond=60

# Hauptschleife
while [[ $exittimeout -gt 1 ]]
do
  exittimeout=$(( $exittimeout - 1 ))
  # Ende offen, dann Jobkette ausfuehren
  if  [[ ! -e "${schedulerdir}/status/master_end" ]]
  then
    echo "master loop ${exittimeout} ${chaincommand}"
    sleep ${sleepsecond}
    ${chaincommand}
  fi
  # Ende erreicht, dann Hauptschleife beenden
  if [[ -e "${schedulerdir}/status/master_end" ]]
  then
    echo "master end"
    exittimeout=0
  fi
done

if [[ $exittimeout -eq 1 ]]
then
  echo "master timeout"
fi

rm ${schedulerdir}/job/nohup.out

