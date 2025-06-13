// Special Vorebelly types. For general use bellies that have abnormal functionality.
// Also ones that probably shouldn't be savable.
// PS: I'm adding this file in the middle of a toilet overhaul PR.
// If that's not the definition of scope increase, I dont know what is. -Reo

/obj/belly/special //parant type for bellies you dont want to be treated like normal bellies to use
	prevent_saving = TRUE

/obj/belly/special/teleporter
	var/atom/movable/target = null
	var/target_turf = TRUE
	var/teleport_delay = 3 SECONDS

/obj/belly/special/teleporter/Entered(atom/movable/thing, atom/OldLoc)
	. = ..()
	if(teleport_delay <= 0) //just try to teleport immediately.
		try_tele(thing)
		return
	addtimer(CALLBACK(src, PROC_REF(try_tele), thing), teleport_delay, TIMER_DELETE_ME)

/obj/belly/special/teleporter/process(wait)
	if(istype(target))
		return ..()
	for(var/atom/movable/AM in contents)
		try_tele(AM)
	. = ..()

/obj/belly/special/teleporter/proc/try_tele(atom/movable/thing)
	if(!istype(target))
		return
	if(isturf(target)) // if it's a turf, we dont need to do anything else, just teleport to it
		thing.forceMove(target)
	else
		thing.forceMove(target_turf ? get_turf(target) : target )
