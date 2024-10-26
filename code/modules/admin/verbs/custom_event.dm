// verb for admins to set custom event
/client/proc/cmd_admin_change_custom_event()
	set category = "Fun"
	set name = "Change Custom Event"

	if(!holder)
		to_chat(src, "Only administrators may use this command.")
		return

	var/input = sanitize(tgui_input_text(usr, "Enter the description of the custom event. Be descriptive. To cancel the event, make this blank or hit cancel.", "Custom Event", custom_event_msg, MAX_PAPER_MESSAGE_LEN, TRUE, prevent_enter = TRUE), MAX_PAPER_MESSAGE_LEN, extra = 0)
	if(!input || input == "")
		custom_event_msg = null
		log_admin("[usr.key] has cleared the custom event text.")
		message_admins("[key_name_admin(usr)] has cleared the custom event text.")
		return

	log_admin("[usr.key] has changed the custom event text.")
	message_admins("[key_name_admin(usr)] has changed the custom event text.")

	custom_event_msg = input

	to_world(span_filter_system("<h1>[span_alert("Custom Event")]</h1>"))
	to_world(span_filter_system("<h2>[span_alert("A custom event is starting. OOC Info:")]</h2>"))
	to_world(span_filter_system(span_alert("[custom_event_msg]")))
	to_world(span_filter_system("<br>"))

	SSwebhooks.send(
		WEBHOOK_CUSTOM_EVENT,
		list(
			"text" = custom_event_msg,
		)
	)

// normal verb for players to view info
/client/verb/cmd_view_custom_event()
	set category = "OOC"
	set name = "Custom Event Info"

	if(!custom_event_msg || custom_event_msg == "")
		to_chat(src, span_filter_notice("There currently is no known custom event taking place."))
		to_chat(src, span_filter_notice("Keep in mind: it is possible that an admin has not properly set this."))
		return

	to_chat(src, "<h1>[span_filter_notice(span_alert("Custom Event"))]</h1>")
	to_chat(src, "<h2>[span_filter_notice(span_alert("A custom event is taking place. OOC Info:"))]</h2>")
	to_chat(src, span_filter_notice(span_alert("[custom_event_msg]<br>")))
