/*
TGUI MODULES

This allows for datum-based TGUIs that can be hooked into objects.
This is useful for things such as the power monitor, which needs to exist on a physical console in the world, but also as a virtual device the AI can use

Code is pretty much ripped verbatim from nano modules, but with un-needed stuff removed
*/
/datum/tgui_module
	var/name
	var/datum/host
	var/list/using_access

	var/tgui_id
	var/ntos = FALSE

/datum/tgui_module/New(var/host)
	src.host = host
	if(ntos)
		tgui_id = "Ntos" + tgui_id

/datum/tgui_module/tgui_host()
	return host ? host.tgui_host() : src

/datum/tgui_module/tgui_close(mob/user)
	if(host)
		host.tgui_close(user)

/datum/tgui_module/proc/check_eye(mob/user)
	return -1

/datum/tgui_module/proc/can_still_topic(mob/user, datum/tgui_state/state)
	return (tgui_status(user, state) == STATUS_INTERACTIVE)

/datum/tgui_module/proc/check_access(mob/user, access)
	if(!access)
		return 1

	if(using_access)
		if(access in using_access)
			return 1
		else
			return 0

	if(!istype(user))
		return 0

	var/obj/item/card/id/I = user.GetIdCard()
	if(!I)
		return 0

	if(access in I.access)
		return 1

	return 0

/datum/tgui_module/tgui_static_data()
	. = ..()
	
	var/obj/item/modular_computer/host = tgui_host()
	if(istype(host))
		. += host.get_header_data()

/datum/tgui_module/tgui_act(action, params)
	if(..())
		return TRUE

	var/obj/item/modular_computer/host = tgui_host()
	if(istype(host))
		if(action == "PC_exit")
			host.kill_program()
			return TRUE
		if(action == "PC_shutdown")
			host.shutdown_computer()
			return TRUE
		if(action == "PC_minimize")
			host.minimize_program(usr)
			return TRUE

// Just a nice little default interact in case the subtypes don't need any special behavior here
/datum/tgui_module/tgui_interact(mob/user, datum/tgui/ui = null, datum/tgui/parent_ui = null)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, tgui_id, name, parent_ui)
		ui.open()

/datum/tgui_module/proc/relaymove(mob/user, direction)
	return FALSE
