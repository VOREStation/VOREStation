#define FIRE_PRIORITY_REFLECTOR 20

SUBSYSTEM_DEF(reflector)
	name = "Reflectors"
	priority = FIRE_PRIORITY_REFLECTOR
	flags = SS_BACKGROUND | SS_NO_INIT
	wait = 5

	var/stat_tag = "R" //Used for logging
	var/list/processing = list()
	var/list/currentrun = list()
	var/process_proc = /datum/proc/process

	var/obj/structure/reflector/current_thing

/datum/controller/subsystem/reflector/Recover()
	log_runtime("[name] subsystem Recover().")
	if(SSreflector.current_thing)
		log_runtime("current_thing was: (\ref[SSreflector.current_thing])[SSreflector.current_thing]([SSreflector.current_thing.type]) - currentrun: [SSreflector.currentrun.len] vs total: [SSreflector.processing.len]")
	var/list/old_processing = SSreflector.processing.Copy()
	for(var/datum/D in old_processing)
		if(CHECK_BITFIELD(D.datum_flags, DF_ISPROCESSING))
			processing |= D

//CHOMPEdit Begin
/datum/controller/subsystem/reflector/stat_entry(msg)
	msg = "[stat_tag]:[processing.len]"
	return ..()
// CHOMPEdit End

/datum/controller/subsystem/reflector/fire(resumed = 0)
	if (!resumed)
		currentrun = processing.Copy()
	//cache for sanic speed (lists are references anyways)
	var/list/current_run = currentrun

	while(current_run.len)
		current_thing = current_run[current_run.len]
		current_run.len--
		if(QDELETED(current_thing))
			processing -= current_thing
		current_thing.Fire()
		if (MC_TICK_CHECK)
			current_thing = null
			return

	current_thing = null

#undef FIRE_PRIORITY_REFLECTOR
