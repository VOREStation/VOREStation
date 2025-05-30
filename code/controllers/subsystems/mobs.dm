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

	var/list/death_list = list()

/datum/controller/subsystem/mobs/stat_entry(msg)
	msg = "P: [global.mob_list.len] | S: [slept_mobs] | D: [death_list.len]"
	return ..()

/datum/controller/subsystem/mobs/fire(resumed = 0)
	if (!resumed)
		src.currentrun = mob_list.Copy()
		process_z.len = GLOB.living_players_by_zlevel.len
		slept_mobs = 0
		for(var/level in 1 to process_z.len)
			process_z[level] = GLOB.living_players_by_zlevel[level].len
		// Lets handle all of these while we have time, should always remain extremely small...
		if(death_list.len) // Don't contact DB if this list is empty
			establish_db_connection()
			if(!SSdbcore.IsConnected())
				log_game("SQL ERROR during death reporting. Failed to connect.")
			else
				for(var/list/entry in death_list)
					process_death(entry)
			death_list.Cut()

	//cache for sanic speed (lists are references anyways)
	var/list/currentrun = src.currentrun
	var/times_fired = src.times_fired
	while(currentrun.len)
		var/mob/M = currentrun[currentrun.len]
		currentrun.len--

		if(!M || QDELETED(M))
			mob_list -= M
			continue
		else if(M.low_priority && !(M.loc && get_z(M) && process_z[get_z(M)]))
			slept_mobs++
			continue

		M.Life(times_fired)

		if (MC_TICK_CHECK)
			return

/datum/controller/subsystem/mobs/proc/log_recent()
	var/msg = "Debug output from the [name] subsystem:\n"
	msg += "- This subsystem is processed tail-first -\n"
	if(!currentrun || !mob_list)
		msg += "ERROR: A critical list [currentrun ? "mob_list" : "currentrun"] is gone!"
		log_game(msg)
		log_world(msg)
		return
	msg += "Lists: currentrun: [currentrun.len], mob_list: [mob_list.len]\n"

	if(!currentrun.len)
		msg += "!!The subsystem just finished the mob_list list, and currentrun is empty (or has never run).\n"
		msg += "!!The info below is the tail of mob_list instead of currentrun.\n"

	var/datum/D = currentrun.len ? currentrun[currentrun.len] : mob_list[mob_list.len]
	msg += "Tail entry: [describeThis(D)] (this is likely the item AFTER the problem item)\n"

	var/position = mob_list.Find(D)
	if(!position)
		msg += "Unable to find context of tail entry in mob_list list.\n"
	else
		if(position != mob_list.len)
			var/additional = mob_list.Find(D, position+1)
			if(additional)
				msg += "WARNING: Tail entry found more than once in mob_list list! Context is for the first found.\n"
		var/start = clamp(position-2,1,mob_list.len)
		var/end = clamp(position+2,1,mob_list.len)
		msg += "2 previous elements, then tail, then 2 next elements of mob_list list for context:\n"
		msg += "---\n"
		for(var/i in start to end)
			msg += "[describeThis(mob_list[i])][i == position ? " << TAIL" : ""]\n"
		msg += "---\n"
	log_game(msg)
	log_world(msg)

/datum/controller/subsystem/mobs/fail()
	..()
	log_recent()

/datum/controller/subsystem/mobs/critfail()
	..()
	log_recent()

/datum/controller/subsystem/mobs/proc/report_death(var/mob/living/carbon/human/H)
	if(!CONFIG_GET(flag/enable_stat_tracking))
		return
	if(!H)
		return
	if(!H.key || !H.mind)
		return
	if(!ticker || !ticker.mode)
		return

	ticker.mode.check_win()

	var/list/data = list()
	data["placeofdeath"] = get_area(H)
	data["podname"] = placeofdeath ? placeofdeath.name : "Unknown area"
	data["sqlname"] = sanitizeSQL(H.real_name)
	data["gender"] = H.gender
	data["brute_loss"] = H.getBruteLoss()
	data["fire_loss"] = H.getFireLoss()
	data["brain_loss"] = H.brainloss
	data["oxy_loss"] = H.getOxyLoss()
	data["sqlkey"] = sanitizeSQL(H.key)
	data["sqlpod"] = sanitizeSQL(podname)
	data["sqlspecial"] = sanitizeSQL(H.mind.special_role)
	data["sqljob"] = sanitizeSQL(H.mind.assigned_role)
	data["laname"] = null
	data["lakey"] = null
	if(H.lastattacker)
		data["laname"] = sanitizeSQL(H.lastattacker:real_name)
		data["lakey"] = sanitizeSQL(H.lastattacker:key)
	data["sqltime"] = time2text(world.realtime, "YYYY-MM-DD hh:mm:ss")
	data["coord"] = "[H.x], [H.y], [H.z]"

	death_list += list(data)

/datum/controller/subsystem/mobs/proc/process_death(var/list/data)
	SHOULD_NOT_OVERRIDE(TRUE)
	PRIVATE_PROC(TRUE)
	//to_world("INSERT INTO death (name, byondkey, job, special, pod, tod, laname, lakey, gender, bruteloss, fireloss, brainloss, oxyloss) VALUES ('[sqlname]', '[sqlkey]', '[sqljob]', '[sqlspecial]', '[sqlpod]', '[sqltime]', '[laname]', '[lakey]', '[H.gender]', [H.bruteloss], [H.getFireLoss()], [H.brainloss], [H.getOxyLoss()])")
	var/datum/db_query/query = SSdbcore.NewQuery("INSERT INTO death (name, byondkey, job, special, pod, tod, laname, lakey, gender, bruteloss, fireloss, brainloss, oxyloss, coord) VALUES ('[data["sqlname"]]', '[data["sqlkey"]]', '[data["sqljob"]]', '[data["sqlspecial"]]', '[data["sqlpod"]]', '[data["sqltime"]]', '[data["laname"]]', '[data["lakey"]]', '[data["gender"]]', [data["brute_loss"]], [data["fire_loss"]], [data["brain_loss"]], [data["oxy_loss"]], '[data["coord"]]')")
	if(!query.Execute())
		var/err = query.ErrorMsg()
		log_game("SQL ERROR during death reporting. Error : \[[err]\]\n")
	qdel(query)
