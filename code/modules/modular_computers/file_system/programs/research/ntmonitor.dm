/datum/computer_file/program/ntnetmonitor
	filename = "ntmonitor"
	filedesc = "NTNet Diagnostics and Monitoring"
	program_icon_state = "comm_monitor"
	program_key_state = "generic_key"
	program_menu_icon = "wrench"
	extended_desc = "This program monitors the local NTNet network, provides access to logging systems, and allows for configuration changes"
	size = 12
	requires_ntnet = TRUE
	required_access = access_network
	available_on_ntnet = TRUE
	tgui_id = "NtosNetMonitor"

/datum/computer_file/program/ntnetmonitor/tgui_data(mob/user)
	if(!ntnet_global)
		return
	var/list/data = get_header_data()

	data["ntnetstatus"] = ntnet_global.check_function()
	data["ntnetrelays"] = ntnet_global.relays.len
	data["idsstatus"] = ntnet_global.intrusion_detection_enabled
	data["idsalarm"] = ntnet_global.intrusion_detection_alarm

	data["config_softwaredownload"] = ntnet_global.setting_softwaredownload
	data["config_peertopeer"] = ntnet_global.setting_peertopeer
	data["config_communication"] = ntnet_global.setting_communication
	data["config_systemcontrol"] = ntnet_global.setting_systemcontrol

	data["ntnetlogs"] = list()
	data["minlogs"] = MIN_NTNET_LOGS
	data["maxlogs"] = MAX_NTNET_LOGS

	data["banned_nids"] = list(ntnet_global.banned_nids)

	for(var/i in ntnet_global.logs)
		data["ntnetlogs"] += list(list("entry" = i))
	data["ntnetmaxlogs"] = ntnet_global.setting_maxlogcount

	return data

/datum/computer_file/program/ntnetmonitor/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	if(..())
		return
	switch(action)
		if("resetIDS")
			if(ntnet_global)
				ntnet_global.resetIDS()
			return TRUE
		if("toggleIDS")
			if(ntnet_global)
				ntnet_global.toggleIDS()
			return TRUE
		if("toggleWireless")
			if(!ntnet_global)
				return

			// NTNet is disabled. Enabling can be done without user prompt
			if(ntnet_global.setting_disabled)
				ntnet_global.setting_disabled = FALSE
				return TRUE

			var/response = tgui_alert(usr, "Really disable NTNet wireless? If your computer is connected wirelessly you won't be able to turn it back on! This will affect all connected wireless devices.", "NTNet shutdown", list("Yes", "No"))
			if(response == "Yes" && tgui_status(usr, state) == STATUS_INTERACTIVE)
				ntnet_global.setting_disabled = TRUE
			return TRUE
		if("purgelogs")
			if(ntnet_global)
				ntnet_global.purge_logs()
			return TRUE
		if("updatemaxlogs")
			var/logcount = params["new_number"]
			if(ntnet_global)
				ntnet_global.update_max_log_count(logcount)
			return TRUE
		if("toggle_function")
			if(!ntnet_global)
				return
			ntnet_global.toggle_function(text2num(params["id"]))
			return TRUE
		if("ban_nid")
			if(!ntnet_global)
				return
			var/nid = tgui_input_number(usr,"Enter NID of device which you want to block from the network:", "Enter NID")
			if(nid && tgui_status(usr, state) == STATUS_INTERACTIVE)
				ntnet_global.banned_nids |= nid
			return TRUE
		if("unban_nid")
			if(!ntnet_global)
				return
			var/nid = tgui_input_number(usr,"Enter NID of device which you want to unblock from the network:", "Enter NID")
			if(nid && tgui_status(usr, state) == STATUS_INTERACTIVE)
				ntnet_global.banned_nids -= nid
			return TRUE 
