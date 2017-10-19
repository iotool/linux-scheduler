#!/bin/sh
# 
# Copyright 2017 by IOTool under GNU Lesser General Public License v3.0
# https://github.com/iotool/linux-scheduler/blob/master/LICENSE
# 
# Scheduler - Alle Jobs der Jobkette starten
# stepscript   : auszufuehrendes Shellskript fuer diesen Job

schedulerdir=/home/myuser/scheduler

# Jobs im Hintergrund starten
nohup ${schedulerdir}/job/job1.sh  >/dev/null 2>&1 &
nohup ${schedulerdir}/job/job2a.sh >/dev/null 2>&1 &
nohup ${schedulerdir}/job/job2b.sh >/dev/null 2>&1 &
nohup ${schedulerdir}/job/job3.sh  >/dev/null 2>&1 &
nohup ${schedulerdir}/job/end.sh   >/dev/null 2>&1 &

