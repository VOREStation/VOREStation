var/global/datum/getrev/revdata = new()

/datum/getrev
	var/branch
	var/revision
	var/date
	var/showinfo
	var/list/testmerge = list()

/datum/getrev/New()
	if(world.TgsAvailable()) // Try TGS maybe
		testmerge = world.TgsTestMerges()
		var/datum/tgs_revision_information/REV = world.TgsRevision()
		if(REV)
			revision = REV.origin_commit || REV.commit
			branch = "-Using TGS-" // TGS doesn't provide branch info yet
			date = "-Using TGS-" // Or date
	
	if(!revision) // File parse method
		var/list/head_branch = file2list(".git/HEAD", "\n")
		if(head_branch.len)
			branch = copytext(head_branch[1], 17)

		var/list/head_log = file2list(".git/logs/HEAD", "\n")
		for(var/line=head_log.len, line>=1, line--)
			if(head_log[line])
				var/list/last_entry = splittext(head_log[line], " ")
				if(last_entry.len < 2)	continue
				revision = last_entry[2]
				// Get date/time
				if(last_entry.len >= 5)
					var/unix_time = text2num(last_entry[5])
					if(unix_time)
						date = unix2date(unix_time)
				break

	to_world_log("-Revision Info-")
	to_world_log("Branch: [branch]")
	to_world_log("Date: [date]")
	to_world_log("Revision: [revision]")

/datum/getrev/proc/GetTestMergeInfo(header = TRUE)
	if(!testmerge.len)
		return ""
	. = header ? "The following pull requests are currently test merged:<br>" : ""
	for(var/line in testmerge)
		var/datum/tgs_revision_information/test_merge/tm = line
		var/cm = tm.pull_request_commit
		var/details = ": '" + html_encode(tm.title) + "' by " + html_encode(tm.author) + " at commit " + html_encode(copytext_char(cm, 1, 11))
		if(details && findtext(details, "\[s\]") && (!usr || !usr.client.holder))
			continue
		. += "<a href=\"[config.githuburl]/pull/[tm.number]\">#[tm.number][details]</a><br>"

client/verb/showrevinfo()
	set category = "OOC"
	set name = "Show Server Revision"
	set desc = "Check the current server code revision"

	var/list/msg = list()
	
	if(revdata.revision)
		msg += "<b>Server revision:</b> [revdata.branch] - [revdata.date]"
		if(config.githuburl)
			msg += "<a href='[config.githuburl]/commit/[revdata.revision]'>[revdata.revision]</a>"
		else
			to_chat(src,revdata.revision)
	else
		msg += "<b>Server revision:</b> Unknown"

	if(world.TgsAvailable())
		var/datum/tgs_version/version = world.TgsVersion()
		msg += "TGS version: [version.raw_parameter]"
		var/datum/tgs_version/api_version = world.TgsApiVersion()
		msg += "DMAPI version: [api_version.raw_parameter]"

	if(revdata.testmerge.len)
		msg += revdata.GetTestMergeInfo()

	to_chat(src, msg.Join("<br>"))
