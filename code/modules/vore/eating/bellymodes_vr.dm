// Process the predator's effects upon the contents of its belly (i.e digestion/transformation etc)
/obj/belly/proc/process_belly(var/times_fired,var/wait) //Passed by controller
	if((times_fired < next_process) || !contents.len)
		recent_sound = FALSE
		return SSBELLIES_IGNORED

	if(loc != owner)
		if(istype(owner))
			loc = owner
		else
			qdel(src)
			return SSBELLIES_PROCESSED

	next_process = times_fired + (6 SECONDS/wait) //Set up our next process time.
	var/play_sound //Potential sound to play at the end to avoid code duplication.
	var/to_update = FALSE //Did anything update worthy happen?

/////////////////////////// Auto-Emotes ///////////////////////////
	if(contents.len && next_emote <= times_fired)
		next_emote = times_fired + round(emote_time/wait,1)
		var/list/EL = emote_lists[digest_mode]
		if(LAZYLEN(EL))
			for(var/mob/living/M in contents)
				if(M.digestable || digest_mode != DM_DIGEST) // don't give digesty messages to indigestible people
					to_chat(M,"<span class='notice'>[pick(EL)]</span>")

/////////////////////////// Exit Early ////////////////////////////
	var/list/touchable_atoms = contents - items_preserved
	if(!length(touchable_atoms))
		return SSBELLIES_PROCESSED

	var/list/touchable_mobs = list()

///////////////////// Early Non-Mode Handling /////////////////////
	var/did_an_item = FALSE
	for(var/A in touchable_atoms)
		//Handle stray items
		if(isitem(A) && !did_an_item)
			var/obj/item/I = A
			if(mode_flags & DM_FLAG_ITEMWEAK)
				I.gurgle_contaminate(contents, cont_flavor)
				items_preserved |= I
				to_update = TRUE
			else
				digest_item(I)
			to_update = TRUE
			did_an_item = TRUE

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

				//Stripping flag
				if(mode_flags & DM_FLAG_STRIPPING)
					for(var/slot in slots)
						var/obj/item/I = H.get_equipped_item(slot = slot)
						if(I)
							H.unEquip(I,force = TRUE)
							if(mode_flags & DM_FLAG_ITEMWEAK)
								I.gurgle_contaminate(contents, cont_flavor)
								items_preserved |= I
							else
								digest_item(I)
							to_update = TRUE
							break

///////////////////////////// DM_HOLD /////////////////////////////
	if(digest_mode == DM_HOLD)
		return SSBELLIES_PROCESSED //Pretty boring, huh

//////////////////////////// DM_DIGEST ////////////////////////////
	else if(digest_mode == DM_DIGEST)

		if(prob(50)) //Was SO OFTEN. AAAA.
			play_sound = pick(digestion_sounds)

		for (var/target in touchable_mobs)
			var/mob/living/M = target
			//Pref protection!
			if (!M.digestable || M.absorbed)
				continue

			//Person just died in guts!
			if(M.stat == DEAD)
				var/digest_alert_owner = pick(digest_messages_owner)
				var/digest_alert_prey = pick(digest_messages_prey)
				var/compensation = M.getOxyLoss() //How much of the prey's damage was caused by passive crit oxyloss to compensate the lost nutrition.

				//Replace placeholder vars
				digest_alert_owner = replacetext(digest_alert_owner,"%pred",owner)
				digest_alert_owner = replacetext(digest_alert_owner,"%prey",M)
				digest_alert_owner = replacetext(digest_alert_owner,"%belly",lowertext(name))

				digest_alert_prey = replacetext(digest_alert_prey,"%pred",owner)
				digest_alert_prey = replacetext(digest_alert_prey,"%prey",M)
				digest_alert_prey = replacetext(digest_alert_prey,"%belly",lowertext(name))

				//Send messages
				to_chat(owner,"<span class='notice'>" + digest_alert_owner + "</span>")
				to_chat(M,"<span class='notice'>" + digest_alert_prey + "</span>")

				play_sound = pick(death_sounds)
				digestion_death(M)
				owner.update_icons()
				if(compensation > 0)
					if(isrobot(owner))
						var/mob/living/silicon/robot/R = owner
						R.cell.charge += 25*compensation
					else
						owner.nutrition += 4.5*compensation
				to_update = TRUE

				continue

			// Deal digestion damage (and feed the pred)
			var/old_brute = M.getBruteLoss()
			var/old_burn = M.getFireLoss()
			M.adjustBruteLoss(digest_brute)
			M.adjustFireLoss(digest_burn)
			var/actual_brute = M.getBruteLoss() - old_brute
			var/actual_burn = M.getFireLoss() - old_burn
			var/damage_gain = actual_brute + actual_burn

			var/offset = (1 + ((M.weight - 137) / 137)) // 130 pounds = .95 140 pounds = 1.02
			var/difference = owner.size_multiplier / M.size_multiplier
			if(isrobot(owner))
				var/mob/living/silicon/robot/R = owner
				R.cell.charge += 25*damage_gain
			if(offset) // If any different than default weight, multiply the % of offset.
				owner.nutrition += offset*(4.5*(damage_gain)/difference) //4.5 nutrition points per health point. Normal same size 100+100 health prey with average weight would give 900 points if the digestion was instant. With all the size/weight offset taxes plus over time oxyloss+hunger taxes deducted with non-instant digestion, this should be enough to not leave the pred starved.
			else
				owner.nutrition += 4.5*(damage_gain)/difference


//////////////////////////// DM_ABSORB ////////////////////////////
	else if(digest_mode == DM_ABSORB)

		for (var/target in touchable_mobs)
			var/mob/living/M = target
			if(prob(10)) //Less often than gurgles. People might leave this on forever.
				play_sound = pick(digestion_sounds)

			if(M.absorbed)
				continue

			if(M.nutrition >= 100) //Drain them until there's no nutrients left. Slowly "absorb" them.
				var/oldnutrition = (M.nutrition * 0.05)
				M.nutrition = (M.nutrition * 0.95)
				owner.nutrition += oldnutrition
			else if(M.nutrition < 100) //When they're finally drained.
				absorb_living(M)
				to_update = TRUE

//////////////////////////// DM_UNABSORB ////////////////////////////
	else if(digest_mode == DM_UNABSORB)

		for (var/target in touchable_mobs)
			var/mob/living/M = target

			if(M.absorbed && owner.nutrition >= 100)
				M.absorbed = 0
				to_chat(M,"<span class='notice'>You suddenly feel solid again </span>")
				to_chat(owner,"<span class='notice'>You feel like a part of you is missing.</span>")
				owner.nutrition -= 100
				to_update = TRUE

//////////////////////////// DM_DRAIN ////////////////////////////
	else if(digest_mode == DM_DRAIN)

		for (var/target in touchable_mobs)
			var/mob/living/M = target

			if(prob(10)) //Less often than gurgles. People might leave this on forever.
				play_sound = pick(digestion_sounds)

			if(M.nutrition >= 100) //Drain them until there's no nutrients left.
				var/oldnutrition = (M.nutrition * 0.05)
				M.nutrition = (M.nutrition * 0.95)
				owner.nutrition += oldnutrition

//////////////////////////// DM_SHRINK ////////////////////////////
	else if(digest_mode == DM_SHRINK)

		for (var/target in touchable_mobs)
			var/mob/living/M = target

			if(prob(10)) //Infinite gurgles!
				play_sound = pick(digestion_sounds)

			if(M.size_multiplier > shrink_grow_size) //Shrink until smol.
				M.resize(M.size_multiplier-0.01) //Shrink by 1% per tick.

				if(M.nutrition >= 100) //Absorbing bodymass results in nutrition if possible.
					var/oldnutrition = (M.nutrition * 0.05)
					M.nutrition = (M.nutrition * 0.95)
					owner.nutrition += oldnutrition

//////////////////////////// DM_GROW ////////////////////////////
	else if(digest_mode == DM_GROW)

		for (var/target in touchable_mobs)
			var/mob/living/M = target

			if(prob(10))
				play_sound = pick(digestion_sounds)

			if(M.size_multiplier < shrink_grow_size) //Grow until large.
				M.resize(M.size_multiplier+0.01) //Grow by 1% per tick.
				if(M.nutrition >= 100)
					owner.nutrition = (owner.nutrition * 0.95)

//////////////////////////// DM_SIZE_STEAL ////////////////////////////
	else if(digest_mode == DM_SIZE_STEAL)

		for (var/target in touchable_mobs)
			var/mob/living/M = target

			if(prob(10))
				play_sound = pick(digestion_sounds)

			if(M.size_multiplier > shrink_grow_size && owner.size_multiplier < 2) //Grow until either pred is large or prey is small.
				owner.resize(owner.size_multiplier+0.01) //Grow by 1% per tick.
				M.resize(M.size_multiplier-0.01) //Shrink by 1% per tick

				if(M.nutrition >= 100)
					var/oldnutrition = (M.nutrition * 0.05)
					M.nutrition = (M.nutrition * 0.95)
					owner.nutrition += oldnutrition

///////////////////////////// DM_HEAL /////////////////////////////
	else if(digest_mode == DM_HEAL)

		if(prob(50)) //Wet heals! The secret is you can leave this on for gurgle noises for fun.
			play_sound = pick(digestion_sounds)

		for (var/target in touchable_mobs)
			var/mob/living/M = target

			if(M.stat == DEAD)
				continue

			if(owner.nutrition > 90 && (M.health < M.maxHealth))
				M.adjustBruteLoss(-5)
				M.adjustFireLoss(-5)
				owner.nutrition -= 2
				if(M.nutrition <= 400)
					M.nutrition += 1
			else if(owner.nutrition > 90 && (M.nutrition <= 400))
				owner.nutrition -= 1
				M.nutrition += 1

/////////////////////////// DM_TRANSFORM ///////////////////////////
	else if(digest_mode == DM_TRANSFORM)
		process_tf(tf_mode, touchable_mobs)

/////////////////////////// Make any noise ///////////////////////////
	if(play_sound)
		playsound(src, play_sound, vol = 100, vary = 1, falloff = VORE_SOUND_FALLOFF, ignore_walls = TRUE, preference = /datum/client_preference/digestion_noises)
	if(to_update)
		for(var/mob/living/M in contents)
			if(M.client)
				M.updateVRPanel()
		if(owner.client)
			owner.updateVRPanel()

	return SSBELLIES_PROCESSED
