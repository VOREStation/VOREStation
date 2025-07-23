
//Either pass the mob you wish to ban in the 'banned_mob' attribute, or the banckey, banip and bancid variables. If both are passed, the mob takes priority! If a mob is not passed, banckey is the minimum that needs to be passed! banip and bancid are optional.
/datum/admins/proc/DB_ban_record(var/bantype, var/mob/banned_mob, var/duration = -1, var/reason, var/job = "", var/rounds = 0, var/banckey = null, var/banip = null, var/bancid = null)

	if(!check_rights(R_MOD,0) && !check_rights(R_BAN))	return

	establish_db_connection()
	if(!SSdbcore.IsConnected())
		return

	var/serverip = "[world.internet_address]:[world.port]"
	var/bantype_pass = 0
	var/bantype_str
	switch(bantype)
		if(BANTYPE_PERMA)
			bantype_str = "PERMABAN"
			duration = -1
			bantype_pass = 1
		if(BANTYPE_TEMP)
			bantype_str = "TEMPBAN"
			bantype_pass = 1
		if(BANTYPE_JOB_PERMA)
			bantype_str = "JOB_PERMABAN"
			duration = -1
			bantype_pass = 1
		if(BANTYPE_JOB_TEMP)
			bantype_str = "JOB_TEMPBAN"
			bantype_pass = 1
	if( !bantype_pass ) return
	if( !istext(reason) ) return
	if( !isnum(duration) ) return

	var/ckey
	var/computerid
	var/ip

	if(ismob(banned_mob))
		ckey = banned_mob.ckey
		if(banned_mob.client)
			computerid = banned_mob.client.computer_id
			ip = banned_mob.client.address
	else if(banckey)
		ckey = ckey(banckey)
		computerid = bancid
		ip = banip

	var/datum/db_query/query = SSdbcore.NewQuery("SELECT id FROM erro_player WHERE ckey = '[ckey]'")
	query.Execute()
	var/validckey = 0
	if(query.NextRow())
		validckey = 1
	qdel(query)
	if(!validckey)
		if(!banned_mob || (banned_mob && !IsGuestKey(banned_mob.key))) //VOREStation Edit Start.
			var/confirm = tgui_alert(usr, "This ckey hasn't been seen, are you sure?", "Confirm Badmin", list("Yes", "No"))
			if(confirm != "Yes")
				return //VOREStation Edit End

	var/a_ckey
	var/a_computerid
	var/a_ip

	if(src.owner && istype(src.owner, /client))
		a_ckey = src.owner:ckey
		a_computerid = src.owner:computer_id
		a_ip = src.owner:address

	var/who
	for(var/client/C in GLOB.clients)
		if(!who)
			who = "[C]"
		else
			who += ", [C]"

	var/adminwho
	for(var/client/C in GLOB.admins)
		if(!adminwho)
			adminwho = "[C]"
		else
			adminwho += ", [C]"

	reason = sql_sanitize_text(reason)

	var/sql = "INSERT INTO erro_ban (`id`,`bantime`,`serverip`,`bantype`,`reason`,`job`,`duration`,`rounds`,`expiration_time`,`ckey`,`computerid`,`ip`,`a_ckey`,`a_computerid`,`a_ip`,`who`,`adminwho`,`edits`,`unbanned`,`unbanned_datetime`,`unbanned_ckey`,`unbanned_computerid`,`unbanned_ip`) VALUES (null, Now(), '[serverip]', '[bantype_str]', '[reason]', '[job]', [(duration)?"[duration]":"0"], [(rounds)?"[rounds]":"0"], Now() + INTERVAL [(duration>0) ? duration : 0] MINUTE, '[ckey]', '[computerid]', '[ip]', '[a_ckey]', '[a_computerid]', '[a_ip]', '[who]', '[adminwho]', '', null, null, null, null, null)"
	var/datum/db_query/query_insert = SSdbcore.NewQuery(sql)
	query_insert.Execute()
	to_chat(usr, span_filter_adminlog("[span_blue("Ban saved to database.")]"))
	message_admins("[key_name_admin(usr)] has added a [bantype_str] for [ckey] [(job)?"([job])":""] [(duration > 0)?"([duration] minutes)":""] with the reason: \"[reason]\" to the ban database.",1)
	qdel(query_insert)


/datum/admins/proc/DB_ban_unban(var/ckey, var/bantype, var/job = "")

	if(!check_rights(R_BAN))
		return

	var/bantype_str
	if(bantype)
		var/bantype_pass = 0
		switch(bantype)
			if(BANTYPE_PERMA)
				bantype_str = "PERMABAN"
				bantype_pass = 1
			if(BANTYPE_TEMP)
				bantype_str = "TEMPBAN"
				bantype_pass = 1
			if(BANTYPE_JOB_PERMA)
				bantype_str = "JOB_PERMABAN"
				bantype_pass = 1
			if(BANTYPE_JOB_TEMP)
				bantype_str = "JOB_TEMPBAN"
				bantype_pass = 1
			if(BANTYPE_ANY_FULLBAN)
				bantype_str = "ANY"
				bantype_pass = 1
		if(!bantype_pass)
			return

	var/bantype_sql
	if(bantype_str == "ANY")
		bantype_sql = "(bantype = 'PERMABAN' OR (bantype = 'TEMPBAN' AND expiration_time > Now() ) )"
	else
		bantype_sql = "bantype = '[bantype_str]'"

	var/sql = "SELECT id FROM erro_ban WHERE ckey = '[ckey]' AND [bantype_sql] AND (unbanned is null OR unbanned = false)"
	if(job)
		sql += " AND job = '[job]'"

	establish_db_connection()
	if(!SSdbcore.IsConnected())
		return

	var/ban_id
	var/ban_number = 0 //failsafe

	var/datum/db_query/query = SSdbcore.NewQuery(sql)
	query.Execute()
	while(query.NextRow())
		ban_id = query.item[1]
		ban_number++;
	qdel(query)

	if(ban_number == 0)
		to_chat(usr, span_filter_adminlog("[span_red("Database update failed due to no bans fitting the search criteria. If this is not a legacy ban you should contact the database admin.")]"))
		return

	if(ban_number > 1)
		to_chat(usr, span_filter_adminlog("[span_red("Database update failed due to multiple bans fitting the search criteria. Note down the ckey, job and current time and contact the database admin.")]"))
		return

	if(istext(ban_id))
		ban_id = text2num(ban_id)
	if(!isnum(ban_id))
		to_chat(usr, span_filter_adminlog("[span_red("Database update failed due to a ban ID mismatch. Contact the database admin.")]"))
		return

	DB_ban_unban_by_id(ban_id)

/datum/admins/proc/DB_ban_edit(client/user, var/banid = null, var/param = null)

	if(!check_rights_for(user, R_BAN))
		return

	if(!isnum(banid) || !istext(param))
		to_chat(user, "Cancelled")
		return

	var/datum/db_query/query = SSdbcore.NewQuery("SELECT ckey, duration, reason FROM erro_ban WHERE id = [banid]")
	query.Execute()

	var/eckey = usr.ckey	//Editing admin ckey
	var/pckey				//(banned) Player ckey
	var/duration			//Old duration
	var/reason				//Old reason

	if(query.NextRow())
		pckey = query.item[1]
		duration = query.item[2]
		reason = query.item[3]
	else
		to_chat(user, span_filter_adminlog("Invalid ban id. Contact the database admin"))
		qdel(query)
		return

	qdel(query)
	reason = sql_sanitize_text(reason)
	var/value

	switch(param)
		if("reason")
			if(!value)
				value = sanitize(tgui_input_text(user, "Insert the new reason for [pckey]'s ban", "New Reason", "[reason]", null))
				value = sql_sanitize_text(value)
				if(!value)
					to_chat(user, "Cancelled")
					return

			var/datum/db_query/update_query = SSdbcore.NewQuery("UPDATE erro_ban SET reason = '[value]', edits = CONCAT(edits,'- [eckey] changed ban reason from <cite><b>\\\"[reason]\\\"</b></cite> to <cite><b>\\\"[value]\\\"</b></cite><BR>') WHERE id = [banid]")
			update_query.Execute()
			message_admins("[key_name_admin(user)] has edited a ban for [pckey]'s reason from [reason] to [value]",1)
			qdel(update_query)
			return
		if("duration")
			if(!value)
				value = tgui_input_number(user, "Insert the new duration (in minutes) for [pckey]'s ban", "New Duration", "[duration]", null)
				if(!isnum(value) || !value)
					to_chat(user, "Cancelled")
					return

			var/datum/db_query/update_query = SSdbcore.NewQuery("UPDATE erro_ban SET duration = [value], edits = CONCAT(edits,'- [eckey] changed ban duration from [duration] to [value]<br>'), expiration_time = DATE_ADD(bantime, INTERVAL [value] MINUTE) WHERE id = [banid]")
			message_admins("[key_name_admin(user)] has edited a ban for [pckey]'s duration from [duration] to [value]",1)
			update_query.Execute()
			qdel(update_query)
			return
		if("unban")
			if(tgui_alert(user, "Unban [pckey]?", "Unban?", list("Yes", "No")) == "Yes")
				DB_ban_unban_by_id(banid)
				return
	to_chat(user, span_filter_adminlog("Cancelled"))
	return

/datum/admins/proc/DB_ban_unban_by_id(var/id)

	if(!check_rights(R_BAN))	return

	var/sql = "SELECT ckey FROM erro_ban WHERE id = [id]"

	establish_db_connection()
	if(!SSdbcore.IsConnected())
		return

	var/ban_number = 0 //failsafe

	var/pckey
	var/datum/db_query/query = SSdbcore.NewQuery(sql)
	query.Execute()
	while(query.NextRow())
		pckey = query.item[1]
		ban_number++;
	qdel(query)
	if(ban_number == 0)
		to_chat(usr, span_filter_adminlog("[span_red("Database update failed due to a ban id not being present in the database.")]"))
		return

	if(ban_number > 1)
		to_chat(usr, span_filter_adminlog("[span_red("Database update failed due to multiple bans having the same ID. Contact the database admin.")]"))
		return

	if(!src.owner || !istype(src.owner, /client))
		return

	var/unban_ckey = src.owner:ckey
	var/unban_computerid = src.owner:computer_id
	var/unban_ip = src.owner:address

	var/sql_update = "UPDATE erro_ban SET unbanned = 1, unbanned_datetime = Now(), unbanned_ckey = '[unban_ckey]', unbanned_computerid = '[unban_computerid]', unbanned_ip = '[unban_ip]' WHERE id = [id]"
	message_admins("[key_name_admin(usr)] has lifted [pckey]'s ban.",1)

	var/datum/db_query/query_update = SSdbcore.NewQuery(sql_update)
	query_update.Execute()
	qdel(query_update)


/client/proc/DB_ban_panel()
	set category = "Admin.Moderation"
	set name = "Banning Panel"
	set desc = "Edit admin permissions"

	if(!holder)
		return

	holder.DB_ban_panel(src)


/datum/admins/proc/DB_ban_panel(client/user, var/playerckey = null)
	if(!user)
		return

	if(!check_rights_for(user, R_BAN))
		return

	establish_db_connection()
	if(!SSdbcore.IsConnected())
		to_chat(usr, span_filter_adminlog("[span_red("Failed to establish database connection")]"))
		return

	var/datum/tgui_ban_panel/tgui = new(user, playerckey, src)
	tgui.tgui_interact(user.mob)
