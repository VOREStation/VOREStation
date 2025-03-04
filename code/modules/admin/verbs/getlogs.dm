/*
	HOW DO I LOG RUNTIMES?
	Firstly, start dreamdeamon if it isn't already running. Then select "world>Log Session" (or press the F3 key)
	navigate the popup window to the data/logs/runtime/ folder from where your tgstation .dmb is located.
	(you may have to make this folder yourself)

	OPTIONAL: 	you can select the little checkbox down the bottom to make dreamdeamon save the log everytime you
				start a world. Just remember to repeat these steps with a new name when you update to a new revision!

	Save it with the name of the revision your server uses (e.g. r3459.txt).
	Game Masters will now be able to grant access any runtime logs you have archived this way!
	This will allow us to gather information on bugs across multiple servers and make maintaining the TG
	codebase for the entire /TG/station commuity a TONNE easier :3 Thanks for your help!
*/


//This proc allows Game Masters to grant a client access to the .getruntimelog verb
//Permissions expire at the end of each round.
//Runtimes can be used to meta or spot game-crashing exploits so it's advised to only grant coders that
//you trust access. Also, it may be wise to ensure that they are not going to play in the current round.
/client/proc/giveruntimelog()
	set name = "Give Runtime Log"
	set desc = "Give somebody access to any session logfiles saved to the /log/runtime/ folder."
	set category = "Admin.Logs"

	if(!src.holder)
		to_chat(src, span_red("Only Admins may use this command."))
		return

	var/client/target = tgui_input_list(src,"Choose somebody to grant access to the server's runtime logs (permissions expire at the end of each round):","Grant Permissions", GLOB.clients)
	if(!istype(target,/client))
		to_chat(src, span_red("Error: giveruntimelog(): Client not found."))
		return

	add_verb(target, /client/proc/getruntimelog)
	to_chat(target, span_red("You have been granted access to runtime logs. Please use them responsibly or risk being banned."))
	return


//This proc allows download of runtime logs saved within the data/logs/ folder by dreamdeamon.
//It works similarly to show-server-log.
/client/proc/getruntimelog()
	set name = "Get runtime logs"
	set desc = "Retrieve any session logfiles saved by dreamdeamon."
	set category = "Admin.Logs"
	browseserverlogs(FALSE, TRUE)

//This proc allows download of past server logs saved within the data/logs/ folder.
//It works similarly to show-server-log.
/client/proc/getserverlog()
	set name = "Get server logs"
	set desc = "Fetch logfiles from data/logs"
	set category = "Admin.Logs"
	browseserverlogs()


/client/proc/browseserverlogs(current=FALSE, runtimes=FALSE)
	var/log_choice = BROWSE_ROOT_ALL_LOGS
	if(current)
		log_choice = BROWSE_ROOT_CURRENT_LOGS
	else if (runtimes)
		log_choice = BROWSE_ROOT_RUNTIME_LOGS
	var/path = browse_files(log_choice)
	feedback_add_details("admin_verb","VTL") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	if(!path)
		return

	if(file_spam_check())
		return

	message_admins("[key_name_admin(src)] accessed file: [path]")
	switch(tgui_alert(src,"View (in game), Open (in your system's text editor), or Download?", path, list("View", "Open", "Download")))
		if ("View")
			src << browse("<html><pre style='word-wrap: break-word;'>[html_encode(file2text(file(path)))]</pre></html>", list2params(list("window" = "viewfile.[path]")))
		if ("Open")
			src << run(file(path))
		if ("Download")
			src << ftp(file(path))
		else
			return
	to_chat(src, "Attempting to send [path], this may take a fair few minutes if the file is very large.", confidential = TRUE)
