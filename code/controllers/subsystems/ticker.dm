//
// Ticker controls the state of the game, being responsible for round start, game mode, and round end.
//
SUBSYSTEM_DEF(ticker)
	name = "Gameticker"
	wait = 2 SECONDS
	init_order = INIT_ORDER_TICKER
	priority = FIRE_PRIORITY_TICKER
	flags = SS_NO_TICK_CHECK | SS_KEEP_TIMING
	runlevels = RUNLEVEL_LOBBY | RUNLEVEL_SETUP | RUNLEVEL_GAME | RUNLEVEL_POSTGAME // Every runlevel!

	var/const/restart_timeout = 4 MINUTES	// Default time to wait before rebooting in desiseconds.
	var/current_state = GAME_STATE_INIT	// We aren't even at pregame yet // TODO replace with CURRENT_GAME_STATE

	/* Relies upon the following globals (TODO move those in here) */
	// var/master_mode = "extended"		//The underlying game mode (so "secret" or the voted mode).
										// Set by SSvote when VOTE_GAMEMODE finishes.
	// var/round_progressing = 1		//Whether the lobby clock is ticking down.

	var/pregame_timeleft = 0			// Time remaining until game starts in seconds. Set by config
	var/start_immediately = FALSE		// If true there is no lobby phase, the game starts immediately.

	var/hide_mode = FALSE 				// If the true game mode should be hidden (because we chose "secret")
	var/datum/game_mode/mode = null		// The actual gamemode, if selected.

	var/end_game_state = END_GAME_NOT_OVER	// Track where we are ending game/round
	var/restart_timeleft				// Time remaining until restart in desiseconds
	var/last_restart_notify				// world.time of last restart warning.
	var/delay_end = FALSE               // If set, the round will not restart on its own.

	// var/login_music					// music played in pregame lobby // VOREStation Edit - We do music differently

	var/list/datum/mind/minds = list()	// The people in the game. Used for objective tracking.

	var/random_players = FALSE	// If set to nonzero, ALL players who latejoin or declare-ready join will have random appearances/genders

	// TODO - Should this go here or in the job subsystem?
	var/triai = FALSE // Global flag for Triumvirate AI being enabled

	//station_explosion used to be a variable for every mob's hud. Which was a waste!
	//Now we have a general cinematic centrally held within the gameticker....far more efficient!
	var/obj/screen/cinematic = null

	var/round_start_time = 0



// This global variable exists for legacy support so we don't have to rename every 'ticker' to 'SSticker' yet.
var/global/datum/controller/subsystem/ticker/ticker
/datum/controller/subsystem/ticker/PreInit()
	global.ticker = src // TODO - Remove this! Change everything to point at SSticker intead

/datum/controller/subsystem/ticker/Initialize()
	pregame_timeleft = config.pregame_time
	send2mainirc("Server lobby is loaded and open at byond://[config.serverurl ? config.serverurl : (config.server ? config.server : "[world.address]:[world.port]")]")
	SSwebhooks.send(
		WEBHOOK_ROUNDPREP,
		list(
			"map" = station_name(),
			"url" = get_world_url()
		)
	)
	GLOB.autospeaker = new (null, null, null, 1) //Set up Global Announcer
	return ..()

/datum/controller/subsystem/ticker/fire(resumed = FALSE)
	switch(current_state)
		if(GAME_STATE_INIT)
			pregame_welcome()
			current_state = GAME_STATE_PREGAME
		if(GAME_STATE_PREGAME)
			pregame_tick()
		if(GAME_STATE_SETTING_UP)
			setup_tick()
		if(GAME_STATE_PLAYING)
			playing_tick()
		if(GAME_STATE_FINISHED)
			post_game_tick()

/datum/controller/subsystem/ticker/proc/pregame_welcome()
	to_world(span_boldannounce(span_notice("<em>Welcome to the pregame lobby!</em>")))
	to_world(span_boldannounce(span_notice("Please set up your character and select ready. The round will start in [pregame_timeleft] seconds.")))
	world << sound('sound/misc/server-ready.ogg', volume = 100)

// Called during GAME_STATE_PREGAME (RUNLEVEL_LOBBY)
/datum/controller/subsystem/ticker/proc/pregame_tick()
	if(round_progressing && last_fire)
		pregame_timeleft -= (world.time - last_fire) / (1 SECOND)

	if(start_immediately)
		pregame_timeleft = 0
	else if(SSvote.active_vote)
		return // vote still going, wait for it.

	// Time to start the game!
	if(pregame_timeleft <= 0)
		current_state = GAME_STATE_SETTING_UP
		Master.SetRunLevel(RUNLEVEL_SETUP)
		if(start_immediately)
			fire() // Don't wait for next tick, do it now!
		return

	//if(pregame_timeleft <= config.vote_autogamemode_timeleft && !SSvote.gamemode_vote_called)
		//.autogamemode() // Start the game mode vote (if we haven't had one already)

// Called during GAME_STATE_SETTING_UP (RUNLEVEL_SETUP)
/datum/controller/subsystem/ticker/proc/setup_tick(resumed = FALSE)
	round_start_time = world.time // otherwise round_start_time would be 0 for the signals
	if(!setup_choose_gamemode())
		// It failed, go back to lobby state and re-send the welcome message
		pregame_timeleft = config.pregame_time
		// SSvote.gamemode_vote_called = FALSE // Allow another autogamemode vote
		current_state = GAME_STATE_PREGAME
		Master.SetRunLevel(RUNLEVEL_LOBBY)
		pregame_welcome()
		return
	// If we got this far we succeeded in picking a game mode.  Punch it!
	setup_startgame()
	return

// Formerly the first half of setup() - The part that chooses the game mode.
// Returns 0 if failed to pick a mode, otherwise 1
/datum/controller/subsystem/ticker/proc/setup_choose_gamemode()
	//Create and announce mode
	if(master_mode == "secret")
		src.hide_mode = TRUE

	var/list/runnable_modes = config.get_runnable_modes()
	if((master_mode == "random") || (master_mode == "secret"))
		if(!runnable_modes.len)
			to_world(span_danger(span_bold("Unable to choose playable game mode.") + " Reverting to pregame lobby."))
			return 0
		if(secret_force_mode != "secret")
			src.mode = config.pick_mode(secret_force_mode)
		if(!src.mode)
			var/list/weighted_modes = list()
			for(var/datum/game_mode/GM in runnable_modes)
				weighted_modes[GM.config_tag] = config.probabilities[GM.config_tag]
			src.mode = gamemode_cache[pickweight(weighted_modes)]
	else
		src.mode = config.pick_mode(master_mode)

	if(!src.mode)
		to_world(span_danger("Serious error in mode setup! Reverting to pregame lobby.")) //Uses setup instead of set up due to computational context.
		return 0

	job_master.ResetOccupations()
	src.mode.create_antagonists()
	src.mode.pre_setup()
	job_master.DivideOccupations() // Apparently important for new antagonist system to register specific job antags properly.

	if(!src.mode.can_start())
		to_world(span_danger(span_bold("Unable to start [mode.name].") + " Not enough players readied, [config.player_requirements[mode.config_tag]] players needed. Reverting to pregame lobby."))
		mode.fail_setup()
		mode = null
		job_master.ResetOccupations()
		return 0

	if(hide_mode)
		to_world(span_notice(span_bold("The current game mode is - Secret!")))
		if(runnable_modes.len)
			var/list/tmpmodes = new
			for (var/datum/game_mode/M in runnable_modes)
				tmpmodes+=M.name
			tmpmodes = sortList(tmpmodes)
			if(tmpmodes.len)
				to_world(span_info(span_bold("Possibilities:") + " [english_list(tmpmodes, and_text= "; ", comma_text = "; ")]"))
	else
		src.mode.announce()
	return 1

// Formerly the second half of setup() - The part that actually initializes everything and starts the game.
/datum/controller/subsystem/ticker/proc/setup_startgame()
	setup_economy()
	create_characters() //Create player characters and transfer them.
	collect_minds()
	equip_characters()
//	data_core.manifest()

	callHook("roundstart")

	spawn(0)//Forking here so we dont have to wait for this to finish
		mode.post_setup()
		//Cleanup some stuff
		for(var/obj/effect/landmark/start/S in landmarks_list)
			//Deleting Startpoints but we need the ai point to AI-ize people later
			if (S.name != "AI")
				qdel(S)
		to_world(span_boldannounce(span_notice("<em>Enjoy the game!</em>")))
		world << sound('sound/AI/welcome.ogg') // Skie
		//Holiday Round-start stuff	~Carn
		Holiday_Game_Start()

	var/list/adm = get_admin_counts()
	if(adm["total"] == 0)
		send2adminirc("A round has started with no admins online.")

	current_state = GAME_STATE_PLAYING
	Master.SetRunLevel(RUNLEVEL_GAME)

	if(config.sql_enabled)
		statistic_cycle() // Polls population totals regularly and stores them in an SQL DB -- TLE

	return 1


// Called during GAME_STATE_PLAYING (RUNLEVEL_GAME)
/datum/controller/subsystem/ticker/proc/playing_tick(resumed = FALSE)
	mode.process() // So THIS is where we run mode.process() huh? Okay

	if(mode.explosion_in_progress)
		return // wait until explosion is done.

	// Calculate if game and/or mode are finished (Complicated by the continuous_rounds config option)
	var/game_finished = FALSE
	var/mode_finished = FALSE
	if (config.continous_rounds) // Game keeps going after mode ends.
		game_finished = (emergency_shuttle.returned() || mode.station_was_nuked)
		mode_finished = ((end_game_state >= END_GAME_MODE_FINISHED) || mode.check_finished()) // Short circuit if already finished.
	else // Game ends when mode does
		game_finished = (mode.check_finished() || (emergency_shuttle.returned() && emergency_shuttle.evac == 1)) || universe_has_ended
		mode_finished = game_finished

	if(game_finished && mode_finished)
		end_game_state = END_GAME_READY_TO_END
		current_state = GAME_STATE_FINISHED
		Master.SetRunLevel(RUNLEVEL_POSTGAME)
		INVOKE_ASYNC(src, PROC_REF(declare_completion))
	else if (mode_finished && (end_game_state < END_GAME_MODE_FINISHED))
		end_game_state = END_GAME_MODE_FINISHED // Only do this cleanup once!
		mode.cleanup()
		//call a transfer shuttle vote
		to_world(span_danger("The round has ended!"))
		SSvote.start_vote(new /datum/vote/crew_transfer)

// Called during GAME_STATE_FINISHED (RUNLEVEL_POSTGAME)
/datum/controller/subsystem/ticker/proc/post_game_tick()
	switch(end_game_state)
		if(END_GAME_READY_TO_END)
			callHook("roundend")

			if (mode.station_was_nuked)
				feedback_set_details("end_proper", "nuke")
				restart_timeleft = 1 MINUTE // No point waiting five minutes if everyone's dead.
				if(!delay_end)
					to_world(span_notice(span_bold("Rebooting due to destruction of [station_name()] in [round(restart_timeleft/600)] minute\s.")))
					last_restart_notify = world.time
			else
				feedback_set_details("end_proper", "proper completion")
				restart_timeleft = restart_timeout

			if(blackbox)
				blackbox.save_all_data_to_sql()	// TODO - Blackbox or statistics subsystem

			end_game_state = END_GAME_ENDING
			return
		if(END_GAME_ENDING)
			restart_timeleft -= (world.time - last_fire)
			if(delay_end)
				to_world(span_notice(span_bold("An admin has delayed the round end.")))
				end_game_state = END_GAME_DELAYED
			else if(restart_timeleft <= 0)
				to_world(span_warning(span_bold("Restarting world!")))
				sleep(5)
				world.Reboot()
			else if (world.time - last_restart_notify >= 1 MINUTE)
				to_world(span_notice(span_bold("Restarting in [round(restart_timeleft/600, 1)] minute\s.")))
				last_restart_notify = world.time
			return
		if(END_GAME_DELAYED)
			restart_timeleft -= (world.time - last_fire)
			if(!delay_end)
				end_game_state = END_GAME_ENDING
		else
			log_error("Ticker arrived at round end in an unexpected endgame state '[end_game_state]'.")
			end_game_state = END_GAME_READY_TO_END


// ----------------------------------------------------------------------
// These two below are not used! But they could be

// Use these preferentially to directly examining ticker.current_state to help prepare for transition to ticker as subsystem!

/datum/controller/subsystem/ticker/proc/PreRoundStart()
	return (current_state < GAME_STATE_PLAYING)

/datum/controller/subsystem/ticker/proc/IsSettingUp()
	return (current_state == GAME_STATE_SETTING_UP)

/datum/controller/subsystem/ticker/proc/IsRoundInProgress()
	return (current_state == GAME_STATE_PLAYING)

/datum/controller/subsystem/ticker/proc/HasRoundStarted()
	return (current_state >= GAME_STATE_PLAYING)

// ------------------------------------------------------------------------
// HELPER PROCS!
// ------------------------------------------------------------------------

//Plus it provides an easy way to make cinematics for other events. Just use this as a template :)
/datum/controller/subsystem/ticker/proc/station_explosion_cinematic(var/station_missed=0, var/override = null)
	if( cinematic )	return	//already a cinematic in progress!

	//initialise our cinematic screen object
	cinematic = new(src)
	cinematic.icon = 'icons/effects/station_explosion.dmi'
	cinematic.icon_state = "station_intact"
	cinematic.layer = 100
	cinematic.plane = PLANE_PLAYER_HUD
	cinematic.mouse_opacity = 0
	cinematic.screen_loc = "1,0"

	var/obj/structure/bed/temp_buckle = new(src)
	//Incredibly hackish. It creates a bed within the gameticker (lol) to stop mobs running around
	if(station_missed)
		for(var/mob/living/M in living_mob_list)
			M.buckled = temp_buckle				//buckles the mob so it can't do anything
			if(M.client)
				M.client.screen += cinematic	//show every client the cinematic
	else	//nuke kills everyone on z-level 1 to prevent "hurr-durr I survived"
		for(var/mob/living/M in living_mob_list)
			M.buckled = temp_buckle
			if(M.client)
				M.client.screen += cinematic

			switch(M.z)
				if(0)	//inside a crate or something
					var/turf/T = get_turf(M)
					if(T && (T.z in using_map.station_levels))				//we don't use M.death(0) because it calls a for(/mob) loop and
						M.health = 0
						M.set_stat(DEAD)
				if(1)	//on a z-level 1 turf.
					M.health = 0
					M.set_stat(DEAD)

	//Now animate the cinematic
	switch(station_missed)
		if(1)	//nuke was nearby but (mostly) missed
			if( mode && !override )
				override = mode.name
			switch( override )
				if("mercenary") //Nuke wasn't on station when it blew up
					flick("intro_nuke",cinematic)
					sleep(35)
					world << sound('sound/effects/explosionfar.ogg')
					flick("station_intact_fade_red",cinematic)
					cinematic.icon_state = "summary_nukefail"
				else
					flick("intro_nuke",cinematic)
					sleep(35)
					world << sound('sound/effects/explosionfar.ogg')
					//flick("end",cinematic)


		if(2)	//nuke was nowhere nearby	//TODO: a really distant explosion animation
			sleep(50)
			world << sound('sound/effects/explosionfar.ogg')


		else	//station was destroyed
			if( mode && !override )
				override = mode.name
			switch( override )
				if("mercenary") //Nuke Ops successfully bombed the station
					flick("intro_nuke",cinematic)
					sleep(35)
					flick("station_explode_fade_red",cinematic)
					world << sound('sound/effects/explosionfar.ogg')
					cinematic.icon_state = "summary_nukewin"
				if("AI malfunction") //Malf (screen,explosion,summary)
					flick("intro_malf",cinematic)
					sleep(76)
					flick("station_explode_fade_red",cinematic)
					world << sound('sound/effects/explosionfar.ogg')
					cinematic.icon_state = "summary_malf"
				if("blob") //Station nuked (nuke,explosion,summary)
					flick("intro_nuke",cinematic)
					sleep(35)
					flick("station_explode_fade_red",cinematic)
					world << sound('sound/effects/explosionfar.ogg')
					cinematic.icon_state = "summary_selfdes"
				else //Station nuked (nuke,explosion,summary)
					flick("intro_nuke",cinematic)
					sleep(35)
					flick("station_explode_fade_red", cinematic)
					world << sound('sound/effects/explosionfar.ogg')
					cinematic.icon_state = "summary_selfdes"
			for(var/mob/living/M in living_mob_list)
				if(M.loc.z in using_map.station_levels)
					M.death()//No mercy
	//If its actually the end of the round, wait for it to end.
	//Otherwise if its a verb it will continue on afterwards.
	sleep(300)

	if(cinematic)	qdel(cinematic)		//end the cinematic
	if(temp_buckle)	qdel(temp_buckle)	//release everybody
	return


/datum/controller/subsystem/ticker/proc/create_characters()
	for(var/mob/new_player/player in player_list)
		if(player && player.ready && player.mind?.assigned_role)
			var/datum/job/J = SSjob.get_job(player.mind.assigned_role)

			// Ask their new_player mob to spawn them
			if(!player.spawn_checks_vr(player.mind.assigned_role))
				var/datum/job/job_datum = job_master.GetJob(J.title)
				job_datum.current_positions--
				player.mind.assigned_role = null
				continue //VOREStation Add

			// Snowflakey AI treatment
			if(J?.mob_type & JOB_SILICON_AI)
				player.close_spawn_windows()
				player.AIize(move = TRUE)
				continue

			var/mob/living/carbon/human/new_char = player.create_character()

			// Created their playable character, delete their /mob/new_player
			if(new_char)
				qdel(player)
				if(new_char.client)
					var/obj/screen/splash/S = new(new_char.client, TRUE)
					S.Fade(TRUE)
					new_char.client.init_verbs()

			// If they're a carbon, they can get manifested
			if(J?.mob_type & JOB_CARBON)
				data_core.manifest_inject(new_char)

/datum/controller/subsystem/ticker/proc/collect_minds()
	for(var/mob/living/player in player_list)
		if(player.mind)
			minds += player.mind


/datum/controller/subsystem/ticker/proc/equip_characters()
	var/captainless=1
	for(var/mob/living/carbon/human/player in player_list)
		if(player && player.mind && player.mind.assigned_role)
			if(player.mind.assigned_role == JOB_SITE_MANAGER)
				captainless=0
			if(!player_is_antag(player.mind, only_offstation_roles = 1))
				job_master.EquipRank(player, player.mind.assigned_role, 0)
				UpdateFactionList(player)
				//equip_custom_items(player)	//VOREStation Removal
				//player.apply_traits() //VOREStation Removal
		//VOREStation Addition Start
		if(player.client)
			if(player.client.prefs.auto_backup_implant)
				var/obj/item/implant/backup/imp = new(src)

				if(imp.handle_implant(player,player.zone_sel.selecting))
					imp.post_implant(player)
		//VOREStation Addition End
	if(captainless)
		for(var/mob/M in player_list)
			if(!istype(M,/mob/new_player))
				to_chat(M, span_notice("Site Management is not forced on anyone."))


/datum/controller/subsystem/ticker/proc/declare_completion()
	to_world(span_filter_system("<br><br><br><H1>A round of [mode.name] has ended!</H1>"))
	for(var/mob/Player in player_list)
		if(Player.mind && !isnewplayer(Player))
			if(Player.stat != DEAD)
				var/turf/playerTurf = get_turf(Player)
				if(emergency_shuttle.departed && emergency_shuttle.evac)
					if(isNotAdminLevel(playerTurf.z))
						to_chat(Player, span_filter_system(span_blue(span_bold("You survived the round, but remained on [station_name()] as [Player.real_name]."))))
					else
						to_chat(Player, span_filter_system(span_green(span_bold("You managed to survive the events on [station_name()] as [Player.real_name]."))))
				else if(isAdminLevel(playerTurf.z))
					to_chat(Player, span_filter_system(span_green(span_bold("You successfully underwent crew transfer after events on [station_name()] as [Player.real_name]."))))
				else if(issilicon(Player))
					to_chat(Player, span_filter_system(span_green(span_bold("You remain operational after the events on [station_name()] as [Player.real_name]."))))
				else
					to_chat(Player, span_filter_system(span_blue(span_bold("You missed the crew transfer after the events on [station_name()] as [Player.real_name]."))))
			else
				if(istype(Player,/mob/observer/dead))
					var/mob/observer/dead/O = Player
					if(!O.started_as_observer)
						to_chat(Player, span_filter_system(span_red(span_bold("You did not survive the events on [station_name()]..."))))
				else
					to_chat(Player, span_filter_system(span_red(span_bold("You did not survive the events on [station_name()]..."))))
	to_world("<br>")

	for (var/mob/living/silicon/ai/aiPlayer in mob_list)
		if (aiPlayer.stat != 2)
			to_world(span_filter_system(span_bold("[aiPlayer.name]'s laws at the end of the round were:"))) // VOREStation edit
		else
			to_world(span_filter_system(span_bold("[aiPlayer.name]'s laws when it was deactivated were:"))) // VOREStation edit
		aiPlayer.show_laws(1)

		if (aiPlayer.connected_robots.len)
			var/robolist = span_bold("The AI's loyal minions were:") + " "
			for(var/mob/living/silicon/robot/robo in aiPlayer.connected_robots)
				robolist += "[robo.name][robo.stat?" (Deactivated), ":", "]"  // VOREStation edit
			to_world(span_filter_system("[robolist]"))

	var/dronecount = 0

	for (var/mob/living/silicon/robot/robo in mob_list)

		if(istype(robo, /mob/living/silicon/robot/platform))
			var/mob/living/silicon/robot/platform/tank = robo
			if(!tank.has_had_player)
				continue

		if(istype(robo,/mob/living/silicon/robot/drone) && !istype(robo,/mob/living/silicon/robot/drone/swarm))
			dronecount++
			continue

		if (!robo.connected_ai)
			if (robo.stat != 2)
				to_world(span_filter_system(span_bold("[robo.name] survived as an AI-less stationbound synthetic! Its laws were:"))) // VOREStation edit
			else
				to_world(span_filter_system(span_bold("[robo.name] was unable to survive the rigors of being a stationbound synthetic without an AI. Its laws were:"))) // VOREStation edit

			if(robo) //How the hell do we lose robo between here and the world messages directly above this?
				robo.laws.show_laws(world)

	if(dronecount)
		to_world(span_filter_system(span_bold("There [dronecount>1 ? "were" : "was"] [dronecount] industrious maintenance [dronecount>1 ? "drones" : "drone"] at the end of this round.")))

	mode.declare_completion()//To declare normal completion.

	//Ask the event manager to print round end information
	SSevents.RoundEnd()

	//Print a list of antagonists to the server log
	var/list/total_antagonists = list()
	//Look into all mobs in world, dead or alive
	for(var/datum/mind/Mind in minds)
		var/temprole = Mind.special_role
		if(temprole)							//if they are an antagonist of some sort.
			if(temprole in total_antagonists)	//If the role exists already, add the name to it
				total_antagonists[temprole] += ", [Mind.name]([Mind.key])"
			else
				total_antagonists.Add(temprole) //If the role doesnt exist in the list, create it and add the mob
				total_antagonists[temprole] += ": [Mind.name]([Mind.key])"

	//Now print them all into the log!
	log_game("Antagonists at round end were...")
	for(var/i in total_antagonists)
		log_game("[i]s[total_antagonists[i]].")

	return 1

/datum/controller/subsystem/ticker/stat_entry(msg)
	switch(current_state)
		if(GAME_STATE_INIT)
			..()
		if(GAME_STATE_PREGAME) // RUNLEVEL_LOBBY
			msg = "START [round_progressing ? "[round(pregame_timeleft)]s" : "(PAUSED)"]"
		if(GAME_STATE_SETTING_UP) // RUNLEVEL_SETUP
			msg = "SETUP"
		if(GAME_STATE_PLAYING) // RUNLEVEL_GAME
			msg = "GAME"
		if(GAME_STATE_FINISHED) // RUNLEVEL_POSTGAME
			switch(end_game_state)
				if(END_GAME_MODE_FINISHED)
					msg = "MODE OVER, WAITING"
				if(END_GAME_READY_TO_END)
					msg = "ENDGAME PROCESSING"
				if(END_GAME_ENDING)
					msg = "END IN [round(restart_timeleft/10)]s"
				if(END_GAME_DELAYED)
					msg = "END PAUSED"
				else
					msg = "ENDGAME ERROR:[end_game_state]"
	return ..()

/datum/controller/subsystem/ticker/Recover()
	flags |= SS_NO_INIT // Don't initialize again

	current_state = SSticker.current_state
	mode = SSticker.mode
	pregame_timeleft = SSticker.pregame_timeleft

	end_game_state = SSticker.end_game_state
	delay_end = SSticker.delay_end
	restart_timeleft = SSticker.restart_timeleft

	minds = SSticker.minds

	random_players = SSticker.random_players

	round_start_time = SSticker.round_start_time
