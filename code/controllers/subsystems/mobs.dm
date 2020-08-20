//
// Mobs Subsystem - Process mob.Life()
//

//VOREStation Edits - Contains temporary debugging code to diagnose extreme tick consumption.
//Revert file to Polaris version when done.

SUBSYSTEM_DEF(mobs)
	name = "Mobs"
	priority = 100
	wait = 2 SECONDS
	flags = SS_KEEP_TIMING|SS_NO_INIT
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME

	var/list/currentrun = list()
	var/log_extensively = FALSE
	var/list/timelog = list()
	
	var/slept_mobs = 0
	var/list/process_z = list()

/datum/controller/subsystem/mobs/stat_entry()
	..("P: [global.mob_list.len] | S: [slept_mobs]")

/datum/controller/subsystem/mobs/fire(resumed = 0)
	if (!resumed)
		src.currentrun = mob_list.Copy()
		process_z.Cut()
		slept_mobs = 0
		var/level = 1
		while(process_z.len < GLOB.living_players_by_zlevel.len)
			process_z.len++
			process_z[level] = GLOB.living_players_by_zlevel[level].len
			level++

	//cache for sanic speed (lists are references anyways)
	var/list/currentrun = src.currentrun
	var/times_fired = src.times_fired
	while(currentrun.len)
		var/mob/M = currentrun[currentrun.len]
		currentrun.len--

		if(!M || QDELETED(M))
			mob_list -= M
			continue
		else if(M.low_priority && !(M.loc && process_z[get_z(M)]))
			slept_mobs++
			continue
		
		M.Life(times_fired)

		if (MC_TICK_CHECK)
			return
