/**
 * Client datum
 *
 * A datum that is created whenever a user joins a BYOND world, one will exist for every active connected
 * player
 *
 * when they first connect, this client object is created and [/client/New] is called
 *
 * When they disconnect, this client object is deleted and [/client/Del] is called
 *
 * All client topic calls go through [/client/Topic] first, so a lot of our specialised
 * topic handling starts here
 */
/client
	/**
	 * This line makes clients parent type be a datum
	 *
	 * By default in byond if you define a proc on datums, that proc will exist on nearly every single type
	 * from icons to images to atoms to mobs to objs to turfs to areas, it won't however, appear on client
	 *
	 * instead by default they act like their own independent type so while you can do isdatum(icon)
	 * and have it return true, you can't do isdatum(client), it will always return false.
	 *
	 * This makes writing oo code hard, when you have to consider this extra special case
	 *
	 * This line prevents that, and has never appeared to cause any ill effects, while saving us an extra
	 * pain to think about
	 *
	 * This line is widely considered black fucking magic, and the fact it works is a puzzle to everyone
	 * involved, including the current engine developer, lummox
	 *
	 * If you are a future developer and the engine source is now available and you can explain why this
	 * is the way it is, please do update this comment
	 */
	parent_type = /datum
		////////////////
		//ADMIN THINGS//
		////////////////
	/// hides the byond verb panel as we use our own custom version
	show_verb_panel = FALSE
	///Contains admin info. Null if client is not an admin.
	var/datum/admins/holder = null
	///Needs to implement InterceptClickOn(user,params,atom) proc
	var/datum/click_intercept = null
	///Time when the click was intercepted
	var/click_intercept_time = 0


	var/buildmode		= 0

	///Contains the last message sent by this client - used to protect against copy-paste spamming.
	var/last_message	= ""
	///contins a number of how many times a message identical to last_message was sent.
	var/last_message_count = 0
	var/ircreplyamount = 0
	var/entity_narrate_holder //Holds /datum/entity_narrate when using the relevant admin verbs.
	var/fakeConversations //Holds fake PDA conversations for event set-up

		/////////
		//OTHER//
		/////////
	///Player preferences datum for the client
	var/datum/preferences/prefs = null
	///Move delay of controlled mob, any keypresses inside this period will persist until the next proper move
	var/move_delay = 0
	///The visual delay to use for the current client.Move(), mostly used for making a client based move look like it came from some other slower source
	var/visual_delay = 0
	var/adminobs		= null
	var/area			= null
	var/time_died_as_mouse = null //when the client last died as a mouse
	var/datum/tooltip/tooltips 	= null
	var/datum/volume_panel/volume_panel = null // Initialized by /client/verb/volume_panel()
	var/seen_news = 0

	var/adminhelped = 0

		///////////////
		//SOUND STUFF//
		///////////////
	var/time_last_ambience_played = 0 // world.time when ambience was played to this client, to space out ambience sounds.

		////////////
		//SECURITY//
		////////////
	// comment out the line below when debugging locally to enable the options & messages menu
	//control_freak = 1

	var/received_irc_pm = -99999
	var/irc_admin			//IRC admin that spoke with them last.
	var/mute_irc = 0
	var/ip_reputation = 0 //Do we think they're using a proxy/vpn? Only if IP Reputation checking is enabled in config.

	///Used for limiting the rate of topic sends by the client to avoid abuse
	var/list/topiclimiter
	///Used for limiting the rate of clicks sends by the client to avoid abuse
	var/list/clicklimiter

	///these persist between logins/logouts during the same round.
	var/datum/persistent_client/persistent_client

	///Amount of keydowns in the last keysend checking interval
	var/client_keysend_amount = 0
	///World tick time where client_keysend_amount will reset
	var/next_keysend_reset = 0
	///World tick time where keysend_tripped will reset back to false
	var/next_keysend_trip_reset = 0
	///When set to true, user will be autokicked if they trip the keysends in a second limit again
	var/keysend_tripped = FALSE
	///custom movement keys for this client
	var/list/movement_keys = list()

	///Autoclick list of two elements, first being the clicked thing, second being the parameters.
	var/list/atom/selected_target[2]

		////////////////////////////////////
		//things that require the database//
		////////////////////////////////////
	var/player_age = "(Requires database)"	//So admins know why it isn't working - Used to determine how old the account is - in days.
	var/related_accounts_ip = "(Requires database)"	//So admins know why it isn't working - Used to determine what other accounts previously logged in from this ip
	var/related_accounts_cid = "(Requires database)"	//So admins know why it isn't working - Used to determine what other accounts previously logged in from this computer id
	var/account_join_date = "(Requires database)"
	var/account_age = "(Requires database)"
	var/list/department_hours = list()	// VOREStation Edit - Track hours of leave accured for each department.
	var/list/play_hours	= list() // VOREStation Edit - Tracks total playtime hours for each departments.

	preload_rsc = PRELOAD_RSC

	var/global/atom/movable/screen/click_catcher/void

	///used to make a special mouse cursor, this one for mouse up icon
	var/mouse_up_icon = null
	///used to make a special mouse cursor, this one for mouse up icon
	var/mouse_down_icon = null
	///used to override the mouse cursor so it doesnt get reset
	var/mouse_override_icon = null

	// List of all asset filenames sent to this client by the asset cache, along with their assoicated md5s
	var/list/sent_assets = list()
	/// List of all completed blocking send jobs awaiting acknowledgement by send_asset
	var/list/completed_asset_jobs = list()
	/// Last asset send job id.
	var/last_asset_job = 0
	var/last_completed_asset_job = 0

	///Last ping of the client
	var/lastping = 0
	///Average ping of the client
	var/avgping = 0

	///world.time they connected
	var/connection_time
	///world.realtime they connected
	var/connection_realtime
	///world.timeofday they connected
	var/connection_timeofday

	// Runechat messages
	var/list/seen_messages
	/// our current tab
	var/stat_tab

	///this is the last recorded client eye by SSparallax/fire()
	var/atom/movable/movingmob

	/// list of all tabs
	var/list/panel_tabs = list()
	/// list of tabs containing spells and abilities
	var/list/spell_tabs = list()
	/// list of misc tabs from mob
	var/list/misc_tabs = list()
	///A lazy list of atoms we've examined in the last RECENT_EXAMINE_MAX_WINDOW (default 2) seconds, so that we will call [/atom/proc/examine_more] instead of [/atom/proc/examine] on them when examining
	var/list/recent_examines
	///Our object window datum. It stores info about and handles behavior for the object tab
	var/datum/object_window_info/obj_window

	var/list/misc_cache = list()

	var/atom/examine_icon //Holder for examine icon, useful for statpanel

	//Hide top bars
	var/fullscreen = FALSE
	//Hide status bar
	var/show_status_bar = TRUE

		///////////
		// INPUT //
		///////////

	/// A buffer of currently held keys.
	var/list/keys_held = list()
	/// A buffer for combinations such of modifiers + keys (ex: CtrlD, AltE, ShiftT). Format: `"key"` -> `"combo"` (ex: `"D"` -> `"CtrlD"`)
	var/list/key_combos_held = list()
	/// The direction we WANT to move, based off our keybinds
	/// Will be udpated to be the actual direction later on
	var/intended_direction = NONE
	/*
	** These next two vars are to apply movement for keypresses and releases made while move delayed.
	** Because discarding that input makes the game less responsive.
	*/
	/// On next move, add this dir to the move that would otherwise be done
	var/next_move_dir_add
	/// On next move, subtract this dir from the move that would otherwise be done
	var/next_move_dir_sub

	/// Whether or not this client has standard hotkeys enabled
	var/hotkeys = TRUE

	#ifdef CARDINAL_INPUT_ONLY

	/// Movement dir of the most recently pressed movement key.  Used in GLOB.cardinal-only movement mode.
	var/last_move_dir_pressed = NONE

	#endif

	/// If this client has been fully initialized or not
	var/fully_created = FALSE

	/// Token used for the external chatlog api. Only valid for the current round.
	var/chatlog_token

	/// The DPI scale of the client. 1 is equivalent to 100% window scaling, 2 will be 200% window scaling
	var/window_scaling

	/// Loot panel for the client
	var/datum/lootpanel/loot_panel

	///Are we locking our movement input?
	var/movement_locked = FALSE
