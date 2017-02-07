//This is a mob that's used for the new lobby.  For the old lobby mob, check code/modules/mob/new_player.dm
/mob/living/lobby
	name = "You"
	desc = "Who else would it be?"
	icon = 'icons/mob/mob.dmi'
	icon_state = "ghost"
	var/ready = 0
	var/spawning = 0//Referenced when you want to delete the new_player later on in the code.
	var/totalPlayers = 0		 //Player counts for the Lobby tab
	var/totalPlayersReady = 0
	var/isolated = 1 //Used to check if we should maintain the illusion of being alone.
	var/do_adjacency_check = 1
	universal_speak = 1
	var/list/visisble_players = list()
	var/list/furnature = list()
	var/list/shown_furnature = list()

//	invisibility = 101

	density = 0


/mob/living/lobby/New()
	mob_list += src
	go_to_lobby()

//Gratutious copypasta
/mob/living/lobby/Stat()
	..()

	if(statpanel("Lobby") && ticker)
		if(ticker.hide_mode)
			stat("Game Mode:", "Secret")
		else
			if(ticker.hide_mode == 0)
				stat("Game Mode:", "[master_mode]") // Old setting for showing the game mode

		if(ticker.current_state == GAME_STATE_PREGAME)
			stat("Time To Start:", "[ticker.pregame_timeleft][round_progressing ? "" : " (DELAYED)"]")
			stat("Players: [totalPlayers]", "Players Ready: [totalPlayersReady]")
			totalPlayers = 0
			totalPlayersReady = 0
			for(var/mob/new_player/player in player_list)
				stat("[player.key]", (player.ready) ? ("(Playing)"):(null))
				totalPlayers++
				if(player.ready)
					totalPlayersReady++
			for(var/mob/living/lobby/player in player_list)
				stat("[player.key]", (player.ready) ? ("(Playing)"):(null))
				totalPlayers++
				if(player.ready)
					totalPlayersReady++

/mob/living/lobby/proc/update_details()
	name = client.prefs.real_name
	update_icon()


/mob/living/lobby/update_icon()
	..()
	client.prefs.update_preview_icon()
	icon = client.prefs.preview_icon


/mob/living/lobby/proc/go_to_lobby()
	var/obj/O = locate("landmark*Lobby-Start")
	if(istype(O))
		loc = O.loc
	else
		src << "<span class='danger'>Unfortunately, the game wasn't able to find you a suitable location for your lobby mob to spawn.  \
		Please report this as a bug.</span>"

/*
/mob/living/lobby/proc/IsJobAvailable(rank)
	var/datum/job/job = job_master.GetJob(rank)
	if(!job)
		return 0
	if(!job.is_position_available())
		return 0
	if(jobban_isbanned(src,rank))
		return 0
	if(!job.player_old_enough(src.client))
		return 0
	return 1

/mob/living/lobby/proc/close_spawn_windows()
	src << browse(null, "window=latechoices") //closes late choices window
	src << browse(null, "window=playersetup") //closes the player setup window

/mob/living/lobby/proc/LateChoices()
	var/name = client.prefs.be_random_name ? "friend" : client.prefs.real_name

	var/dat = "<html><body><center>"
	dat += "<b>Welcome, [name].<br></b>"
	dat += "Round Duration: [round_duration()]<br>"

	if(emergency_shuttle) //In case Nanotrasen decides reposess CentComm's shuttles.
		if(emergency_shuttle.going_to_centcom()) //Shuttle is going to centcomm, not recalled
			dat += "<font color='red'><b>The station has been evacuated.</b></font><br>"
		if(emergency_shuttle.online())
			if (emergency_shuttle.evac)	// Emergency shuttle is past the point of no recall
				dat += "<font color='red'>The station is currently undergoing evacuation procedures.</font><br>"
			else						// Crew transfer initiated
				dat += "<font color='red'>The station is currently undergoing crew transfer procedures.</font><br>"

	dat += "Choose from the following open positions:<br>"
	for(var/datum/job/job in job_master.occupations)
		if(job && IsJobAvailable(job.title))
			var/active = 0
			// Only players with the job assigned and AFK for less than 10 minutes count as active
			for(var/mob/M in player_list) if(M.mind && M.client && M.mind.assigned_role == job.title && M.client.inactivity <= 10 * 60 * 10)
				active++
			dat += "<a href='byond://?src=\ref[src];SelectedJob=[job.title]'>[job.title] ([job.current_positions]) (Active: [active])</a><br>"

	dat += "</center>"
	src << browse(dat, "window=latechoices;size=300x640;can_close=1")

/mob/living/lobby/proc/AttemptLateSpawn(rank,var/spawning_at)
	world << "AttemptLateSpawn() was called."
	if (src != usr)
		return 0
	if(!ticker || ticker.current_state != GAME_STATE_PLAYING)
		usr << "\red The round is either not ready, or has already finished..."
		return 0
	if(!config.enter_allowed)
		usr << "<span class='notice'>There is an administrative lock on entering the game!</span>"
		return 0
	if(!IsJobAvailable(rank))
		src << alert("[rank] is not available. Please try another.")
		return 0

	spawning = 1
	close_spawn_windows()

	job_master.AssignRole(src, rank, 1)

	var/mob/living/character = create_character()	//creates the human and transfers vars and mind
	character = job_master.EquipRank(character, rank, 1)					//equips the human
	UpdateFactionList(character)
	equip_custom_items(character)

	// AIs don't need a spawnpoint, they must spawn at an empty core
	if(character.mind.assigned_role == "AI")

		character = character.AIize(move=0) // AIize the character, but don't move them yet

		// IsJobAvailable for AI checks that there is an empty core available in this list
		var/obj/structure/AIcore/deactivated/C = empty_playable_ai_cores[1]
		empty_playable_ai_cores -= C

		character.loc = C.loc

//		AnnounceCyborg(character, rank, "has been downloaded to the empty core in \the [character.loc.loc]")
		ticker.mode.latespawn(character)

		qdel(C)
		qdel(src)
		return

	//Find our spawning point.
	var/join_message = job_master.LateSpawn(character, rank)

	character.lastarea = get_area(loc)
	// Moving wheelchair if they have one
	if(character.buckled && istype(character.buckled, /obj/structure/bed/chair/wheelchair))
		character.buckled.loc = character.loc
		character.buckled.set_dir(character.dir)

	ticker.mode.latespawn(character)

	if(character.mind.assigned_role != "Cyborg")
		data_core.manifest_inject(character)
		ticker.minds += character.mind//Cyborgs and AIs handle this in the transform proc.	//TODO!!!!! ~Carn

		//Grab some data from the character prefs for use in random news procs.

		AnnounceArrival(character, rank, join_message)
//	else
//		AnnounceCyborg(character, rank, join_message)

	qdel(src)

/mob/living/lobby/proc/has_admin_rights()
	return check_rights(R_ADMIN, 0, src)

/mob/living/lobby/proc/is_species_whitelisted(datum/species/S)
	if(!S)
		return 1
	return is_alien_whitelisted(src, S.name) || !config.usealienwhitelist || !(S.spawn_flags & IS_WHITELISTED)

/mob/living/lobby/proc/create_character()
	spawning = 1
	close_spawn_windows()

	var/mob/living/carbon/human/new_character

	var/use_species_name
	var/datum/species/chosen_species
	if(client.prefs.species)
		chosen_species = all_species[client.prefs.species]
		use_species_name = chosen_species.get_station_variant() //Only used by pariahs atm.

	if(chosen_species && use_species_name)
		// Have to recheck admin due to no usr at roundstart. Latejoins are fine though.
		if(is_species_whitelisted(chosen_species) || has_admin_rights())
			new_character = new(loc, use_species_name)

	if(!new_character)
		new_character = new(loc)

	new_character.lastarea = get_area(loc)

	for(var/lang in client.prefs.alternate_languages)
		var/datum/language/chosen_language = all_languages[lang]
		if(chosen_language)
			if(!config.usealienwhitelist || !(chosen_language.flags & WHITELISTED) || is_alien_whitelisted(src, lang) || has_admin_rights() \
				|| (new_character.species && (chosen_language.name in new_character.species.secondary_langs)))
				new_character.add_language(lang)

	if(ticker.random_players)
		new_character.gender = pick(MALE, FEMALE)
		client.prefs.real_name = random_name(new_character.gender)
		client.prefs.randomize_appearance_for(new_character)
	else
		client.prefs.copy_to(new_character)

	src << sound(null, repeat = 0, wait = 0, volume = 85, channel = 1) // MAD JAMS cant last forever yo

	if(mind)
		mind.active = 0					//we wish to transfer the key manually
		mind.original = new_character
		mind.transfer_to(new_character)					//won't transfer key since the mind is not active

	new_character.name = real_name
	new_character.dna.ready_dna(new_character)
	new_character.dna.b_type = client.prefs.b_type
	new_character.sync_organ_dna()
	if(client.prefs.disabilities)
		// Set defer to 1 if you add more crap here so it only recalculates struc_enzymes once. - N3X
		new_character.dna.SetSEState(GLASSESBLOCK,1,0)
		new_character.disabilities |= NEARSIGHTED

	// And uncomment this, too.
	//new_character.dna.UpdateSE()

	// Do the initial caching of the player's body icons.
	new_character.force_update_limbs()
	new_character.update_eyes()
	new_character.regenerate_icons()

	new_character.key = key		//Manually transfer the key to log them in

	return new_character

/mob/living/lobby/proc/late_join()
	if(!ticker || ticker.current_state != GAME_STATE_PLAYING)
		usr << "<span class='danger'>The round is either not ready, or has already finished...</span>"
		return

	if(client.prefs.species != "Human" && !check_rights(R_ADMIN, 0))
		if(!is_alien_whitelisted(src, client.prefs.species) && config.usealienwhitelist)
			src << alert("You are currently not whitelisted to play [client.prefs.species].")
			return 0

		var/datum/species/S = all_species[client.prefs.species]
		if(!(S.spawn_flags & IS_WHITELISTED))
			src << alert("Your current species,[client.prefs.species], is not available for play on the station.")
			return 0

	LateChoices()

/mob/living/lobby/verb/late_join_verb()
	set name = "Late join"
	set desc = "Late join manually."
	set category = "Lobby Verbs"
	late_join()

/mob/living/lobby/proc/become_observer()
	if(alert(src,"Are you sure you wish to observe? You will have to wait 30 minutes before being able to respawn!","Player Setup","Yes","No") == "Yes")
		if(!client)
			return 1
		var/mob/dead/observer/observer = new()

		spawning = 1
		src << sound(null, repeat = 0, wait = 0, volume = 85, channel = 1) // MAD JAMS cant last forever yo


		observer.started_as_observer = 1
		close_spawn_windows()
		var/obj/O = locate("landmark*Observer-Start")
		if(istype(O))
			src << "<span class='notice'>Now teleporting.</span>"
			observer.loc = O.loc
		else
			src << "<span class='danger'>Could not locate an observer spawn point. Use the Teleport verb to jump to the station map.</span>"
		observer.timeofdeath = world.time // Set the time of death so that the respawn timer works correctly.

		announce_ghost_joinleave(src)
		client.prefs.update_preview_icon()
		observer.icon = client.prefs.preview_icon
		observer.alpha = 127

		if(client.prefs.be_random_name)
			client.prefs.real_name = random_name(client.prefs.gender)
		observer.real_name = client.prefs.real_name
		observer.name = observer.real_name
		if(!client.holder && !config.antag_hud_allowed)           // For new ghosts we remove the verb from even showing up if it's not allowed.
			observer.verbs -= /mob/dead/observer/verb/toggle_antagHUD        // Poor guys, don't know what they are missing!
		observer.key = key
		qdel(src)

		return 1

/mob/living/lobby/verb/observe_verb()
	set name = "Observe"
	set desc = "Lets you observe the round.  Remember, you won't be able to join the game for another 30 minutes!"
	set category = "Lobby Verbs"
	become_observer()

/mob/living/lobby/proc/ViewManifest()
	var/dat = "<html><body>"
	dat += "<h4>Northern Star Manifest</h4>"
	dat += data_core.get_manifest(OOC = 1)

	src << browse(dat, "window=manifest;size=370x420;can_close=1")

/mob/living/lobby/verb/show_manifest()
	set name = "Show Manifest"
	set desc = "Views a copy of the Northern Star's manifest."
	set category = "Lobby Verbs"
	ViewManifest()

/mob/living/lobby/MayRespawn()
	return 1

/mob/living/lobby/verb/return_to_lobby()
	set name = "Return to Lobby"
	set desc = "For testing only!"
	set category = "Lobby Verbs"

	var/obj/O = locate("landmark*Lobby-Start")
	if(istype(O))
		src << "<span class='notice'>Now teleporting.</span>"
		loc = O.loc

/mob/living/lobby/Topic(href, href_list[])
	if(!client)
		return 0
	if(href_list["SelectedJob"])

		if(!config.enter_allowed)
			usr << "<span class='notice'>There is an administrative lock on entering the game!</span>"
			return
		else if(ticker && ticker.mode && ticker.mode.explosion_in_progress)
			usr << "<span class='danger'>The station is currently exploding. Joining would go poorly.</span>"
			return

		if(client.prefs.species != "Human")
			if(!is_alien_whitelisted(src, client.prefs.species) && config.usealienwhitelist)
				src << alert("You are currently not whitelisted to play [client.prefs.species].")
				return 0

			var/datum/species/S = all_species[client.prefs.species]
			if(!(S.spawn_flags & CAN_JOIN))
				src << alert("Your current species, [client.prefs.species], is not available for play on the station.")
				return 0

		AttemptLateSpawn(href_list["SelectedJob"],client.prefs.spawnpoint)
		return
*/
/mob/proc/make_into_lobby_mob()
	var/mob/new_player/M = new /mob/living/lobby()
	if(!client)
		log_game("[usr.key] AM failed due to disconnect.")
		qdel(M)
		return

	M.key = key
	if(M.mind)
		M.mind.reset()
	return