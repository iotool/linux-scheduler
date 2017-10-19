#!/bin/sh
# 
# Copyright 2017 by IOTool under GNU Lesser General Public License v3.0
# https://github.com/iotool/linux-scheduler/blob/master/LICENSE
# 
# Scheduler - Jobkette abbrechen
# schedulerdir : Hauptverzeichnis vom Scheduler
# parentcount  : Zaehler fuer Abhaengigkeiten

schedulerdir=/home/myuser/scheduler
parentcount=0

# Jobkette gestartet und noch nicht beendet
if [[ -e "${schedulerdir}/status/master_start" ]]
then 
  parentcount=$(( $parentcount + 1 ));
  if [[ ! -e "${schedulerdir}/status/master_end" ]]; then parentcount=$(( $parentcount - 1 )); fi
else 
  parentcount=$(( $parentcount + 1 ));
fi

# Jobkette abbrechen (Master beenden)
if [[ $parentcount -eq 0 ]]
then
  echo "cancle master"
  echo "cancle " >> ${schedulerdir}/status/master_start
  echo "cancle " > ${schedulerdir}/status/master_end
else
  echo "cancle not possible!"
fi

