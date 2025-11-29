/obj/machinery/button/remote
	name = "remote object control"
	desc = "It controls objects, remotely."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "doorctrl0"
	power_channel = ENVIRON
	layer = ABOVE_WINDOW_LAYER
	var/desiredstate = 0
	var/exposedwires = 0
	var/wires = 3
	/*
	Bitflag,	1=checkID
				2=Network Access
	*/

	anchored = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 2
	active_power_usage = 4

/obj/machinery/button/remote/attack_ai(mob/user as mob)
	if(wires & 2)
		return attack_hand(user)
	else
		to_chat(user, "Error, no route to host.")

/obj/machinery/button/remote/attackby(obj/item/W, mob/user as mob)
	return attack_hand(user)

/obj/machinery/button/remote/emag_act(var/remaining_charges, var/mob/user)
	if(LAZYLEN(req_access) || LAZYLEN(req_one_access))
		LAZYCLEARLIST(req_access)
		LAZYCLEARLIST(req_one_access)
		playsound(src, "sparks", 100, 1)
		return 1

/obj/machinery/button/remote/attack_hand(mob/user as mob)
	if(..())
		return

	add_fingerprint(user)
	if(stat & (NOPOWER|BROKEN))
		return

	if(!allowed(user) && (wires & 1))
		to_chat(user, span_warning("Access Denied"))
		flick("doorctrl-denied",src)
		return

	use_power(5)
	icon_state = "doorctrl1"
	desiredstate = !desiredstate
	trigger(user)
	addtimer(CALLBACK(src, TYPE_PROC_REF(/atom, update_icon)), 1.5 SECONDS, TIMER_DELETE_ME|TIMER_UNIQUE)

/obj/machinery/button/remote/proc/trigger()
	return

/obj/machinery/button/remote/power_change()
	..()
	update_icon()

/obj/machinery/button/remote/update_icon()
	if(stat & NOPOWER)
		icon_state = "doorctrl-p"
	else
		icon_state = "doorctrl0"

/*
	Airlock remote control
*/

// Bitmasks for door switches.
#define OPEN   0x1
#define IDSCAN 0x2
#define BOLTS  0x4
#define SHOCK  0x8
#define SAFE   0x10

/obj/machinery/button/remote/airlock
	icon = 'icons/obj/stationobjs.dmi'
	name = "remote door-control"
	desc = "It controls doors, remotely."

	var/specialfunctions = 1
	/*
	Bitflag, 	1= open
				2= idscan,
				4= bolts
				8= shock
				16= door safties
	*/

/obj/machinery/button/remote/airlock/trigger()
	for(var/obj/machinery/door/airlock/D in GLOB.machines)
		if(D.id_tag == id)
			if(specialfunctions & OPEN)
				if(D.density)
					D.open()
					continue
				D.close()
				continue

			if(desiredstate == 1)
				if(specialfunctions & IDSCAN)
					D.set_idscan(0)
				if(specialfunctions & BOLTS)
					D.lock()
				if(specialfunctions & SHOCK)
					D.electrify(-1)
				if(specialfunctions & SAFE)
					D.set_safeties(0)
				continue

			if(specialfunctions & IDSCAN)
				D.set_idscan(1)
			if(specialfunctions & BOLTS)
				D.unlock()
			if(specialfunctions & SHOCK)
				D.electrify(0)
			if(specialfunctions & SAFE)
				D.set_safeties(1)

#undef OPEN
#undef IDSCAN
#undef BOLTS
#undef SHOCK
#undef SAFE

/*
	Blast door remote control
*/
/obj/machinery/button/remote/blast_door
	icon = 'icons/obj/stationobjs.dmi'
	name = "remote blast door-control"
	desc = "It controls blast doors, remotely."

/obj/machinery/button/remote/blast_door/trigger()
	for(var/obj/machinery/door/blast/M in GLOB.machines)
		if(M.id == id)
			if(M.density)
				M.open()
			else
				M.close()

/*
	Emitter remote control
*/
/obj/machinery/button/remote/emitter
	name = "remote emitter control"
	desc = "It controls emitters, remotely."

/obj/machinery/button/remote/emitter/trigger(mob/user as mob)
	for(var/obj/machinery/power/emitter/E in GLOB.machines)
		if(E.id == id)
			E.activate(user)

/*
	Mass driver remote control
*/
/obj/machinery/button/remote/driver
	name = "mass driver button"
	desc = "A remote control switch for a mass driver."
	icon = 'icons/obj/objects.dmi'
	icon_state = "launcherbtt"

/obj/machinery/button/remote/driver/trigger(mob/user)
	if(active)
		return
	active = TRUE
	update_icon()

	for(var/obj/machinery/door/blast/M in GLOB.machines)
		if(M.id == id)
			M.open()
	addtimer(CALLBACK(src, PROC_REF(trigger_step_one)), 2 SECONDS, TIMER_DELETE_ME|TIMER_UNIQUE)

/obj/machinery/button/remote/driver/proc/trigger_step_one()
	PRIVATE_PROC(TRUE)
	for(var/obj/machinery/mass_driver/M in GLOB.machines)
		if(M.id == id)
			M.drive()
	addtimer(CALLBACK(src, PROC_REF(trigger_step_two)), 5 SECONDS, TIMER_DELETE_ME|TIMER_UNIQUE)

/obj/machinery/button/remote/driver/proc/trigger_step_two()
	PRIVATE_PROC(TRUE)

	for(var/obj/machinery/door/blast/M in GLOB.machines)
		if(M.id == id)
			M.close()

	active = FALSE
	update_icon()


/obj/machinery/button/remote/driver/update_icon()
	if(!active || (stat & NOPOWER))
		icon_state = "launcherbtt"
	else
		icon_state = "launcheract"

/*
	Shieldgen remote control
*/
/obj/machinery/button/remote/shields
	name = "remote shield control"
	desc = "It controls shields, remotely."
	icon = 'icons/obj/stationobjs.dmi'

/obj/machinery/button/remote/shields/trigger(var/mob/user)
	for(var/obj/machinery/shield_gen/SG in GLOB.machines)
		if(SG.id == id)
			if(SG?.anchored)
				SG.toggle()

/obj/machinery/button/remote/airlock/release
	icon = 'icons/obj/door_release.dmi'
	name = "emergency door release"
	desc = "Forces the opening of doors in an emergency, regardless of whether they're powered."

	use_power = USE_POWER_OFF
	idle_power_usage = 0
	active_power_usage = 0

/obj/machinery/button/remote/airlock/release/trigger()
	for(var/obj/machinery/door/airlock/D in GLOB.machines)
		if(D.id_tag == id)
			if(D.locked)
				D.unlock(1)
			if(D.density)
				D.open(1)

/obj/machinery/button/remote/airlock/release/powered()
	return 1 //Is always able to be used
