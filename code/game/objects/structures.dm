/obj/structure
	icon = 'icons/obj/structures.dmi'
	w_class = ITEMSIZE_NO_CONTAINER
	blocks_emissive = EMISSIVE_BLOCK_GENERIC

	var/climbable
	var/climb_delay = 3.5 SECONDS
	var/breakable
	var/parts
	var/list/climbers
	var/block_turf_edges = FALSE // If true, turf edge icons will not be made on the turf this occupies.

	var/list/connections
	var/list/other_connections
	var/list/blend_objects = newlist() // Objects which to blend with
	var/list/noblend_objects = newlist() //Objects to avoid blending with (such as children of listed blend objects.

/obj/structure/Initialize(mapload)
	. = ..()
	if(climbable)
		verbs += /obj/structure/proc/climb_on

/obj/structure/Destroy()
	if(parts)
		new parts(loc)
	return ..()

/obj/structure/attack_hand(mob/user)
	if(breakable)
		if(HULK in user.mutations)
			user.say(pick(";RAAAAAAAARGH!", ";HNNNNNNNNNGGGGGGH!", ";GWAAAAAAAARRRHHH!", "NNNNNNNNGGGGGGGGHH!", ";AAAAAAARRRGH!" ))
			attack_generic(user,1,"smashes")
		else if(ishuman(user))
			var/mob/living/carbon/human/H = user
			if(H.species.can_shred(user))
				attack_generic(user,1,"slices")

	if(LAZYLEN(climbers) && !(user in climbers))
		user.visible_message(span_warning("[user.name] shakes \the [src]."), \
					span_notice("You shake \the [src]."))
		structure_shaken()

	return ..()

/obj/structure/attack_tk()
	return

/obj/structure/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if(prob(50))
				qdel(src)
				return
		if(3.0)
			return

/obj/structure/proc/climb_on()
	set name = "Climb structure"
	set desc = "Climbs onto a structure."
	set category = "Object"
	set src in oview(1)

	do_climb(usr)

/obj/structure/MouseDrop_T(mob/target, mob/user)
	var/mob/living/H = user
	if(istype(H) && can_climb(H) && target == user)
		do_climb(target)
	else
		return ..()

/obj/structure/proc/can_climb(var/mob/living/user, post_climb_check=0)
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

/obj/structure/proc/turf_is_crowded()
	var/turf/T = get_turf(src)
	if(!T || !istype(T))
		return "empty void"
	if(T.density)
		return T
	for(var/obj/O in T.contents)
		if(istype(O,/obj/structure))
			var/obj/structure/S = O
			if(S.climbable) continue
		if(O && O.density && !(O.flags & ON_BORDER)) //ON_BORDER structures are handled by the Adjacent() check.
			return O
	return 0

/obj/structure/proc/do_climb(var/mob/living/user)
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

/obj/structure/proc/climb_to(var/mob/living/user)
	return get_turf(src)

/obj/structure/proc/structure_shaken()
	for(var/mob/living/M in climbers)
		M.Weaken(1)
		to_chat(M, span_danger("You topple as you are shaken off \the [src]!"))
		climbers.Cut(1,2)

	for(var/mob/living/M in get_turf(src))
		if(M.lying) return //No spamming this on people.

		M.Weaken(3)
		to_chat(M, span_danger("You topple as \the [src] moves under you!"))

		if(prob(25))

			var/damage = rand(15,30)
			var/mob/living/carbon/human/H = M
			if(!istype(H))
				to_chat(H, span_danger("You land heavily!"))
				M.adjustBruteLoss(damage)
				return

			var/obj/item/organ/external/affecting

			switch(pick(list("ankle","wrist","head","knee","elbow")))
				if("ankle")
					affecting = H.get_organ(pick(BP_L_FOOT, BP_R_FOOT))
				if("knee")
					affecting = H.get_organ(pick(BP_L_LEG, BP_R_LEG))
				if("wrist")
					affecting = H.get_organ(pick(BP_L_HAND, BP_R_HAND))
				if("elbow")
					affecting = H.get_organ(pick(BP_L_ARM, BP_R_ARM))
				if("head")
					affecting = H.get_organ(BP_HEAD)

			if(affecting)
				to_chat(M, span_danger("You land heavily on your [affecting.name]!"))
				affecting.take_damage(damage, 0)
				if(affecting.parent)
					affecting.parent.add_autopsy_data("Misadventure", damage)
			else
				to_chat(H, span_danger("You land heavily!"))
				H.adjustBruteLoss(damage)

			H.UpdateDamageIcon()
			H.updatehealth()
	return

/obj/structure/proc/can_touch(var/mob/user)
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

/obj/structure/attack_generic(var/mob/user, var/damage, var/attack_verb)
	if(!breakable || damage < STRUCTURE_MIN_DAMAGE_THRESHOLD)
		return 0
	visible_message(span_danger("[user] [attack_verb] the [src] apart!"))
	user.do_attack_animation(src)
	spawn(1) qdel(src)
	return 1

/obj/structure/proc/can_visually_connect()
	return anchored

/obj/structure/proc/can_visually_connect_to(var/obj/structure/S)
	return istype(S, src)

/obj/structure/proc/update_connections(propagate = 0)
	var/list/dirs = list()
	var/list/other_dirs = list()

	for(var/obj/structure/S in orange(src, 1))
		if(can_visually_connect_to(S))
			if(S.can_visually_connect())
				if(propagate)
					S.update_connections()
					S.update_icon()
				dirs += get_dir(src, S)

	if(!can_visually_connect())
		connections = list("0", "0", "0", "0")
		other_connections = list("0", "0", "0", "0")
		return FALSE

	for(var/direction in GLOB.cardinal)
		var/turf/T = get_step(src, direction)
		var/success = 0
		for(var/b_type in blend_objects)
			if(istype(T, b_type))
				success = 1
				if(propagate)
					var/turf/simulated/wall/W = T
					if(istype(W))
						W.update_connections(1)
				if(success)
					break // breaks inner loop
		if(!success)
			blend_obj_loop:
				for(var/obj/O in T)
					for(var/b_type in blend_objects)
						if(istype(O, b_type))
							success = 1
							for(var/obj/structure/S in T)
								if(istype(S, src))
									success = 0
							for(var/nb_type in noblend_objects)
								if(istype(O, nb_type))
									success = 0

						if(success)
							break blend_obj_loop // breaks outer loop

		if(success)
			dirs += get_dir(src, T)
			other_dirs += get_dir(src, T)

	refresh_neighbors()

	connections = dirs_to_corner_states(dirs)
	other_connections = dirs_to_corner_states(other_dirs)
	return TRUE

/obj/structure/proc/refresh_neighbors()
	for(var/turf/T as anything in RANGE_TURFS(1, src))
		T.update_icon()
