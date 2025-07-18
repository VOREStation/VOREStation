/client/proc/air_report()
	set category = "Debug.Investigate"
	set name = "Show Air Report"

	if(!master_controller || !SSair)
		tgui_alert_async(usr,"Master_controller or SSair not found.","Air Report")
		return

	var/active_groups = SSair.active_zones
	var/inactive_groups = SSair.zones.len - active_groups

	var/hotspots = 0
	for(var/obj/fire/hotspot in world)
		hotspots++

	var/active_on_main_station = 0
	var/inactive_on_main_station = 0
	for(var/zone/zone in SSair.zones)
		var/turf/simulated/turf = locate() in zone.contents
		if(turf?.z in using_map.station_levels)
			if(zone.needs_update)
				active_on_main_station++
			else
				inactive_on_main_station++

	var/output = {"<B>AIR SYSTEMS REPORT</B><HR>
<B>General Processing Data</B><BR>
	Cycle: [SSair.current_cycle]<br>
	Groups: [SSair.zones.len]<BR>
---- <I>Active:</I> [active_groups]<BR>
---- <I>Inactive:</I> [inactive_groups]<BR><br>
---- <I>Active on station:</i> [active_on_main_station]<br>
---- <i>Inactive on station:</i> [inactive_on_main_station]<br>
<BR>
<B>Special Processing Data</B><BR>
	Hotspot Processing: [hotspots]<BR>
<br>
<B>Geometry Processing Data</B><BR>
	Tile Update: [SSair.tiles_to_update.len]<BR>
"}

	var/datum/browser/popup = new(src, "airreport", "Airreport")
	popup.set_content(output)
	popup.open()

/client/proc/fix_next_move()
	set category = "Debug.Game"
	set name = "Unfreeze Everyone"
	var/largest_move_time = 0
	var/largest_click_time = 0
	var/mob/largest_move_mob = null
	var/mob/largest_click_mob = null
	for(var/mob/M in GLOB.mob_list)
		if(!M.client)
			continue
		if(M.next_move >= largest_move_time)
			largest_move_mob = M
			if(M.next_move > world.time)
				largest_move_time = M.next_move - world.time
			else
				largest_move_time = 1
		if(M.next_click >= largest_click_time)
			largest_click_mob = M
			if(M.next_click > world.time)
				largest_click_time = M.next_click - world.time
			else
				largest_click_time = 0
		log_admin("DEBUG: [key_name(M)]  next_move = [M.next_move]  next_click = [M.next_click]  world.time = [world.time]")
		M.next_move = 1
		M.next_click = 0
	message_admins("[key_name_admin(largest_move_mob)] had the largest move delay with [largest_move_time] frames / [largest_move_time/10] seconds!", 1)
	message_admins("[key_name_admin(largest_click_mob)] had the largest click delay with [largest_click_time] frames / [largest_click_time/10] seconds!", 1)
	message_admins("world.time = [world.time]", 1)
	feedback_add_details("admin_verb","UFE") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return

/client/proc/radio_report()
	set category = "Debug.Game"
	set name = "Radio report"

	var/output = "<b>Radio Report</b><hr>"
	for (var/fq in radio_controller.frequencies)
		output += "<b>Freq: [fq]</b><br>"
		var/datum/radio_frequency/fqs = radio_controller.frequencies[fq]
		if (!fqs)
			output += "&nbsp;&nbsp;<b>ERROR</b><br>"
			continue
		for (var/radio_filter in fqs.devices)
			var/list/f = fqs.devices[radio_filter]
			if (!f)
				output += "&nbsp;&nbsp;[radio_filter]: ERROR<br>"
				continue
			output += "&nbsp;&nbsp;[radio_filter]: [f.len]<br>"
			for (var/device in f)
				if (isobj(device))
					output += "&nbsp;&nbsp;&nbsp;&nbsp;[device] ([device:x],[device:y],[device:z] in area [get_area(device:loc)])<br>"
				else
					output += "&nbsp;&nbsp;&nbsp;&nbsp;[device]<br>"

	var/datum/browser/popup = new(src, "radioreport", "Radioreport")
	popup.set_content(output)
	popup.open()
	feedback_add_details("admin_verb","RR") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/reload_admins()
	set name = "Reload Admins"
	set category = "Debug.Server"

	if(!check_rights(R_SERVER))	return

	message_admins("[usr] manually reloaded admins")
	load_admins()
	feedback_add_details("admin_verb","RLDA") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/reload_eventMs()
	set name = "Reload Event Managers"
	set category = "Debug.Server"

	if(!check_rights(R_SERVER)) return

	message_admins("[usr] manually reloaded Event Managers")
	world.load_mods()


//todo:
/client/proc/jump_to_dead_group()
	set name = "Jump to dead group"
	set category = "Debug.Game"
		/*
	if(!holder)
		to_chat(src, "Only administrators may use this command.")
		return

	if(!SSair)
		to_chat(usr, "Cannot find air_system")
		return
	var/datum/air_group/dead_groups = list()
	for(var/datum/air_group/group in SSair.air_groups)
		if (!group.group_processing)
			dead_groups += group
	var/datum/air_group/dest_group = pick(dead_groups)
	usr.loc = pick(dest_group.members)
	feedback_add_details("admin_verb","JDAG") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return
	*/

/client/proc/kill_airgroup()
	set name = "Kill Local Airgroup"
	set desc = "Use this to allow manual manupliation of atmospherics."
	set category = "Debug.Dangerous"
	/*
	if(!holder)
		to_chat(src, "Only administrators may use this command.")
		return

	if(!SSair)
		to_chat(usr, "Cannot find air_system")
		return

	var/turf/T = get_turf(usr)
	if(istype(T, /turf/simulated))
		var/datum/air_group/AG = T:parent
		AG.next_check = 30
		AG.group_processing = 0
	else
		to_chat(usr, "Local airgroup is unsimulated!")
	feedback_add_details("admin_verb","KLAG") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	*/

/client/proc/print_jobban_old()
	set name = "Print Jobban Log"
	set desc = "This spams all the active jobban entries for the current round to standard output."
	set category = "Debug.Investigate"

	to_chat(usr, span_bold("Jobbans active in this round."))
	for(var/t in jobban_keylist)
		to_chat(usr, "[t]")

/client/proc/print_jobban_old_filter()
	set name = "Search Jobban Log"
	set desc = "This searches all the active jobban entries for the current round and outputs the results to standard output."
	set category = "Debug.Investigate"

	var/job_filter = tgui_input_text(usr, "Contains what?","Job Filter")
	if(!job_filter)
		return

	to_chat(usr, span_bold("Jobbans active in this round."))
	for(var/t in jobban_keylist)
		if(findtext(t, job_filter))
			to_chat(usr, "[t]")
