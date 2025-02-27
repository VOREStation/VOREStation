SUBSYSTEM_DEF(motiontracker)
	name = "Motion Tracker"
	priority = FIRE_PRIORITY_MOTIONTRACKER
	wait = 1 SECOND
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME
	flags = SS_NO_INIT
	var/min_range = 2
	var/max_range = 8
	var/all_echos_round = 0
	var/all_pings_round = 0
	var/list/queued_echo_turfs = list()
	var/list/currentrun = list()
	var/list/expended_echos = list()

/datum/controller/subsystem/motiontracker/stat_entry(msg)
	var/count = 0
	if(_listen_lookup)
		var/list/track_list = _listen_lookup[COMSIG_MOVABLE_MOTIONTRACKER]
		if(islist(track_list))
			count = track_list.len
		else
			count = 1 // listen_lookup optimizes single entries into just returning the only thing
	msg = "L: [count] | Q: [queued_echo_turfs.len] | A: [all_echos_round]/[all_pings_round]"
	return ..()

/datum/controller/subsystem/motiontracker/fire(resumed = 0)
	if(!resumed)
		src.currentrun = queued_echo_turfs.Copy()
		expended_echos.Cut()
	while(currentrun.len)
		var/key = currentrun[1] // Because using an index into an associative array gets the key at that index... I hate you byond.
		var/list/data = currentrun[key]
		var/datum/weakref/AF= data[1]
		var/datum/weakref/RF= data[2]
		var/count 			= data[3]
		var/list/clients 	= data[4]
		var/turf/At = AF?.resolve()
		var/turf/Rt = RF?.resolve()
		if(Rt && At && count)
			while(count-- > 0)
				// Place at root turf offset from signal responder's turf using px offsets. So it will show up over visblocking.
				var/image/motion_echo/E = new /image/motion_echo('icons/effects/effects.dmi', Rt, "motion_echo", OBFUSCATION_LAYER, SOUTH)
				E.place_from_root(At)
				for(var/datum/weakref/C in clients)
					E.append_client(C)
		currentrun.Remove(key)
		expended_echos[key] = data
		if(MC_TICK_CHECK)
			return
	// Removed used keys, incase the current queue grew while we were processing this one
	queued_echo_turfs -= expended_echos

// We get this from anything in the world that would cause a motion tracker ping
// From sounds to motions, to mob attacks. This then sends a signal to anyone listening.
/datum/controller/subsystem/motiontracker/proc/ping(var/atom/source, var/hear_chance = 30)
	var/turf/T = get_turf(source)
	if(!isturf(T)) // ONLY call from turfs
		return
	if(!prob(hear_chance))
		return
	if(hear_chance <= 40)
		T = get_step(T,pick(cardinal))
		if(!T) // incase...
			return
	// Echo time, we have a turf
	if(queued_echo_turfs[REF(T)]) // Already echoing
		return
	all_pings_round++
	SEND_SIGNAL(src, COMSIG_MOVABLE_MOTIONTRACKER, WEAKREF(source), T)

// We get this back from anything that handles the signal, and queues up a turf to draw the echo on
// The logic is in the SIGNAL HANDLER for if it does anything at all with the signal instead of assuming
// everything wants effects drawn, for example the motion tracker item just flicks() and doesn't call this.
/datum/controller/subsystem/motiontracker/proc/queue_echo(var/turf/Rt,var/turf/At,var/echo_count = 1,var/datum/weakref/client)
	if(!Rt || !At || !client)
		return
	var/rfe = REF(At)
	if(!queued_echo_turfs[rfe]) // We only care about the final turf, not the root turf for duping
		queued_echo_turfs[rfe] = list(WEAKREF(At),WEAKREF(Rt),echo_count,list(client))
		all_echos_round++
	else
		var/list/data = queued_echo_turfs[rfe]
		data[4] += list(client)
