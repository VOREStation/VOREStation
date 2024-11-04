/*
	get_holder_at_turf_level(): Similar to get_turf(), will return the "highest up" holder of this atom, excluding the turf.
	Example: A fork inside a box inside a locker will return the locker. Essentially, get_just_before_turf().
*/ //Credit to /vg/
/proc/get_holder_at_turf_level(const/atom/movable/O)
	if(!istype(O)) //atom/movable does not include areas
		return
	var/atom/A
	for(A=O, A && !isturf(A.loc), A=A.loc);  // semicolon is for the empty statement
	return A

/proc/get_safe_ventcrawl_target(var/obj/machinery/atmospherics/unary/vent_pump/start_vent)
	if(!start_vent.network || !start_vent.network.normal_members.len)
		return
	var/list/vent_list = list()
	for(var/obj/machinery/atmospherics/unary/vent_pump/vent in start_vent.network.normal_members)
		if(vent == start_vent)
			continue
		if(vent.welded)
			continue
		var/area/A = get_area(vent)
		if(A.forbid_events)
			continue
		vent_list += vent
	if(!vent_list.len)
		return
	return pick(vent_list)

/proc/split_into_3(var/total)
	if(!total || !isnum(total))
		return

	var/part1 = rand(0,total)
	var/part2 = rand(0,total)
	var/part3 = total-(part1+part2)

	if(part3<0)
		part1 = total-part1
		part2 = total-part2
		part3 = -part3

	return list(part1, part2, part3)

//Sender is optional
/proc/admin_chat_message(var/message = "Debug Message", var/color = "#FFFFFF", var/sender)
	if (!CONFIG_GET(string/chat_webhook_url) || !message)
		return
	spawn(0)
		var/query_string = "type=adminalert"
		query_string += "&key=[url_encode(CONFIG_GET(string/chat_webhook_key))]"
		query_string += "&msg=[url_encode(message)]"
		query_string += "&color=[url_encode(color)]"
		if(sender)
			query_string += "&from=[url_encode(sender)]"
		world.Export("[CONFIG_GET(string/chat_webhook_url)]?[query_string]")

/proc/admin_action_message(var/admin = "INVALID", var/user = "INVALID", var/action = "INVALID", var/reason = "INVALID", var/time = "INVALID")
	if (!CONFIG_GET(string/chat_webhook_url) || !action)
		return
	spawn(0)
		var/query_string = "type=adminaction"
		query_string += "&key=[url_encode(CONFIG_GET(string/chat_webhook_key))]"
		query_string += "&admin=[url_encode(admin)]"
		query_string += "&user=[url_encode(user)]"
		query_string += "&action=[url_encode(action)]"
		query_string += "&reason=[url_encode(reason)]"
		query_string += "&time=[url_encode(time)]"
		world.Export("[CONFIG_GET(string/chat_webhook_url)]?[query_string]")
