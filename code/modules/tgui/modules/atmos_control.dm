/datum/tgui_module/atmos_control
	name = "Atmospherics Control"
	tgui_id = "AtmosControl"
	var/obj/access = new()
	var/emagged = 0
	var/ui_ref
	var/list/monitored_alarms = list()

/datum/tgui_module/atmos_control/New(atmos_computer, req_access, req_one_access, monitored_alarm_ids)
	..()
	access.req_access = req_access
	access.req_one_access = req_one_access

	if(monitored_alarm_ids)
		for(var/obj/machinery/alarm/alarm in GLOB.machines)
			if(alarm.alarm_id && (alarm.alarm_id in monitored_alarm_ids))
				monitored_alarms += alarm
		// machines may not yet be ordered at this point
		monitored_alarms = dd_sortedObjectList(monitored_alarms)

/datum/tgui_module/atmos_control/tgui_act(action, params, datum/tgui/ui)
	if(..())
		return TRUE

	switch(action)
		if("alarm")
			if(ui_ref)
				var/obj/machinery/alarm/alarm = locate(params["alarm"]) in (monitored_alarms.len ? monitored_alarms : GLOB.machines)
				if(alarm)
					var/datum/tgui_state/TS = generate_state(alarm)
					alarm.tgui_interact(ui.user, parent_ui = ui_ref, state = TS)
			return 1
		if("setZLevel")
			ui.set_map_z_level(params["mapZLevel"])
			return TRUE

/datum/tgui_module/atmos_control/ui_assets(mob/user)
	. = ..()
	. += get_asset_datum(/datum/asset/simple/nanomaps)

/datum/tgui_module/atmos_control/tgui_interact(mob/user, datum/tgui/ui = null)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, tgui_id, name)
		ui.autoupdate = TRUE
		ui.open()
	ui_ref = ui

/datum/tgui_module/atmos_control/tgui_static_data(mob/user)
	. = ..()

	var/z = get_z(user)
	var/list/map_levels = using_map.get_map_levels(z)

	// TODO: Move these to a cache, similar to cameras
	var/alarms[0]
	for(var/obj/machinery/alarm/alarm in (monitored_alarms.len ? monitored_alarms : GLOB.machines))
		if(!monitored_alarms.len && alarm.alarms_hidden)
			continue
		if(!(alarm.z in map_levels))
			continue
		alarms[++alarms.len] = list(
			"name" = sanitize(alarm.name),
			"ref"= "\ref[alarm]",
			"danger" = max(alarm.danger_level, alarm.alarm_area.atmosalm),
			"x" = alarm.x,
			"y" = alarm.y,
			"z" = alarm.z)
	.["alarms"] = alarms
	.["zoomScale"] = world.maxx + world.maxy

/datum/tgui_module/atmos_control/tgui_data(mob/user)
	var/list/data = list()

	var/z = get_z(user)
	var/list/map_levels = using_map.get_map_levels(z)
	data["map_levels"] = map_levels

	return data

/datum/tgui_module/atmos_control/tgui_close()
	. = ..()
	ui_ref = null

/datum/tgui_module/atmos_control/proc/generate_state(air_alarm)
	var/datum/tgui_state/air_alarm_remote/state = new()
	state.atmos_control = src
	state.air_alarm = air_alarm
	return state

/datum/tgui_state/air_alarm_remote
	var/datum/tgui_module/atmos_control/atmos_control	= null
	var/obj/machinery/alarm/air_alarm					= null

/datum/tgui_state/air_alarm_remote/can_use_topic(src_object, mob/user)
	if(!atmos_control.ui_ref)
		qdel(src)
		return STATUS_CLOSE
	if(has_access(user))
		return STATUS_INTERACTIVE
	return STATUS_UPDATE

/datum/tgui_state/air_alarm_remote/proc/has_access(var/mob/user)
	return user && (isAI(user) || atmos_control.access.allowed(user) || atmos_control.emagged || air_alarm.rcon_setting == RCON_YES || (air_alarm.alarm_area.atmosalm && air_alarm.rcon_setting == RCON_AUTO) || (access_ce in user.GetAccess()))

/datum/tgui_state/air_alarm_remote/Destroy()
	atmos_control = null
	air_alarm = null
	return ..()

/datum/tgui_module/atmos_control/ntos
	ntos = TRUE

/datum/tgui_module/atmos_control/robot
/datum/tgui_module/atmos_control/robot/tgui_state(mob/user)
	return GLOB.tgui_self_state
