SUBSYSTEM_DEF(ticker)
	name = "Ticker"
	priority = FIRE_PRIORITY_TICKER
	flags = SS_KEEP_TIMING
	runlevels = RUNLEVEL_LOBBY | RUNLEVEL_SETUP | RUNLEVEL_GAME

	/// state of current round (used by process()) Use the defines GAME_STATE_* !
	var/current_state = GAME_STATE_STARTUP
	/// Boolean to track if round should be forcibly ended next ticker tick.
	/// Set by admin intervention ([ADMIN_FORCE_END_ROUND])
	/// or a "round-ending" event, like summoning Nar'Sie, a blob victory, the nuke going off, etc. ([FORCE_END_ROUND])
	var/force_ending = END_ROUND_AS_NORMAL
	/// If TRUE, there is no lobby phase, the game starts immediately.
	var/start_immediately = FALSE
	/// Boolean to track and check if our subsystem setup is done.
	var/setup_done = FALSE

	var/hide_mode = FALSE
	var/datum/game_mode/mode = null

	var/login_music //music played in pregame lobby
	var/round_end_sound //music/jingle played when the world reboots
	var/round_end_sound_sent = TRUE //If all clients have loaded it

	var/list/datum/mind/minds = list() //The characters in the game. Used for objective tracking.

	var/delay_end = FALSE //if set true, the round will not restart on it's own
	var/admin_delay_notice = "" //a message to display to anyone who tries to restart the world after a delay
	var/ready_for_reboot = FALSE //all roundend preparation done with, all that's left is reboot

	var/tipped = FALSE //Did we broadcast the tip of the day yet?
	var/selected_tip // What will be the tip of the day?

	var/timeLeft //pregame timer
	var/start_at

	var/gametime_offset = 432000 //Deciseconds to add to world.time for station time.
	var/station_time_rate_multiplier = 12 //factor of station time progressal vs real time.

	/// Num of players, used for pregame stats on statpanel
	var/totalPlayers = 0
	/// Num of ready players, used for pregame stats on statpanel (only viewable by admins)
	var/totalPlayersReady = 0
	/// Num of ready admins, used for pregame stats on statpanel (only viewable by admins)
	var/total_admins_ready = 0

	var/queue_delay = 0
	var/list/queued_players = list() //used for join queues when the server exceeds the hard population cap

	/// What is going to be reported to other stations at end of round?
	var/news_report


	var/roundend_check_paused = FALSE

	var/round_start_time = 0
	var/list/round_start_events
	var/list/round_end_events
	var/mode_result = "undefined"
	var/end_state = "undefined"

	/// People who have been commended and will receive a heart
	var/list/hearts

	/// Why an emergency shuttle was called
	var/emergency_reason

	/// ID of round reboot timer, if it exists
	var/reboot_timer = null
	/// ID of round countdown timer, if it exists
	var/countdown_timer = null

	/// ### LEGACY VARS ###
	/// Default time to wait before rebooting in desiseconds.
	var/const/restart_timeout = 4 MINUTES
	/// Track where we are ending game/round
	var/end_game_state = END_GAME_NOT_OVER
	/// Time remaining until restart in desiseconds
	var/restart_timeleft
	/// world.time of last restart warning.
	var/last_restart_notify

/datum/controller/subsystem/ticker/Initialize()
	start_at = world.time + (CONFIG_GET(number/lobby_countdown) * 10)
	return SS_INIT_SUCCESS

/datum/controller/subsystem/ticker/fire(resumed = FALSE)
	switch(current_state)
		if(GAME_STATE_STARTUP)
			// if(Master.initializations_finished_with_no_players_logged_in) // We want to wait the full time after the startup finished
			start_at = world.time + (CONFIG_GET(number/lobby_countdown) * 10)
			for(var/client/C in GLOB.clients)
				window_flash(C, ignorepref = TRUE) //let them know lobby has opened up.
			to_chat(world, span_boldnotice("Welcome to [station_name()]!"))
			for(var/channel_tag in CONFIG_GET(str_list/channel_announce_new_game))
				send2chat(new /datum/tgs_message_content("New round starting on [using_map.full_name] ([using_map.name])!"), channel_tag)
			current_state = GAME_STATE_PREGAME
			SEND_SIGNAL(src, COMSIG_TICKER_ENTER_PREGAME)

			fire()
		if(GAME_STATE_PREGAME)
			//lobby stats for statpanels
			if(isnull(timeLeft))
				timeLeft = max(0,start_at - world.time)
				to_chat(world, span_notice("Round starting in [round(timeLeft / 10)] Seconds!"))
			totalPlayers = LAZYLEN(GLOB.new_player_list)
			totalPlayersReady = 0
			total_admins_ready = 0
			for(var/mob/new_player/player as anything in GLOB.new_player_list)
				if(player.ready == PLAYER_READY_TO_PLAY)
					++totalPlayersReady
					if(player.client?.holder)
						++total_admins_ready

			if(start_immediately)
				timeLeft = 0

			//countdown
			if(timeLeft < 0)
				return

			// Do not count down the time, if the game start is delayed
			if (GLOB.round_progressing)
				timeLeft -= wait

			//if(timeLeft <= 300 && !tipped)
			//	send_tip_of_the_round(world, selected_tip)
			//	tipped = TRUE

			if(timeLeft <= 0)
				SEND_SIGNAL(src, COMSIG_TICKER_ENTER_SETTING_UP)
				current_state = GAME_STATE_SETTING_UP
				Master.SetRunLevel(RUNLEVEL_SETUP)
				if(start_immediately)
					fire()

		if(GAME_STATE_SETTING_UP)
			if(!setup())
				//setup failed
				current_state = GAME_STATE_STARTUP
				start_at = world.time + (CONFIG_GET(number/lobby_countdown) * 10)
				timeLeft = null
				Master.SetRunLevel(RUNLEVEL_LOBBY)
				SEND_SIGNAL(src, COMSIG_TICKER_ERROR_SETTING_UP)

		if(GAME_STATE_PLAYING)
			mode.process() // So THIS is where we run mode.process() huh? Okay

			if(mode.explosion_in_progress)
				return // wait until explosion is done.

			if(force_ending)
				current_state = GAME_STATE_FINISHED
				declare_completion(force_ending)
				Master.SetRunLevel(RUNLEVEL_POSTGAME)
			else
				// Calculate if game and/or mode are finished (Complicated by the continuous_rounds config option)
				var/game_finished = FALSE
				var/mode_finished = FALSE
				if (CONFIG_GET(flag/continuous_rounds)) // Game keeps going after mode ends.
					game_finished = (GLOB.emergency_shuttle.returned() || mode.station_was_nuked)
					mode_finished = ((end_game_state >= END_GAME_MODE_FINISHED) || mode.check_finished()) // Short circuit if already finished.
				else // Game ends when mode does
					game_finished = (mode.check_finished() || (GLOB.emergency_shuttle.returned() && GLOB.emergency_shuttle.evac == 1)) || GLOB.universe_has_ended
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
					to_chat(world, span_boldannounce("The round has ended!"))
					SSvote.start_vote(new /datum/vote/crew_transfer)

		// FIXME: IMPROVE THIS LATER!
		if(GAME_STATE_FINISHED)
			post_game_tick()

			if (world.time - last_restart_notify >= 1 MINUTE && !delay_end)
				to_chat(world, span_boldannounce("Restarting in [round(restart_timeleft/600, 1)] minute\s."))
				last_restart_notify = world.time

/datum/controller/subsystem/ticker/proc/setup()
	to_chat(world, span_boldannounce("Starting game..."))
	var/init_start = world.timeofday

	CHECK_TICK
	setup_choose_gamemode()
	// TODO

	CHECK_TICK
	setup_economy()
	create_characters() //Create player characters
	collect_minds()
	equip_characters()

	//	data_core.manifest()

	for(var/I in round_start_events)
		var/datum/callback/cb = I
		cb.InvokeAsync()
	LAZYCLEARLIST(round_start_events)

	//otherwise round_start_time would be 0 for the signals
	round_start_time = world.time
	GLOB.round_start_time = REALTIMEOFDAY
	SEND_SIGNAL(src, COMSIG_TICKER_ROUND_STARTING, world.time)
	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_ROUND_START)

	// Spawn randomized items
	for(var/id, value in GLOB.multi_point_spawns)
		var/obj/random_multi/rm = pickweight(value)
		rm.generate_items()
		for(var/entry in value)
			qdel(entry)

	// Place empty AI cores once we know who is playing AI
	for(var/obj/effect/landmark/start/S in GLOB.landmarks_list)
		if(S.name != JOB_AI)
			continue
		if(locate(/mob/living) in S.loc)
			continue
		GLOB.empty_playable_ai_cores += new /obj/structure/AIcore/deactivated(get_turf(S))

	// Final init, these things need round to start for their info to be ready
	for(var/obj/item/paper/dockingcodes/dcp as anything in GLOB.papers_dockingcode)
		dcp.populate_info()
	for(var/obj/machinery/power/solar_control/SC as anything in GLOB.solars_list)
		SC.auto_start()

	log_world("Game start took [(world.timeofday - init_start)/10]s")
	INVOKE_ASYNC(SSdbcore, TYPE_PROC_REF(/datum/controller/subsystem/dbcore,SetRoundStart))

	to_chat(world, span_notice(span_bold("Welcome to [station_name()], enjoy your stay!")))
	world << sound('sound/AI/welcome.ogg') // Skie
	//SEND_SOUND(world, sound(SSstation.announcer.get_rand_welcome_sound()))

	current_state = GAME_STATE_PLAYING
	Master.SetRunLevel(RUNLEVEL_GAME)

	//Holiday Round-start stuff	~Carn
	Holiday_Game_Start()

	// TODO END

	PostSetup()

	return TRUE

/datum/controller/subsystem/ticker/proc/PostSetup()
	set waitfor = FALSE
	mode.post_setup()
	// TODO

	var/list/adm = get_admin_counts()
	var/list/allmins = adm["present"]
	send2adminchat("Server", "Round [GLOB.round_id ? "#[GLOB.round_id]" : ""] has started[allmins.len ? ".":" with no active admins online!"]")

	setup_done = TRUE
	// TODO START

	// TODO END
	for(var/obj/effect/landmark/start/S in GLOB.landmarks_list)
		//Deleting Startpoints but we need the ai point to AI-ize people later
		if (S.name != "AI")
			qdel(S)

	if(CONFIG_GET(flag/sql_enabled))
		statistic_cycle() // Polls population totals regularly and stores them in an SQL DB -- TLE

//These callbacks will fire after roundstart key transfer
/datum/controller/subsystem/ticker/proc/OnRoundstart(datum/callback/cb)
	if(!HasRoundStarted())
		LAZYADD(round_start_events, cb)
	else
		cb.InvokeAsync()

//These callbacks will fire before roundend report
/datum/controller/subsystem/ticker/proc/OnRoundend(datum/callback/cb)
	if(current_state >= GAME_STATE_FINISHED)
		cb.InvokeAsync()
	else
		LAZYADD(round_end_events, cb)

// Formerly the first half of setup() - The part that chooses the game mode.
// Returns 0 if failed to pick a mode, otherwise 1
/datum/controller/subsystem/ticker/proc/setup_choose_gamemode()
	//Create and announce mode
	if(GLOB.master_mode == "secret")
		src.hide_mode = TRUE

	var/list/runnable_modes = config.get_runnable_modes()
	if((GLOB.master_mode == "random") || (GLOB.master_mode == "secret"))
		if(!runnable_modes.len)
			to_chat(world, span_filter_system(span_bold("Unable to choose playable game mode.") + " Reverting to pregame lobby."))
			return 0
		if(GLOB.secret_force_mode != "secret")
			src.mode = config.pick_mode(GLOB.secret_force_mode)
		if(!src.mode)
			var/list/weighted_modes = list()
			for(var/datum/game_mode/GM in runnable_modes)
				weighted_modes[GM.config_tag] = CONFIG_GET(keyed_list/probabilities)[GM.config_tag]
			src.mode = config.gamemode_cache[pickweight(weighted_modes)]
	else
		src.mode = config.pick_mode(GLOB.master_mode)

	if(!src.mode)
		to_chat(world, span_boldannounce("Serious error in mode setup! Reverting to pregame lobby.")) //Uses setup instead of set up due to computational context.
		return 0

	GLOB.job_master.ResetOccupations()
	src.mode.create_antagonists()
	src.mode.pre_setup()
	GLOB.job_master.DivideOccupations() // Apparently important for new antagonist system to register specific job antags properly.

	if(!src.mode.can_start())
		to_chat(world, span_filter_system(span_bold("Unable to start [mode.name].") + " Not enough players readied, [CONFIG_GET(keyed_list/player_requirements)[mode.config_tag]] players needed. Reverting to pregame lobby."))
		mode.fail_setup()
		mode = null
		GLOB.job_master.ResetOccupations()
		return 0

	if(hide_mode)
		to_chat(world, span_world(span_notice("The current game mode is - Secret!")))
		if(runnable_modes.len)
			var/list/tmpmodes = list()
			for (var/datum/game_mode/M in runnable_modes)
				tmpmodes+=M.name
			tmpmodes = sortList(tmpmodes)
			if(tmpmodes.len)
				to_chat(world, span_filter_system(span_bold("Possibilities:") + " [english_list(tmpmodes, and_text= "; ", comma_text = "; ")]"))
	else
		src.mode.announce()
	return 1

// Called during GAME_STATE_FINISHED (RUNLEVEL_POSTGAME)
/datum/controller/subsystem/ticker/proc/post_game_tick()
	switch(end_game_state)
		if(END_GAME_READY_TO_END)
			callHook("roundend") // TODO, remove all hooks that use this in favor of global signal
			SEND_GLOBAL_SIGNAL(COMSIG_GLOB_ROUND_END)

			if (mode.station_was_nuked)
				feedback_set_details("end_proper", "nuke")
				restart_timeleft = 1 MINUTE // No point waiting five minutes if everyone's dead.
				if(!delay_end)
					to_chat(world, span_boldannounce("Rebooting due to destruction of [station_name()] in [round(restart_timeleft/600)] minute\s."))
					last_restart_notify = world.time
			else
				feedback_set_details("end_proper", "proper completion")
				restart_timeleft = restart_timeout

			if(blackbox)
				blackbox.save_all_data_to_sql()	// TODO - Blackbox or statistics subsystem

			end_game_state = END_GAME_ENDING
			return

/datum/controller/subsystem/ticker/proc/create_characters()
	for(var/mob/new_player/player in GLOB.player_list)
		if(player && player.ready && player.mind?.assigned_role)
			var/datum/job/J = SSjob.get_job(player.mind.assigned_role)

			// Ask their new_player mob to spawn them
			if(!player.spawn_checks_vr(player.mind.assigned_role))
				var/datum/job/job_datum = GLOB.job_master.GetJob(J.title)
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
					new_char.client.init_verbs()

			// If they're a carbon, they can get manifested
			if(J?.mob_type & JOB_CARBON)
				GLOB.data_core.manifest_inject(new_char)
		CHECK_TICK

/datum/controller/subsystem/ticker/proc/collect_minds()
	for(var/mob/living/player in GLOB.player_list)
		if(player.mind)
			minds += player.mind
		CHECK_TICK

/datum/controller/subsystem/ticker/proc/equip_characters()
	var/captainless=1
	for(var/mob/living/carbon/human/player in GLOB.player_list)
		if(player && player.mind && player.mind.assigned_role)
			if(player.mind.assigned_role == JOB_SITE_MANAGER)
				captainless=0
			if(!player_is_antag(player.mind, only_offstation_roles = 1))
				GLOB.job_master.EquipRank(player, player.mind.assigned_role, 0)
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
		CHECK_TICK
	if(captainless)
		for(var/mob/M in GLOB.player_list)
			if(!isnewplayer(M))
				to_chat(M, span_notice("Site Management is not forced on anyone."))

///Whether the game has started, including roundend.
/datum/controller/subsystem/ticker/proc/HasRoundStarted()
	return current_state >= GAME_STATE_PLAYING

///Whether the game is currently in progress, excluding roundend
/datum/controller/subsystem/ticker/proc/IsRoundInProgress()
	return current_state == GAME_STATE_PLAYING

///Whether the game is currently in progress, excluding roundend
/datum/controller/subsystem/ticker/proc/IsPostgame()
	return current_state == GAME_STATE_FINISHED

/datum/controller/subsystem/ticker/Recover()
	current_state = SSticker.current_state
	force_ending = SSticker.force_ending

	login_music = SSticker.login_music
	round_end_sound = SSticker.round_end_sound

	minds = SSticker.minds

	delay_end = SSticker.delay_end

	tipped = SSticker.tipped
	selected_tip = SSticker.selected_tip

	timeLeft = SSticker.timeLeft

	totalPlayers = SSticker.totalPlayers
	totalPlayersReady = SSticker.totalPlayersReady
	total_admins_ready = SSticker.total_admins_ready

	queue_delay = SSticker.queue_delay
	queued_players = SSticker.queued_players
	round_start_time = SSticker.round_start_time

	queue_delay = SSticker.queue_delay
	queued_players = SSticker.queued_players

	if (Master) //Set Masters run level if it exists
		switch (current_state)
			if(GAME_STATE_SETTING_UP)
				Master.SetRunLevel(RUNLEVEL_SETUP)
			if(GAME_STATE_PLAYING)
				Master.SetRunLevel(RUNLEVEL_GAME)
			if(GAME_STATE_FINISHED)
				Master.SetRunLevel(RUNLEVEL_POSTGAME)

/datum/controller/subsystem/ticker/proc/Reboot(reason, end_string, delay)
	set waitfor = FALSE
	if(usr && !check_rights(R_SERVER, TRUE))
		return

	if(!delay)
		delay = CONFIG_GET(number/round_end_countdown) SECONDS
		if(delay >= 60 SECONDS)
			countdown_timer = addtimer(CALLBACK(src, PROC_REF(announce_countdown), delay), 60 SECONDS)

	var/skip_delay = check_rights()
	if(delay_end && !skip_delay)
		to_chat(world, span_boldannounce("An admin has delayed the round end."))
		return

	to_chat(world, span_boldannounce("Rebooting World in [DisplayTimeText(delay)]. [reason]"))

	// We dont have those
	//var/statspage = CONFIG_GET(string/roundstatsurl)
	//var/gamelogloc = CONFIG_GET(string/gamelogurl)
	//if(statspage)
	//	to_chat(world, span_info("Round statistics and logs can be viewed <a href=\"[statspage][GLOB.round_id]\">at this website!</a>"))
	//else if(gamelogloc)
	//	to_chat(world, span_info("Round logs can be located <a href=\"[gamelogloc]\">at this website!</a>"))

	var/start_wait = world.time
	UNTIL(round_end_sound_sent || (world.time - start_wait) > (delay * 2)) //don't wait forever
	reboot_timer = addtimer(CALLBACK(src, PROC_REF(reboot_callback), reason, end_string), delay - (world.time - start_wait), TIMER_STOPPABLE)

/datum/controller/subsystem/ticker/proc/announce_countdown(remaining_time)
	remaining_time -= 60 SECONDS
	if(remaining_time > 60 SECONDS)
		to_chat(world, span_boldannounce("Rebooting World in [DisplayTimeText(remaining_time)]."))
		countdown_timer = addtimer(CALLBACK(src, PROC_REF(announce_countdown), remaining_time), 60 SECONDS)
		return
	if(remaining_time <= 60 SECONDS && remaining_time > 0)
		countdown_timer = addtimer(CALLBACK(src, PROC_REF(announce_countdown), remaining_time - 1 SECOND), remaining_time)
		return
	if(!delay_end)
		to_chat(world, span_boldannounce("Rebooting World."))

/datum/controller/subsystem/ticker/proc/reboot_callback(reason, end_string)
	if(end_string)
		end_state = end_string

	log_game(span_boldannounce("Rebooting World. [reason]"))

	world.Reboot()

/**
 * Deletes the current reboot timer and nulls the var
 *
 * Arguments:
 * * user - the user that cancelled the reboot, may be null
 */
/datum/controller/subsystem/ticker/proc/cancel_reboot(mob/user)
	if(!reboot_timer)
		to_chat(user, span_warning("There is no pending reboot!"))
		return FALSE
	to_chat(world, span_boldannounce("An admin has delayed the round end."))
	deltimer(reboot_timer)
	reboot_timer = null
	if(countdown_timer)
		deltimer(countdown_timer)
		countdown_timer = null
	return TRUE

/**
 * Helper proc that delays the roundend for us.
 * This proc will trigger a reboot if the delay is 'toggled off'.
 * Use with care.
 */
/datum/controller/subsystem/ticker/proc/toggle_delay()
	delay_end = !delay_end

	if(countdown_timer)
		deltimer(countdown_timer)
		countdown_timer = null
	if(reboot_timer)
		deltimer(reboot_timer)
		reboot_timer = null
	else
		Reboot("World reboot after administrative delay.")
