/////////////////////
///  PHASE SHIFT  ///
/////////////////////
//Visual effect for phase in/out
/obj/effect/temp_visual/shadekin
	randomdir = FALSE
	duration = 5
	icon = 'icons/mob/vore_shadekin.dmi'

/obj/effect/temp_visual/shadekin/phase_in
	icon_state = "tp_in"

/obj/effect/temp_visual/shadekin/phase_out
	icon_state = "tp_out"

/datum/power/shadekin/phase_shift
	name = "Phase Shift (100)"
	desc = "Shift yourself out of alignment with realspace to travel quickly to different areas."
	verbpath = /mob/living/proc/phase_shift
	ability_icon_state = "phase_shift"

/mob/living/proc/phase_shift()
	set name = "Phase Shift (100)"
	set desc = "Shift yourself out of alignment with realspace to travel quickly to different areas."
	set category = "Abilities.Shadekin"

	var/datum/component/shadekin/SK = get_shadekin_component()
	if(!SK)
		return FALSE
	if(stat)
		to_chat(src, span_warning("Can't use that ability in your state!"))
		return FALSE
	var/area/A = get_area(src)
	if(!client?.holder && A.flag_check(AREA_BLOCK_PHASE_SHIFT))
		to_chat(src, span_warning("You can't do that here!"))
		return

	var/ability_cost = 100

	var/darkness = 1
	var/turf/T = get_turf(src)
	if(!T)
		to_chat(src,span_warning("You can't use that here!"))
		return FALSE

	if(SK.doing_phase)
		return FALSE

	var/brightness = T.get_lumcount() //Brightness in 0.0 to 1.0
	darkness = 1-brightness //Invert

	var/watcher = 0
	for(var/mob/living/carbon/human/watchers in oview(7,src ))	// If we can see them...
		if(watchers in oviewers(7,src))	// And they can see us...
			if(!(watchers.stat) && !isbelly(watchers.loc) && !istype(watchers.loc, /obj/item/holder))	// And they are alive and not being held by someone...
				watcher++	// They are watching us!

	ability_cost = CLAMP(ability_cost/(0.01+darkness*2),50, 80)//This allows for 1 watcher in full light
	if(watcher>0)
		ability_cost = ability_cost + ( 15 * watcher )
	/*
	if(!(SK.in_phase))
		log_debug("[src] attempted to shift with [watcher] visible Carbons with a  cost of [ability_cost] in a darkness level of [darkness]")
	*/

	if(SK.doing_phase)
		to_chat(src, span_warning("You are already trying to phase!"))
		return FALSE
	else if(SK.shadekin_get_energy() < ability_cost && !(SK.in_phase))
		to_chat(src, span_warning("Not enough energy for that ability!"))
		return FALSE

	if(!(SK.in_phase))
		SK.shadekin_adjust_energy(-ability_cost)
	playsound(src, 'sound/effects/stealthoff.ogg', 75, 1)

	if(!T.CanPass(src,T) || loc != T)
		to_chat(src,span_warning("You can't use that here!"))
		return FALSE

	//Shifting in
	if(SK.in_phase)
		phase_in(T, SK)
	//Shifting out
	else
		phase_out(T, SK)


/mob/living/proc/phase_in(var/turf/T, var/datum/component/shadekin/SK)
	if(SK.in_phase)

		// pre-change
		if(!isturf(T)) //Sanity
			return
		forceMove(T)
		var/original_canmove = canmove
		SetStunned(0)
		SetWeakened(0)
		if(buckled)
			buckled.unbuckle_mob()
		if(pulledby)
			pulledby.stop_pulling()
		stop_pulling()

		// change
		canmove = FALSE
		SK.in_phase = FALSE
		SK.doing_phase = TRUE
		throwpass = FALSE
		name = get_visible_name()
		for(var/obj/belly/B as anything in vore_organs)
			B.escapable = initial(B.escapable)

		//cut_overlays()
		invisibility = initial(invisibility)
		see_invisible = initial(see_invisible)
		incorporeal_move = initial(incorporeal_move)
		density = initial(density)
		can_pull_size = initial(can_pull_size)
		can_pull_mobs = initial(can_pull_mobs)
		hovering = initial(hovering)
		update_icon()

		//Cosmetics mostly
		var/obj/effect/temp_visual/shadekin/phase_in/phaseanim = new /obj/effect/temp_visual/shadekin/phase_in(src.loc)
		phaseanim.pixel_y = (src.size_multiplier - 1) * 16 // Pixel shift for the animation placement
		phaseanim.adjust_scale(src.size_multiplier, src.size_multiplier)
		phaseanim.dir = dir
		alpha = 0
		automatic_custom_emote(VISIBLE_MESSAGE,"phases in!")

		addtimer(CALLBACK(src, PROC_REF(shadekin_complete_phase_in), original_canmove, SK), 5, TIMER_DELETE_ME)


/mob/living/proc/shadekin_complete_phase_in(var/original_canmove, var/datum/component/shadekin/SK)
	canmove = original_canmove
	alpha = initial(alpha)
	remove_modifiers_of_type(/datum/modifier/shadekin_phase_vision)
	remove_modifiers_of_type(/datum/modifier/phased_out)

	//Potential phase-in vore

	if(can_be_drop_pred || can_be_drop_prey) //Toggleable in vore panel
		var/list/potentials = living_mobs(0)
		var/mob/living/our_prey
		if(potentials.len)
			var/mob/living/target = pick(potentials)
			if(can_be_drop_pred && istype(target) && target.devourable && target.can_be_drop_prey && target.phase_vore && vore_selected && phase_vore)
				target.forceMove(vore_selected)
				to_chat(target, span_vwarning("\The [src] phases in around you, [vore_selected.vore_verb]ing you into their [vore_selected.name]!"))
				to_chat(src, span_vwarning("You phase around [target], [vore_selected.vore_verb]ing them into your [vore_selected.name]!"))
				our_prey = target
			else if(can_be_drop_prey && istype(target) && devourable && target.can_be_drop_pred && target.phase_vore && target.vore_selected && phase_vore)
				our_prey = src
				forceMove(target.vore_selected)
				to_chat(target, span_vwarning("\The [src] phases into you, [target.vore_selected.vore_verb]ing them into your [target.vore_selected.name]!"))
				to_chat(src, span_vwarning("You phase into [target], having them [target.vore_selected.vore_verb] you into their [target.vore_selected.name]!"))
			if(our_prey)
				for(var/obj/item/flashlight/held_lights in our_prey.contents)
					if(istype(held_lights,/obj/item/flashlight/glowstick) ||istype(held_lights,/obj/item/flashlight/flare) ) //No affecting glowsticks or flares...As funny as that is
						continue
					held_lights.on = 0
					held_lights.update_brightness()

	SK.doing_phase = FALSE
	if(!SK.flicker_time)
		return //Early return. No time, no flickering.
	//Affect nearby lights
	for(var/obj/machinery/light/L in range(SK.flicker_distance, src))
		if(prob(SK.flicker_break_chance))
			addtimer(CALLBACK(L, TYPE_PROC_REF(/obj/machinery/light, broken)), rand(5,25), TIMER_DELETE_ME)
		else
			if(SK.flicker_color)
				L.flicker(SK.flicker_time, SK.flicker_color)
			else
				L.flicker(SK.flicker_time)
	for(var/obj/item/flashlight/flashlights in range(SK.flicker_distance, src)) //Find any flashlights near us and make them flicker too!
		if(istype(flashlights,/obj/item/flashlight/glowstick) ||istype(flashlights,/obj/item/flashlight/flare)) //No affecting glowsticks or flares...As funny as that is
			continue
		flashlights.flicker(SK.flicker_time, SK.flicker_color, TRUE)
	for(var/mob/living/creatures in range(SK.flicker_distance, src))
		if(isbelly(creatures.loc)) //don't flicker anyone that gets nomphed.
			continue
		for(var/obj/item/flashlight/held_lights in creatures.contents)
			if(istype(held_lights,/obj/item/flashlight/glowstick) ||istype(held_lights,/obj/item/flashlight/flare) ) //No affecting glowsticks or flares...As funny as that is
				continue
			held_lights.flicker(SK.flicker_time, SK.flicker_color, TRUE)

/mob/living/proc/phase_out(var/turf/T)
	var/datum/component/shadekin/SK = get_shadekin_component()
	if(!(SK.in_phase))
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
		if(SK.normal_phase && SK.drop_items_on_phase)
			drop_both_hands()
			if(back)
				unEquip(back)

		can_pull_size = 0
		can_pull_mobs = MOB_PULL_NONE
		hovering = TRUE
		canmove = FALSE

		// change
		SK.in_phase = TRUE
		SK.doing_phase = TRUE
		throwpass = TRUE
		automatic_custom_emote(VISIBLE_MESSAGE,"phases out!")

		if(real_name) //If we a real name, perfect, let's just set our name to our newfound visible name.
			name = get_visible_name()
		else //If we don't, let's put our real_name as our initial name.
			real_name = initial(name)
			name = get_visible_name()

		for(var/obj/belly/B as anything in vore_organs)
			B.escapable = FALSE

		var/obj/effect/temp_visual/shadekin/phase_out/phaseanim = new /obj/effect/temp_visual/shadekin/phase_out(src.loc)
		phaseanim.pixel_y = (src.size_multiplier - 1) * 16 // Pixel shift for the animation placement
		phaseanim.adjust_scale(src.size_multiplier, src.size_multiplier)
		phaseanim.dir = dir
		alpha = 0
		add_modifier(/datum/modifier/shadekin_phase_vision)
		if(SK.normal_phase)
			add_modifier(/datum/modifier/phased_out)
		addtimer(CALLBACK(src, PROC_REF(complete_phase_out), original_canmove, SK), 5, TIMER_DELETE_ME)


/mob/living/proc/complete_phase_out(original_canmove, var/datum/component/shadekin/SK)
	invisibility = INVISIBILITY_SHADEKIN
	see_invisible = INVISIBILITY_SHADEKIN
	see_invisible_default = INVISIBILITY_SHADEKIN // Allow seeing phased entities while phased.
	update_icon()
	alpha = 127

	canmove = original_canmove
	incorporeal_move = TRUE
	density = FALSE
	SK.doing_phase = FALSE

/datum/modifier/shadekin_phase_vision
	name = "Shadekin Phase Vision"
	vision_flags = SEE_THRU

/datum/modifier/phased_out
	name = "Phased Out"
	desc = "You are currently phased out of realspace, and cannot interact with it."
	hidden = TRUE
	//Stops you from using guns. See /obj/item/gun/proc/special_check(var/mob/user)
