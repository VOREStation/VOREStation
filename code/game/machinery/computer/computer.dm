/obj/machinery/computer
	name = "computer"
	icon = 'icons/obj/computer.dmi'
	icon_state = "computer"
	density = TRUE
	anchored = TRUE
	unacidable = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 300
	active_power_usage = 300
	blocks_emissive = FALSE
	var/climbable = TRUE
	var/list/climbers
	var/climb_delay = 3.5 SECONDS
	var/processing = 0

	var/icon_keyboard = "generic_key"
	var/icon_screen = "generic"
	var/light_range_on = 2
	var/light_power_on = 1

	clicksound = "keyboard"

/obj/machinery/computer/Initialize()
	. = ..()
	power_change()
	update_icon()
	if(climbable)
		verbs += /obj/structure/proc/climb_on

/obj/machinery/computer/process()
	if(stat & (NOPOWER|BROKEN))
		return 0
	return 1

/obj/machinery/computer/emp_act(severity)
	if(prob(20/severity)) set_broken()
	..()


/obj/machinery/computer/ex_act(severity)
	switch(severity)
		if(1.0)
			fall_apart(severity)
			return
		if(2.0)
			if (prob(25))
				fall_apart(severity)
				return
			if (prob(50))
				for(var/x in verbs)
					src.verbs -= x
				set_broken()
		if(3.0)
			if (prob(25))
				for(var/x in verbs)
					src.verbs -= x
				set_broken()
		else
	return

/obj/machinery/computer/bullet_act(var/obj/item/projectile/Proj)
	if(prob(Proj.get_structure_damage()))
		set_broken()
	..()

/obj/machinery/computer/blob_act()
	ex_act(2)

/obj/machinery/computer/update_icon()
	cut_overlays()

	. = list()

	// Connecty
	if(initial(icon_state) == "computer")
		var/append_string = ""
		var/left = turn(dir, 90)
		var/right = turn(dir, -90)
		var/turf/L = get_step(src, left)
		var/turf/R = get_step(src, right)
		var/obj/machinery/computer/LC = locate() in L
		var/obj/machinery/computer/RC = locate() in R
		if(LC && LC.dir == dir && initial(LC.icon_state) == "computer")
			append_string += "_L"
		if(RC && RC.dir == dir && initial(RC.icon_state) == "computer")
			append_string += "_R"
		icon_state = "computer[append_string]"

	if(icon_keyboard)
		if(stat & NOPOWER)
			playsound(src, 'sound/machines/terminal_off.ogg', 50, 1)
			return add_overlay("[icon_keyboard]_off")
		. += icon_keyboard

	// This whole block lets screens ignore lighting and be visible even in the darkest room
	var/overlay_state = icon_screen
	if(stat & BROKEN)
		overlay_state = "[icon_state]_broken"

	. += mutable_appearance(icon, overlay_state)
	. += emissive_appearance(icon, overlay_state)
	playsound(src, 'sound/machines/terminal_on.ogg', 50, 1)

	add_overlay(.)

/obj/machinery/computer/power_change()
	..()
	update_icon()
	if(stat & NOPOWER)
		set_light(0)
	else
		set_light(light_range_on, light_power_on)

/obj/machinery/computer/proc/set_broken()
	stat |= BROKEN
	update_icon()

/obj/machinery/computer/proc/decode(text)
	// Adds line breaks
	text = replacetext(text, "\n", "<BR>")
	return text

/obj/machinery/computer/attackby(I as obj, user as mob)
	if(computer_deconstruction_screwdriver(user, I))
		return
	else
		if(istype(I,/obj/item/gripper)) //Behold, Grippers and their horribleness. If ..() is called by any computers' attackby() now or in the future, this should let grippers work with them appropriately.
			var/obj/item/gripper/B = I	//B, for Borg.
			if(!B.wrapped)
				to_chat(user, "\The [B] is not holding anything.")
				return
			else
				var/B_held = B.wrapped
				to_chat(user, "You use \the [B] to use \the [B_held] with \the [src].")
				playsound(src, clicksound, 100, 1, 0)
			return
		attack_hand(user)
		return

/obj/machinery/computer/proc/climb_on()
	set name = "Climb structure"
	set desc = "Climbs onto a structure."
	set category = "Object"
	set src in oview(1)

	do_climb(usr)

/obj/machinery/computer/MouseDrop_T(mob/target, mob/user)
	var/mob/living/H = user
	if(istype(H) && can_climb(H) && target == user)
		do_climb(target)
	else
		return ..()

/obj/machinery/computer/proc/can_climb(var/mob/living/user, post_climb_check=0)
	if (!climbable || !can_touch(user) || (!post_climb_check && (user in climbers)))
		return 0

	if (!user.Adjacent(src))
		to_chat(user, span_danger("You can't climb there, the way is blocked."))
		return 0

	var/obj/occupied = turf_is_crowded()
	if(occupied)
		to_chat(user, span_danger("There's \a [occupied] in the way."))
		return 0
	return 1

/obj/machinery/computer/proc/turf_is_crowded()
	var/turf/T = get_turf(src)
	if(!T || !istype(T))
		return "empty void"
	if(T.density)
		return T
	for(var/obj/O in T.contents)
		if(istype(O,/obj/machinery/computer))
			var/obj/machinery/computer/S = O
			if(S.climbable) continue
		if(O && O.density && !(O.flags & ON_BORDER)) //ON_BORDER structures are handled by the Adjacent() check.
			return O
	return 0

/obj/machinery/computer/proc/do_climb(var/mob/living/user)
	if (!can_climb(user))
		return

	user.visible_message(span_warning("[user] starts climbing onto \the [src]!"))
	LAZYDISTINCTADD(climbers, user)

	if(!do_after(user,(issmall(user) ? climb_delay * 0.6 : climb_delay)))
		LAZYREMOVE(climbers, user)
		return

	if (!can_climb(user, post_climb_check=1))
		LAZYREMOVE(climbers, user)
		return

	user.forceMove(climb_to(user))

	if (get_turf(user) == get_turf(src))
		user.visible_message(span_warning("[user] climbs onto \the [src]!"))
	LAZYREMOVE(climbers, user)

/obj/machinery/computer/proc/climb_to(var/mob/living/user)
	return get_turf(src)


/obj/machinery/computer/proc/can_touch(var/mob/user)
	if (!user)
		return 0
	if(!Adjacent(user))
		return 0
	if (user.restrained() || user.buckled)
		to_chat(user, span_notice("You need your hands and legs free for this."))
		return 0
	if (user.stat || user.paralysis || user.sleeping || user.lying || user.weakened)
		return 0
	if (isAI(user))
		to_chat(user, span_notice("You need hands for this."))
		return 0
	return 1
