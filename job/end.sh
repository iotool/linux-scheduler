#!/bin/sh
# 
# Copyright 2017 by IOTool under GNU Lesser General Public License v3.0
# https://github.com/iotool/linux-scheduler/blob/master/LICENSE
# 
# Scheduler - Ende mit Abhaengigkeiten ermitteln
# schedulerdir : Hauptverzeichnis vom Scheduler
# parentcount  : Zaehler fuer Abhaengigkeiten

schedulerdir=/home/myuser/scheduler
parentcount=0

# Vorbedingungen noch nicht erfuellt, dann noch nicht beendet 
if [[ ! -e "${schedulerdir}/status/job3_end" ]]; then parentcount=$(( $parentcount + 1 )); fi

# Jobkette nicht gestartet oder bereits beendet
if [[ ! -e "${schedulerdir}/status/master_start" ]]; then parentcount=$(( $parentcount + 1 )); fi
if [[ -e "${schedulerdir}/status/master_end" ]]; then parentcount=$(( $parentcount + 1 )); fi

# Ende setzen, wenn alle Vorbedingungen erfuellt und Jobkette noch nicht beendet
if [[ $parentcount -eq 0 ]]
then
  echo "end reached"
  echo "ende" > ${schedulerdir}/status/master_end
else
  echo "end not reached"
fi

