/datum/tgui_module/uav
	name = "UAV Control"
	tgui_id = "UAV"
	ntos = TRUE
	var/obj/item/uav/current_uav = null //The UAV we're watching
	var/signal_strength = 0 //Our last signal strength report (cached for a few seconds)
	var/signal_test_counter = 0 //How long until next signal strength check
	var/list/viewers //Who's viewing a UAV through us
	var/adhoc_range = 30 //How far we can operate on a UAV without NTnet

/datum/tgui_module/uav/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = ..()

	if(current_uav)
		if(QDELETED(current_uav))
			clear_current()
		else if(signal_test_counter-- <= 0)
			signal_strength = get_signal_to(current_uav)
			if(!signal_strength)
				clear_current()
			else // Don't reset counter until we find a UAV that's actually in range we can stay connected to
				signal_test_counter = 20

	data["current_uav"] = null
	if(current_uav)
		data["current_uav"] = list("status" = current_uav.get_status_string(), "power" = current_uav.state == 1 ? 1 : null)
	data["signal_strength"] = signal_strength ? signal_strength >= 2 ? "High" : "Low" : "None"
	data["in_use"] = LAZYLEN(viewers)

	var/list/paired_map = list()
	var/obj/item/modular_computer/mc_host = tgui_host()
	if(istype(mc_host))
		for(var/datum/weakref/wr as anything in mc_host.paired_uavs)
			var/obj/item/uav/U = wr.resolve()
			paired_map.Add(list(list("name" = "[U ? U.nickname : "!!Missing!!"]", "uavref" = "\ref[U]")))

	data["paired_uavs"] = paired_map
	return data

/datum/tgui_module/uav/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	if(..())
		return TRUE

	switch(action)
		if("switch_uav")
			var/obj/item/uav/U = locate(params["switch_uav"]) //This is a \ref to the UAV itself
			if(!istype(U))
				to_chat(ui.user,span_warning("Something is blocking the connection to that UAV. In-person investigation is required."))
				return FALSE

			if(!get_signal_to(U))
				to_chat(ui.user,span_warning("The screen freezes for a moment, before returning to the UAV selection menu. It's not able to connect to that UAV."))
				return FALSE

			set_current(U)
			return TRUE

		if("del_uav")
			var/refstring = params["del_uav"] //This is a \ref to the UAV itself
			var/obj/item/modular_computer/mc_host = tgui_host()
			//This is so we can really scrape up any weakrefs that can't resolve
			for(var/datum/weakref/wr in mc_host.paired_uavs)
				if(wr.reference == refstring)
					if(current_uav?.weak_reference == wr)
						set_current(null)
					LAZYREMOVE(mc_host.paired_uavs, wr)
			return TRUE

		if("view_uav")
			if(!current_uav)
				return FALSE

			if(!current_uav.state)
				to_chat(ui.user,span_warning("The screen freezes for a moment, before returning to the UAV selection menu. It's not able to connect to that UAV."))
			else
				if(get_dist(ui.user, tgui_host()) > 1 || ui.user.blinded)
					return FALSE
				else if(!viewing_uav(ui.user))
					if(!viewers) viewers = list() // List must exist for pass by reference to work
					start_coordinated_remoteview(ui.user, current_uav, viewers, /datum/remote_view_config/uav_control)
				else
					ui.user.reset_perspective()
			return TRUE

		if("power_uav")
			if(!current_uav)
				return FALSE
			else if(current_uav.toggle_power())
				SEND_SIGNAL(src,COMSIG_REMOTE_VIEW_CLEAR)
				return TRUE

/datum/tgui_module/uav/proc/set_current(var/obj/item/uav/U)
	if(current_uav == U)
		return

	signal_strength = 0
	current_uav = U
	RegisterSignal(U, COMSIG_MOVABLE_Z_CHANGED, PROC_REF(current_uav_changed_z))
	SEND_SIGNAL(src,COMSIG_REMOTE_VIEW_CLEAR)

/datum/tgui_module/uav/proc/clear_current()
	if(!current_uav)
		return

	UnregisterSignal(current_uav, COMSIG_MOVABLE_Z_CHANGED)
	signal_strength = 0
	current_uav = null
	SEND_SIGNAL(src,COMSIG_REMOTE_VIEW_CLEAR)

/datum/tgui_module/uav/proc/current_uav_changed_z(old_z, new_z)
	SIGNAL_HANDLER
	signal_strength = get_signal_to(current_uav)
	if(!signal_strength)
		clear_current()

////
//// Finding signal strength between us and the UAV
////
/datum/tgui_module/uav/proc/get_signal_to(atom/movable/AM)
	// Following roughly the ntnet signal levels
	// 0 is none
	// 1 is weak
	// 2 is strong
	var/obj/item/modular_computer/host = tgui_host() //Better not add this to anything other than modular computers.
	if(!istype(host))
		return
	var/our_signal = host.get_ntnet_status() //1 low, 2 good, 3 wired, 0 none
	var/their_z = get_z(AM)

	//If we have no NTnet connection don't bother getting theirs
	if(!our_signal)
		if(get_z(host) == their_z && (get_dist(host, AM) < adhoc_range))
			return 1 //We can connect (with weak signal) in same z without ntnet, within 30 turfs
		else
			return 0

	var/list/zlevels_in_range = using_map.get_map_levels(their_z, FALSE)
	var/list/zlevels_in_long_range = using_map.get_map_levels(their_z, TRUE, om_range = DEFAULT_OVERMAP_RANGE) - zlevels_in_range
	var/their_signal = 0
	// Measure z-distance between the AM passed in and the nearest relay
	for(var/obj/machinery/ntnet_relay/R as anything in ntnet_global.relays)
		if(!R.operable())
			continue
		if(R.z == their_z)
			their_signal = 2
			break
		if(R.z in zlevels_in_range)
			their_signal = 2
			break
		if(R.z in zlevels_in_long_range)
			their_signal = 1
			break

	// AM passed in has no NTnet at all
	if(!their_signal)
		if(get_z(host) == their_z && (get_dist(host, AM) < adhoc_range))
			return 1 //We can connect (with weak signal) in same z without ntnet, within 30 turfs
		else
			return 0
	else
		return max(our_signal, their_signal)

/datum/tgui_module/uav/tgui_status(mob/user)
	. = ..()
	if(. > STATUS_DISABLED)
		return
	user.reset_perspective()

/datum/tgui_module/uav/proc/viewing_uav(mob/user)
	return (WEAKREF(user) in viewers)

/datum/tgui_module/uav/look(mob/user)
	if(issilicon(user)) //Too complicated for me to want to mess with at the moment
		to_chat(user, span_warning("Regulations prevent you from controlling several corporeal forms at the same time!"))
		return
	if(!current_uav)
		return
	current_uav.add_master(user)
	LAZYDISTINCTADD(viewers, WEAKREF(user))

/datum/tgui_module/uav/unlook(mob/user)
	if(current_uav)
		current_uav.remove_master(user)
	LAZYREMOVE(viewers, WEAKREF(user))

/datum/tgui_module/uav/tgui_close(mob/user)
	. = ..()
	user.reset_perspective()

////
////  Settings for remote view
////
/datum/remote_view_config/uav_control
	relay_movement = TRUE
	override_health_hud = TRUE
	var/original_health_hud_icon

/datum/remote_view_config/uav_control/handle_relay_movement( datum/component/remote_view/owner_component, mob/host_mob, direction)
	var/datum/tgui_module/uav/tgui_owner = owner_component.get_coordinator()
	if(tgui_owner?.current_uav)
		return tgui_owner.current_uav.relaymove(host_mob, direction, tgui_owner.signal_strength)
	return FALSE

/datum/remote_view_config/uav_control/handle_apply_visuals( datum/component/remote_view/owner_component, mob/host_mob)
	var/datum/tgui_module/uav/tgui_owner = owner_component.get_coordinator()
	if(!tgui_owner)
		return
	if(get_dist(host_mob, tgui_owner.tgui_host()) > 1 || !tgui_owner.current_uav)
		host_mob.reset_perspective()
		return
	// Apply hud
	host_mob.overlay_fullscreen("fishbed",/atom/movable/screen/fullscreen/fishbed)
	host_mob.overlay_fullscreen("scanlines",/atom/movable/screen/fullscreen/scanline)
	if(tgui_owner.signal_strength <= 1)
		host_mob.overlay_fullscreen("whitenoise",/atom/movable/screen/fullscreen/noise)
	else
		host_mob.clear_fullscreen("whitenoise", 0)

/datum/remote_view_config/uav_control/handle_remove_visuals( datum/component/remote_view/owner_component, mob/host_mob)
	// Clear hud
	host_mob.clear_fullscreen("fishbed",0)
	host_mob.clear_fullscreen("scanlines",0)
	host_mob.clear_fullscreen("whitenoise",0)

// We are responsible for restoring the health UI's icons on removal
/datum/remote_view_config/uav_control/attached_to_mob( datum/component/remote_view/owner_component, mob/host_mob)
	original_health_hud_icon = host_mob.healths?.icon

/datum/remote_view_config/uav_control/detatch_from_mob( datum/component/remote_view/owner_component, mob/host_mob)
	if(host_mob.healths && original_health_hud_icon)
		host_mob.healths.icon = original_health_hud_icon
		host_mob.healths.appearance = null

// Show the uav health instead of the mob's while it is viewing
/datum/remote_view_config/uav_control/handle_hud_health( datum/component/remote_view/owner_component, mob/host_mob)
	var/datum/tgui_module/uav/tgui_owner = owner_component.get_coordinator()

	var/mutable_appearance/MA = new (host_mob.healths)
	MA.icon = 'icons/mob/screen1_robot_minimalist.dmi'
	MA.cut_overlays()

	if(!tgui_owner?.current_uav)
		MA.icon_state = "health7"
	else
		switch(tgui_owner.current_uav.health)
			if(100 to INFINITY)
				MA.icon_state = "health0"
			if(80 to 100)
				MA.icon_state = "health1"
			if(60 to 80)
				MA.icon_state = "health2"
			if(40 to 60)
				MA.icon_state = "health3"
			if(20 to 40)
				MA.icon_state = "health4"
			if(0 to 20)
				MA.icon_state = "health5"
			else
				MA.icon_state = "health6"

	host_mob.healths.icon_state = "blank"
	host_mob.healths.appearance = MA
	return COMSIG_COMPONENT_HANDLED_HEALTH_ICON
