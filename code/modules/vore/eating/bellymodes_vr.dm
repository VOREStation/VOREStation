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

/////////////////////////// Auto-Emotes ///////////////////////////
	if(contents.len && next_emote <= times_fired)
		next_emote = times_fired + round(emote_time/wait,1)
		var/list/EL = emote_lists[digest_mode]
		for(var/mob/living/M in contents)
			if(M.digestable || !(digest_mode == DM_DIGEST || digest_mode == DM_DIGEST_NUMB || digest_mode == DM_ITEMWEAK)) // don't give digesty messages to indigestible people
				to_chat(M,"<span class='notice'>[pick(EL)]</span>")

/////////////////////////// Exit Early ////////////////////////////
	var/list/touchable_items = contents - items_preserved
	if(!length(touchable_items))
		return SSBELLIES_PROCESSED

//////////////////////// Absorbed Handling ////////////////////////
	for(var/mob/living/M in contents)
		if(M.absorbed)
			M.Weaken(5)

///////////////////////////// DM_HOLD /////////////////////////////
	if(digest_mode == DM_HOLD)
		return SSBELLIES_PROCESSED //Pretty boring, huh

//////////////////////////// DM_DIGEST ////////////////////////////
	else if(digest_mode == DM_DIGEST || digest_mode == DM_DIGEST_NUMB || digest_mode == DM_ITEMWEAK)

		if(prob(50)) //Was SO OFTEN. AAAA.
			play_sound = pick(digestion_sounds)

		for (var/mob/living/M in contents)
			//Pref protection!
			if (!M.digestable || M.absorbed)
				continue

			//Person just died in guts!
			if(M.stat == DEAD)
				var/digest_alert_owner = pick(digest_messages_owner)
				var/digest_alert_prey = pick(digest_messages_prey)

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
				continue

			if(digest_mode == DM_DIGEST_NUMB && ishuman(M))
				var/mob/living/carbon/human/H = M
				if(H.bloodstr.get_reagent_amount("numbenzyme") < 5)
					H.bloodstr.add_reagent("numbenzyme",10)

			// Deal digestion damage (and feed the pred)
			M.adjustBruteLoss(digest_brute)
			M.adjustFireLoss(digest_burn)

			var/offset = (1 + ((M.weight - 137) / 137)) // 130 pounds = .95 140 pounds = 1.02
			var/difference = owner.size_multiplier / M.size_multiplier
			if(isrobot(owner))
				var/mob/living/silicon/robot/R = owner
				R.cell.charge += 20*(digest_brute+digest_burn)
			if(offset) // If any different than default weight, multiply the % of offset.
				owner.nutrition += offset*(2*(digest_brute+digest_burn)/difference) // 9.5 nutrition per digestion tick if they're 130 pounds and it's same size. 10.2 per digestion tick if they're 140 and it's same size. Etc etc.
			else
				owner.nutrition += 2*(digest_brute+digest_burn)/difference
			M.updateVRPanel()

		//Contaminate or gurgle items
		var/obj/item/T = pick(touchable_items)
		if(istype(T))
			if(digest_mode == DM_ITEMWEAK)
				if(istype(T,/obj/item/weapon/reagent_containers/food) || istype(T,/obj/item/weapon/holder) || istype(T,/obj/item/organ))
					digest_item(T)
				else
					T.gurgle_contaminate(contents, owner)
					items_preserved |= T
			else
				digest_item(T)

		owner.updateVRPanel()

//////////////////////////// DM_STRIPDIGEST ////////////////////////////
	else if(digest_mode == DM_STRIPDIGEST) // Only gurgle the gear off your prey.

		if(prob(50))
			play_sound = pick(digestion_sounds)

		// Handle loose items first.
		var/obj/item/T = pick(touchable_items)
		if(istype(T))
			digest_item(T)

		for(var/mob/living/carbon/human/M in contents)
			if (M.absorbed)
				continue
			for(var/slot in slots)
				var/obj/item/thingy = M.get_equipped_item(slot = slot)
				if(thingy)
					M.unEquip(thingy,force = TRUE)
					thingy.forceMove(owner)
					contents |= thingy
					digest_item(T)
			M.updateVRPanel()

		owner.updateVRPanel()

//////////////////////////// DM_ABSORB ////////////////////////////
	else if(digest_mode == DM_ABSORB)

		for (var/mob/living/M in contents)

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

//////////////////////////// DM_UNABSORB ////////////////////////////
	else if(digest_mode == DM_UNABSORB)

		for (var/mob/living/M in contents)
			if(M.absorbed && owner.nutrition >= 100)
				M.absorbed = 0
				to_chat(M,"<span class='notice'>You suddenly feel solid again </span>")
				to_chat(owner,"<span class='notice'>You feel like a part of you is missing.</span>")
				owner.nutrition -= 100

//////////////////////////// DM_DRAIN ////////////////////////////
	else if(digest_mode == DM_DRAIN)

		for (var/mob/living/M in contents)

			if(prob(10)) //Less often than gurgles. People might leave this on forever.
				play_sound = pick(digestion_sounds)

			if(M.nutrition >= 100) //Drain them until there's no nutrients left.
				var/oldnutrition = (M.nutrition * 0.05)
				M.nutrition = (M.nutrition * 0.95)
				owner.nutrition += oldnutrition

//////////////////////////// DM_SHRINK ////////////////////////////
	else if(digest_mode == DM_SHRINK)

		for (var/mob/living/M in contents)

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

		for (var/mob/living/M in contents)

			if(prob(10))
				play_sound = pick(digestion_sounds)

			if(M.size_multiplier < shrink_grow_size) //Grow until large.
				M.resize(M.size_multiplier+0.01) //Grow by 1% per tick.
				if(M.nutrition >= 100)
					owner.nutrition = (owner.nutrition * 0.95)

//////////////////////////// DM_SIZE_STEAL ////////////////////////////
	else if(digest_mode == DM_SIZE_STEAL)

		for (var/mob/living/M in contents)

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
		if(prob(50)) //Wet heals!
			play_sound = pick(digestion_sounds)

		for (var/mob/living/M in contents)
			if(M.stat != DEAD)
				if(owner.nutrition > 90 && (M.health < M.maxHealth))
					M.adjustBruteLoss(-5)
					M.adjustFireLoss(-5)
					owner.nutrition -= 2
					if(M.nutrition <= 400)
						M.nutrition += 1
				else if(owner.nutrition > 90 && (M.nutrition <= 400))
					owner.nutrition -= 1
					M.nutrition += 1

///////////////////////////// DM_TRANSFORM_HAIR_AND_EYES /////////////////////////////
	else if(digest_mode == DM_TRANSFORM_HAIR_AND_EYES && ishuman(owner))
		for (var/mob/living/carbon/human/P in contents)
			if(P.stat == DEAD)
				continue

			var/mob/living/carbon/human/O = owner

			if(O.nutrition > 400 && P.nutrition < 400)
				O.nutrition -= 2
				P.nutrition += 1.5

			if(check_eyes(P) || check_hair(P))
				change_eyes(P)
				change_hair(P,1)

///////////////////////////// DM_TRANSFORM_MALE /////////////////////////////
	else if(digest_mode == DM_TRANSFORM_MALE && ishuman(owner))
		for (var/mob/living/carbon/human/P in contents)
			if(P.stat == DEAD)
				continue

			var/mob/living/carbon/human/O = owner

			if(O.nutrition > 400 && P.nutrition < 400)
				O.nutrition -= 2
				P.nutrition += 1.5

			if(check_eyes(P))
				change_eyes(P,1)
				continue

			if(check_hair(P) || check_skin(P))
				change_hair(P)
				change_skin(P,1)
				continue

			if(check_gender(P,MALE))
				change_gender(P,MALE,1)

///////////////////////////// DM_TRANSFORM_FEMALE /////////////////////////////
	else if(digest_mode == DM_TRANSFORM_FEMALE && ishuman(owner))
		for (var/mob/living/carbon/human/P in contents)
			if(P.stat == DEAD)
				continue

			var/mob/living/carbon/human/O = owner

			if(O.nutrition > 400 && P.nutrition < 400)
				O.nutrition -= 2
				P.nutrition += 1.5

			if(check_eyes(P))
				change_eyes(P,1)
				continue

			if(check_hair(P) || check_skin(P))
				change_hair(P)
				change_skin(P,1)
				continue

			if(check_gender(P,FEMALE))
				change_gender(P,FEMALE,1)

///////////////////////////// DM_TRANSFORM_KEEP_GENDER  /////////////////////////////
	else if(digest_mode == DM_TRANSFORM_KEEP_GENDER && ishuman(owner))
		for (var/mob/living/carbon/human/P in contents)
			if(P.stat == DEAD)
				continue

			var/mob/living/carbon/human/O = owner

			if(O.nutrition > 400 && P.nutrition < 400)
				O.nutrition -= 2
				P.nutrition += 1.5

			if(check_eyes(P))
				change_eyes(P,1)
				continue

			if(check_hair(P) || check_skin(P))
				change_hair(P)
				change_skin(P,1)

///////////////////////////// DM_TRANSFORM_CHANGE_SPECIES_AND_TAUR  /////////////////////////////
	else if(digest_mode == DM_TRANSFORM_CHANGE_SPECIES_AND_TAUR && ishuman(owner))
		for (var/mob/living/carbon/human/P in contents)
			if(P.stat == DEAD)
				continue

			var/mob/living/carbon/human/O = owner

			if(O.nutrition > 400 && P.nutrition < 400)
				O.nutrition -= 2
				P.nutrition += 1.5

			if(check_ears(P) || check_tail_nocolor(P) || check_wing_nocolor(P) || check_species(P))
				change_ears(P)
				change_tail_nocolor(P)
				change_wing_nocolor(P)
				change_species(P,1)

///////////////////////////// DM_TRANSFORM_REPLICA /////////////////////////////
	else if(digest_mode == DM_TRANSFORM_REPLICA && ishuman(owner))
		for (var/mob/living/carbon/human/P in contents)
			if(P.stat == DEAD)
				continue

			var/mob/living/carbon/human/O = owner

			if(O.nutrition > 400 && P.nutrition < 400)
				O.nutrition -= 2
				P.nutrition += 1.5

			if(check_eyes(P))
				change_eyes(P,1)
				continue

			if(check_hair(P) || check_skin(P))
				change_hair(P)
				change_skin(P,1)
				continue

			if(check_ears(P) || check_tail(P) || check_wing(P) || check_species(P))
				change_ears(P)
				change_tail(P)
				change_wing(P)
				change_species(P,1)

///////////////////////////// DM_TRANSFORM_CHANGE_SPECIES_AND_TAUR_EGG /////////////////////////////
	else if(digest_mode == DM_TRANSFORM_CHANGE_SPECIES_AND_TAUR_EGG && ishuman(owner))
		for (var/mob/living/carbon/human/P in contents)
			if(P.stat == DEAD)
				continue

			if(check_ears(P) || check_tail_nocolor(P) || check_wing_nocolor(P)|| check_species(P))
				change_ears(P)
				change_tail_nocolor(P)
				change_wing_nocolor(P)
				change_species(P,1)
				continue

			if(!P.absorbed)
				put_in_egg(P,1)

///////////////////////////// DM_TRANSFORM_KEEP_GENDER_EGG  /////////////////////////////
	else if(digest_mode == DM_TRANSFORM_KEEP_GENDER_EGG && ishuman(owner))
		for (var/mob/living/carbon/human/P in contents)
			if(P.stat == DEAD)
				continue

			if(check_eyes(P))
				change_eyes(P,1)
				continue

			if(check_hair(P) || check_skin(P))
				change_hair(P)
				change_skin(P,1)
				continue

			if(!P.absorbed)
				put_in_egg(P,1)

///////////////////////////// DM_TRANSFORM_REPLICA_EGG /////////////////////////////
	else if(digest_mode == DM_TRANSFORM_REPLICA_EGG && ishuman(owner))
		for (var/mob/living/carbon/human/P in contents)
			if(P.stat == DEAD)
				continue

			if(check_eyes(P))
				change_eyes(P,1)
				continue

			if(check_hair(P) || check_skin(P))
				change_hair(P)
				change_skin(P,1)
				continue

			if(check_ears(P) || check_tail(P) || check_wing(P) || check_species(P))
				change_ears(P)
				change_tail(P)
				change_wing(P)
				change_species(P,1)
				continue

			if(!P.absorbed)
				put_in_egg(P,1)

///////////////////////////// DM_TRANSFORM_MALE_EGG /////////////////////////////
	else if(digest_mode == DM_TRANSFORM_MALE_EGG && ishuman(owner))
		for (var/mob/living/carbon/human/P in contents)
			if(P.stat == DEAD)
				continue

			if(check_eyes(P))
				change_eyes(P,1)
				continue

			if(check_hair(P) || check_skin(P))
				change_hair(P)
				change_skin(P,1)
				continue

			if(check_gender(P,MALE))
				change_gender(P,MALE,1)
				continue

			if(!P.absorbed)
				put_in_egg(P,1)

///////////////////////////// DM_TRANSFORM_FEMALE_EGG /////////////////////////////
	else if(digest_mode == DM_TRANSFORM_FEMALE_EGG && ishuman(owner))
		for (var/mob/living/carbon/human/P in contents)
			if(P.stat == DEAD)
				continue

			if(check_eyes(P))
				change_eyes(P,1)
				continue

			if(check_hair(P) || check_skin(P))
				change_hair(P)
				change_skin(P,1)
				continue

			if(check_gender(P,MALE))
				change_gender(P,MALE,1)
				continue

			if(!P.absorbed)
				put_in_egg(P,1)

///////////////////////////// DM_EGG /////////////////////////////
	else if(digest_mode == DM_EGG && ishuman(owner))
		for (var/mob/living/carbon/human/P in contents)
			if(P.absorbed || P.stat == DEAD)
				continue

			put_in_egg(P,1)

	if(play_sound)
		for (var/mob/living/M in contents)
			M << sound(play_sound)
		playsound(src, play_sound, vol = 100, vary = 1, falloff = VORE_SOUND_FALLOFF, ignore_walls = FALSE, preference = /datum/client_preference/digestion_noises)
	return SSBELLIES_PROCESSED
