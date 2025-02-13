/mob/observer/dead/verb/spawn_in_belly()
	set category = "Ghost.Join"
	set name = "Spawn In Belly"
	set desc = "Spawn in someone's belly."

	if(!client)
		return

	// If any ghost-side restrictions are desired, they'll go here

	tgui_alert(src,{"
This verb allows you to spawn inside someone's belly when they are in round.
Make sure you to coordinate with your predator OOCly as well as roleplay approprietly.
You are considered to have been in the belly entire time the predator was around and are not added to crew lists.
This is not intended to be used for mechanical advantage or providing assistance, but for facilitating longterm scenes.
Please do not abuse this ability.
"},"OOC Warning")			// Warning.

	var/list/eligible_targets = list()

	for(var/mob/living/pred in living_mob_list)
		if(!istype(pred) || !pred.client)		// Ignore preds that aren't living mobs or player controlled
			continue
		if(pred.no_vore)						// No vore, no bellies, no inbelly spawning
			continue
		if(!(get_z(pred) in using_map.station_levels))	// No explo reinforcements
			continue
		if(ishuman(pred))
			var/mob/living/carbon/human/H = pred
			if(!H.allow_inbelly_spawning)
				continue
			eligible_targets += H
			continue
		if(issilicon(pred))
			var/mob/living/silicon/S = pred
			if(isAI(S))
				continue						// Sorry, AI buddies. Your vore works too differently.
			if(!S.allow_inbelly_spawning)
				continue
			eligible_targets += S
			continue
		if(isanimal(pred))
			var/mob/living/simple_mob/SM = pred
			if(!SM.vore_active)						// No vore, no bellies, no inbelly spawning
				continue
			if(!SM.allow_inbelly_spawning)
				continue
			eligible_targets += SM
			continue

		// Only humans, simple_mobs and non-AI silicons are included. Obscure stuff like bots is skipped.

	if(!eligible_targets.len)
		to_chat(src, span_notice("No eligible preds were found."))				// :(
		return

	var/mob/living/target = tgui_input_list(src, "Please specify which character you want to spawn inside of.", "Predator", eligible_targets)	// Offer the list of things we gathered.

	if(!target || !client)			// Did out target cease to exist? Or did we?
		return

	// Notify them that its now pred's turn
	to_chat(src, span_notice("Inbelly spawn request sent to predator."))
	target.inbelly_spawn_prompt(client)			// Hand reins over to them

/mob/living/proc/inbelly_spawn_prompt(client/potential_prey)
	if(!potential_prey || !istype(potential_prey))		// Did our prey cease to exist?
		return

	// Are we cool with this prey spawning in at all?
	var/answer = tgui_alert(src, "[potential_prey.prefs.real_name] wants to spawn in one of your bellies. Do you accept?", "Inbelly Spawning", list("Yes", "No"))
	if(answer != "Yes")
		to_chat(potential_prey, span_notice("Your request was turned down."))
		return

	// Let them know so that they don't spam it.
	to_chat(potential_prey, span_notice("Predator agreed to your request. Wait a bit while they choose a belly."))

	// Where we dropping?
	var/obj/belly/belly_choice = tgui_input_list(src, "Choose Target Belly", "Belly Choice", src.vore_organs)

	// Wdym nowhere?
	if(!belly_choice || !istype(belly_choice))
		to_chat(potential_prey, span_notice("Something went wrong with predator selecting a belly. Try again?"))
		to_chat(src, span_notice("No valid belly selected. Inbelly spawn cancelled."))
		return

	// Extra caution never hurts
	if(belly_choice.digest_mode == DM_DIGEST)
		var/digest_answer = tgui_alert(src, "[belly_choice] is currently set to Digest. Are you sure you want to spawn prey there?", "Inbelly Spawning", list("Yes", "No"))
		if(digest_answer != "Yes")
			to_chat(potential_prey, span_notice("Something went wrong with predator selecting a belly. Try again?"))
			to_chat(src, span_notice("Inbelly spawn cancelled."))

	// Are they already fat (and/or appropriate equivalent)?
	var/absorbed = FALSE
	var/absorbed_answer = tgui_alert(src, "Do you want them to start absorbed?", "Inbelly Spawning", list("Yes", "No"))

	if(absorbed_answer == "Yes")
		absorbed = TRUE

	// They disappeared?
	if(!potential_prey)
		to_chat(src, span_notice("No prey found. Something went wrong!"))
		return

	// Final confirmation for pred
	var/confirmation_pred = tgui_alert(src, "Are you certain that you want [potential_prey.prefs.real_name] spawned in your [belly_choice][absorbed ? ", absorbed" : ""]?", "Inbelly Spawning", list("Yes", "No"))

	if(confirmation_pred != "Yes")
		to_chat(potential_prey, span_notice("Your pred couldn't finish selection. Try again?"))
		to_chat(src, span_notice("Inbelly spawn cancelled."))
		return

	to_chat(src, span_notice("Waiting for prey's confirmation..."))

	// And final confirmation for prey
	var/confirmation_prey = tgui_alert(potential_prey, "Are you certain that you to spawn in [src]'s [belly_choice][absorbed ? ", absorbed" : ""]?", "Inbelly Spawning", list("Yes", "No"))

	if(confirmation_prey == "Yes" && potential_prey && src && belly_choice)
		//Now we finally spawn them in!
		if(!is_alien_whitelisted(potential_prey, GLOB.all_species[potential_prey.prefs.species]))
			to_chat(potential_prey, span_notice("You are not whitelisted to play as currently selected character."))
			to_chat(src, span_notice("Prey accepted the confirmation, but something went wrong with spawning their character."))
			return
		inbelly_spawn(potential_prey, src, belly_choice, absorbed)
	else
		to_chat(potential_prey, span_notice("Inbelly spawn cancelled."))
		to_chat(src, span_notice("Prey cancelled their inbelly spawn request."))
		return

/proc/inbelly_spawn(client/prey, mob/living/pred, obj/belly/target_belly, var/absorbed = FALSE)
	// All this is basically admin late spawn-in, but skipping all parts related to records and equipment and with predteremined location
	var/player_key = prey.key
	var/picked_ckey = prey.ckey
	var/picked_slot = prey.prefs.default_slot
	var/mob/living/carbon/human/new_character

	new_character = new(null)		// Spawn them in nullspace first. Can't have "Defaultname Defaultnameson slides into your Stomach".

	if(!new_character)
		return

	prey.prefs.copy_to(new_character)
	if(new_character.dna)
		new_character.dna.ResetUIFrom(new_character)
		new_character.sync_dna_traits(TRUE) // Traitgenes Sync traits to genetics if needed
		new_character.sync_organ_dna()
	new_character.initialize_vessel()
	new_character.key = player_key
	if(new_character.mind)
		var/datum/antagonist/antag_data = get_antag_data(new_character.mind.special_role)
		if(antag_data)
			antag_data.add_antagonist(new_character.mind)
			antag_data.place_mob(new_character)

	if(new_character.mind)
		new_character.mind.loaded_from_ckey = picked_ckey
		new_character.mind.loaded_from_slot = picked_slot

	for(var/lang in prey.prefs.alternate_languages)
		var/datum/language/chosen_language = GLOB.all_languages[lang]
		if(chosen_language)
			if(is_lang_whitelisted(prey,chosen_language) || (new_character.species && (chosen_language.name in new_character.species.secondary_langs)))
				new_character.add_language(lang)
	for(var/key in prey.prefs.language_custom_keys)
		if(prey.prefs.language_custom_keys[key])
			var/datum/language/keylang = GLOB.all_languages[prey.prefs.language_custom_keys[key]]
			if(keylang)
				new_character.language_keys[key] = keylang
	// VOREStation Add: Preferred Language Setting;
	if(prey.prefs.preferred_language) // Do we have a preferred language?
		var/datum/language/def_lang = GLOB.all_languages[prey.prefs.preferred_language]
		if(def_lang)
			new_character.default_language = def_lang
	// VOREStation Add End

	new_character.regenerate_icons()

	new_character.update_transform()

	new_character.forceMove(target_belly)		// Now that they're all setup and configured, send them to their destination.

	if(absorbed)
		target_belly.absorb_living(new_character)	// Glorp.

	log_admin("[prey] (as [new_character.real_name] has spawned inside one of [pred]'s bellies.")				// Log it. Avoid abuse.
	message_admins("[prey] (as [new_character.real_name] has spawned inside one of [pred]'s bellies.", 1)

	return new_character			// incase its ever needed
