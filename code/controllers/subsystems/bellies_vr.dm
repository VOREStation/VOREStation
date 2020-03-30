#define SSBELLIES_PROCESSED 1
#define SSBELLIES_IGNORED 2

//
// Bellies subsystem - Process vore bellies
//

SUBSYSTEM_DEF(bellies)
	name = "Bellies"
	priority = 5
	wait = 1 SECONDS
	flags = SS_KEEP_TIMING|SS_NO_INIT
	runlevels = RUNLEVEL_GAME|RUNLEVEL_POSTGAME

	var/list/belly_list = list()
	var/list/currentrun = list()
	var/ignored_bellies = 0
	var/obj/belly/current_belly

/datum/controller/subsystem/bellies/Recover()
	log_debug("[name] subsystem Recover().")
	if(SSbellies.current_belly)
		log_debug("current_belly was: (\ref[SSbellies.current_belly])[SSbellies.current_belly]([SSbellies.current_belly.type])(SSbellies.current_belly.owner) - currentrun: [SSbellies.currentrun.len] vs total: [SSbellies.belly_list.len]")
	var/list/old_bellies = SSbellies.belly_list.Copy()
	for(var/datum/D in old_bellies)
		if(!isbelly(D))
			log_debug("[name] subsystem Recover() found inappropriate item in list: [D.type]")
		belly_list |= D

/datum/controller/subsystem/bellies/stat_entry()
	..("#: [belly_list.len] | P: [ignored_bellies]")

/datum/controller/subsystem/bellies/fire(resumed = 0)
	if (!resumed)
		ignored_bellies = 0
		src.currentrun = belly_list.Copy()

	//cache for sanic speed (lists are references anyways)
	var/list/currentrun = src.currentrun
	var/times_fired = src.times_fired
	while(currentrun.len)
		current_belly = currentrun[currentrun.len]
		currentrun.len--

		if(QDELETED(current_belly))
			belly_list -= current_belly
		else
			if(current_belly.process_belly(times_fired,wait) == SSBELLIES_IGNORED)
				ignored_bellies++

		if (MC_TICK_CHECK)
			current_belly = null
			return

	current_belly = null
