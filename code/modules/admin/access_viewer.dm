
/*
	Tgui panel for admins editing the access list of various machines.
*/
/datum/access_viewer
	var/datum/weakref/focused_obj

/datum/access_viewer/Destroy(force)
	focused_obj = null
	. = ..()

/datum/access_viewer/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AccessViewer", "Access Viewer")
		ui.open()

/datum/access_viewer/tgui_state(mob/user)
	return ADMIN_STATE(R_DEBUG)

/datum/access_viewer/tgui_act(action, params, datum/tgui/ui)
	. = ..()
	if(.)
		return

	var/obj/machinery/req_thing = focused_obj?.resolve()
	if(!req_thing)
		return FALSE

	var/set_id = text2num(params["set_id"])
	switch(action)
		if("req_all")
			if(!req_thing.req_access)
				req_thing.req_access = list()
			if(set_id in req_thing.req_access)
				req_thing.req_access -= set_id
			else
				req_thing.req_access += set_id
			return TRUE

		if("req_one")
			if(!req_thing.req_one_access)
				req_thing.req_one_access = list()
			if(set_id in req_thing.req_one_access)
				req_thing.req_one_access -= set_id
			else
				req_thing.req_one_access += set_id
			return TRUE

/datum/access_viewer/tgui_static_data(mob/user)
	var/list/data = list()
	var/list/access_list = list()
	for(var/datum/access/dat as anything in subtypesof(/datum/access))
		access_list += list(
			list(
				"id" = dat.id,
				"name" = dat.desc,
				"region" = dat.region,
				"access_type" = dat.access_type,
			)
		)
	data["access_list"] = access_list
	return data

/datum/access_viewer/tgui_data(mob/user)
	var/list/data = list()
	// Check if the object still exists
	var/obj/machinery/req_thing = focused_obj?.resolve()
	if(req_thing)
		data["name"] = req_thing.name
		data["coords"] = "[req_thing.x].[req_thing.y].[req_thing.z]"
		data["req_access"] = req_thing.req_access ? req_thing.req_access : list()
		data["req_one_access"] = req_thing.req_one_access ? req_thing.req_one_access : list()
	return data

/datum/access_viewer/proc/set_access_focus(obj/machinery/req_thing)
	focused_obj = WEAKREF(req_thing)
