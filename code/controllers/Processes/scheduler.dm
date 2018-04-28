/var/datum/controller/process/scheduler/scheduler

/************
* Scheduler *
************/
/datum/controller/process/scheduler
	var/list/scheduled_tasks

/datum/controller/process/scheduler/setup()
	name = "scheduler"
	schedule_interval = 1 SECOND
	scheduled_tasks = list()
	scheduler = src

/datum/controller/process/scheduler/doWork()
	var/world_time = world.time
	for(last_object in scheduled_tasks)
		var/datum/scheduled_task/scheduled_task = last_object
		if(world_time < scheduled_task.trigger_time)
			break // Too early for this one, and therefore too early for all remaining.
		try
			unschedule(scheduled_task)
			scheduled_task.pre_process()
			scheduled_task.process()
			scheduled_task.post_process()
		catch(var/exception/e)
			catchException(e, last_object)
		SCHECK

// We've been restarted, probably due to having a massive list of tasks.
// Lets copy over the task list as safely as we can and try to chug thru it...
// Note: We won't be informed about tasks being destroyed, but this is the best we can do.
/datum/controller/process/scheduler/copyStateFrom(var/datum/controller/process/scheduler/target)
	scheduled_tasks = list()
	for(var/datum/scheduled_task/st in target.scheduled_tasks)
		if(!QDELETED(st) && istype(st))
			schedule(st)
	scheduler = src

// We are being killed. Least we can do is deregister all those events we registered
/datum/controller/process/scheduler/onKill()
	for(var/st in scheduled_tasks)
		destroyed_event.unregister(st, src)

/datum/controller/process/scheduler/statProcess()
	..()
	stat(null, "[scheduled_tasks.len] task\s")

/datum/controller/process/scheduler/proc/schedule(var/datum/scheduled_task/st)
	dd_insertObjectList(scheduled_tasks, st)

/datum/controller/process/scheduler/proc/unschedule(var/datum/scheduled_task/st)
	scheduled_tasks -= st

/**********
* Helpers *
**********/
/proc/schedule_task_in(var/in_time, var/procedure, var/list/arguments = list())
	return schedule_task(world.time + in_time, procedure, arguments)

/proc/schedule_callback_in(var/in_time, var/datum/callback)
	return schedule_callback(world.time + in_time, callback)

/proc/schedule_task_with_source_in(var/in_time, var/source, var/procedure, var/list/arguments = list())
	return schedule_task_with_source(world.time + in_time, source, procedure, arguments)

/proc/schedule_task(var/trigger_time, var/procedure, var/list/arguments)
	var/datum/scheduled_task/st = new/datum/scheduled_task(trigger_time, procedure, arguments, /proc/destroy_scheduled_task, list())
	scheduler.schedule(st)
	return st

/proc/schedule_callback(var/trigger_time, var/datum/callback)
	var/datum/scheduled_task/callback/st = new/datum/scheduled_task/callback(trigger_time, callback, /proc/destroy_scheduled_task, list())
	scheduler.schedule(st)
	return st

/proc/schedule_task_with_source(var/trigger_time, var/source, var/procedure, var/list/arguments)
	var/datum/scheduled_task/st = new/datum/scheduled_task/source(trigger_time, source, procedure, arguments, /proc/destroy_scheduled_task, list())
	scheduler.schedule(st)
	return st

/proc/schedule_repeating_task(var/trigger_time, var/repeat_interval, var/procedure, var/list/arguments)
	var/datum/scheduled_task/st = new/datum/scheduled_task(trigger_time, procedure, arguments, /proc/repeat_scheduled_task, list(repeat_interval))
	scheduler.schedule(st)
	return st

/proc/schedule_repeating_task_with_source(var/trigger_time, var/repeat_interval, var/source, var/procedure, var/list/arguments)
	var/datum/scheduled_task/st = new/datum/scheduled_task/source(trigger_time, source, procedure, arguments, /proc/repeat_scheduled_task, list(repeat_interval))
	scheduler.schedule(st)
	return st

/*************
* Task Datum *
*************/
/datum/scheduled_task
	var/trigger_time
	var/procedure
	var/list/arguments
	var/task_after_process
	var/list/task_after_process_args

/datum/scheduled_task/New(var/trigger_time, var/procedure, var/list/arguments, var/proc/task_after_process, var/list/task_after_process_args)
	..()
	src.trigger_time = trigger_time
	src.procedure = procedure
	src.arguments = arguments ? arguments : list()
	src.task_after_process = task_after_process ? task_after_process : /proc/destroy_scheduled_task
	src.task_after_process_args = istype(task_after_process_args) ? task_after_process_args : list()
	task_after_process_args += src

/datum/scheduled_task/Destroy()
	scheduler.unschedule(src)
	procedure = null
	arguments.Cut()
	task_after_process = null
	task_after_process_args.Cut()
	return ..()

/datum/scheduled_task/dd_SortValue()
	return trigger_time

/datum/scheduled_task/proc/pre_process()
	task_triggered_event.raise_event(list(src))

/datum/scheduled_task/proc/process()
	if(procedure)
		call(procedure)(arglist(arguments))

/datum/scheduled_task/proc/post_process()
	call(task_after_process)(arglist(task_after_process_args))

// Resets the trigger time, has no effect if the task has already triggered
/datum/scheduled_task/proc/trigger_task_in(var/trigger_in)
	src.trigger_time = world.time + trigger_in

/datum/scheduled_task/callback
	var/datum/callback/callback

/datum/scheduled_task/callback/New(var/trigger_time, var/datum/callback, var/proc/task_after_process, var/list/task_after_process_args)
	..(trigger_time = trigger_time, task_after_process = task_after_process, task_after_process_args = task_after_process_args)

/datum/scheduled_task/callback/process()
	callback.Invoke()

/datum/scheduled_task/source
	var/datum/source

/datum/scheduled_task/source/New(var/trigger_time, var/datum/source, var/procedure, var/list/arguments, var/proc/task_after_process, var/list/task_after_process_args)
	src.source = source
	destroyed_event.register(src.source, src, /datum/scheduled_task/source/proc/source_destroyed)
	..(trigger_time, procedure, arguments, task_after_process, task_after_process_args)

/datum/scheduled_task/source/Destroy()
	source = null
	return ..()

/datum/scheduled_task/source/process()
	call(source, procedure)(arglist(arguments))

/datum/scheduled_task/source/proc/source_destroyed()
	qdel(src)

/proc/destroy_scheduled_task(var/datum/scheduled_task/st)
	qdel(st)

/proc/repeat_scheduled_task(var/trigger_delay, var/datum/scheduled_task/st)
	st.trigger_time = world.time + trigger_delay
	scheduler.schedule(st)
