GLOBAL_DATUM(revdata, /datum/getrev)

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
	. = list()
	if(!testmerge.len)
		return
	if(header)
		. += "The following pull requests are currently test merged:"
	for(var/datum/tgs_revision_information/test_merge/tm as anything in testmerge)
		var/cm = tm.pull_request_commit
		var/details = ": '" + html_encode(tm.title) + "' by " + html_encode(tm.author) + " at commit " + html_encode(copytext_char(cm, 1, 11))
		if(details && findtext(details, "\[s\]") && (!usr || !usr.client.holder))
			continue
		. += "<a href=\"[config.githuburl]/pull/[tm.number]\">#[tm.number][details]</a>"

/client/verb/showrevinfo()
	set category = "OOC"
	set name = "Show Server Revision"
	set desc = "Check the current server code revision"

	if(!GLOB.revdata)
		to_chat(src, "<span class='warning'>Please wait until server initializations are complete.</span>")
		return
	
	var/list/msg = list()
	
	if(GLOB.revdata.revision)
		msg += "<b>Server revision:</b> B:[GLOB.revdata.branch] D:[GLOB.revdata.date]"
		if(config.githuburl)
			msg += "<b>Commit:</b> <a href='[config.githuburl]/commit/[GLOB.revdata.revision]'>[GLOB.revdata.revision]</a>"
		else
			msg += "<b>Commit:</b> GLOB.revdata.revision"
	else
		msg += "<b>Server revision:</b> Unknown"

	if(world.TgsAvailable())
		var/datum/tgs_version/version = world.TgsVersion()
		msg += "<b>TGS version:</b> [version.raw_parameter]"
		var/datum/tgs_version/api_version = world.TgsApiVersion()
		msg += "<b>DMAPI version:</b> [api_version.raw_parameter]"

	if(GLOB.revdata.testmerge.len)
		msg += GLOB.revdata.GetTestMergeInfo()

	to_chat(src, msg.Join("<br>"))
