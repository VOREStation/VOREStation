// Phase shifting procs (and related procs)
/mob/living/simple_mob/shadekin/proc/phase_shift()
	var/turf/T = get_turf(src)
	var/area/A = T.loc	//RS Port #658
	if(!T.CanPass(src,T) || loc != T)
		to_chat(src,span_warning("You can't use that here!"))
		return FALSE
	/*
	if((get_area(src).flags & PHASE_SHIELDED))
		to_chat(src,span_warning("This area is preventing you from phasing!"))
		return FALSE
	*/
	//RS Port #658 Start
	if(!client?.holder && A.flag_check(AREA_BLOCK_PHASE_SHIFT))
		to_chat(src,span_warning("You can't use that here!"))
		return FALSE
	//RS Port #658 End

	//Shifting in
	if(ability_flags & AB_PHASE_SHIFTED)
		phase_in(T)
	//Shifting out
	else
		phase_out(T)

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
		mouse_opacity = 1
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
		addtimer(CALLBACK(src,PROC_REF(custom_emote), 1, "phases in!"), 0, TIMER_DELETE_ME)
		addtimer(CALLBACK(src,PROC_REF(phase_in_finish_phase),T,original_canmove),5, TIMER_DELETE_ME)

/mob/living/simple_mob/shadekin/proc/phase_in_finish_phase(var/turf/T,var/original_canmove)
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_OVERRIDE(TRUE)
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

	handle_phasein_flicker()

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
		throwpass = TRUE // CHOMPAdd
		mouse_opacity = 0
		custom_emote(1,"phases out!")
		real_name = name
		name = "Something"

		for(var/obj/belly/B as anything in vore_organs)
			B.escapable = FALSE

		cut_overlays()
		flick("tp_out",src)
		addtimer(CALLBACK(src, PROC_REF(phase_invis_handling), original_canmove), 5, TIMER_DELETE_ME)

/mob/living/simple_mob/shadekin/proc/phase_invis_handling(var/original_canmove)
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_OVERRIDE(TRUE)
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


/*
/mob/living/simple_mob/shadekin/proc/dark_tunneling()
	var/template_id = "dark_portal"
	var/datum/map_template/shelter/template

	if(!template)
		template = SSmapping.shelter_templates[template_id]
		if(!template)
			throw EXCEPTION("Shelter template ([template_id]) not found!")
			return FALSE

	var/turf/deploy_location = get_turf(src)
	var/status = template.check_deploy(deploy_location)

	switch(status)
		//Not allowed due to /area technical reasons
		if(SHELTER_DEPLOY_BAD_AREA)
			to_chat(src, span_warning("A tunnel to the Dark will not function in this area."))

		//Anchored objects or no space
		if(SHELTER_DEPLOY_BAD_TURFS, SHELTER_DEPLOY_ANCHORED_OBJECTS)
			var/width = template.width
			var/height = template.height
			to_chat(src, span_warning("There is not enough open area for a tunnel to the Dark to form! You need to clear a [width]x[height] area!"))

	if(status != SHELTER_DEPLOY_ALLOWED)
		return FALSE

	var/turf/T = deploy_location
	var/datum/effect/effect/system/smoke_spread/smoke = new /datum/effect/effect/system/smoke_spread()
	smoke.attach(T)
	smoke.set_up(10, 0, T)
	smoke.start()

	src.visible_message(span_notice("[src] begins pulling dark energies around themselves."))
	if(do_after(src, 600)) //60 seconds
		playsound(src, 'sound/effects/phasein.ogg', 100, 1)
		src.visible_message(span_notice("[src] finishes pulling dark energies around themselves, creating a portal."))

		log_and_message_admins("[key_name_admin(src)] created a tunnel to the dark at [get_area(T)]!")
		template.annihilate_plants(deploy_location)
		template.load(deploy_location, centered = TRUE)
		template.update_lighting(deploy_location)
		ability_flags &= AB_DARK_TUNNEL
		return TRUE
	else
		return FALSE
*/

/*
/mob/living/simple_mob/shadekin/proc/dark_maw()
	var/turf/T = get_turf(src)
	if(!istype(T))
		to_chat(src, span_warning("You don't seem to be able to set a trap here!"))
		return FALSE
	else if(T.get_lumcount() >= 0.5)
		to_chat(src, span_warning("There is too much light here for your trap to last!"))
		return FALSE

	if(do_after(src, 10))
		if(ability_flags & AB_PHASE_SHIFTED)
			new /obj/effect/abstract/dark_maw(loc, src, 1)
		else
			new /obj/effect/abstract/dark_maw(loc, src)

		return TRUE
	else
		return FALSE
*/
