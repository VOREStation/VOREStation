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
		to_chat(user, "<span class='warning'>Access Denied</span>")
		flick("doorctrl-denied",src)
		return

	use_power(5)
	icon_state = "doorctrl1"
	desiredstate = !desiredstate
	trigger(user)
	spawn(15)
		update_icon()

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
	icon = 'icons/obj/stationobjs_vr.dmi' // VOREStation Edit
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
	for(var/obj/machinery/door/airlock/D in machines)
		if(D.id_tag == id)
			if(specialfunctions & OPEN)
				if(D.density)
					spawn(0)
						D.open()
						return
				else
					spawn(0)
						D.close()
						return
			if(desiredstate == 1)
				if(specialfunctions & IDSCAN)
					D.set_idscan(0)
				if(specialfunctions & BOLTS)
					D.lock()
				if(specialfunctions & SHOCK)
					D.electrify(-1)
				if(specialfunctions & SAFE)
					D.set_safeties(0)
			else
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
	icon = 'icons/obj/stationobjs_vr.dmi'
	name = "remote blast door-control"
	desc = "It controls blast doors, remotely."

/obj/machinery/button/remote/blast_door/trigger()
	for(var/obj/machinery/door/blast/M in machines)
		if(M.id == id)
			if(M.density)
				spawn(0)
					M.open()
					return
			else
				spawn(0)
					M.close()
					return

/*
	Emitter remote control
*/
/obj/machinery/button/remote/emitter
	name = "remote emitter control"
	desc = "It controls emitters, remotely."

/obj/machinery/button/remote/emitter/trigger(mob/user as mob)
	for(var/obj/machinery/power/emitter/E in machines)
		if(E.id == id)
			spawn(0)
				E.activate(user)
				return

/*
	Mass driver remote control
*/
/obj/machinery/button/remote/driver
	name = "mass driver button"
	desc = "A remote control switch for a mass driver."
	icon = 'icons/obj/objects.dmi'
	icon_state = "launcherbtt"

/obj/machinery/button/remote/driver/trigger(mob/user as mob)
	active = 1
	update_icon()

	for(var/obj/machinery/door/blast/M in machines)
		if(M.id == id)
			spawn(0)
				M.open()
				return

	sleep(20)

	for(var/obj/machinery/mass_driver/M in machines)
		if(M.id == id)
			M.drive()

	sleep(50)

	for(var/obj/machinery/door/blast/M in machines)
		if(M.id == id)
			spawn(0)
				M.close()
				return

	icon_state = "launcherbtt"
	update_icon()

	return

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
	icon = 'icons/obj/stationobjs_vr.dmi' // VOREStation Edit

/obj/machinery/button/remote/shields/trigger(var/mob/user)
	for(var/obj/machinery/shield_gen/SG in machines)
		if(SG.id == id)
			spawn(0)
				if(SG?.anchored)
					SG.toggle()
