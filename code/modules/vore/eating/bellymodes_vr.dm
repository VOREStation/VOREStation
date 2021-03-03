// Process the predator's effects upon the contents of its belly (i.e digestion/transformation etc)
/obj/belly/process(wait) //Passed by controller
	recent_sound = FALSE

	if(loc != owner)
		if(istype(owner))
			loc = owner
		else
			qdel(src)
			return

	var/play_sound //Potential sound to play at the end to avoid code duplication.
	var/to_update = FALSE //Did anything update worthy happen?

///////////////////// Prey Loop Refresh/hack //////////////////////
	prey_loop()

/////////////////////////// Sound Selections ///////////////////////////
	var/digestion_noise_chance = 0
	var/sound/prey_digest
	var/sound/pred_digest
	if(!fancy_vore)
		prey_digest = sound(get_sfx("classic_digestion_sounds"))
		pred_digest = sound(get_sfx("classic_digestion_sounds"))
	else
		prey_digest = sound(get_sfx("fancy_digest_prey"))
		pred_digest = sound(get_sfx("fancy_digest_pred"))

/////////////////////////// Exit Early ////////////////////////////
	var/list/touchable_atoms = contents - items_preserved
	if(!length(touchable_atoms))
		return

	var/datum/digest_mode/DM = GLOB.digest_modes["[digest_mode]"]
	if(!DM)
		log_debug("Digest mode [digest_mode] didn't exist in the digest_modes list!!")
		return FALSE
	if(DM.handle_atoms(src, touchable_atoms))
		updateVRPanels()
		return

	var/list/touchable_mobs = null

	var/list/hta_returns = handle_touchable_atoms(touchable_atoms)
	if(islist(hta_returns))
		if(hta_returns["digestion_noise_chance"])
			digestion_noise_chance = hta_returns["digestion_noise_chance"]
		if(hta_returns["touchable_mobs"])
			touchable_mobs = hta_returns["touchable_mobs"]
		if(hta_returns["to_update"])
			to_update = hta_returns["to_update"]

	if(!islist(touchable_mobs))
		return

///////////////////// Early Non-Mode Handling /////////////////////
	var/list/EL = emote_lists[digest_mode]
	if(LAZYLEN(EL) && touchable_mobs && next_emote <= world.time)
		next_emote = world.time + emote_time
		for(var/mob/living/M in contents)
			if(digest_mode == DM_DIGEST && !M.digestable)
				continue // don't give digesty messages to indigestible people
			to_chat(M, "<span class='notice'>[pick(EL)]</span>")

	if(!digestion_noise_chance)
		digestion_noise_chance = DM.noise_chance

	for(var/target in touchable_mobs)
		var/mob/living/L = target
		if(!istype(L))
			continue
		var/list/returns = DM.process_mob(src, target)
		if(istype(returns) && returns["to_update"])
			to_update = TRUE
		if(istype(returns) && returns["soundToPlay"] && !play_sound)
			play_sound = returns["soundToPlay"]

/////////////////////////// Make any noise ///////////////////////////
	if(digestion_noise_chance && prob(digestion_noise_chance))
		for(var/mob/M in contents)
			if(M && M.is_preference_enabled(/datum/client_preference/digestion_noises))
				SEND_SOUND(M, prey_digest)
		play_sound = pred_digest

	if(play_sound)
		for(var/mob/M in hearers(VORE_SOUND_RANGE, get_turf(owner))) //so we don't fill the whole room with the sound effect
			if(!M.is_preference_enabled(/datum/client_preference/digestion_noises))
				continue
			if(isturf(M.loc) || (M.loc != src)) //to avoid people on the inside getting the outside sounds and their direct sounds + built in sound pref check
				if(fancy_vore)
					M.playsound_local(get_turf(owner), play_sound, vol = 100, vary = 1, falloff = VORE_SOUND_FALLOFF)
				else
					M.playsound_local(get_turf(owner), play_sound, vol = 100, vary = 1, falloff = VORE_SOUND_FALLOFF)
				 //these are all external sound triggers now, so it's ok.

	if(to_update)
		updateVRPanels()

/obj/belly/proc/handle_touchable_atoms(list/touchable_atoms)
	var/did_an_item = FALSE // Only do one item per cycle.
	var/to_update = FALSE
	var/digestion_noise_chance = 0
	var/list/touchable_mobs = list()

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

			// Fullscreen overlays
			vore_fx(L)

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

				//Worn items flag
				if(mode_flags & DM_FLAG_AFFECTWORN)
					for(var/slot in slots)
						var/obj/item/I = H.get_equipped_item(slot = slot)
						if(I && I.canremove)
							if(handle_digesting_item(I))
								digestion_noise_chance = 25
								to_update = TRUE
								break

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

	return list("to_update" = to_update, "touchable_mobs" = touchable_mobs, "digestion_noise_chance" = digestion_noise_chance)

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

	var/living_count = 0
	for(var/mob/living/L in contents)
		living_count++

	//Replace placeholder vars
	digest_alert_owner = replacetext(digest_alert_owner, "%pred", owner)
	digest_alert_owner = replacetext(digest_alert_owner, "%prey", M)
	digest_alert_owner = replacetext(digest_alert_owner, "%belly", lowertext(name))
	digest_alert_owner = replacetext(digest_alert_owner, "%count", contents.len)
	digest_alert_owner = replacetext(digest_alert_owner, "%countprey", living_count)

	digest_alert_prey = replacetext(digest_alert_prey, "%pred", owner)
	digest_alert_prey = replacetext(digest_alert_prey, "%prey", M)
	digest_alert_prey = replacetext(digest_alert_prey, "%belly", lowertext(name))
	digest_alert_prey = replacetext(digest_alert_prey, "%count", contents.len)
	digest_alert_prey = replacetext(digest_alert_prey, "%countprey", living_count)

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
			R.cell.charge += 25*compensation*(nutrition_percent / 100)
		else
			owner.adjust_nutrition((nutrition_percent / 100)*4.5*compensation)

/obj/belly/proc/steal_nutrition(mob/living/L)
	if(L.nutrition >= 100)
		var/oldnutrition = (L.nutrition * 0.05)
		L.nutrition = (L.nutrition * 0.95)
		owner.adjust_nutrition(oldnutrition)

/obj/belly/proc/updateVRPanels()
	for(var/mob/living/M in contents)
		if(M.client)
			M.updateVRPanel()
	if(owner.client)
		owner.updateVRPanel()
	if(isanimal(owner))
		owner.update_icon()
