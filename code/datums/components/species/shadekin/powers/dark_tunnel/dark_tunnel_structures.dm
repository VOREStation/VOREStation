GLOBAL_LIST_BOILERPLATE(all_darkportal_hubs, /obj/structure/dark_portal/hub)
GLOBAL_LIST_BOILERPLATE(all_darkportal_minions, /obj/structure/dark_portal/minion)
/obj/structure/dark_portal
	name = "Dark portal"
	icon = 'icons/obj/shadekin_portal.dmi'
	density = TRUE
	anchored = TRUE
	var/locked = null
	var/locked_name = ""
	var/one_time_use = FALSE
	var/precision = 1

/obj/structure/dark_portal/proc/close_portal()
	return

/obj/structure/dark_portal/proc/teleport(atom/movable/M as mob|obj)
	if(!locked)
		return
	if(isliving(M))
		var/mob/living/to_check = M
		var/datum/component/shadekin/SK = to_check.GetComponent(/datum/component/shadekin)
		if(SK && SK.in_dark_respite)
			to_chat(M, span_warning("You can't go through this portal so soon after an emergency warp!"))
			to_check.Stun(10)
			return

	do_teleport(M, locked, precision, local = FALSE, bohsafe = TRUE)

	if(one_time_use)
		one_time_use = 0
		close_portal()
	return

// These things are always on. By default they always teleport you to themselves.
/obj/structure/dark_portal/hub
	icon_state = "hub_portal"
	desc = "A large portal. Touching it without going through may alter the destination."
	var/list/destination_station_areas // Override this in map files!
	var/list/destination_wilderness_areas // Override this in map files!

/obj/structure/dark_portal/hub/Initialize(mapload)
	. = ..()
	locked = src
	locked_name = src.name

/obj/structure/dark_portal/hub/Initialize(mapload)
	. = ..()
	set_light(2, 3, "#ffffff")

/obj/structure/dark_portal/hub/close_portal()
	locked = src
	locked_name = src.name
	precision = 1

/obj/structure/dark_portal/hub/attack_hand(mob/living/user)
	if(!isliving(user))
		return
	var/datum/component/shadekin/SK = user.GetComponent(/datum/component/shadekin)
	if(SK)
		if(SK.in_dark_respite)
			to_chat(user, span_warning("You can't use this so soon after an emergency warp!"))
			return
		if(SK.in_phase)
			to_chat(user, span_warning("You can't use this while phase shifted!"))
			return
		if(locked != src)
			var/confirm = tgui_alert(user, "This portal is currently open to [locked_name]. Change the portal destination?", "Change Portal Destination", list("Yes", "Cancel"))
			if(!confirm || confirm == "Cancel")
				return
		var/list/L = list()
		for(var/obj/structure/dark_portal/hub/H in GLOB.all_darkportal_hubs)
			if(H == src)
				L["This Portal"] = H
			else
				L[H.name] = H
		for(var/obj/structure/dark_portal/minion/M in GLOB.all_darkportal_minions)
			var/tmpname = "Dark Portal ([get_area(M)])"
			L[tmpname] = M
		var/desc = tgui_input_list(user, "Please select a hub portal to connect to.", "Portal Menu", L)
		if(!desc)
			return
		locked = L[desc]
		locked_name = desc
		return
	else if(locked_name == "somewhere on the station" || locked_name == "somewhere in the wilderness")
		to_chat(user, span_warning("The portal distorts for a moment, before returning to how it was, seemingly already determined where to send you."))
		return
	else if(istype(user, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		if(H.job && H.job != JOB_OUTSIDER && LAZYLEN(destination_station_areas))
			var/list/floors = list()
			var/area/picked_area = pick(destination_station_areas)
			for(var/turf/simulated/floor/floor in get_area_turfs(picked_area))
				floors.Add(floor)
			if(!LAZYLEN(floors))
				log_and_message_admins("[src]: There were no floors to teleport to in [picked_area]!")
				to_chat(user, span_warning("The portal distorts for a moment, seemingly unable to determine where to send you."))
				close_portal()
				destination_station_areas.Remove(picked_area)
				return
			locked = pick(floors)
			locked_name = "somewhere on the station"
			one_time_use = TRUE
			precision = 0
			to_chat(user, span_notice("The portal distorts for a moment, resolving itself soon after. You feel like it will lead you to the station now."))
			return
	if(!LAZYLEN(destination_wilderness_areas))
		to_chat(user, span_warning("The portal distorts for a moment, seemingly unable to determine where to send you."))
		close_portal()
		return
	var/list/floors = list()
	var/area/picked_area = pick(destination_wilderness_areas)
	for(var/turf/simulated/floor/floor in get_area_turfs(picked_area))
		floors.Add(floor)
	if(!LAZYLEN(floors))
		log_and_message_admins("[src]: There were no floors to teleport to in [picked_area]!")
		to_chat(user, span_warning("The portal distorts for a moment, seemingly unable to determine where to send you."))
		close_portal()
		destination_wilderness_areas.Remove(picked_area)
		return
	locked = pick(floors)
	locked_name = "somewhere in the wilderness"
	one_time_use = TRUE
	precision = 0
	to_chat(user, span_notice("The portal distorts for a moment, resolving itself soon after. You feel like it will lead you to somewhere in the wilderness now."))
	return

/obj/structure/dark_portal/hub/Bumped(M as mob|obj)
	spawn()
		teleport(M)
	return

// These things have an off state. A shadekin has to boop them to turn it on
/obj/structure/dark_portal/minion
	icon_state = "minion0"

/obj/structure/dark_portal/minion/close_portal()
	locked = null
	locked_name = ""
	precision = 1
	icon_state = "minion0"

/obj/structure/dark_portal/minion/attack_hand(mob/living/user)
	if(!isliving(user))
		return
	var/datum/component/shadekin/SK = user.GetComponent(/datum/component/shadekin)
	if(SK)
		if(SK.in_dark_respite)
			to_chat(user, span_warning("You can't use this so soon after an emergency warp!"))
			return FALSE
		if(SK.in_phase)
			to_chat(user, span_warning("You can't use this while phase shifted!"))
			return FALSE
		if(icon_state == "minion1")
			var/confirm = tgui_alert(user, "This portal is currently open to [locked_name]. Close this portal to the dark?", "Close Portal", list("Yes", "Cancel"))
			if(!confirm || confirm == "Cancel")
				return
			if(confirm == "Yes")
				close_portal()
				return
		if(SK.shadekin_get_energy() < 10)
			to_chat(user, span_warning("Not enough energy to open up the portal! (10 required)"))
			return
		if(!LAZYLEN(GLOB.all_darkportal_hubs))
			to_chat(user, span_warning("No hub portals exist!"))
			return
		if(LAZYLEN(GLOB.all_darkportal_hubs) == 1)
			SK.shadekin_adjust_energy(user, -10)
			var/obj/structure/dark_portal/target = GLOB.all_darkportal_hubs[1]
			locked = target
			locked_name = target.name
			icon_state = "minion1"
			addtimer(CALLBACK(src, PROC_REF(check_to_close),target), 5 MINUTES, TIMER_DELETE_ME)
			return
		var/list/L = list()
		for(var/obj/structure/dark_portal/hub/H in GLOB.all_darkportal_hubs)
			L[H.name] = H
		var/desc = tgui_input_list(user, "Please select a hub portal to connect to.", "Portal Menu", L)
		if(!desc)
			return
		locked = L[desc]
		locked_name = desc
		icon_state = "minion1"
		addtimer(CALLBACK(src, PROC_REF(check_to_close_desc),locked), 5 MINUTES, TIMER_DELETE_ME)
		return
	else if(!istype(user, /mob/living))
		return
	else if(icon_state == "minion0")
		to_chat(user, span_notice("You touch the portal... nothing happens."))
	else
		to_chat(user, span_notice("You touch the portal, your hand able to pass through without harm."))

/obj/structure/dark_portal/proc/check_to_close(var/obj/structure/dark_portal/target)
	if(locked == target)
		close_portal()

/obj/structure/dark_portal/proc/check_to_close_desc(var/old_locked)
	if(locked == old_locked)
		close_portal()

/obj/structure/dark_portal/minion/Bumped(M as mob|obj)
	spawn()
		if(icon_state == "minion1")
			teleport(M)
	return
