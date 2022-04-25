/datum/tgui_module/alarm_monitor
	name = "Alarm monitor"
	tgui_id = "StationAlertConsole"
	var/list_cameras = 0						// Whether or not to list camera references. A future goal would be to merge this with the enginering/security camera console. Currently really only for AI-use.
	var/list/datum/alarm_handler/alarm_handlers // The particular list of alarm handlers this alarm monitor should present to the user.

/datum/tgui_module/alarm_monitor/New()
	..()
	alarm_handlers = list()

/datum/tgui_module/alarm_monitor/all
/datum/tgui_module/alarm_monitor/all/New()
	..()
	alarm_handlers = SSalarm.handlers

// Subtype for glasses_state
/datum/tgui_module/alarm_monitor/all/glasses
/datum/tgui_module/alarm_monitor/all/glasses/tgui_state(mob/user)
	return GLOB.tgui_glasses_state

/datum/tgui_module/alarm_monitor/all/robot
/datum/tgui_module/alarm_monitor/all/robot/tgui_state(mob/user)
	return GLOB.tgui_self_state

/datum/tgui_module/alarm_monitor/engineering
/datum/tgui_module/alarm_monitor/engineering/New()
	..()
	alarm_handlers = list(GLOB.atmosphere_alarm, GLOB.fire_alarm, GLOB.power_alarm)

// Subtype for glasses_state
/datum/tgui_module/alarm_monitor/engineering/glasses
/datum/tgui_module/alarm_monitor/engineering/glasses/tgui_state(mob/user)
	return GLOB.tgui_glasses_state

// Subtype for nif_state
/datum/tgui_module/alarm_monitor/engineering/nif
/datum/tgui_module/alarm_monitor/engineering/nif/tgui_state(mob/user)
	return GLOB.tgui_nif_state

// Subtype for NTOS
/datum/tgui_module/alarm_monitor/engineering/ntos
	ntos = TRUE

/datum/tgui_module/alarm_monitor/security
/datum/tgui_module/alarm_monitor/security/New()
	..()
	alarm_handlers = list(GLOB.camera_alarm, GLOB.motion_alarm)

// Subtype for glasses_state
/datum/tgui_module/alarm_monitor/security/glasses
/datum/tgui_module/alarm_monitor/security/glasses/tgui_state(mob/user)
	return GLOB.tgui_glasses_state

// Subtype for NTOS
/datum/tgui_module/alarm_monitor/security/ntos
	ntos = TRUE

/datum/tgui_module/alarm_monitor/proc/register_alarm(var/object, var/procName)
	for(var/datum/alarm_handler/AH in alarm_handlers)
		AH.register_alarm(object, procName)

/datum/tgui_module/alarm_monitor/proc/unregister_alarm(var/object)
	for(var/datum/alarm_handler/AH in alarm_handlers)
		AH.unregister_alarm(object)

/datum/tgui_module/alarm_monitor/proc/all_alarms()
	var/z = get_z(tgui_host())
	var/list/all_alarms = new()
	for(var/datum/alarm_handler/AH in alarm_handlers)
		all_alarms += AH.visible_alarms(z)

	return all_alarms

/datum/tgui_module/alarm_monitor/proc/major_alarms()
	var/z = get_z(tgui_host())
	var/list/all_alarms = new()
	for(var/datum/alarm_handler/AH in alarm_handlers)
		all_alarms += AH.major_alarms(z)

	return all_alarms

// Modified version of above proc that uses slightly less resources, returns 1 if there is a major alarm, 0 otherwise.
/datum/tgui_module/alarm_monitor/proc/has_major_alarms()
	var/z = get_z(tgui_host())
	for(var/datum/alarm_handler/AH in alarm_handlers)
		if(AH.has_major_alarms(z))
			return 1

	return 0

/datum/tgui_module/alarm_monitor/proc/minor_alarms()
	var/z = get_z(tgui_host())
	var/list/all_alarms = new()
	for(var/datum/alarm_handler/AH in alarm_handlers)
		all_alarms += AH.minor_alarms(z)

	return all_alarms

/datum/tgui_module/alarm_monitor/tgui_act(action, params)
	if(..())
		return TRUE
	
	// Camera stuff is AI only.
	// If you're not an AI, this is a read-only UI.
	if(!isAI(usr))
		return

	switch(action)
		if("switchTo")
			var/obj/machinery/camera/C = locate(params["camera"]) in cameranet.cameras
			if(!C)
				return

			usr.switch_to_camera(C)
			return 1

/datum/tgui_module/alarm_monitor/tgui_data(mob/user)
	var/list/data = list()

	var/categories[0]
	var/z = get_z(tgui_host())
	for(var/datum/alarm_handler/AH in alarm_handlers)
		categories[++categories.len] = list("category" = AH.category, "alarms" = list())
		for(var/datum/alarm/A in AH.visible_alarms(z))
			var/cameras[0]
			var/lost_sources[0]

			if(isAI(user))
				for(var/obj/machinery/camera/C in A.cameras())
					cameras[++cameras.len] = C.tgui_structure()
			for(var/datum/alarm_source/AS in A.sources)
				if(!AS.source)
					lost_sources[++lost_sources.len] = AS.source_name

			categories[categories.len]["alarms"] += list(list(
					"name" = "[A.alarm_name()]" + "[A.max_severity() > 1 ? "(MAJOR)" : ""]",
					"origin_lost" = A.origin == null,
					"has_cameras" = cameras.len,
					"cameras" = cameras,
					"lost_sources" = lost_sources.len ? sanitize(english_list(lost_sources, nothing_text = "", and_text = ", ")) : ""))
	data["categories"] = categories

	return data
