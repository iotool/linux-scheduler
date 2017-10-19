#!/bin/sh
# 
# Copyright 2017 by IOTool under GNU Lesser General Public License v3.0
# https://github.com/iotool/linux-scheduler/blob/master/LICENSE
# 
# Scheduler - Job mit Abhaengigkeiten starten
# jobname      : eindeutiger Name fuer einen Ablauf
# stepscript   : auszufuehrendes Shellskript fuer diesen Job
# schedulerdir : Hauptverzeichnis vom Scheduler
# parentcount  : Zaehler fuer Abhaengigkeiten

jobname=job3
stepscript=/step/step3.sh
schedulerdir=/home/myuser/scheduler
parentcount=0

# Job bereits gestartet oder beendet, dann nicht erneut starten  
if [[ -e "${schedulerdir}/status/${jobname}_start" ]]; then parentcount=$(( $parentcount + 1 )); fi
if [[ -e "${schedulerdir}/status/${jobname}_end" ]]; then parentcount=$(( $parentcount + 1 )); fi

# Vorbedingungen noch nicht erfuellt, dann noch nicht starten
if [[ ! -e "${schedulerdir}/status/master_start" ]]; then parentcount=$(( $parentcount + 1 )); fi
if [[ ! -e "${schedulerdir}/status/job2a_end" ]]; then parentcount=$(( $parentcount + 1 )); fi
if [[ ! -e "${schedulerdir}/status/job2b_end" ]]; then parentcount=$(( $parentcount + 1 )); fi

# Verarbeitung starten, wenn keine Vorbedingung offen und Job noch nicht gestartet
if [[ $parentcount -eq 0 ]]
then
  echo "start ${schedulerdir}/${stepscript}" > ${schedulerdir}/status/${jobname}_start
  echo "${jobname} start ${stepscript}"
  sleep 1
  . ${schedulerdir}/${stepscript}
  echo "end ${schedulerdir}/${stepscript}" > ${schedulerdir}/status/${jobname}_end
else
  echo "${jobname} ignored"
fi

