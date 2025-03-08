// Phase shifting procs (and related procs)
/mob/living/simple_mob/shadekin/proc/phase_shift()
	var/turf/T = get_turf(src)
	var/area/A = T.loc	//RS Port #658
	if(!T.CanPass(src,T) || loc != T)
		to_chat(src,span_warning("You can't use that here!"))
		return FALSE
	//RS Port #658 Start
	if(!client?.holder && A.flag_check(AREA_BLOCK_PHASE_SHIFT))
		to_chat(src,span_warning("You can't use that here!"))
		return FALSE
	//RS Port #658 End

	else if(doing_phase)
		to_chat(src, span_warning("You are already trying to phase!"))
		return FALSE

	doing_phase = TRUE
	//Shifting in
	if(ability_flags & AB_PHASE_SHIFTED)
		phase_in(T)
	//Shifting out
	else
		phase_out(T)
	doing_phase = FALSE

/mob/living/simple_mob/shadekin/proc/phase_in(var/turf/T)
	if(ability_flags & AB_PHASE_SHIFTED)

		// pre-change
		forceMove(T)
		var/original_canmove = canmove
		SetStunned(0)
		SetWeakened(0)
		if(buckled)
			buckled.unbuckle_mob()
		if(pulledby)
			pulledby.stop_pulling()
		stop_pulling()
		canmove = FALSE

		// change
		ability_flags &= ~AB_PHASE_SHIFTED
		throwpass = FALSE
		name = real_name
		for(var/obj/belly/B as anything in vore_organs)
			B.escapable = initial(B.escapable)

		cut_overlays()
		alpha = initial(alpha)
		invisibility = initial(invisibility)
		see_invisible = initial(see_invisible)
		incorporeal_move = initial(incorporeal_move)
		density = initial(density)
		force_max_speed = initial(force_max_speed)

		//Cosmetics mostly
		flick("tp_in",src)
		INVOKE_ASYNC(src, PROC_REF(custom_emote),1,"phases in!")

		addtimer(CALLBACK(src, PROC_REF(shadekin_complete_phase_in), original_canmove), 5, TIMER_DELETE_ME)


/mob/living/simple_mob/shadekin/proc/shadekin_complete_phase_in(var/original_canmove)
	canmove = original_canmove

	//Potential phase-in vore
	if(can_be_drop_pred) //Toggleable in vore panel
		var/list/potentials = living_mobs(0)
		if(potentials.len)
			var/mob/living/target = pick(potentials)
			if(istype(target) && target.devourable && target.can_be_drop_prey && vore_selected)
				target.forceMove(vore_selected)
				to_chat(target,span_vwarning("\The [src] phases in around you, [vore_selected.vore_verb]ing you into their [vore_selected.name]!"))

	// Do this after the potential vore, so we get the belly
	update_icon()

	//Affect nearby lights
	var/destroy_lights = 0
	if(eye_state == RED_EYES)
		destroy_lights = 80
	if(eye_state == PURPLE_EYES)
		destroy_lights = 25

	for(var/obj/machinery/light/L in machines)
		if(L.z != z || get_dist(src,L) > 10)
			continue

		if(prob(destroy_lights))
			addtimer(CALLBACK(L, TYPE_PROC_REF(/obj/machinery/light, broken)), rand(5,25), TIMER_DELETE_ME)
		else
			L.flicker(10)

/mob/living/simple_mob/shadekin/proc/phase_out(var/turf/T)
	if(!(ability_flags & AB_PHASE_SHIFTED))

		// pre-change
		forceMove(T)
		var/original_canmove = canmove
		SetStunned(0)
		SetWeakened(0)
		if(buckled)
			buckled.unbuckle_mob()
		if(pulledby)
			pulledby.stop_pulling()
		stop_pulling()
		canmove = FALSE

		// change
		ability_flags |= AB_PHASE_SHIFTED
		throwpass = TRUE
		custom_emote(1,"phases out!")
		real_name = name
		name = "Something"

		for(var/obj/belly/B as anything in vore_organs)
			B.escapable = FALSE

		cut_overlays()
		flick("tp_out",src)
		sleep(5)
		invisibility = INVISIBILITY_LEVEL_TWO
		see_invisible = INVISIBILITY_LEVEL_TWO
		update_icon()
		alpha = 127

		canmove = original_canmove
		incorporeal_move = TRUE
		density = FALSE
		force_max_speed = TRUE

/mob/living/simple_mob/shadekin/UnarmedAttack()
	if(ability_flags & AB_PHASE_SHIFTED)
		return FALSE //Nope.

	. = ..()

/mob/living/simple_mob/shadekin/can_fall()
	if(ability_flags & AB_PHASE_SHIFTED)
		return FALSE //Nope!

	return ..()

/mob/living/simple_mob/shadekin/zMove(direction)
	if(ability_flags & AB_PHASE_SHIFTED)
		var/turf/destination = (direction == UP) ? GetAbove(src) : GetBelow(src)
		if(destination)
			forceMove(destination)
		return TRUE

	return ..()

// Healing others
/mob/living/simple_mob/shadekin/proc/mend_other()
	//I hate to crunch a view() but I only want ones I can see
	var/list/viewed = oview(1)
	var/list/targets = list()
	for(var/mob/living/L in viewed)
		targets += L
	if(!targets.len)
		to_chat(src,span_warning("Nobody nearby to mend!"))
		return FALSE

	var/mob/living/target = tgui_input_list(src,"Pick someone to mend:","Mend Other", targets)
	if(!target)
		return FALSE

	target.add_modifier(/datum/modifier/shadekin/heal_boop,1 MINUTE)
	visible_message(span_notice("\The [src] gently places a hand on \the [target]..."))
	face_atom(target)
	return TRUE
