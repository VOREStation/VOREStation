// Phase shifting procs (and related procs)
/mob/living/simple_mob/shadekin/phase_shift()
	var/turf/T = get_turf(src)
	var/area/A = T.loc
	if(!T.CanPass(src,T) || loc != T)
		to_chat(src,span_warning("You can't use that here!"))
		return FALSE
	if(!check_rights_for(client, R_HOLDER) && A.flag_check(AREA_BLOCK_PHASE_SHIFT))
		to_chat(src,span_warning("You can't use that here!"))
		return FALSE

	else if(doing_phase)
		to_chat(src, span_warning("You are already trying to phase!"))
		return FALSE

	doing_phase = TRUE
	//Shifting in
	if(comp.in_phase)
		phase_in(T)
	//Shifting out
	else
		phase_out(T)
	doing_phase = FALSE

/mob/living/simple_mob/shadekin/UnarmedAttack()
	if(comp.in_phase)
		return FALSE //Nope.

	. = ..()

/mob/living/simple_mob/shadekin/can_fall()
	if(comp.in_phase)
		return FALSE //Nope!

	return ..()

/mob/living/simple_mob/shadekin/zMove(direction)
	if(comp.in_phase)
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
