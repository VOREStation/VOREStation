ADMIN_VERB(get_server_logs, (R_ADMIN | R_SERVER), "Get Server Logs", "View or retrieve logfiles.", ADMIN_CATEGORY_MAIN)
	user.browseserverlogs()

ADMIN_VERB(get_current_logs, (R_ADMIN | R_SERVER), "Get Current Logs", "View or retrieve logfiles for the current round.", ADMIN_CATEGORY_MAIN)
	user.browseserverlogs(current=TRUE)

/client/proc/browseserverlogs(current=FALSE)
	var/path = browse_files(current ? BROWSE_ROOT_CURRENT_LOGS : BROWSE_ROOT_ALL_LOGS)
	if(!path)
		return

	if(file_spam_check())
		return

	message_admins("[key_name_admin(src)] accessed file: [path]")
	feedback_add_details("admin_verb","VTL") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

	switch(tgui_alert(usr,"View (in game), Open (in your system's text editor), or Download?", path, list("View", "Open", "Download")))
		if ("View")
			src << browse(HTML_SKELETON("<pre style='word-wrap: break-word;'>[html_encode(file2text(file(path)))]</pre>"), list2params(list("window" = "viewfile.[path]")))
		if ("Open")
			src << run(file(path))
		if ("Download")
			src << ftp(file(path))
		else
			return
	to_chat(src, "Attempting to send [path], this may take a fair few minutes if the file is very large.", confidential = TRUE)
