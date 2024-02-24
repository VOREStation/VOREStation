/datum/tgui_module/uav
	name = "UAV Control"
	tgui_id = "UAV"
	ntos = TRUE
	var/obj/item/device/uav/current_uav = null //The UAV we're watching
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
			var/obj/item/device/uav/U = wr.resolve()
			paired_map.Add(list(list("name" = "[U ? U.nickname : "!!Missing!!"]", "uavref" = "\ref[U]")))

	data["paired_uavs"] = paired_map
	return data

/datum/tgui_module/uav/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	if(..())
		return TRUE

	switch(action)
		if("switch_uav")
			var/obj/item/device/uav/U = locate(params["switch_uav"]) //This is a \ref to the UAV itself
			if(!istype(U))
				to_chat(usr,"<span class='warning'>Something is blocking the connection to that UAV. In-person investigation is required.</span>")
				return FALSE

			if(!get_signal_to(U))
				to_chat(usr,"<span class='warning'>The screen freezes for a moment, before returning to the UAV selection menu. It's not able to connect to that UAV.</span>")
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

			if(current_uav.check_eye(usr) < 0)
				to_chat(usr,"<span class='warning'>The screen freezes for a moment, before returning to the UAV selection menu. It's not able to connect to that UAV.</span>")
			else
				viewing_uav(usr) ? unlook(usr) : look(usr)
			return TRUE

		if("power_uav")
			if(!current_uav)
				return FALSE
			else if(current_uav.toggle_power())
				//Clean up viewers faster
				if(LAZYLEN(viewers))
					for(var/datum/weakref/W in viewers)
						var/M = W.resolve()
						if(M)
							unlook(M)
				return TRUE

/datum/tgui_module/uav/proc/set_current(var/obj/item/device/uav/U)
	if(current_uav == U)
		return

	signal_strength = 0
	current_uav = U
	RegisterSignal(U, COMSIG_MOVABLE_Z_CHANGED, PROC_REF(current_uav_changed_z))

	if(LAZYLEN(viewers))
		for(var/datum/weakref/W in viewers)
			var/M = W.resolve()
			if(M)
				look(M)

/datum/tgui_module/uav/proc/clear_current()
	if(!current_uav)
		return

	UnregisterSignal(current_uav, COMSIG_MOVABLE_Z_CHANGED)
	signal_strength = 0
	current_uav = null

	if(LAZYLEN(viewers))
		for(var/datum/weakref/W in viewers)
			var/M = W.resolve()
			if(M)
				to_chat(M, "<span class='warning'>You're disconnected from the UAV's camera!</span>")
				unlook(M)

/datum/tgui_module/uav/proc/current_uav_changed_z(old_z, new_z)
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

/* All handling viewers */
/datum/tgui_module/uav/Destroy()
	if(LAZYLEN(viewers))
		for(var/datum/weakref/W in viewers)
			var/M = W.resolve()
			if(M)
				unlook(M)
	. = ..()

/datum/tgui_module/uav/tgui_status(mob/user)
	. = ..()
	if(. > STATUS_DISABLED)
		if(viewing_uav(user))
			look(user)
		return
	unlook(user)

/datum/tgui_module/uav/tgui_close(mob/user)
	. = ..()
	unlook(user)

/datum/tgui_module/uav/proc/viewing_uav(mob/user)
	return (WEAKREF(user) in viewers)

/datum/tgui_module/uav/proc/look(mob/user)
	if(issilicon(user)) //Too complicated for me to want to mess with at the moment
		to_chat(user, "<span class='warning'>Regulations prevent you from controlling several corporeal forms at the same time!</span>")
		return

	if(!current_uav)
		return

	if(user.machine != tgui_host())
		user.set_machine(tgui_host())
	user.reset_view(current_uav)
	current_uav.add_master(user)
	LAZYDISTINCTADD(viewers, WEAKREF(user))

/datum/tgui_module/uav/proc/unlook(mob/user)
	user.unset_machine()
	user.reset_view()
	if(current_uav)
		current_uav.remove_master(user)
	LAZYREMOVE(viewers, WEAKREF(user))

/datum/tgui_module/uav/check_eye(mob/user)
	if(get_dist(user, tgui_host()) > 1 || user.blinded || !current_uav)
		unlook(user)
		return -1

	var/viewflag = current_uav.check_eye(user)
	if(viewflag < 0) //camera doesn't work
		unlook(user)
		return -1

	return viewflag

////
//// Relaying movements to the UAV
////
/datum/tgui_module/uav/relaymove(var/mob/user, direction)
	if(current_uav)
		return current_uav.relaymove(user, direction, signal_strength)

////
////  The effects when looking through a UAV
////
/datum/tgui_module/uav/apply_visual(mob/M)
	if(!M.client)
		return
	if(WEAKREF(M) in viewers)
		M.overlay_fullscreen("fishbed",/obj/screen/fullscreen/fishbed)
		M.overlay_fullscreen("scanlines",/obj/screen/fullscreen/scanline)

		if(signal_strength <= 1)
			M.overlay_fullscreen("whitenoise",/obj/screen/fullscreen/noise)
		else
			M.clear_fullscreen("whitenoise", 0)
	else
		remove_visual(M)

/datum/tgui_module/uav/remove_visual(mob/M)
	if(!M.client)
		return
	M.clear_fullscreen("fishbed",0)
	M.clear_fullscreen("scanlines",0)
	M.clear_fullscreen("whitenoise",0)
