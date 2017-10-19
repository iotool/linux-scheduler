# Linux Scheduler

* based on simple shellscript
* no database or installation required

## Scheduling

![Linux Scheduler](https://github.com/iotool/linux-scheduler/blob/master/iotool-linux-scheduler.png "Linux Scheduler")

I've built this scheduler for environments where you can't install any software.

**schedule your chain**:

* linux feature: cron jobs
* workaround: while sleep loop

If you are not allowed to use cron, you can create a shellscript like master.sh that contain an endless loop. Don't forget a sleep delay to reduce the system workload. Inside this loop you can parse system time and speficy crontab like execution rules.

**start your chain**:

```
$ cd ~/scheduler/job
$ . start.sh
start master . /home/myuser/scheduler/job/master.sh
master loop 1439 nohup /home/myuser/scheduler/job/chain.sh >/dev/null 2>&1 &
master loop 1438 nohup /home/myuser/scheduler/job/chain.sh >/dev/null 2>&1 &
```

You can start your chain manually or by cron.

**cancle your chain**:

```
$ cd ~/scheduler/job
$ . cancle.sh
cancle master
```

Use cancle to force exit the main loop of the master script. You don't need to kill processes. With cancle you are able to terminate your chain that is running on clustered infrastructure with shared filesystems.

**monitor your chain**:

```
$ cd ~/scheduler/status
$ ls -l -t --time-style=+'%c '
-rw------- 1 myuser user    8 Thu 19 Oct 2017 09:44:52 PM CEST  master_end
-rw------- 1 myuser user   54 Thu 19 Oct 2017 09:44:52 PM CEST  master_start
-rw------- 1 myuser user   43 Thu 19 Oct 2017 09:43:12 PM CEST  job3_end
-rw------- 1 myuser user   45 Thu 19 Oct 2017 09:43:11 PM CEST  job3_start
-rw------- 1 myuser user   44 Thu 19 Oct 2017 09:43:11 PM CEST  job2b_end
-rw------- 1 myuser user   44 Thu 19 Oct 2017 09:43:09 PM CEST  job2a_end
-rw------- 1 myuser user   46 Thu 19 Oct 2017 09:43:08 PM CEST  job2b_start
-rw------- 1 myuser user   46 Thu 19 Oct 2017 09:43:08 PM CEST  job2a_start
-rw------- 1 myuser user   43 Thu 19 Oct 2017 09:43:08 PM CEST  job1_end
-rw------- 1 myuser user   45 Thu 19 Oct 2017 09:43:07 PM CEST  job1_start
```

The schedule is using files to controle the workflow. 

## Steps = program

* single processing step
* sequential program execution

**stepx.sh**:

```
#!/bin/sh
perl /home/myuser/step_x.pl
```

Steps are regular shellskripts that execute atomic logic of your process. You don't have to modify this code because we use separate job script as wrappers. You don't have to move existing shellscript into the scheduler folder.

## Jobs = process

* overall process flow
* parallele job processing

Just copy existing job and rename jobname, specify the stepscript / dependencies and add your new jobs to chain. Modify the end script if necessary.

**jobx.sh**:

```
jobname=jobx
stepscript=/step/stepx.sh
schedulerdir=/home/myuser/scheduler
parentcount=0

if [[ -e "${schedulerdir}/status/${jobname}_start" ]]; then parentcount=$(( $parentcount + 1 )); fi
if [[ -e "${schedulerdir}/status/${jobname}_end" ]]; then parentcount=$(( $parentcount + 1 )); fi

if [[ ! -e "${schedulerdir}/status/master_start" ]]; then parentcount=$(( $parentcount + 1 )); fi
if [[ ! -e "${schedulerdir}/status/joba_end" ]]; then parentcount=$(( $parentcount + 1 )); fi
if [[ ! -e "${schedulerdir}/status/jobb_end" ]]; then parentcount=$(( $parentcount + 1 )); fi

# ...
```
Each job detect its dependencies (e.g. "joba" and "jobb"). The script is simply counting each missing parent. All jobs should run only one time (start and/or end must not exists).

**chain.sh**:

```
#!/bin/sh
schedulerdir=/home/myuser/scheduler
nohup ${schedulerdir}/job/job1.sh  >/dev/null 2>&1 &
nohup ${schedulerdir}/job/job2a.sh >/dev/null 2>&1 &
nohup ${schedulerdir}/job/job2b.sh >/dev/null 2>&1 &
nohup ${schedulerdir}/job/job3.sh  >/dev/null 2>&1 &
nohup ${schedulerdir}/job/jobx.sh  >/dev/null 2>&1 &
nohup ${schedulerdir}/job/end.sh   >/dev/null 2>&1 &

```

Add new jobs to the chain shellscript. There is no sort order for dependencies between jobs, because each job check its dependencies by itself.

**end.sh**:

```
#!/bin/sh
schedulerdir=/home/myuser/scheduler
parentcount=0
if [[ ! -e "${schedulerdir}/status/jobx_end" ]]; then parentcount=$(( $parentcount + 1 )); fi
if [[ ! -e "${schedulerdir}/status/master_start" ]]; then parentcount=$(( $parentcount + 1 )); fi
if [[ -e "${schedulerdir}/status/master_end" ]]; then parentcount=$(( $parentcount + 1 )); fi
if [[ $parentcount -eq 0 ]]
then
  echo "end reached"
  echo "ende" > ${schedulerdir}/status/master_end
else
  echo "end not reached"
fi

```

End is the predefined latest job of each chain where you have to define your end dependencies. The end shellscript force the master shellscript to exit its main loop.





