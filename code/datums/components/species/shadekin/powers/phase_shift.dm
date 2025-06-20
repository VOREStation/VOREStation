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
		force_max_speed = initial(force_max_speed)
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

	//Potential phase-in vore
	if(can_be_drop_pred) //Toggleable in vore panel
		var/list/potentials = living_mobs(0)
		if(potentials.len)
			var/mob/living/target = pick(potentials)
			if(istype(target) && target.devourable && target.can_be_drop_prey && target.phase_vore && vore_selected && phase_vore)
				target.forceMove(vore_selected)
				to_chat(target,span_vwarning("\The [src] phases in around you, [vore_selected.vore_verb]ing you into their [vore_selected.name]!"))

	SK.doing_phase = FALSE

	//Affect nearby lights
	var/destroy_lights = 0
	if(SK.phase_gentle)
		Stun(1)
	for(var/obj/machinery/light/L in GLOB.machines)
		if(L.z != z || get_dist(src,L) > 10)
			continue
		if(SK.phase_gentle)
			L.flicker(1)
		else if(prob(destroy_lights))
			addtimer(CALLBACK(L, TYPE_PROC_REF(/obj/machinery/light, broken)), rand(5,25), TIMER_DELETE_ME)
		else
			L.flicker(10)

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
		canmove = FALSE

		// change
		SK.in_phase = TRUE
		SK.doing_phase = TRUE
		throwpass = TRUE
		automatic_custom_emote(VISIBLE_MESSAGE,"phases out!")
		name = get_visible_name()

		for(var/obj/belly/B as anything in vore_organs)
			B.escapable = FALSE

		var/obj/effect/temp_visual/shadekin/phase_out/phaseanim = new /obj/effect/temp_visual/shadekin/phase_out(src.loc)
		phaseanim.pixel_y = (src.size_multiplier - 1) * 16 // Pixel shift for the animation placement
		phaseanim.adjust_scale(src.size_multiplier, src.size_multiplier)
		phaseanim.dir = dir
		alpha = 0
		add_modifier(/datum/modifier/shadekin_phase_vision)
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
