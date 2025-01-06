/obj/machinery/transhuman/autoresleever
	name = "automatic resleever"
	desc = "Uses advanced technology to detect when someone needs to be resleeved, and automatically prints and sleeves them into a new body. It even generates its own biomass!"
	icon = 'icons/obj/machines/autoresleever.dmi'
	icon_state = "autoresleever"
	density = TRUE
	anchored = TRUE
	var/equip_body = FALSE				//If true, this will spawn the person with equipment
	var/default_job = JOB_ALT_VISITOR		//The job that will be assigned if equip_body is true and the ghost doesn't have a job
	var/ghost_spawns = FALSE			//If true, allows ghosts who haven't been spawned yet to spawn
	var/vore_respawn = 5 MINUTES		//The time to wait if you died from vore
	var/respawn = 30 MINUTES			//The time to wait if you didn't die from vore
	var/spawn_slots = -1				//How many people can be spawned from this? If -1 it's unlimited
	var/spawntype						//The kind of mob that will be spawned, if set.

/obj/machinery/transhuman/autoresleever/update_icon()
	. = ..()
	if(stat)
		icon_state = "autoresleever-o"
	else
		icon_state = "autoresleever"

/obj/machinery/transhuman/autoresleever/power_change()
	. = ..()
	update_icon()

/obj/machinery/transhuman/autoresleever/attack_ghost(mob/observer/dead/user as mob)
	update_icon()
	if(spawn_slots == 0)
		to_chat(user, span_warning("There are no more respawn slots."))
		return
	if(user.mind)
		if(user.mind.vore_death)
			if(vore_respawn <= world.time - user.timeofdeath)
				autoresleeve(user)
			else
				to_chat(user, span_warning("You must wait [((vore_respawn - (world.time - user.timeofdeath)) * 0.1) / 60] minutes to use \the [src]."))
				return
		else if(respawn <= world.time - user.timeofdeath)
			autoresleeve(user)
		else
			to_chat(user, span_warning("You must wait [((respawn - (world.time - user.timeofdeath)) * 0.1) /60] minutes to use \the [src]."))
			return
	else if(spawntype)
		if(tgui_alert(user, "This [src] spawns something special, would you like to play as it?", "Creachur", list("No","Yes")) == "Yes")
			autoresleeve(user)
	else if(ghost_spawns)
		if(tgui_alert(user, "Would you like to be spawned here as your presently loaded character?", "Spawn here", list("No","Yes")) == "Yes")
			autoresleeve(user)
	else
		to_chat(user, span_warning("You need to have been spawned in order to respawn here."))

/obj/machinery/transhuman/autoresleever/attackby(var/mob/user)	//Let's not let people mess with this.
	update_icon()
	if(isobserver(user))
		attack_ghost(user)
	else
		return

/obj/machinery/transhuman/autoresleever/proc/autoresleeve(var/mob/observer/dead/ghost)
	if(stat)
		to_chat(ghost, span_warning("This machine is not functioning..."))
		return
	if(!isobserver(ghost))
		return
	if(ghost.mind && ghost.mind.current && ghost.mind.current.stat != DEAD)
		if(istype(ghost.mind.current.loc, /obj/item/mmi))
			if(tgui_alert(ghost, "Your brain is still alive, using the auto-resleever will delete that brain. Are you sure?", "Delete Brain", list("No","Yes")) != "Yes")
				return
			if(istype(ghost.mind.current.loc, /obj/item/mmi))
				qdel(ghost.mind.current.loc)
		else
			to_chat(ghost, span_warning("Your body is still alive, you cannot be resleeved."))
			return

	var/client/ghost_client = ghost.client

	if(!is_alien_whitelisted(ghost, GLOB.all_species[ghost_client?.prefs?.species]) && !check_rights(R_ADMIN, 0)) // Prevents a ghost ghosting in on a slot and spawning via a resleever with race they're not whitelisted for, getting around normal join restrictions.
		to_chat(ghost, span_warning("You are not whitelisted to spawn as this species!"))
		return

	/* // Comments out NO_SCAN restriction, as per headmin/maintainer request.
	var/datum/species/chosen_species
	if(ghost.client.prefs.species) // In case we somehow don't have a species set here.
		chosen_species = GLOB.all_species[ghost_client.prefs.species]

	if(chosen_species.flags && NO_SCAN) // Sanity. Prevents species like Xenochimera, Proteans, etc from rejoining the round via resleeve, as they should have their own methods of doing so already, as agreed to when you whitelist as them.
		to_chat(ghost, span_warning("This species cannot be resleeved!"))
		return
	*/

	//Name matching is ugly but mind doesn't persist to look at.
	var/charjob
	var/datum/data/record/record_found
	record_found = find_general_record("name",ghost_client.prefs.real_name)

	//Found their record, they were spawned previously
	if(record_found)
		charjob = record_found.fields["real_rank"]
	else if(equip_body || ghost_spawns)
		charjob = default_job
	else
		to_chat(ghost, span_warning("It appears as though your loaded character has not been spawned this round, or has quit the round. If you died as a different character, please load them, and try again."))
		return

	//For logging later
	var/player_key = ghost_client.key
	var/picked_ckey = ghost_client.ckey
	var/picked_slot = ghost_client.prefs.default_slot

	var/spawnloc = get_turf(src)
	//Did we actually get a loc to spawn them?
	if(!spawnloc)
		to_chat(ghost, span_warning("Could not find a valid location to spawn your character."))
		return

	if(spawntype)
		var/spawnthing = new spawntype(spawnloc)
		if(isliving(spawnthing))
			var/mob/living/L = spawnthing
			L.key = player_key
			L.ckey = picked_ckey
			log_admin("[L.ckey]'s has been spawned as [L] via \the [src].")
			message_admins("[L.ckey]'s has been spawned as [L] via \the [src].")
		else
			to_chat(ghost, span_warning("You can't play as a [spawnthing]..."))
			return
		if(spawn_slots == -1)
			return
		else if(spawn_slots == 0)
			return
		else
			spawn_slots --
			return

	if(tgui_alert(ghost, "Would you like to be resleeved?", "Resleeve", list("No","Yes")) != "Yes")
		return
	var/mob/living/carbon/human/new_character
	new_character = new(spawnloc)

	//We were able to spawn them, right?
	if(!new_character)
		to_chat(ghost, "Something went wrong and spawning failed.")
		return

	//Write the appearance and whatnot out to the character
	ghost_client.prefs.copy_to(new_character)
	if(new_character.dna)
		new_character.dna.ResetUIFrom(new_character)
		new_character.sync_organ_dna()
	if(ghost.mind)
		ghost.mind.transfer_to(new_character)

	new_character.key = player_key

	//Were they any particular special role? If so, copy.
	if(new_character.mind)
		new_character.mind.loaded_from_ckey = picked_ckey
		new_character.mind.loaded_from_slot = picked_slot
		var/datum/antagonist/antag_data = get_antag_data(new_character.mind.special_role)
		if(antag_data)
			antag_data.add_antagonist(new_character.mind)
			antag_data.place_mob(new_character)

	for(var/lang in ghost_client.prefs.alternate_languages)
		var/datum/language/chosen_language = GLOB.all_languages[lang]
		if(chosen_language)
			if(is_lang_whitelisted(ghost,chosen_language) || (new_character.species && (chosen_language.name in new_character.species.secondary_langs)))
				new_character.add_language(lang)
	for(var/key in ghost_client.prefs.language_custom_keys)
		if(ghost_client.prefs.language_custom_keys[key])
			var/datum/language/keylang = GLOB.all_languages[ghost_client.prefs.language_custom_keys[key]]
			if(keylang)
				new_character.language_keys[key] = keylang
	// VOREStation Add: Preferred Language Setting;
	if(ghost_client.prefs.preferred_language) // Do we have a preferred language?
		var/datum/language/def_lang = GLOB.all_languages[ghost_client.prefs.preferred_language]
		if(def_lang)
			new_character.default_language = def_lang
	// VOREStation Add End

	//If desired, apply equipment.
	if(equip_body)
		if(charjob)
			job_master.EquipRank(new_character, charjob, 1)
			new_character.mind.assigned_role = charjob
			new_character.mind.role_alt_title = job_master.GetPlayerAltTitle(new_character, charjob)

	//A redraw for good measure
	new_character.regenerate_icons()

	new_character.update_transform()

	log_admin("[new_character.ckey]'s character [new_character.real_name] has been auto-resleeved.")
	message_admins("[new_character.ckey]'s character [new_character.real_name] has been auto-resleeved.")

	var/obj/item/implant/backup/imp = new(src)

	if(imp.handle_implant(new_character,new_character.zone_sel.selecting))
		imp.post_implant(new_character)

	var/datum/transcore_db/db = SStranscore.db_by_mind_name(new_character.mind.name)
	if(db)
		var/datum/transhuman/mind_record/record = db.backed_up[new_character.mind.name]
		if((world.time - record.last_notification) < 30 MINUTES)
			global_announcer.autosay("[new_character.name] has been resleeved by the automatic resleeving system.", "TransCore Oversight", new_character.isSynthetic() ? "Science" : "Medical")
		spawn(0)	//Wait a second for nif to do its thing if there is one
		if(record.nif_path)
			var/obj/item/nif/nif
			if(new_character.nif)
				nif = new_character.nif
			else
				nif = new record.nif_path(new_character,null,record.nif_savedata)
			spawn(0)	//Wait another second in case we just gave them a new nif
			if(nif)	//Now restore the software
				for(var/path in record.nif_software)
					new path(nif)
				nif.durability = record.nif_durability

	if(spawn_slots == -1)
		return
	else if(spawn_slots == 0)
		return
	else
		spawn_slots --
		return
