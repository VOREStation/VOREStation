GLOBAL_LIST_INIT(digest_modes, list())

/datum/digest_mode
	var/id = DM_HOLD
	var/noise_chance = 0

/**
 * This proc has all the behavior for the given digestion mode.
 * It returns either null, or an associative list in the following format:
 * list("to_update" = TRUE/FALSE, "soundToPlay" = sound())
 * where to_update is whether or not a updateVorePanel() call is necessary,
 * and soundToPlay will play the given sound at the end of the process tick.
 */
/datum/digest_mode/proc/process_mob(obj/belly/B, mob/living/L)
	return null

/datum/digest_mode/digest
	id = DM_DIGEST
	noise_chance = 50

/datum/digest_mode/digest/process_mob(obj/belly/B, mob/living/L)
	//Pref protection!
	if(!L.digestable || L.absorbed)
		return null

	//Person just died in guts!
	if(L.stat == DEAD)
		if(L.is_preference_enabled(/datum/client_preference/digestion_noises))
			if(!B.fancy_vore)
				SEND_SOUND(L, sound(get_sfx("classic_death_sounds")))
			else
				SEND_SOUND(L, sound(get_sfx("fancy_death_prey")))
		B.handle_digestion_death(L)
		if(!B.fancy_vore)
			return list("to_update" = TRUE, "soundToPlay" = sound(get_sfx("classic_death_sounds")))
		return list("to_update" = TRUE, "soundToPlay" = sound(get_sfx("fancy_death_pred")))

	// Deal digestion damage (and feed the pred)
	var/old_brute = L.getBruteLoss()
	var/old_burn = L.getFireLoss()
	L.adjustBruteLoss(B.digest_brute)
	L.adjustFireLoss(B.digest_burn)
	var/actual_brute = L.getBruteLoss() - old_brute
	var/actual_burn = L.getFireLoss() - old_burn
	var/damage_gain = (actual_brute + actual_burn)*(B.nutrition_percent / 100)

	var/offset = (1 + ((L.weight - 137) / 137)) // 130 pounds = .95 140 pounds = 1.02
	var/difference = B.owner.size_multiplier / L.size_multiplier
	if(isrobot(B.owner))
		var/mob/living/silicon/robot/R = B.owner
		R.cell.charge += 25 * damage_gain
	if(offset) // If any different than default weight, multiply the % of offset.
		B.owner.adjust_nutrition(offset*(4.5 * (damage_gain) / difference)) //4.5 nutrition points per health point. Normal same size 100+100 health prey with average weight would give 900 points if the digestion was instant. With all the size/weight offset taxes plus over time oxyloss+hunger taxes deducted with non-instant digestion, this should be enough to not leave the pred starved.
	else
		B.owner.adjust_nutrition(4.5 * (damage_gain) / difference)

/datum/digest_mode/absorb
	id = DM_ABSORB
	noise_chance = 10

/datum/digest_mode/absorb/process_mob(obj/belly/B, mob/living/L)
	if(!L.absorbable || L.absorbed)
		return null
	B.steal_nutrition(L)
	if(L.nutrition < 100)
		B.absorb_living(L)
		return list("to_update" = TRUE)

/datum/digest_mode/unabsorb
	id = DM_UNABSORB

/datum/digest_mode/unabsorb/process_mob(obj/belly/B, mob/living/L)
	if(L.absorbed && B.owner.nutrition >= 100)
		L.absorbed = FALSE
		to_chat(L, "<span class='notice'>You suddenly feel solid again.</span>")
		to_chat(B.owner,"<span class='notice'>You feel like a part of you is missing.</span>")
		B.owner.adjust_nutrition(-100)
		return list("to_update" = TRUE)

/datum/digest_mode/drain
	id = DM_DRAIN
	noise_chance = 10

/datum/digest_mode/drain/process_mob(obj/belly/B, mob/living/L)
	B.steal_nutrition(L)

/datum/digest_mode/drain/shrink
	id = DM_SHRINK

/datum/digest_mode/drain/shrink/process_mob(obj/belly/B, mob/living/L)
	if(L.size_multiplier > B.shrink_grow_size)
		L.resize(L.size_multiplier - 0.01) // Shrink by 1% per tick
		. = ..()

/datum/digest_mode/grow
	id = DM_GROW
	noise_chance = 10

/datum/digest_mode/grow/process_mob(obj/belly/B, mob/living/L)
	if(L.size_multiplier < B.shrink_grow_size)
		L.resize(L.size_multiplier + 0.01) // Shrink by 1% per tick

/datum/digest_mode/drain/sizesteal
	id = DM_SIZE_STEAL

/datum/digest_mode/drain/sizesteal/process_mob(obj/belly/B, mob/living/L)
	if(L.size_multiplier > B.shrink_grow_size && B.owner.size_multiplier < 2) //Grow until either pred is large or prey is small.
		B.owner.resize(B.owner.size_multiplier + 0.01) //Grow by 1% per tick.
		L.resize(L.size_multiplier - 0.01) //Shrink by 1% per tick
		. = ..()

/datum/digest_mode/heal
	id = DM_HEAL
	noise_chance = 50 //Wet heals! The secret is you can leave this on for gurgle noises for fun.

/datum/digest_mode/heal/process_mob(obj/belly/B, mob/living/L)
	if(L.stat == DEAD)
		return null // Can't heal the dead with healbelly
	if(B.owner.nutrition > 90 && (L.health < L.maxHealth))
		L.adjustBruteLoss(-2.5)
		L.adjustFireLoss(-2.5)
		L.adjustToxLoss(-5)
		L.adjustOxyLoss(-5)
		L.adjustCloneLoss(-1.25)
		B.owner.adjust_nutrition(-2)
		if(L.nutrition <= 400)
			L.adjust_nutrition(1)
	else if(B.owner.nutrition > 90 && (L.nutrition <= 400))
		B.owner.adjust_nutrition(-1)
		L.adjust_nutrition(1)

// TRANSFORM MODES
/datum/digest_mode/transform
	var/stabilize_nutrition = FALSE
	var/changes_eyes = FALSE
	var/changes_hair_solo = FALSE
	var/changes_hairandskin = FALSE
	var/changes_gender = FALSE
	var/changes_gender_to = null
	var/changes_species = FALSE
	var/changes_ears_tail_wing_nocolor = FALSE
	var/changes_ears_tail_wing_color = FALSE
	var/eggs = FALSE

/datum/digest_mode/transform/process_mob(obj/belly/B, mob/living/carbon/human/H)
	if(!istype(H) || H.stat == DEAD)
		return null
	if(stabilize_nutrition)
		if(B.owner.nutrition > 400 && H.nutrition < 400)
			B.owner.adjust_nutrition(-2)
			H.adjust_nutrition(1.5)
	var/datum/species/target_species = H.species
	if(!((target_species.spawn_flags & SPECIES_IS_WHITELISTED) || (target_species.spawn_flags & SPECIES_IS_RESTRICTED)))
		if(changes_eyes && B.check_eyes(H))
			B.change_eyes(H, 1)
			return null
		if(changes_hair_solo && B.check_hair(H))
			B.change_hair(H)
			return null
		if(changes_hairandskin && (B.check_hair(H) || B.check_skin(H)))
			B.change_hair(H)
			B.change_skin(H, 1)
			return null
		if(changes_species)
			if(changes_ears_tail_wing_nocolor && (B.check_ears(H) || B.check_tail_nocolor(H) || B.check_wing_nocolor(H) || B.check_species(H)))
				B.change_ears(H)
				B.change_tail_nocolor(H)
				B.change_wing_nocolor(H)
				B.change_species(H, 1, 1) // ,1) preserves coloring
				H.species.create_organs(H)
				H.sync_organ_dna()
				return null
			if(changes_ears_tail_wing_color && (B.check_ears(H) || B.check_tail(H) || B.check_wing(H) || B.check_species(H)))
				B.change_ears(H)
				B.change_tail(H)
				B.change_wing(H)
				B.change_species(H, 1, 2) // ,2) does not preserve coloring.
				H.species.create_organs(H)
				H.sync_organ_dna()
				return null
	if(changes_gender && B.check_gender(H, changes_gender_to))
		B.change_gender(H, changes_gender_to, 1)
		return null
	if(eggs && (!H.absorbed))
		B.put_in_egg(H, 1)
		return null

// Regular TF Modes
/datum/digest_mode/transform/hairandeyes
	id = DM_TRANSFORM_HAIR_AND_EYES
	stabilize_nutrition = TRUE
	changes_eyes = TRUE
	changes_hair_solo = TRUE

/datum/digest_mode/transform/gender
	id = DM_TRANSFORM_FEMALE
	changes_eyes = TRUE
	changes_hairandskin = TRUE
	changes_gender = TRUE
	changes_gender_to = FEMALE
	stabilize_nutrition = TRUE

/datum/digest_mode/transform/gender/male
	id = DM_TRANSFORM_FEMALE
	changes_gender_to = MALE

/datum/digest_mode/transform/keepgender
	id = DM_TRANSFORM_KEEP_GENDER
	changes_eyes = TRUE
	changes_hairandskin = TRUE
	stabilize_nutrition = TRUE

/datum/digest_mode/transform/speciesandtaur
	id = DM_TRANSFORM_CHANGE_SPECIES_AND_TAUR
	changes_species = TRUE
	changes_ears_tail_wing_nocolor = TRUE
	stabilize_nutrition = TRUE

/datum/digest_mode/transform/replica
	id = DM_TRANSFORM_REPLICA
	changes_eyes = TRUE
	changes_hairandskin = TRUE
	changes_species = TRUE
	changes_ears_tail_wing_color = TRUE

// E G G
/datum/digest_mode/transform/egg
	id = DM_EGG
	eggs = TRUE

/datum/digest_mode/transform/egg/gender
	id = DM_TRANSFORM_FEMALE_EGG
	changes_eyes = TRUE
	changes_hairandskin = TRUE
	changes_gender = TRUE
	changes_gender_to = FEMALE
	stabilize_nutrition = TRUE

/datum/digest_mode/transform/egg/gender/male
	id = DM_TRANSFORM_MALE_EGG
	changes_gender_to = MALE

/datum/digest_mode/transform/egg/nogender
	id = DM_TRANSFORM_KEEP_GENDER_EGG
	changes_eyes = TRUE
	changes_hairandskin = TRUE
	stabilize_nutrition = TRUE

/datum/digest_mode/transform/egg/speciesandtaur
	id = DM_TRANSFORM_CHANGE_SPECIES_AND_TAUR_EGG
	changes_species = TRUE
	changes_ears_tail_wing_nocolor = TRUE
	stabilize_nutrition = TRUE

/datum/digest_mode/transform/egg/replica
	id = DM_TRANSFORM_REPLICA_EGG
	changes_eyes = TRUE
	changes_hairandskin = TRUE
	changes_species = TRUE
	changes_ears_tail_wing_color = TRUE