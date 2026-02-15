SUBSYSTEM_DEF(ai)
	name = "AI"
	priority = FIRE_PRIORITY_AI
	wait = 2 SECONDS
	flags = SS_NO_INIT
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME

	dependencies = list(
		/datum/controller/subsystem/air,
		/datum/controller/subsystem/mobs
	)

	var/list/processing = list()
	var/list/currentrun = list()

	var/slept_mobs = 0
	var/list/process_z = list()

/datum/controller/subsystem/ai/stat_entry(msg)
	msg = "P: [length(processing)] | S: [slept_mobs]"
	return ..()

/datum/controller/subsystem/ai/fire(resumed = 0)
	if (!resumed)
		src.currentrun = processing.Copy()
		process_z.Cut()
		slept_mobs = 0
		var/level = 1
		while(length(process_z) < length(GLOB.living_players_by_zlevel))
			process_z.len++
			process_z[level] = length(GLOB.living_players_by_zlevel[level])
			level++

	//cache for sanic speed (lists are references anyways)
	var/list/currentrun = src.currentrun

	while(length(currentrun))
		var/datum/ai_holder/A = currentrun[length(currentrun)]
		--currentrun.len
		if(!A || QDELETED(A) || A.busy) // Doesn't exist or won't exist soon or not doing it this tick
			continue

		var/mob/living/L = A.holder	//VOREStation Edit Start
		if(!L?.loc)
			continue

		if((get_z(L) && process_z[get_z(L)]) || !L.low_priority) //VOREStation Edit End
			A.handle_strategicals()
		else
			slept_mobs++
			A.set_stance(STANCE_IDLE)

		if(MC_TICK_CHECK)
			return
