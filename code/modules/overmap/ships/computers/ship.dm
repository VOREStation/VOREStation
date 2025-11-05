/*
While these computers can be placed anywhere, they will only function if placed on either a non-space, non-shuttle turf
with an /obj/effect/overmap/visitable/ship present elsewhere on that z level, or else placed in a shuttle area with an /obj/effect/overmap/visitable/ship
somewhere on that shuttle. Subtypes of these can be then used to perform ship overmap movement functions.
*/
/obj/machinery/computer/ship
	var/obj/effect/overmap/visitable/ship/linked
	var/list/viewers // Weakrefs to mobs in direct-view mode.
	var/extra_view = 0 // how much the view is increased by when the mob is in overmap mode.

// A late init operation called in SSshuttles, used to attach the thing to the right ship.
/obj/machinery/computer/ship/proc/attempt_hook_up(obj/effect/overmap/visitable/ship/sector)
	if(!istype(sector))
		return
	if(sector.check_ownership(src))
		linked = sector
		return 1

/obj/machinery/computer/ship/proc/sync_linked(var/user = null)
	var/obj/effect/overmap/visitable/ship/sector = get_overmap_sector(z)
	if(!sector)
		return
	. = attempt_hook_up_recursive(sector)
	if(. && linked && user)
		to_chat(user, span_notice("[src] reconnected to [linked]"))
		user << browse(null, "window=[src]") // close reconnect dialog

/obj/machinery/computer/ship/proc/attempt_hook_up_recursive(obj/effect/overmap/visitable/ship/sector)
	if(attempt_hook_up(sector))
		return sector
	for(var/obj/effect/overmap/visitable/ship/candidate in sector)
		if((. = .(candidate)))
			return

/obj/machinery/computer/ship/proc/display_reconnect_dialog(var/mob/user, var/flavor)
	var/datum/browser/popup = new (user, "[src]", "[src]")
	if(viewing_overmap(user))
		user.reset_perspective()
	popup.set_content("<center>" + span_bold(span_red("Error")) + "<br>Unable to connect to [flavor].<br><a href='byond://?src=\ref[src];sync=1'>Reconnect</a></center>")
	popup.open()

/obj/machinery/computer/ship/Topic(href, href_list)
	if(..())
		return TRUE
	if(href_list["sync"])
		if(sync_linked(usr))
			interface_interact(usr)
		return TRUE

// In computer_shims for now - we had to define it.
// /obj/machinery/computer/ship/interface_interact(var/mob/user)
// 	ui_interact(user)
// 	return TRUE

/obj/machinery/computer/ship/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	if(..())
		return TRUE
	switch(action)
		if("sync")
			sync_linked(ui.user)
			return TRUE
		if("close")
			ui.user.reset_perspective()
			return TRUE
	return FALSE

// Management of mob view displacement. look to shift view to the ship on the overmap; unlook to shift back.

/obj/machinery/computer/ship/look(var/mob/user)
	apply_visual(user)
	if(linked.real_appearance)
		user.client?.images += linked.real_appearance
	user.set_machine(src)
	if(isliving(user))
		var/mob/living/L = user
		L.handle_vision()
	user.set_viewsize(world.view + extra_view)

/obj/machinery/computer/ship/unlook(var/mob/user)
	user.unset_machine()
	if(linked && linked.real_appearance && user.client)
		user.client.images -= linked.real_appearance
	if(isliving(user))
		var/mob/living/L = user
		L.handle_vision()
	user.set_viewsize() // reset to default

/obj/machinery/computer/ship/proc/viewing_overmap(mob/user)
	return (WEAKREF(user) in viewers)

/obj/machinery/computer/ship/tgui_close(mob/user)
	. = ..()
	user.reset_perspective()

/obj/machinery/computer/ship/check_eye(var/mob/user)
	if(user.blinded || !linked)
		user.reset_perspective()
		return -1
	else
		return 0

/obj/machinery/computer/ship/sensors/Destroy()
	sensors = null
	. = ..()
