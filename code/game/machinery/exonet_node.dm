/obj/machinery/exonet_node
	name = "exonet node"
	desc = null // Gets written in New()
	icon = 'icons/obj/stationobjs_vr.dmi' //VOREStation Edit
	icon_state = "exonet" //VOREStation Edit
	idle_power_usage = 2500
	density = TRUE
	var/on = 1
	var/toggle = 1

	var/allow_external_PDAs = 1
	var/allow_external_communicators = 1
	var/allow_external_newscasters = 1

	var/opened = 0

	var/list/logs = list() // Gets written to by exonet's send_message() function.

	circuit = /obj/item/circuitboard/telecomms/exonet_node
// Proc: New()
// Parameters: None
// Description: Adds components to the machine for deconstruction.
/obj/machinery/exonet_node/map/Initialize()
	. = ..()
	default_apply_parts()
	desc = "This machine is one of many, many nodes inside [using_map.starsys_name]'s section of the Exonet, connecting the [using_map.station_short] to the rest of the system, at least \
	electronically."

// Proc: update_icon()
// Parameters: None
// Description: Self explanatory.
/obj/machinery/exonet_node/update_icon()
	if(on)
		/* VOREStation Removal
		if(!allow_external_PDAs && !allow_external_communicators && !allow_external_newscasters)
			icon_state = "[initial(icon_state)]_idle"
		else
		*/
		icon_state = initial(icon_state)
	else
		icon_state = "[initial(icon_state)]_off"

// Proc: update_power()
// Parameters: None
// Description: Sets the device on/off and adjusts power draw based on stat and toggle variables.
/obj/machinery/exonet_node/proc/update_power()
	if(toggle)
		if(stat & (BROKEN|NOPOWER|EMPED))
			on = 0
			update_idle_power_usage(0)
		else
			on = 1
			update_idle_power_usage(2500)
	else
		on = 0
		update_idle_power_usage(0)
	update_icon()

// Proc: emp_act()
// Parameters: 1 (severity - how strong the EMP is, with lower numbers being stronger)
// Description: Shuts off the machine for awhile if an EMP hits it.  Ion anomalies also call this to turn it off.
/obj/machinery/exonet_node/emp_act(severity)
	if(!(stat & EMPED))
		stat |= EMPED
		var/duration = (300 * 10)/severity
		spawn(rand(duration - 20, duration + 20))
			stat &= ~EMPED
	update_icon()
	..()

// Proc: process()
// Parameters: None
// Description: Calls the procs below every tick.
/obj/machinery/exonet_node/process()
	update_power()

// Proc: attackby()
// Parameters: 2 (I - the item being whacked against the machine, user - the person doing the whacking)
// Description: Handles deconstruction.
/obj/machinery/exonet_node/attackby(obj/item/I, mob/user)
	if(I.is_screwdriver())
		default_deconstruction_screwdriver(user, I)
	else if(I.is_crowbar())
		default_deconstruction_crowbar(user, I)
	else
		..()

// Proc: attack_ai()
// Parameters: 1 (user - the AI clicking on the machine)
// Description: Redirects to attack_hand()
/obj/machinery/exonet_node/attack_ai(mob/user)
	attack_hand(user)

// Proc: attack_hand()
// Parameters: 1 (user - the person clicking on the machine)
// Description: Opens the TGUI interface with tgui_interact()
/obj/machinery/exonet_node/attack_hand(mob/user)
	tgui_interact(user)

// Proc: tgui_interact()
// Parameters: 2 (user - person interacting with the UI, ui - the UI itself, in a refresh)
// Description: Handles opening the TGUI interface
/obj/machinery/exonet_node/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ExonetNode", src)
		ui.open()

// Proc: tgui_data()
// Parameters: 1 (user - the person using the interface)
// Description: Allows the user to turn the machine on or off, or open or close certain 'ports' for things like external PDA messages, newscasters, etc.
/obj/machinery/exonet_node/tgui_data(mob/user)
	// this is the data which will be sent to the ui
	var/list/data = list()

	data["on"] = toggle ? 1 : 0
	data["allowPDAs"] = allow_external_PDAs
	data["allowCommunicators"] = allow_external_communicators
	data["allowNewscasters"] = allow_external_newscasters
	data["logs"] = logs

	return data

// Proc: tgui_act()
// Parameters: 2 (standard tgui_act arguments)
// Description: Responds to button presses on the TGUI interface.
/obj/machinery/exonet_node/tgui_act(action, params)
	if(..())
		return TRUE

	switch(action)
		if("toggle_power")
			. = TRUE
			toggle = !toggle
			update_power()
			if(!toggle)
				var/msg = "[usr.client.key] ([usr]) has turned [src] off, at [x],[y],[z]."
				message_admins(msg)
				log_game(msg)

		if("toggle_PDA_port")
			. = TRUE
			allow_external_PDAs = !allow_external_PDAs

		if("toggle_communicator_port")
			. = TRUE
			allow_external_communicators = !allow_external_communicators
			if(!allow_external_communicators)
				var/msg = "[usr.client.key] ([usr]) has turned [src]'s communicator port off, at [x],[y],[z]."
				message_admins(msg)
				log_game(msg)

		if("toggle_newscaster_port")
			. = TRUE
			allow_external_newscasters = !allow_external_newscasters
			if(!allow_external_newscasters)
				var/msg = "[usr.client.key] ([usr]) has turned [src]'s newscaster port off, at [x],[y],[z]."
				message_admins(msg)
				log_game(msg)

	update_icon()
	add_fingerprint(usr)

// Proc: get_exonet_node()
// Parameters: None
// Description: Helper proc to get a reference to an Exonet node.
/proc/get_exonet_node()
	for(var/obj/machinery/exonet_node/E in machines)
		if(E.on)
			return E

// Proc: write_log()
// Parameters: 4 (origin_address - Where the message is from, target_address - Where the message is going, data_type - Instructions on how to interpet content,
// 		content - The actual message.
// Description: This writes to the logs list, so that people can see what people are doing on the Exonet ingame.  Note that this is not an admin logging function.
// 		Communicators are already logged seperately.
/obj/machinery/exonet_node/proc/write_log(var/origin_address, var/target_address, var/data_type, var/content)
	//var/timestamp = time2text(station_time_in_ds, "hh:mm:ss")
	var/timestamp = "[stationdate2text()] [stationtime2text()]"
	var/msg = "[timestamp] | FROM [origin_address] TO [target_address] | TYPE: [data_type] | CONTENT: [content]"
	logs.Add(msg)
