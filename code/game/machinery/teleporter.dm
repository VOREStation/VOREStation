//////
//////  Teleporter computer
//////
/obj/machinery/computer/teleporter
	name = "teleporter control console"
	desc = "Used to control a linked teleportation Hub and Station."
	icon_keyboard = "teleport_key"
	icon_screen = "teleport"
	circuit = /obj/item/circuitboard/teleporter
	dir = 4
	var/id = null
	var/one_time_use = 0 //Used for one-time-use teleport cards (such as clown planet coordinates.)
						 //Setting this to 1 will set locked to null after a player enters the portal and will not allow hand-teles to open portals to that location.
	var/datum/tgui_module/teleport_control/teleport_control

/obj/machinery/computer/teleporter/Initialize()
	id = "[rand(1000, 9999)]"
	. = ..()
	underlays = list(image('icons/obj/stationobjs.dmi', icon_state = "telecomp-wires"))
	teleport_control = new(src)
	var/obj/machinery/teleport/station/station = null
	var/obj/machinery/teleport/hub/hub = null

	// Search surrounding turfs for the station, and then search the station's surrounding turfs for the hub.
	for(var/direction in cardinal)
		station = locate(/obj/machinery/teleport/station, get_step(src, direction))
		if(station)
			for(direction in cardinal)
				hub = locate(/obj/machinery/teleport/hub, get_step(station, direction))
				if(hub)
					break
			break

	if(istype(station))
		station.com = hub
		teleport_control.hub = hub

	if(istype(hub))
		hub.com = src
		teleport_control.station = station

/obj/machinery/computer/teleporter/Destroy()
	QDEL_NULL(teleport_control)
	return ..()

/obj/machinery/computer/teleporter/attackby(I as obj, mob/living/user as mob)
	if(istype(I, /obj/item/card/data/))
		var/obj/item/card/data/C = I
		if(stat & (NOPOWER|BROKEN) & (C.function != "teleporter"))
			attack_hand()

		var/obj/L = null

		for(var/obj/effect/landmark/sloc in landmarks_list)
			if(sloc.name != C.data) continue
			if(locate(/mob/living) in sloc.loc) continue
			L = sloc
			break

		if(!L)
			L = locate("landmark*[C.data]") // use old stype

		if(istype(L, /obj/effect/landmark/) && istype(L.loc, /turf))
			to_chat(usr, "You insert the coordinates into the machine.")
			to_chat(usr, "A message flashes across the screen, reminding the user that the nuclear authentication disk is not transportable via insecure means.")
			user.drop_item()
			qdel(I)

			if(C.data == "Clown Land")
				//whoops
				for(var/mob/O in hearers(src, null))
					O.show_message("<span class='warning'>Incoming bluespace portal detected, unable to lock in.</span>", 2)

				for(var/obj/machinery/teleport/hub/H in range(1))
					var/amount = rand(2,5)
					for(var/i=0;i<amount;i++)
						new /mob/living/simple_mob/animal/space/carp(get_turf(H))
				//
			else
				for(var/mob/O in hearers(src, null))
					O.show_message("<span class='notice'>Locked In</span>", 2)
				teleport_control.locked = L
				one_time_use = 1

			add_fingerprint(usr)
	else
		..()

	return

/obj/machinery/teleport/station/attack_ai()
	attack_hand()

/obj/machinery/computer/teleporter/attack_ai(mob/user)
	teleport_control.tgui_interact(user)

/obj/machinery/computer/teleporter/attack_hand(mob/user)
	add_fingerprint(user)
	if(stat & (BROKEN|NOPOWER))
		return
	teleport_control.tgui_interact(user)

/obj/machinery/computer/teleporter/verb/set_id(t as text)
	set category = "Object"
	set name = "Set teleporter ID"
	set src in oview(1)
	set desc = "ID Tag:"

	if(stat & (NOPOWER|BROKEN) || !istype(usr,/mob/living))
		return
	if(t)
		id = t
	return

//////
//////  Root of all the machinery
//////
/obj/machinery/teleport
	name = "teleport"
	icon = 'icons/obj/stationobjs.dmi'
	density = TRUE
	anchored = TRUE
	var/lockeddown = 0

//////
//////  The part you step into
//////
/obj/machinery/teleport/hub
	name = "teleporter hub"
	desc = "It's the hub of a teleporting machine."
	icon = 'icons/obj/teleporter_vr.dmi' //VOREStation Add
	icon_state = "tele0"
	dir = 4
	var/accurate = 0
	use_power = USE_POWER_IDLE
	idle_power_usage = 10
	active_power_usage = 2000
	circuit = /obj/item/circuitboard/teleporter_hub
	var/obj/machinery/computer/teleporter/com

/obj/machinery/teleport/hub/Initialize()
	. = ..()
	underlays += image('icons/obj/stationobjs.dmi', icon_state = "tele-wires")
	default_apply_parts()

/obj/machinery/teleport/hub/Destroy()
	com?.teleport_control.hub = null
	com = null
	return ..()

/obj/machinery/teleport/hub/Bumped(M as mob|obj)
	spawn()
		if(icon_state == "tele1")
			teleport(M)
			use_power(5000)
	return

/obj/machinery/teleport/hub/proc/teleport(atom/movable/M as mob|obj)
	if(!com)
		return
	if(!com.teleport_control.locked)
		for(var/mob/O in hearers(src, null))
			O.show_message("<span class='warning'>Failure: Cannot authenticate locked on coordinates. Please reinstate coordinate matrix.</span>")
		return
	if(istype(M, /atom/movable))
		//VOREStation Addition Start: Prevent taurriding abuse
		if(istype(M, /mob/living))
			var/mob/living/L = M
			if(LAZYLEN(L.buckled_mobs))
				var/datum/riding/R = L.riding_datum
				for(var/rider in L.buckled_mobs)
					R.force_dismount(rider)
		//VOREStation Addition End: Prevent taurriding abuse
		if(prob(5) && !accurate) //oh dear a problem, put em in deep space
			do_teleport(M, locate(rand((2*TRANSITIONEDGE), world.maxx - (2*TRANSITIONEDGE)), rand((2*TRANSITIONEDGE), world.maxy - (2*TRANSITIONEDGE)), 3), 2)
		else
			do_teleport(M, com.teleport_control.locked) //dead-on precision

		if(com.one_time_use) //Make one-time-use cards only usable one time!
			com.one_time_use = 0
			com.teleport_control.locked = null
	else
		var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
		s.set_up(5, 1, src)
		s.start()
		accurate = 1
		spawn(3000)	accurate = 0 //Accurate teleporting for 5 minutes
		for(var/mob/B in hearers(src, null))
			B.show_message("<span class='notice'>Test fire completed.</span>")
	return

//////
//////  The middle part
//////
/obj/machinery/teleport/station
	name = "station"
	desc = "It's the station thingy of a teleport thingy." //seriously, wtf.
	icon = 'icons/obj/teleporter_vr.dmi' //VOREStation Add
	icon_state = "controller"
	dir = 4
	var/active = 0
	var/engaged = 0
	use_power = USE_POWER_IDLE
	idle_power_usage = 10
	active_power_usage = 2000
	circuit = /obj/item/circuitboard/teleporter_station
	var/obj/machinery/teleport/hub/com

/obj/machinery/teleport/station/Initialize()
	. = ..()
	add_overlay("controller-wires")
	default_apply_parts()

/obj/machinery/teleport/station/Destroy()
	com?.com?.teleport_control.station = null
	com = null
	return ..()

/obj/machinery/teleport/station/proc/engage()
	if(stat & (BROKEN|NOPOWER))
		return

	if(com)
		com.icon_state = "tele1"
		use_power(5000)
		update_use_power(USE_POWER_ACTIVE)
		com.update_use_power(USE_POWER_ACTIVE)
		for(var/mob/O in hearers(src, null))
			O.show_message("<span class='notice'>Teleporter engaged!</span>", 2)
	add_fingerprint(usr)
	engaged = 1
	return

/obj/machinery/teleport/station/proc/disengage()
	if(stat & (BROKEN|NOPOWER))
		return

	if(com)
		com.icon_state = "tele0"
		com.accurate = 0
		com.update_use_power(USE_POWER_IDLE)
		update_use_power(USE_POWER_IDLE)
		for(var/mob/O in hearers(src, null))
			O.show_message("<span class='notice'>Teleporter disengaged!</span>", 2)
	add_fingerprint(usr)
	engaged = 0
	return

/obj/machinery/teleport/station/proc/testfire()
	if(!com || active)
		return

	active = TRUE
	visible_message("<span class='notice'>Test firing!</span>")
	com.teleport()
	use_power(5000)
	flick(src, "controller-c") //VOREStation Add

	VARSET_IN(src, active, FALSE, 3 SECONDS)

/obj/machinery/teleport/station/power_change()
	..()
	if(stat & NOPOWER)
		icon_state = "controller-p"

		if(com)
			com.icon_state = "tele0"
	else
		icon_state = "controller"


/obj/effect/laser/Bump()
	range--
	return

/obj/effect/laser/Move()
	range--
	return

/atom/proc/laserhit(L as obj)
	return 1
