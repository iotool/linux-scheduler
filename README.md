# Linux Scheduler

* based on simple shellscript
* no database or installation required

## Scheduling

![Linux Scheduler](https://github.com/iotool/linux-scheduler/blob/master/iotool-linux-scheduler.png "Linux Scheduler")

I've built this scheduler for environments where you can't install any software.

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
jobname=job1
stepscript=/step/step1.sh
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
if [[ ! -e "${schedulerdir}/status/job3_end" ]]; then parentcount=$(( $parentcount + 1 )); fi
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





