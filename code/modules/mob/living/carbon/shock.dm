/mob/living/var/traumatic_shock = 0
/mob/living/carbon/var/shock_stage = 0

// proc to find out in how much pain the mob is at the moment
/mob/living/carbon/proc/updateshock()
	if (!can_feel_pain())
		src.traumatic_shock = 0
		return 0

	src.traumatic_shock = 			\
	1	* src.getOxyLoss() + 		\
	0.7	* src.getToxLoss() + 		\
	1.2	* src.getShockFireLoss() + 		\
	1.2	* src.getShockBruteLoss() + 		\
	1.7	* src.getCloneLoss() + 		\
	2	* src.halloss

	if(src.slurring)
		src.traumatic_shock -= 20

	// broken or ripped off organs will add quite a bit of pain
	if(ishuman(src))
		var/mob/living/carbon/human/M = src
		for(var/obj/item/organ/external/organ in M.organs)
			if(organ.is_broken() || organ.open)
				src.traumatic_shock += 30
			else if(organ.is_dislocated())
				src.traumatic_shock += 15

	// Some individuals/species are more or less supectible to pain. Default trauma_mod = 1. Does not affect painkillers
	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		H.traumatic_shock *= H.species.trauma_mod

	src.traumatic_shock += -1 *  src.chem_effects[CE_PAINKILLER]

	if(src.traumatic_shock < 0)
		src.traumatic_shock = 0

	return src.traumatic_shock


/mob/living/carbon/proc/handle_shock()
	updateshock()
