/mob/living/var/traumatic_shock = 0
/mob/living/carbon/var/shock_stage = 0

// proc to find out in how much pain the mob is at the moment
/mob/living/carbon/proc/updateshock()
	if (!can_feel_pain() && !synth_cosmetic_pain)
		traumatic_shock = 0
		return 0

	traumatic_shock = 			\
	1	* getOxyLoss() + 		\
	0.7	* getToxLoss() + 		\
	1.2	* getShockFireLoss() + 		\
	1.2	* getShockBruteLoss() + 		\
	1.7	* getCloneLoss() + 		\
	2	* getHalLoss()

	if(slurring)
		traumatic_shock -= 20

	// broken or ripped off organs will add quite a bit of pain
	if(ishuman(src))
		var/mob/living/carbon/human/M = src
		for(var/obj/item/organ/external/organ in M.organs)
			if(!organ.organ_can_feel_pain())
				continue
			if(organ.is_broken() || organ.open)
				traumatic_shock += 30
			else if(organ.is_dislocated())
				traumatic_shock += 15

	// Some individuals/species are more or less supectible to pain. Default pain_mod = 1. Does not affect painkillers
	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		H.traumatic_shock *= H.species.pain_mod

	traumatic_shock += -1 *  chem_effects[CE_PAINKILLER]

	if(traumatic_shock < 0)
		traumatic_shock = 0

	return traumatic_shock


/mob/living/carbon/proc/handle_shock()
	updateshock()
