/obj/machinery/gateway
	name = "gateway"
	desc = "A mysterious gateway built by unknown hands.  It allows for faster than light travel to far-flung locations and even alternate realities."  //VOREStation Edit
	icon = 'icons/obj/machines/gateway.dmi'
	icon_state = "off"
	density = 1
	anchored = 1
	var/active = 0


/obj/machinery/gateway/Initialize()
	update_icon()
	if(dir == SOUTH)
		density = 0
	. = ..()

/obj/machinery/gateway/update_icon()
	if(active)
		icon_state = "on"
		return
	icon_state = "off"



//this is da important part wot makes things go
/obj/machinery/gateway/centerstation
	density = 1
	icon_state = "offcenter"
	use_power = USE_POWER_IDLE

	//warping vars
	var/list/linked = list()
	var/ready = 0				//have we got all the parts for a gateway?
	var/wait = 0				//this just grabs world.time at world start
	var/obj/machinery/gateway/centeraway/awaygate = null

/obj/machinery/gateway/centerstation/Initialize()
	update_icon()
	wait = world.time + config.gateway_delay	//+ thirty minutes default
	awaygate = locate(/obj/machinery/gateway/centeraway)
	. = ..()
	density = 1 //VOREStation Add

/obj/machinery/gateway/centerstation/update_icon()
	if(active)
		icon_state = "oncenter"
		return
	icon_state = "offcenter"
/* VOREStation Removal - Doesn't do anything
/obj/machinery/gateway/centerstation/New()
	density = 1
*/ //VOREStation Removal End

obj/machinery/gateway/centerstation/process()
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
		to_chat(user, "<span class='notice'>Error: No destination found. Please program gateway.</span>")
		return
	if(world.time < wait)
		to_chat(user, "<span class='notice'>Error: Warpspace triangulation in progress. Estimated time to completion: [round(((wait - world.time) / 10) / 60)] minutes.</span>")
		return
	if(!awaygate.calibrated && !LAZYLEN(awaydestinations)) //VOREStation Edit
		to_chat(user, "<span class='notice'>Error: Destination gate uncalibrated. Gateway unsafe to use without far-end calibration update.</span>")
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
		if(istype(M, /obj/item/device/uav))
			var/obj/item/device/uav/L = M
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
			//VOREStation Addition Start: Abduction!
			if(istype(M, /mob/living) && dest.abductor)
				var/mob/living/L = M
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
					for(var/obj/item/weapon/holder/I in mob_contents)
						var/obj/item/weapon/holder/H = I
						var/mob/living/MI = H.held_mob
						MI.forceMove(get_turf(H))
						if(!issilicon(MI)) //Don't drop borg modules...
							for(var/obj/item/II in MI)
								if(istype(II,/obj/item/weapon/implant) || istype(II,/obj/item/device/nif))
									continue
								MI.drop_from_inventory(II, dest.loc)
						var/obj/effect/landmark/finaldest = pick(awayabductors)
						MI.forceMove(finaldest.loc)
						sleep(1)
						MI.Paralyse(10)
						MI << 'sound/effects/bamf.ogg'
						to_chat(MI,"<span class='warning'>You're starting to come to. You feel like you've been out for a few minutes, at least...</span>")
					for(var/obj/item/I in L)
						if(istype(I,/obj/item/weapon/implant) || istype(I,/obj/item/device/nif))
							continue
						L.drop_from_inventory(I, dest.loc)
				var/obj/effect/landmark/finaldest = pick(awayabductors)
				L.forceMove(finaldest.loc)
				sleep(1)
				L.Paralyse(10)
				L << 'sound/effects/bamf.ogg'
				to_chat(L,"<span class='warning'>You're starting to come to. You feel like you've been out for a few minutes, at least...</span>")
			//VOREStation Addition End
		return

/obj/machinery/gateway/centerstation/attackby(obj/item/device/W as obj, mob/user as mob)
	if(istype(W,/obj/item/device/multitool))
		if(!awaygate)
			awaygate = locate(/obj/machinery/gateway/centeraway)
			if(!awaygate) // We still can't find the damn thing because there is no destination.
				to_chat(user, "<span class='notice'>Error: Programming failed. No destination found.</span>")
				return
			to_chat(user, "<span class='notice'><b>Startup programming successful!</b></span>: A destination in another point of space and time has been detected.")
		else
			to_chat(user, "<font color='black'>The gate is already calibrated, there is no work for you to do here.</font>")
			return

/////////////////////////////////////Away////////////////////////


/obj/machinery/gateway/centeraway
	density = 1
	icon_state = "offcenter"
	use_power = USE_POWER_OFF
	var/calibrated = 1
	var/list/linked = list()	//a list of the connected gateway chunks
	var/ready = 0
	var/obj/machinery/gateway/centeraway/stationgate = null


/obj/machinery/gateway/centeraway/Initialize()
	update_icon()
	stationgate = locate(/obj/machinery/gateway/centerstation)
	. = ..()
	density = 1 //VOREStation Add


/obj/machinery/gateway/centeraway/update_icon()
	if(active)
		icon_state = "oncenter"
		return
	icon_state = "offcenter"

/obj/machinery/gateway/centeraway/New()
	density = 1


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
		to_chat(user, "<span class='notice'>Error: No destination found. Please calibrate gateway.</span>")
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
		for(var/obj/item/weapon/implant/exile/E in M)//Checking that there is an exile implant in the contents
			if(E.imp_in == M)//Checking that it's actually implanted vs just in their pocket
				to_chat(M, "<font color='black'>The station gate has detected your exile implant and is blocking your entry.</font>")
				return
	M.forceMove(get_step(stationgate.loc, SOUTH))
	M.set_dir(SOUTH)
	M << 'sound/effects/phasein.ogg'
	playsound(src, 'sound/effects/phasein.ogg', 100, 1)


/obj/machinery/gateway/centeraway/attackby(obj/item/device/W as obj, mob/user as mob)
	if(istype(W,/obj/item/device/multitool))
		if(calibrated && stationgate)
			to_chat(user, "<font color='black'>The gate is already calibrated, there is no work for you to do here.</font>")
			return
		else
			// VOREStation Add
			stationgate = locate(/obj/machinery/gateway/centerstation)
			if(!stationgate)
				to_chat(user, "<span class='notice'>Error: Recalibration failed. No destination found... That can't be good.</span>")
				return
			// VOREStation Add End
			else
				to_chat(user, "<font color='blue'><b>Recalibration successful!</b>:</font><font color='black'> This gate's systems have been fine tuned. Travel to this gate will now be on target.</font>")
				calibrated = 1
				return
