/proc/attacklog_insert(mob/log_target, message, color)
	set waitfor = FALSE
	if(!ismob(log_target))
		return
	if(!SSdbcore.IsConnected())
		LAZYADD(log_target.attack_log, text("\[[time_stamp()]\] [key_name(log_target)] <font color=[color]>[message]</font>"))
		return

	var/datum/db_query/query_insert = SSdbcore.NewQuery("INSERT INTO erro_attacklog (id, time, ckey, mob, color, message) VALUES (null, NOW(), :t_ckey, :t_mob, :t_color, :t_content)",
		list("t_ckey" = log_target.ckey, "t_mob" = log_target.real_name, "t_color" = color, "t_content" = "[message]"))
	if(!query_insert.Execute())
		log_sql("Error during logging: "+query_insert.ErrorMsg())
		qdel(query_insert)
		return
	qdel(query_insert)

/proc/dialoglog_insert(mob/log_target, message, type, color)
	set waitfor = FALSE
	if(!ismob(log_target))
		return
	if(!SSdbcore.IsConnected())
		var/colored_message = message
		if(color)
			if(color[1] == "#")
				colored_message = "<font color=[color]>[message]</font>"
			else
				colored_message = "<font color='[color]'>[message]</font>"
		LAZYADD(log_target.dialogue_log, "([type]) " + colored_message)
		return
	var/datum/db_query/query_insert = SSdbcore.NewQuery("INSERT INTO erro_dialog (mid, time, ckey, mob, type, color, message) VALUES (null, NOW(), :sender_ckey, :sender_mob, :message_type, :message_color, :message_content)",
		list("sender_ckey" = log_target.ckey, "sender_mob" = log_target.real_name, "message_type" = "[type]", "message_color" = color, "message_content" = message))
	if(!query_insert.Execute())
		log_sql("Error during logging: "+query_insert.ErrorMsg())
		qdel(query_insert)
		return
	qdel(query_insert)
