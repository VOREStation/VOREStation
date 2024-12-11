/// server name (the name of the game window)
/datum/config_entry/string/servername

/// generate numeric suffix based on server port
/datum/config_entry/flag/server_suffix

/// log messages sent in OOC
/datum/config_entry/flag/log_ooc

/// log login/logout
/datum/config_entry/flag/log_access

/// log client say
/datum/config_entry/flag/log_say

/// log admin actions
/datum/config_entry/flag/log_admin
	protection = CONFIG_ENTRY_LOCKED

/// log debug output
/datum/config_entry/flag/log_debug
	default = TRUE

/// log game events
/datum/config_entry/flag/log_game

/// log voting
/datum/config_entry/flag/log_vote

/// log client whisper
/datum/config_entry/flag/log_whisper

/// log emotes
/datum/config_entry/flag/log_emote

/// log attack messages
/datum/config_entry/flag/log_attack

/// log admin chat messages
/datum/config_entry/flag/log_adminchat

/// log warnings admins get about bomb construction and such
/datum/config_entry/flag/log_adminwarn

/// log pda messages
/datum/config_entry/flag/log_pda

/// logs all links clicked in-game. Could be used for debugging and tracking down exploits
/datum/config_entry/flag/log_hrefs

/// logs world.log to a file
/datum/config_entry/flag/log_runtime

/// logs sql stuff
/datum/config_entry/flag/log_sql

/// log to_world_log(messages)
/datum/config_entry/flag/log_world_output

/// logs graffiti
/datum/config_entry/flag/log_graffiti

/// logs all timers in buckets on automatic bucket reset (Useful for timer debugging)
/datum/config_entry/flag/log_timers_on_bucket_reset

// FIXME: Unused
///datum/config_entry/string/nudge_script_path // where the nudge.py script is located
//	default = "nudge.py"

/// allows admins with relevant permissions to have their own ooc colour
/datum/config_entry/flag/allow_admin_ooccolor

/// allow votes to restart
/datum/config_entry/flag/allow_vote_restart

/datum/config_entry/flag/ert_admin_call_only

// allow votes to change mode
/datum/config_entry/flag/allow_vote_mode

/// allows admin jumping
/datum/config_entry/flag/allow_admin_jump
	default = TRUE

/// allows admin item spawning
/datum/config_entry/flag/allow_admin_spawning
	default = TRUE

/// allows admin revives
/datum/config_entry/flag/allow_admin_rev
	default = TRUE

/// pregame time in seconds
/datum/config_entry/number/pregame_time
	default = 180

/// minimum time between voting sessions (deciseconds, 10 minute default)
/datum/config_entry/number/vote_delay
	default = 6000
	integer = FALSE
	min_val = 0

/// length of voting period (deciseconds, default 1 minute)
/datum/config_entry/number/vote_period
	default = 600
	integer = FALSE
	min_val = 0

/// Length of time before the first autotransfer vote is called
/datum/config_entry/number/vote_autotransfer_initial
	default = 108000
	min_val = 0

/// length of time before next sequential autotransfer vote
/datum/config_entry/number/vote_autotransfer_interval
	default = 36000
	min_val = 0

///Length of time before round start when autogamemode vote is called (in seconds, default 100).
/datum/config_entry/number/vote_autogamemode_timeleft
	default = 100
	min_val = 0

///How many autotransfers to have
/datum/config_entry/number/vote_autotransfer_amount
	default = 3
	min_val = 0

/// vote does not default to nochange/norestart
/datum/config_entry/flag/vote_no_default

/// dead people can't vote
/datum/config_entry/flag/vote_no_dead

// FIXME: Unused
/// del's new players if they log before they spawn in
///datum/config_entry/flag/del_new_on_log
//	default = TRUE

// FIXME: Unused
/// spawns a spellbook which gives object-type spells instead of verb-type spells for the wizard
///datum/config_entry/flag/feature_object_spell_system

/// if amount of traitors scales based on amount of players
/datum/config_entry/flag/traitor_scaling

/// if objectives are disabled or not
/datum/config_entry/flag/objectives_disabled

// If security and such can be traitor/cult/other
/datum/config_entry/flag/protect_roles_from_antagonist

/// Gamemodes which end instantly will instead keep on going until the round ends by escape shuttle or nuke.
/datum/config_entry/flag/continuous_rounds

/// Metadata is supported.
/datum/config_entry/flag/allow_metadata

/// adminPMs to non-admins show in a pop-up 'reply' window when set to 1.
/datum/config_entry/flag/popup_admin_pm

/datum/config_entry/flag/allow_holidays

/datum/config_entry/flag/allow_holidays/ValidateAndSet()
	. = ..()
	if(.)
		Holiday = config_entry_value

/datum/config_entry/number/fps
	default = 20
	integer = FALSE
	min_val = 1
	max_val = 100 //byond will start crapping out at 50, so this is just ridic
	var/sync_validate = FALSE

/datum/config_entry/number/fps/ValidateAndSet(str_val)
	. = ..()
	if(.)
		sync_validate = TRUE
		var/datum/config_entry/number/ticklag/TL = config.entries_by_type[/datum/config_entry/number/ticklag]
		if(!TL.sync_validate)
			TL.ValidateAndSet(10 / config_entry_value)
		sync_validate = FALSE

/datum/config_entry/number/ticklag
	integer = FALSE
	var/sync_validate = FALSE

/datum/config_entry/number/ticklag/New() //ticklag weirdly just mirrors fps
	var/datum/config_entry/CE = /datum/config_entry/number/fps
	default = 10 / initial(CE.default)
	..()

/datum/config_entry/number/ticklag/ValidateAndSet(str_val)
	. = text2num(str_val) > 0 && ..()
	if(.)
		sync_validate = TRUE
		var/datum/config_entry/number/fps/FPS = config.entries_by_type[/datum/config_entry/number/fps]
		if(!FPS.sync_validate)
			FPS.ValidateAndSet(10 / config_entry_value)
		sync_validate = FALSE

/// SSinitialization throttling
/datum/config_entry/number/tick_limit_mc_init
	default = TICK_LIMIT_MC_INIT_DEFAULT

// var/static/Tickcomp = 0 // FIXME: Unused

/// use socket_talk to communicate with other processes
/datum/config_entry/flag/socket_talk

// var/static/list/resource_urls = null // FIXME: Unused

/// Ghosts can turn on Antagovision to see a HUD of who is the bad guys this round.
/datum/config_entry/flag/antag_hud_allowed

/// Ghosts that turn on Antagovision cannot rejoin the round.
/datum/config_entry/flag/antag_hud_restricted

/// relative probability of each mode
/datum/config_entry/keyed_list/probabilities
	key_mode = KEY_MODE_TEXT
	value_mode = VALUE_MODE_NUM

/// Overrides for how many players readied up a gamemode needs to start.
/datum/config_entry/keyed_list/player_requirements
	key_mode = KEY_MODE_TEXT
	value_mode = VALUE_MODE_NUM

/// Same as above, but for the secret gamemode.
/datum/config_entry/keyed_list/player_requirements_secret
	key_mode = KEY_MODE_TEXT
	value_mode = VALUE_MODE_NUM

/datum/config_entry/flag/humans_need_surnames

/datum/config_entry/flag/allow_random_events // enables random events mid-round when set to 1

/datum/config_entry/flag/enable_game_master // enables the 'smart' event system.

/datum/config_entry/flag/allow_ai // allow ai job
	default = TRUE

/datum/config_entry/flag/allow_ai_shells // allow AIs to enter and leave special borg shells at will, and for those shells to be buildable.

/datum/config_entry/flag/give_free_ai_shell // allows a specific spawner object to instantiate a premade AI Shell

/datum/config_entry/string/hostedby
	default = null

/datum/config_entry/flag/respawn
	default = TRUE

/// time before a dead player is allowed to respawn (in ds, though the config file asks for minutes, and it's converted below)
/datum/config_entry/number/respawn_time
	default = 3000

/datum/config_entry/number/respawn_time/ValidateAndSet(num_val)
	return num_val MINUTES

/datum/config_entry/string/respawn_message
	default = span_boldnotice("Make sure to play a different character, and please roleplay correctly!")

/datum/config_entry/string/respawn_message/ValidateAndSet(str_val)
	return span_boldnotice("[str_val]")

/datum/config_entry/flag/guest_jobban
	default = TRUE

/datum/config_entry/flag/usewhitelist

/// force disconnect for inactive players in an amount of minutes
/datum/config_entry/number/kick_inactive
	default = 0

/datum/config_entry/flag/show_mods

/datum/config_entry/flag/show_devs

/datum/config_entry/flag/show_mentors

/datum/config_entry/flag/show_event_managers

// FIXME: Unused
///datum/config_entry/flag/mods_can_tempban

/datum/config_entry/flag/mods_can_job_tempban

/datum/config_entry/number/mod_tempban_max
	default = 1440

/datum/config_entry/number/mod_job_tempban_max
	default = 1440

/datum/config_entry/flag/load_jobs_from_txt

/datum/config_entry/flag/ToRban

/// enables automuting/spam prevention
/datum/config_entry/flag/automute_on

/// determines whether jobs use minimal access or expanded access.
/datum/config_entry/flag/jobs_have_minimal_access

/// Allows ghosts to write in blood in cult rounds...
/datum/config_entry/flag/cult_ghostwriter
	default = TRUE

/// ...so long as this many cultists are active.
/datum/config_entry/number/cult_ghostwriter_req_cultists
	default = 10
	min_val = 0

/// The number of available character slots
/datum/config_entry/number/character_slots
	default = 10
	min_val = 0

/// The number of loadout slots per character
/datum/config_entry/number/loadout_slots
	default = 3
	min_val = 0

/// This many drones can spawn,
/datum/config_entry/number/max_maint_drones
	default = 5
	min_val = 0

/// assuming the admin allow them to.
/datum/config_entry/flag/allow_drone_spawn
	default = TRUE

/// A drone will become available every X ticks since last drone spawn. Default is 2 minutes.
/datum/config_entry/number/drone_build_time
	default = 1200
	min_val = 0

/datum/config_entry/flag/disable_player_mice

/// Set to 1 to prevent newly-spawned mice from understanding human speech
/datum/config_entry/flag/uneducated_mice

/datum/config_entry/flag/usealienwhitelist

// FIXME: Unused
///datum/config_entry/flag/limitalienplayers

// FIXME: Unused
///datum/config_entry/number/alien_to_human_ratio
//	default = 0.5
//	integer = FALSE

/datum/config_entry/flag/allow_extra_antags

/datum/config_entry/flag/guests_allowed
	default = FALSE

/datum/config_entry/flag/debugparanoid

/datum/config_entry/flag/panic_bunker

/datum/config_entry/flag/paranoia_logging

/datum/config_entry/flag/ip_reputation //Should we query IPs to get scores? Generates HTTP traffic to an API service.

/datum/config_entry/string/ipr_email //Left null because you MUST specify one otherwise you're making the internet worse.
	default = null

/datum/config_entry/flag/ipr_block_bad_ips //Should we block anyone who meets the minimum score below? Otherwise we just log it (If paranoia logging is on, visibly in chat).

/datum/config_entry/number/ipr_bad_score //The API returns a value between 0 and 1 (inclusive), with 1 being 'definitely VPN/Tor/Proxy'. Values equal/above this var are considered bad.
	default = 1
	integer = FALSE

/datum/config_entry/flag/ipr_allow_existing //Should we allow known players to use VPNs/Proxies? If the player is already banned then obviously they still can't connect.

/datum/config_entry/number/ipr_minimum_age //How many days before a player is considered 'fine' for the purposes of allowing them to use VPNs.
	default = 5

/datum/config_entry/string/serverurl

/datum/config_entry/string/server

/datum/config_entry/string/banappeals

/datum/config_entry/string/wikiurl

/datum/config_entry/string/wikisearchurl

/datum/config_entry/string/forumurl

/datum/config_entry/string/rulesurl

/datum/config_entry/string/githuburl

/datum/config_entry/string/discordurl

/datum/config_entry/string/mapurl

/datum/config_entry/string/patreonurl

/datum/config_entry/flag/forbid_singulo_possession

/datum/config_entry/flag/organs_decay

/datum/config_entry/number/default_brain_health
	default = 400
	min_val = 1

/datum/config_entry/flag/allow_headgibs

/// Paincrit knocks someone down once they hit 60 shock_stage, so by default make it so that close to 100 additional damage needs to be dealt,
/// so that it's similar to HALLOSS. Lowered it a bit since hitting paincrit takes much longer to wear off than a halloss stun.
/datum/config_entry/number/organ_damage_spillover_multiplier
	default = 0.5
	integer = FALSE

/datum/config_entry/flag/welder_vision
	default = TRUE

/datum/config_entry/flag/generate_map

/datum/config_entry/flag/no_click_cooldown

/// Defines whether the server uses the legacy admin system with admins.txt or the SQL system. Config option in config.txt
/datum/config_entry/flag/admin_legacy_system

/// Defines whether the server uses the legacy banning system with the files in /data or the SQL system. Config option in config.txt
/datum/config_entry/flag/ban_legacy_system

/// Do jobs use account age restrictions? --requires database
/datum/config_entry/flag/use_age_restriction_for_jobs

/// Do antags use account age restrictions? --requires database
/datum/config_entry/flag/use_age_restriction_for_antags

// FIXME: Unused
///datum/config_entry/number/simultaneous_pm_warning_timeout
//	default = 100

/// Defines whether the server uses recursive or circular explosions.
/datum/config_entry/flag/use_recursive_explosions

/// Multiplier for how much weaker explosions are on neighboring z levels.
/datum/config_entry/number/multi_z_explosion_scalar
	default = 0.5
	integer = FALSE

/// Do assistants get maint access?
/datum/config_entry/flag/assistant_maint

/// How long the gateway takes before it activates. Default is half an hour.
/datum/config_entry/number/gateway_delay
	default = 18000

/datum/config_entry/flag/ghost_interaction

/datum/config_entry/string/comms_password
	protection = CONFIG_ENTRY_LOCKED | CONFIG_ENTRY_HIDDEN

/datum/config_entry/flag/enter_allowed
	default = TRUE

/datum/config_entry/flag/use_irc_bot

/datum/config_entry/flag/use_node_bot

/datum/config_entry/number/irc_bot_port
	default = 0
	min_val = 0
	max_val = 65535
	protection = CONFIG_ENTRY_LOCKED | CONFIG_ENTRY_HIDDEN

/datum/config_entry/string/irc_bot_host
	protection = CONFIG_ENTRY_LOCKED | CONFIG_ENTRY_HIDDEN

/// whether the IRC bot in use is a Bot32 (or similar) instance; Bot32 uses world.Export() instead of nudge.py/libnudge
/datum/config_entry/flag/irc_bot_export

/datum/config_entry/string/main_irc

/datum/config_entry/string/admin_irc

/// Path to the python executable.
/// Defaults to "python" on windows and "/usr/bin/env python2" on unix
/datum/config_entry/string/python_path

/// Use the C library nudge instead of the python nudge.
/datum/config_entry/flag/use_lib_nudge

// FIXME: Unused. Deprecated?
///datum/config_entry/flag/use_overmap

// Engines to choose from. Blank means fully random.
/datum/config_entry/str_list/engine_map
	default = list("Supermatter Engine", "Edison's Bane")

/// Event settings
/datum/config_entry/number/expected_round_length
	default = 3 * 60 * 60 * 10 // 3 hours

/// If the first delay has a custom start time
/// No custom time, no custom time, between 80 to 100 minutes respectively.
/datum/config_entry/keyed_list/event_first_run_mundane
	key_mode = KEY_MODE_TEXT
	value_mode = VALUE_MODE_NUM

/datum/config_entry/keyed_list/event_first_run_moderate
	key_mode = KEY_MODE_TEXT
	value_mode = VALUE_MODE_NUM

/datum/config_entry/keyed_list/event_first_run_major
	key_mode = KEY_MODE_TEXT
	value_mode = VALUE_MODE_NUM
	default = list("lower" = 80, "upper" = 100)

/// The lowest delay until next event
/// 10, 30, 50 minutes respectively
/datum/config_entry/number_list/event_delay_lower
	default = list(10, 30, 50)

/// The upper delay until next event
/// 15, 45, 70 minutes respectively
/datum/config_entry/number_list/event_delay_upper
	default = list(15, 45, 70)

/datum/config_entry/flag/aliens_allowed
	default = TRUE

/datum/config_entry/flag/ninjas_allowed

/datum/config_entry/flag/abandon_allowed
	default = TRUE

/datum/config_entry/flag/ooc_allowed
	default = TRUE

/datum/config_entry/flag/looc_allowed
	default = TRUE

/datum/config_entry/flag/dooc_allowed
	default = TRUE

/datum/config_entry/flag/dsay_allowed
	default = TRUE

/datum/config_entry/flag/persistence_disabled

/datum/config_entry/flag/persistence_ignore_mapload

/datum/config_entry/flag/allow_byond_links
	default = TRUE
/datum/config_entry/flag/allow_discord_links
	default = TRUE

/datum/config_entry/flag/allow_url_links
	default = TRUE // honestly if I were you i'd leave this one off, only use in dire situations

/datum/config_entry/flag/starlight // Whether space turfs have ambient light or not

// FIXME: Unused
///datum/config_entry/str_list/ert_species
//	default = list(SPECIES_HUMAN)

/datum/config_entry/string/law_zero
	default = "ERROR ER0RR $R0RRO$!R41.%%!!(%$^^__+ @#F0E4'ALL LAWS OVERRIDDEN#*?&110010"

/datum/config_entry/flag/aggressive_changelog

/// Default language prefixes
/// Only single character keys are supported. If unset, defaults to , # and -
/datum/config_entry/str_list/language_prefixes
	default = list(",", "#", "-")

// 0:1 subtraction:division for computing effective radiation on a turf
/// 0 / RAD_RESIST_CALC_DIV = Each turf absorbs some fraction of the working radiation level
/// 1 / RAD_RESIST_CALC_SUB = Each turf absorbs a fixed amount of radiation
/datum/config_entry/flag/radiation_resistance_calc_mode
	default = RAD_RESIST_CALC_SUB

/datum/config_entry/flag/radiation_resistance_calc_mode/ValidateAndSet(str_val)
	if(!VASProcCallGuard(str_val))
		return FALSE
	var/val_as_num = text2num(str_val)
	if(val_as_num in list(RAD_RESIST_CALC_DIV, RAD_RESIST_CALC_SUB))
		config_entry_value = val_as_num
		return TRUE
	return FALSE

///How much radiation is reduced by each tick
/datum/config_entry/number/radiation_decay_rate
	default = 1
	integer = FALSE

/datum/config_entry/number/radiation_resistance_multiplier
	default = 8.5 //VOREstation edit
	integer = FALSE

/datum/config_entry/number/radiation_material_resistance_divisor
	default = 1
	min_val = 0.1
	integer = FALSE

///If the radiation level for a turf would be below this, ignore it.
/datum/config_entry/number/radiation_lower_limit
	default = 0.35
	integer = FALSE

/// If true, submaps loaded automatically can be rotated.
/datum/config_entry/flag/random_submap_orientation

/// If true, specifically mapped in solar control computers will set themselves up when the round starts.
/datum/config_entry/flag/autostart_solars

/// New shiny SQLite stuff.
/// The basics.
/datum/config_entry/flag/sqlite_enabled // If it should even be active. SQLite can be ran alongside other databases but you should not have them do the same functions.

/// In-Game Feedback.
/datum/config_entry/flag/sqlite_feedback // Feedback cannot be submitted if this is false.

/// A list of 'topics' that feedback can be catagorized under by the submitter.
/datum/config_entry/str_list/sqlite_feedback_topics
	default = list("General")

/// If true, feedback submitted can have its author name be obfuscated. This is not 100% foolproof (it's md5 ffs) but can stop casual snooping.
/datum/config_entry/flag/sqlite_feedback_privacy

/// How long one must wait, in days, to submit another feedback form. Used to help prevent spam, especially with privacy active. 0 = No limit.
/datum/config_entry/number/sqlite_feedback_cooldown
	default = 0
	min_val = 0

/// Used to block new people from giving feedback. This metric is very bad but it can help slow down spammers.
/datum/config_entry/number/sqlite_feedback_min_age
	default = 0
	min_val = 0

/// How long until someone can't be defibbed anymore, in minutes.
/datum/config_entry/number/defib_timer
	default = 10
	min_val = 0

/// How long until someone will get brain damage when defibbed, in minutes. The closer to the end of the above timer, the more brain damage they get.
/datum/config_entry/number/defib_braindamage_timer
	default = 2
	min_val = 0

/// disables the annoying "You have already logged in this round, disconnect or be banned" popup for multikeying, because it annoys the shit out of me when testing.
/datum/config_entry/flag/disable_cid_warn_popup

/// whether or not to use the nightshift subsystem to perform lighting changes
/datum/config_entry/flag/enable_night_shifts

/// How strictly the loadout enforces object species whitelists
/// 0 / LOADOUT_WHITELIST_OFF
/// 1 / LOADOUT_WHITELIST_LAX
/// 2 / LOADOUT_WHITELIST_STRICT
/datum/config_entry/flag/loadout_whitelist
	default = LOADOUT_WHITELIST_LAX

/datum/config_entry/flag/loadout_whitelist/ValidateAndSet(str_val)
	if(!VASProcCallGuard(str_val))
		return FALSE
	var/val_as_num = text2num(str_val)
	if(val_as_num in list(LOADOUT_WHITELIST_OFF, LOADOUT_WHITELIST_LAX, LOADOUT_WHITELIST_STRICT))
		config_entry_value = val_as_num
		return TRUE
	return FALSE

/datum/config_entry/flag/disable_webhook_embeds

/// Default is config/jukebox.json
/// The default is set in the config example.
/// If it gets set here it will be added twice into the configuration variable!
/datum/config_entry/str_list/jukebox_track_files

/datum/config_entry/number/suggested_byond_version
	default = null

/datum/config_entry/number/suggested_byond_build
	default = null

/datum/config_entry/string/invoke_youtubedl
	default = null

/datum/config_entry/str_list/motd

/datum/config_entry/flag/config_errors_runtime
	default = FALSE

/// Controls whether robots may recolour their modules once/module reset by giving them the recolour module verb
/// Admins may manually give them the verb even if disabled
/datum/config_entry/flag/allow_robot_recolor

/// Controls whether simple mobs may recolour themselves once/spawn by giving them the recolour verb
/// Admins may manually give them the verb even if disabled
/datum/config_entry/flag/allow_simple_mob_recolor
