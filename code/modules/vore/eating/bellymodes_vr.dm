// Process the predator's effects upon the contents of its belly (i.e digestion/transformation etc)
// Called from /mob/living/Life() proc.
/datum/belly/proc/process_Life()

/////////////////////////// Auto-Emotes ///////////////////////////
	if((digest_mode in emote_lists) && !emotePend)
		emotePend = TRUE

		spawn(emoteTime)
			var/list/EL = emote_lists[digest_mode]
			for(var/mob/living/M in internal_contents)
				M << "<span class='notice'>[pick(EL)]</span>"
			src.emotePend = FALSE

//////////////////////// Absorbed Handling ////////////////////////
	for(var/mob/living/M in internal_contents)
		if(M.absorbed)
			M.Weaken(5)

///////////////////////////// DM_HOLD /////////////////////////////
	if(digest_mode == DM_HOLD)
		return //Pretty boring, huh

//////////////////////////// DM_DIGEST ////////////////////////////
	if(digest_mode == DM_DIGEST || digest_mode == DM_DIGEST_NUMB || digest_mode == DM_ITEMWEAK)
		var/list/touchable_items = internal_contents - items_preserved
		if(!length(touchable_items))
			return

		if(prob(50)) //Was SO OFTEN. AAAA.
			var/churnsound = pick(digestion_sounds)
			for(var/mob/hearer in range(1,owner))
				hearer << sound(churnsound,volume=80)

		for (var/mob/living/M in internal_contents)
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
				owner << "<span class='notice'>" + digest_alert_owner + "</span>"
				M << "<span class='notice'>" + digest_alert_prey + "</span>"

				var/deathsound = pick(death_sounds)
				for(var/mob/hearer in range(1,owner))
					hearer << deathsound
				digestion_death(M)
				owner.update_icons()
				continue

			if(digest_mode == DM_DIGEST_NUMB && ishuman(M))
				var/mob/living/carbon/human/H = M
				if(H.bloodstr.get_reagent_amount("numbenzyme") < 5)
					H.bloodstr.add_reagent("numbenzyme",10)

			// Deal digestion damage (and feed the pred)
			if(!(M.status_flags & GODMODE))
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
				T.gurgle_contaminate(internal_contents, owner)
				items_preserved |= T
			else
				digest_item(T)

		owner.updateVRPanel()
		return

//////////////////////////// DM_STRIPDIGEST ////////////////////////////
	if(digest_mode == DM_STRIPDIGEST) // Only gurgle the gear off your prey.
		var/list/touchable_items = internal_contents - items_preserved
		if(!length(touchable_items))
			return

		if(prob(50))
			var/churnsound = pick(digestion_sounds)
			for(var/mob/hearer in range(1,owner))
				hearer << sound(churnsound,volume=80)

		// Handle loose items first.
		var/obj/item/T = pick(touchable_items)
		if(istype(T))
			digest_item(T)

		for(var/mob/living/carbon/human/M in internal_contents)
			if (M.absorbed)
				continue
			for(var/slot in slots)
				var/obj/item/thingy = M.get_equipped_item(slot = slot)
				if(thingy)
					M.unEquip(thingy,force = TRUE)
					thingy.forceMove(owner)
					internal_contents |= thingy
					digest_item(T)
			M.updateVRPanel()

		owner.updateVRPanel()
		return

//////////////////////////// DM_ABSORB ////////////////////////////
	if(digest_mode == DM_ABSORB)

		for (var/mob/living/M in internal_contents)

			if(prob(10)) //Less often than gurgles. People might leave this on forever.
				var/absorbsound = pick(digestion_sounds)
				M << sound(absorbsound,volume=80)
				owner << sound(absorbsound,volume=80)

			if(M.absorbed)
				continue

			if(M.nutrition >= 100) //Drain them until there's no nutrients left. Slowly "absorb" them.
				var/oldnutrition = (M.nutrition * 0.05)
				M.nutrition = (M.nutrition * 0.95)
				owner.nutrition += oldnutrition
			else if(M.nutrition < 100) //When they're finally drained.
				absorb_living(M)

		return



//////////////////////////// DM_UNABSORB ////////////////////////////
	if(digest_mode == DM_UNABSORB)

		for (var/mob/living/M in internal_contents)
			if(M.absorbed && owner.nutrition >= 100)
				M.absorbed = 0
				M << "<span class='notice'>You suddenly feel solid again </span>"
				owner << "<span class='notice'>You feel like a part of you is missing.</span>"
				owner.nutrition -= 100
		return


//////////////////////////// DM_DRAIN ////////////////////////////
	if(digest_mode == DM_DRAIN)

		for (var/mob/living/M in internal_contents)

			if(prob(10)) //Less often than gurgles. People might leave this on forever.
				var/drainsound = pick(digestion_sounds)
				M << sound(drainsound,volume=80)
				owner << sound(drainsound,volume=80)

			if(M.nutrition >= 100) //Drain them until there's no nutrients left.
				var/oldnutrition = (M.nutrition * 0.05)
				M.nutrition = (M.nutrition * 0.95)
				owner.nutrition += oldnutrition
				return
		return

//////////////////////////// DM_SHRINK ////////////////////////////
	if(digest_mode == DM_SHRINK)

		for (var/mob/living/M in internal_contents)

			if(prob(10)) //Infinite gurgles!
				var/shrinksound = pick(digestion_sounds)
				M << sound(shrinksound,volume=80)
				owner << sound(shrinksound,volume=80)

			if(M.size_multiplier > shrink_grow_size) //Shrink until smol.
				M.resize(M.size_multiplier-0.01) //Shrink by 1% per tick.
				if(M.nutrition >= 100) //Absorbing bodymass results in nutrition if possible.
					var/oldnutrition = (M.nutrition * 0.05)
					M.nutrition = (M.nutrition * 0.95)
					owner.nutrition += oldnutrition
				return
		return

//////////////////////////// DM_GROW ////////////////////////////
	if(digest_mode == DM_GROW)

		for (var/mob/living/M in internal_contents)

			if(prob(10))
				var/growsound = pick(digestion_sounds)
				M << sound(growsound,volume=80)
				owner << sound(growsound,volume=80)

			if(M.size_multiplier < shrink_grow_size) //Grow until large.
				M.resize(M.size_multiplier+0.01) //Grow by 1% per tick.
				if(M.nutrition >= 100)
					owner.nutrition = (owner.nutrition * 0.95)
		return

//////////////////////////// DM_SIZE_STEAL ////////////////////////////
	if(digest_mode == DM_SIZE_STEAL)

		for (var/mob/living/M in internal_contents)

			if(prob(10))
				var/growsound = pick(digestion_sounds)
				M << sound(growsound,volume=80)
				owner << sound(growsound,volume=80)

			if(M.size_multiplier > shrink_grow_size && owner.size_multiplier < 2) //Grow until either pred is large or prey is small.
				owner.resize(owner.size_multiplier+0.01) //Grow by 1% per tick.
				M.resize(M.size_multiplier-0.01) //Shrink by 1% per tick
				if(M.nutrition >= 100)
					var/oldnutrition = (M.nutrition * 0.05)
					M.nutrition = (M.nutrition * 0.95)
					owner.nutrition += oldnutrition
		return

///////////////////////////// DM_HEAL /////////////////////////////
	if(digest_mode == DM_HEAL)
		if(prob(50)) //Wet heals!
			var/healsound = pick(digestion_sounds)
			for(var/mob/hearer in range(1,owner))
				hearer << sound(healsound,volume=80)

		for (var/mob/living/M in internal_contents)
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
		return

///////////////////////////// DM_TRANSFORM_HAIR_AND_EYES /////////////////////////////
	if(digest_mode == DM_TRANSFORM_HAIR_AND_EYES && ishuman(owner))
		for (var/mob/living/carbon/human/P in internal_contents)
			if(P.stat == DEAD)
				continue

			var/mob/living/carbon/human/O = owner

			if(O.nutrition > 400 && P.nutrition < 400)
				O.nutrition -= 2
				P.nutrition += 1.5

			if(check_eyes(P) || check_hair(P))
				change_eyes(P)
				change_hair(P,1)

		return
///////////////////////////// DM_TRANSFORM_MALE /////////////////////////////
	if(digest_mode == DM_TRANSFORM_MALE && ishuman(owner))
		for (var/mob/living/carbon/human/P in internal_contents)
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

		return


///////////////////////////// DM_TRANSFORM_FEMALE /////////////////////////////
	if(digest_mode == DM_TRANSFORM_FEMALE && ishuman(owner))
		for (var/mob/living/carbon/human/P in internal_contents)
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

		return

///////////////////////////// DM_TRANSFORM_KEEP_GENDER  /////////////////////////////
	if(digest_mode == DM_TRANSFORM_KEEP_GENDER && ishuman(owner))
		for (var/mob/living/carbon/human/P in internal_contents)
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

		return

///////////////////////////// DM_TRANSFORM_CHANGE_SPECIES_AND_TAUR  /////////////////////////////
	if(digest_mode == DM_TRANSFORM_CHANGE_SPECIES_AND_TAUR && ishuman(owner))
		for (var/mob/living/carbon/human/P in internal_contents)
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

		return

///////////////////////////// DM_TRANSFORM_REPLICA /////////////////////////////
	if(digest_mode == DM_TRANSFORM_REPLICA && ishuman(owner))
		for (var/mob/living/carbon/human/P in internal_contents)
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

		return

///////////////////////////// DM_TRANSFORM_CHANGE_SPECIES_AND_TAUR_EGG /////////////////////////////
	if(digest_mode == DM_TRANSFORM_CHANGE_SPECIES_AND_TAUR_EGG && ishuman(owner))
		for (var/mob/living/carbon/human/P in internal_contents)
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

		return

///////////////////////////// DM_TRANSFORM_KEEP_GENDER_EGG  /////////////////////////////
	if(digest_mode == DM_TRANSFORM_KEEP_GENDER_EGG && ishuman(owner))
		for (var/mob/living/carbon/human/P in internal_contents)
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

		return

///////////////////////////// DM_TRANSFORM_REPLICA_EGG /////////////////////////////
	if(digest_mode == DM_TRANSFORM_REPLICA_EGG && ishuman(owner))
		for (var/mob/living/carbon/human/P in internal_contents)
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

		return

///////////////////////////// DM_TRANSFORM_MALE_EGG /////////////////////////////
	if(digest_mode == DM_TRANSFORM_MALE_EGG && ishuman(owner))
		for (var/mob/living/carbon/human/P in internal_contents)
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

		return

///////////////////////////// DM_TRANSFORM_FEMALE_EGG /////////////////////////////
	if(digest_mode == DM_TRANSFORM_FEMALE_EGG && ishuman(owner))
		for (var/mob/living/carbon/human/P in internal_contents)
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

		return

///////////////////////////// DM_EGG /////////////////////////////
	if(digest_mode == DM_EGG && ishuman(owner))
		for (var/mob/living/carbon/human/P in internal_contents)
			if(P.absorbed || P.stat == DEAD)
				continue

			put_in_egg(P,1)
