// Process the predator's effects upon the contents of its belly (i.e digestion/transformation etc)
/obj/belly/proc/process_belly(times_fired, wait) //Passed by controller
	if((times_fired < next_process) || !contents.len)
		recent_sound = FALSE
		return SSBELLIES_IGNORED

	if(loc != owner)
		if(istype(owner))
			loc = owner
		else
			qdel(src)
			return SSBELLIES_PROCESSED

	next_process = times_fired + (6 SECONDS / wait) //Set up our next process time.

	var/play_sound //Potential sound to play at the end to avoid code duplication.
	var/to_update = FALSE //Did anything update worthy happen?

///////////////////// Prey Loop Refresh/hack //////////////////////
	prey_loop()

/////////////////////////// Sound Selections ///////////////////////////
	var/sound/prey_digest
	var/sound/prey_death
	var/sound/pred_digest
	var/sound/pred_death
	if(!fancy_vore)
		prey_digest = sound(get_sfx("classic_digestion_sounds"))
		prey_death = sound(get_sfx("classic_death_sounds"))
		pred_digest = sound(get_sfx("classic_digestion_sounds"))
		pred_death = sound(get_sfx("classic_death_sounds"))
	else
		prey_digest = sound(get_sfx("fancy_digest_prey"))
		prey_death = sound(get_sfx("fancy_death_prey"))
		pred_digest = sound(get_sfx("fancy_digest_pred"))
		pred_death = sound(get_sfx("fancy_death_pred"))

/////////////////////////// Exit Early ////////////////////////////
	var/list/touchable_atoms = contents - items_preserved
	if(!length(touchable_atoms))
		return SSBELLIES_PROCESSED

	var/list/touchable_mobs = list()

///////////////////// Early Non-Mode Handling /////////////////////
	if(contents.len && next_emote <= times_fired)
		next_emote = times_fired + round(emote_time/wait,1)
		var/list/EL = emote_lists[digest_mode]
		if(LAZYLEN(EL))
			for(var/mob/living/M in contents)
				if(M.digestable || digest_mode != DM_DIGEST) // don't give digesty messages to indigestible people
					to_chat(M, "<span class='notice'>[pick(EL)]</span>")

	var/did_an_item = FALSE // Only do one item per cycle.
	var/digestion_noise_chance = 0

	for(var/A in touchable_atoms)
		//Handle stray items
		if(isitem(A) && !did_an_item)
			did_an_item = handle_digesting_item(A)
			if(did_an_item)
				to_update = TRUE

			//Less often than with normal digestion
			if((item_digest_mode == IM_DIGEST_FOOD || item_digest_mode == IM_DIGEST) && prob(25))
				// This is a little weird, but the point of it is that we don't want to repeat code
				// but we also want the prob(25) chance to run for -every- item we look at, not just once
				// More gurgles the better~
				digestion_noise_chance = 25

		//Handle eaten mobs
		else if(isliving(A))
			var/mob/living/L = A
			touchable_mobs += L

			if(L.absorbed)
				L.Weaken(5)

			//Handle 'human'
			if(ishuman(L))
				var/mob/living/carbon/human/H = L

				//Numbing flag
				if(mode_flags & DM_FLAG_NUMBING)
					if(H.bloodstr.get_reagent_amount("numbenzyme") < 2)
						H.bloodstr.add_reagent("numbenzyme",4)

				//Thickbelly flag
				if((mode_flags & DM_FLAG_THICKBELLY) && !H.muffled)
					H.muffled = TRUE

				//Stripping flag
				if(mode_flags & DM_FLAG_STRIPPING)
					for(var/slot in slots)
						var/obj/item/I = H.get_equipped_item(slot = slot)
						if(I && H.unEquip(I, force = FALSE))
							handle_digesting_item(I)
							digestion_noise_chance = 25
							to_update = TRUE
							break // Digest off one by one, not all at once
							
		//get rid of things like blood drops and gibs that end up in there
		else if(istype(A, /obj/effect/decal/cleanable))
			qdel(A)

	if(digest_mode == DM_HOLD)
		//We deliberately do not want any gurgly noises if the belly is in DM_HOLD
		if(to_update)
			updateVRPanels()
		return SSBELLIES_PROCESSED 

	if(digest_mode == DM_TRANSFORM)
		process_tf(tf_mode, touchable_mobs)

	for(var/target in touchable_mobs)
		var/mob/living/L = target
		if(!istype(L))
			continue
		switch(digest_mode)
			if(DM_DIGEST)
				digestion_noise_chance = 50			
				//Pref protection!
				if(!L.digestable || L.absorbed)
					continue

				//Person just died in guts!
				if(L.stat == DEAD)
					play_sound = pred_death
					if(L.is_preference_enabled(/datum/client_preference/digestion_noises))
						SEND_SOUND(L, prey_death)
					handle_digestion_death(L)
					to_update = TRUE
					continue

				// Deal digestion damage (and feed the pred)
				var/old_brute = L.getBruteLoss()
				var/old_burn = L.getFireLoss()
				L.adjustBruteLoss(digest_brute)
				L.adjustFireLoss(digest_burn)
				var/actual_brute = L.getBruteLoss() - old_brute
				var/actual_burn = L.getFireLoss() - old_burn
				var/damage_gain = actual_brute + actual_burn

				var/offset = (1 + ((L.weight - 137) / 137)) // 130 pounds = .95 140 pounds = 1.02
				var/difference = owner.size_multiplier / L.size_multiplier
				if(isrobot(owner))
					var/mob/living/silicon/robot/R = owner
					R.cell.charge += 25 * damage_gain
				if(offset) // If any different than default weight, multiply the % of offset.
					owner.nutrition += offset*((nutrition_percent / 100) * 4.5 * (damage_gain) / difference) //4.5 nutrition points per health point. Normal same size 100+100 health prey with average weight would give 900 points if the digestion was instant. With all the size/weight offset taxes plus over time oxyloss+hunger taxes deducted with non-instant digestion, this should be enough to not leave the pred starved.
				else
					owner.nutrition += (nutrition_percent / 100) * 4.5 * (damage_gain) / difference
			if(DM_ABSORB)
				if(!L.absorbable || L.absorbed)
					continue
				digestion_noise_chance = 10
				steal_nutrition(L)
				if(L.nutrition < 100)
					absorb_living(L)
					to_update = TRUE
			if(DM_UNABSORB)
				if(L.absorbed && owner.nutrition >= 100)
					L.absorbed = FALSE
					to_chat(L, "<span class='notice'>You suddenly feel solid again.</span>")
					to_chat(owner,"<span class='notice'>You feel like a part of you is missing.</span>")
					owner.nutrition -= 100
					to_update = TRUE
			if(DM_DRAIN)
				digestion_noise_chance = 10
				steal_nutrition(L)
			if(DM_SHRINK)
				digestion_noise_chance = 10
				if(L.size_multiplier > shrink_grow_size)
					L.resize(L.size_multiplier - 0.01) // Shrink by 1% per tick
					steal_nutrition(L)
			if(DM_GROW)
				digestion_noise_chance = 10
				if(L.size_multiplier < shrink_grow_size)
					L.resize(L.size_multiplier - 0.01) // Grow by 1% per tick
			if(DM_SIZE_STEAL)
				digestion_noise_chance = 10
				if(L.size_multiplier > shrink_grow_size && owner.size_multiplier < 2) //Grow until either pred is large or prey is small.
					owner.resize(owner.size_multiplier+0.01) //Grow by 1% per tick.
					L.resize(L.size_multiplier-0.01) //Shrink by 1% per tick
					steal_nutrition(L)
			if(DM_HEAL)
				digestion_noise_chance = 50 //Wet heals! The secret is you can leave this on for gurgle noises for fun.
				if(L.stat == DEAD)
					continue // Can't heal the dead with healbelly
				if(owner.nutrition > 90 && (L.health < L.maxHealth))
					L.adjustBruteLoss(-2.5)
					L.adjustFireLoss(-2.5)
					L.adjustToxLoss(-5)
					L.adjustOxyLoss(-5)
					L.adjustCloneLoss(-1.25)
					owner.nutrition -= 2
					if(L.nutrition <= 400)
						L.nutrition += 1
				else if(owner.nutrition > 90 && (L.nutrition <= 400))
					owner.nutrition -= 1
					L.nutrition += 1

/////////////////////////// Make any noise ///////////////////////////
	if(digestion_noise_chance && prob(digestion_noise_chance))
		for(var/mob/M in contents)
			if(M && M.is_preference_enabled(/datum/client_preference/digestion_noises))
				SEND_SOUND(M, prey_digest)
		play_sound = pred_digest

	if(play_sound)
		for(var/mob/M in hearers(VORE_SOUND_RANGE, owner)) //so we don't fill the whole room with the sound effect
			if(!M.is_preference_enabled(/datum/client_preference/digestion_noises))
				continue
			if(isturf(M.loc) || (M.loc != src)) //to avoid people on the inside getting the outside sounds and their direct sounds + built in sound pref check
				if(fancy_vore)
					M.playsound_local(owner.loc, play_sound, vol = 75, vary = 1, falloff = VORE_SOUND_FALLOFF)
				else
					M.playsound_local(owner.loc, play_sound, vol = 100, vary = 1, falloff = VORE_SOUND_FALLOFF)
				 //these are all external sound triggers now, so it's ok.
	
	if(to_update)
		updateVRPanels()

	return SSBELLIES_PROCESSED

/obj/belly/proc/prey_loop()
	for(var/mob/living/M in contents)
		//We don't bother executing any other code if the prey doesn't want to hear the noises.
		if(!M.is_preference_enabled(/datum/client_preference/digestion_noises))
			M.stop_sound_channel(CHANNEL_PREYLOOP) // sanity just in case, because byond is whack and you can't trust it
			continue

		// We don't want the sounds to overlap, but we do want them to steadily replay.
		// We also don't want the sounds to play if the pred hasn't marked this belly as fleshy, or doesn't
		// have the right sounds to play.
		if(isbelly(M.loc) && is_wet && wet_loop && (world.time > M.next_preyloop))
			M.stop_sound_channel(CHANNEL_PREYLOOP)
			var/sound/preyloop = sound('sound/vore/sunesound/prey/loop.ogg')
			M.playsound_local(get_turf(src), preyloop, 80, 0, channel = CHANNEL_PREYLOOP)
			M.next_preyloop = (world.time + (52 SECONDS))

/obj/belly/proc/handle_digesting_item(obj/item/I)
	var/did_an_item = FALSE
	// We always contaminate IDs.
	if(contaminates || istype(I, /obj/item/weapon/card/id))
		I.gurgle_contaminate(src, contamination_flavor, contamination_color)

	switch(item_digest_mode)
		if(IM_HOLD)
			items_preserved |= I
		if(IM_DIGEST_FOOD)
			if(istype(I,/obj/item/weapon/reagent_containers/food) || istype(I, /obj/item/organ))
				did_an_item = digest_item(I)
			else
				items_preserved |= I
		if(IM_DIGEST)
			did_an_item = digest_item(I)
	return did_an_item

/obj/belly/proc/handle_digestion_death(mob/living/M)
	var/digest_alert_owner = pick(digest_messages_owner)
	var/digest_alert_prey = pick(digest_messages_prey)
	var/compensation = M.getOxyLoss() //How much of the prey's damage was caused by passive crit oxyloss to compensate the lost nutrition.

	//Replace placeholder vars
	digest_alert_owner = replacetext(digest_alert_owner, "%pred", owner)
	digest_alert_owner = replacetext(digest_alert_owner, "%prey", M)
	digest_alert_owner = replacetext(digest_alert_owner, "%belly", lowertext(name))

	digest_alert_prey = replacetext(digest_alert_prey, "%pred", owner)
	digest_alert_prey = replacetext(digest_alert_prey, "%prey", M)
	digest_alert_prey = replacetext(digest_alert_prey, "%belly", lowertext(name))

	//Send messages
	to_chat(owner, "<span class='notice'>[digest_alert_owner]</span>")
	to_chat(M, "<span class='notice'>[digest_alert_prey]</span>")

	if((mode_flags & DM_FLAG_LEAVEREMAINS) && M.digest_leave_remains)
		handle_remains_leaving(M)
	digestion_death(M)
	if(!ishuman(owner))
		owner.update_icons()
	if(compensation == 0) //Slightly sloppy way at making sure certain mobs don't give ZERO nutrition (fish and so on)
		compensation = 21 //This reads as 20*4.5 due to the calculations afterward, making the backup nutrition value 94.5 per mob. Not op compared to regular prey.
	if(compensation > 0)
		if(isrobot(owner))
			var/mob/living/silicon/robot/R = owner
			R.cell.charge += 25*compensation
		else
			owner.nutrition += (nutrition_percent / 100)*4.5*compensation

/obj/belly/proc/steal_nutrition(mob/living/L)
	if(L.nutrition >= 100)
		var/oldnutrition = (L.nutrition * 0.05)
		L.nutrition = (L.nutrition * 0.95)
		owner.nutrition += oldnutrition

/obj/belly/proc/updateVRPanels()
	for(var/mob/living/M in contents)
		if(M.client)
			M.updateVRPanel()
	if(owner.client)
		owner.updateVRPanel()