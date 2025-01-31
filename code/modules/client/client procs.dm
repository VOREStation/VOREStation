	////////////
	//SECURITY//
	////////////
#define UPLOAD_LIMIT		10485760	//Restricts client uploads to the server to 10MB //Boosted this thing. What's the worst that can happen?
#define MIN_CLIENT_VERSION	0		//Just an ambiguously low version for now, I don't want to suddenly stop people playing.
									//I would just like the code ready should it ever need to be used.
#define LIMITER_SIZE 12
#define CURRENT_SECOND 1
#define SECOND_COUNT 2
#define CURRENT_MINUTE 3
#define MINUTE_COUNT 4
#define ADMINSWARNED_AT 5

//# define TOPIC_DEBUGGING 1

/client/proc/reduce_minute_count()
	if (!topiclimiter)
		topiclimiter = new(LIMITER_SIZE)
	if(topiclimiter[MINUTE_COUNT] > 0)
		topiclimiter[MINUTE_COUNT] -= 1

	/*
	When somebody clicks a link in game, this Topic is called first.
	It does the stuff in this proc and  then is redirected to the Topic() proc for the src=[0xWhatever]
	(if specified in the link). ie locate(hsrc).Topic()

	Such links can be spoofed.

	Because of this certain things MUST be considered whenever adding a Topic() for something:
		- Can it be fed harmful values which could cause runtimes?
		- Is the Topic call an admin-only thing?
		- If so, does it have checks to see if the person who called it (usr.client) is an admin?
		- Are the processes being called by Topic() particularly laggy?
		- If so, is there any protection against somebody spam-clicking a link?
	If you have any  questions about this stuff feel free to ask. ~Carn
	*/
/client/Topic(href, href_list, hsrc)
	if(!usr || usr != mob)	//stops us calling Topic for somebody else's client. Also helps prevent usr=null
		return

	#if defined(TOPIC_DEBUGGING)
	to_world("[src]'s Topic: [href] destined for [hsrc].")

	if(href_list["nano_err"]) //nano throwing errors
		to_world("## NanoUI, Subject [src]: " + html_decode(href_list["nano_err")]) //NANO DEBUG HOOK

	#endif

	// asset_cache
	var/asset_cache_job
	if(href_list["asset_cache_confirm_arrival"])
		asset_cache_job = asset_cache_confirm_arrival(href_list["asset_cache_confirm_arrival"])
		if (!asset_cache_job)
			return

	// Rate limiting
	var/mtl = CONFIG_GET(number/minute_topic_limit)
	if (!holder && mtl)
		var/minute = round(world.time, 600)
		if (!topiclimiter)
			topiclimiter = new(LIMITER_SIZE)
		if (minute != topiclimiter[CURRENT_MINUTE])
			topiclimiter[CURRENT_MINUTE] = minute
			topiclimiter[MINUTE_COUNT] = 0
		topiclimiter[MINUTE_COUNT] += 1
		if (topiclimiter[MINUTE_COUNT] > mtl)
			var/msg = "Your previous action was ignored because you've done too many in a minute."
			if (minute != topiclimiter[ADMINSWARNED_AT]) //only one admin message per-minute. (if they spam the admins can just boot/ban them)
				topiclimiter[ADMINSWARNED_AT] = minute
				msg += " Administrators have been informed."
				log_and_message_admins("[key_name(src)] Has hit the per-minute topic limit of [mtl] topic calls in a given game minute", src)
			to_chat(src, span_danger("[msg]"))
			return

	var/stl = CONFIG_GET(number/second_topic_limit)
	if (!holder && stl && href_list["window_id"] != "statbrowser")
		var/second = round(world.time, 10)
		if (!topiclimiter)
			topiclimiter = new(LIMITER_SIZE)
		if (second != topiclimiter[CURRENT_SECOND])
			topiclimiter[CURRENT_SECOND] = second
			topiclimiter[SECOND_COUNT] = 0
		topiclimiter[SECOND_COUNT] += 1
		if (topiclimiter[SECOND_COUNT] > stl)
			to_chat(src, span_danger("Your previous action was ignored because you've done too many in a second"))
			return

	//search the href for script injection
	if( findtext(href,"<script",1,0) )
		to_world_log("Attempted use of scripts within a topic call, by [src]")
		message_admins("Attempted use of scripts within a topic call, by [src]")
		return

	// Tgui Topic middleware
	if(!tgui_Topic(href_list))
		return

	//Admin PM
	if(href_list["priv_msg"])
		var/client/C = locate(href_list["priv_msg"])
		if(ismob(C)) 		//Old stuff can feed-in mobs instead ofGLOB.clients
			var/mob/M = C
			C = M.client
		cmd_admin_pm(C,null)
		return

	if(href_list["mentorhelp_msg"])
		var/client/C = locate(href_list["mentorhelp_msg"])
		if(ismob(C))
			var/mob/M = C
			C = M.client
		cmd_mentor_pm(C, null)
		return

	if(href_list["irc_msg"])
		if(!holder && received_irc_pm < world.time - 6000) //Worse they can do is spam IRC for 10 minutes
			to_chat(src, span_warning("You are no longer able to use this, it's been more than 10 minutes since an admin on IRC has responded to you"))
			return
		if(mute_irc)
			to_chat(usr, span_warning("You cannot use this as your client has been muted from sending messages to the admins on IRC"))
			return
		send2adminirc(href_list["irc_msg"])
		return

	//VOREStation Add
	if(href_list["discord_reg"])
		var/their_id = html_decode(href_list["discord_reg"])
		var/sane = FALSE
		for(var/list/L as anything in GLOB.pending_discord_registrations)
			if(!islist(L))
				GLOB.pending_discord_registrations -= L
				continue
			if(L["ckey"] == ckey && L["id"] == their_id)
				GLOB.pending_discord_registrations -= list(L)
				var/time = L["time"]
				if((world.realtime - time) > 10 MINUTES)
					to_chat(src, span_warning("Sorry, that link has expired. Please request another on Discord."))
					return
				sane = TRUE
				break

		if(!sane)
			to_chat(src, span_warning("Sorry, that link doesn't appear to be valid. Please try again."))
			return

		var/sql_discord = sql_sanitize_text(their_id)
		var/sql_ckey = sql_sanitize_text(ckey)
		var/datum/db_query/query = SSdbcore.NewQuery("UPDATE erro_player SET discord_id = '[sql_discord]' WHERE ckey = '[sql_ckey]'")
		if(query.Execute())
			to_chat(src, span_notice("Registration complete! Thank you for taking the time to register your Discord ID."))
			log_and_message_admins("[ckey] has registered their Discord ID to obtain the Crew Member role. Their Discord snowflake ID is: [their_id]", src)
			admin_chat_message(message = "[ckey] has registered their Discord ID to obtain the Crew Member role. Their Discord is: <@[their_id]>", color = "#4eff22")
			notes_add(ckey, "Discord ID: [their_id]")
			world.VgsAddMemberRole(their_id)
		else
			to_chat(src, span_warning("There was an error registering your Discord ID in the database. Contact an administrator."))
			log_and_message_admins("[ckey] failed to register their Discord ID. Their Discord snowflake ID is: [their_id]. Is the database connected?", src)
		qdel(query)
		return
	//VOREStation Add End
	if(href_list["reload_statbrowser"])
		stat_panel.reinitialize()

	//Logs all hrefs
	if(config && CONFIG_GET(flag/log_hrefs) && href_logfile)
		WRITE_LOG(href_logfile, "[src] (usr:[usr])</small> || [hsrc ? "[hsrc] " : ""][href]")

	//byond bug ID:2256651
	if (asset_cache_job && (asset_cache_job in completed_asset_jobs))
		to_chat(src, span_danger("An error has been detected in how your client is receiving resources. Attempting to correct.... (If you keep seeing these messages you might want to close byond and reconnect)"))
		src << browse("...", "window=asset_cache_browser")
		return
	if (href_list["asset_cache_preload_data"])
		asset_cache_preload_data(href_list["asset_cache_preload_data"])
		return

	if(href_list["commandbar_typing"])
		handle_commandbar_typing(href_list)

	switch(href_list["_src_"])
		if("holder")	hsrc = holder
		if("mentorholder")	hsrc = (check_rights(R_ADMIN, 0) ? holder : mentorholder)
		if("usr")		hsrc = mob
		if("prefs")		return prefs.process_link(usr,href_list)
		if("vars")		return view_var_Topic(href,href_list,hsrc)

	switch(href_list["action"])
		if("openLink")
			src << link(href_list["link"])

	if (hsrc)
		var/datum/real_src = hsrc
		if(QDELETED(real_src))
			return

	//fun fact: Topic() acts like a verb and is executed at the end of the tick like other verbs. So we have to queue it if the server is
	//overloaded
	if(hsrc && hsrc != holder && DEFAULT_TRY_QUEUE_VERB(VERB_CALLBACK(src, PROC_REF(_Topic), hsrc, href, href_list)))
		return
	..() //redirect to hsrc.Topic()

///dumb workaround because byond doesnt seem to recognize the Topic() typepath for /datum/proc/Topic() from the client Topic,
///so we cant queue it without this
/client/proc/_Topic(datum/hsrc, href, list/href_list)
	return hsrc.Topic(href, href_list)

//This stops files larger than UPLOAD_LIMIT being sent from client to server via input(), client.Import() etc.
/client/AllowUpload(filename, filelength)
	if(filelength > UPLOAD_LIMIT)
		to_chat(src, span_red("Error: AllowUpload(): File Upload too large. Upload Limit: [UPLOAD_LIMIT/1024]KiB."))
		return 0
/*	//Don't need this at the moment. But it's here if it's needed later.
	//Helps prevent multiple files being uploaded at once. Or right after eachother.
	var/time_to_wait = fileaccess_timer - world.time
	if(time_to_wait > 0)
		to_chat(src, "<font color='red'>Error: AllowUpload(): Spam prevention. Please wait [round(time_to_wait/10)] seconds.</font>")
		return 0
	fileaccess_timer = world.time + FTPDELAY	*/
	return 1


	///////////
	//CONNECT//
	///////////
/client/New(TopicData)
	// TODO: Remove version check with 516
	if(byond_version >= 516) // Enable 516 compat browser storage mechanisms
		winset(src, null, "browser-options=[DEFAULT_CLIENT_BROWSER_OPTIONS]")

	TopicData = null							//Prevent calls to client.Topic from connect

	if(!(connection in list("seeker", "web")))					//Invalid connection type.
		return null
	if(byond_version < MIN_CLIENT_VERSION)		//Out of date client.
		return null

	if(!CONFIG_GET(flag/guests_allowed) && IsGuestKey(key))
		alert(src,"This server doesn't allow guest accounts to play. Please go to https://www.byond.com/ and register for a key.","Guest") // Not tgui_alert
		del(src)
		return

	//Only show this if they are put into a new_player mob. Otherwise, "what title screen?"
	if(isnewplayer(src.mob))
		to_chat(src, span_red("If the title screen is black, resources are still downloading. Please be patient until the title screen appears."))

	GLOB.clients += src
	GLOB.directory[ckey] = src

	// Instantiate stat panel
	stat_panel = new(src, "statbrowser")
	stat_panel.subscribe(src, .proc/on_stat_panel_message)

	// Instantiate tgui panel
	tgui_say = new(src, "tgui_say")
	initialize_commandbar_spy()
	tgui_panel = new(src, "browseroutput")

	GLOB.ahelp_tickets.ClientLogin(src)
	GLOB.mhelp_tickets.ClientLogin(src)

	//Admin Authorisation
	holder = admin_datums[ckey]
	if(holder)
		GLOB.admins += src
		holder.owner = src

	mentorholder = mentor_datums[ckey]
	if (mentorholder)
		mentorholder.associate(GLOB.directory[ckey])

	//preferences datum - also holds some persistant data for the client (because we may as well keep these datums to a minimum)
	prefs = preferences_datums[ckey]
	if(prefs)
		prefs.client = src
		prefs.load_savefile() // just to make sure we have the latest data
		prefs.apply_all_client_preferences()
	else
		prefs = new /datum/preferences(src)
		preferences_datums[ckey] = prefs
	prefs.last_ip = address				//these are gonna be used for banning
	prefs.last_id = computer_id			//these are gonna be used for banning

	hook_vr("client_new",list(src)) //VOREStation Code. For now this only loads vore prefs, so better put before mob.Login() call but after normal prefs are loaded.

	. = ..()	//calls mob.Login()
	prefs.sanitize_preferences()
	if(prefs)
		prefs.selecting_slots = FALSE

	// Initialize stat panel
	stat_panel.initialize(
		inline_html = file2text('html/statbrowser.html'),
		inline_js = file2text('html/statbrowser.js'),
		inline_css = file2text('html/statbrowser.css'),
	)
	addtimer(CALLBACK(src, PROC_REF(check_panel_loaded)), 30 SECONDS)

	// Initialize tgui panel
	tgui_say.initialize()
	tgui_panel.initialize()

	connection_time = world.time
	connection_realtime = world.realtime
	connection_timeofday = world.timeofday

	if(custom_event_msg && custom_event_msg != "")
		to_chat(src, "<h1 class='alert'>Custom Event</h1>")
		to_chat(src, "<h2 class='alert'>A custom event is taking place. OOC Info:</h2>")
		to_chat(src, span_alert("[custom_event_msg]"))
		to_chat(src, "<br>")

	if(!winexists(src, "asset_cache_browser")) // The client is using a custom skin, tell them.
		to_chat(src, span_warning("Unable to access asset cache browser, if you are using a custom skin file, please allow DS to download the updated version, if you are not, then make a bug report. This is not a critical issue but can cause issues with resource downloading, as it is impossible to know when extra resources arrived to you."))

	if(holder)
		add_admin_verbs()
		admin_memo_show()

	// Forcibly enable hardware-accelerated graphics, as we need them for the lighting overlays.
	// (but turn them off first, since sometimes BYOND doesn't turn them on properly otherwise)
	spawn(5) // And wait a half-second, since it sounds like you can do this too fast.
		if(src)
			winset(src, null, "command=\".configure graphics-hwmode off\"")
			sleep(2) // wait a bit more, possibly fixes hardware mode not re-activating right
			winset(src, null, "command=\".configure graphics-hwmode on\"")

	log_client_to_db()

	send_resources()

	if(!void)
		void = new()
	screen += void

	if(CONFIG_GET(flag/paranoia_logging))
		var/alert = FALSE //VOREStation Edit start.
		if(isnum(player_age) && player_age == 0)
			log_and_message_admins("PARANOIA: [key_name(src)] has connected here for the first time.")
			alert = TRUE
		if(isnum(account_age) && account_age <= 2)
			log_and_message_admins("PARANOIA: [key_name(src)] has a very new BYOND account ([account_age] days).")
			alert = TRUE
		if(alert)
			for(var/client/X in GLOB.admins)
				if(X.prefs?.read_preference(/datum/preference/toggle/holder/play_adminhelp_ping))
					X << 'sound/effects/tones/newplayerping.ogg'
				window_flash(X)
		//VOREStation Edit end.
	fully_created = TRUE
	attempt_auto_fit_viewport()

	// TODO: Remove version check with 516
	if(byond_version >= 516)
		// Now that we're fully initialized, use our prefs
		if(prefs?.read_preference(/datum/preference/toggle/browser_dev_tools))
			winset(src, null, "browser-options=[DEFAULT_CLIENT_BROWSER_OPTIONS],devtools")

	//////////////
	//DISCONNECT//
	//////////////
/client/Del()
	if(!gc_destroyed)
		gc_destroyed = world.time
		if (!QDELING(src))
			stack_trace("Client does not purport to be QDELING, this is going to cause bugs in other places!")

		GLOB.ahelp_tickets.ClientLogout(src)
		GLOB.mhelp_tickets.ClientLogout(src)

		// Yes this is the same as what's found in qdel(). Yes it does need to be here
		// Get off my back
		SEND_SIGNAL(src, COMSIG_PARENT_QDELETING, TRUE)
		Destroy() //Clean up signals and timers.
	return ..()

/client/Destroy()
	if(holder)
		holder.owner = null
		GLOB.admins -= src
	if (mentorholder)
		mentorholder.owner = null
		GLOB.mentors -= src
	GLOB.directory -= ckey
	GLOB.clients -= src

	..()
	return QDEL_HINT_HARDDEL_NOW

// here because it's similar to below

// Returns null if no DB connection can be established, or -1 if the requested key was not found in the database

/proc/get_player_age(key)
	establish_db_connection()
	if(!SSdbcore.IsConnected())
		return null

	var/sql_ckey = sql_sanitize_text(ckey(key))

	var/datum/db_query/query = SSdbcore.NewQuery("SELECT datediff(Now(),firstseen) as age FROM erro_player WHERE ckey = '[sql_ckey]'")
	query.Execute()

	if(query.NextRow())
		return text2num(query.item[1])
	else
		return -1


/client/proc/log_client_to_db()

	if ( IsGuestKey(src.key) )
		return

	establish_db_connection()
	if(!SSdbcore.IsConnected())
		return

	var/sql_ckey = sql_sanitize_text(src.ckey)

	var/datum/db_query/query = SSdbcore.NewQuery("SELECT id, datediff(Now(),firstseen) as age FROM erro_player WHERE ckey = '[sql_ckey]'")
	query.Execute()
	var/sql_id = 0
	player_age = 0	// New players won't have an entry so knowing we have a connection we set this to zero to be updated if their is a record.
	while(query.NextRow())
		sql_id = query.item[1]
		player_age = text2num(query.item[2])
		break

	qdel(query)
	account_join_date = sanitizeSQL(findJoinDate())
	if(account_join_date && SSdbcore.IsConnected())
		var/datum/db_query/query_datediff = SSdbcore.NewQuery("SELECT DATEDIFF(Now(),'[account_join_date]')")
		if(query_datediff.Execute() && query_datediff.NextRow())
			account_age = text2num(query_datediff.item[1])
		qdel(query_datediff)

	var/datum/db_query/query_ip = SSdbcore.NewQuery("SELECT ckey FROM erro_player WHERE ip = '[address]'")
	query_ip.Execute()
	related_accounts_ip = ""
	while(query_ip.NextRow())
		related_accounts_ip += "[query_ip.item[1]], "
		break
	qdel(query_ip)

	var/datum/db_query/query_cid = SSdbcore.NewQuery("SELECT ckey FROM erro_player WHERE computerid = '[computer_id]'")
	query_cid.Execute()
	related_accounts_cid = ""
	while(query_cid.NextRow())
		related_accounts_cid += "[query_cid.item[1]], "
		break
	qdel(query_cid)

	//Just the standard check to see if it's actually a number
	if(sql_id)
		if(istext(sql_id))
			sql_id = text2num(sql_id)
		if(!isnum(sql_id))
			return

	var/admin_rank = "Player"
	if(src.holder)
		admin_rank = src.holder.rank

	var/sql_ip = sql_sanitize_text(src.address)
	var/sql_computerid = sql_sanitize_text(src.computer_id)
	var/sql_admin_rank = sql_sanitize_text(admin_rank)

	// If you're about to disconnect the player, you have to use to_chat_immediate otherwise they won't get the message (SSchat will queue it)

	//Panic bunker code
	if (isnum(player_age) && player_age == 0) //first connection
		if (CONFIG_GET(flag/panic_bunker) && !holder && !deadmin_holder)
			log_adminwarn("Failed Login: [key] - New account attempting to connect during panic bunker")
			message_admins(span_adminnotice("Failed Login: [key] - New account attempting to connect during panic bunker"))
			disconnect_with_message("Sorry but the server is currently not accepting connections from never before seen players.")
			return 0

	// IP Reputation Check
	if(CONFIG_GET(flag/ip_reputation))
		if(CONFIG_GET(flag/ipr_allow_existing) && player_age >= CONFIG_GET(number/ipr_minimum_age))
			log_admin("Skipping IP reputation check on [key] with [address] because of player age")
		else if(update_ip_reputation()) //It is set now
			if(ip_reputation >= CONFIG_GET(number/ipr_bad_score)) //It's bad

				//Log it
				if(CONFIG_GET(flag/paranoia_logging)) //We don't block, but we want paranoia log messages
					log_and_message_admins("[key] at [address] has bad IP reputation: [ip_reputation]. Will be kicked if enabled in config.", null)
				else //We just log it
					log_admin("[key] at [address] has bad IP reputation: [ip_reputation]. Will be kicked if enabled in config.")

				//Take action if required
				if(CONFIG_GET(flag/ipr_block_bad_ips) && CONFIG_GET(flag/ipr_allow_existing)) //We allow players of an age, but you don't meet it
					disconnect_with_message("Sorry, we only allow VPN/Proxy/Tor usage for players who have spent at least [CONFIG_GET(number/ipr_minimum_age)] days on the server. If you are unable to use the internet without your VPN/Proxy/Tor, please contact an admin out-of-game to let them know so we can accommodate this.")
					return 0
				else if(CONFIG_GET(flag/ipr_block_bad_ips)) //We don't allow players of any particular age
					disconnect_with_message("Sorry, we do not accept connections from users via VPN/Proxy/Tor connections. If you believe this is in error, contact an admin out-of-game.")
					return 0
		else
			log_admin("Couldn't perform IP check on [key] with [address]")

	// VOREStation Edit Start - Department Hours
	var/datum/db_query/query_hours = SSdbcore.NewQuery("SELECT department, hours, total_hours FROM vr_player_hours WHERE ckey = '[sql_ckey]'")
	if(query_hours.Execute())
		while(query_hours.NextRow())
			department_hours[query_hours.item[1]] = text2num(query_hours.item[2])
			play_hours[query_hours.item[1]] = text2num(query_hours.item[3])
	else
		var/error_message = query_hours.ErrorMsg() // Need this out here since the spawn below will split the stack and who knows what'll happen by the time it runs
		log_debug("Error loading play hours for [ckey]: [error_message]")
		tgui_alert_async(src, "The query to load your existing playtime failed. Screenshot this, give the screenshot to a developer, and reconnect, otherwise you may lose any recorded play hours (which may limit access to jobs). ERROR: [error_message]", "PROBLEMS!!")
	// VOREStation Edit End - Department Hours
	qdel(query_hours)

	if(sql_id)
		//Player already identified previously, we need to just update the 'lastseen', 'ip' and 'computer_id' variables
		var/datum/db_query/query_update = SSdbcore.NewQuery("UPDATE erro_player SET lastseen = Now(), ip = '[sql_ip]', computerid = '[sql_computerid]', lastadminrank = '[sql_admin_rank]' WHERE id = [sql_id]")
		query_update.Execute()
		qdel(query_update)
	else
		//New player!! Need to insert all the stuff
		var/datum/db_query/query_insert = SSdbcore.NewQuery("INSERT INTO erro_player (id, ckey, firstseen, lastseen, ip, computerid, lastadminrank) VALUES (null, '[sql_ckey]', Now(), Now(), '[sql_ip]', '[sql_computerid]', '[sql_admin_rank]')")
		query_insert.Execute()
		qdel(query_insert)

	//Logging player access
	var/serverip = "[world.internet_address]:[world.port]"
	var/datum/db_query/query_accesslog = SSdbcore.NewQuery("INSERT INTO `erro_connection_log`(`id`,`datetime`,`serverip`,`ckey`,`ip`,`computerid`) VALUES(null,Now(),'[serverip]','[sql_ckey]','[sql_ip]','[sql_computerid]');")
	query_accesslog.Execute()
	qdel(query_accesslog)

#undef UPLOAD_LIMIT
#undef MIN_CLIENT_VERSION

//checks if a client is afk
//3000 frames = 5 minutes
/client/proc/is_afk(duration=3000)
	if(inactivity > duration)	return inactivity
	return 0

//Called when the client performs a drag-and-drop operation.
/client/MouseDrop(start_object,end_object,start_location,end_location,start_control,end_control,params)
	if(buildmode && start_control == "mapwindow.map" && start_control == end_control)
		build_drag(src,buildmode,start_object,end_object,start_location,end_location,start_control,end_control,params)
	else
		. = ..()

/client/proc/last_activity_seconds()
	return inactivity / 10

//send resources to the client. It's here in its own proc so we can move it around easiliy if need be
/client/proc/send_resources()
	spawn (10) //removing this spawn causes all clients to not get verbs.

		//load info on what assets the client has
		src << browse('code/modules/asset_cache/validate_assets.html', "window=asset_cache_browser")

		//Precache the client with all other assets slowly, so as to not block other browse() calls
		if (CONFIG_GET(flag/asset_simple_preload))
			addtimer(CALLBACK(SSassets.transport, TYPE_PROC_REF(/datum/asset_transport, send_assets_slow), src, SSassets.transport.preload), 5 SECONDS)

/mob/proc/MayRespawn()
	return 0

/client/proc/MayRespawn()
	if(mob)
		return mob.MayRespawn()

	// Something went wrong, client is usually kicked or transfered to a new mob at this point
	return 0

/client/verb/character_setup()
	set name = "Character Setup"
	set category = "Preferences.Character"
	if(prefs)
		prefs.ShowChoices(usr)

/client/verb/game_options()
	set name = "Game Options"
	set category = "Preferences.Game"
	if(prefs)
		prefs.tgui_interact(usr)

/client/proc/findJoinDate()
	var/list/http = world.Export("http://byond.com/members/[ckey]?format=text")
	if(!http)
		log_world("Failed to connect to byond age check for [ckey]")
		return
	var/F = file2text(http["CONTENT"])
	if(F)
		var/regex/R = regex("joined = \"(\\d{4}-\\d{2}-\\d{2})\"")
		if(R.Find(F))
			. = R.group[1]
		else
			CRASH("Age check regex failed for [src.ckey]")

/client/vv_edit_var(var_name, var_value)
	if(var_name == NAMEOF(src, holder))
		return FALSE
	return ..()

//This is for getipintel.net.
//You're welcome to replace this proc with your own that does your own cool stuff.
//Just set the client's ip_reputation var and make sure it makes sense with your config settings (higher numbers are worse results)
/client/proc/update_ip_reputation()
	var/request = "https://check.getipintel.net/check.php?ip=[address]&contact=[CONFIG_GET(string/ipr_email)]"
	var/http[] = world.Export(request)

	/* Debug
	to_world_log("Requested this: [request]")
	for(var/entry in http)
		to_world_log("[entry] : [http[entry]]")
	*/

	if(!http || !islist(http)) //If we couldn't check, the service might be down, fail-safe.
		log_admin("Couldn't connect to getipintel.net to check [address] for [key]")
		return FALSE

	//429 is rate limit exceeded
	if(text2num(http["STATUS"]) == 429)
		log_and_message_admins("getipintel.net reports HTTP status 429. IP reputation checking is now disabled. If you see this, let a developer know.")
		CONFIG_SET(flag/ip_reputation, FALSE)
		return FALSE

	var/content = file2text(http["CONTENT"]) //world.Export actually returns a file object in CONTENT
	var/score = text2num(content)
	if(isnull(score))
		return FALSE

	//Error handling
	if(score < 0)
		var/fatal = TRUE
		var/ipr_error = "getipintel.net IP reputation check error while checking [address] for [key]: "
		switch(score)
			if(-1)
				ipr_error += "No input provided"
			if(-2)
				fatal = FALSE
				ipr_error += "Invalid IP provided"
			if(-3)
				fatal = FALSE
				ipr_error += "Unroutable/private IP (spoofing?)"
			if(-4)
				fatal = FALSE
				ipr_error += "Unable to reach database"
			if(-5)
				ipr_error += "Our IP is banned or otherwise forbidden"
			if(-6)
				ipr_error += "Missing contact info"

		log_and_message_admins(ipr_error)
		if(fatal)
			CONFIG_SET(flag/ip_reputation, FALSE)
			log_and_message_admins("With this error, IP reputation checking is disabled for this shift. Let a developer know.")
		return FALSE

	//Went fine
	else
		ip_reputation = score
		return TRUE

/client/proc/disconnect_with_message(var/message = "You have been intentionally disconnected by the server.<br>This may be for security or administrative reasons.")
	message = "<head><title>You Have Been Disconnected</title></head><body><hr><center><b>[message]</b></center><hr><br>If you feel this is in error, you can contact an administrator out-of-game (for example, on Discord).</body>"
	window_flash(src)
	src << browse("<html>[message]</html>","window=dropmessage;size=480x360;can_close=1")
	qdel(src)

/// Keydown event in a tgui window this client has open. Has keycode passed to it.
/client/verb/TguiKeyDown(keycode as text)
	set name = "TguiKeyDown"
	set hidden = TRUE
	return // stub

/// Keyup event in a tgui window this client has open. Has keycode passed to it.
/client/verb/TguiKeyUp(keycode as text) // Doesn't seem to currently fire?
	set name = "TguiKeyUp"
	set hidden = TRUE
	return // stub

/client/verb/toggle_fullscreen()
	set name = "Toggle Fullscreen"
	set category = "OOC.Client Settings"

	fullscreen = !fullscreen

	if (fullscreen)
		winset(usr, "mainwindow", "on-size=")
		winset(usr, "mainwindow", "titlebar=false")
		winset(usr, "mainwindow", "can-resize=false")
		winset(usr, "mainwindow", "menu=")
		winset(usr, "mainwindow", "is-maximized=false")
		winset(usr, "mainwindow", "is-maximized=true")
	else
		winset(usr, "mainwindow", "menu=menu")
		winset(usr, "mainwindow", "titlebar=true")
		winset(usr, "mainwindow", "can-resize=true")
		winset(usr, "mainwindow", "is-maximized=false")
		winset(usr, "mainwindow", "on-size=attempt_auto_fit_viewport") // The attempt_auto_fit_viewport() proc is not implemented yet
	attempt_auto_fit_viewport()

/client/verb/toggle_verb_panel()
	set name = "Toggle Verbs"
	set category = "OOC.Client Settings"

	show_verb_panel = !show_verb_panel

	to_chat(src, "Your verbs are now [show_verb_panel ? "on" : "off. To turn them back on, type 'toggle-verbs' into the command bar."].")

/*
/client/verb/toggle_status_bar()
	set name = "Toggle Status Bar"
	set category = "OOC.Client Settings"

	show_status_bar = !show_status_bar

	if (show_status_bar)
		winset(usr, "input", "is-visible=true")
	else
		winset(usr, "input", "is-visible=false")
*/

/client/verb/show_active_playtime()
	set name = "Active Playtime"
	set category = "OOC.Game"

	if(!play_hours.len)
		to_chat(src, span_warning("Persistent playtime disabled!"))
		return

	var/department_hours = ""
	for(var/play_hour in play_hours)
		if(!isnum(play_hour) && isnum(play_hours[play_hour]))
			department_hours += "<br>\t[capitalize(play_hour)]: [play_hours[play_hour]]"
	if(!department_hours)
		to_chat(src, span_warning("No recorded playtime found!"))
		return
	to_chat(src, span_info("Your department hours:" + department_hours))

/// compiles a full list of verbs and sends it to the browser
/client/proc/init_verbs()
	if(IsAdminAdvancedProcCall())
		return
	var/list/verblist = list()
	panel_tabs.Cut()
	for(var/thing in (verbs + mob?.verbs))
		var/procpath/verb_to_init = thing
		if(!verb_to_init)
			continue
		if(verb_to_init.hidden)
			continue
		if(!istext(verb_to_init.category))
			continue
		panel_tabs |= verb_to_init.category
		verblist[++verblist.len] = list(verb_to_init.category, verb_to_init.name, verb_to_init.desc)
	src.stat_panel.send_message("init_verbs", list(panel_tabs = panel_tabs, verblist = verblist))

/client/proc/check_panel_loaded()
	if(stat_panel && stat_panel.is_ready())
		return
	to_chat(src, span_danger("Statpanel failed to load, click <a href='byond://?src=[REF(src)];reload_statbrowser=1'>here</a> to reload the panel. If this does not work, reconnecting will reassign a new panel."))

/**
 * Handles incoming messages from the stat-panel TGUI.
 */
/client/proc/on_stat_panel_message(type, payload)
	switch(type)
		if("Update-Verbs")
			init_verbs()
		if("Remove-Tabs")
			panel_tabs -= payload["tab"]
		if("Send-Tabs")
			panel_tabs |= payload["tab"]
		if("Reset-Tabs")
			panel_tabs = list()
		if("Set-Tab")
			stat_tab = payload["tab"]
			SSstatpanels.immediate_send_stat_data(src)


// Mouse stuff
/client/Click(atom/object, atom/location, control, params)
	var/mcl = CONFIG_GET(number/minute_click_limit)
	if (!holder && mcl)
		var/minute = round(world.time, 600)

		if (!clicklimiter)
			clicklimiter = new(LIMITER_SIZE)

		if (minute != clicklimiter[CURRENT_MINUTE])
			clicklimiter[CURRENT_MINUTE] = minute
			clicklimiter[MINUTE_COUNT] = 0

		clicklimiter[MINUTE_COUNT] += 1

		if (clicklimiter[MINUTE_COUNT] > mcl)
			var/msg = "Your previous click was ignored because you've done too many in a minute."
			if (minute != clicklimiter[ADMINSWARNED_AT]) //only one admin message per-minute. (if they spam the admins can just boot/ban them)
				clicklimiter[ADMINSWARNED_AT] = minute

				msg += " Administrators have been informed."
				log_and_message_admins("Has hit the per-minute click limit of [mcl] clicks in a given game minute", src)
			to_chat(src, span_danger("[msg]"))
			return

	var/scl = CONFIG_GET(number/second_click_limit)
	if (!holder && scl)
		var/second = round(world.time, 10)
		if (!clicklimiter)
			clicklimiter = new(LIMITER_SIZE)

		if (second != clicklimiter[CURRENT_SECOND])
			clicklimiter[CURRENT_SECOND] = second
			clicklimiter[SECOND_COUNT] = 0

		clicklimiter[SECOND_COUNT] += 1

		if (clicklimiter[SECOND_COUNT] > scl)
			to_chat(src, span_danger("Your previous click was ignored because you've done too many in a second"))
			return
	SEND_SIGNAL(src, COMSIG_CLIENT_CLICK, object, location, control, params, usr)
	. = ..()

#undef ADMINSWARNED_AT
#undef CURRENT_MINUTE
#undef CURRENT_SECOND
#undef LIMITER_SIZE
#undef MINUTE_COUNT
#undef SECOND_COUNT
