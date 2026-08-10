/obj/structure/spring_trap
	name = "spring trap"
	gender = PLURAL
	layer = 2.6
	anchored = TRUE

	var/sprung = TRUE
	var/distance = 3
	var/max_distance = 10
	var/reset_time = 15 SECONDS

	icon = 'icons/obj/items.dmi'
	icon_state = "spring_trap"

/obj/structure/spring_trap/start_active
	sprung = FALSE

/obj/structure/spring_trap/attackby(obj/item/W, mob/user, attack_modifier, click_parameters)
	if(W.has_tool_quality(TOOL_WRENCH))
		playsound(src, W.usesound, 50, TRUE)
		if(do_after(user, 10 SECONDS, target = src))
			user.visible_message(span_danger("[user] has disassembled \the [src]."), span_notice("You disassemble \the [src]."))
			sprung = TRUE
			new /obj/item/spring_trap_kit(get_turf(src))
			qdel(src)
		else if(!sprung)
			trigger(user, TRUE)
		return
	if(W.has_tool_quality(TOOL_SCREWDRIVER))
		playsound(src, W.usesound, 50, TRUE)
		if(do_after(user, 10 SECONDS, target = src))
			user.visible_message(span_danger("[user] starts adjusting the spring in \the [src]"), span_notice("You adjust the spring in \the [src]"))
			distance = tgui_input_number(user, "Pick distance", "distance", min_value = 1, max_value = max_distance)
			return
	if(W.has_tool_quality(TOOL_CROWBAR))
		playsound(src, W.usesound, 50, TRUE)
		if(do_after(user, 10 SECONDS, target = src))
			user.visible_message(span_danger("[user] starts adjusting the spring in \the [src]"), span_notice("You adjust the spring in \the [src]"))
			var/temp_dir = tgui_input_list(user, "Pick direction", "direction", list("north", "south", "east", "west"), SOUTH)
			dir = text2dir(temp_dir)
			return
	. = ..()

/obj/structure/spring_trap/attack_hand(mob/user)
	if(!sprung)
		user.visible_message(
			span_danger("[user] starts to disarm \the [src]."),span_notice("You begin disarming \the [src]."), "You hear the slow creaking of a spring.")
		playsound(src, 'sound/machines/click.ogg', 50, TRUE)

		if(do_after(user, 10 SECONDS, target = src))
			user.visible_message(span_danger("[user] has disarmed \the [src]."), span_notice("You have disarmed \the [src]."))
			sprung = TRUE
			update_icon()
		else
			trigger(user, TRUE)
	else
		user.visible_message(span_danger("[user] starts to reset \the [src]."), span_notice("You begin resetting \the [src]."), "You hear the slow creaking of a spring.")
		if(do_after(user, 5 SECONDS, target = src))
			playsound(src, 'sound/machines/click.ogg', 50, TRUE)
			sprung = FALSE
			update_icon()

/obj/structure/spring_trap/proc/trigger(mob/living/target)
	SSmotiontracker.ping(src, 100)
	log_and_message_admins("has been yote by a [name] at \the [get_area(loc)], last touched by [forensic_data?.get_lastprint()]", target)
	playsound(src, 'sound/machines/click.ogg', 50, 1)

	visible_message(span_danger("[target] triggers \the [src]."), span_danger("You trigger \the [src]."), span_infoplain(span_bold("You hear a spring creaking!")))

	var/turf/T = get_turf(src)
	if(!T)
		return

	var/turf/land_turf = T

	for(var/i, i < max_distance, i++)
		if(iswall(land_turf))
			continue
		land_turf = get_step(land_turf, dir)

	for(var/atom/movable/thing in (T.contents | target))
		if(thing == src || thing.anchored)
			continue
		if(isliving(target))
			var/mob/living/L = target
			if(L.mob_size <= MOB_TINY)
				var/turf/new_turf = land_turf
				for(var/i, i < max_distance, i++)
					if(iswall(new_turf))
						continue
					new_turf = get_step(new_turf, dir)
				L.throw_at(new_turf, distance, 1)
				continue
		thing.throw_at(land_turf, distance, 1)

	sprung = TRUE
	addtimer(CALLBACK(src, PROC_REF(reset)), reset_time, TIMER_DELETE_ME)

/obj/structure/spring_trap/Crossed(atom/movable/AM)
	if(AM.is_incorporeal() || isobserver(AM) || istype(AM, /obj/effect/abstract) || AM.throwing || istype(AM, /obj/item/projectile))
		return
	if(!sprung)
		if(isliving(AM))
			var/mob/living/L = AM
			if(!(L.m_intent == I_RUN))
				return
		trigger(AM)
	..()

/obj/structure/spring_trap/proc/reset()
	if(!sprung)
		return FALSE
	SSmotiontracker.ping(src, 100)
	visible_message(span_notice("[src] clicks as it resets itself."), "You hear the slow creaking of a spring.")
	playsound(src, 'sound/machines/click.ogg', 50, TRUE)
	sprung = FALSE

/obj/item/spring_trap_kit
	name = "spring trap assembly kit"
	gender = PLURAL
	icon = 'icons/obj/items.dmi'
	icon_state = "spring_trap-kit"

/obj/item/spring_trap_kit/attack_self(mob/user, modifiers)
	. = ..()
	user.visible_message(span_danger("[user] starts to construct \the [src]."), span_notice("You start constructing \the [src]"))
	if(do_after(user, 10 SECONDS, target = src))
		playsound(src, 'sound/machines/click.ogg', 50, 1)
		var/obj/structure/spring_trap/spring_trap = new(get_turf(src))
		spring_trap.add_fingerprint(user)
		spring_trap.dir = user.dir
		qdel(src)
