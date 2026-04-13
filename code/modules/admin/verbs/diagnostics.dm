ADMIN_VERB(air_report, R_DEBUG, "Show Air Report", "Displays the current atmos stats.", ADMIN_CATEGORY_DEBUG_INVESTIGATE)
	if(!SSair.initialized)
		tgui_alert_async(user, "SSair not ready.", "Air Report")
		return

	var/active_groups = SSair.active_zones
	var/inactive_groups = SSair.zones.len - active_groups

	var/hotspots = 0
	for(var/obj/fire/hotspot in world)
		hotspots++

	var/active_on_main_station = 0
	var/inactive_on_main_station = 0
	for(var/datum/zone/zone as anything in SSair.zones)
		var/turf/simulated/turf = locate() in zone.contents
		if(turf?.z in using_map.station_levels)
			if(zone.needs_update)
				active_on_main_station++
				continue
			inactive_on_main_station++

	var/output = {"<B>AIR SYSTEMS REPORT</B><HR>
<B>General Processing Data</B><BR>
	Cycle: [SSair.current_cycle]<br>
	Groups: [length(SSair.zones)]<BR>
---- <I>Active:</I> [active_groups]<BR>
---- <I>Inactive:</I> [inactive_groups]<BR><br>
---- <I>Active on station:</i> [active_on_main_station]<br>
---- <i>Inactive on station:</i> [inactive_on_main_station]<br>
<BR>
<B>Special Processing Data</B><BR>
	Hotspot Processing: [hotspots]<BR>
<br>
<B>Geometry Processing Data</B><BR>
	Tile Update: [length(SSair.tiles_to_update)]<BR>
"}

	var/datum/browser/popup = new(user, "airreport", "Airreport")
	popup.set_content(output)
	popup.open()

ADMIN_VERB(radio_report, R_DEBUG, "Radio report", "Displays a radio report.", ADMIN_CATEGORY_DEBUG_INVESTIGATE)
	var/output = "<b>Radio Report</b><hr>"
	for (var/fq in SSradio.frequencies)
		output += "<b>Freq: [fq]</b><br>"
		var/datum/radio_frequency/fqs = SSradio.frequencies[fq]
		if (!fqs)
			output += "&nbsp;&nbsp;<b>ERROR</b><br>"
			continue
		for (var/radio_filter, device_list in fqs.devices)
			var/list/f = device_list
			if (!f)
				output += "&nbsp;&nbsp;[radio_filter]: ERROR<br>"
				continue
			output += "&nbsp;&nbsp;[radio_filter]: [f.len]<br>"
			for (var/device in f)
				if (isobj(device))
					output += "&nbsp;&nbsp;&nbsp;&nbsp;[device] ([device:x],[device:y],[device:z] in area [get_area(device:loc)])<br>"
					continue
				output += "&nbsp;&nbsp;&nbsp;&nbsp;[device]<br>"

	var/datum/browser/popup = new(user, "radioreport", "Radioreport")
	popup.set_content(output)
	popup.open()
	feedback_add_details("admin_verb","RR") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

ADMIN_VERB(reload_admins, R_SERVER, "Reload Admins", "Reloads admins from the file or database.", ADMIN_CATEGORY_DEBUG_SERVER)
	message_admins("[user] manually reloaded admins")
	load_admins()
	feedback_add_details("admin_verb","RLDA") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

ADMIN_VERB(print_jobban_old, R_ADMIN|R_MOD, "Print Jobban Log", "This spams all the active jobban entries for the current round to standard output.", ADMIN_CATEGORY_DEBUG_INVESTIGATE)
	to_chat(user, span_debug_info(span_bold("Jobbans active in this round.")))
	for(var/t in GLOB.jobban_keylist)
		to_chat(user, span_debug_info("[t]"))

ADMIN_VERB(print_jobban_old_filter, R_ADMIN|R_MOD, "Search Jobban Log", "This searches all the active jobban entries for the current round and outputs the results to standard output.", ADMIN_CATEGORY_DEBUG_INVESTIGATE)
	var/job_filter = tgui_input_text(user, "Contains what?","Job Filter")
	if(!job_filter)
		return

	to_chat(user, span_debug_info(span_bold("Jobbans active in this round.")))
	for(var/t in GLOB.jobban_keylist)
		if(findtext(t, job_filter))
			to_chat(user, span_debug_info("[t]"))
