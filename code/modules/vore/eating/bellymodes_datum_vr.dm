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

/datum/digest_mode/proc/handle_atoms(obj/belly/B, list/touchable_atoms)
    return FALSE

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

// E G G
/datum/digest_mode/egg
	id = DM_EGG
/*
/datum/digest_mode/egg/process_mob(obj/belly/B, mob/living/carbon/human/H)
	if(!istype(H) || H.stat == DEAD || H.absorbed)
		return null
	B.put_in_egg(H, 1)*/

/datum/digest_mode/egg/handle_atoms(obj/belly/B, list/touchable_atoms)
	var/list/egg_contents = list()
	for(var/E in touchable_atoms)
		if(istype(E, /obj/item/weapon/storage/vore_egg)) // Don't egg other eggs.
			continue
		if(isliving(E))
			var/mob/living/L = E
			if(L.absorbed)
				continue
			egg_contents += L
		if(isitem(E))
			egg_contents += E
	if(egg_contents.len)
		if(!B.ownegg)
			if(B.egg_type in tf_vore_egg_types)
				B.egg_path = tf_vore_egg_types[B.egg_type]
			B.ownegg = new B.egg_path(B)
		for(var/atom/movable/C in egg_contents)
			if(isitem(C) && egg_contents.len == 1) //Only egging one item
				var/obj/item/I = C
				B.ownegg.w_class = I.w_class
				B.ownegg.max_storage_space = B.ownegg.w_class
				I.forceMove(B.ownegg)
				B.ownegg.icon_scale_x = 0.2 * B.ownegg.w_class
				B.ownegg.icon_scale_y = 0.2 * B.ownegg.w_class
				B.ownegg.update_transform()
				egg_contents -= I
				B.ownegg = null
				return
			if(isliving(C))
				var/mob/living/M = C
				B.ownegg.w_class = M.size_multiplier * 4 //Egg size and weight scaled to match occupant.
				var/obj/item/weapon/holder/H = new M.holder_type(B.ownegg)
				H.held_mob = M
				M.forceMove(H)
				H.sync(M)
				B.ownegg.max_storage_space = H.w_class
				B.ownegg.icon_scale_x = 0.25 * B.ownegg.w_class
				B.ownegg.icon_scale_y = 0.25 * B.ownegg.w_class
				B.ownegg.update_transform()
				egg_contents -= M
				if(B.ownegg.w_class > 4)
					B.ownegg.slowdown = B.ownegg.w_class - 4
				B.ownegg = null
				return
			C.forceMove(B.ownegg)
			if(isitem(C))
				var/obj/item/I = C
				B.ownegg.w_class += I.w_class //Let's assume a regular outfit can reach total w_class of 16.
		B.ownegg.calibrate_size()
		B.ownegg.orient2hud()
		B.ownegg.w_class = clamp(B.ownegg.w_class * 0.25, 1, 8) //A total w_class of 16 will result in a backpack sized egg.
		B.ownegg.icon_scale_x = 0.25 * B.ownegg.w_class
		B.ownegg.icon_scale_y = 0.25 * B.ownegg.w_class
		B.ownegg.update_transform()
		if(B.ownegg.w_class > 4)
			B.ownegg.slowdown = B.ownegg.w_class - 4
		B.ownegg = null
	return