/client
	var/datum/managed_browser/feedback_viewer/feedback_viewer = null

/datum/admins/proc/view_feedback()
	set category = "Admin.Misc"
	set name = "View Feedback"
	set desc = "Open the Feedback Viewer"

	if(!check_rights(R_ADMIN|R_DEBUG|R_EVENT))
		return

	if(usr.client.feedback_viewer)
		usr.client.feedback_viewer.display()
	else
		usr.client.feedback_viewer = new(usr.client)

// This object holds the code to run the admin feedback viewer.
/datum/managed_browser/feedback_viewer
	base_browser_id = "feedback_viewer"
	title = "Submitted Feedback"
	size_x = 900
	size_y = 500
	var/database/query/last_query = null

/datum/managed_browser/feedback_viewer/New(client/new_client)
	if(!check_rights(R_ADMIN|R_DEBUG|R_EVENT, new_client)) // Just in case someone figures out a way to spawn this as non-staff.
		message_admins("[new_client] tried to view feedback with insufficent permissions.")
		qdel(src)

	..()

/datum/managed_browser/feedback_viewer/Destroy()
	if(my_client)
		my_client.feedback_viewer = null
	return ..()

/datum/managed_browser/feedback_viewer/proc/feedback_filter(row_name, thing_to_find, exact = FALSE)
	var/database/query/query = null
	if(exact) // Useful for ID searches, so searching for 'id 10' doesn't also get 'id 101'.
		query = new({"
			SELECT *
			FROM [SQLITE_TABLE_FEEDBACK]
			WHERE [row_name] == ?
			ORDER BY [SQLITE_FEEDBACK_COLUMN_ID]
			DESC LIMIT 50;
		"},
		thing_to_find
		)

	else
		// Wrap the thing in %s so LIKE will work.
		thing_to_find = "%[thing_to_find]%"
		query = new({"
			SELECT *
			FROM [SQLITE_TABLE_FEEDBACK]
			WHERE [row_name] LIKE ?
			ORDER BY [SQLITE_FEEDBACK_COLUMN_ID]
			DESC LIMIT 50;
		"},
		thing_to_find
		)
	query.Execute(SSsqlite.sqlite_db)
	SSsqlite.sqlite_check_for_errors(query, "Admin Feedback Viewer - Filter by [row_name] to find [thing_to_find]")
	return query

// Builds the window for players to review their feedback.
/datum/managed_browser/feedback_viewer/get_html()
	var/list/dat = list("<html><body>")
	if(!last_query) // If no query was done before, just show the most recent feedbacks.
		var/database/query/query = new({"
			SELECT *
			FROM [SQLITE_TABLE_FEEDBACK]
			ORDER BY [SQLITE_FEEDBACK_COLUMN_ID]
			DESC LIMIT 50;
			"}
			)
		query.Execute(SSsqlite.sqlite_db)
		SSsqlite.sqlite_check_for_errors(query, "Admin Feedback Viewer")
		last_query = query

	dat += "<table border='1' style='width:100%'>"
	dat += "<tr>"
	dat += "<th>[href(src, list("filter_id" = 1), "ID")]</th>"
	dat += "<th>[href(src, list("filter_topic" = 1), "Topic")]</th>"
	dat += "<th>[href(src, list("filter_author" = 1), "Author")]</th>"
	dat += "<th>[href(src, list("filter_content" = 1), "Content")]</th>"
	dat += "<th>[href(src, list("filter_datetime" = 1), "Datetime")]</th>"
	dat += "</tr>"

	while(last_query.NextRow())
		var/list/row_data = last_query.GetRowData()
		dat += "<tr>"
		dat += "<td>[row_data[SQLITE_FEEDBACK_COLUMN_ID]]</td>"
		dat += "<td>[row_data[SQLITE_FEEDBACK_COLUMN_TOPIC]]</td>"
		dat += "<td>[row_data[SQLITE_FEEDBACK_COLUMN_AUTHOR]]</td>" // TODO: Color this to make hashed keys more distinguishable.
		var/text = row_data[SQLITE_FEEDBACK_COLUMN_CONTENT]
		if(length(text) > 512)
			text = href(src, list(
				"show_full_feedback" = 1,
				"feedback_author" = row_data[SQLITE_FEEDBACK_COLUMN_AUTHOR],
				"feedback_content" = row_data[SQLITE_FEEDBACK_COLUMN_CONTENT]
				), "[copytext(text, 1, 64)]... ([length(text)])")
		else
			text = replacetext(text, "\n", "<br>")
		dat += "<td>[text]</td>"
		dat += "<td>[row_data[SQLITE_FEEDBACK_COLUMN_DATETIME]]</td>"
		dat += "</tr>"
	dat += "</table>"

	dat += "</body></html>"
	return dat.Join()

// Used to show the full version of feedback in a seperate window.
/datum/managed_browser/feedback_viewer/proc/display_big_feedback(author, text)
	var/list/dat = list("<html><body>")
	dat += replacetext(text, "\n", "<br>")

	var/datum/browser/popup = new(my_client.mob, "feedback_big", "[author]'s Feedback", 480, 520, src)
	popup.set_content(dat.Join())
	popup.open()


/datum/managed_browser/feedback_viewer/Topic(href, href_list[])
	if(!my_client)
		return FALSE

	if(href_list["close"]) // To avoid refreshing.
		return

	if(href_list["show_full_feedback"])
		display_big_feedback(href_list["feedback_author"], href_list["feedback_content"])
		return

	if(href_list["filter_id"])
		var/id_to_search = tgui_input_number(my_client, "Write feedback ID here.", "Filter by ID", null)
		if(id_to_search)
			last_query = feedback_filter(SQLITE_FEEDBACK_COLUMN_ID, id_to_search, TRUE)

	if(href_list["filter_author"])
		var/author_to_search = tgui_input_text(my_client, "Write desired key or hash here. Partial keys/hashes are allowed.", "Filter by Author", null)
		if(author_to_search)
			last_query = feedback_filter(SQLITE_FEEDBACK_COLUMN_AUTHOR, author_to_search)

	if(href_list["filter_topic"])
		var/topic_to_search = tgui_input_text(my_client, "Write desired topic here. Partial topics are allowed. \
		\nThe current topics in the config are [english_list(CONFIG_GET(str_list/sqlite_feedback_topics))].", "Filter by Topic", null)
		if(topic_to_search)
			last_query = feedback_filter(SQLITE_FEEDBACK_COLUMN_TOPIC, topic_to_search)

	if(href_list["filter_content"])
		var/content_to_search = tgui_input_text(my_client, "Write desired content to find here. Partial matches are allowed.", "Filter by Content", null, multiline = TRUE)
		if(content_to_search)
			last_query = feedback_filter(SQLITE_FEEDBACK_COLUMN_CONTENT, content_to_search)

	if(href_list["filter_datetime"])
		var/datetime_to_search = tgui_input_text(my_client, "Write desired datetime. Partial matches are allowed.\n\
		Format is 'YYYY-MM-DD HH:MM:SS'.", "Filter by Datetime", null)
		if(datetime_to_search)
			last_query = feedback_filter(SQLITE_FEEDBACK_COLUMN_DATETIME, datetime_to_search)

	// Refresh.
	display()
