//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:33

/mob/new_player
	var/ready = 0
	var/spawning = 0			//Referenced when you want to delete the new_player later on in the code.
	var/totalPlayers = 0		//Player counts for the Lobby tab
	var/totalPlayersReady = 0
	var/has_respawned = FALSE	//Determines if we're using RESPAWN_MESSAGE
	var/datum/tgui_window/lobby_window = null
	var/datum/tgui_module/crew_manifest/new_player/manifest_dialog = null
	var/datum/tgui_module/late_choices/late_choices_dialog = null
	universal_speak = 1

	invisibility = INVISIBILITY_ABSTRACT

	density = FALSE
	stat = 2
	canmove = 0

	anchored = TRUE	//  don't get pushed around

	var/created_for

/mob/new_player/Initialize(mapload)
	. = ..()
	add_verb(src, /mob/proc/insidePanel)

/mob/new_player/Destroy()
	if(manifest_dialog)
		QDEL_NULL(manifest_dialog)
	if(late_choices_dialog)
		QDEL_NULL(late_choices_dialog)
	. = ..()

/mob/new_player/get_status_tab_items()
	. = ..()
	. += ""

	. += "Game Mode: [SSticker.hide_mode ? "Secret" : "[config.mode_names[GLOB.master_mode]]"]"

	// if(SSvote.mode)
	// 	. += "Vote: [capitalize(SSvote.mode)] Time Left: [SSvote.time_remaining] s"

	if(SSticker.current_state == GAME_STATE_INIT)
		. += "Time To Start: Server Initializing"

	else if(SSticker.current_state == GAME_STATE_PREGAME)
		. += "Time To Start: [round(SSticker.pregame_timeleft,1)][GLOB.round_progressing ? "" : " (DELAYED)"]"
		. += "Players: [totalPlayers]"
		. += "Players Ready: [totalPlayersReady]"
		totalPlayers = 0
		totalPlayersReady = 0
		var/datum/job/refJob = null
		for(var/mob/new_player/player in player_list)
			refJob = player.client?.prefs.get_highest_job()
			var/obfuscate_key = player.read_preference(/datum/preference/toggle/obfuscate_key)
			var/obfuscate_job = player.read_preference(/datum/preference/toggle/obfuscate_job)
			if(obfuscate_key && obfuscate_job)
				. += "Anonymous User [player.ready ? "Ready!" : null]"
			else if(obfuscate_key)
				. += "Anonymous User [player.ready ? "(Playing as: [refJob ? refJob.title : "Unknown"])" : null]"
			else if(obfuscate_job)
				. += "[player.key] [player.ready ? "Ready!" : null]"
			else
				. += "[player.key] [player.ready ? "(Playing as: [refJob ? refJob.title : "Unknown"])" : null]"
			totalPlayers++
			if(player.ready)totalPlayersReady++

/mob/new_player/Topic(href, href_list[])
	if(!client)	return 0

	if(href_list["privacy_poll"])
		establish_db_connection()
		if(!SSdbcore.IsConnected())
			return
		var/voted = 0

		//First check if the person has not voted yet.
		var/datum/db_query/query = SSdbcore.NewQuery("SELECT * FROM erro_privacy WHERE ckey='[src.ckey]'")
		query.Execute()
		while(query.NextRow())
			voted = 1
			break
		qdel(query)
		//This is a safety switch, so only valid options pass through
		var/option = "UNKNOWN"
		switch(href_list["privacy_poll"])
			if("signed")
				option = "SIGNED"
			if("anonymous")
				option = "ANONYMOUS"
			if("nostats")
				option = "NOSTATS"
			if("later")
				usr << browse(null,"window=privacypoll")
				return
			if("abstain")
				option = "ABSTAIN"

		if(option == "UNKNOWN")
			return

		if(!voted)
			var/sql = "INSERT INTO erro_privacy VALUES (null, Now(), '[src.ckey]', '[option]')"
			var/datum/db_query/query_insert = SSdbcore.NewQuery(sql)
			query_insert.Execute()
			to_chat(usr, span_bold("Thank you for your vote!"))
			qdel(query_insert)
			usr << browse(null,"window=privacypoll")

	if(!ready && href_list["preference"])
		if(client)
			client.prefs.process_link(src, href_list)

	if(href_list["pollid"])

		var/pollid = href_list["pollid"]
		if(istext(pollid))
			pollid = text2num(pollid)
		if(isnum(pollid))
			src.poll_player(pollid)
		return

	if(href_list["votepollid"] && href_list["votetype"])
		var/pollid = text2num(href_list["votepollid"])
		var/votetype = href_list["votetype"]
		switch(votetype)
			if("OPTION")
				var/optionid = text2num(href_list["voteoptionid"])
				vote_on_poll(pollid, optionid)
			if("TEXT")
				var/replytext = href_list["replytext"]
				log_text_poll_reply(pollid, replytext)
			if("NUMVAL")
				var/id_min = text2num(href_list["minid"])
				var/id_max = text2num(href_list["maxid"])

				if( (id_max - id_min) > 100 )	//Basic exploit prevention
					to_chat(usr, "The option ID difference is too big. Please contact administration or the database admin.")
					return

				for(var/optionid = id_min; optionid <= id_max; optionid++)
					if(!isnull(href_list["o[optionid]"]))	//Test if this optionid was replied to
						var/rating
						if(href_list["o[optionid]"] == "abstain")
							rating = null
						else
							rating = text2num(href_list["o[optionid]"])
							if(!isnum(rating))
								return

						vote_on_numval_poll(pollid, optionid, rating)
			if("MULTICHOICE")
				var/id_min = text2num(href_list["minoptionid"])
				var/id_max = text2num(href_list["maxoptionid"])

				if( (id_max - id_min) > 100 )	//Basic exploit prevention
					to_chat(usr, "The option ID difference is too big. Please contact administration or the database admin.")
					return

				for(var/optionid = id_min; optionid <= id_max; optionid++)
					if(!isnull(href_list["option_[optionid]"]))	//Test if this optionid was selected
						vote_on_poll(pollid, optionid, 1)


/mob/new_player/proc/handle_server_news()
	if(!client)
		return
	var/savefile/F = get_server_news()
	if(F)
		client.prefs.lastnews = md5(F["body"])
		SScharacter_setup.queue_preferences_save(client.prefs)

		var/dat = "<html><body><center>"
		dat += "<h1>[F["title"]]</h1>"
		dat += "<br>"
		dat += "[F["body"]]"
		dat += "<br>"
		dat += span_normal(span_italics("Last written by [F["author"]], on [F["timestamp"]]."))
		dat += "</center></body></html>"
		var/datum/browser/popup = new(src, "Server News", "Server News", 450, 300, src)
		popup.set_content(dat)
		popup.open()

/mob/proc/time_till_respawn()
	if(!ckey)
		return -1 // What?

	var/timer = GLOB.respawn_timers[ckey]
	// No timer at all
	if(!timer)
		return 0
	// Special case, infinite timer
	if(timer == -1)
		return -1
	// Timer expired
	if(timer <= world.time)
		GLOB.respawn_timers -= ckey
		return 0
	// Timer still going
	return timer - world.time

/mob/new_player/proc/IsJobAvailable(rank)
	var/datum/job/job = job_master.GetJob(rank)
	if(!job)
		return 0
	if(!job.is_position_available())
		return 0
	if(jobban_isbanned(src,rank))
		return 0
	if(!job.player_old_enough(src.client))
		return 0
	if(!job.player_has_enough_playtime(src.client))
		return 0
	if(!is_job_whitelisted(src,rank))
		return 0
	if(!job.player_has_enough_pto(src.client))
		return 0
	return 1


/mob/new_player/proc/AttemptLateSpawn(rank,var/spawning_at)
	if (src != usr)
		return 0
	if(!ticker || ticker.current_state != GAME_STATE_PLAYING)
		to_chat(src, span_red("The round is either not ready, or has already finished..."))
		return 0
	if(!CONFIG_GET(flag/enter_allowed))
		to_chat(src, span_notice("There is an administrative lock on entering the game!"))
		return 0
	if(!IsJobAvailable(rank))
		tgui_alert_async(src,"[rank] is not available. Please try another.")
		return 0
	if(!spawn_checks_vr(rank)) return 0
	if(!client)
		return 0

	//Find our spawning point.
	var/list/join_props = job_master.LateSpawn(client, rank)

	if(!join_props)
		return

	var/turf/T = join_props["turf"]
	var/join_message = join_props["msg"]
	var/announce_channel = join_props["channel"] || "Common"

	if(!T || !join_message)
		return 0

	spawning = 1
	close_spawn_windows()

	var/obj/item/itemtf = join_props["itemtf"]
	if(itemtf && istype(itemtf, /obj/item/capture_crystal))
		var/obj/item/capture_crystal/cryst = itemtf
		if(cryst.spawn_mob_type)
			// We want to be a spawned mob instead of a person aaaaa
			var/mob/living/carrier = join_props["carrier"]
			var/vorgans = join_props["vorgans"]
			cryst.bound_mob = new cryst.spawn_mob_type(cryst)
			cryst.spawn_mob_type = null
			cryst.bound_mob.ai_holder_type = /datum/ai_holder/simple_mob/inert
			cryst.bound_mob.key = src.key
			log_and_message_admins("[key_name_admin(src)] joined [cryst.bound_mob] inside a capture crystal [ADMIN_FLW(cryst.bound_mob)]")
			if(vorgans)
				cryst.bound_mob.copy_from_prefs_vr()
			if(istype(carrier))
				cryst.capture(cryst.bound_mob, carrier)
			else
				//Something went wrong, but lets try to do as much as we can.
				cryst.bound_mob.capture_caught = TRUE
				cryst.persist_storable = FALSE
			cryst.update_icon()
			qdel(src)
			return

	job_master.AssignRole(src, rank, 1)

	var/mob/living/character = create_character(T)	//creates the human and transfers vars and mind
	character = job_master.EquipRank(character, rank, 1)					//equips the human
	UpdateFactionList(character)

	var/datum/job/J = SSjob.get_job(rank)

	// AIs don't need a spawnpoint, they must spawn at an empty core
	if(J.mob_type & JOB_SILICON_AI)

		// IsJobAvailable for AI checks that there is an empty core available in this list
		var/obj/structure/AIcore/deactivated/C = GLOB.empty_playable_ai_cores[1]
		GLOB.empty_playable_ai_cores -= C

		character.loc = C.loc

		// AIize the character, but don't move them yet
		character = character.AIize(move = FALSE) // Dupe of code in /datum/controller/subsystem/ticker/proc/create_characters() for non-latespawn, unify?

		AnnounceCyborg(character, rank, "has been transferred to the empty core in \the [character.loc.loc]")
		ticker.mode.latespawn(character)

		qdel(C) //Deletes empty core (really?)
		qdel(src) //Deletes new_player
		return

	// Moving wheelchair if they have one
	if(character.buckled && istype(character.buckled, /obj/structure/bed/chair/wheelchair))
		character.buckled.loc = character.loc
		character.buckled.set_dir(character.dir)

	ticker.mode.latespawn(character)

	if(rank == JOB_OUTSIDER)
		log_and_message_admins("has joined the round as non-crew. (<A href='byond://?_src_=holder;[HrefToken()];adminplayerobservecoodjump=1;X=[T.x];Y=[T.y];Z=[T.z]'>JMP</a>)",character)
		if(!(J.mob_type & JOB_SILICON))
			ticker.minds += character.mind
	else if(rank == JOB_ANOMALY)
		log_and_message_admins("has joined the round as anomaly. (<A href='byond://?_src_=holder;[HrefToken()];adminplayerobservecoodjump=1;X=[T.x];Y=[T.y];Z=[T.z]'>JMP</a>)",character)
		if(!(J.mob_type & JOB_SILICON))
			ticker.minds += character.mind
	else if(J.mob_type & JOB_SILICON)
		AnnounceCyborg(character, rank, join_message, announce_channel, character.z)
	else
		AnnounceArrival(character, rank, join_message, announce_channel, character.z)
		GLOB.data_core.manifest_inject(character)
		ticker.minds += character.mind//Cyborgs and AIs handle this in the transform proc.	//TODO!!!!! ~Carn
	if(ishuman(character))
		if(character.client.prefs.auto_backup_implant)
			var/obj/item/implant/backup/imp = new(src)

			if(imp.handle_implant(character,character.zone_sel.selecting))
				imp.post_implant(character)
	var/gut = join_props["voreny"]
	var/start_absorbed = join_props["absorb"]
	var/mob/living/prey = join_props["prey"]
	if(itemtf && istype(itemtf, /obj/item/capture_crystal))
		//We want to be in the crystal, not actually possessing the crystal.
		var/obj/item/capture_crystal/cryst = itemtf
		var/mob/living/carrier = join_props["carrier"]
		cryst.capture(character, carrier)
		character.forceMove(cryst)
		cryst.update_icon()
	else if(itemtf)
		itemtf.inhabit_item(character, itemtf.name, character)
		var/mob/living/possessed_voice = itemtf.possessed_voice
		itemtf.trash_eatable = character.devourable
		itemtf.unacidable = !character.digestable
		character.forceMove(possessed_voice)
	else if(prey)
		character.copy_from_prefs_vr(1,1) //Yes I know we're reloading these, shut up
		var/obj/belly/gut_to_enter
		for(var/obj/belly/B in character.vore_organs)
			if(B.name == gut)
				gut_to_enter = B
				character.vore_selected = B
		var/datum/effect/effect/system/teleport_greyscale/tele = new /datum/effect/effect/system/teleport_greyscale()
		tele.set_up("#00FFFF", get_turf(prey))
		tele.start()
		character.forceMove(get_turf(prey))
		if(start_absorbed)
			prey.absorbed = 1
		prey.forceMove(gut_to_enter)
	else
		if(gut)
			if(start_absorbed)
				character.absorbed = 1
			character.forceMove(gut)

	character.client.init_verbs()
	qdel(src) // Delete new_player mob

/mob/new_player/proc/AnnounceCyborg(var/mob/living/character, var/rank, var/join_message, var/channel, var/zlevel)
	if (ticker.current_state == GAME_STATE_PLAYING)
		var/list/zlevels = zlevel ? using_map.get_map_levels(zlevel, TRUE, om_range = DEFAULT_OVERMAP_RANGE) : null
		if(character.mind.role_alt_title)
			rank = character.mind.role_alt_title
		// can't use their name here, since cyborg namepicking is done post-spawn, so we'll just say "A new Cyborg has arrived"/"A new Android has arrived"/etc.
		GLOB.global_announcer.autosay("A new[rank ? " [rank]" : " visitor" ] [join_message ? join_message : "has arrived on the station"].", "Arrivals Announcement Computer", channel, zlevels)

/mob/new_player/proc/LateChoices()
	if(!late_choices_dialog)
		late_choices_dialog = new(src)
	late_choices_dialog.tgui_interact(src)

/mob/new_player/proc/create_character(var/turf/T)
	spawning = 1
	close_spawn_windows()

	var/mob/living/carbon/human/new_character

	var/use_species_name
	var/datum/species/chosen_species
	if(client.prefs.species)
		chosen_species = GLOB.all_species[client.prefs.species]
		use_species_name = chosen_species.get_station_variant() //Only used by pariahs atm.

	if(chosen_species && use_species_name)
		// Have to recheck admin due to no usr at roundstart. Latejoins are fine though.
		if(is_alien_whitelisted(src.client, chosen_species))
			new_character = new(T, use_species_name)

	if(!new_character)
		new_character = new(T)

	if(ticker.random_players)
		new_character.gender = pick(MALE, FEMALE)
		client.prefs.real_name = random_name(new_character.gender)
		client.prefs.randomize_appearance_and_body_for(new_character)
	else
		client.prefs.copy_to(new_character, icon_updates = TRUE)

	if(client && client.media)
		client.media.stop_music() // MAD JAMS cant last forever yo

	if(mind)
		mind.active = 0					//we wish to transfer the key manually
		mind.original = new_character
		mind.loaded_from_ckey = client.ckey
		mind.loaded_from_slot = client.prefs.default_slot
		mind.transfer_to(new_character)					//won't transfer key since the mind is not active

	new_character.name = real_name
	client.init_verbs()
	new_character.dna.ready_dna(new_character)
	new_character.dna.b_type = client.prefs.b_type
	new_character.sync_dna_traits(TRUE) // Traitgenes Sync traits to genetics if needed
	new_character.sync_organ_dna()
	new_character.initialize_vessel()

	for(var/lang in client.prefs.alternate_languages)
		var/datum/language/chosen_language = GLOB.all_languages[lang]
		if(chosen_language)
			if(is_lang_whitelisted(src,chosen_language) || (new_character.species && (chosen_language.name in new_character.species.secondary_langs)))
				new_character.add_language(lang)
	for(var/key in client.prefs.language_custom_keys)
		if(client.prefs.language_custom_keys[key])
			var/datum/language/keylang = GLOB.all_languages[client.prefs.language_custom_keys[key]]
			if(keylang)
				new_character.language_keys[key] = keylang
	// VOREStation Add: Preferred Language Setting;
	if(client.prefs.preferred_language) // Do we have a preferred language?
		var/datum/language/def_lang = GLOB.all_languages[client.prefs.preferred_language]
		if(def_lang)
			new_character.default_language = def_lang
	// VOREStation Add End
	// And uncomment this, too.
	//new_character.dna.UpdateSE()

	// Do the initial caching of the player's body icons.
	new_character.force_update_limbs()
	new_character.update_icons_body()
	new_character.update_transform() //VOREStation Edit

	new_character.key = key		//Manually transfer the key to log them in

	return new_character

/mob/new_player/proc/ViewManifest()
	if(!manifest_dialog)
		manifest_dialog = new(src)
	manifest_dialog.tgui_interact(src)

/mob/new_player/Move()
	return 0

/mob/new_player/proc/close_spawn_windows()
	manifest_dialog?.close_ui()
	late_choices_dialog?.close_ui()

	src << browse(null, "window=latechoices") //closes late choices window
	src << browse(null, "window=preferences_window") //VOREStation Edit?
	src << browse(null, "window=News") //closes news window

/mob/new_player/get_species()
	var/datum/species/chosen_species
	if(client.prefs.species)
		chosen_species = GLOB.all_species[client.prefs.species]

	if(!chosen_species)
		return SPECIES_HUMAN

	if(is_alien_whitelisted(src.client, chosen_species))
		return chosen_species.name

	return SPECIES_HUMAN

/mob/new_player/get_gender()
	if(!client || !client.prefs) ..()
	return client.prefs.biological_gender

/mob/new_player/is_ready()
	return ready && ..()

// Prevents lobby players from seeing say, even with ghostears
/mob/new_player/hear_say(var/list/message_pieces, var/verb = "says", var/italics = 0, var/mob/speaker = null)
	return

/mob/new_player/hear_holopad_talk(list/message_pieces, var/verb = "says", var/mob/speaker = null)
	return

/mob/new_player/hear_holopad_talk(list/message_pieces, var/verb = "says", var/mob/speaker = null)
	return

// Prevents lobby players from seeing emotes, even with ghosteyes
/mob/new_player/show_message(msg, type, alt, alt_type)
	return

/mob/new_player/hear_radio()
	return

/mob/new_player/MayRespawn()
	return 1
