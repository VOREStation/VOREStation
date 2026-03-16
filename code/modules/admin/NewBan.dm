GLOBAL_VAR_INIT(c_minutes, 0)
GLOBAL_DATUM(banlist, /savefile)


/proc/CheckBan(var/ckey, var/id, var/address)
	if(!GLOB.banlist)		// if Banlist cannot be located for some reason
		LoadBans()		// try to load the bans
		if(!GLOB.banlist)	// uh oh, can't find bans!
			return 0	// ABORT ABORT ABORT

	. = list()
	var/appeal
	if(config && CONFIG_GET(string/banappeals))
		appeal = "\nFor more information on your ban, or to appeal, head to <a href='[CONFIG_GET(string/banappeals)]'>[CONFIG_GET(string/banappeals)]</a>"
	GLOB.banlist.cd = "/base"
	if( "[ckey][id]" in GLOB.banlist.dir )
		GLOB.banlist.cd = "[ckey][id]"
		if (GLOB.banlist["temp"])
			if (!GetExp(GLOB.banlist["minutes"]))
				ClearTempbans()
				return 0
			else
				.["desc"] = "\nReason: [GLOB.banlist["reason"]]\nExpires: [GetExp(GLOB.banlist["minutes"])]\nBy: [GLOB.banlist["bannedby"]][appeal]"
		else
			GLOB.banlist.cd	= "/base/[ckey][id]"
			.["desc"]	= "\nReason: [GLOB.banlist["reason"]]\nExpires: <B>PERMANENT</B>\nBy: [GLOB.banlist["bannedby"]][appeal]"
		.["reason"]	= "ckey/id"
		return .
	else
		for (var/A in GLOB.banlist.dir)
			GLOB.banlist.cd = "/base/[A]"
			var/matches
			if( ckey == GLOB.banlist["key"] )
				matches += "ckey"
			if( id == GLOB.banlist["id"] )
				if(matches)
					matches += "/"
				matches += "id"
			if( address == GLOB.banlist["ip"] )
				if(matches)
					matches += "/"
				matches += "ip"

			if(matches)
				if(GLOB.banlist["temp"])
					if (!GetExp(GLOB.banlist["minutes"]))
						ClearTempbans()
						return 0
					else
						.["desc"] = "\nReason: [GLOB.banlist["reason"]]\nExpires: [GetExp(GLOB.banlist["minutes"])]\nBy: [GLOB.banlist["bannedby"]][appeal]"
				else
					.["desc"] = "\nReason: [GLOB.banlist["reason"]]\nExpires: <B>PERMANENT</B>\nBy: [GLOB.banlist["bannedby"]][appeal]"
				.["reason"] = matches
				return .
	return 0

/proc/UpdateTime() //No idea why i made this a proc.
	GLOB.c_minutes = (world.realtime / 10) / 60
	return 1

/hook/startup/proc/loadBans()
	return LoadBans()

/proc/LoadBans()

	GLOB.banlist = new("data/banlist.bdb")
	log_admin("Loading Banlist")

	if (!length(GLOB.banlist.dir)) log_admin("Banlist is empty.")

	if (!GLOB.banlist.dir.Find("base"))
		log_admin("Banlist missing base dir.")
		GLOB.banlist.dir.Add("base")
		GLOB.banlist.cd = "/base"
	else if (GLOB.banlist.dir.Find("base"))
		GLOB.banlist.cd = "/base"

	ClearTempbans()
	return 1

/proc/ClearTempbans()
	UpdateTime()

	GLOB.banlist.cd = "/base"
	for (var/A in GLOB.banlist.dir)
		GLOB.banlist.cd = "/base/[A]"
		if (!GLOB.banlist["key"] || !GLOB.banlist["id"])
			RemoveBan(A)
			log_admin("Invalid Ban.")
			message_admins("Invalid Ban.")
			continue

		if (!GLOB.banlist["temp"])
			continue
		if (GLOB.c_minutes >= GLOB.banlist["minutes"])
			RemoveBan(A)

	return 1


/proc/AddBan(ckey, computerid, reason, bannedby, temp, minutes, address)

	var/bantimestamp

	if (temp)
		UpdateTime()
		bantimestamp = GLOB.c_minutes + minutes

	GLOB.banlist.cd = "/base"
	if ( GLOB.banlist.dir.Find("[ckey][computerid]") )
		to_chat(usr, span_filter_adminlog(span_warning("Ban already exists.")))
		return 0
	else
		GLOB.banlist.dir.Add("[ckey][computerid]")
		GLOB.banlist.cd = "/base/[ckey][computerid]"
		GLOB.banlist["key"] << ckey
		GLOB.banlist["id"] << computerid
		GLOB.banlist["ip"] << address
		GLOB.banlist["reason"] << reason
		GLOB.banlist["bannedby"] << bannedby
		GLOB.banlist["temp"] << temp
		if (temp)
			GLOB.banlist["minutes"] << bantimestamp
	admin_action_message(bannedby, ckey, "banned", reason, temp ? minutes : -1) //VOREStation Add
	return 1

/proc/RemoveBan(foldername)
	var/key
	var/id

	GLOB.banlist.cd = "/base/[foldername]"
	GLOB.banlist["key"] >> key
	GLOB.banlist["id"] >> id
	GLOB.banlist.cd = "/base"

	if (!GLOB.banlist.dir.Remove(foldername)) return 0

	if(!usr)
		log_admin("Ban Expired: [key]")
		message_admins("Ban Expired: [key]")
	else
		ban_unban_log_save("[key_name_admin(usr)] unbanned [key]")
		log_admin("[key_name_admin(usr)] unbanned [key]")
		message_admins("[key_name_admin(usr)] unbanned: [key]")
		feedback_inc("ban_unban",1)
		usr.client.holder.DB_ban_unban( ckey(key), BANTYPE_ANY_FULLBAN)
	for (var/A in GLOB.banlist.dir)
		GLOB.banlist.cd = "/base/[A]"
		if (key == GLOB.banlist["key"] /*|| id == GLOB.banlist["id"]*/)
			GLOB.banlist.cd = "/base"
			GLOB.banlist.dir.Remove(A)
			continue
	admin_action_message(usr.key, key, "unbanned", "\[Unban\]", 0) //VOREStation Add
	return 1

/proc/GetExp(minutes as num)
	UpdateTime()
	var/exp = minutes - GLOB.c_minutes
	if (exp <= 0)
		return 0
	else
		var/timeleftstring
		if (exp >= 1440) //1440 = 1 day in minutes
			timeleftstring = "[round(exp / 1440, 0.1)] Days"
		else if (exp >= 60) //60 = 1 hour in minutes
			timeleftstring = "[round(exp / 60, 0.1)] Hours"
		else
			timeleftstring = "[exp] Minutes"
		return timeleftstring

/datum/admins/proc/unbanpanel()
	var/count = 0
	var/dat
	//var/dat = "<HR>" + span_bold("Unban Player:") + " " + span_blue("(U) = Unban") + " , (E) = Edit Ban " + span_green("(Total<HR><table border=1 rules=all frame=void cellspacing=0 cellpadding=3 >")
	GLOB.banlist.cd = "/base"
	for (var/A in GLOB.banlist.dir)
		count++
		GLOB.banlist.cd = "/base/[A]"
		var/ref		= "\ref[src]"
		var/key		= GLOB.banlist["key"]
		var/id		= GLOB.banlist["id"]
		var/ip		= GLOB.banlist["ip"]
		var/reason	= GLOB.banlist["reason"]
		var/by		= GLOB.banlist["bannedby"]
		var/expiry
		if(GLOB.banlist["temp"])
			expiry = GetExp(GLOB.banlist["minutes"])
			if(!expiry)		expiry = "Removal Pending"
		else				expiry = "Permaban"

		dat += text("<tr><td><A href='byond://?src=[ref];[HrefToken()];unbanf=[key][id]'>(U)</A><A href='byond://?src=[ref];[HrefToken()];unbane=[key][id]'>(E)</A> Key: <B>[key]</B></td><td>ComputerID: <B>[id]</B></td><td>IP: <B>[ip]</B></td><td> [expiry]</td><td>(By: [by])</td><td>(Reason: [reason])</td></tr>")

	dat += "</table>"
	dat = "<HR>" + span_bold("Bans:") + " " + span_blue("(U) = Unban , (E) = Edit Ban") + " - " + span_green("([count] Bans)") + "<HR><table border=1 rules=all frame=void cellspacing=0 cellpadding=3 >[dat]"

	var/datum/browser/popup = new(owner, "unbanp", "Unban", 875, 400)
	popup.set_content(dat)
	popup.open()

//////////////////////////////////// DEBUG ////////////////////////////////////

/proc/CreateBans()

	UpdateTime()

	var/i
	var/last

	for(i=0, i<1001, i++)
		var/a = pick(1,0)
		var/b = pick(1,0)
		if(b)
			GLOB.banlist.cd = "/base"
			GLOB.banlist.dir.Add("trash[i]trashid[i]")
			GLOB.banlist.cd = "/base/trash[i]trashid[i]"
			to_chat(GLOB.banlist["key"], "trash[i]")
		else
			GLOB.banlist.cd = "/base"
			GLOB.banlist.dir.Add("[last]trashid[i]")
			GLOB.banlist.cd = "/base/[last]trashid[i]"
			GLOB.banlist["key"] << last
		to_chat(GLOB.banlist["id"], "trashid[i]")
		to_chat(GLOB.banlist["reason"], "Trashban[i].")
		GLOB.banlist["temp"] << a
		GLOB.banlist["minutes"] << GLOB.c_minutes + rand(1,2000)
		to_chat(GLOB.banlist["bannedby"], "trashmin")
		last = "trash[i]"

	GLOB.banlist.cd = "/base"

/proc/ClearAllBans()
	GLOB.banlist.cd = "/base"
	for (var/A in GLOB.banlist.dir)
		RemoveBan(A)
