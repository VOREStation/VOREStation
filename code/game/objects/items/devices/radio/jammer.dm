GLOBAL_LIST_EMPTY(active_radio_jammers)

/// Returns a list of radiojammer info for the first jammer affecting a turf. Returns null if nothing affects it.
/proc/is_jammed(atom/movable/check_thing)
	RETURN_TYPE(/list)

	// Allows /obj to be passed, but we always work by turf.
	var/turf/Tr = check_thing
	if(!isturf(check_thing))
		check_thing = get_turf(check_thing)
	//Nullspace radios don't get jammed.
	if(!Tr)
		return null

	var/area/our_area = get_area(Tr)
	if(our_area.no_comms)
		return TRUE
	if(!Tr || !length(GLOB.active_radio_jammers))
		return null

	for(var/obj/item/radio_jammer/J as anything in GLOB.active_radio_jammers)
		var/datum/component/radio_jammer/comp = J
		var/turf/Tcj = comp.get_host_turf()
		if(!Tcj || !comp.enabled)
			continue
		if(Tcj.z != Tr.z)
			continue
		var/dist = get_dist(Tcj,Tr)
		if(dist > comp.jam_range)
			continue
		return list("jammer" = comp, "distance" = dist)

	return null

/obj/item/radio_jammer
	name = "subspace jammer"
	desc = "Primarily for blocking subspace communications, preventing the use of headsets, PDAs, and communicators. Also masks suit sensors."	// Added suit sensor jamming
	icon = 'icons/obj/device.dmi'
	icon_state = "jammer0"
	var/active_state = "jammer1"
	var/last_overlay_percent = null // Stores overlay icon_state to avoid excessive recreation of overlays.

	var/on = TRUE
	var/obj/item/cell/device/weapon/power_source
	var/tick_cost = 5 //VOREStation Edit - For the ERPs.

	pickup_sound = 'sound/items/pickup/device.ogg'
	drop_sound = 'sound/items/drop/device.ogg'

/obj/item/radio_jammer/Initialize(mapload)
	. = ..()
	power_source = new(src)

/obj/item/radio_jammer/Initialize(mapload)
	. = ..()
	update_icon()
	AddComponent(/datum/component/radio_jammer, 7)

/obj/item/radio_jammer/Destroy()
	if(on)
		turn_off()
	QDEL_NULL(power_source)
	return ..()

/obj/item/radio_jammer/get_cell()
	return power_source

/obj/item/radio_jammer/proc/turn_off(mob/user)
	if(user)
		to_chat(user,span_warning("\The [src] deactivates."))
	STOP_PROCESSING(SSobj, src)
	var/datum/component/radio_jammer/comp = GetComponent(/datum/component/radio_jammer)
	comp.disable()
	on = comp.enabled
	update_icon()

/obj/item/radio_jammer/proc/turn_on(mob/user)
	if(user)
		to_chat(user,span_notice("\The [src] is now active."))
	START_PROCESSING(SSobj, src)
	var/datum/component/radio_jammer/comp = GetComponent(/datum/component/radio_jammer)
	comp.enable()
	on = comp.enabled
	update_icon()

/obj/item/radio_jammer/process()
	if(!power_source || !power_source.check_charge(tick_cost))
		var/mob/living/notify
		if(isliving(loc))
			notify = loc
		turn_off(notify)
	else
		power_source.use(tick_cost)
		update_icon()


/obj/item/radio_jammer/attack_hand(mob/user)
	if(user.get_inactive_hand() == src && power_source)
		to_chat(user,span_notice("You eject \the [power_source] from \the [src]."))
		user.put_in_hands(power_source)
		power_source = null
		turn_off()
	else
		return ..()

/obj/item/radio_jammer/attack_self(mob/user)
	. = ..(user)
	if(.)
		return TRUE
	if(on)
		turn_off(user)
	else
		if(power_source)
			turn_on(user)
		else
			to_chat(user,span_warning("\The [src] has no power source!"))

/obj/item/radio_jammer/attackby(obj/W, mob/user)
	if(istype(W,/obj/item/cell/device/weapon) && !power_source)
		power_source = W
		power_source.update_icon() //Why doesn't a cell do this already? :|
		user.unEquip(power_source)
		power_source.forceMove(src)
		update_icon()
		to_chat(user,span_notice("You insert \the [power_source] into \the [src]."))

/obj/item/radio_jammer/update_icon()
	if(on)
		icon_state = active_state
	else
		icon_state = initial(icon_state)

	var/overlay_percent = 0
	if(power_source)
		overlay_percent = between(0, round( power_source.percent() , 25), 100)
	else
		overlay_percent = 0

	// Only Cut() if we need to.
	if(overlay_percent != last_overlay_percent)
		cut_overlays()
		add_overlay("jammer_overlay_[overlay_percent]")
		last_overlay_percent = overlay_percent

//Unlimited use, unlimited range jammer for admins. Turn it on, drop it somewhere, it works.
/obj/item/radio_jammer/admin
	tick_cost = 0

/obj/item/radio_jammer/admin/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/radio_jammer, 255)

///Checks to see if the clothing is in a belly that jams sensors or blocks tracking.
/proc/is_vore_jammed(atom/current)
	while(current.loc)
		if(isbelly(current.loc))
			var/obj/belly/B = current.loc
			if(B.mode_flags & DM_FLAG_JAMSENSORS)
				return TRUE
		current = current.loc
	return FALSE
