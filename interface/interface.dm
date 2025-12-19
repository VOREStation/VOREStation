//Please use mob or src (not usr) in these procs. This way they can be called in the same fashion as procs.
/client/verb/wiki(query as text)
	set name = "wiki"
	set desc = "Type what you want to know about.  This will open the wiki on your web browser."
	set category = "OOC.Resources"
	if(CONFIG_GET(string/wikiurl))
		if(query)
			if(CONFIG_GET(string/wikisearchurl))
				var/output = replacetext(CONFIG_GET(string/wikisearchurl), "%s", url_encode(query))
				src << link(output)
			else
				to_chat(src, span_warning(" The wiki search URL is not set in the server configuration."))
		else
			src << link(CONFIG_GET(string/wikiurl))
	else
		to_chat(src, span_warning("The wiki URL is not set in the server configuration."))
		return

/client/verb/forum()
	set name = "forum"
	set desc = "Visit the forum."
	set hidden = 1
	if(CONFIG_GET(string/forumurl))
		if(tgui_alert(usr, "This will open the forum in your browser. Are you sure?","Visit Website",list("Yes","No")) != "Yes")
			return
		src << link(CONFIG_GET(string/forumurl))
	else
		to_chat(src, span_warning("The forum URL is not set in the server configuration."))
		return

/client/verb/rules()
	set name = "Rules"
	set desc = "Show Server Rules."
	set hidden = 1

	if(CONFIG_GET(string/rulesurl))
		if(tgui_alert(usr, "This will open the rules in your browser. Are you sure?","Visit Website",list("Yes","No")) != "Yes")
			return
		src << link(CONFIG_GET(string/rulesurl))
	else
		to_chat(src, span_danger("The rules URL is not set in the server configuration."))
	return

/client/verb/map()
	set name = "Map"
	set desc = "See the map."
	set hidden = 1

	if(CONFIG_GET(string/mapurl))
		if(tgui_alert(usr, "This will open the map in your browser. Are you sure?","Visit Website",list("Yes","No")) != "Yes")
			return
		src << link(CONFIG_GET(string/mapurl))
	else
		to_chat(src, span_danger("The map URL is not set in the server configuration."))
	return

/client/verb/github()
	set name = "GitHub"
	set desc = "Visit the GitHub"
	set hidden = 1

	if(CONFIG_GET(string/githuburl))
		if(tgui_alert(usr, "This will open the GitHub in your browser. Are you sure?","Visit Website",list("Yes","No")) != "Yes")
			return
		src << link(CONFIG_GET(string/githuburl))
	else
		to_chat(src, span_danger("The GitHub URL is not set in the server configuration."))
	return

/client/verb/discord()
	set name = "Discord"
	set desc = "Visit the discord"
	set hidden = 1

	if(CONFIG_GET(string/discordurl))
		if(tgui_alert(usr, "This will open the Discord in your browser. Are you sure?","Visit Website",list("Yes","No")) != "Yes")
			return
		src << link(CONFIG_GET(string/discordurl))
	else
		to_chat(src, span_danger("The Discord URL is not set in the server configuration."))
	return

/client/verb/patreon()
	set name = "Patreon"
	set desc = "Visit the patreon"
	set hidden = 1

	if(CONFIG_GET(string/patreonurl))
		if(tgui_alert(usr, "This will open the Patreon in your browser. Are you sure?","Visit Website",list("Yes","No")) != "Yes")
			return
		src << link(CONFIG_GET(string/patreonurl))
	else
		to_chat(src, span_danger("The Patreon URL is not set in the server configuration."))
	return

/client/verb/reportissue()
	set name = "report-issue"
	set desc = "Report an issue"

	var/githuburl = CONFIG_GET(string/githuburl)
	if(!githuburl)
		to_chat(src, span_danger("The Github URL is not set in the server configuration."))
		return

	var/testmerge_data = GLOB.revdata.testmerge
	var/has_testmerge_data = (length(testmerge_data) != 0)

	var/message = "This will open the Github issue reporter in your browser. Are you sure?"
	if(has_testmerge_data)
		message += "<br>The following experimental changes are active and are probably the cause of any new or sudden issues you may experience. If possible, please try to find a specific thread for your issue instead of posting to the general issue tracker:<br>"
		message += GLOB.revdata.GetTestMergeInfo(FALSE)

	// We still use tg_alert here because some people were concerned that if someone wanted to report that tgui wasn't working
	// then the report issue button being tgui-based would be problematic.
	if(tg_alert(src, message, "Report Issue", "Yes", "No") != "Yes")
		return

	var/base_link = githuburl + "/issues/new?template=bug_report_form.yml"
	var/list/concatable = list(base_link)

	var/client_version = "[byond_version].[byond_build]"
	concatable += ("&reporting-version=" + client_version)

	// the way it works is that we use the ID's that are baked into the template YML and replace them with values that we can collect in game.
	if(GLOB.round_id)
		concatable += ("&round-id=" + GLOB.round_id)

	// Insert testmerges
	if(has_testmerge_data)
		var/list/all_tms = list()
		for(var/entry in testmerge_data)
			var/datum/tgs_revision_information/test_merge/tm = entry
			all_tms += "- \[[tm.title]\]([githuburl]/pull/[tm.number])"
		var/all_tms_joined = jointext(all_tms, "\n")

		concatable += ("&test-merges=" + url_encode(all_tms_joined))

	DIRECT_OUTPUT(src, link(jointext(concatable, "")))

/client/verb/changelog()
	set name = "Changelog"
	set category = "OOC.Resources"

	if(!GLOB.changelog_tgui)
		GLOB.changelog_tgui = new /datum/changelog()

	GLOB.changelog_tgui.tgui_interact(mob)
	//if(prefs.lastchangelog != GLOB.changelog_hash)
	//	prefs.lastchangelog = GLOB.changelog_hash
	//	prefs.save_preferences()
	//	winset(src, "infobuttons.changelog", "font-style=;")

/client/verb/hotkeys_help()
	set name = "Hotkeys Help"
	set category = "OOC.Resources"

	if(!GLOB.hotkeys_tgui)
		GLOB.hotkeys_tgui = new /datum/hotkeys_help()

	GLOB.hotkeys_tgui.tgui_interact(mob)
