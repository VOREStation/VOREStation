//////////////////////////////////////////////////////////////////////////////////////
///////////////////////////// SPECIAL ITEMS/REAGENTS !!!! ////////////////////////////
////////////////////////////////////////////////////////////////////////////////////// //keeping most of these the same except the stuff that apply to the standard synx. -lo
/*
/datum/seed/hardlightseed/
	name = PLANT_NULLHARDLIGHT
	seed_name = "Biomechanical Hardlight generator seed"
	display_name = "Biomechanical Hardlight stem"
	mutants = null
	can_self_harvest = 1
	has_mob_product = null

/datum/seed/hardlightseed/New()
	..()
	set_trait(TRAIT_IMMUTABLE,1) //Normal genetics wont be able to do much with the mechanical parts, its more a machine than a real plant
	set_trait(TRAIT_MATURATION,1)
	set_trait(TRAIT_PRODUCTION,1)
	set_trait(TRAIT_YIELD,1)
	set_trait(TRAIT_POTENCY,1)
	set_trait(TRAIT_PRODUCT_ICON,"alien4")
	set_trait(TRAIT_PRODUCT_COLOUR,"#00FFFF")
	set_trait(TRAIT_PLANT_COLOUR,"#00FFFF")
	set_trait(TRAIT_PLANT_ICON,"alien4") //spooky pods
	set_trait(TRAIT_IDEAL_HEAT, 283)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0)
	set_trait(TRAIT_WATER_CONSUMPTION, 0)

/datum/seed/hardlightseed/typesx //Respawn mechanism for the synx
	name = "hardlightseedsx"
	seed_name = "hardlightseedsx"
	display_name = "Biomechanical Hardlight Generator SX"//PLant that is part mechanical part biological
	has_mob_product = /mob/living/simple_mob/animal/synx/ai/pet/holo
*/ //This is defined in seed_datums_ch

/obj/item/seeds/hardlightseed/typesx
	seed_type = "hardlightseedsx"

/datum/reagent/inaprovaline/synxchem
	name = "Alien nerveinhibitor"
	description = "A toxin that slowly metabolizes damaging the person, but makes them unable to feel pain."
	id = "synxchem"
	metabolism = REM * 0.1 //Slow metabolization to try and mimic permanent nerve damage without actually being too cruel to people
	color = "#FFFFFF"
	overdose = REAGENTS_OVERDOSE * 4 //But takes a lot to OD

/datum/reagent/inaprovaline/synxchem/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien != IS_DIONA)
		if(prob(8))
			M.custom_pain("You [pick("feel numb!","feel dizzy and heavy.","feel strange!")]",60)
		if(prob(2))
			M.custom_pain("You [pick("suddenly lose control over your body!", "can't move!", "are frozen in place.", "can't struggle!")]",60)
			M.AdjustParalysis(1)
//		M.add_chemical_effect(CE_STABLE, 15)
		M.add_chemical_effect(CE_PAINKILLER, 60)
		// M.adjustToxLoss(0.4) //Dealing twice of it as tox, even if you have no brute, its not true conversion. Synxchem without stomach shoved out of its mouth isn't going to do tox. -Lo
	//	M.adjustHalLoss(1) //we do not need halloss as well as paralyze. lo-

/datum/reagent/inaprovaline/synxchem/holo
	name = "SX type simulation nanomachines" //Educational!
	description = "Type SX nanomachines to simulate what it feels like to come in contact with a synx, minus the damage"
	id = "fakesynxchem"
	metabolism = REM * 1 //ten times faster for convenience of testers.
	color = "#00FFFF"
	overdose = REAGENTS_OVERDOSE * 20 //it's all fake. But having nanomachines move through you is not good at a certain amount.

/datum/reagent/inaprovaline/synxchem/holo/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien != IS_DIONA)
		if(prob(5))
			M.custom_pain("You feel no pain!",60)
		if(prob(2))
			M.custom_pain("You suddenly lose control over your body!",60)
			M.AdjustParalysis(1)
		M.add_chemical_effect(CE_STABLE, 15)
		M.add_chemical_effect(CE_PAINKILLER, 50)
		M.adjustBruteLoss(-0.2)//Made to simulate combat, also useful as very odd healer.
		M.adjustToxLoss(-0.2) //HELP ITS MAULING ME!
		M.adjustFireLoss(-0.2) //huh this mauling aint so bad
		//M.adjustHalLoss(10) //OH MY GOD END MY PAIN NOW WHO MADE THIS SIMULATION //Removing because this is spammy and stunlocks for absurd durations

/datum/reagent/inaprovaline/synxchem/clown
	name = "HONK"
	description = "HONK"
	id = "clownsynxchem"
	metabolism = REM * 0.5
	color = "#FFFFFF"
	overdose = REAGENTS_OVERDOSE * 200

/datum/reagent/inaprovaline/synxchem/clown/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.adjustToxLoss(0.01)
	playsound(M.loc, 'sound/items/bikehorn.ogg', 50, 1)
	M.adjustBruteLoss(-2)//healing brute
	if(prob(1))
		M.custom_pain("I have no horn but i must honk!",60)
	if(prob(2))
		var/location = get_turf(M)
		new /obj/item/bikehorn(location)
		M.custom_pain("You suddenly cough up a bikehorn!",60)

/*why is this in here twice? -Lo
	/datum/reagent/inaprovaline/synxchem/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
		if(alien != IS_DIONA)
		if(prob(5))
			M.custom_pain("You feel no pain despite the clear signs of damage to your body!",0)
		if(prob(2))
			M.custom_pain("You suddenly lose control over your body!",0)
			M.AdjustParalysis(1)
		M.add_chemical_effect(CE_STABLE, 15)
		M.add_chemical_effect(CE_PAINKILLER, 50)
		M.adjustBruteLoss(-0.2)//healing brute
		M.adjustToxLoss(0.1) //Dealing half of it as tox
		M.adjustHalLoss(1) //dealing 5 times the amount of brute healed as halo, but we cant feel pain yet
		// ^ I have no idea what this might cause, my ideal plan is that once the pain killer wears off you suddenly collapse;
		//Since Halloss is not "real" damage this should not cause death
*/

/datum/reagent/inaprovaline/synxchem/overdose(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(alien != IS_DIONA)
		M.make_dizzy(10)
		if(prob(5))
			M.AdjustStunned(1)
		if(prob(2))
			M.AdjustParalysis(1)


/datum/reagent/inaprovaline/synxchem/holo/overdose(var/mob/living/carbon/M, var/alien, var/removed)
	return

/datum/reagent/inaprovaline/synxchem/clown/overdose(var/mob/living/carbon/M, var/alien, var/removed)
	return
