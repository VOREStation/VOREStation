//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32


/*

	All telecommunications interactions:

*/

#define STATION_Z 1
#define TELECOMM_Z 3

/obj/machinery/telecomms
	var/list/temp = null // output message

/obj/machinery/telecomms/attackby(obj/item/P as obj, mob/user as mob)

	// Using a multitool lets you access the receiver's interface
	if(istype(P, /obj/item/device/multitool))
		attack_hand(user)

	// REPAIRING: Use Nanopaste to repair 10-20 integrity points.
	if(istype(P, /obj/item/stack/nanopaste))
		var/obj/item/stack/nanopaste/T = P
		if (integrity < 100)               								//Damaged, let's repair!
			if (T.use(1))
				integrity = between(0, integrity + rand(10,20), 100)
				to_chat(usr, "You apply the Nanopaste to [src], repairing some of the damage.")
		else
			to_chat(usr, "This machine is already in perfect condition.")
		return


	if(default_deconstruction_screwdriver(user, P))
		return
	if(default_deconstruction_crowbar(user, P))
		return

/obj/machinery/telecomms/attack_ai(var/mob/user as mob)
	attack_hand(user)

/obj/machinery/telecomms/tgui_data(mob/user)
	var/list/data = list()
	
	data["temp"] = temp
	data["on"] = on

	data["id"] = null
	data["network"] = null
	data["autolinkers"] = FALSE
	data["shadowlink"] = FALSE
	data["options"] = list()
	data["linked"] = list()
	data["filter"] = list()
	data["multitool"] = FALSE
	data["multitool_buffer"] = null

	if(on || interact_offline)
		data["id"] = id
		data["network"] = network
		data["autolinkers"] = !!LAZYLEN(autolinkers)
		data["shadowlink"] = !!hide

		data["options"] = Options_Menu()

		var/obj/item/device/multitool/P = get_multitool(user)
		data["multitool"] = !!P
		data["multitool_buffer"] = null
		if(P && P.buffer)
			P.update_icon()
			data["multitool_buffer"] = list("name" = "[P.buffer]", "id" = "[P.buffer.id]")

		var/i = 0
		var/list/linked = list()
		for(var/obj/machinery/telecomms/T in links)
			i++
			linked.Add(list(list(
				"ref" = "\ref[T]",
				"name" = "[T]",
				"id" = T.id,
				"index" = i,
			)))
		data["linked"] = linked
		
		var/list/filter = list()
		for(var/x in freq_listening)
			filter.Add(list(list(
				"name" = "[format_frequency(x)]",
				"freq" = x,
			)))
		data["filter"] = filter

	return data

/obj/machinery/telecomms/tgui_status(mob/user)
	if(!issilicon(user))
		if(!istype(user.get_active_hand(), /obj/item/device/multitool))
			return STATUS_CLOSE
	. = ..()

/obj/machinery/telecomms/attack_hand(var/mob/user as mob)
	tgui_interact(user)

/obj/machinery/telecomms/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "TelecommsMultitoolMenu", name)
		ui.open()

// Off-Site Relays
//
// You are able to send/receive signals from the station's z level (changeable in the STATION_Z #define) if
// the relay is on the telecomm satellite (changable in the TELECOMM_Z #define)


/obj/machinery/telecomms/relay/proc/toggle_level()

	var/turf/position = get_turf(src)

	// Toggle on/off getting signals from the station or the current Z level
	if(src.listening_level == STATION_Z) // equals the station
		src.listening_level = position.z
		return 1
	else if(position.z == TELECOMM_Z)
		src.listening_level = STATION_Z
		return 1
	return 0

// Returns a multitool from a user depending on their mobtype.

/obj/machinery/proc/get_multitool(mob/user as mob)	//No need to have this being a telecomms specific proc.

	var/obj/item/device/multitool/P = null
	// Let's double check
	if(!issilicon(user) && istype(user.get_active_hand(), /obj/item/device/multitool))
		P = user.get_active_hand()
	else if(isAI(user))
		var/mob/living/silicon/ai/U = user
		P = U.aiMulti
	else if(isrobot(user) && in_range(user, src))
		if(istype(user.get_active_hand(), /obj/item/device/multitool))
			P = user.get_active_hand()
	return P

// Additional Options for certain machines. Use this when you want to add an option to a specific machine.
// Example of how to use below.

/obj/machinery/telecomms/proc/Options_Menu()
	return list()

/*
// Add an option to the processor to switch processing mode. (COMPRESS -> UNCOMPRESS or UNCOMPRESS -> COMPRESS)
/obj/machinery/telecomms/processor/Options_Menu()
	var/dat = "<br>Processing Mode: <A href='?src=\ref[src];process=1'>[process_mode ? "UNCOMPRESS" : "COMPRESS"]</a>"
	return dat
*/
// The topic for Additional Options. Use this for checking href links for your specific option.
// Example of how to use below.
/obj/machinery/telecomms/proc/Options_Act(action, params)
	return

/*
/obj/machinery/telecomms/processor/Options_Act(action, params)

	if(href_list["process"])
		set_temp("-% Processing mode changed. %-", "average")
		src.process_mode = !src.process_mode
*/

// RELAY

/obj/machinery/telecomms/relay/Options_Menu()
	var/list/data = ..()
	data["use_listening_level"] = TRUE
	data["use_broadcasting"] = TRUE
	data["use_receiving"] = TRUE
	data["listening_level"] = (listening_level == STATION_Z)
	data["broadcasting"] = broadcasting
	data["receiving"] = receiving
	return data

/obj/machinery/telecomms/relay/Options_Act(action, params)
	if(..())
		return TRUE

	switch(action)
		if("receive")
			. = TRUE
			receiving = !receiving
			set_temp("-% Receiving mode changed. %-", "average")
		if("broadcast")
			. = TRUE
			broadcasting = !broadcasting
			set_temp("-% Broadcasting mode changed. %-", "average")
		if("change_listening")
			. = TRUE
			//Lock to the station OR lock to the current position!
			//You need at least two receivers and two broadcasters for this to work, this includes the machine.
			var/result = toggle_level()
			if(result)
				set_temp("-% [src]'s signal has been successfully changed.", "average")
			else
				set_temp("-% [src] could not lock it's signal onto the station. Two broadcasters or receivers required.", "average")

// BUS

/obj/machinery/telecomms/bus/Options_Menu()
	var/list/data = ..()
	data["use_change_freq"] = TRUE
	data["change_freq"] = change_frequency
	return data

/obj/machinery/telecomms/bus/Options_Act(action, params)
	if(..())
		return TRUE
	
	switch(action)
		if("change_freq")
			. = TRUE
			var/newfreq = input(usr, "Specify a new frequency for new signals to change to. Enter null to turn off frequency changing. Decimals assigned automatically.", src, network) as null|num
			if(canAccess(usr))
				if(newfreq)
					if(findtext(num2text(newfreq), "."))
						newfreq *= 10 // shift the decimal one place
					if(newfreq < 10000)
						change_frequency = newfreq
						set_temp("-% New frequency to change to assigned: \"[newfreq] GHz\" %-", "average")
				else
					change_frequency = 0
					set_temp("-% Frequency changing deactivated %-", "average")


// BROADCASTER
/obj/machinery/telecomms/broadcaster/Options_Menu()
	var/list/data = ..()
	data["use_broadcast_range"] = TRUE
	data["range"] = overmap_range
	data["minRange"] = overmap_range_min
	data["maxRange"] = overmap_range_max
	return data

/obj/machinery/telecomms/broadcaster
	interact_offline = TRUE // because you can accidentally nuke power grids with these, need to be able to fix mistake

/obj/machinery/telecomms/broadcaster/Options_Act(action, params)
	if(..())
		return TRUE

	switch(action)
		if("range")
			var/new_range = params["range"]
			overmap_range = clamp(new_range, overmap_range_min, overmap_range_max)
			update_idle_power_usage(initial(idle_power_usage)**(overmap_range+1))

// RECEIVER
/obj/machinery/telecomms/receiver/Options_Menu()
	var/list/data = ..()
	data["use_receive_range"] = TRUE
	data["range"] = overmap_range
	data["minRange"] = overmap_range_min
	data["maxRange"] = overmap_range_max
	return data

/obj/machinery/telecomms/receiver
	interact_offline = TRUE // because you can accidentally nuke power grids with these, need to be able to fix mistake

/obj/machinery/telecomms/receiver/Options_Act(action, params)
	if(..())
		return TRUE
	
	switch(action)
		if("range")
			var/new_range = params["range"]
			overmap_range = clamp(new_range, overmap_range_min, overmap_range_max)
			update_idle_power_usage(initial(idle_power_usage)**(overmap_range+1))

/obj/machinery/telecomms/tgui_act(action, params)
	if(..())
		return TRUE

	var/obj/item/device/multitool/P = get_multitool(usr)

	switch(action)
		if("toggle")
			src.toggled = !src.toggled
			set_temp("-% [src] has been [src.toggled ? "activated" : "deactivated"].", "average")
			update_power()
			. = TRUE

		if("id")
			var/newid = copytext(reject_bad_text(input(usr, "Specify the new ID for this machine", src, id) as null|text),1,MAX_MESSAGE_LEN)
			if(newid && canAccess(usr))
				id = newid
				set_temp("-% New ID assigned: \"[id]\" %-", "average")
				. = TRUE

		if("network")
			var/newnet = tgui_input_text(usr, "Specify the new network for this machine. This will break all current links.", src, network)
			if(newnet && canAccess(usr))

				if(length(newnet) > 15)
					set_temp("-% Too many characters in new network tag %-", "average")

				else
					for(var/obj/machinery/telecomms/T in links)
						T.links.Remove(src)

					network = newnet
					links = list()
					set_temp("-% New network tag assigned: \"[network]\" %-", "average")
				. = TRUE


		if("freq")
			var/newfreq = input(usr, "Specify a new frequency to filter (GHz). Decimals assigned automatically.", src, network) as null|num
			if(newfreq && canAccess(usr))
				if(findtext(num2text(newfreq), "."))
					newfreq *= 10 // shift the decimal one place
				if(!(newfreq in freq_listening) && newfreq < 10000)
					freq_listening.Add(newfreq)
					set_temp("-% New frequency filter assigned: \"[newfreq] GHz\" %-", "average")
				. = TRUE

		if("delete")
			var/x = text2num(params["delete"])
			set_temp("-% Removed frequency filter [x] %-", "average")
			freq_listening.Remove(x)
			. = TRUE

		if("unlink")
			if(text2num(params["unlink"]) <= length(links))
				var/obj/machinery/telecomms/T = links[text2num(params["unlink"])]
				set_temp("-% Removed \ref[T] [T.name] from linked entities. %-", "average")

				// Remove link entries from both T and src.

				if(src in T.links)
					T.links.Remove(src)
				links.Remove(T)
				. = TRUE

		if("link")
			if(P)
				if(P.buffer && P.buffer != src)
					if(!(src in P.buffer.links))
						P.buffer.links.Add(src)

					if(!(P.buffer in src.links))
						src.links.Add(P.buffer)

					set_temp("-% Successfully linked with \ref[P.buffer] [P.buffer.name] %-", "average")

				else
					set_temp("-% Unable to acquire buffer %-", "average")
				. = TRUE

		if("buffer")
			P.buffer = src
			set_temp("-% Successfully stored \ref[P.buffer] [P.buffer.name] in buffer %-", "average")
			. = TRUE

		if("flush")
			set_temp("-% Buffer successfully flushed. %-", "average")
			P.buffer = null
			. = TRUE

		if("cleartemp")
			temp = null
			. = TRUE

	if(Options_Act(action, params))
		. = TRUE

	add_fingerprint(usr)

/obj/machinery/telecomms/proc/canAccess(var/mob/user)
	if(issilicon(user) || in_range(user, src))
		return 1
	return 0

/obj/machinery/telecomms/proc/set_temp(var/text, var/color = "average")
	temp = list("color" = color, "text" = text)

#undef TELECOMM_Z
#undef STATION_Z
