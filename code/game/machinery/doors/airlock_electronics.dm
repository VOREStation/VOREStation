/obj/item/airlock_electronics
	name = "airlock electronics"
	icon = 'icons/obj/doors/door_assembly.dmi'
	icon_state = "door_electronics"
	w_class = ITEMSIZE_SMALL //It should be tiny! -Agouri

	matter = list(MAT_STEEL = MATERIAL_COST(0.025),MAT_GLASS = MATERIAL_COST(0.025))

	req_one_access = list(ACCESS_ENGINE, ACCESS_TALON_ENGINEER) // Access to unlock the device, ignored if emagged //VOREStation Edit - Add talon
	var/list/apply_any_access = list(ACCESS_ENGINE) // Can apply any access, not just their own

	var/secure = 0 //if set, then wires will be randomized and bolts will drop if the door is broken
	var/list/conf_access = null
	var/one_access = TRUE //if set to 1, door would receive req_one_access instead of req_access
	var/last_configurator = "Noone"
	var/locked = 1
	var/emagged = 0

/obj/item/airlock_electronics/emag_act(remaining_charges, mob/user)
	if(!emagged)
		emagged = 1
		to_chat(user, span_notice("You remove the access restrictions on [src]!"))
		return 1

/obj/item/airlock_electronics/attack_self(mob/user)
	. = ..(user)
	if(.)
		return TRUE
	if (!ishuman(user) && !issilicon(user))
		return FALSE
	tgui_interact(user)

/obj/item/airlock_electronics/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AirlockElectronics", name)
		ui.open()

/obj/item/airlock_electronics/tgui_data(mob/user)
	// this is the data which will be sent to the ui
	var/acc_list = list()
	var/list/available_access = list()
	available_access += user.GetAccess()
	if(conf_access)
		available_access |= conf_access
	for(var/acc in available_access)
		acc_list[SSaccess.get_access_desc(acc)] = list("access_num" = acc, "enabled" = (acc in conf_access))

	var/list/data = list(
		"last_configurator" = last_configurator,
		"locked" = locked,
		"one_access" = one_access,
		"access" = acc_list
	)

	return data

/obj/item/airlock_electronics/tgui_act(action, list/params, datum/tgui/ui)
	if(..())
		return TRUE
	if (!ishuman(ui.user) && !issilicon(ui.user))
		return FALSE

	switch(action)
		if("login")
			if(emagged)
				locked = FALSE
				last_configurator = ui.user.name
				return TRUE

			var/obj/item/card/id/id = ui.user.GetIdCard()
			var/list/access = ui.user.GetAccess()
			if(check_access_list(access))
				locked = FALSE
				last_configurator = id ? id.registered_name : ui.user.name
				return TRUE
			return FALSE

		if("logout")
			if(locked)
				return FALSE
			locked = TRUE
			return TRUE

		if("one_access")
			if(locked)
				return FALSE
			one_access = !one_access
			return TRUE

		if("access")
			if(locked)
				return FALSE
			toggle_access(params["access"])
			return TRUE

/obj/item/airlock_electronics/proc/toggle_access(acc)
	if (acc == "all")
		conf_access = null
		return

	var/req = text2num(acc)
	if(!req)
		return FALSE

	LAZYINITLIST(conf_access)

	if (!(req in conf_access))
		conf_access += req
		return

	LAZYREMOVE(conf_access, req)

/obj/item/airlock_electronics/proc/get_available_accesses(mob/user)
	var/obj/item/card/id/id
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		id = H.get_idcard()
	else if(issilicon(user))
		var/mob/living/silicon/R = user
		id = R.idcard

	// Nothing
	if(!id || !id.GetAccess())
		return list()

	// Has engineer access, can put any access
	if(has_access(null, apply_any_access, id.GetAccess()))
		return SSaccess.get_all_station_access()

	// Not an engineer, can only pick your own accesses to program
	return id.GetAccess()

/obj/item/airlock_electronics/secure
	name = "secure airlock electronics"
	desc = "designed to be somewhat more resistant to hacking than standard electronics."
	secure = 1

/obj/item/airlock_electronics/secure/emag_act(remaining_charges, mob/user)
	to_chat(user, span_warning("You don't appear to be able to bypass this hardened device!"))
	return -1
