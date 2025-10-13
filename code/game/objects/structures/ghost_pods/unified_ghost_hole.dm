/obj/structure/ghost_pod/ghost_activated/unified_hole
	name = "maintenance critter hole"
	desc = "This is my hole! It was made for me!"
	icon = 'icons/effects/effects.dmi'
	icon_state = "rift"
	icon_state_opened = "tendril_dead"
	density = FALSE
	ghost_query_type = /datum/ghost_query/maints_spawner
	anchored = TRUE
	invisibility = INVISIBILITY_OBSERVER
	spawn_active = TRUE
	var/redgate_restricted = FALSE

//override the standard attack_ghost proc for custom messages
/obj/structure/ghost_pod/ghost_activated/unified_hole/attack_ghost(var/mob/observer/dead/user)
	var/choice
	if(jobban_isbanned(user, JOB_GHOSTROLES))
		to_chat(user, span_warning("You cannot use this spawnpoint because you are banned from playing ghost roles."))
		return

	//No OOC notes/FT
	if(not_has_ooc_text(user))
		//to_chat(user, span_warning("You must have proper out-of-character notes and flavor text configured for your current character slot to use this spawnpoint."))
		return

	if(redgate_restricted)
		choice = tgui_alert(user, "Which type of critter do you wish to spawn as? Note that this is a Redgate Spawner: if you choose the Lurker role you will not be able to leave through the redgate until another character grants you permission by clicking on the redgate with you nearby. Are you absolutely sure you wish to continue?", "Redgate Critter Spawner", list("Mob", "Morph", "Lurker", "Cancel"))
	else
		choice = tgui_alert(user, "Which type of critter do you wish to spawn as?", "Critter Spawner", list("Mob", "Morph", "Lurker", "Cancel"))


	if(choice == "Mob")
		create_simplemob(user)
	else if(choice == "Morph")
		create_morph(user)
	else if(choice == "Lurker")
		if(!is_alien_whitelisted(user.client, GLOB.all_species[user.client.prefs.species]))
			to_chat(user, span_warning("You cannot use this spawnpoint to spawn as a species you are not whitelisted for!"))
			return
		else
			create_lurker(user)
	else if(choice == "Cancel")
		return

/obj/structure/ghost_pod/ghost_activated/unified_hole/proc/create_simplemob(var/mob/M)
	var/choice
	var/finalized = FALSE
	GLOB.active_ghost_pods -= src

	if(needscharger)
		new /obj/machinery/recharge_station/ghost_pod_recharger(src.loc)

	while(!finalized && M.client)
		choice = tgui_input_list(M, "What type of critter do you want to play as?", "Critter Choice", GLOB.maint_mob_pred_options)
		if(!choice)	//We probably pushed the cancel button on the mob selection. Let's just put the ghost pod back in the list.
			to_chat(M, span_notice("No mob selected, cancelling."))
			reset_ghostpod()
			return

		if(choice)
			finalized = tgui_alert(M, "Are you sure you want to play as [choice]?","Confirmation",list("No","Yes"))

	if(!choice)	//If somehow we ended up here and we don't have a choice, let's just reset things!
		reset_ghostpod()
		return

	var/mobtype = GLOB.maint_mob_pred_options[choice]
	var/mob/living/simple_mob/newPred = new mobtype(get_turf(src))
	qdel(newPred.ai_holder)
	newPred.ai_holder = null
	//newPred.movement_cooldown = 0			// The "needless artificial speed cap" exists for a reason
	// R.has_hands = TRUE // Downstream
	if(M.mind)
		M.mind.transfer_to(newPred)
	to_chat(M, span_notice("You are " + span_bold("[newPred]") + ", somehow having stowed away in search of food, shelter, or safety. The environment around you is a strange and unfamiliar one, but sooner or later you'll have to leave your hiding place in search of food. How you choose to do so is up to you, just beware that you don't end up falling prey to some other creature."))
	to_chat(M, span_critical("Please be advised, this role is NOT AN ANTAGONIST."))
	to_chat(M, span_warning("You may be a spooky (or cute!) space critter, but your role is to facilitate roleplay, not to fight the station and slaughter people. You're free to get into any kind of roleplay scene you like if OOC prefs align, but emphasis is on the 'roleplay' here. If you intend to be an actual threat, you MUST seek permission from staff first. GENERALLY, this role should avoid well populated areas, but you might be able to get away with it if you spawn as something relatively innocuous."))
	newPred.ckey = M.ckey
	newPred.visible_message(span_warning("[newPred] emerges from somewhere!"))
	log_and_message_admins("successfully used a Maintenance Critter spawner to spawn in as a [newPred].", newPred)
	if(tgui_alert(newPred, "Do you want to load the vore bellies from your current slot?", "Load Bellies", list("Yes", "No")) == "Yes")
		newPred.copy_from_prefs_vr()
		if(LAZYLEN(newPred.vore_organs))
			newPred.vore_selected = newPred.vore_organs[1]
	qdel(src)

/obj/structure/ghost_pod/ghost_activated/unified_hole/proc/create_morph(var/mob/M)
	GLOB.active_ghost_pods -= src
	var/mob/living/simple_mob/vore/morph/newMorph = new /mob/living/simple_mob/vore/morph(get_turf(src))
	newMorph.voremob_loaded = TRUE // On-demand belly loading.
	if(M.mind)
		M.mind.transfer_to(newMorph)
	to_chat(M, span_notice("You are a " + span_bold("Morph") + ", somehow having stowed away in your wandering. You are in a strange and unfamiliar place, but one that's sure to be full of tasty treats and learning opportunities. If you want to survive here for long you should probably seek a convincing disguise, or at the very least take advantage of your amorphous form to slither through the ventilation system and avoid danger that way."))
	to_chat(M, span_notice("You can use shift + click on objects and creatures to disguise yourself as them, but your strikes are nearly useless when you are disguised. \
	You can undisguise yourself by shift + clicking yourself, but changing your shape (whether changing to a false form or returning to your natural form) has a short cooldown. You can also ventcrawl, \
	by using alt + click on the vent or scrubber. Note that it may be impossible to impersonate certain people due to mechanical preference settings."))
	to_chat(M, span_critical("Please be advised, this role is NOT AN ANTAGONIST."))
	to_chat(M, span_warning("You may be a weird goopy creature, but your role is to facilitate weird goopy creature roleplay, not to fight the station and slaughter people. You're free to get into any kind of roleplay scene you like if OOC prefs align, but emphasis is on the 'roleplay' here. If you intend to be an actual threat, you MUST seek permission from staff first. GENERALLY, this role should avoid well populated areas, but you might be able to get away with it if you play your cards right."))

	newMorph.ckey = M.ckey
	newMorph.visible_message(span_warning("A morph appears to crawl out of somewhere."))
	log_and_message_admins("successfully used a Maintenance Critter spawner to spawn in as a Morph.", newMorph)
	if(tgui_alert(newMorph, "Do you want to load the vore bellies from your current slot?", "Load Bellies", list("Yes", "No")) == "Yes")
		newMorph.copy_from_prefs_vr()
		if(LAZYLEN(newMorph.vore_organs))
			newMorph.vore_selected = newMorph.vore_organs[1]
	qdel(src)

/obj/structure/ghost_pod/ghost_activated/unified_hole/proc/create_lurker(var/mob/M)
	var/picked_ckey = M.ckey
	var/picked_slot = M.client.prefs.default_slot
	GLOB.active_ghost_pods -= src

	var/mob/living/carbon/human/new_character = new(src.loc)
	if(!new_character)
		to_chat(M, span_warning("Something went wrong and spawning failed. Please check your character slot doesn't have any obvious errors, then either try again or send an adminhelp!"))
		reset_ghostpod()
		return
	log_and_message_admins("successfully used a Maintenance Critter spawner to spawn in as their loaded character.", M)

	M.client.prefs.copy_to(new_character)
	new_character.dna.ResetUIFrom(new_character)
	new_character.sync_organ_dna()
	new_character.sync_addictions()
	new_character.key = M.key
	new_character.mind.loaded_from_ckey = picked_ckey
	new_character.mind.loaded_from_slot = picked_slot

	job_master.EquipRank(new_character, JOB_MAINT_LURKER, 1)

	for(var/lang in new_character.client.prefs.alternate_languages)
		var/datum/language/chosen_language = GLOB.all_languages[lang]
		if(chosen_language)
			if(is_lang_whitelisted(M, chosen_language) || (new_character.species && (chosen_language.name in new_character.species.secondary_langs)))
				new_character.add_language(lang)

	SEND_SIGNAL(new_character, COMSIG_HUMAN_DNA_FINALIZED)

	new_character.regenerate_icons()

	new_character.update_transform()
	if(redgate_restricted)
		new_character.redgate_restricted = TRUE
		to_chat(new_character, span_notice("You are an inhabitant of this redgate location, you have no special advantages compared to the rest of the crew, so be cautious! You have spawned with an ID that will allow you free access to basic doors, and should possess all of your chosen loadout items that are not role restricted, and can make use of anything you can find in the redgate map."))
	else
		to_chat(new_character, span_notice("You are a " + span_bold(JOB_MAINT_LURKER) + ", a loose end, stowaway, drifter, or somesuch. You have no special advantages compared to the rest of the crew, so be cautious! You have spawned with an ID that will allow you free access to maintenance areas, and should possess all of your chosen loadout items that are not role restricted. You also have a PDA which you can use for messaging purposes, and are free to make use of anything you can find in maintenance."))
	to_chat(new_character, span_critical("Please be advised, this role is " + span_bold("NOT AN ANTAGONIST.")))
	to_chat(new_character, span_notice("Whoever or whatever your chosen character slot is, your role is to facilitate roleplay focused around that character; this role is not free license to attack and murder people without provocation or explicit out-of-character consent. You should probably be cautious around high-traffic and highly sensitive areas (e.g. Telecomms) as Security personnel would be well within their rights to treat you as a trespasser. That said, good luck!"))

	new_character.visible_message(span_warning("[new_character] appears to crawl out of somewhere."))
	qdel(src)

/obj/structure/ghost_pod/ghost_activated/unified_hole/Initialize(mapload)
	. = ..()
	GLOB.active_ghost_pods += src

/obj/structure/ghost_pod/ghost_activated/unified_hole/Destroy()
	. = ..()
	GLOB.active_ghost_pods -= src

/obj/structure/ghost_pod/ghost_activated/unified_hole/redgate
	name = "Redspace inhabitant hole"
	desc = "A starting location for critters who exist inside of the redgate!"
	redgate_restricted = TRUE
