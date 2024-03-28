// Process the predator's effects upon the contents of its belly (i.e digestion/transformation etc)
/obj/belly/process(wait) //Passed by controller
	recent_sound = FALSE

	if(loc != owner)
		if(istype(owner))
			loc = owner
		else
			qdel(src)
			return

	// VERY early exit
	if(!contents.len)
		return

	var/play_sound //Potential sound to play at the end to avoid code duplication.
	var/to_update = FALSE //Did anything update worthy happen?

/////////////////////////// Exit Early ////////////////////////////
	var/list/touchable_atoms = contents - items_preserved
	if(!length(touchable_atoms))
		return

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

///////////////////// Early Non-Mode Handling /////////////////////

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

	if(!digestion_noise_chance)
		digestion_noise_chance = DM.noise_chance

/////////////////////////// Make any noise ///////////////////////////
	if(digestion_noise_chance && prob(digestion_noise_chance))
		for(var/mob/M in contents)
			if(M && M.is_preference_enabled(/datum/client_preference/digestion_noises))
				SEND_SOUND(M, prey_digest)
		play_sound = pred_digest

	if(!LAZYLEN(touchable_mobs))
		if(to_update)
			updateVRPanels()
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
		return

///////////////////// Prey Loop Refresh/hack //////////////////////
	prey_loop()

///////////////////// Time to actually process mobs /////////////////////

	for(var/mob/living/L as anything in touchable_mobs)
		if(!istype(L))
			stack_trace("Touchable mobs had a nonmob: [L]")
			continue
		var/list/returns = DM.process_mob(src, L)
		if(istype(returns) && returns["to_update"])
			to_update = TRUE
		if(istype(returns) && returns["soundToPlay"] && !play_sound)
			play_sound = returns["soundToPlay"]

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

	if(emote_active)
		var/list/EL = emote_lists[digest_mode]
		if((LAZYLEN(EL) || LAZYLEN(emote_lists[DM_HOLD_ABSORBED]) || (digest_mode == DM_DIGEST && LAZYLEN(emote_lists[DM_HOLD])) || (digest_mode == DM_SELECT && (LAZYLEN(emote_lists[DM_HOLD])||LAZYLEN(emote_lists[DM_DIGEST])||LAZYLEN(emote_lists[DM_ABSORB])) )) && next_emote <= world.time)
			var/living_count = 0
			var/absorbed_count = 0
			for(var/mob/living/L in contents)
				living_count++
				if(L.absorbed)
					absorbed_count++
			next_emote = world.time + (emote_time SECONDS)
			for(var/mob/living/M in contents)
				if(M.absorbed)
					EL = emote_lists[DM_HOLD_ABSORBED]

					var/raw_message = pick(EL)
					var/formatted_message
					formatted_message = replacetext(raw_message, "%belly", lowertext(name))
					formatted_message = replacetext(formatted_message, "%pred", owner)
					formatted_message = replacetext(formatted_message, "%prey", M)
					formatted_message = replacetext(formatted_message, "%countprey", absorbed_count)
					if(formatted_message)
						to_chat(M, "<span class='vnotice'>[formatted_message]</span>")
				else
					if (digest_mode == DM_SELECT)
						var/datum/digest_mode/selective/DM_S = GLOB.digest_modes[DM_SELECT]
						EL = emote_lists[DM_S.get_selective_mode(src, M)]
					else if(digest_mode == DM_DIGEST && !M.digestable)
						EL = emote_lists[DM_HOLD]					// Use Hold's emote list if we're indigestible

					var/raw_message = pick(EL)
					var/formatted_message
					formatted_message = replacetext(raw_message, "%belly", lowertext(name))
					formatted_message = replacetext(formatted_message, "%pred", owner)
					formatted_message = replacetext(formatted_message, "%prey", M)
					formatted_message = replacetext(formatted_message, "%countprey", living_count)
					formatted_message = replacetext(formatted_message, "%count", contents.len)
					if(formatted_message)
						to_chat(M, "<span class='vnotice'>[formatted_message]</span>")

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

			if(L.absorbed && !issilicon(L))
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

				//Force psay
				if((mode_flags & DM_FLAG_FORCEPSAY) && !H.forced_psay && H.absorbed)
					H.forced_psay = TRUE

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
	var/compensation = M.maxHealth / 5 //Dead body bonus.
	if(ishuman(M))
		compensation += M.getOxyLoss() //How much of the prey's damage was caused by passive crit oxyloss to compensate the lost nutrition.

	var/living_count = 0
	for(var/mob/living/L in contents)
		living_count++

	//Replace placeholder vars
	digest_alert_owner = replacetext(digest_alert_owner, "%pred", owner)
	digest_alert_owner = replacetext(digest_alert_owner, "%prey", M)
	digest_alert_owner = replacetext(digest_alert_owner, "%belly", lowertext(name))
	digest_alert_owner = replacetext(digest_alert_owner, "%countprey", living_count)
	digest_alert_owner = replacetext(digest_alert_owner, "%count", contents.len)

	digest_alert_prey = replacetext(digest_alert_prey, "%pred", owner)
	digest_alert_prey = replacetext(digest_alert_prey, "%prey", M)
	digest_alert_prey = replacetext(digest_alert_prey, "%belly", lowertext(name))
	digest_alert_prey = replacetext(digest_alert_prey, "%countprey", living_count)
	digest_alert_prey = replacetext(digest_alert_prey, "%count", contents.len)

	//Send messages
	to_chat(owner, "<span class='vnotice'>[digest_alert_owner]</span>")
	to_chat(M, "<span class='vnotice'>[digest_alert_prey]</span>")

	if(M.ckey)
		GLOB.prey_digested_roundstat++

	var/personal_nutrition_modifier = M.get_digestion_nutrition_modifier()
	var/pred_digestion_efficiency = owner.get_digestion_efficiency_modifier()

	if((mode_flags & DM_FLAG_LEAVEREMAINS) && M.digest_leave_remains)
		handle_remains_leaving(M)
	digestion_death(M)
	if(!ishuman(owner))
		owner.update_icons()
	if(isrobot(owner))
		var/mob/living/silicon/robot/R = owner
		R.cell.charge += (nutrition_percent / 100) * compensation * 25 * personal_nutrition_modifier
	else
		owner.adjust_nutrition((nutrition_percent / 100) * compensation * 4.5 * personal_nutrition_modifier * pred_digestion_efficiency)

/obj/belly/proc/steal_nutrition(mob/living/L)
	if(L.nutrition <= 110)
		if(drainmode == DR_SLEEP && istype(L,/mob/living/carbon/human)) //Slowly put prey to sleep
			if(L.tiredness <= 105)
				L.tiredness = (L.tiredness + 6)
			if(L.tiredness <= 90 && L.tiredness >= 75)
				to_chat(L, "<span class='warning'>You are about to fall unconscious!</span>")
				to_chat(owner, "<span class='warning'>[L] is about to fall unconscious!</span>")
		if(drainmode == DR_FAKE && istype(L,/mob/living/carbon/human)) //Slowly bring prey to the edge of sleep without crossing it
			if(L.tiredness <= 93)
				L.tiredness = (L.tiredness + 6)
		if(drainmode == DR_WEIGHT && istype(L,/mob/living/carbon/human)) //Slowly drain your prey's weight and add it to your own
			if(L.weight > 70)
				L.weight -= (0.01 * L.weight_loss)
				owner.weight += (0.01 * L.weight_loss) //intentionally dependant on the prey's weight loss ratio rather than the preds weight gain to keep them in pace with one another.
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
