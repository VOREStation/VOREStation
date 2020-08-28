/datum/tgui_module/ship
	var/obj/effect/overmap/visitable/ship/linked
	var/list/viewers
	var/extra_view = 0

/datum/tgui_module/ship/New()
	. = ..()
	sync_linked()
	if(linked)
		name = "[linked.name] [name]"

/datum/tgui_module/ship/Destroy()
	if(LAZYLEN(viewers))
		for(var/weakref/W in viewers)
			var/M = W.resolve()
			if(M)
				unlook(M)
	. = ..()

/datum/tgui_module/ship/tgui_status(mob/user)
	. = ..()
	if(. > STATUS_DISABLED)
		if(viewing_overmap(user))
			look(user)
		return
	unlook(user)

/datum/tgui_module/ship/tgui_close(mob/user)
	. = ..()
	user.unset_machine()
	unlook(user)

/datum/tgui_module/ship/proc/sync_linked()
	var/obj/effect/overmap/visitable/ship/sector = get_overmap_sector(get_z(tgui_host()))
	if(!sector)
		return
	return attempt_hook_up_recursive(sector)

/datum/tgui_module/ship/proc/attempt_hook_up_recursive(obj/effect/overmap/visitable/ship/sector)
	if(attempt_hook_up(sector))
		return sector
	for(var/obj/effect/overmap/visitable/ship/candidate in sector)
		if((. = .(candidate)))
			return

/datum/tgui_module/ship/proc/attempt_hook_up(obj/effect/overmap/visitable/ship/sector)
	if(!istype(sector))
		return
	if(sector.check_ownership(tgui_host()))
		linked = sector
		return 1

/datum/tgui_module/ship/proc/look(var/mob/user)
	if(linked)
		user.set_machine(tgui_host())
		user.reset_view(linked)
	user.set_viewsize(world.view + extra_view)
	GLOB.moved_event.register(user, src, /datum/tgui_module/ship/proc/unlook)
	LAZYDISTINCTADD(viewers, weakref(user))

/datum/tgui_module/ship/proc/unlook(var/mob/user)
	user.reset_view()
	user.set_viewsize() // reset to default
	GLOB.moved_event.unregister(user, src, /datum/tgui_module/ship/proc/unlook)
	LAZYREMOVE(viewers, weakref(user))

/datum/tgui_module/ship/proc/viewing_overmap(mob/user)
	return (weakref(user) in viewers)

/datum/tgui_module/ship/check_eye(var/mob/user)
	if(!get_dist(user, tgui_host()) > 1 || user.blinded || !linked)
		unlook(user)
		return -1
	else
		return 0

// Navigation
/datum/tgui_module/ship/nav
	name = "Navigation Display"
	tgui_id = "OvermapNavigation"

/datum/tgui_module/ship/nav/tgui_interact(mob/user, datum/tgui/ui)
	if(!linked)
		var/obj/machinery/computer/ship/navigation/host = tgui_host()
		if(istype(host))
			// Real Computer path
			host.display_reconnect_dialog(user, "Navigation")
			return

		// NTOS Path
		if(!sync_linked())
			to_chat(user, "<span class='warning'>You don't appear to be on a spaceship...</span>")
			if(ui)
				ui.close(can_be_suspended = FALSE)
			if(ntos)
				var/obj/item/modular_computer/M = tgui_host()
				if(istype(M))
					M.kill_program()
		return

	. = ..()

/datum/tgui_module/ship/nav/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = ..()

	var/turf/T = get_turf(linked)
	var/obj/effect/overmap/visitable/sector/current_sector = locate() in T

	data["sector"] = current_sector ? current_sector.name : "Deep Space"
	data["sector_info"] = current_sector ? current_sector.desc : "Not Available"
	data["s_x"] = linked.x
	data["s_y"] = linked.y
	data["speed"] = round(linked.get_speed()*1000, 0.01)
	data["accel"] = round(linked.get_acceleration()*1000, 0.01)
	data["heading"] = linked.get_heading_degrees()
	data["viewing"] = viewing_overmap(user)

	if(linked.get_speed())
		data["ETAnext"] = "[round(linked.ETA()/10)] seconds"
	else
		data["ETAnext"] = "N/A"

	return data

/datum/tgui_module/ship/nav/tgui_act(action, params)
	if(..())
		return TRUE

	if(!linked)
		return FALSE

	if(action == "viewing")
		viewing_overmap(usr) ? unlook(usr) : look(usr)
		return TRUE

/datum/tgui_module/ship/nav/ntos
	ntos = TRUE