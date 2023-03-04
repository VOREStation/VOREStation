/obj/item/mine
	name = "explosive mine"
	desc = "A small explosive land mine."
	density =  FALSE
	anchored = FALSE
	icon = 'icons/obj/mine.dmi'
	icon_state = "mine"

	var/actual_name
	var/actual_desc
	var/actual_icon_state
	var/hidden_alpha = 255

	var/panel_open = FALSE
	var/armed = FALSE
	var/triggering = FALSE
	var/datum/mine_payload/payload = /datum/mine_payload/explosive

	var/static/list/concealable_turfs = list(
		/turf/simulated/floor/concrete,
		/turf/simulated/floor/outdoors
	)

/obj/item/mine/Initialize()
	. = ..()
	if(ispath(payload))
		payload = new payload
	register_dangerous_to_step()

	// We store and hide our appearance if we're armed, to avoid people gaming mines via desc.
	actual_name = name
	actual_desc = desc
	actual_icon_state = icon_state
	update_icon()

/obj/item/mine/Destroy()
	if(istype(payload))
		QDEL_NULL(payload)
	unregister_dangerous_to_step()
	return ..()

/obj/item/mine/update_icon()
	. = ..()
	alpha = initial(alpha)
	cut_overlays()
	if(panel_open)
		add_overlay("[icon_state]_open")
	else if(armed)
		add_overlay("[icon_state]_armed")
		alpha = hidden_alpha
	else
		add_overlay("[icon_state]_safe")

/obj/item/mine/attack_self(mob/user)	// You do not want to move or throw a land mine while priming it... Explosives + Sudden Movement = Bad Times
	add_fingerprint(user)
	msg_admin_attack("[key_name_admin(user)] armed \the [src]")
	user.visible_message(
		SPAN_DANGER("\The [user] starts arming \the [src]."),
		SPAN_DANGER("You start arming \the [src]. Hold still!")
	)
	if(do_after(user, 10 SECONDS))
		playsound(src, 'sound/weapons/armbomb.ogg', 75, 1, -3)
		prime(user)
	else
		visible_message(
			SPAN_DANGER("\The [user] accidentally triggers \the [src]!"),
			SPAN_DANGER("You accidentally trigger \the [src]!")
		)
		prime(user)
		trigger_payload(user)
	return TRUE

// debug proc, replace with proper disarm minigame
/obj/item/mine/proc/disarm()
	armed = FALSE
	triggering = FALSE
	anchored = FALSE
	name = actual_name
	desc = actual_desc
	icon_state = actual_icon_state
	hidden_alpha = 255
	update_icon()

/obj/item/mine/attack_hand(mob/living/user)
	if(armed)
		trigger_payload()
		return TRUE
	return ..()

/obj/item/mine/attackby(obj/item/W, mob/living/user)

	if(W.is_screwdriver())
		visible_message(SPAN_NOTICE("\The [user] begins carefully adjusting \the [src]'s casing."))
		if(do_after(user, 15 SECONDS, src))
			panel_open = !panel_open
			visible_message(SPAN_NOTICE("\The [user] carefully [panel_open ? "opens" : "closes"] the casing of \the [src]."))
			update_icon()
		else if(armed)
			to_chat(user, SPAN_DANGER("You set off \the [src]!"))
			trigger_payload(user)
		return TRUE

	if(armed)
		if(panel_open && W.is_wirecutter())
			visible_message(SPAN_NOTICE("\The [user] begins painstakingly disarming \the [src]..."))
			if(do_after(user, 30 SECONDS, src))
				visible_message(SPAN_NOTICE("\The [user] disarms \the [src]!"))
				disarm()
				return TRUE
		if(armed) // checking again in case the do_after() stacks
			to_chat(user, SPAN_DANGER("You set off \the [src]!"))
			trigger_payload(user)
		return TRUE

	return ..()

/obj/item/mine/proc/prime(mob/user)

	if(armed)
		return

	if(user)
		visible_message(SPAN_NOTICE("\The [src] beeps as the priming sequence completes."))
		user.drop_from_inventory(src, get_turf(user))
		add_fingerprint(user)

	anchored = TRUE
	armed = TRUE

	if(isturf(loc) && prob(65))
		for(var/turftype in concealable_turfs)
			if(istype(loc, turftype))
				hidden_alpha = pick(50, 90, 120)
				break

	name = "mine"
	desc = "A small land mine."
	icon_state = "mine"
	update_icon()

/obj/item/mine/Moved(atom/oldloc)
	. = ..()
	if(.)
		var/turf/old_turf = get_turf(oldloc)
		var/turf/new_turf = get_turf(src)
		if(old_turf != new_turf)
			old_turf.unregister_dangerous_object(src)
			new_turf.register_dangerous_object(src)

/obj/item/mine/proc/trigger_payload(var/mob/living/M)
	if(!triggering && payload && armed)
		triggering = TRUE
		if(ismob(loc))
			var/mob/holder = loc
			holder.drop_from_inventory(src)
		visible_message("\The [src] goes off!")
		payload.trigger_payload(src, M)
		disarm() // the mine can be reused if the payload doesn't destroy it.
		return TRUE
	return FALSE

/obj/item/mine/bullet_act()
	if(prob(50))
		trigger_payload()
	if(!QDELETED(src))
		..()

/obj/item/mine/ex_act(severity)
	if(severity <= 2 || prob(50))
		trigger_payload()
	if(!QDELETED(src))
		..()

/obj/item/mine/Crossed(atom/movable/AM)
	. = ..()
	if(istype(AM) && !AM.is_incorporeal())
		Bumped(AM)

/obj/item/mine/Bumped(atom/movable/AM)
	. = ..()
	if(!QDELETED(src) && !is_safe_to_step(AM))
		trigger_payload(AM)

// This tells AI mobs to not be dumb and step on mines willingly.
/obj/item/mine/is_safe_to_step(mob/living/L)
	if(!armed)
		return TRUE

	if(isliving(L))
		if(L.hovering)
			return TRUE
	else if(ismecha(L))
		var/obj/mecha/M = L
		return M.in_flight()
	else
		return TRUE

	return FALSE
