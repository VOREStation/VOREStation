// verb for admins to set custom event
ADMIN_VERB(cmd_admin_change_custom_event, R_ADMIN|R_FUN|R_SERVER|R_EVENT, "Change Custom Event", "Change custom event message.", ADMIN_CATEGORY_FUN_EVENT_KIT)
	var/input = tgui_input_text(user, "Enter the description of the custom event. Be descriptive. To cancel the event, make this blank or hit cancel.", "Custom Event", GLOB.custom_event_msg, MAX_PAPER_MESSAGE_LEN, TRUE, prevent_enter = TRUE)
	if(isnull(input))
		return
	if(input == "")
		GLOB.custom_event_msg = null
		log_and_message_admins("has cleared the custom event text.", user)
		return

	log_and_message_admins("has changed the custom event text.", user)

	GLOB.custom_event_msg = input

	to_chat(world, span_filter_system("<h1>[span_alert("Custom Event")]</h1>"))
	to_chat(world, span_filter_system("<h2>[span_alert("A custom event is starting. OOC Info:")]</h2>"))
	to_chat(world, span_filter_system(span_alert("[GLOB.custom_event_msg]")))
	to_chat(world, span_filter_system("<br>"))

// normal verb for players to view info
/client/verb/cmd_view_custom_event()
	set category = "OOC.Game"
	set name = "Custom Event Info"

	if(!GLOB.custom_event_msg || GLOB.custom_event_msg == "")
		to_chat(src, span_filter_notice("There currently is no known custom event taking place."))
		to_chat(src, span_filter_notice("Keep in mind: it is possible that an admin has not properly set this."))
		return

	to_chat(src, "<h1>[span_filter_notice(span_alert("Custom Event"))]</h1>")
	to_chat(src, "<h2>[span_filter_notice(span_alert("A custom event is taking place. OOC Info:"))]</h2>")
	to_chat(src, span_filter_notice(span_alert("[GLOB.custom_event_msg]<br>")))
