/************************************************************************\
 * This module controls everything to do with the NIF's tgui interface. *
\************************************************************************/
/**
 * Etc variables on the NIF to keep this self contained
 */
/obj/item/device/nif
	var/static/list/valid_ui_themes = list(
		"abductor",
		"cardtable",
		"hackerman",
		"malfunction",
		"ntos",
		"paper",
		"retro",
		"syndicate"
	)
	var/tmp/obj/effect/statclick/nif_open/our_statclick
	var/tmp/last_notification

/**
 * Special stat button for the interface
 */
/obj/effect/statclick/nif_open
/obj/effect/statclick/nif_open/Click(location, control, params)
	var/obj/item/device/nif/N = target
	if(istype(N))
		N.tgui_interact(usr)

/**
 * The NIF State ensures that only our authorized implanted user can touch us.
 */
/obj/item/device/nif/tgui_state(mob/user)
	return GLOB.tgui_nif_main_state

/**
 * Standard TGUI stub to open the NIF.js template.
 */
/obj/item/device/nif/tgui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "NIF", name)
		ui.open()

/**
 * tgui_data gives the UI any relevant data it needs.
 * In our case, that's basically everything from our statpanel.
 */
/obj/item/device/nif/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = ..()

	data["theme"] = save_data["ui_theme"]
	data["last_notification"] = last_notification

	// Random biometric information
	data["nutrition"] = human.nutrition
	data["isSynthetic"] = human.isSynthetic()

	data["nif_percent"] = round((durability/initial(durability))*100)
	data["nif_stat"] = stat

	data["modules"] = list()
	if(stat == NIF_WORKING)
		for(var/nifsoft in nifsofts)
			if(!nifsoft)
				continue
			var/datum/nifsoft/NS = nifsoft
			data["modules"].Add(list(list(
				"name" = NS.name,
				"desc" = NS.desc,
				"p_drain" = NS.p_drain,
				"a_drain" = NS.a_drain,
				"illegal" = NS.illegal,
				"wear" = NS.wear,
				"cost" = NS.cost,
				"activates" = NS.activates,
				"active" = NS.active,
				"stat_text" = NS.stat_text(),
				"ref" = REF(NS),
			)))

	return data

/**
 * tgui_act handles all user input in the UI.
 */
/obj/item/device/nif/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	if(..())
		return TRUE

	switch(action)
		if("setTheme")
			if((params["theme"] in valid_ui_themes) || params["theme"] == null)
				save_data["ui_theme"] = params["theme"]
			return TRUE
		if("toggle_module")
			var/datum/nifsoft/NS = locate(params["module"]) in nifsofts
			if(!istype(NS))
				return
			if(NS.activates)
				if(NS.active)
					NS.deactivate()
				else
					NS.activate()
			return TRUE
		if("uninstall")
			var/datum/nifsoft/NS = locate(params["module"]) in nifsofts
			if(!istype(NS))
				return
			NS.uninstall()
			return TRUE
		if("dismissNotification")
			last_notification = null
			return TRUE