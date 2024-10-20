/obj/machinery/gateway
	name = "gateway"
	desc = "A mysterious gateway built by unknown hands.  It allows for faster than light travel to far-flung locations and even alternate realities."  //VOREStation Edit
	icon = 'icons/obj/machines/gateway.dmi'
	icon_state = "off"
	density = TRUE
	anchored = TRUE
	unacidable = TRUE
	var/active = 0


/obj/machinery/gateway/Initialize()
	update_icon()
	if(dir == SOUTH)
		density = FALSE
	. = ..()

/obj/machinery/gateway/update_icon()
	if(active)
		icon_state = "on"
		return
	icon_state = "off"



//this is da important part wot makes things go
GLOBAL_DATUM(gateway_station, /obj/machinery/gateway/centerstation)
/obj/machinery/gateway/centerstation
	density = TRUE
	icon_state = "offcenter"
	use_power = USE_POWER_IDLE

	//warping vars
	var/list/linked = list()
	var/ready = 0				//have we got all the parts for a gateway?
	var/wait = 0				//this just grabs world.time at world start
	var/obj/machinery/gateway/centeraway/awaygate = null

/obj/machinery/gateway/centerstation/Initialize()
	if(GLOB.gateway_station)
		warning("[src] at [x],[y],[z] appears to be an additional station-gateway")
	else
		GLOB.gateway_station = src

	update_icon()
	wait = world.time + config.gateway_delay	//+ thirty minutes default

	if(GLOB.gateway_away)
		awaygate = GLOB.gateway_away
	else
		awaygate = locate(/obj/machinery/gateway/centeraway)

	. = ..()
	density = TRUE //VOREStation Add

/obj/machinery/gateway/centerstation/Destroy()
	if(awaygate?.stationgate == src)
		awaygate.stationgate = null
	if(GLOB.gateway_station == src)
		GLOB.gateway_station = null
	return ..()

/obj/machinery/gateway/centerstation/update_icon()
	if(active)
		icon_state = "oncenter"
		return
	icon_state = "offcenter"
/* VOREStation Removal - Doesn't do anything
/obj/machinery/gateway/centerstation/New()
	density = TRUE
*/ //VOREStation Removal End

/obj/machinery/gateway/centerstation/process()
	if(stat & (NOPOWER))
		if(active) toggleoff()
		return

	if(active)
		use_power(5000)


/obj/machinery/gateway/centerstation/proc/detect()
	linked = list()	//clear the list
	var/turf/T = loc

	for(var/i in alldirs)
		T = get_step(loc, i)
		var/obj/machinery/gateway/G = locate(/obj/machinery/gateway) in T
		if(G)
			linked.Add(G)
			continue

		//this is only done if we fail to find a part
		ready = 0
		toggleoff()
		break

	if(linked.len == 8)
		ready = 1


/obj/machinery/gateway/centerstation/proc/toggleon(mob/user as mob)
	if(!ready)			return
	if(linked.len != 8)	return
	if(!powered())		return
	if(!awaygate)
		to_chat(user, span_notice("Error: No destination found. Please program gateway."))
		return
	if(world.time < wait)
		to_chat(user, span_notice("Error: Warpspace triangulation in progress. Estimated time to completion: [round(((wait - world.time) / 10) / 60)] minutes."))
		return
	if(!awaygate.calibrated && !LAZYLEN(awaydestinations)) //VOREStation Edit
		to_chat(user, span_notice("Error: Destination gate uncalibrated. Gateway unsafe to use without far-end calibration update."))
		return

	for(var/obj/machinery/gateway/G in linked)
		G.active = 1
		G.update_icon()
	active = 1
	update_icon()


/obj/machinery/gateway/centerstation/proc/toggleoff()
	for(var/obj/machinery/gateway/G in linked)
		G.active = 0
		G.update_icon()
	active = 0
	update_icon()


/obj/machinery/gateway/centerstation/attack_hand(mob/user as mob)
	if(!ready)
		detect()
		return
	if(!active)
		toggleon(user)
		return
	toggleoff()


//okay, here's the good teleporting stuff
/obj/machinery/gateway/centerstation/Bumped(atom/movable/M as mob|obj)
	if(!ready)		return
	if(!active)		return
	if(!awaygate)	return

	use_power(5000)
	M << 'sound/effects/phasein.ogg'
	playsound(src, 'sound/effects/phasein.ogg', 100, 1)
	if(awaygate.calibrated)
		M.forceMove(get_step(awaygate.loc, SOUTH))
		M.set_dir(SOUTH)
		return
	else
		//VOREStation Addition Start: Prevent abuse
		if(istype(M, /obj/item/uav))
			var/obj/item/uav/L = M
			L.power_down()
		if(istype(M, /mob/living))
			var/mob/living/L = M
			if(LAZYLEN(L.buckled_mobs))
				var/datum/riding/R = L.riding_datum
				for(var/rider in L.buckled_mobs)
					R.force_dismount(rider)
		//VOREStation Addition End: Prevent abuse
		var/obj/effect/landmark/dest = pick(awaydestinations)
		if(dest)
			M.forceMove(dest.loc)
			M.set_dir(SOUTH)
			//VOREStation Addition Start: Mcguffin time!
			if(ishuman(M))
				var/mob/living/carbon/human/H = M
				if(H.client)
					awaygate.entrydetect()
			//VOREStation Addition End: Mcguffin time!

			//VOREStation Addition Start: Abduction!
			if(istype(M, /mob/living) && dest.abductor)
				var/mob/living/L = M
				if(L.nutrition > 500)
					L.nutrition = 500 //If the aim is to negate people overpreparing, then they shouldn't be able to stuff themselves full of food either.
				//Situations to get the mob out of
				if(L.buckled)
					L.buckled.unbuckle_mob()
				if(istype(L.loc,/obj/mecha))
					var/obj/mecha/ME = L.loc
					ME.go_out()
				else if(istype(L.loc,/obj/machinery/sleeper))
					var/obj/machinery/sleeper/SL = L.loc
					SL.go_out()
				else if(istype(L.loc,/obj/machinery/recharge_station))
					var/obj/machinery/recharge_station/RS = L.loc
					RS.go_out()
				if(!issilicon(L)) //Don't drop borg modules...
					var/list/mob_contents = list() //Things which are actually drained as a result of the above not being null.
					mob_contents |= L // The recursive check below does not add the object being checked to its list.
					mob_contents |= recursive_content_check(L, mob_contents, recursion_limit = 3, client_check = 0, sight_check = 0, include_mobs = 1, include_objects = 1, ignore_show_messages = 1)
					for(var/obj/item/holder/I in mob_contents)
						var/obj/item/holder/H = I
						var/mob/living/MI = H.held_mob
						MI.forceMove(get_turf(H))
						if(!issilicon(MI)) //Don't drop borg modules...
							for(var/obj/item/II in MI)
								if(istype(II,/obj/item/implant) || istype(II,/obj/item/nif))
									continue
								MI.drop_from_inventory(II, dest.loc)
						var/obj/effect/landmark/finaldest = pick(awayabductors)
						MI.forceMove(finaldest.loc)
						sleep(1)
						MI.Paralyse(10)
						MI << 'sound/effects/bamf.ogg'
						to_chat(MI,span_warning("You're starting to come to. You feel like you've been out for a few minutes, at least..."))
					for(var/obj/item/I in L)
						if(istype(I,/obj/item/implant) || istype(I,/obj/item/nif))
							continue
						L.drop_from_inventory(I, dest.loc)
				var/obj/effect/landmark/finaldest = pick(awayabductors)
				L.forceMove(finaldest.loc)
				sleep(1)
				L.Paralyse(10)
				L << 'sound/effects/bamf.ogg'
				to_chat(L,span_warning("You're starting to come to. You feel like you've been out for a few minutes, at least..."))
			//VOREStation Addition End
		return

/obj/machinery/gateway/centerstation/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/multitool))
		if(!awaygate)
			if(GLOB.gateway_away)
				awaygate = GLOB.gateway_away
			else
				awaygate = locate(/obj/machinery/gateway/centeraway)
			if(!awaygate) // We still can't find the damn thing because there is no destination.
				to_chat(user, span_notice("Error: Programming failed. No destination found."))
				return
			to_chat(user, span_boldnotice("Startup programming successful!") + ": A destination in another point of space and time has been detected.")
		else
			to_chat(user, span_black("The gate is already calibrated, there is no work for you to do here."))
			return

/////////////////////////////////////Away////////////////////////
GLOBAL_DATUM(gateway_away, /obj/machinery/gateway/centeraway)
/obj/machinery/gateway/centeraway
	density = TRUE
	icon_state = "offcenter"
	use_power = USE_POWER_OFF
	var/calibrated = 1
	var/list/linked = list()	//a list of the connected gateway chunks
	var/ready = 0
	var/obj/machinery/gateway/centerstation/stationgate = null

/obj/machinery/gateway/centeraway/New()
	density = TRUE

/obj/machinery/gateway/centeraway/Initialize()
	if(GLOB.gateway_away)
		warning("[src] at [x],[y],[z] appears to be an additional away-gateway")
	else
		GLOB.gateway_away = src

	update_icon()

	if(GLOB.gateway_station)
		stationgate = GLOB.gateway_station
	else
		stationgate = locate(/obj/machinery/gateway/centerstation)
	. = ..()
	density = TRUE //VOREStation Add

/obj/machinery/gateway/centeraway/Destroy()
	if(stationgate?.awaygate == src)
		stationgate.awaygate = null
	if(GLOB.gateway_away == src)
		GLOB.gateway_away = null
	return ..()

/obj/machinery/gateway/centeraway/update_icon()
	if(active)
		icon_state = "oncenter"
		return
	icon_state = "offcenter"

/obj/machinery/gateway/centeraway/proc/detect()
	linked = list()	//clear the list
	var/turf/T = loc

	for(var/i in alldirs)
		T = get_step(loc, i)
		var/obj/machinery/gateway/G = locate(/obj/machinery/gateway) in T
		if(G)
			linked.Add(G)
			continue

		//this is only done if we fail to find a part
		ready = 0
		toggleoff()
		break

	if(linked.len == 8)
		ready = 1


/obj/machinery/gateway/centeraway/proc/toggleon(mob/user as mob)
	if(!ready)			return
	if(linked.len != 8)	return
	if(!stationgate || !calibrated) // Vorestation edit. Not like Polaris ever touches this anyway.
		to_chat(user, span_notice("Error: No destination found. Please calibrate gateway."))
		return

	for(var/obj/machinery/gateway/G in linked)
		G.active = 1
		G.update_icon()
	active = 1
	update_icon()


/obj/machinery/gateway/centeraway/proc/toggleoff()
	for(var/obj/machinery/gateway/G in linked)
		G.active = 0
		G.update_icon()
	active = 0
	update_icon()


/obj/machinery/gateway/centeraway/attack_hand(mob/user as mob)
	if(!ready)
		detect()
		return
	if(!active)
		toggleon(user)
		return
	toggleoff()


/obj/machinery/gateway/centeraway/Bumped(atom/movable/M as mob|obj)
	if(!ready)	return
	if(!active)	return
	if(istype(M, /mob/living/carbon))
		for(var/obj/item/implant/exile/E in M)//Checking that there is an exile implant in the contents
			if(E.imp_in == M)//Checking that it's actually implanted vs just in their pocket
				to_chat(M, span_black("The station gate has detected your exile implant and is blocking your entry."))
				return
	M.forceMove(get_step(stationgate.loc, SOUTH))
	M.set_dir(SOUTH)
	M << 'sound/effects/phasein.ogg'
	playsound(src, 'sound/effects/phasein.ogg', 100, 1)


/obj/machinery/gateway/centeraway/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/multitool))
		if(calibrated && stationgate)
			to_chat(user, span_black("The gate is already calibrated, there is no work for you to do here."))
			return
		else
			// VOREStation Add
			if(GLOB.gateway_station)
				stationgate = GLOB.gateway_station
			else
				stationgate = locate(/obj/machinery/gateway/centerstation)
			if(!stationgate)
				to_chat(user, span_notice("Error: Recalibration failed. No destination found... That can't be good."))
				return
			// VOREStation Add End
			else
				to_chat(user, span_blue(span_bold("Recalibration successful!") + "") + span_black(" This gate's systems have been fine tuned. Travel to this gate will now be on target."))
				calibrated = 1
				return
