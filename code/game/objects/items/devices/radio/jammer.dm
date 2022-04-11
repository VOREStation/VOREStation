var/global/list/active_radio_jammers = list()

/proc/is_jammed(var/obj/radio)
	var/turf/Tr = get_turf(radio)
	if(!Tr) return 0 //Nullspace radios don't get jammed.

	for(var/obj/item/device/radio_jammer/J as anything in active_radio_jammers)
		var/turf/Tj = get_turf(J)

		if(J.on && Tj.z == Tr.z) //If we're on the same Z, it's worth checking.
			var/dist = get_dist(Tj,Tr)
			if(dist <= J.jam_range)
				return list("jammer" = J, "distance" = dist)

/obj/item/device/radio_jammer
	name = "subspace jammer"
	desc = "Primarily for blocking subspace communications, preventing the use of headsets, PDAs, and communicators. Also masks suit sensors."	// Added suit sensor jamming
	icon = 'icons/obj/device.dmi'
	icon_state = "jammer0"
	var/active_state = "jammer1"
	var/last_overlay_percent = null // Stores overlay icon_state to avoid excessive recreation of overlays.

	var/on = 0
	var/jam_range = 7
	var/obj/item/weapon/cell/device/weapon/power_source
	var/tick_cost = 5 //VOREStation Edit - For the ERPs.

	origin_tech = list(TECH_ILLEGAL = 7, TECH_BLUESPACE = 5) //Such technology! Subspace jamming!

/obj/item/device/radio_jammer/New()
	power_source = new(src)
	update_icon() // So it starts with the full overlay.

/obj/item/device/radio_jammer/Destroy()
	if(on)
		turn_off()
	QDEL_NULL(power_source)
	return ..()

/obj/item/device/radio_jammer/get_cell()
	return power_source

/obj/item/device/radio_jammer/proc/turn_off(mob/user)
	if(user)
		to_chat(user,"<span class='warning'>\The [src] deactivates.</span>")
	STOP_PROCESSING(SSobj, src)
	active_radio_jammers -= src
	on = FALSE
	update_icon()

/obj/item/device/radio_jammer/proc/turn_on(mob/user)
	if(user)
		to_chat(user,"<span class='notice'>\The [src] is now active.</span>")
	START_PROCESSING(SSobj, src)
	active_radio_jammers += src
	on = TRUE
	update_icon()

/obj/item/device/radio_jammer/process()
	if(!power_source || !power_source.check_charge(tick_cost))
		var/mob/living/notify
		if(isliving(loc))
			notify = loc
		turn_off(notify)
	else
		power_source.use(tick_cost)
		update_icon()


/obj/item/device/radio_jammer/attack_hand(mob/user)
	if(user.get_inactive_hand() == src && power_source)
		to_chat(user,"<span class='notice'>You eject \the [power_source] from \the [src].</span>")
		user.put_in_hands(power_source)
		power_source = null
		turn_off()
	else
		return ..()

/obj/item/device/radio_jammer/attack_self(mob/user)
	if(on)
		turn_off(user)
	else
		if(power_source)
			turn_on(user)
		else
			to_chat(user,"<span class='warning'>\The [src] has no power source!</span>")

/obj/item/device/radio_jammer/attackby(obj/W, mob/user)
	if(istype(W,/obj/item/weapon/cell/device/weapon) && !power_source)
		power_source = W
		power_source.update_icon() //Why doesn't a cell do this already? :|
		user.unEquip(power_source)
		power_source.forceMove(src)
		update_icon()
		to_chat(user,"<span class='notice'>You insert \the [power_source] into \the [src].</span>")

/obj/item/device/radio_jammer/update_icon()
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

