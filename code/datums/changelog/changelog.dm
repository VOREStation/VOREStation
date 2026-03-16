/datum/changelog
	var/static/list/changelog_items = list()
	var/static/list/dates
	var/static/list/testmerges

/datum/changelog/tgui_state()
	return GLOB.tgui_always_state

/datum/changelog/tgui_interact(mob/user, datum/tgui/ui)
	if(isnull(dates))
		dates = get_dates()
	if(isnull(testmerges))
		testmerges = get_testmerge_data()

	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "Changelog")
		ui.set_autoupdate(FALSE)
		ui.open()

/datum/changelog/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	. = ..()
	if(.)
		return
	if(action == "get_month")
		var/datum/asset/changelog_item/changelog_item = changelog_items[params["date"]]
		if (!changelog_item)
			changelog_item = new /datum/asset/changelog_item(params["date"])
			changelog_items[params["date"]] = changelog_item
		return ui.send_asset(changelog_item)

/datum/changelog/tgui_static_data()
	var/list/data = list()

	data["dates"] = dates
	data["testmerges"] = testmerges
	data["discord_url"] = CONFIG_GET(string/discordurl)

	return data

/datum/changelog/proc/get_dates()
	. = list()
	var/regex/yml_regex = regex(@"\.yml", "g")
	for(var/archive_file in flist("html/changelogs/archive/"))
		. += replacetext(archive_file, yml_regex, "")

/datum/changelog/proc/get_testmerge_data()
	. = list()
	for(var/datum/tgs_revision_information/test_merge/testmerge in world.TgsTestMerges())
		if(!testmerge.body || findtext(testmerge.title, @"[s]"))
			continue
		var/list/changes = parse_github_changelog(testmerge.body)
		if(!length(changes))
			changes = list("unknown" = list("Changes are not documented. Ask the author ([testmerge.author]) to add a changelog to their PR!"))
		var/list/testmerge_data = list(
			"title" = trimtext("[testmerge.title]"),
			"number" = testmerge.number,
			"author" = testmerge.author,
			"link" = testmerge.url,
			"changes" = changes,
		)
		. += list(testmerge_data)

/proc/parse_github_changelog(body) as /list
	// these shouldn't be static, as this will only be called a few times at most in get_testmerge_data, which will only be called once.
	var/regex/cl_pattern = new(@"(:cl:|🆑)([\S \t]*)$")
	var/regex/entry_pattern = new(@"(\w+): (.+)")
	var/regex/end_pattern = new(@"^/(:cl:|🆑)")
	var/regex/newline_pattern = new(@"(\r\n|\r|\n)")

	// no changes, this is just using the default template
	if(findtext_char(body, "add: Added new mechanics or gameplay changes"))
		return

	var/started = FALSE
	var/list/lines = splittext_char(trimtext(body), newline_pattern)

	for(var/line in lines)
		line = trimtext(line)
		if(findtext_char(line, end_pattern))
			break
		if(started)
			if (findtext_char(line, entry_pattern))
				var/change_type = trimtext(entry_pattern.group[1])
				var/change_desc = trimtext(entry_pattern.group[2])
				if(!change_type || !change_desc)
					continue
				LAZYADDASSOCLIST(., change_type, change_desc)
		else
			if(findtext_char(line, cl_pattern))
				started = TRUE
