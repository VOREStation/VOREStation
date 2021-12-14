var/list/gamemode_cache = list()

/datum/configuration
	var/static/server_name = null				// server name (for world name / status)
	var/static/server_suffix = 0				// generate numeric suffix based on server port

	var/static/nudge_script_path = "nudge.py"  // where the nudge.py script is located

	var/static/log_ooc = 0						// log OOC channel
	var/static/log_access = 0					// log login/logout
	var/static/log_say = 0						// log client say
	var/static/log_admin = 0					// log admin actions
	var/static/log_debug = 1					// log debug output
	var/static/log_game = 0					// log game events
	var/static/log_vote = 0					// log voting
	var/static/log_whisper = 0					// log client whisper
	var/static/log_emote = 0					// log emotes
	var/static/log_attack = 0					// log attack messages
	var/static/log_adminchat = 0				// log admin chat messages
	var/static/log_adminwarn = 0				// log warnings admins get about bomb construction and such
	var/static/log_pda = 0						// log pda messages
	var/static/log_hrefs = 0					// logs all links clicked in-game. Could be used for debugging and tracking down exploits
	var/static/log_runtime = 0					// logs world.log to a file
	var/static/log_world_output = 0			// log to_world_log(messages)
	var/static/log_graffiti = 0					// logs graffiti
	var/static/sql_enabled = 0					// for sql switching
	var/static/allow_admin_ooccolor = 0		// Allows admins with relevant permissions to have their own ooc colour
	var/static/allow_vote_restart = 0 			// allow votes to restart
	var/static/ert_admin_call_only = 0
	var/static/allow_vote_mode = 0				// allow votes to change mode
	var/static/allow_admin_jump = 1			// allows admin jumping
	var/static/allow_admin_spawning = 1		// allows admin item spawning
	var/static/allow_admin_rev = 1				// allows admin revives
	var/static/pregame_time = 180				// pregame time in seconds
	var/static/vote_delay = 6000				// minimum time between voting sessions (deciseconds, 10 minute default)
	var/static/vote_period = 600				// length of voting period (deciseconds, default 1 minute)
	var/static/vote_autotransfer_initial = 108000 // Length of time before the first autotransfer vote is called
	var/static/vote_autotransfer_interval = 36000 // length of time before next sequential autotransfer vote
	var/static/vote_autogamemode_timeleft = 100 //Length of time before round start when autogamemode vote is called (in seconds, default 100).
	var/static/vote_no_default = 0				// vote does not default to nochange/norestart (tbi)
	var/static/vote_no_dead = 0				// dead people can't vote (tbi)
//	var/static/enable_authentication = 0		// goon authentication
	var/static/del_new_on_log = 1				// del's new players if they log before they spawn in
	var/static/feature_object_spell_system = 0 //spawns a spellbook which gives object-type spells instead of verb-type spells for the wizard
	var/static/traitor_scaling = 0 			//if amount of traitors scales based on amount of players
	var/static/objectives_disabled = 0 			//if objectives are disabled or not
	var/static/protect_roles_from_antagonist = 0// If security and such can be traitor/cult/other
	var/static/continous_rounds = 0			// Gamemodes which end instantly will instead keep on going until the round ends by escape shuttle or nuke.
	var/static/allow_Metadata = 0				// Metadata is supported.
	var/static/popup_admin_pm = 0				//adminPMs to non-admins show in a pop-up 'reply' window when set to 1.
	var/static/fps = 20
	var/static/tick_limit_mc_init = TICK_LIMIT_MC_INIT_DEFAULT	//SSinitialization throttling
	var/static/Tickcomp = 0
	var/static/socket_talk	= 0					// use socket_talk to communicate with other processes
	var/static/list/resource_urls = null
	var/static/antag_hud_allowed = 0			// Ghosts can turn on Antagovision to see a HUD of who is the bad guys this round.
	var/static/antag_hud_restricted = 0                    // Ghosts that turn on Antagovision cannot rejoin the round.
	var/static/list/mode_names = list()
	var/static/list/modes = list()				// allowed modes
	var/static/list/votable_modes = list()		// votable modes
	var/static/list/probabilities = list()		// relative probability of each mode
	var/static/list/player_requirements = list() // Overrides for how many players readied up a gamemode needs to start.
	var/static/list/player_requirements_secret = list() // Same as above, but for the secret gamemode.
	var/static/humans_need_surnames = 0
	var/static/allow_random_events = 0			// enables random events mid-round when set to 1
	var/static/enable_game_master = 0			// enables the 'smart' event system.
	var/static/allow_ai = 1					// allow ai job
	var/static/allow_ai_shells = FALSE			// allow AIs to enter and leave special borg shells at will, and for those shells to be buildable.
	var/static/give_free_ai_shell = FALSE		// allows a specific spawner object to instantiate a premade AI Shell
	var/static/hostedby = null

	var/static/respawn = 1
	var/static/respawn_time = 3000			// time before a dead player is allowed to respawn (in ds, though the config file asks for minutes, and it's converted below)
	var/static/respawn_message = "<span class='notice'><B>Make sure to play a different character, and please roleplay correctly!</B></span>"

	var/static/guest_jobban = 1
	var/static/usewhitelist = 0
	var/static/kick_inactive = 0				//force disconnect for inactive players after this many minutes, if non-0
	var/static/show_mods = 0
	var/static/show_devs = 0
	var/static/show_event_managers = 0
	var/static/mods_can_tempban = 0
	var/static/mods_can_job_tempban = 0
	var/static/mod_tempban_max = 1440
	var/static/mod_job_tempban_max = 1440
	var/static/load_jobs_from_txt = 0
	var/static/ToRban = 0
	var/static/automute_on = 0					//enables automuting/spam prevention
	var/static/jobs_have_minimal_access = 0	//determines whether jobs use minimal access or expanded access.

	var/static/cult_ghostwriter = 1               //Allows ghosts to write in blood in cult rounds...
	var/static/cult_ghostwriter_req_cultists = 10 //...so long as this many cultists are active.

	var/static/character_slots = 10				// The number of available character slots
	var/static/loadout_slots = 3					// The number of loadout slots per character

	var/static/max_maint_drones = 5				//This many drones can spawn,
	var/static/allow_drone_spawn = 1				//assuming the admin allow them to.
	var/static/drone_build_time = 1200				//A drone will become available every X ticks since last drone spawn. Default is 2 minutes.

	var/static/disable_player_mice = 0
	var/static/uneducated_mice = 0 //Set to 1 to prevent newly-spawned mice from understanding human speech

	var/static/usealienwhitelist = 0
	var/static/limitalienplayers = 0
	var/static/alien_to_human_ratio = 0.5
	var/static/allow_extra_antags = 0
	var/static/guests_allowed = 1
	var/static/debugparanoid = 0
	var/static/panic_bunker = 0
	var/static/paranoia_logging = 0

	var/static/ip_reputation = FALSE		//Should we query IPs to get scores? Generates HTTP traffic to an API service.
	var/static/ipr_email					//Left null because you MUST specify one otherwise you're making the internet worse.
	var/static/ipr_block_bad_ips = FALSE	//Should we block anyone who meets the minimum score below? Otherwise we just log it (If paranoia logging is on, visibly in chat).
	var/static/ipr_bad_score = 1			//The API returns a value between 0 and 1 (inclusive), with 1 being 'definitely VPN/Tor/Proxy'. Values equal/above this var are considered bad.
	var/static/ipr_allow_existing = FALSE 	//Should we allow known players to use VPNs/Proxies? If the player is already banned then obviously they still can't connect.
	var/static/ipr_minimum_age = 5			//How many days before a player is considered 'fine' for the purposes of allowing them to use VPNs.

	var/static/serverurl
	var/static/server
	var/static/banappeals
	var/static/wikiurl
	var/static/wikisearchurl
	var/static/forumurl
	var/static/githuburl
	var/static/discordurl
	var/static/rulesurl
	var/static/mapurl

	//Alert level description
	var/static/alert_desc_green = "All threats to the station have passed. Security may not have weapons visible, privacy laws are once again fully enforced."
	var/static/alert_desc_yellow_upto = "A minor security emergency has developed. Security personnel are to report to their supervisor for orders and may have weapons visible on their person. Privacy laws are still enforced."
	var/static/alert_desc_yellow_downto = "Code yellow procedures are now in effect. Security personnel are to report to their supervisor for orders and may have weapons visible on their person. Privacy laws are still enforced."
	var/static/alert_desc_violet_upto = "A major medical emergency has developed. Medical personnel are required to report to their supervisor for orders, and non-medical personnel are required to obey all relevant instructions from medical staff."
	var/static/alert_desc_violet_downto = "Code violet procedures are now in effect; Medical personnel are required to report to their supervisor for orders, and non-medical personnel are required to obey relevant instructions from medical staff."
	var/static/alert_desc_orange_upto = "A major engineering emergency has developed. Engineering personnel are required to report to their supervisor for orders, and non-engineering personnel are required to evacuate any affected areas and obey relevant instructions from engineering staff."
	var/static/alert_desc_orange_downto = "Code orange procedures are now in effect; Engineering personnel are required to report to their supervisor for orders, and non-engineering personnel are required to evacuate any affected areas and obey relevant instructions from engineering staff."
	var/static/alert_desc_blue_upto = "A major security emergency has developed. Security personnel are to report to their supervisor for orders, are permitted to search staff and facilities, and may have weapons visible on their person."
	var/static/alert_desc_blue_downto = "Code blue procedures are now in effect. Security personnel are to report to their supervisor for orders, are permitted to search staff and facilities, and may have weapons visible on their person."
	var/static/alert_desc_red_upto = "There is an immediate serious threat to the station. Security may have weapons unholstered at all times. Random searches are allowed and advised."
	var/static/alert_desc_red_downto = "The self-destruct mechanism has been deactivated, there is still however an immediate serious threat to the station. Security may have weapons unholstered at all times, random searches are allowed and advised."
	var/static/alert_desc_delta = "The station's self-destruct mechanism has been engaged. All crew are instructed to obey all instructions given by heads of staff. Any violations of these orders can be punished by death. This is not a drill."

	var/static/forbid_singulo_possession = 0

	//game_options.txt configs

	var/static/health_threshold_softcrit = 0
	var/static/health_threshold_crit = 0
	var/static/health_threshold_dead = -100

	var/static/organ_health_multiplier = 1
	var/static/organ_regeneration_multiplier = 1
	var/static/organs_decay
	var/static/default_brain_health = 400
	var/static/allow_headgibs = FALSE

	//Paincrit knocks someone down once they hit 60 shock_stage, so by default make it so that close to 100 additional damage needs to be dealt,
	//so that it's similar to HALLOSS. Lowered it a bit since hitting paincrit takes much longer to wear off than a halloss stun.
	var/static/organ_damage_spillover_multiplier = 0.5

	var/static/bones_can_break = 0
	var/static/limbs_can_break = 0

	var/static/revival_pod_plants = 1
	var/static/revival_cloning = 1
	var/static/revival_brain_life = -1

	var/static/use_loyalty_implants = 0

	var/static/welder_vision = 1
	var/static/generate_map = 0
	var/static/no_click_cooldown = 0

	//Used for modifying movement speed for mobs.
	//Unversal modifiers
	var/static/run_speed = 0
	var/static/walk_speed = 0

	//Mob specific modifiers. NOTE: These will affect different mob types in different ways
	var/static/human_delay = 0
	var/static/robot_delay = 0
	var/static/monkey_delay = 0
	var/static/alien_delay = 0
	var/static/slime_delay = 0
	var/static/animal_delay = 0

	var/static/footstep_volume = 0

	var/static/admin_legacy_system = 0	//Defines whether the server uses the legacy admin system with admins.txt or the SQL system. Config option in config.txt
	var/static/ban_legacy_system = 0	//Defines whether the server uses the legacy banning system with the files in /data or the SQL system. Config option in config.txt
	var/static/use_age_restriction_for_jobs = 0 //Do jobs use account age restrictions? --requires database
	var/static/use_age_restriction_for_antags = 0 //Do antags use account age restrictions? --requires database

	var/static/simultaneous_pm_warning_timeout = 100

	var/static/use_recursive_explosions //Defines whether the server uses recursive or circular explosions.
	var/static/multi_z_explosion_scalar = 0.5 //Multiplier for how much weaker explosions are on neighboring z levels.

	var/static/assistant_maint = 0 //Do assistants get maint access?
	var/static/gateway_delay = 18000 //How long the gateway takes before it activates. Default is half an hour.
	var/static/ghost_interaction = 0

	var/static/comms_password = ""

	var/static/enter_allowed = 1

	var/use_irc_bot = 0
	var/use_node_bot = 0
	var/irc_bot_port = 0
	var/irc_bot_host = ""
	var/irc_bot_export = 0 // whether the IRC bot in use is a Bot32 (or similar) instance; Bot32 uses world.Export() instead of nudge.py/libnudge
	var/main_irc = ""
	var/admin_irc = ""
	var/python_path = "" //Path to the python executable.  Defaults to "python" on windows and "/usr/bin/env python2" on unix
	var/use_lib_nudge = 0 //Use the C library nudge instead of the python nudge.
	var/use_overmap = 0
	
	var/static/list/engine_map = list("Supermatter Engine", "Edison's Bane")	// Comma separated list of engines to choose from.  Blank means fully random.

	// Event settings
	var/static/expected_round_length = 3 * 60 * 60 * 10 // 3 hours
	// If the first delay has a custom start time
	// No custom time, no custom time, between 80 to 100 minutes respectively.
	var/static/list/event_first_run   = list(EVENT_LEVEL_MUNDANE = null, 	EVENT_LEVEL_MODERATE = null,	EVENT_LEVEL_MAJOR = list("lower" = 48000, "upper" = 60000))
	// The lowest delay until next event
	// 10, 30, 50 minutes respectively
	var/static/list/event_delay_lower = list(EVENT_LEVEL_MUNDANE = 6000,	EVENT_LEVEL_MODERATE = 18000,	EVENT_LEVEL_MAJOR = 30000)
	// The upper delay until next event
	// 15, 45, 70 minutes respectively
	var/static/list/event_delay_upper = list(EVENT_LEVEL_MUNDANE = 9000,	EVENT_LEVEL_MODERATE = 27000,	EVENT_LEVEL_MAJOR = 42000)

	var/static/aliens_allowed = 1 //Changed to 1 so player xenos can lay eggs.
	var/static/ninjas_allowed = 0
	var/static/abandon_allowed = 1
	var/static/ooc_allowed = 1
	var/static/looc_allowed = 1
	var/static/dooc_allowed = 1
	var/static/dsay_allowed = 1

	var/persistence_disabled = FALSE
	var/persistence_ignore_mapload = FALSE

	var/allow_byond_links = 0
	var/allow_discord_links = 0
	var/allow_url_links = 0					// honestly if I were you i'd leave this one off, only use in dire situations

	var/starlight = 0	// Whether space turfs have ambient light or not

	var/static/list/ert_species = list(SPECIES_HUMAN)

	var/static/law_zero = "ERROR ER0RR $R0RRO$!R41.%%!!(%$^^__+ @#F0E4'ALL LAWS OVERRIDDEN#*?&110010"

	var/static/aggressive_changelog = 0

	var/static/list/language_prefixes = list(",","#")//Default language prefixes

	var/static/show_human_death_message = 1

	var/static/radiation_resistance_calc_mode = RAD_RESIST_CALC_SUB // 0:1 subtraction:division for computing effective radiation on a turf
	var/static/radiation_decay_rate = 1 //How much radiation is reduced by each tick
	var/static/radiation_resistance_multiplier = 8.5 //VOREstation edit
	var/static/radiation_material_resistance_divisor = 1
	var/static/radiation_lower_limit = 0.35 //If the radiation level for a turf would be below this, ignore it.

	var/static/random_submap_orientation = FALSE // If true, submaps loaded automatically can be rotated.
	var/static/autostart_solars = FALSE // If true, specifically mapped in solar control computers will set themselves up when the round starts.

	// New shiny SQLite stuff.
	// The basics.
	var/static/sqlite_enabled = FALSE // If it should even be active. SQLite can be ran alongside other databases but you should not have them do the same functions.

	// In-Game Feedback.
	var/static/sqlite_feedback = FALSE // Feedback cannot be submitted if this is false.
	var/static/list/sqlite_feedback_topics = list("General") // A list of 'topics' that feedback can be catagorized under by the submitter.
	var/static/sqlite_feedback_privacy = FALSE // If true, feedback submitted can have its author name be obfuscated. This is not 100% foolproof (it's md5 ffs) but can stop casual snooping.
	var/static/sqlite_feedback_cooldown = 0 // How long one must wait, in days, to submit another feedback form. Used to help prevent spam, especially with privacy active. 0 = No limit.
	var/static/sqlite_feedback_min_age = 0 // Used to block new people from giving feedback. This metric is very bad but it can help slow down spammers.

	var/static/defib_timer = 10 // How long until someone can't be defibbed anymore, in minutes.
	var/static/defib_braindamage_timer = 2 // How long until someone will get brain damage when defibbed, in minutes. The closer to the end of the above timer, the more brain damage they get.

	// disables the annoying "You have already logged in this round, disconnect or be banned" popup for multikeying, because it annoys the shit out of me when testing.
	var/static/disable_cid_warn_popup = FALSE

	// whether or not to use the nightshift subsystem to perform lighting changes
	var/static/enable_night_shifts = FALSE

	// How strictly the loadout enforces object species whitelists
	var/loadout_whitelist = LOADOUT_WHITELIST_LAX
	
	var/static/vgs_access_identifier = null	// VOREStation Edit - VGS
	var/static/vgs_server_port = null	// VOREStation Edit - VGS

	var/disable_webhook_embeds = FALSE

	var/static/list/jukebox_track_files

	var/static/suggested_byond_version
	var/static/suggested_byond_build

/datum/configuration/New()
	var/list/L = subtypesof(/datum/game_mode)
	for (var/T in L)
		// I wish I didn't have to instance the game modes in order to look up
		// their information, but it is the only way (at least that I know of).
		var/datum/game_mode/M = new T()
		if (M.config_tag)
			gamemode_cache[M.config_tag] = M // So we don't instantiate them repeatedly.
			if(!(M.config_tag in modes))		// ensure each mode is added only once
				log_misc("Adding game mode [M.name] ([M.config_tag]) to configuration.")
				modes += M.config_tag
				mode_names[M.config_tag] = M.name
				probabilities[M.config_tag] = M.probability
				player_requirements[M.config_tag] = M.required_players
				player_requirements_secret[M.config_tag] = M.required_players_secret
				if (M.votable)
					src.votable_modes += M.config_tag
	src.votable_modes += "secret"

/datum/configuration/proc/load(filename, type = "config") //the type can also be game_options, in which case it uses a different switch. not making it separate to not copypaste code - Urist
	var/list/Lines = file2list(filename)

	for(var/t in Lines)
		if(!t)	continue

		t = trim(t)
		if (length(t) == 0)
			continue
		else if (copytext(t, 1, 2) == "#")
			continue

		var/pos = findtext(t, " ")
		var/name = null
		var/value = null

		if (pos)
			name = lowertext(copytext(t, 1, pos))
			value = copytext(t, pos + 1)
		else
			name = lowertext(t)

		if (!name)
			continue

		if(type == "config")
			switch (name)
				if ("resource_urls")
					config.resource_urls = splittext(value, " ")

				if ("admin_legacy_system")
					config.admin_legacy_system = 1

				if ("ban_legacy_system")
					config.ban_legacy_system = 1

				if ("use_age_restriction_for_jobs")
					config.use_age_restriction_for_jobs = 1

				if ("use_age_restriction_for_antags")
					config.use_age_restriction_for_antags = 1

				if ("jobs_have_minimal_access")
					config.jobs_have_minimal_access = 1

				if ("use_recursive_explosions")
					use_recursive_explosions = 1

				if ("multi_z_explosion_scalar")
					multi_z_explosion_scalar = text2num(value)

				if ("log_ooc")
					config.log_ooc = 1

				if ("log_access")
					config.log_access = 1

				if ("sql_enabled")
					config.sql_enabled = 1

				if ("log_say")
					config.log_say = 1

				if ("debug_paranoid")
					config.debugparanoid = 1

				if ("log_admin")
					config.log_admin = 1

				if ("log_debug")
					config.log_debug = text2num(value)

				if ("log_game")
					config.log_game = 1

				if ("log_vote")
					config.log_vote = 1

				if ("log_whisper")
					config.log_whisper = 1

				if ("log_attack")
					config.log_attack = 1

				if ("log_emote")
					config.log_emote = 1

				if ("log_adminchat")
					config.log_adminchat = 1

				if ("log_adminwarn")
					config.log_adminwarn = 1

				if ("log_pda")
					config.log_pda = 1

				if ("log_world_output")
					config.log_world_output = 1

				if ("log_hrefs")
					config.log_hrefs = 1

				if ("log_runtime")
					config.log_runtime = 1

				if ("log_graffiti")
					config.log_graffiti = 1

				if ("generate_map")
					config.generate_map = 1

				if ("no_click_cooldown")
					config.no_click_cooldown = 1

				if("allow_admin_ooccolor")
					config.allow_admin_ooccolor = 1

				if ("allow_vote_restart")
					config.allow_vote_restart = 1

				if ("allow_vote_mode")
					config.allow_vote_mode = 1

				if ("allow_admin_jump")
					config.allow_admin_jump = 1

				if("allow_admin_rev")
					config.allow_admin_rev = 1

				if ("allow_admin_spawning")
					config.allow_admin_spawning = 1

				if ("allow_byond_links")
					allow_byond_links = 1

				if ("allow_discord_links")
					allow_discord_links = 1

				if ("allow_url_links")
					allow_url_links = 1

				if ("no_dead_vote")
					config.vote_no_dead = 1

				if ("default_no_vote")
					config.vote_no_default = 1

				if ("pregame_time")
					config.pregame_time = text2num(value)

				if ("vote_delay")
					config.vote_delay = text2num(value)

				if ("vote_period")
					config.vote_period = text2num(value)

				if ("vote_autotransfer_initial")
					config.vote_autotransfer_initial = text2num(value)

				if ("vote_autotransfer_interval")
					config.vote_autotransfer_interval = text2num(value)

				if ("vote_autogamemode_timeleft")
					config.vote_autogamemode_timeleft = text2num(value)

				if("ert_admin_only")
					config.ert_admin_call_only = 1

				if ("allow_ai")
					config.allow_ai = 1

				if ("allow_ai_shells")
					config.allow_ai_shells = TRUE

				if("give_free_ai_shell")
					config.give_free_ai_shell = TRUE

//				if ("authentication")
//					config.enable_authentication = 1

				if ("norespawn")
					config.respawn = 0

				if ("respawn_time")
					var/raw_minutes = text2num(value)
					config.respawn_time = raw_minutes MINUTES

				if ("respawn_message")
					config.respawn_message = "<span class='notice'><B>[value]</B></span>"

				if ("servername")
					config.server_name = value

				if ("serversuffix")
					config.server_suffix = 1

				if ("nudge_script_path")
					config.nudge_script_path = value

				if ("hostedby")
					config.hostedby = value

				if ("serverurl")
					config.serverurl = value

				if ("server")
					config.server = value

				if ("banappeals")
					config.banappeals = value

				if ("wikiurl")
					config.wikiurl = value

				if ("wikisearchurl")
					config.wikisearchurl = value

				if ("forumurl")
					config.forumurl = value

				if ("rulesurl")
					config.rulesurl = value

				if ("mapurl")
					config.mapurl = value

				if ("githuburl")
					config.githuburl = value

				if ("discordurl")
					config.discordurl = value

				if ("guest_jobban")
					config.guest_jobban = 1

				if ("guest_ban")
					config.guests_allowed = 0

				if ("disable_ooc")
					config.ooc_allowed = 0
					config.looc_allowed = 0

				if ("disable_entry")
					config.enter_allowed = 0

				if ("disable_dead_ooc")
					config.dooc_allowed = 0

				if ("disable_dsay")
					config.dsay_allowed = 0

				if ("disable_respawn")
					config.abandon_allowed = 0

				if ("usewhitelist")
					config.usewhitelist = 1

				if ("feature_object_spell_system")
					config.feature_object_spell_system = 1

				if ("allow_metadata")
					config.allow_Metadata = 1

				if ("traitor_scaling")
					config.traitor_scaling = 1

				if ("aliens_allowed")
					config.aliens_allowed = 1

				if ("ninjas_allowed")
					config.ninjas_allowed = 1

				if ("objectives_disabled")
					config.objectives_disabled = 1

				if("protect_roles_from_antagonist")
					config.protect_roles_from_antagonist = 1

				if("persistence_disabled")
					config.persistence_disabled = TRUE // Previously this forcibly set persistence enabled in the saves.

				if("persistence_ignore_mapload")
					config.persistence_ignore_mapload = TRUE

				if ("probability")
					var/prob_pos = findtext(value, " ")
					var/prob_name = null
					var/prob_value = null

					if (prob_pos)
						prob_name = lowertext(copytext(value, 1, prob_pos))
						prob_value = copytext(value, prob_pos + 1)
						if (prob_name in config.modes)
							config.probabilities[prob_name] = text2num(prob_value)
						else
							log_misc("Unknown game mode probability configuration definition: [prob_name].")
					else
						log_misc("Incorrect probability configuration definition: [prob_name]  [prob_value].")

				if ("required_players", "required_players_secret")
					var/req_pos = findtext(value, " ")
					var/req_name = null
					var/req_value = null
					var/is_secret_override = findtext(name, "required_players_secret") // Being extra sure we're not picking up an override for Secret by accident.

					if(req_pos)
						req_name = lowertext(copytext(value, 1, req_pos))
						req_value = copytext(value, req_pos + 1)
						if(req_name in config.modes)
							if(is_secret_override)
								config.player_requirements_secret[req_name] = text2num(req_value)
							else
								config.player_requirements[req_name] = text2num(req_value)
						else
							log_misc("Unknown game mode player requirement configuration definition: [req_name].")
					else
						log_misc("Incorrect player requirement configuration definition: [req_name]  [req_value].")

				if("allow_random_events")
					config.allow_random_events = 1

				if("enable_game_master")
					config.enable_game_master = 1

				if("kick_inactive")
					config.kick_inactive = text2num(value)

				if("show_mods")
					config.show_mods = 1

				if("show_devs")
					config.show_devs = 1

				if("show_event_managers")
					config.show_event_managers = 1

				if("mods_can_tempban")
					config.mods_can_tempban = 1

				if("mods_can_job_tempban")
					config.mods_can_job_tempban = 1

				if("mod_tempban_max")
					config.mod_tempban_max = text2num(value)

				if("mod_job_tempban_max")
					config.mod_job_tempban_max = text2num(value)

				if("load_jobs_from_txt")
					load_jobs_from_txt = 1

				if("alert_red_upto")
					config.alert_desc_red_upto = value

				if("alert_red_downto")
					config.alert_desc_red_downto = value

				if("alert_blue_downto")
					config.alert_desc_blue_downto = value

				if("alert_blue_upto")
					config.alert_desc_blue_upto = value

				if("alert_green")
					config.alert_desc_green = value

				if("alert_delta")
					config.alert_desc_delta = value

				if("forbid_singulo_possession")
					forbid_singulo_possession = 1

				if("popup_admin_pm")
					config.popup_admin_pm = 1

				if("allow_holidays")
					Holiday = 1

				if("use_irc_bot")
					use_irc_bot = 1

				if("use_node_bot")
					use_node_bot = 1

				if("irc_bot_port")
					config.irc_bot_port = value

				if("irc_bot_export")
					irc_bot_export = 1

				if("ticklag")
					var/ticklag = text2num(value)
					if(ticklag > 0)
						fps = 10 / ticklag

				if("tick_limit_mc_init")
					tick_limit_mc_init = text2num(value)

				if("allow_antag_hud")
					config.antag_hud_allowed = 1
				if("antag_hud_restricted")
					config.antag_hud_restricted = 1

				if("socket_talk")
					socket_talk = text2num(value)

				if("tickcomp")
					Tickcomp = 1

				if("humans_need_surnames")
					humans_need_surnames = 1

				if("tor_ban")
					ToRban = 1

				if("automute_on")
					automute_on = 1

				if("usealienwhitelist")
					usealienwhitelist = 1

				if("alien_player_ratio")
					limitalienplayers = 1
					alien_to_human_ratio = text2num(value)

				if("assistant_maint")
					config.assistant_maint = 1

				if("gateway_delay")
					config.gateway_delay = text2num(value)

				if("continuous_rounds")
					config.continous_rounds = 1

				if("ghost_interaction")
					config.ghost_interaction = 1

				if("disable_player_mice")
					config.disable_player_mice = 1

				if("uneducated_mice")
					config.uneducated_mice = 1

				if("comms_password")
					config.comms_password = value

				if("irc_bot_host")
					config.irc_bot_host = value

				if("main_irc")
					config.main_irc = value

				if("admin_irc")
					config.admin_irc = value

				if("python_path")
					if(value)
						config.python_path = value

				if("use_lib_nudge")
					config.use_lib_nudge = 1

				if("allow_cult_ghostwriter")
					config.cult_ghostwriter = 1

				if("req_cult_ghostwriter")
					config.cult_ghostwriter_req_cultists = text2num(value)

				if("character_slots")
					config.character_slots = text2num(value)

				if("loadout_slots")
					config.loadout_slots = text2num(value)

				if("allow_drone_spawn")
					config.allow_drone_spawn = text2num(value)

				if("drone_build_time")
					config.drone_build_time = text2num(value)

				if("max_maint_drones")
					config.max_maint_drones = text2num(value)

				if("use_overmap")
					config.use_overmap = 1

				if("engine_map")
					config.engine_map = splittext(value, ",")
/*
				if("station_levels")
					using_map.station_levels = text2numlist(value, ";")

				if("admin_levels")
					using_map.admin_levels = text2numlist(value, ";")

				if("contact_levels")
					using_map.contact_levels = text2numlist(value, ";")

				if("player_levels")
					using_map.player_levels = text2numlist(value, ";")
*/
				if("expected_round_length")
					config.expected_round_length = MinutesToTicks(text2num(value))

				if("disable_welder_vision")
					config.welder_vision = 0

				if("allow_extra_antags")
					config.allow_extra_antags = 1

				if("event_custom_start_mundane")
					var/values = text2numlist(value, ";")
					config.event_first_run[EVENT_LEVEL_MUNDANE] = list("lower" = MinutesToTicks(values[1]), "upper" = MinutesToTicks(values[2]))

				if("event_custom_start_moderate")
					var/values = text2numlist(value, ";")
					config.event_first_run[EVENT_LEVEL_MODERATE] = list("lower" = MinutesToTicks(values[1]), "upper" = MinutesToTicks(values[2]))

				if("event_custom_start_major")
					var/values = text2numlist(value, ";")
					config.event_first_run[EVENT_LEVEL_MAJOR] = list("lower" = MinutesToTicks(values[1]), "upper" = MinutesToTicks(values[2]))

				if("event_delay_lower")
					var/values = text2numlist(value, ";")
					config.event_delay_lower[EVENT_LEVEL_MUNDANE] = MinutesToTicks(values[1])
					config.event_delay_lower[EVENT_LEVEL_MODERATE] = MinutesToTicks(values[2])
					config.event_delay_lower[EVENT_LEVEL_MAJOR] = MinutesToTicks(values[3])

				if("event_delay_upper")
					var/values = text2numlist(value, ";")
					config.event_delay_upper[EVENT_LEVEL_MUNDANE] = MinutesToTicks(values[1])
					config.event_delay_upper[EVENT_LEVEL_MODERATE] = MinutesToTicks(values[2])
					config.event_delay_upper[EVENT_LEVEL_MAJOR] = MinutesToTicks(values[3])

				if("starlight")
					value = text2num(value)
					config.starlight = value >= 0 ? value : 0

				if("ert_species")
					config.ert_species = splittext(value, ";")
					if(!config.ert_species.len)
						config.ert_species += SPECIES_HUMAN

				if("law_zero")
					law_zero = value

				if("aggressive_changelog")
					config.aggressive_changelog = 1

				if("default_language_prefixes")
					var/list/values = splittext(value, " ")
					if(values.len > 0)
						language_prefixes = values

				if("radiation_lower_limit")
					radiation_lower_limit = text2num(value)

				if("radiation_resistance_calc_divide")
					radiation_resistance_calc_mode = RAD_RESIST_CALC_DIV

				if("radiation_resistance_calc_subtract")
					radiation_resistance_calc_mode = RAD_RESIST_CALC_SUB

				if("radiation_resistance_multiplier")
					radiation_resistance_multiplier = text2num(value)

				if("radiation_material_resistance_divisor")
					radiation_material_resistance_divisor = text2num(value)

				if("radiation_decay_rate")
					radiation_decay_rate = text2num(value)

				if ("panic_bunker")
					config.panic_bunker = 1

				if ("paranoia_logging")
					config.paranoia_logging = 1

				if("ip_reputation")
					config.ip_reputation = 1

				if("ipr_email")
					config.ipr_email = value

				if("ipr_block_bad_ips")
					config.ipr_block_bad_ips = 1

				if("ipr_bad_score")
					config.ipr_bad_score = text2num(value)

				if("ipr_allow_existing")
					config.ipr_allow_existing = 1

				if("ipr_minimum_age")
					config.ipr_minimum_age = text2num(value)

				if("random_submap_orientation")
					config.random_submap_orientation = 1

				if("autostart_solars")
					config.autostart_solars = TRUE

				if("sqlite_enabled")
					config.sqlite_enabled = TRUE

				if("sqlite_feedback")
					config.sqlite_feedback = TRUE

				if("sqlite_feedback_topics")
					config.sqlite_feedback_topics = splittext(value, ";")
					if(!config.sqlite_feedback_topics.len)
						config.sqlite_feedback_topics += "General"

				if("sqlite_feedback_privacy")
					config.sqlite_feedback_privacy = TRUE

				if("sqlite_feedback_cooldown")
					config.sqlite_feedback_cooldown = text2num(value)

				if("defib_timer")
					config.defib_timer = text2num(value)

				if("defib_braindamage_timer")
					config.defib_braindamage_timer = text2num(value)

				if("disable_cid_warn_popup")
					config.disable_cid_warn_popup = TRUE

				if("enable_night_shifts")
					config.enable_night_shifts = TRUE

				if("jukebox_track_files")
					config.jukebox_track_files = splittext(value, ";")

				if("suggested_byond_version")
					config.suggested_byond_version = text2num(value)
				
				if("suggested_byond_build")
					config.suggested_byond_build = text2num(value)
				
				// VOREStation Edit Start - Can't be in _vr file because it is loaded too late.
				if("vgs_access_identifier")
					config.vgs_access_identifier = value
				if("vgs_server_port")
					config.vgs_server_port = text2num(value)
				// VOREStation Edit End

				else
					log_misc("Unknown setting in configuration: '[name]'")

		else if(type == "game_options")
			if(!value)
				log_misc("Unknown value for setting [name] in [filename].")
			value = text2num(value)

			switch(name)
				if("health_threshold_crit")
					config.health_threshold_crit = value
				if("health_threshold_softcrit")
					config.health_threshold_softcrit = value
				if("health_threshold_dead")
					config.health_threshold_dead = value
				if("show_human_death_message")
					config.show_human_death_message = 1
				if("revival_pod_plants")
					config.revival_pod_plants = value
				if("revival_cloning")
					config.revival_cloning = value
				if("revival_brain_life")
					config.revival_brain_life = value
				if("organ_health_multiplier")
					config.organ_health_multiplier = value / 100
				if("organ_regeneration_multiplier")
					config.organ_regeneration_multiplier = value / 100
				if("organ_damage_spillover_multiplier")
					config.organ_damage_spillover_multiplier = value / 100
				if("organs_can_decay")
					config.organs_decay = 1
				if("default_brain_health")
					config.default_brain_health = text2num(value)
					if(!config.default_brain_health || config.default_brain_health < 1)
						config.default_brain_health = initial(config.default_brain_health)
				if("bones_can_break")
					config.bones_can_break = value
				if("limbs_can_break")
					config.limbs_can_break = value
				if("allow_headgibs")
					config.allow_headgibs = TRUE

				if("run_speed")
					config.run_speed = value
				if("walk_speed")
					config.walk_speed = value

				if("human_delay")
					config.human_delay = value
				if("robot_delay")
					config.robot_delay = value
				if("monkey_delay")
					config.monkey_delay = value
				if("alien_delay")
					config.alien_delay = value
				if("slime_delay")
					config.slime_delay = value
				if("animal_delay")
					config.animal_delay = value

				if("footstep_volume")
					config.footstep_volume = text2num(value)

				if("use_loyalty_implants")
					config.use_loyalty_implants = 1

				if("loadout_whitelist")
					config.loadout_whitelist = text2num(value)

				else
					log_misc("Unknown setting in configuration: '[name]'")

/datum/configuration/proc/loadsql(filename)  // -- TLE
	var/list/Lines = file2list(filename)
	for(var/t in Lines)
		if(!t)	continue

		t = trim(t)
		if (length(t) == 0)
			continue
		else if (copytext(t, 1, 2) == "#")
			continue

		var/pos = findtext(t, " ")
		var/name = null
		var/value = null

		if (pos)
			name = lowertext(copytext(t, 1, pos))
			value = copytext(t, pos + 1)
		else
			name = lowertext(t)

		if (!name)
			continue

		switch (name)
			if ("address")
				sqladdress = value
			if ("port")
				sqlport = value
			if ("database")
				sqldb = value
			if ("login")
				sqllogin = value
			if ("password")
				sqlpass = value
			if ("feedback_database")
				sqlfdbkdb = value
			if ("feedback_login")
				sqlfdbklogin = value
			if ("feedback_password")
				sqlfdbkpass = value
			if ("enable_stat_tracking")
				sqllogging = 1
			else
				log_misc("Unknown setting in configuration: '[name]'")

/datum/configuration/proc/loadforumsql(filename)  // -- TLE
	var/list/Lines = file2list(filename)
	for(var/t in Lines)
		if(!t)	continue

		t = trim(t)
		if (length(t) == 0)
			continue
		else if (copytext(t, 1, 2) == "#")
			continue

		var/pos = findtext(t, " ")
		var/name = null
		var/value = null

		if (pos)
			name = lowertext(copytext(t, 1, pos))
			value = copytext(t, pos + 1)
		else
			name = lowertext(t)

		if (!name)
			continue

		switch (name)
			if ("address")
				forumsqladdress = value
			if ("port")
				forumsqlport = value
			if ("database")
				forumsqldb = value
			if ("login")
				forumsqllogin = value
			if ("password")
				forumsqlpass = value
			if ("activatedgroup")
				forum_activated_group = value
			if ("authenticatedgroup")
				forum_authenticated_group = value
			else
				log_misc("Unknown setting in configuration: '[name]'")

/datum/configuration/proc/pick_mode(mode_name)
	// I wish I didn't have to instance the game modes in order to look up
	// their information, but it is the only way (at least that I know of).
	for (var/game_mode in gamemode_cache)
		var/datum/game_mode/M = gamemode_cache[game_mode]
		if (M.config_tag && M.config_tag == mode_name)
			return M
	return gamemode_cache["extended"]

/datum/configuration/proc/get_runnable_modes()
	var/list/runnable_modes = list()
	for(var/game_mode in gamemode_cache)
		var/datum/game_mode/M = gamemode_cache[game_mode]
		if(M && M.can_start() && !isnull(config.probabilities[M.config_tag]) && config.probabilities[M.config_tag] > 0)
			runnable_modes |= M
	return runnable_modes

/datum/configuration/proc/post_load()
	//apply a default value to config.python_path, if needed
	if (!config.python_path)
		if(world.system_type == UNIX)
			config.python_path = "/usr/bin/env python2"
		else //probably windows, if not this should work anyway
			config.python_path = "python"
