/mob/living/proc/inbelly_spawn_prompt(client/potential_prey)
	if(!potential_prey || !istype(potential_prey))		// Did our prey cease to exist?
		return

	// Are we cool with this prey spawning in at all?
	var/prey_name = potential_prey.prefs.read_preference(/datum/preference/name/real_name)
	var/answer = tgui_alert(src, "[prey_name] wants to spawn in one of your bellies. Do you accept?", "Inbelly Spawning", list("Yes", "No"))
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
	var/confirmation_pred = tgui_alert(src, "Are you certain that you want [prey_name] spawned in your [belly_choice][absorbed ? ", absorbed" : ""]?", "Inbelly Spawning", list("Yes", "No"))

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
	new_character.sync_addictions()
	new_character.initialize_vessel()
	new_character.key = player_key
	if(new_character.mind)
		var/datum/antagonist/antag_data = get_antag_data(new_character.mind.special_role)
		if(antag_data)
			antag_data.add_antagonist(new_character.mind)
			antag_data.place_mob(new_character)
		new_character.mind.loaded_from_ckey = picked_ckey
		new_character.mind.loaded_from_slot = picked_slot
		if(new_character.mind.antag_holder)
			new_character.mind.antag_holder.apply_antags(new_character)

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
	if(prey.prefs.preferred_language) // Do we have a preferred language?
		var/datum/language/def_lang = GLOB.all_languages[prey.prefs.preferred_language]
		if(def_lang)
			new_character.default_language = def_lang

	SEND_SIGNAL(new_character, COMSIG_HUMAN_DNA_FINALIZED)

	new_character.regenerate_icons()

	new_character.update_transform()

	new_character.forceMove(target_belly)		// Now that they're all setup and configured, send them to their destination.

	if(absorbed)
		target_belly.absorb_living(new_character)	// Glorp.

	log_admin("[prey] (as [new_character.real_name] has spawned inside one of [pred]'s bellies.")				// Log it. Avoid abuse.
	message_admins("[prey] (as [new_character.real_name] has spawned inside one of [pred]'s bellies.", 1)

	return new_character			// incase its ever needed

/mob/living/proc/soulcatcher_spawn_prompt(mob/observer/dead/prey, req_time)
	if(tgui_alert(src, "[prey.name] wants to join into your Soulcatcher.","Soulcatcher Request",list("Deny", "Allow"), timeout=1 MINUTES) != "Allow")
		to_chat(prey, span_warning("[src] has denied your request."))
		return

	if((world.time - req_time) > 1 MINUTES)
		to_chat(src, span_warning("The request had already expired. (1 minute waiting max)"))
		return

	if(!soulgem)
		return

	if(prey && prey.key && !stat && soulgem.flag_check(SOULGEM_ACTIVE | SOULGEM_CATCHING_GHOSTS, TRUE))
		if(!prey.mind) //No mind yet, aka haven't played in this round.
			prey.mind = new(prey.key)

		prey.mind.name = prey.name
		prey.mind.current = prey
		prey.mind.active = TRUE

		soulgem.catch_mob(prey) //This will result in the prey being deleted so...

/mob/living/carbon/human/proc/nif_soulcatcher_spawn_prompt(mob/observer/dead/prey, req_time)
	if(tgui_alert(src, "[prey.name] wants to join into your Soulcatcher.","Soulcatcher Request",list("Deny", "Allow"), timeout=1 MINUTES) != "Allow")
		to_chat(prey, span_warning("[src] has denied your request."))
		return

	if((world.time - req_time) > 1 MINUTES)
		to_chat(src, span_warning("The request had already expired. (1 minute waiting max)"))
		return

	if(!nif)
		return

	var/datum/nifsoft/soulcatcher/SC = nif.imp_check(NIF_SOULCATCHER)
	if(!SC)
		to_chat(prey, span_warning("[src] doesn't have the Soulcatcher NIFSoft installed, or their NIF is unpowered."))
		return

	//Final check since we waited for input a couple times.
	if(prey && prey.key && !stat && nif && SC)
		if(!prey.mind) //No mind yet, aka haven't played in this round.
			prey.mind = new(prey.key)

		prey.mind.name = prey.name
		prey.mind.current = prey
		prey.mind.active = TRUE

		SC.catch_mob(prey) //This will result in the prey being deleted so...
