#define RECOMMENDED_VERSION 513
/world/New()
	world_startup_time = world.timeofday
	rollover_safety_date = world.realtime - world.timeofday // 00:00 today (ish, since floating point error with world.realtime) of today
	to_world_log("Map Loading Complete")
	//logs
	//VOREStation Edit Start
	log_path += time2text(world.realtime, "YYYY/MM-Month/DD-Day/round-hh-mm-ss")
	diary = start_log("[log_path].log")
	href_logfile = start_log("[log_path]-hrefs.htm")
	error_log = start_log("[log_path]-error.log")
	debug_log = start_log("[log_path]-debug.log")
	//VOREStation Edit End

	changelog_hash = md5('html/changelog.html')					//used for telling if the changelog has changed recently

	if(byond_version < RECOMMENDED_VERSION)
		to_world_log("Your server's byond version does not meet the recommended requirements for this server. Please update BYOND")

	TgsNew()
	VgsNew() // VOREStation Edit - VGS

	config.post_load()

	if(config && config.server_name != null && config.server_suffix && world.port > 0)
		// dumb and hardcoded but I don't care~
		config.server_name += " #[(world.port % 1000) / 100]"

	// TODO - Figure out what this is. Can you assign to world.log?
	// if(config && config.log_runtime)
	// 	log = file("data/logs/runtime/[time2text(world.realtime,"YYYY-MM-DD-(hh-mm-ss)")]-runtime.log")

	GLOB.timezoneOffset = get_timezone_offset()

	callHook("startup")
	init_vchat()
	//Emergency Fix
	load_mods()
	//end-emergency fix

	src.update_status()

	. = ..()

#if UNIT_TEST
	log_unit_test("Unit Tests Enabled.  This will destroy the world when testing is complete.")
	log_unit_test("If you did not intend to enable this please check code/__defines/unit_testing.dm")
#endif

	// This is kinda important. Set up details of what the hell things are made of.
	populate_material_list()

	// Create frame types.
	populate_frame_types()

	// Create floor types.
	populate_flooring_types()

	// Create robolimbs for chargen.
	populate_robolimb_list()

	master_controller = new /datum/controller/game_controller()
	Master.Initialize(10, FALSE, TRUE) // VOREStation Edit

	spawn(1)
		master_controller.setup()
#if UNIT_TEST
		initialize_unit_tests()
#endif

	spawn(3000)		//so we aren't adding to the round-start lag
		if(config.ToRban)
			ToRban_autoupdate()

#undef RECOMMENDED_VERSION

	return

var/world_topic_spam_protect_ip = "0.0.0.0"
var/world_topic_spam_protect_time = world.timeofday

/world/Topic(T, addr, master, key)
	TGS_TOPIC
	VGS_TOPIC // VOREStation Edit - VGS
	log_topic("\"[T]\", from:[addr], master:[master], key:[key]")

	if (T == "ping")
		var/x = 1
		for (var/client/C)
			x++
		return x

	else if(T == "players")
		var/n = 0
		for(var/mob/M in player_list)
			if(M.client)
				n++
		return n

	else if (copytext(T,1,7) == "status")
		var/input[] = params2list(T)
		var/list/s = list()
		s["version"] = game_version
		s["mode"] = master_mode
		s["respawn"] = config.abandon_allowed
		s["persistance"] = config.persistence_disabled
		s["enter"] = config.enter_allowed
		s["vote"] = config.allow_vote_mode
		s["ai"] = config.allow_ai
		s["host"] = host ? host : null

		// This is dumb, but spacestation13.com's banners break if player count isn't the 8th field of the reply, so... this has to go here.
		s["players"] = 0
		s["stationtime"] = stationtime2text()
		s["roundduration"] = roundduration2text()
		s["map"] = strip_improper(using_map.full_name) //Done to remove the non-UTF-8 text macros

		if(input["status"] == "2") // Shiny new hip status.
			var/active = 0
			var/list/players = list()
			var/list/admins = list()

			for(var/client/C in GLOB.clients)
				if(C.holder)
					if(C.holder.fakekey)
						continue
					admins[C.key] = C.holder.rank
				players += C.key
				if(istype(C.mob, /mob/living))
					active++

			s["players"] = players.len
			s["playerlist"] = list2params(players)
			s["active_players"] = active
			var/list/adm = get_admin_counts()
			var/list/presentmins = adm["present"]
			var/list/afkmins = adm["afk"]
			s["admins"] = presentmins.len + afkmins.len //equivalent to the info gotten from adminwho
			s["adminlist"] = list2params(admins)
		else // Legacy.
			var/n = 0
			var/admins = 0

			for(var/client/C in GLOB.clients)
				if(C.holder)
					if(C.holder.fakekey)
						continue	//so stealthmins aren't revealed by the hub
					admins++
				s["player[n]"] = C.key
				n++

			s["players"] = n
			s["admins"] = admins

		return list2params(s)

	else if(T == "manifest")
		var/list/positions = list()
		var/list/set_names = list(
				"heads" = SSjob.get_job_titles_in_department(DEPARTMENT_COMMAND),
				"sec" = SSjob.get_job_titles_in_department(DEPARTMENT_SECURITY),
				"eng" = SSjob.get_job_titles_in_department(DEPARTMENT_ENGINEERING),
				"med" = SSjob.get_job_titles_in_department(DEPARTMENT_MEDICAL),
				"sci" = SSjob.get_job_titles_in_department(DEPARTMENT_RESEARCH),
				"car" = SSjob.get_job_titles_in_department(DEPARTMENT_CARGO),
				"pla" = SSjob.get_job_titles_in_department(DEPARTMENT_PLANET), //VOREStation Add,
				"civ" = SSjob.get_job_titles_in_department(DEPARTMENT_CIVILIAN),
				"bot" = SSjob.get_job_titles_in_department(DEPARTMENT_SYNTHETIC)
			)

		for(var/datum/data/record/t in data_core.general)
			var/name = t.fields["name"]
			var/rank = t.fields["rank"]
			var/real_rank = make_list_rank(t.fields["real_rank"])

			var/department = 0
			for(var/k in set_names)
				if(real_rank in set_names[k])
					if(!positions[k])
						positions[k] = list()
					positions[k][name] = rank
					department = 1
			if(!department)
				if(!positions["misc"])
					positions["misc"] = list()
				positions["misc"][name] = rank

		for(var/datum/data/record/t in data_core.hidden_general)
			var/name = t.fields["name"]
			var/rank = t.fields["rank"]
			var/real_rank = make_list_rank(t.fields["real_rank"])

			var/datum/job/J = SSjob.get_job(real_rank)
			if(J?.offmap_spawn)
				if(!positions["off"])
					positions["off"] = list()
				positions["off"][name] = rank

		// Synthetics don't have actual records, so we will pull them from here.
		for(var/mob/living/silicon/ai/ai in mob_list)
			if(!positions["bot"])
				positions["bot"] = list()
			positions["bot"][ai.name] = "Artificial Intelligence"
		for(var/mob/living/silicon/robot/robot in mob_list)
			// No combat/syndicate cyborgs, no drones, and no AI shells.
			if(robot.shell)
				continue
			if(robot.module && robot.module.hide_on_manifest())
				continue
			if(!positions["bot"])
				positions["bot"] = list()
			positions["bot"][robot.name] = "[robot.modtype] [robot.braintype]"

		for(var/k in positions)
			positions[k] = list2params(positions[k]) // converts positions["heads"] = list("Bob"="Captain", "Bill"="CMO") into positions["heads"] = "Bob=Captain&Bill=CMO"

		return list2params(positions)

	else if(T == "revision")
		if(GLOB.revdata.revision)
			return list2params(list(branch = GLOB.revdata.branch, date = GLOB.revdata.date, revision = GLOB.revdata.revision))
		else
			return "unknown"

	else if(copytext(T,1,5) == "info")
		var/input[] = params2list(T)
		if(input["key"] != config.comms_password)
			if(world_topic_spam_protect_ip == addr && abs(world_topic_spam_protect_time - world.time) < 50)

				spawn(50)
					world_topic_spam_protect_time = world.time
					return

			world_topic_spam_protect_time = world.time
			world_topic_spam_protect_ip = addr

			return "Bad Key"

		var/list/search = params2list(input["info"])
		var/list/ckeysearch = list()
		for(var/text in search)
			ckeysearch += ckey(text)

		var/list/match = list()

		for(var/mob/M in mob_list)
			var/strings = list(M.name, M.ckey)
			if(M.mind)
				strings += M.mind.assigned_role
				strings += M.mind.special_role
			for(var/text in strings)
				if(ckey(text) in ckeysearch)
					match[M] += 10 // an exact match is far better than a partial one
				else
					for(var/searchstr in search)
						if(findtext(text, searchstr))
							match[M] += 1

		var/maxstrength = 0
		for(var/mob/M in match)
			maxstrength = max(match[M], maxstrength)
		for(var/mob/M in match)
			if(match[M] < maxstrength)
				match -= M

		if(!match.len)
			return "No matches"
		else if(match.len == 1)
			var/mob/M = match[1]
			var/info = list()
			info["key"] = M.key
			info["name"] = M.name == M.real_name ? M.name : "[M.name] ([M.real_name])"
			info["role"] = M.mind ? (M.mind.assigned_role ? M.mind.assigned_role : "No role") : "No mind"
			var/turf/MT = get_turf(M)
			info["loc"] = M.loc ? "[M.loc]" : "null"
			info["turf"] = MT ? "[MT] @ [MT.x], [MT.y], [MT.z]" : "null"
			info["area"] = MT ? "[MT.loc]" : "null"
			info["antag"] = M.mind ? (M.mind.special_role ? M.mind.special_role : "Not antag") : "No mind"
			info["hasbeenrev"] = M.mind ? M.mind.has_been_rev : "No mind"
			info["stat"] = M.stat
			info["type"] = M.type
			if(istype(M, /mob/living))
				var/mob/living/L = M
				info["damage"] = list2params(list(
							oxy = L.getOxyLoss(),
							tox = L.getToxLoss(),
							fire = L.getFireLoss(),
							brute = L.getBruteLoss(),
							clone = L.getCloneLoss(),
							brain = L.getBrainLoss()
						))
			else
				info["damage"] = "non-living"
			info["gender"] = M.gender
			return list2params(info)
		else
			var/list/ret = list()
			for(var/mob/M in match)
				ret[M.key] = M.name
			return list2params(ret)

	else if(copytext(T,1,9) == "adminmsg")
		/*
			We got an adminmsg from IRC bot lets split the input then validate the input.
			expected output:
				1. adminmsg = ckey of person the message is to
				2. msg = contents of message, parems2list requires
				3. validatationkey = the key the bot has, it should match the gameservers commspassword in it's configuration.
				4. sender = the ircnick that send the message.
		*/


		var/input[] = params2list(T)
		if(input["key"] != config.comms_password)
			if(world_topic_spam_protect_ip == addr && abs(world_topic_spam_protect_time - world.time) < 50)

				spawn(50)
					world_topic_spam_protect_time = world.time
					return

			world_topic_spam_protect_time = world.time
			world_topic_spam_protect_ip = addr

			return "Bad Key"

		var/client/C
		var/req_ckey = ckey(input["adminmsg"])

		for(var/client/K in GLOB.clients)
			if(K.ckey == req_ckey)
				C = K
				break
		if(!C)
			return "No client with that name on server"

		var/rank = input["rank"]
		if(!rank)
			rank = "Admin"

		var/message =	"<font color='red'>IRC-[rank] PM from <b><a href='?irc_msg=[input["sender"]]'>IRC-[input["sender"]]</a></b>: [input["msg"]]</font>"
		var/amessage =  "<font color='blue'>IRC-[rank] PM from <a href='?irc_msg=[input["sender"]]'>IRC-[input["sender"]]</a> to <b>[key_name(C)]</b> : [input["msg"]]</font>"

		C.received_irc_pm = world.time
		C.irc_admin = input["sender"]

		C << 'sound/effects/adminhelp.ogg'
		to_chat(C,message)


		for(var/client/A in GLOB.admins)
			if(A != C)
				to_chat(A,amessage)

		return "Message Successful"

	else if(copytext(T,1,6) == "notes")
		/*
			We got a request for notes from the IRC Bot
			expected output:
				1. notes = ckey of person the notes lookup is for
				2. validationkey = the key the bot has, it should match the gameservers commspassword in it's configuration.
		*/
		var/input[] = params2list(T)
		if(input["key"] != config.comms_password)
			if(world_topic_spam_protect_ip == addr && abs(world_topic_spam_protect_time - world.time) < 50)

				spawn(50)
					world_topic_spam_protect_time = world.time
					return

			world_topic_spam_protect_time = world.time
			world_topic_spam_protect_ip = addr
			return "Bad Key"

		return show_player_info_irc(ckey(input["notes"]))

	else if(copytext(T,1,4) == "age")
		var/input[] = params2list(T)
		if(input["key"] != config.comms_password)
			if(world_topic_spam_protect_ip == addr && abs(world_topic_spam_protect_time - world.time) < 50)
				spawn(50)
					world_topic_spam_protect_time = world.time
					return

			world_topic_spam_protect_time = world.time
			world_topic_spam_protect_ip = addr
			return "Bad Key"

		var/age = get_player_age(input["age"])
		if(isnum(age))
			if(age >= 0)
				return "[age]"
			else
				return "Ckey not found"
		else
			return "Database connection failed or not set up"


/world/Reboot(reason = 0, fast_track = FALSE)
	/*spawn(0)
		world << sound(pick('sound/AI/newroundsexy.ogg','sound/misc/apcdestroyed.ogg','sound/misc/bangindonk.ogg')) // random end sounds!! - LastyBatsy
		*/

	if (reason || fast_track) //special reboot, do none of the normal stuff
		if (usr)
			log_admin("[key_name(usr)] Has requested an immediate world restart via client side debugging tools")
			message_admins("[key_name_admin(usr)] Has requested an immediate world restart via client side debugging tools")
			to_world("<span class='boldannounce'>[key_name_admin(usr)] has requested an immediate world restart via client side debugging tools</span>")

		else
			to_world("<span class='boldannounce'>Rebooting world immediately due to host request</span>")
	else
		Master.Shutdown()	//run SS shutdowns
		for(var/client/C in GLOB.clients)
			if(config.server)	//if you set a server location in config.txt, it sends you there instead of trying to reconnect to the same world address. -- NeoFite
				C << link("byond://[config.server]")

	TgsReboot()
	log_world("World rebooted at [time_stamp()]")
	..()

/hook/startup/proc/loadMode()
	world.load_mode()
	return 1

/world/proc/load_mode()
	if(!fexists("data/mode.txt"))
		return


	var/list/Lines = file2list("data/mode.txt")
	if(Lines.len)
		if(Lines[1])
			master_mode = Lines[1]
			log_misc("Saved mode is '[master_mode]'")

/world/proc/save_mode(var/the_mode)
	var/F = file("data/mode.txt")
	fdel(F)
	F << the_mode


/hook/startup/proc/loadMOTD()
	world.load_motd()
	return 1

/world/proc/load_motd()
	join_motd = file2text("config/motd.txt")


/proc/load_configuration()
	config = new /datum/configuration()
	config.load("config/config.txt")
	config.load("config/game_options.txt","game_options")
	config.loadsql("config/dbconfig.txt")
	config.loadforumsql("config/forumdbconfig.txt")

/hook/startup/proc/loadMods()
	world.load_mods()
	world.load_mentors() // no need to write another hook.
	return 1

/world/proc/load_mods()
	if(config.admin_legacy_system)
		var/text = file2text("config/moderators.txt")
		if (!text)
			error("Failed to load config/mods.txt")
		else
			var/list/lines = splittext(text, "\n")
			for(var/line in lines)
				if (!line)
					continue

				if (copytext(line, 1, 2) == ";")
					continue

				var/title = "Moderator"
				var/rights = admin_ranks[title]

				var/ckey = copytext(line, 1, length(line)+1)
				var/datum/admins/D = new /datum/admins(title, rights, ckey)
				D.associate(GLOB.directory[ckey])

/world/proc/load_mentors()
	if(config.admin_legacy_system)
		var/text = file2text("config/mentors.txt")
		if (!text)
			error("Failed to load config/mentors.txt")
		else
			var/list/lines = splittext(text, "\n")
			for(var/line in lines)
				if (!line)
					continue
				if (copytext(line, 1, 2) == ";")
					continue

				var/ckey = copytext(line, 1, length(line)+1)
				var/datum/mentor/M = new /datum/mentor(ckey)
				M.associate(GLOB.directory[ckey])

/world/proc/update_status()
	var/s = ""

	if (config && config.server_name)
		s += "<b>[config.server_name]</b> &#8212; "

	s += "<b>[station_name()]</b>";
	s += " ("
	s += "<a href=\"http://\">" //Change this to wherever you want the hub to link to.
//	s += "[game_version]"
	s += "Default"  //Replace this with something else. Or ever better, delete it and uncomment the game version.
	s += "</a>"
	s += ")"

	var/list/features = list()

	if(ticker)
		if(master_mode)
			features += master_mode
	else
		features += "<b>STARTING</b>"

	if (!config.enter_allowed)
		features += "closed"

	features += config.abandon_allowed ? "respawn" : "no respawn"

	features += config.persistence_disabled ? "persistence disabled" : "persistence enabled"

	features += config.persistence_ignore_mapload ? "persistence mapload disabled" : "persistence mapload enabled"

	if (config && config.allow_vote_mode)
		features += "vote"

	if (config && config.allow_ai)
		features += "AI allowed"

	var/n = 0
	for (var/mob/M in player_list)
		if (M.client)
			n++

	if (n > 1)
		features += "~[n] players"
	else if (n > 0)
		features += "~[n] player"


	if (config && config.hostedby)
		features += "hosted by <b>[config.hostedby]</b>"

	if (features)
		s += ": [jointext(features, ", ")]"

	/* does this help? I do not know */
	if (src.status != s)
		src.status = s

#define FAILED_DB_CONNECTION_CUTOFF 5
var/failed_db_connections = 0
var/failed_old_db_connections = 0

/hook/startup/proc/connectDB()
	if(!config.sql_enabled)
		to_world_log("SQL connection disabled in config.")
	else if(!setup_database_connection())
		to_world_log("Your server failed to establish a connection with the feedback database.")
	else
		to_world_log("Feedback database connection established.")
	return 1

/proc/setup_database_connection()
	if(failed_db_connections > FAILED_DB_CONNECTION_CUTOFF)	//If it failed to establish a connection more than 5 times in a row, don't bother attempting to conenct anymore.
		return 0

	if(!dbcon)
		dbcon = new()

	var/user = sqlfdbklogin
	var/pass = sqlfdbkpass
	var/db = sqlfdbkdb
	var/address = sqladdress
	var/port = sqlport

	dbcon.Connect("dbi:mysql:[db]:[address]:[port]","[user]","[pass]")
	. = dbcon.IsConnected()
	if ( . )
		failed_db_connections = 0	//If this connection succeeded, reset the failed connections counter.
	else
		failed_db_connections++		//If it failed, increase the failed connections counter.
		to_world_log(dbcon.ErrorMsg())

	return .

//This proc ensures that the connection to the feedback database (global variable dbcon) is established
/proc/establish_db_connection()
	if(failed_db_connections > FAILED_DB_CONNECTION_CUTOFF)
		return 0

	if(!dbcon || !dbcon.IsConnected())
		return setup_database_connection()
	else
		return 1


/hook/startup/proc/connectOldDB()
	if(!config.sql_enabled)
		to_world_log("SQL connection disabled in config.")
	else if(!setup_old_database_connection())
		to_world_log("Your server failed to establish a connection with the SQL database.")
	else
		to_world_log("SQL database connection established.")
	return 1

//These two procs are for the old database, while it's being phased out. See the tgstation.sql file in the SQL folder for more information.
/proc/setup_old_database_connection()

	if(failed_old_db_connections > FAILED_DB_CONNECTION_CUTOFF)	//If it failed to establish a connection more than 5 times in a row, don't bother attempting to conenct anymore.
		return 0

	if(!dbcon_old)
		dbcon_old = new()

	var/user = sqllogin
	var/pass = sqlpass
	var/db = sqldb
	var/address = sqladdress
	var/port = sqlport

	dbcon_old.Connect("dbi:mysql:[db]:[address]:[port]","[user]","[pass]")
	. = dbcon_old.IsConnected()
	if ( . )
		failed_old_db_connections = 0	//If this connection succeeded, reset the failed connections counter.
	else
		failed_old_db_connections++		//If it failed, increase the failed connections counter.
		to_world_log(dbcon.ErrorMsg())

	return .

//This proc ensures that the connection to the feedback database (global variable dbcon) is established
/proc/establish_old_db_connection()
	if(failed_old_db_connections > FAILED_DB_CONNECTION_CUTOFF)
		return 0

	if(!dbcon_old || !dbcon_old.IsConnected())
		return setup_old_database_connection()
	else
		return 1

// Cleans up DB connections and recreates them
/proc/reset_database_connections()
	var/list/results = list("-- Resetting DB connections --")
	failed_db_connections = 0

	if(dbcon?.IsConnected())
		dbcon.Disconnect()
		results += "dbcon was connected and asked to disconnect"
	else
		results += "dbcon was not connected"

	if(dbcon_old?.IsConnected())
		results += "WARNING: dbcon_old is connected, not touching it, but is this intentional?"

	if(!config.sql_enabled)
		results += "stopping because config.sql_enabled = false"
	else
		. = setup_database_connection()
		if(.)
			results += "SUCCESS: set up a connection successfully with setup_database_connection()"
		else
			results += "FAIL: failed to connect to the database with setup_database_connection()"

	results += "-- DB Reset End --"
	to_world_log(results.Join("\n"))

// Things to do when a new z-level was just made.
/world/proc/max_z_changed()
	if(!istype(GLOB.players_by_zlevel, /list))
		GLOB.players_by_zlevel = new /list(world.maxz, 0)
		GLOB.living_players_by_zlevel = new /list(world.maxz, 0)

	while(GLOB.players_by_zlevel.len < world.maxz)
		GLOB.players_by_zlevel.len++
		GLOB.players_by_zlevel[GLOB.players_by_zlevel.len] = list()

		GLOB.living_players_by_zlevel.len++
		GLOB.living_players_by_zlevel[GLOB.living_players_by_zlevel.len] = list()

// Call this to make a new blank z-level, don't modify maxz directly.
/world/proc/increment_max_z()
	maxz++
	max_z_changed()

// Call this to change world.fps, don't modify it directly.
/world/proc/change_fps(new_value = 20)
	if(new_value <= 0)
		CRASH("change_fps() called with [new_value] new_value.")
	if(fps == new_value)
		return //No change required.

	fps = new_value
	on_tickrate_change()

// Called whenver world.tick_lag or world.fps are changed.
/world/proc/on_tickrate_change()
	SStimer?.reset_buckets()

#undef FAILED_DB_CONNECTION_CUTOFF

/proc/get_world_url()
	. = "byond://"
	if(config.serverurl)
		. += config.serverurl
	else if(config.server)
		. += config.server
	else
		. += "[world.address]:[world.port]"

var/global/game_id = null

/hook/startup/proc/generate_gameid()
	if(game_id != null)
		return
	game_id = ""

	var/list/c = list(
		"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m",
		"n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z",
		"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M",
		"N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z",
		"1", "2", "3", "4", "5", "6", "7", "8", "9", "0"
		)
	var/l = c.len

	var/t = world.timeofday
	for(var/_ = 1 to 4)
		game_id = "[c[(t % l) + 1]][game_id]"
		t = round(t / l)
	game_id = "-[game_id]"
	t = round(world.realtime / (10 * 60 * 60 * 24))
	for(var/_ = 1 to 3)
		game_id = "[c[(t % l) + 1]][game_id]"
		t = round(t / l)
	return 1