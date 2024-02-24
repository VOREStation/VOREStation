/mob/living/simple_mob/vore/demon/verb/blood_crawl()
	set name = "Bloodcrawl"
	set desc = "Shift out of reality using blood as your gateway"
	set category = "Abilities"

	var/turf/T = get_turf(src)
	if(!T.CanPass(src,T) || loc != T)
		to_chat(src,"<span class='warning'>You can't use that here!</span>")
		return FALSE

	if(shift_state && shift_state == AB_SHIFT_ACTIVE)
		to_chat(src,"<span class='warning'>You can't do a shift while actively shifting!</span>")
		return FALSE

	if(!(locate(/obj/effect/decal/cleanable/blood) in src.loc))
		to_chat(src,"<span class='warning'>You need blood to shift between realities!</span>")
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
	is_shifting = TRUE

	//Shifting in
	if(shifted_out)
		shifted_out = FALSE
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
		flick("phasein",src)
		custom_emote(1,"phases in!")
		sleep(30) //The duration of the TP animation
		is_shifting = FALSE
		canmove = original_canmove

		//Potential phase-in vore
		if(can_be_drop_pred) //Toggleable in vore panel
			var/list/potentials = living_mobs(0)
			if(potentials.len)
				var/mob/living/target = pick(potentials)
				if(istype(target) && target.devourable && target.can_be_drop_prey && vore_selected)
					target.forceMove(vore_selected)
					to_chat(target,"<span class='vwarning'>\The [src] phases in around you, [vore_selected.vore_verb]ing you into their [vore_selected.name]!</span>")

		// Do this after the potential vore, so we get the belly
		update_icon()

		shift_state = AB_SHIFT_NONE

		/*
		//Affect nearby lights
		var/destroy_lights = 0

		for(var/obj/machinery/light/L in machines)
			if(L.z != z || get_dist(src,L) > 10)
				continue

			if(prob(destroy_lights))
				spawn(rand(5,25))
					L.broken()
			else
				L.flicker(10)
		*/

	//Shifting out
	else
		shifted_out = TRUE
		shift_state = AB_SHIFT_PASSIVE
		custom_emote(1,"phases out!")
		real_name = name
		name = "Something"
		health = maxHealth	//Fullheal

		for(var/obj/belly/B as anything in vore_organs)
			B.escapable = FALSE

		cut_overlays()
		flick("phaseout",src)
		sleep(30)
		invisibility = INVISIBILITY_LEVEL_TWO
		see_invisible = INVISIBILITY_LEVEL_TWO
		update_icon()
		alpha = 127

		is_shifting = FALSE
		canmove = original_canmove
		incorporeal_move = TRUE
		density = FALSE
		force_max_speed = TRUE

/mob/living/simple_mob/vore/demon/verb/phase_shift()
	set name = "Phase Shift"
	set desc = "Shift out of reality temporarily"
	set category = "Abilities"


	var/turf/T = get_turf(src)

	if(shift_state && shift_state == AB_SHIFT_PASSIVE)
		to_chat(src,"<span class='warning'>You can't do a shift while passively shifting!</span>")
		return FALSE

	if(shifted_out)
		to_chat(src,"<span class='warning'>You can't return to the physical world yet!</span>")
		return FALSE

	if(world.time - last_shift < 600)
		to_chat(src,"<span class='warning'>You can't temporarily shift so soon! You need to wait [round(((last_shift+600)-world.time)/10)] second\s!</span>")
		return FALSE

	shift_state = AB_SHIFT_ACTIVE
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
	is_shifting = TRUE

	shifted_out = TRUE
	custom_emote(1,"phases out!")
	real_name = name
	name = "Something"

	for(var/obj/belly/B as anything in vore_organs)
		B.escapable = FALSE

	cut_overlays()
	flick("phaseout",src)
	sleep(30)
	invisibility = INVISIBILITY_LEVEL_TWO
	see_invisible = INVISIBILITY_LEVEL_TWO
	update_icon()
	alpha = 127

	is_shifting = FALSE
	canmove = original_canmove
	incorporeal_move = TRUE
	density = FALSE
	force_max_speed = TRUE

	spawn(300)
		shifted_out = FALSE
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
		original_canmove = canmove
		canmove = FALSE
		is_shifting = TRUE

		//Cosmetics mostly
		flick("phasein",src)
		custom_emote(1,"phases in!")
		sleep(30) //The duration of the TP animation
		is_shifting = FALSE
		canmove = original_canmove

		var/turf/NT = get_turf(src)

		if(!NT.CanPass(src,NT))
			for(var/direction in list(1,2,4,8,5,6,9,10))
				var/turf/L = get_step(NT, direction)
				if(L)
					if(L.CanPass(src,L))
						forceMove(L)
						break

		//Potential phase-in vore
		if(can_be_drop_pred) //Toggleable in vore panel
			var/list/potentials = living_mobs(0)
			if(potentials.len)
				var/mob/living/target = pick(potentials)
				if(istype(target) && target.devourable && target.can_be_drop_prey && vore_selected)
					target.forceMove(vore_selected)
					to_chat(target,"<span class='vwarning'>\The [src] phases in around you, [vore_selected.vore_verb]ing you into their [vore_selected.name]!</span>")

		// Do this after the potential vore, so we get the belly
		update_icon()

		shift_state = AB_SHIFT_NONE
		last_shift = world.time
