/**
 * /obj/screen/map_view_tg is map_view on steroids, existing simultaneously for compatibility and not driving me crazy
 * during implementation
 */
INITIALIZE_IMMEDIATE(/obj/screen/map_view_tg)
/obj/screen/map_view_tg
	name = "screen"
	icon_state = "blank"
	// Map view has to be on the lowest plane to enable proper lighting
	layer = MAP_VIEW_LAYER
	plane = MAP_VIEW_PLANE
	del_on_map_removal = FALSE

	// Weakrefs of all our viewers
	var/list/datum/weakref/viewing_clients = list()
	var/list/popup_plane_masters

/obj/screen/map_view_tg/Destroy()
	for(var/datum/weakref/client_ref in viewing_clients)
		hide_from_client(client_ref.resolve())

	return ..()

/obj/screen/map_view_tg/proc/generate_view(map_key)
	// Map keys have to start and end with an A-Z character,
	// and definitely NOT with a square bracket or even a number.
	// I wasted 6 hours on this. :agony:
	// -- Stylemistake
	assigned_map = map_key
	set_position(1, 1)

	popup_plane_masters = get_tgui_plane_masters()

	for(var/obj/screen/instance as anything in popup_plane_masters)
		instance.assigned_map = assigned_map
		instance.del_on_map_removal = FALSE
		instance.screen_loc = "[assigned_map]:1,1"

/**
 * Generates and displays the map view to a client
 * Make sure you at least try to pass tgui_window if map view needed on UI,
 * so it will wait a signal from TGUI, which tells windows is fully visible.
 *
 * If you use map view not in TGUI, just call it as usualy.
 * If UI needs planes, call display_to_client.
 *
 * * show_to - Mob which needs map view
 * * window - Optional. TGUI window which needs map view
 */
/obj/screen/map_view_tg/proc/display_to(mob/show_to, datum/tgui_window/window)
	if(window && !window.visible)
		RegisterSignal(window, COMSIG_TGUI_WINDOW_VISIBLE, PROC_REF(display_on_ui_visible))
	else
		display_to_client(show_to.client)

/obj/screen/map_view_tg/proc/display_on_ui_visible(datum/tgui_window/window, client/show_to)
	SIGNAL_HANDLER
	display_to_client(show_to)
	UnregisterSignal(window, COMSIG_TGUI_WINDOW_VISIBLE)

/obj/screen/map_view_tg/proc/display_to_client(client/show_to)
	show_to.register_map_obj(src)

	for(var/plane in popup_plane_masters)
		show_to.register_map_obj(plane)

	viewing_clients |= WEAKREF(show_to)

/obj/screen/map_view_tg/proc/hide_from(mob/hide_from)
	// hide_from_client(hide_from?.canon_client)
	hide_from_client(hide_from?.client)

/obj/screen/map_view_tg/proc/hide_from_client(client/hide_from)
	if(!hide_from)
		return
	hide_from.clear_map(assigned_map)
