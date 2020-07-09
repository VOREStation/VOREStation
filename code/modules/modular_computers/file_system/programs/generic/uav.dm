/obj/item/modular_computer
	var/list/paired_uavs //Weakrefs, don't worry about it!

/datum/computer_file/program/uav
	filename = "rigger"
	filedesc = "UAV Control"
	nanomodule_path = /datum/nano_module/uav
	program_icon_state = "comm_monitor"
	program_key_state = "generic_key"
	program_menu_icon = "link"
	extended_desc = "This program allows remote control of certain drones, but only when paired with this device."
	size = 12
	available_on_ntnet = 1
	//requires_ntnet = 1

/datum/nano_module/uav
	name = "UAV Control program"
	var/obj/item/device/uav/current_uav = null //The UAV we're watching
	var/signal_strength = 0 //Our last signal strength report (cached for a few seconds)
	var/signal_test_counter = 0 //How long until next signal strength check
	var/list/viewers //Who's viewing a UAV through us
	var/adhoc_range = 30 //How far we can operate on a UAV without NTnet

/datum/nano_module/uav/Destroy()
	if(LAZYLEN(viewers))
		for(var/weakref/W in viewers)
			var/M = W.resolve()
			if(M)
				unlook(M)
	. = ..()

/datum/nano_module/uav/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1, state = default_state)
	var/list/data = host.initial_data()

	if(current_uav)
		if(QDELETED(current_uav))
			set_current(null)
		else if(signal_test_counter-- <= 0)
			signal_strength = get_signal_to(current_uav)
			if(!signal_strength)
				set_current(null)
			else // Don't reset counter until we find a UAV that's actually in range we can stay connected to
				signal_test_counter = 20

	data["current_uav"] = null
	if(current_uav)
		data["current_uav"] = list("status" = current_uav.get_status_string(), "power" = current_uav.state == 1 ? 1 : null)
	data["signal_strength"] = signal_strength ? signal_strength >= 2 ? "High" : "Low" : "None"
	data["in_use"] = LAZYLEN(viewers)

	var/list/paired_map = list()
	var/obj/item/modular_computer/mc_host = nano_host()
	if(istype(mc_host))
		for(var/puav in mc_host.paired_uavs)
			var/weakref/wr = puav
			var/obj/item/device/uav/U = wr.resolve()
			paired_map[++paired_map.len] = list("name" = "[U ? U.nickname : "!!Missing!!"]", "uavref" = "\ref[U]")

	data["paired_uavs"] = paired_map

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "mod_uav.tmpl", "UAV Control", 600, 500, state = state)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/datum/nano_module/uav/Topic(var/href, var/href_list = list(), var/datum/topic_state/state)
	if((. = ..()))
		return
	state = state || DefaultTopicState() || global.default_state
	if(CanUseTopic(usr, state, href_list) == STATUS_INTERACTIVE)
		CouldUseTopic(usr)
		return OnTopic(usr, href_list, state)
	CouldNotUseTopic(usr)
	return TRUE

/datum/nano_module/uav/proc/OnTopic(var/mob/user, var/list/href_list)
	if(href_list["switch_uav"])
		var/obj/item/device/uav/U = locate(href_list["switch_uav"]) //This is a \ref to the UAV itself
		if(!istype(U))
			to_chat(usr,"<span class='warning'>Something is blocking the connection to that UAV. In-person investigation is required.</span>")
			return TOPIC_NOACTION

		if(!get_signal_to(U))
			to_chat(usr,"<span class='warning'>The screen freezes for a moment, before returning to the UAV selection menu. It's not able to connect to that UAV.</span>")
			return TOPIC_NOACTION

		set_current(U)
		return TOPIC_REFRESH

	if(href_list["del_uav"])
		var/refstring = href_list["del_uav"] //This is a \ref to the UAV itself
		var/obj/item/modular_computer/mc_host = nano_host()
		//This is so we can really scrape up any weakrefs that can't resolve
		for(var/weakref/wr in mc_host.paired_uavs)
			if(wr.ref == refstring)
				if(current_uav?.weakref == wr)
					set_current(null)
				LAZYREMOVE(mc_host.paired_uavs, wr)

	else if(href_list["view_uav"])
		if(!current_uav)
			return TOPIC_NOACTION

		if(current_uav.check_eye(user) < 0)
			to_chat(usr,"<span class='warning'>The screen freezes for a moment, before returning to the UAV selection menu. It's not able to connect to that UAV.</span>")
		else
			viewing_uav(user) ? unlook(user) : look(user)
		return TOPIC_NOACTION

	else if(href_list["power_uav"])
		if(!current_uav)
			return TOPIC_NOACTION
		else if(current_uav.toggle_power())
			//Clean up viewers faster
			if(LAZYLEN(viewers))
				for(var/weakref/W in viewers)
					var/M = W.resolve()
					if(M)
						unlook(M)
			return TOPIC_REFRESH

/datum/nano_module/uav/proc/DefaultTopicState()
	return global.default_state

/datum/nano_module/uav/proc/CouldNotUseTopic(mob/user)
	. = ..()
	unlook(user)

/datum/nano_module/uav/proc/CouldUseTopic(mob/user)
	. = ..()
	if(viewing_uav(user))
		look(user)

/datum/nano_module/uav/proc/set_current(var/obj/item/device/uav/U)
	if(current_uav == U)
		return

	signal_strength = 0
	current_uav = U

	if(LAZYLEN(viewers))
		for(var/weakref/W in viewers)
			var/M = W.resolve()
			if(M)
				if(current_uav)
					to_chat(M, "<span class='warning'>You're disconnected from the UAV's camera!</span>")
					unlook(M)
				else
					look(M)

////
//// Finding signal strength between us and the UAV
////
/datum/nano_module/uav/proc/get_signal_to(var/atom/movable/AM)
	// Following roughly the ntnet signal levels
	// 0 is none
	// 1 is weak
	// 2 is strong
	var/obj/item/modular_computer/host = nano_host() //Better not add this to anything other than modular computers.
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
	for(var/relay in ntnet_global.relays)
		var/obj/machinery/ntnet_relay/R = relay
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

	if(!their_signal) //They have no NTnet at all
		if(get_z(host) == their_z && (get_dist(host, AM) < adhoc_range))
			return 1 //We can connect (with weak signal) in same z without ntnet, within 30 turfs
		else
			return 0
	else
		return max(our_signal, their_signal)

////
//// UAV viewer handling
////
/datum/nano_module/uav/proc/viewing_uav(mob/user)
	return (weakref(user) in viewers)

/datum/nano_module/uav/proc/look(var/mob/user)
	if(issilicon(user)) //Too complicated for me to want to mess with at the moment
		to_chat(user, "<span class='warning'>Regulations prevent you from controlling several corporeal forms at the same time!</span>")
		return

	if(!current_uav)
		return

	user.set_machine(nano_host())
	user.reset_view(current_uav)
	current_uav.add_master(user)
	LAZYDISTINCTADD(viewers, weakref(user))

/datum/nano_module/uav/proc/unlook(var/mob/user)
	user.unset_machine()
	user.reset_view()
	if(current_uav)
		current_uav.remove_master(user)
	LAZYREMOVE(viewers, weakref(user))

/datum/nano_module/uav/check_eye(var/mob/user)
	if(get_dist(user, nano_host()) > 1 || user.blinded || !current_uav)
		unlook(user)
		return -1

	var/viewflag = current_uav.check_eye(user)
	if (viewflag < 0) //camera doesn't work
		unlook(user)
		return -1

	return viewflag

////
//// Relaying movements to the UAV
////
/datum/nano_module/uav/relaymove(var/mob/user, direction)
	if(current_uav)
		return current_uav.relaymove(user, direction, signal_strength)

////
////  The effects when looking through a UAV
////
/datum/nano_module/uav/apply_visual(var/mob/M)
	if(!M.client)
		return
	if(weakref(M) in viewers)
		M.overlay_fullscreen("fishbed",/obj/screen/fullscreen/fishbed)
		M.overlay_fullscreen("scanlines",/obj/screen/fullscreen/scanline)

		if(signal_strength <= 1)
			M.overlay_fullscreen("whitenoise",/obj/screen/fullscreen/noise)
		else
			M.clear_fullscreen("whitenoise", 0)
	else
		remove_visual(M)

/datum/nano_module/uav/remove_visual(mob/M)
	if(!M.client)
		return
	M.clear_fullscreen("fishbed",0)
	M.clear_fullscreen("scanlines",0)
	M.clear_fullscreen("whitenoise",0)
