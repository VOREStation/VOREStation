/datum/element/slosh
	element_flags = ELEMENT_DETACH_ON_HOST_DESTROY|ELEMENT_BESPOKE
	var/step_count
	var/vore_organs_reagents
	var/vore_footstep_volume
	var/vore_footstep_chance

/datum/element/slosh/Attach(datum/target)
	. = ..()
	if(!isliving(target))
		return ELEMENT_INCOMPATIBLE

	RegisterSignal(target, COMSIG_MOVABLE_MOVED, PROC_REF(handle_sloshstep), override = TRUE)
	step_count = 0
	vore_organs_reagents = list()
	vore_footstep_volume = 0
	vore_footstep_chance = 0
	return

/datum/element/slosh/Detach(datum/source)
	UnregisterSignal(source, COMSIG_MOVABLE_MOVED)
	return ..()

/datum/element/slosh/proc/handle_sloshstep(mob/living/source)
	SIGNAL_HANDLER

	if(ishuman(source))
		var/mob/living/carbon/human/source_human = source
		if(source_human.m_intent == I_WALK && step_count++ % 20 == 0)
			return
		if(source_human.m_intent == I_RUN && step_count++ % 2 != 0)
			return
		choose_vorefootstep(source)
	if(issilicon(source))
		if(step_count++ % 2)
			choose_vorefootstep(source)


/datum/element/slosh/proc/choose_vorefootstep(mob/living/source)
	if(step_count++ >= 5)

		vore_organs_reagents = list()
		var/highest_vol = 0

		for(var/obj/belly/B in source.vore_organs)
			var/total_volume = B.reagents.total_volume
			vore_organs_reagents += total_volume

			if(B.show_liquids && B.vorefootsteps_sounds && highest_vol < total_volume)
				highest_vol = total_volume

		if(highest_vol < 20)
			vore_footstep_volume = 0
			vore_footstep_chance = 0
		else
			vore_footstep_volume = 20 + highest_vol * 4/5
			vore_footstep_chance = highest_vol/4

		step_count = 0

		if(!vore_footstep_volume || !vore_footstep_chance)
			return

		if(prob(vore_footstep_chance))
			handle_vorefootstep(source)

/datum/element/slosh/proc/handle_vorefootstep(mob/living/source)
	if(!CONFIG_GET(number/vorefootstep_volume) || !vore_footstep_volume)
		return

	var/S = pick(GLOB.slosh)
	if(!S) return
	var/volume = CONFIG_GET(number/vorefootstep_volume) * (vore_footstep_volume/100)

	if(ishuman(source))
		var/mob/living/carbon/human/human_source = source

		if(!human_source.shoes || human_source.m_intent == I_WALK)
			volume = CONFIG_GET(number/vorefootstep_volume) * (vore_footstep_volume/100) * 0.75
		else if(human_source.shoes)
			var/obj/item/clothing/shoes/feet = human_source.shoes
			if(istype(feet))
				volume = feet.step_volume_mod * CONFIG_GET(number/vorefootstep_volume) * (vore_footstep_volume/100) * 0.75
		if(!human_source.has_organ(BP_L_FOOT) && !human_source.has_organ(BP_R_FOOT))
			return

	if(source.buckled || source.lying || source.throwing || source.is_incorporeal())
		return
	if(!get_gravity(source) && prob(75))
		return

	playsound(source.loc, S, volume, FALSE, preference = /datum/preference/toggle/digestion_noises)
	return
