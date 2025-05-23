/mob/living/simple_mob/clowns/big/c_shift
	var/ability_flags = 0 //Flags for active abilities

// Phase shifting procs (and related procs)
/mob/living/simple_mob/clowns/big/c_shift/proc/phase_shift()
	var/turf/T = get_turf(src)
	if(!T.CanPass(src,T) || loc != T)
		to_chat(src,span_warning("You can't use that here!"))
		return FALSE

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

	//Shifting in
	if(ability_flags & AB_PHASE_SHIFTED)
		ability_flags &= ~AB_PHASE_SHIFTED
		mouse_opacity = 2
		name = real_name


		cut_overlays()
		alpha = initial(alpha)
		invisibility = initial(invisibility)
		see_invisible = initial(see_invisible)
		incorporeal_move = initial(incorporeal_move)
		density = initial(density)
		force_max_speed = initial(force_max_speed)

		//Cosmetics mostly
		flick("tp_in",src)
		automatic_custom_emote(VISIBLE_MESSAGE,"phases in!")
		sleep(5) //The duration of the TP animation
		canmove = original_canmove

		// Do this after the potential vore, so we get the belly
		update_icon()

		//Affect nearby lights


		for(var/obj/machinery/light/L in machines)
			if(L.z != z || get_dist(src,L) > 10)
				continue

			L.flicker(10)

	//Shifting out
	else
		ability_flags |= AB_PHASE_SHIFTED
		mouse_opacity = 0
		automatic_custom_emote(VISIBLE_MESSAGE,"phases out!")
		real_name = name
		name = "Something"

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

/mob/living/simple_mob/clowns/big/c_shift/UnarmedAttack()
	if(ability_flags & AB_PHASE_SHIFTED)
		return FALSE //Nope.

	. = ..()

/mob/living/simple_mob/clowns/big/c_shift/can_fall()
	if(ability_flags & AB_PHASE_SHIFTED)
		return FALSE //Nope!

	return ..()

/mob/living/simple_mob/clowns/big/c_shift/zMove(direction)
	if(ability_flags & AB_PHASE_SHIFTED)
		var/turf/destination = (direction == UP) ? GetAbove(src) : GetBelow(src)
		if(destination)
			forceMove(destination)
		return TRUE

	return ..()
