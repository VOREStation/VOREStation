//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:33

/mob/new_player
	var/ready = 0
	var/spawning = 0			//Referenced when you want to delete the new_player later on in the code.
	var/totalPlayers = 0		//Player counts for the Lobby tab
	var/totalPlayersReady = 0
	var/show_hidden_jobs = 0	//Show jobs that are set to "Never" in preferences
	var/datum/browser/panel
	universal_speak = 1

	invisibility = 101

	density = FALSE
	stat = 2
	canmove = 0

	anchored = TRUE	//  don't get pushed around

	var/created_for

/mob/new_player/New()
	mob_list += src
	initialized = TRUE // Explicitly don't use Initialize().  New players join super early and use New()

/mob/new_player/verb/new_player_panel()
	set src = usr
	new_player_panel_proc()


/mob/new_player/proc/new_player_panel_proc()
	var/output = "<div align='center'>"
	/* VOREStation Removal
	output += "[using_map.get_map_info()]"
	output +="<hr>"
	VOREStation Removal End */
	output += "<p><a href='byond://?src=\ref[src];show_preferences=1'>Character Setup</A></p>"

	if(!ticker || ticker.current_state <= GAME_STATE_PREGAME)
		if(ready)
			output += "<p>\[ <span class='linkOn'><b>Ready</b></span> | <a href='byond://?src=\ref[src];ready=0'>Not Ready</a> \]</p>"
		else
			output += "<p>\[ <a href='byond://?src=\ref[src];ready=1'>Ready</a> | <span class='linkOn'><b>Not Ready</b></span> \]</p>"

	else
		output += "<a href='byond://?src=\ref[src];manifest=1'>View the Crew Manifest</A><br><br>"
		output += "<p><a href='byond://?src=\ref[src];late_join=1'>Join Game!</A></p>"

	output += "<p><a href='byond://?src=\ref[src];observe=1'>Observe</A></p>"

	if(!IsGuestKey(src.key))
		establish_db_connection()

		if(dbcon.IsConnected())
			var/isadmin = 0
			if(src.client && src.client.holder)
				isadmin = 1
			var/DBQuery/query = dbcon.NewQuery("SELECT id FROM erro_poll_question WHERE [(isadmin ? "" : "adminonly = false AND")] Now() BETWEEN starttime AND endtime AND id NOT IN (SELECT pollid FROM erro_poll_vote WHERE ckey = \"[ckey]\") AND id NOT IN (SELECT pollid FROM erro_poll_textreply WHERE ckey = \"[ckey]\")")
			query.Execute()
			var/newpoll = 0
			while(query.NextRow())
				newpoll = 1
				break

			if(newpoll)
				output += "<p><b><a href='byond://?src=\ref[src];showpoll=1'>Show Player Polls</A> (NEW!)</b></p>"
			else
				output += "<p><a href='byond://?src=\ref[src];showpoll=1'>Show Player Polls</A></p>"

	if(client.check_for_new_server_news())
		output += "<p><b><a href='byond://?src=\ref[src];shownews=1'>Show Game Updates</A> (NEW!)</b></p>"
	else
		output += "<p><a href='byond://?src=\ref[src];shownews=1'>Show Game Updates</A></p>"

	if(SSsqlite.can_submit_feedback(client))
		output += "<p>[href(src, list("give_feedback" = 1), "Give Feedback")]</p>"

	if(GLOB.news_data.station_newspaper)
		if(client.prefs.lastlorenews == GLOB.news_data.newsindex)
			output += "<p><a href='byond://?src=\ref[src];open_station_news=1'>Show [using_map.station_name] News</A></p>"
		else
			output += "<p><b><a href='byond://?src=\ref[src];open_station_news=1'>Show [using_map.station_name] News (NEW!)</A></b></p>"

	output += "</div>"

	if (client.prefs.lastlorenews == GLOB.news_data.newsindex)
		client.seen_news = 1

	if(GLOB.news_data.station_newspaper && !client.seen_news && client.is_preference_enabled(/datum/client_preference/show_lore_news))
		show_latest_news(GLOB.news_data.station_newspaper)
		client.prefs.lastlorenews = GLOB.news_data.newsindex
		SScharacter_setup.queue_preferences_save(client.prefs)

	panel = new(src, "Welcome","Welcome", 210, 300, src) // VOREStation Edit
	panel.set_window_options("can_close=0")
	panel.set_content(output)
	panel.open()
	return

/mob/new_player/Stat()
	..()

	if(statpanel("Lobby") && SSticker)
		stat("Game Mode:", SSticker.hide_mode ? "Secret" : "[config.mode_names[master_mode]]")

		if(SSvote.mode)
			stat("Vote: [capitalize(SSvote.mode)]", "Time Left: [SSvote.time_remaining] s")

		if(SSticker.current_state == GAME_STATE_INIT)
			stat("Time To Start:", "Server Initializing")

		else if(SSticker.current_state == GAME_STATE_PREGAME)
			stat("Time To Start:", "[round(SSticker.pregame_timeleft,1)][round_progressing ? "" : " (DELAYED)"]")
			stat("Players: [totalPlayers]", "Players Ready: [totalPlayersReady]")
			totalPlayers = 0
			totalPlayersReady = 0
			var/datum/job/refJob = null
			for(var/mob/new_player/player in player_list)
				refJob = player.client.prefs.get_highest_job()
				stat("[player.key]", (player.ready)?("(Playing as: [(refJob)?(refJob.title):("Unknown")])"):(null))
				totalPlayers++
				if(player.ready)totalPlayersReady++

/mob/new_player/Topic(href, href_list[])
	if(!client)	return 0

	if(href_list["show_preferences"])
		client.prefs.ShowChoices(src)
		return 1

	if(href_list["ready"])
		if(!ticker || ticker.current_state <= GAME_STATE_PREGAME) // Make sure we don't ready up after the round has started
			ready = text2num(href_list["ready"])
		else
			ready = 0

	if(href_list["refresh"])
		//src << browse(null, "window=playersetup") //closes the player setup window
		panel.close()
		new_player_panel_proc()

	if(href_list["observe"])
		if(tgui_alert(src,"Are you sure you wish to observe? If you do, make sure to not use any knowledge gained from observing if you decide to join later.","Player Setup",list("Yes","No")) == "Yes")
			if(!client)	return 1

			//Make a new mannequin quickly, and allow the observer to take the appearance
			var/mob/living/carbon/human/dummy/mannequin = new()
			client.prefs.dress_preview_mob(mannequin)
			var/mob/observer/dead/observer = new(mannequin)
			observer.moveToNullspace() //Let's not stay in our doomed mannequin
			qdel(mannequin)

			spawning = 1
			if(client.media)
				client.media.stop_music() // MAD JAMS cant last forever yo

			observer.started_as_observer = 1
			close_spawn_windows()
			var/obj/O = locate("landmark*Observer-Start")
			if(istype(O))
				to_chat(src, "<span class='notice'>Now teleporting.</span>")
				observer.forceMove(O.loc)
			else
				to_chat(src, "<span class='danger'>Could not locate an observer spawn point. Use the Teleport verb to jump to the station map.</span>")

			announce_ghost_joinleave(src)

			if(client.prefs.be_random_name)
				client.prefs.real_name = random_name(client.prefs.identifying_gender)
			observer.real_name = client.prefs.real_name
			observer.name = observer.real_name
			if(!client.holder && !config.antag_hud_allowed)           // For new ghosts we remove the verb from even showing up if it's not allowed.
				observer.verbs -= /mob/observer/dead/verb/toggle_antagHUD        // Poor guys, don't know what they are missing!
			observer.key = key
			observer.set_respawn_timer(time_till_respawn()) // Will keep their existing time if any, or return 0 and pass 0 into set_respawn_timer which will use the defaults
			qdel(src)

			return 1

	if(href_list["late_join"])

		if(!ticker || ticker.current_state != GAME_STATE_PLAYING)
			to_chat(usr, "<font color='red'>The round is either not ready, or has already finished...</font>")
			return

		var/time_till_respawn = time_till_respawn()
		if(time_till_respawn == -1) // Special case, never allowed to respawn
			to_chat(usr, "<span class='warning'>Respawning is not allowed!</span>")
		else if(time_till_respawn) // Nonzero time to respawn
			to_chat(usr, "<span class='warning'>You can't respawn yet! You need to wait another [round(time_till_respawn/10/60, 0.1)] minutes.</span>")
			return
/*
		if(client.prefs.species != "Human" && !check_rights(R_ADMIN, 0)) //VORESTATION EDITS: THE COMMENTED OUT AREAS FROM LINE 154 TO 178
			if (config.usealienwhitelist)
				if(!is_alien_whitelisted(src, client.prefs.species))
					tgui_alert(src, "You are currently not whitelisted to Play [client.prefs.species].")
					return 0
*/
		LateChoices()

	if(href_list["manifest"])
		ViewManifest()

	if(href_list["SelectedJob"])

		/* Vorestation Removal Start
		//Prevents people rejoining as same character.
		for (var/mob/living/carbon/human/C in mob_list)
			var/char_name = client.prefs.real_name
			if(char_name == C.real_name)
				to_chat(usr, "<span class='notice'>There is a character that already exists with the same name - <b>[C.real_name]</b>, please join with a different one, or use Quit the Round with the previous character.</span>") //VOREStation Edit
				return
		*/ //Vorestation Removal End

		if(!config.enter_allowed)
			to_chat(usr, "<span class='notice'>There is an administrative lock on entering the game!</span>")
			return
		else if(ticker && ticker.mode && ticker.mode.explosion_in_progress)
			to_chat(usr, "<span class='danger'>The station is currently exploding. Joining would go poorly.</span>")
			return

		if(!is_alien_whitelisted(src, GLOB.all_species[client.prefs.species]))
			tgui_alert(src, "You are currently not whitelisted to play [client.prefs.species].")
			return 0

		var/datum/species/S = GLOB.all_species[client.prefs.species]

		if(!(S.spawn_flags & SPECIES_CAN_JOIN))
			tgui_alert_async(src,"Your current species, [client.prefs.species], is not available for play on the station.")
			return 0

		AttemptLateSpawn(href_list["SelectedJob"],client.prefs.spawnpoint)
		return

	if(href_list["privacy_poll"])
		establish_db_connection()
		if(!dbcon.IsConnected())
			return
		var/voted = 0

		//First check if the person has not voted yet.
		var/DBQuery/query = dbcon.NewQuery("SELECT * FROM erro_privacy WHERE ckey='[src.ckey]'")
		query.Execute()
		while(query.NextRow())
			voted = 1
			break

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
			var/DBQuery/query_insert = dbcon.NewQuery(sql)
			query_insert.Execute()
			to_chat(usr, "<b>Thank you for your vote!</b>")
			usr << browse(null,"window=privacypoll")

	if(!ready && href_list["preference"])
		if(client)
			client.prefs.process_link(src, href_list)
	else if(!href_list["late_join"])
		new_player_panel()

	if(href_list["showpoll"])

		handle_player_polling()
		return

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

	if(href_list["shownews"])
		handle_server_news()
		return

	if(href_list["hidden_jobs"])
		show_hidden_jobs = !show_hidden_jobs
		LateChoices()

	if(href_list["give_feedback"])
		if(!SSsqlite.can_submit_feedback(my_client))
			return

		if(client.feedback_form)
			client.feedback_form.display() // In case they closed the form early.
		else
			client.feedback_form = new(client)

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
		dat += "<font size='2'><i>Last written by [F["author"]], on [F["timestamp"]].</i></font>"
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
	//VOREStation Add
	if(!job.player_has_enough_playtime(src.client))
		return 0
	if(!is_job_whitelisted(src,rank))
		return 0
	if(!job.player_has_enough_pto(src.client))
		return 0
	//VOREStation Add End
	return 1


/mob/new_player/proc/AttemptLateSpawn(rank,var/spawning_at)
	if (src != usr)
		return 0
	if(!ticker || ticker.current_state != GAME_STATE_PLAYING)
		to_chat(usr, "<font color='red'>The round is either not ready, or has already finished...</font>")
		return 0
	if(!config.enter_allowed)
		to_chat(usr, "<span class='notice'>There is an administrative lock on entering the game!</span>")
		return 0
	if(!IsJobAvailable(rank))
		tgui_alert_async(src,"[rank] is not available. Please try another.")
		return 0
	if(!spawn_checks_vr(rank)) return 0 // VOREStation Insert
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

	job_master.AssignRole(src, rank, 1)

	var/mob/living/character = create_character(T)	//creates the human and transfers vars and mind
	character = job_master.EquipRank(character, rank, 1)					//equips the human
	UpdateFactionList(character)
	if(character && character.client)
		var/obj/screen/splash/Spl = new(character.client, TRUE)
		Spl.Fade(TRUE)

	var/datum/job/J = SSjob.get_job(rank)

	// AIs don't need a spawnpoint, they must spawn at an empty core
	if(J.mob_type & JOB_SILICON_AI)

		// IsJobAvailable for AI checks that there is an empty core available in this list
		var/obj/structure/AIcore/deactivated/C = empty_playable_ai_cores[1]
		empty_playable_ai_cores -= C

		character.loc = C.loc

		// AIize the character, but don't move them yet
		character = character.AIize(move = FALSE) // Dupe of code in /datum/controller/subsystem/ticker/proc/create_characters() for non-latespawn, unify?

		AnnounceCyborg(character, rank, "has been transferred to the empty core in \the [character.loc.loc]")
		ticker.mode.latespawn(character)

		qdel(C) //Deletes empty core (really?)
		qdel(src) //Deletes new_player
		return

	// Equip our custom items only AFTER deploying to spawn points eh?
	//equip_custom_items(character)	//VOREStation Removal

	//character.apply_traits() //VOREStation Removal

	// Moving wheelchair if they have one
	if(character.buckled && istype(character.buckled, /obj/structure/bed/chair/wheelchair))
		character.buckled.loc = character.loc
		character.buckled.set_dir(character.dir)

	ticker.mode.latespawn(character)

	if(J.mob_type & JOB_SILICON)
		AnnounceCyborg(character, rank, join_message, announce_channel, character.z)
	else
		AnnounceArrival(character, rank, join_message, announce_channel, character.z)
		data_core.manifest_inject(character)
		ticker.minds += character.mind//Cyborgs and AIs handle this in the transform proc.	//TODO!!!!! ~Carn

	qdel(src) // Delete new_player mob

/mob/new_player/proc/AnnounceCyborg(var/mob/living/character, var/rank, var/join_message, var/channel, var/zlevel)
	if (ticker.current_state == GAME_STATE_PLAYING)
		var/list/zlevels = zlevel ? using_map.get_map_levels(zlevel, TRUE, om_range = DEFAULT_OVERMAP_RANGE) : null
		if(character.mind.role_alt_title)
			rank = character.mind.role_alt_title
		// can't use their name here, since cyborg namepicking is done post-spawn, so we'll just say "A new Cyborg has arrived"/"A new Android has arrived"/etc.
		global_announcer.autosay("A new[rank ? " [rank]" : " visitor" ] [join_message ? join_message : "has arrived on the station"].", "Arrivals Announcement Computer", channel, zlevels)

/mob/new_player/proc/LateChoices()
	var/name = client.prefs.be_random_name ? "friend" : client.prefs.real_name

	var/dat = "<html><body><center>"
	dat += "<b>Welcome, [name].<br></b>"
	dat += "Round Duration: [roundduration2text()]<br>"

	if(emergency_shuttle) //In case NanoTrasen decides reposess CentCom's shuttles.
		if(emergency_shuttle.going_to_centcom()) //Shuttle is going to CentCom, not recalled
			dat += "<font color='red'><b>The station has been evacuated.</b></font><br>"
		if(emergency_shuttle.online())
			if (emergency_shuttle.evac)	// Emergency shuttle is past the point of no recall
				dat += "<font color='red'>The station is currently undergoing evacuation procedures.</font><br>"
			else						// Crew transfer initiated
				dat += "<font color='red'>The station is currently undergoing crew transfer procedures.</font><br>"

	dat += "Choose from the following open/valid positions:<br>"
	dat += "<a href='byond://?src=\ref[src];hidden_jobs=1'>[show_hidden_jobs ? "Hide":"Show"] Hidden Jobs.</a><br>"

	var/deferred = ""
	for(var/datum/job/job in job_master.occupations)
		if(job && IsJobAvailable(job.title))
			// Checks for jobs with minimum age requirements
			if((job.minimum_character_age || job.min_age_by_species) && (client.prefs.age < job.get_min_age(client.prefs.species, client.prefs.organ_data["brain"])))
				continue
			// Checks for jobs set to "Never" in preferences	//TODO: Figure out a better way to check for this
			if(!(client.prefs.GetJobDepartment(job, 1) & job.flag))
				if(!(client.prefs.GetJobDepartment(job, 2) & job.flag))
					if(!(client.prefs.GetJobDepartment(job, 3) & job.flag))
						if(!show_hidden_jobs && job.title != "Assistant")	// Assistant is always an option
							continue
			var/active = 0
			// Only players with the job assigned and AFK for less than 10 minutes count as active
			for(var/mob/M in player_list) if(M.mind && M.client && M.mind.assigned_role == job.title && M.client.inactivity <= 10 MINUTES)
				active++

			var/string = "<a href='byond://?src=\ref[src];SelectedJob=[job.title]'>[job.title] ([job.current_positions]) (Active: [active])</a><br>"

			if(job.offmap_spawn) //At the bottom
				deferred += string
			else
				dat += string

	dat += deferred

	dat += "</center>"
	src << browse(dat, "window=latechoices;size=300x640;can_close=1")


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
		if(is_alien_whitelisted(chosen_species))
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
		// VOREStation edit to disable the destructive forced renaming for our responsible whitelist clowns.
		//if(mind.assigned_role == "Clown")				//give them a clownname if they are a clown
		//	new_character.real_name = pick(clown_names)	//I hate this being here of all places but unfortunately dna is based on real_name!
		//	new_character.rename_self("clown")
		mind.original = new_character
		// VOREStation
		mind.loaded_from_ckey = client.ckey
		mind.loaded_from_slot = client.prefs.default_slot
		// VOREStation
		//mind.traits = client.prefs.traits.Copy() // VOREStation conflict
		mind.transfer_to(new_character)					//won't transfer key since the mind is not active

	new_character.name = real_name
	new_character.dna.ready_dna(new_character)
	new_character.dna.b_type = client.prefs.b_type
	new_character.sync_organ_dna()
	if(client.prefs.disabilities)
		// Set defer to 1 if you add more crap here so it only recalculates struc_enzymes once. - N3X
		new_character.dna.SetSEState(GLASSESBLOCK,1,0)
		new_character.disabilities |= NEARSIGHTED

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
	// And uncomment this, too.
	//new_character.dna.UpdateSE()

	// Do the initial caching of the player's body icons.
	new_character.force_update_limbs()
	new_character.update_icons_body()
	new_character.update_transform() //VOREStation Edit

	new_character.key = key		//Manually transfer the key to log them in

	return new_character

/mob/new_player/proc/ViewManifest()
	var/dat = "<div align='center'>"
	dat += data_core.get_manifest(OOC = 1)

	//src << browse(dat, "window=manifest;size=370x420;can_close=1")
	var/datum/browser/popup = new(src, "Crew Manifest", "Crew Manifest", 370, 420, src)
	popup.set_content(dat)
	popup.open()

/mob/new_player/Move()
	return 0

/mob/new_player/proc/close_spawn_windows()

	src << browse(null, "window=latechoices") //closes late choices window
	src << browse(null, "window=preferences_window") //VOREStation Edit?
	src << browse(null, "window=News") //closes news window
	//src << browse(null, "window=playersetup") //closes the player setup window
	panel.close()

/mob/new_player/proc/has_admin_rights()
	return check_rights(R_ADMIN, 0, src)

/mob/new_player/get_species()
	if(client.prefs.species)
		var/datum/species/chosen_species = GLOB.all_species[client.prefs.species]
		if(chosen_species && is_alien_whitelisted(src, chosen_species))
			return chosen_species
	return GLOB.all_species[SPECIES_HUMAN]

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
