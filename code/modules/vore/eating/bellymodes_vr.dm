// Process the predator's effects upon the contents of its belly (i.e digestion/transformation etc)
/obj/belly/process(wait) //Passed by controller
	recent_sound = FALSE
	cycle_sloshed = FALSE

	if(loc != owner)
		if(istype(owner))
			loc = owner
		else
			qdel(src)
			return

	HandleBellyReagents()	// reagent belly stuff, here to jam it into subsystems and avoid too much cpu usage
	update_belly_surrounding() // Updates belly_surrounding list for indirect vore usage
	// VERY early exit
	if(!contents.len)
		if(owner.previewing_belly == src)
			HandleBellyReagentEffects()
		return

	// Autotransfer count moved here.
	if(autotransfer_enabled)
		var/list/autotransferables = list()
		for(var/atom/movable/M in contents)
			if(!M || !M.autotransferable) continue
			// If the prey can't pass the filter of at least one transfer location, skip it
			if(ismob(M) && !(autotransfer_filter(M, autotransfer_secondary_whitelist, autotransfer_secondary_blacklist) || autotransfer_filter(M, autotransfer_whitelist, autotransfer_blacklist))) continue
			if(isitem(M) && !(autotransfer_filter(M, autotransfer_secondary_whitelist_items, autotransfer_secondary_blacklist_items) || autotransfer_filter(M, autotransfer_whitelist_items, autotransfer_blacklist_items))) continue
			M.belly_cycles++
			if(M.belly_cycles < autotransferwait / 60) continue
			autotransferables += M
		if(LAZYLEN(autotransferables) >= autotransfer_min_amount)
			var/tally = 0
			for(var/atom/movable/M in autotransferables)
				if(check_autotransfer(M))
					tally++
				if(autotransfer_max_amount > 0 && tally >= autotransfer_max_amount) break

	var/play_sound //Potential sound to play at the end to avoid code duplication.
	var/to_update = FALSE //Did anything update worthy happen?
	SEND_SIGNAL(src, COMSIG_BELLY_UPDATE_PREY_LOOP) // signals listening atoms to update prey_loop. May be cancelled by early exit otherwise.

/////////////////////////// Exit Early ////////////////////////////
	var/list/touchable_atoms = contents - items_preserved
	for(var/mob/observer/G in touchable_atoms) // don't bother trying to process ghosts.
		touchable_atoms -= G
	var/datum/digest_mode/DM = GLOB.digest_modes["[digest_mode]"]
	if(!DM)
		log_debug("Digest mode [digest_mode] didn't exist in the digest_modes list!!")
		return FALSE
	if(digest_mode == DM_EGG)
		prey_loop() //Apparently on Egg mode the sound loop never played before? Just slapping this here to fix that
		if(DM.handle_atoms(src, contents))
			updateVRPanels()
		return
	if(!length(touchable_atoms) && !belly_surrounding.len) // Needed to not exit early for indirect vorefx
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

	touchable_atoms -= items_preserved
	HandleBellyReagentEffects(touchable_atoms)

/////////////////////////// Make any noise ///////////////////////////
	if(digestion_noise_chance && prob(digestion_noise_chance))
		for(var/mob/M in contents)
			if(M && M.check_sound_preference(/datum/preference/toggle/digestion_noises))
				SEND_SOUND(M, prey_digest)
		play_sound = pred_digest

	if(!LAZYLEN(belly_surrounding)) //Changed to belly_surrounding from touchable_mobs so indirect vore viewers get this too
		if(to_update)
			updateVRPanels()
		if(play_sound)
			for(var/mob/M in hearers(VORE_SOUND_RANGE, get_turf(owner))) //so we don't fill the whole room with the sound effect
				if(!M.check_sound_preference(/datum/preference/toggle/digestion_noises))
					continue
				if(isturf(M.loc) || (M.loc != src)) //to avoid people on the inside getting the outside sounds and their direct sounds + built in sound pref check
					if(fancy_vore)
						M.playsound_local(get_turf(owner), play_sound, vol = sound_volume, vary = 1, falloff = VORE_SOUND_FALLOFF, frequency = noise_freq)
					else
						M.playsound_local(get_turf(owner), play_sound, vol = sound_volume, vary = 1, falloff = VORE_SOUND_FALLOFF, frequency = noise_freq)
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
			if(!M.check_sound_preference(/datum/preference/toggle/digestion_noises))
				continue
			if(isturf(M.loc) || (M.loc != src)) //to avoid people on the inside getting the outside sounds and their direct sounds + built in sound pref check
				if(fancy_vore)
					M.playsound_local(get_turf(owner), play_sound, vol = sound_volume, vary = 1, falloff = VORE_SOUND_FALLOFF, frequency = noise_freq)
				else
					M.playsound_local(get_turf(owner), play_sound, vol = sound_volume, vary = 1, falloff = VORE_SOUND_FALLOFF, frequency = noise_freq)
				 //these are all external sound triggers now, so it's ok.

	if(emote_active)
		// emote_lists can be = ""
		var/list/EL
		if(islist(emote_lists))
			EL = emote_lists[digest_mode]

		if((LAZYLEN(EL) || LAZYLEN(emote_lists[DM_HOLD_ABSORBED]) || (digest_mode == DM_DIGEST && LAZYLEN(emote_lists[DM_HOLD])) || (digest_mode == DM_SELECT && (LAZYLEN(emote_lists[DM_HOLD])||LAZYLEN(emote_lists[DM_DIGEST])||LAZYLEN(emote_lists[DM_ABSORB])) )) && next_emote <= world.time)
			next_emote = world.time + (emote_time SECONDS)
			for(var/mob/living/M in contents)
				if(M.absorbed)
					EL = emote_lists[DM_HOLD_ABSORBED]
					if(LAZYLEN(EL))
						to_chat(M, span_vnotice(belly_format_string(EL, M, use_absorbed_count = TRUE)))
				else
					if (digest_mode == DM_SELECT)
						var/datum/digest_mode/selective/DM_S = GLOB.digest_modes[DM_SELECT]
						EL = emote_lists[DM_S.get_selective_mode(src, M)]
					else if(digest_mode == DM_DIGEST && !M.digestable)
						EL = emote_lists[DM_HOLD]					// Use Hold's emote list if we're indigestible

					if(LAZYLEN(EL))
						to_chat(M, span_vnotice(belly_format_string(EL, M)))

	if(to_update)
		updateVRPanels()


/obj/belly/proc/handle_touchable_atoms(list/touchable_atoms)
	var/did_an_item = FALSE // Only do one item per cycle.
	var/to_update = FALSE
	var/digestion_noise_chance = 0
	var/list/touchable_mobs = list()

	for(var/A in touchable_atoms)
		//Handle eaten mobs
		if(isliving(A))
			var/mob/living/L = A
			touchable_mobs += L

			if(L.absorbed && !issilicon(L))
				L.Weaken(5)

			//Handle 'human'
			if(ishuman(L))
				var/mob/living/carbon/human/H = L

				//Numbing flag
				if(mode_flags & DM_FLAG_NUMBING)
					if(H.bloodstr.get_reagent_amount(REAGENT_ID_NUMBENZYME) < 2)
						H.bloodstr.add_reagent(REAGENT_ID_NUMBENZYME,4)

				//Thickbelly flag
				if((mode_flags & DM_FLAG_THICKBELLY) && !H.muffled)
					H.muffled = TRUE
				//Fix muffled sometimes being sticky.
				else if(!(mode_flags & DM_FLAG_THICKBELLY) && H.muffled)
					H.muffled = FALSE

				//Force psay
				if((mode_flags & DM_FLAG_FORCEPSAY) && !H.forced_psay && H.absorbed)
					H.forced_psay = TRUE
				//Fix forcepsay sometimes being sticky.
				else if(!(mode_flags & DM_FLAG_FORCEPSAY) && H.forced_psay)
					H.forced_psay = FALSE

				//Worn items flag
				if(mode_flags & DM_FLAG_AFFECTWORN)
					for(var/slot in slots)
						var/obj/item/I = H.get_equipped_item(slot = slot)
						if(I && I.canremove)
							touchable_atoms |= I

				//Stripping flag
				if((mode_flags & DM_FLAG_STRIPPING) && H.strip_pref) //Stripping pref check
					for(var/slot in slots)
						var/obj/item/I = H.get_equipped_item(slot = slot)
						if(I && H.unEquip(I, force = FALSE))
							handle_digesting_item(I)
							digestion_noise_chance = 25
							to_update = TRUE
							break // Digest off one by one, not all at once

	for(var/A in touchable_atoms) //List updated for worn items.
		//Handle stray items
		if(isitem(A))
			if(item_digest_mode == IM_DIGEST_PARALLEL)
				var/touchable_amount = touchable_atoms.len
				did_an_item = handle_digesting_item(A, touchable_amount)
			else if(!did_an_item)
				did_an_item = handle_digesting_item(A, 1)
			if(did_an_item)
				to_update = TRUE

			//Less often than with normal digestion
			if((item_digest_mode == IM_DIGEST_FOOD || item_digest_mode == IM_DIGEST || item_digest_mode == IM_DIGEST_PARALLEL) && prob(25))
				// This is a little weird, but the point of it is that we don't want to repeat code
				// but we also want the prob(25) chance to run for -every- item we look at, not just once
				// More gurgles the better~
				digestion_noise_chance = 25
			continue

		//get rid of things like blood drops and gibs that end up in there
		else if(istype(A, /obj/effect/decal/cleanable))
			qdel(A)

	return list("to_update" = to_update, "touchable_mobs" = touchable_mobs, "digestion_noise_chance" = digestion_noise_chance)

/obj/belly/proc/prey_loop()
	for(var/mob/living/M in belly_surrounding) //contents changed to belly_surrounding to loop sound for indirect viewers too
		//We don't bother executing any other code if the prey doesn't want to hear the noises.
		if(!M.check_sound_preference(/datum/preference/toggle/digestion_noises))
			M.stop_sound_channel(CHANNEL_PREYLOOP) // sanity just in case, because byond is whack and you can't trust it
			continue

		// We don't want the sounds to overlap, but we do want them to steadily replay.
		// We also don't want the sounds to play if the pred hasn't marked this belly as fleshy, or doesn't
		// have the right sounds to play.
		if(is_wet && wet_loop && (world.time > M.next_preyloop)) //Removed isbelly(M.loc) as some viewers might be indirectly in the belly
			M.stop_sound_channel(CHANNEL_PREYLOOP)
			var/sound/preyloop = sound('sound/vore/sunesound/prey/loop.ogg')
			M.playsound_local(get_turf(src), preyloop, 80, 0, channel = CHANNEL_PREYLOOP, frequency = noise_freq)
			M.next_preyloop = (world.time + (52 SECONDS))

/obj/belly/proc/handle_digesting_item(obj/item/I, touchable_amount)
	var/did_an_item = FALSE
	// We always contaminate IDs.
	if(contaminates || istype(I, /obj/item/card/id))
		I.gurgle_contaminate(src, contamination_flavor, contamination_color)

	switch(item_digest_mode)
		if(IM_HOLD)
			items_preserved |= I
		if(IM_DIGEST_FOOD)
			if(istype(I,/obj/item/reagent_containers/food) || istype(I, /obj/item/organ))
				var/obj/item/organ/R = I
				if(istype(R) && R.robotic >= ORGAN_ROBOT)
					items_preserved |= I
				else
					did_an_item = digest_item(I, touchable_amount)
			else
				items_preserved |= I
		if(IM_DIGEST,IM_DIGEST_PARALLEL)
			did_an_item = digest_item(I, touchable_amount)
	return did_an_item

/obj/belly/proc/handle_digestion_death(mob/living/M, instant = FALSE)
	if(!instant && slow_digestion) // Gradual corpse digestion
		if(!M.digestion_in_progress)
			M.digestion_in_progress = TRUE
			if(M.health > -36 || (ishuman(M) && M.health > -136))
				to_chat(M, span_vnotice("(Your predator has enabled gradual body digestion. Stick around for a second round of churning to reach the true finisher.)"))
		if(M.health < M.maxHealth * -1) //Siplemobs etc
			if(ishuman(M))
				if(M.health < (M.maxHealth * -1) -100) //Spacemans can go much deeper. Jank but maxHealth*-2 doesn't work with flat standard -100hp death threshold.
					if(slow_brutal)
						var/mob/living/carbon/human/P = M
						var/vitals_only = TRUE
						for(var/obj/item/organ/external/E in P.organs)
							if(!E.vital)
								vitals_only = FALSE
								if(!LAZYLEN(E.children))
									for(var/obj/item/implant/I as anything in E.implants)
										qdel(I)
									E.droplimb(TRUE, DROPLIMB_EDGE)
									qdel(E)
									break
							continue
						if(vitals_only)
							M.digestion_in_progress = FALSE
					else
						M.digestion_in_progress = FALSE
			else
				M.digestion_in_progress = FALSE
		if(M.digestion_in_progress)
			return
	var/digest_alert_owner = span_vnotice(belly_format_string(digest_messages_owner, M))
	var/digest_alert_prey = span_vnotice(belly_format_string(digest_messages_prey, M))
	var/compensation = M.maxHealth / 5 //Dead body bonus.
	if(ishuman(M))
		compensation += M.getOxyLoss() //How much of the prey's damage was caused by passive crit oxyloss to compensate the lost nutrition.

	//Send messages
	to_chat(owner, digest_alert_owner)
	to_chat(M, digest_alert_prey)

	if(M.ckey)
		GLOB.prey_digested_roundstat++

	owner.churn_count++
	owner.handle_special_unlocks()

	var/personal_nutrition_modifier = M.get_digestion_nutrition_modifier()
	var/pred_digestion_efficiency = owner.get_digestion_efficiency_modifier()

	if(ishuman(M) && (mode_flags & DM_FLAG_SPARELIMB) && M.digest_leave_remains)
		var/mob/living/carbon/human/H = M
		var/list/detachable_limbs = H.get_modular_limbs(return_first_found = FALSE, validate_proc = /obj/item/organ/external/proc/can_remove_modular_limb)
		for(var/obj/item/organ/external/E in detachable_limbs)
			if(H.species.name != SPECIES_PROTEAN)
				E.removed(H)
				E.dropInto(src)
	if((mode_flags & DM_FLAG_LEAVEREMAINS) && M.digest_leave_remains)
		handle_remains_leaving(M)
	digestion_death(M)
	if(show_liquids && reagent_mode_flags & DM_FLAG_REAGENTSDIGEST && reagents.total_volume < reagents.maximum_volume) // digestion producing reagents
		owner_adjust_nutrition((nutrition_percent / 100) * compensation * 3 * personal_nutrition_modifier)
		GenerateBellyReagents_digested()
	else
		owner_adjust_nutrition((nutrition_percent / 100) * compensation * 4.5 * personal_nutrition_modifier * pred_digestion_efficiency)

/obj/belly/proc/steal_nutrition(mob/living/L)
	if(L.nutrition <= 110)
		if(drainmode == DR_SLEEP && ishuman(L)) //Slowly put prey to sleep
			if(L.tiredness <= 105)
				L.tiredness = (L.tiredness + 6)
			if(L.tiredness <= 90 && L.tiredness >= 75)
				to_chat(L, span_warning("You are about to fall unconscious!"))
				to_chat(owner, span_warning("[L] is about to fall unconscious!"))
		if(drainmode == DR_FAKE && ishuman(L)) //Slowly bring prey to the edge of sleep without crossing it
			if(L.tiredness <= 93)
				L.tiredness = (L.tiredness + 6)
		if(drainmode == DR_WEIGHT && ishuman(L)) //Slowly drain your prey's weight and add it to your own
			if(L.weight > 70)
				L.weight -= (0.01 * L.weight_loss)
				owner.weight += (0.01 * L.weight_loss) //intentionally dependant on the prey's weight loss ratio rather than the preds weight gain to keep them in pace with one another.
	if(L.nutrition >= 100)
		var/oldnutrition = (L.nutrition * 0.05)
		L.nutrition = (L.nutrition * 0.95)
		if(show_liquids && reagent_mode_flags & DM_FLAG_REAGENTSDRAIN && reagents.total_volume < reagents.maximum_volume)   // draining reagent production //Added to this proc now since it's used for draining
			owner_adjust_nutrition(oldnutrition * 0.75) //keeping the price static, due to how much nutrition can flunctuate
			GenerateBellyReagents_absorbing() //Dont need unique proc so far
		else
			owner_adjust_nutrition(oldnutrition)

/obj/belly/proc/updateVRPanels()
	for(var/mob/living/M in belly_surrounding) //Changed to belly_surrounding from contents so updates happen for indirect viewers too
		if(M.client)
			M.updateVRPanel()
	if(owner.client)
		owner.updateVRPanel()
	if(isanimal(owner))
		owner.update_icon()
