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
	var/tmp/last_notification
	var/tmp/datum/component/nif_menu/menu

/**
 * Small helper component to manage the HUD icon
 */
/datum/component/nif_menu
	var/obj/screen/nif/screen_icon

/datum/component/nif_menu/Initialize()
	if(!ismob(parent))
		return COMPONENT_INCOMPATIBLE
	. = ..()

/datum/component/nif_menu/RegisterWithParent()
	. = ..()
	RegisterSignal(parent, COMSIG_MOB_CLIENT_LOGIN, PROC_REF(create_mob_button))
	var/mob/owner = parent
	if(owner.client)
		create_mob_button(parent)

/datum/component/nif_menu/UnregisterFromParent()
	. = ..()
	UnregisterSignal(parent, COMSIG_MOB_CLIENT_LOGIN)
	if(ismob(parent))
		var/mob/owner = parent
		if(screen_icon)
			owner?.client?.screen -= screen_icon
			UnregisterSignal(screen_icon, COMSIG_CLICK)
			qdel_null(screen_icon)
		if(ishuman(parent))
			owner.verbs -= /mob/living/carbon/human/proc/nif_menu


/datum/component/nif_menu/proc/create_mob_button(mob/user)
	var/datum/hud/HUD = user.hud_used
	if(!screen_icon)
		screen_icon = new()
		RegisterSignal(screen_icon, COMSIG_CLICK, PROC_REF(nif_menu_click))
	screen_icon.icon = HUD.ui_style
	screen_icon.color = HUD.ui_color
	screen_icon.alpha = HUD.ui_alpha
	LAZYADD(HUD.other_important, screen_icon)
	user.client?.screen += screen_icon

	user.verbs |= /mob/living/carbon/human/proc/nif_menu

/datum/component/nif_menu/proc/nif_menu_click(source, location, control, params, user)
	var/mob/living/carbon/human/H = user
	if(istype(H) && H.nif)
		INVOKE_ASYNC(H.nif, PROC_REF(tgui_interact), user)

/**
 * Screen object for NIF menu access
 */
/obj/screen/nif
	name = "nif menu"
	icon = 'icons/mob/screen/midnight.dmi'
	icon_state = "nif"
	screen_loc = ui_smallquad

/**
 * Verb to open the interface
 */
/mob/living/carbon/human/proc/nif_menu()
	set name = "NIF Menu"
	set category = "IC"
	set desc = "Open the NIF user interface."

	var/obj/item/device/nif/N = nif
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
	if(!ishuman(user))
		return FALSE
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

	data["valid_themes"] = valid_ui_themes
	data["theme"] = save_data["ui_theme"]
	data["last_notification"] = last_notification

	// Random biometric information
	data["nutrition"] = human.nutrition
	data["isSynthetic"] = human.isSynthetic()

	data["nif_percent"] = round((durability/initial(durability))*100)
	data["nif_stat"] = stat


	var/list/modules = list()
	if(stat == NIF_WORKING)
		for(var/nifsoft in nifsofts)
			if(!nifsoft)
				continue
			var/datum/nifsoft/NS = nifsoft
			modules.Add(list(list(
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
	data["modules"] = modules

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
