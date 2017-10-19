#!/bin/sh
# 
# Copyright 2017 by IOTool under GNU Lesser General Public License v3.0
# https://github.com/iotool/linux-scheduler/blob/master/LICENSE
# 
# Scheduler - Jobkette starten und doppelte Ausfuehrung verhindern
# schedulerdir : Hauptverzeichnis vom Scheduler
# parentcount  : Zaehler fuer Abhaengigkeiten

schedulerdir=/home/myuser/scheduler
mastercommand=". ${schedulerdir}/job/master.sh"
parentcount=0

# Jobkette gestartet und noch nicht beendet
if [[ -e "${schedulerdir}/status/master_start" ]]
then 
  parentcount=$(( $parentcount + 1 ));
  if [[ -e "${schedulerdir}/status/master_end" ]]; then parentcount=$(( $parentcount - 1 )); fi
fi

# Jobkette starten (alten Status loeschen, Master starten)
if [[ $parentcount -eq 0 ]]
then
  echo "start master ${mastercommand}"
  rm ${schedulerdir}/status/*
  echo "start ${mastercommand}" > ${schedulerdir}/status/master_start
  ${mastercommand}
else
  echo "start not possible!"
fi

