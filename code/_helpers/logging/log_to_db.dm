/proc/db_log_insert(mob/log_target, message, type, color)
	set waitfor = FALSE
	if(!ismob(log_target))
		return
	if(!SSdbcore.IsConnected())
		return
	var/datum/db_query/query_insert = SSdbcore.NewQuery("INSERT INTO erro_dialog (mid, time, ckey, mob, area, type, color, message) VALUES (null, NOW(), :sender_ckey, :sender_mob, :message_area, :message_type, :message_color, :message_content)",
		list("sender_ckey" = log_target.ckey, "sender_mob" = log_target.real_name, "message_area" = "[loc_name(log_target)]", "message_type" = "[type]", "message_color" = color, "message_content" = message))
	if(!query_insert.Execute())
		log_sql("Error during logging: "+query_insert.ErrorMsg())
		qdel(query_insert)
		return
	qdel(query_insert)
