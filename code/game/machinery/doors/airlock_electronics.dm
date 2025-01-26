/obj/item/airlock_electronics
	name = "airlock electronics"
	icon = 'icons/obj/doors/door_assembly.dmi'
	icon_state = "door_electronics"
	w_class = ITEMSIZE_SMALL //It should be tiny! -Agouri

	matter = list(MAT_STEEL = 50,MAT_GLASS = 50)

	req_one_access = list(access_engine, access_talon) // Access to unlock the device, ignored if emagged //VOREStation Edit - Add talon
	var/list/apply_any_access = list(access_engine) // Can apply any access, not just their own

	var/secure = 0 //if set, then wires will be randomized and bolts will drop if the door is broken
	var/list/conf_access = null
	var/one_access = 0 //if set to 1, door would receive req_one_access instead of req_access
	var/last_configurator = null
	var/locked = 1
	var/emagged = 0

/obj/item/airlock_electronics/emag_act(var/remaining_charges, var/mob/user)
	if(!emagged)
		emagged = 1
		to_chat(user, span_notice("You remove the access restrictions on [src]!"))
		return 1

/obj/item/airlock_electronics/attack_self(mob/user as mob)
	if (!ishuman(user) && !istype(user,/mob/living/silicon/robot))
		return ..(user)

	var/t1 = span_bold("Access control") + "<br>\n"

	if (last_configurator)
		t1 += "Operator: [last_configurator]<br>"

	if (locked)
		t1 += "<a href='byond://?src=\ref[src];login=1'>Unlock Interface</a><hr>"
	else
		t1 += "<a href='byond://?src=\ref[src];logout=1'>Lock Interface</a><hr>"

		t1 += "Access requirement is set to "
		t1 += one_access ? "<a style='color: green' href='byond://?src=\ref[src];one_access=1'>ONE</a><hr>" : "<a style='color: red' href='byond://?src=\ref[src];one_access=1'>ALL</a><hr>"

		t1 += conf_access == null ? "<font color=red>All</font><br>" : "<a href='byond://?src=\ref[src];access=all'>All</a><br>"

		t1 += "<br>"

		var/list/accesses = get_available_accesses(user)
		for (var/acc in accesses)
			var/aname = get_access_desc(acc)

			if (!conf_access || !conf_access.len || !(acc in conf_access))
				t1 += "<a href='byond://?src=\ref[src];access=[acc]'>[aname]</a><br>"
			else if(one_access)
				t1 += "<a style='color: green' href='byond://?src=\ref[src];access=[acc]'>[aname]</a><br>"
			else
				t1 += "<a style='color: red' href='byond://?src=\ref[src];access=[acc]'>[aname]</a><br>"

	t1 += text("<p><a href='byond://?src=\ref[];close=1'>Close</a></p>\n", src)

	user << browse("<html>[t1]</html>", "window=airlock_electronics")
	onclose(user, "airlock")

/obj/item/airlock_electronics/Topic(href, href_list)
	..()
	if (usr.stat || usr.restrained() || (!ishuman(usr) && !istype(usr,/mob/living/silicon)))
		return
	if (href_list["close"])
		usr << browse(null, "window=airlock_electronics")
		return

	if (href_list["login"])
		if(emagged)
			src.locked = 0
			src.last_configurator = usr.name
		else if(issilicon(usr))
			src.locked = 0
			src.last_configurator = usr.name
		else if(isliving(usr))
			var/obj/item/card/id/id
			if(ishuman(usr))
				var/mob/living/carbon/human/H = usr
				id = H.get_idcard()
				// In their ID slot?
				if(id && src.check_access(id))
					src.locked = 0
					src.last_configurator = id.registered_name
			// Still locked, human handling didn't do it!
			if(locked)
				var/obj/item/I = usr.get_active_hand()
				id = I?.GetID()
				if(id && src.check_access(id))
					src.locked = 0
					src.last_configurator = id.registered_name

	if (locked)
		return

	if (href_list["logout"])
		locked = 1

	if (href_list["one_access"])
		one_access = !one_access

	if (href_list["access"])
		toggle_access(href_list["access"])

	attack_self(usr)

/obj/item/airlock_electronics/proc/toggle_access(var/acc)
	if (acc == "all")
		conf_access = null
	else
		var/req = text2num(acc)

		if (conf_access == null)
			conf_access = list()

		if (!(req in conf_access))
			conf_access += req
		else
			conf_access -= req
			if (!conf_access.len)
				conf_access = null

/obj/item/airlock_electronics/proc/get_available_accesses(var/mob/user)
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
	else if(has_access(null, apply_any_access, id.GetAccess()))
		return get_all_station_access()

	// Not an engineer, can only pick your own accesses to program
	else
		return id.GetAccess()

/obj/item/airlock_electronics/secure
	name = "secure airlock electronics"
	desc = "designed to be somewhat more resistant to hacking than standard electronics."
	origin_tech = list(TECH_DATA = 2)
	secure = 1

/obj/item/airlock_electronics/secure/emag_act(var/remaining_charges, var/mob/user)
	to_chat(user, span_warning("You don't appear to be able to bypass this hardened device!"))
	return -1
