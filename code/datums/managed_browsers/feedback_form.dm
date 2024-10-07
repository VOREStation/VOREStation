/client
	var/datum/managed_browser/feedback_form/feedback_form = null

/client/can_vv_get(var_name)
	return var_name != NAMEOF(src, feedback_form) // No snooping.

GENERAL_PROTECT_DATUM(/datum/managed_browser/feedback_form)

// A fairly simple object to hold information about a player's feedback as it's being written.
// Having this be it's own object instead of being baked into /mob/new_player allows for it to be used
// from other places than just the lobby, and makes it a lot harder for people with dev powers to be naughty with it using VV/proccall.
/datum/managed_browser/feedback_form
	base_browser_id = "feedback_form"
	title = "Server Feedback"
	size_x = 480
	size_y = 520
	var/feedback_topic = null
	var/feedback_body = null
	var/feedback_hide_author = FALSE

/datum/managed_browser/feedback_form/New(client/new_client)
	feedback_topic = config.sqlite_feedback_topics[1]
	..(new_client)

/datum/managed_browser/feedback_form/Destroy()
	if(my_client)
		my_client.feedback_form = null
	return ..()

// Privacy option is allowed if both the config allows it, and the pepper file exists and isn't blank.
/datum/managed_browser/feedback_form/proc/can_be_private()
	return config.sqlite_feedback_privacy && SSsqlite.get_feedback_pepper()

/datum/managed_browser/feedback_form/display()
	if(!my_client)
		return
	if(!SSsqlite.can_submit_feedback(my_client))
		return
	..()

// Builds the window for players to review their feedback.
/datum/managed_browser/feedback_form/get_html()
	var/list/dat = list("<html><body>")
	dat += "<center>"
	dat += "<font size='2'>"
	dat += "Here, you can write some feedback for the server.<br>"
	dat += "Note that HTML is NOT supported!<br>"
	dat += "Click the edit button to begin writing.<br>"

	dat += "Your feedback is currently [length(feedback_body)]/[MAX_FEEDBACK_LENGTH] letters long."
	dat += "</font>"
	dat += "<hr>"

	dat += "<h2>Preview</h2></center>"

	dat += "Author: "

	if(can_be_private())
		if(!feedback_hide_author)
			dat += "[my_client.ckey] "
			dat += span_linkOn(span_bold("Visible"))
			dat += " | "
			dat += href(src, list("feedback_hide_author" = 1), "Hashed")
		else
			dat += "[md5(ckey(lowertext(my_client.ckey + SSsqlite.get_feedback_pepper())))] "
			dat += href(src, list("feedback_hide_author" = 0), "Visible")
			dat += " | "
			dat += span_linkOn(span_bold("Hashed"))
	else
		dat += my_client.ckey
	dat += "<br>"

	if(config.sqlite_feedback_topics.len > 1)
		dat += "Topic: [href(src, list("feedback_choose_topic" = 1), feedback_topic)]<br>"
	else
		dat += "Topic: [config.sqlite_feedback_topics[1]]<br>"

	dat += "<br>"
	if(feedback_body)
		dat += replacetext(feedback_body, "\n", "<br>") // So newlines will look like they work in the preview.
	else
		dat += span_italics("\[Feedback goes here...\]")
	dat += "<br>"
	dat += href(src, list("feedback_edit_body" = 1), "Edit")
	dat += "<hr>"

	if(config.sqlite_feedback_cooldown)
		dat += "<i>Please note that you will have to wait [config.sqlite_feedback_cooldown] day\s before \
		being able to write more feedback after submitting.</i><br>"

	dat += href(src, list("feedback_submit" = 1), "Submit")
	dat += "</body></html>"
	return dat.Join()

/datum/managed_browser/feedback_form/Topic(href, href_list[])
	if(!my_client)
		return FALSE

	if(href_list["feedback_edit_body"])
		// This is deliberately not sanitized here, and is instead checked when hitting the submission button,
		// as we want to give the user a chance to fix it without needing to rewrite the whole thing.
		feedback_body = tgui_input_text(my_client, "Please write your feedback here.", "Feedback Body", feedback_body, multiline = TRUE, prevent_enter = TRUE)
		display() // Refresh the window with new information.
		return

	if(href_list["feedback_hide_author"])
		if(!can_be_private())
			feedback_hide_author = FALSE
		else
			feedback_hide_author = text2num(href_list["feedback_hide_author"])
		display()
		return

	if(href_list["feedback_choose_topic"])
		feedback_topic = tgui_input_list(my_client, "Choose the topic you want to submit your feedback under.", "Feedback Topic", config.sqlite_feedback_topics)
		display()
		return

	if(href_list["feedback_submit"])
		// Do some last minute validation, and tell the user if something goes wrong,
		// so we don't wipe out their ten thousand page essay due to having a few too many characters.
		if(length(feedback_body) > MAX_FEEDBACK_LENGTH)
			to_chat(my_client, span_warning("Your feedback is too long, at [length(feedback_body)] characters, where as the \
			limit is [MAX_FEEDBACK_LENGTH]. Please shorten it and try again."))
			return

		var/text = sanitize(feedback_body, max_length = 0, encode = TRUE, trim = FALSE, extra = FALSE)
		if(!text) // No text, or it was super invalid.
			to_chat(my_client, span_warning("It appears you didn't write anything, or it was invalid."))
			return

		if(tgui_alert(my_client, "Are you sure you want to submit your feedback?", "Confirm Submission", list("No", "Yes")) == "Yes")
			var/author_text = my_client.ckey
			if(can_be_private() && feedback_hide_author)
				author_text = md5(my_client.ckey + SSsqlite.get_feedback_pepper())

			var/success = SSsqlite.insert_feedback(author = author_text, topic = feedback_topic, content = feedback_body, sqlite_object = SSsqlite.sqlite_db)
			if(!success)
				to_chat(my_client, span_warning("Something went wrong while inserting your feedback into the database. Please try again. \
				If this happens again, you should contact a developer."))
				return

			my_client.mob << browse(null, "window=[browser_id]") // Closes the window.
			if(istype(my_client.mob, /mob/new_player))
				var/mob/new_player/NP = my_client.mob
				NP.new_player_panel_proc() // So the feedback button goes away, if the user gets put on cooldown.
			qdel(src)
