/obj/machinery/computer/teleporter
	name = "teleporter control console"
	desc = "Used to control a linked teleportation Hub and Station."
	icon_keyboard = "teleport_key"
	icon_screen = "teleport"
	circuit = /obj/item/weapon/circuitboard/teleporter
	dir = 4
	var/obj/item/locked = null
	var/id = null
	var/one_time_use = 0 //Used for one-time-use teleport cards (such as clown planet coordinates.)
						 //Setting this to 1 will set locked to null after a player enters the portal and will not allow hand-teles to open portals to that location.

/obj/machinery/computer/teleporter/New()
	id = "[rand(1000, 9999)]"
	..()
	underlays.Cut()
	underlays += image('icons/obj/stationobjs_vr.dmi', icon_state = "telecomp-wires")	//VOREStation Edit: different direction for wires to account for dirs
	return

/obj/machinery/computer/teleporter/Initialize()
	. = ..()
	var/obj/machinery/teleport/station/station
	var/obj/machinery/teleport/hub/hub

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

	if(istype(hub))
		hub.com = src

/obj/machinery/computer/teleporter/attackby(I as obj, mob/living/user as mob)
	if(istype(I, /obj/item/weapon/card/data/))
		var/obj/item/weapon/card/data/C = I
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
				locked = L
				one_time_use = 1

			add_fingerprint(usr)
	else
		..()

	return

/obj/machinery/teleport/station/attack_ai()
	attack_hand()

/obj/machinery/computer/teleporter/attack_hand(user as mob)
	if(..()) return

	/* Ghosts can't use this one because it's a direct selection */
	if(istype(user, /mob/observer/dead)) return

	var/list/L = list()
	var/list/areaindex = list()

	for(var/obj/item/device/radio/beacon/R in all_beacons)
		var/turf/T = get_turf(R)
		if(!T)
			continue
		if(!(T.z in using_map.player_levels))
			continue
		var/tmpname = T.loc.name
		if(areaindex[tmpname])
			tmpname = "[tmpname] ([++areaindex[tmpname]])"
		else
			areaindex[tmpname] = 1
		L[tmpname] = R

	for (var/obj/item/weapon/implant/tracking/I in all_tracking_implants)
		if(!I.implanted || !ismob(I.loc))
			continue
		else
			var/mob/M = I.loc
			if(M.stat == 2)
				if(M.timeofdeath + 6000 < world.time)
					continue
			var/turf/T = get_turf(M)
			if(T)	continue
			if(T.z == 2)	continue
			var/tmpname = M.real_name
			if(areaindex[tmpname])
				tmpname = "[tmpname] ([++areaindex[tmpname]])"
			else
				areaindex[tmpname] = 1
			L[tmpname] = I

	var/desc = input("Please select a location to lock in.", "Locking Computer") in L|null
	if(!desc)
		return
	if(get_dist(src, usr) > 1 && !issilicon(usr))
		return

	locked = L[desc]
	for(var/mob/O in hearers(src, null))
		O.show_message("<span class='notice'>Locked In</span>", 2)
	add_fingerprint(usr)
	return

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

/proc/find_loc(obj/R as obj)
	if(!R)	return null
	var/turf/T = R.loc
	while(!istype(T, /turf))
		T = T.loc
		if(!T || istype(T, /area))	return null
	return T

/obj/machinery/teleport
	name = "teleport"
	icon = 'icons/obj/stationobjs.dmi'
	density = 1
	anchored = 1.0
	var/lockeddown = 0

/obj/machinery/teleport/hub
	name = "teleporter hub"
	desc = "It's the hub of a teleporting machine."
	icon_state = "tele0"
	dir = 4
	var/accurate = 0
	use_power = 1
	idle_power_usage = 10
	active_power_usage = 2000
	circuit = /obj/item/weapon/circuitboard/teleporter_hub
	var/obj/machinery/computer/teleporter/com

/obj/machinery/teleport/hub/New()
	..()
	underlays.Cut()
	underlays += image('icons/obj/stationobjs.dmi', icon_state = "tele-wires")

	component_parts = list()
	component_parts += new /obj/item/weapon/stock_parts/scanning_module(src)
	component_parts += new /obj/item/weapon/stock_parts/scanning_module(src)
	component_parts += new /obj/item/weapon/stock_parts/scanning_module(src)
	component_parts += new /obj/item/weapon/stock_parts/scanning_module(src)
	component_parts += new /obj/item/weapon/stock_parts/micro_laser(src)
	component_parts += new /obj/item/weapon/stock_parts/micro_laser(src)
	component_parts += new /obj/item/weapon/stock_parts/micro_laser(src)
	component_parts += new /obj/item/weapon/stock_parts/micro_laser(src)
	component_parts += new /obj/item/stack/cable_coil(src, 10)
	RefreshParts()

/obj/machinery/teleport/hub/Bumped(M as mob|obj)
	spawn()
		if(icon_state == "tele1")
			teleport(M)
			use_power(5000)
	return

/obj/machinery/teleport/hub/proc/teleport(atom/movable/M as mob|obj)
	if(!com)
		return
	if(!com.locked)
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
			do_teleport(M, com.locked) //dead-on precision

		if(com.one_time_use) //Make one-time-use cards only usable one time!
			com.one_time_use = 0
			com.locked = null
	else
		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		s.set_up(5, 1, src)
		s.start()
		accurate = 1
		spawn(3000)	accurate = 0 //Accurate teleporting for 5 minutes
		for(var/mob/B in hearers(src, null))
			B.show_message("<span class='notice'>Test fire completed.</span>")
	return
/*
/proc/do_teleport(atom/movable/M as mob|obj, atom/destination, precision)
	if(istype(M, /obj/effect))
		qdel(M)
		return
	if(istype(M, /obj/item/weapon/disk/nuclear)) // Don't let nuke disks get teleported --NeoFite
		for(var/mob/O in viewers(M, null))
			O.show_message(text("<span class='danger'>The [] bounces off of the portal!</span>", M.name), 1)
		return
	if(istype(M, /mob/living))
		var/mob/living/MM = M
		if(MM.check_contents_for(/obj/item/weapon/disk/nuclear))
			to_chat(MM, "<span class='warning'>Something you are carrying seems to be unable to pass through the portal. Better drop it if you want to go through.</span>")
			return
	var/disky = 0
	for (var/atom/O in M.contents) //I'm pretty sure this accounts for the maximum amount of container in container stacking. --NeoFite
		if(istype(O, /obj/item/weapon/storage) || istype(O, /obj/item/weapon/gift))
			for (var/obj/OO in O.contents)
				if(istype(OO, /obj/item/weapon/storage) || istype(OO, /obj/item/weapon/gift))
					for (var/obj/OOO in OO.contents)
						if(istype(OOO, /obj/item/weapon/disk/nuclear))
							disky = 1
				if(istype(OO, /obj/item/weapon/disk/nuclear))
					disky = 1
		if(istype(O, /obj/item/weapon/disk/nuclear))
			disky = 1
		if(istype(O, /mob/living))
			var/mob/living/MM = O
			if(MM.check_contents_for(/obj/item/weapon/disk/nuclear))
				disky = 1
	if(disky)
		for(var/mob/P in viewers(M, null))
			P.show_message(text("<span class='danger'>The [] bounces off of the portal!</span>", M.name), 1)
		return

//Bags of Holding cause bluespace teleportation to go funky. --NeoFite
	if(istype(M, /mob/living))
		var/mob/living/MM = M
		if(MM.check_contents_for(/obj/item/weapon/storage/backpack/holding))
			to_chat(MM, "<span class='warning'>The Bluespace interface on your Bag of Holding interferes with the teleport!</span>")
			precision = rand(1,100)
	if(istype(M, /obj/item/weapon/storage/backpack/holding))
		precision = rand(1,100)
	for (var/atom/O in M.contents) //I'm pretty sure this accounts for the maximum amount of container in container stacking. --NeoFite
		if(istype(O, /obj/item/weapon/storage) || istype(O, /obj/item/weapon/gift))
			for (var/obj/OO in O.contents)
				if(istype(OO, /obj/item/weapon/storage) || istype(OO, /obj/item/weapon/gift))
					for (var/obj/OOO in OO.contents)
						if(istype(OOO, /obj/item/weapon/storage/backpack/holding))
							precision = rand(1,100)
				if(istype(OO, /obj/item/weapon/storage/backpack/holding))
					precision = rand(1,100)
		if(istype(O, /obj/item/weapon/storage/backpack/holding))
			precision = rand(1,100)
		if(istype(O, /mob/living))
			var/mob/living/MM = O
			if(MM.check_contents_for(/obj/item/weapon/storage/backpack/holding))
				precision = rand(1,100)

	var/turf/destturf = get_turf(destination)

	var/tx = destturf.x + rand(precision * -1, precision)
	var/ty = destturf.y + rand(precision * -1, precision)

	var/tmploc

	if(ismob(destination.loc)) //If this is an implant.
		tmploc = locate(tx, ty, destturf.z)
	else
		tmploc = locate(tx, ty, destination.z)

	if(tx == destturf.x && ty == destturf.y && (istype(destination.loc, /obj/structure/closet) || istype(destination.loc, /obj/structure/closet/secure_closet)))
		tmploc = destination.loc

	if(tmploc==null)
		return

	M.loc = tmploc
	sleep(2)

	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(5, 1, M)
	s.start()
	return
*/

/obj/machinery/teleport/station
	name = "station"
	desc = "It's the station thingy of a teleport thingy." //seriously, wtf.
	icon_state = "controller"
	dir = 4
	var/active = 0
	var/engaged = 0
	use_power = 1
	idle_power_usage = 10
	active_power_usage = 2000
	circuit = /obj/item/weapon/circuitboard/teleporter_station
	var/obj/machinery/teleport/hub/com

/obj/machinery/teleport/station/New()
	..()
	overlays.Cut()
	overlays += image('icons/obj/stationobjs.dmi', icon_state = "controller-wires")

	component_parts = list()
	component_parts += new /obj/item/weapon/stock_parts/console_screen(src)
	component_parts += new /obj/item/weapon/stock_parts/capacitor(src)
	component_parts += new /obj/item/weapon/stock_parts/capacitor(src)
	component_parts += new /obj/item/stack/cable_coil(src, 10)
	RefreshParts()

/obj/machinery/teleport/station/attackby(var/obj/item/weapon/W)
	attack_hand()

/obj/machinery/teleport/station/attack_ai()
	attack_hand()

/obj/machinery/teleport/station/attack_hand()
	if(engaged)
		disengage()
	else
		engage()

/obj/machinery/teleport/station/proc/engage()
	if(stat & (BROKEN|NOPOWER))
		return

	if(com)
		com.icon_state = "tele1"
		use_power(5000)
		update_use_power(2)
		com.update_use_power(2)
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
		com.update_use_power(1)
		update_use_power(1)
		for(var/mob/O in hearers(src, null))
			O.show_message("<span class='notice'>Teleporter disengaged!</span>", 2)
	add_fingerprint(usr)
	engaged = 0
	return

/obj/machinery/teleport/station/verb/testfire()
	set name = "Test Fire Teleporter"
	set category = "Object"
	set src in oview(1)

	if(stat & (BROKEN|NOPOWER) || !istype(usr,/mob/living))
		return

	if(com && !active)
		active = 1
		for(var/mob/O in hearers(src, null))
			O.show_message("<span class='notice'>Test firing!</span>", 2)
		com.teleport()
		use_power(5000)

		spawn(30)
			active=0

	add_fingerprint(usr)
	return

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
