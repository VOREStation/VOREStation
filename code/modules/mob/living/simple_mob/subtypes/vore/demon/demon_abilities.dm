/mob/living/simple_mob/vore/demon/verb/blood_crawl()
	set name = "Bloodcrawl"
	set desc = "Shift out of reality using blood as your gateway"
	set category = "Abilities.Demon"

	var/turf/T = get_turf(src)
	if(!T.CanPass(src,T) || loc != T)
		to_chat(src,span_warning("You can't use that here!"))
		return FALSE

	if((get_area(src).flags & PHASE_SHIELDED))
		to_chat(src,span_warning("This area is preventing you from phasing!"))
		return FALSE

	if(shift_state && shift_state == AB_SHIFT_ACTIVE)
		to_chat(src,span_warning("You can't do a shift while actively shifting!"))
		return FALSE

	if(!(locate(/obj/effect/decal/cleanable/blood) in src.loc))
		to_chat(src,span_warning("You need blood to shift between realities!"))
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
		automatic_custom_emote(VISIBLE_MESSAGE,"phases in!")
		sleep(30) //The duration of the TP animation
		is_shifting = FALSE
		canmove = original_canmove

		//Potential phase-in vore
		if(can_be_drop_pred) //Toggleable in vore panel
			var/list/potentials = living_mobs(0)
			if(potentials.len)
				var/mob/living/target = pick(potentials)
				if(can_phase_vore(src, target))
					target.forceMove(vore_selected)
					to_chat(target,span_vwarning("\The [src] phases in around you, [vore_selected.vore_verb]ing you into their [vore_selected.get_belly_name()]!"))

		// Do this after the potential vore, so we get the belly
		update_icon()

		shift_state = AB_SHIFT_NONE

		/*
		//Affect nearby lights
		var/destroy_lights = 0

		for(var/obj/machinery/light/L in GLOB.machines)
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
		automatic_custom_emote(VISIBLE_MESSAGE,"phases out!")
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

/mob/living/simple_mob/vore/demon/verb/demonic_phase_shift()
	set name = "Phase Shift"
	set desc = "Shift out of reality temporarily"
	set category = "Abilities.Demon"


	var/turf/T = get_turf(src)

	if(shift_state && shift_state == AB_SHIFT_PASSIVE)
		to_chat(src,span_warning("You can't do a shift while passively shifting!"))
		return FALSE

	if(shifted_out)
		to_chat(src,span_warning("You can't return to the physical world yet!"))
		return FALSE

	if(world.time - last_shift < 600)
		to_chat(src,span_warning("You can't temporarily shift so soon! You need to wait [round(((last_shift+600)-world.time)/10)] second\s!"))
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
	automatic_custom_emote(VISIBLE_MESSAGE,"phases out!")
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
		automatic_custom_emote(VISIBLE_MESSAGE,"phases in!")
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
				if(can_phase_vore(src, target))
					target.forceMove(vore_selected)
					to_chat(target,span_vwarning("\The [src] phases in around you, [vore_selected.vore_verb]ing you into their [vore_selected.get_belly_name()]!"))

		// Do this after the potential vore, so we get the belly
		update_icon()

		shift_state = AB_SHIFT_NONE
		last_shift = world.time


/mob/living/simple_mob/vore/demon/verb/blood_burst()
	set name = "Blood burst"
	set desc = "Spawn bloody remains from your past hunts."
	set category = "Abilities.Demon"

	var/turf/T = get_turf(src)

	if(shifted_out)
		to_chat(src,span_warning("You must be in the physical world to create blood!"))
		return FALSE

	if(world.time - blood_spawn < 1500)
		to_chat(src,span_warning("You can't create blood so soon! You need to wait [round(((blood_spawn+1500)-world.time)/10)] second\s!"))
		return FALSE


	new /obj/effect/gibspawner/generic(T)

	playsound(src.loc, 'sound/effects/blobattack.ogg', 50, 1)

	blood_spawn = world.time

	return

/mob/living/simple_mob/vore/demon/verb/toggle_laugh()
	set name = "Toggle Auto Laugh"
	set desc = "Toggles whether the demon will automatically laugh when interacted with."
	set category = "Abilities.Demon"

	enable_autolaugh = !enable_autolaugh
	if(enable_autolaugh)
		to_chat(src,span_warning("Autolaugh has been toggled on"))
	else
		to_chat(src,span_warning("Autolaugh has been toggled off"))

/mob/living/simple_mob/vore/demon/verb/manual_laugh()
	set name = "Laugh"
	set desc = "Plays the laugh track."
	set category = "Abilities.Demon"

	if(!enable_autolaugh) //yeah this is kinda sorta dirty but id rather use a bool over something else here to control this.
		enable_autolaugh = !enable_autolaugh
		laugh()
		enable_autolaugh = !enable_autolaugh
	else
		laugh()
	to_chat(src,span_warning("You laugh!")) //lets add some fluff response for clicking the feel good button.

/mob/living/simple_mob/vore/demon/verb/sizespell()
	set name = "Shrink/Grow Prey"
	set category = "Abilities.Demon"
	set desc = "Shrink/Grow someone nearby! (60 second cooldown)"
	set popup_menu = FALSE // Stop licking by accident! //Yes this is from lick code, sue me.

	var/obj/item/grab/G = src.get_active_hand()

	if(!istype(G))
		to_chat(src, span_warning("You must be grabbing a creature in your active hand to affect them."))
		return
	var/mob/living/carbon/human/T = G.affecting
	if(!istype(T))
		to_chat(src, span_warning("\The [T] is not able to be affected."))
		return

	if(G.state != GRAB_NECK)
		to_chat(src, span_warning("You must have a tighter grip to affect this creature."))
		return

	if(!checkClickCooldown() || incapacitated(INCAPACITATION_ALL))
		return

	setClickCooldown(8)
	T.resize(size_amount)
	visible_message(span_warning("[src] shrinks [T]!"),span_notice("You shrink [T]."))

/mob/living/simple_mob/vore/demon
	var/size_amount = RESIZE_TINY //Adding a var to keep track of sizespell setting

/mob/living/simple_mob/vore/demon/verb/toggle_sizespell()
	set name = "Shrink/Grow Amount"
	set desc = "Changes the amount you grow/shrink people."
	set category = "Abilities.Demon"

	var/size_select = tgui_input_number(src, "Put the desired size ([RESIZE_MINIMUM * 100]-[RESIZE_MAXIMUM * 100]%)", "Set Size", size_amount * 100, RESIZE_MAXIMUM * 100, RESIZE_MINIMUM * 100) //Stolen from sizegun code
	if(!size_select)
		return
	size_amount = (size_select/100)
	to_chat(src,span_notice("Size spell set to [size_select]%")) //Telling the user the new amount

/mob/living/simple_mob/vore/demon/verb/demon_bite()
	set name = "Mindbreaker Bite"
	set category = "Abilities.Demon"
	set desc = "Inject mindbreaker into your grabbed prey!"
	set popup_menu = FALSE // Stop licking by accident! //Yes this is from lick code, sue me.

	var/obj/item/grab/G = src.get_active_hand()

	if(!istype(G))
		to_chat(src, span_warning("You must be grabbing a creature in your active hand to affect them."))
		return
	var/mob/living/carbon/human/T = G.affecting
	if(!istype(T))
		to_chat(src, span_warning("\The [T] is not able to be affected."))
		return

	if(G.state != GRAB_NECK)
		to_chat(src, span_warning("You must have a tighter grip to affect this creature."))
		return

	if(!checkClickCooldown() || incapacitated(INCAPACITATION_ALL))
		return

	setClickCooldown(8)
	T.reagents.add_reagent(poison_type, poison_per_bite)
	visible_message(span_warning("[src] bites [T]!"),span_notice("You bite [T]."))
