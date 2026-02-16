SUBSYSTEM_DEF(aifast)
	name = "AI (Fast)"
	priority = FIRE_PRIORITY_AI
	wait = 0.25 SECONDS // Every quarter second
	flags = SS_NO_INIT
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME

	dependencies = list(
		/datum/controller/subsystem/ai
	)

	var/list/processing = list()
	var/list/currentrun = list()

/datum/controller/subsystem/aifast/stat_entry(msg)
	msg = "P:[length(processing)]"
	return ..()

/datum/controller/subsystem/aifast/fire(resumed = 0)
	if (!resumed)
		src.currentrun = processing.Copy()

	//cache for sanic speed (lists are references anyways)
	var/list/currentrun = src.currentrun

	while(length(currentrun))
		var/datum/ai_holder/A = currentrun[length(currentrun)]
		--currentrun.len
		if(!A || QDELETED(A) || A.busy) // Doesn't exist or won't exist soon or not doing it this tick
			continue
		A.handle_tactics()

		if(MC_TICK_CHECK)
			return
