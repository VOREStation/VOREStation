/obj/item/integrated_circuit/illegal
	complexity = 3
	category_text = "Illegal Parts"
	power_draw_per_use = 50

/* [WIP]
/obj/item/integrated_circuit/illegal/EPv2_Spoofer
	name = "\improper EPv2 Spoofer circuit"
	desc = "Enables the receiving of messages of other Exonet devices."
	extended_desc = "An EPv2 address is a string with the format of XXXX:XXXX:XXXX:XXXX.  Data can be received using the \
	second pin, with additonal data reserved for the third pin.  When a message is received, the second activation pin \
	will pulse whatever's connected to it.  Pulsing the first activation pin will set the given EPv2 address.\
	\
	Note: Receiving messages could cause the circuit to accidentally send malformed data to the target address."
	icon_state = "signal_illegal"
	complexity = 6
	inputs = list("target EPv2 address"	= IC_PINTYPE_STRING)
	outputs = list(
		"address received"			= IC_PINTYPE_STRING,
		"data received"				= IC_PINTYPE_STRING,
		"secondary text received"	= IC_PINTYPE_STRING
		)
	activators = list("set spoof address" = IC_PINTYPE_PULSE_IN, "on data received" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_RESEARCH|IC_SPAWN_ILLEGAL
	origin_tech = list(TECH_ENGINEERING = 2, TECH_DATA = 2, TECH_MAGNET = 2, TECH_BLUESPACE = 2, TECH_ILLEGAL = 2)
	power_draw_per_use = 200
	var/datum/exonet_protocol/exonet = null
	var/address_spoofed = FALSE

/obj/item/integrated_circuit/illegal/EPv2_Spoofer/Initialize()
	. = ..()
	exonet = new(src)
	exonet.make_address("EPv2_Spoofer_circuit-\ref[src]")
	desc += "<br>This circuit's EPv2 address is: [exonet.address]"

/obj/item/integrated_circuit/illegal/EPv2_Spoofer/Destroy()
	if(exonet)
		if(!address_spoofed) // We dont actually want to destroy the regular address
			exonet.remove_address()
		qdel(exonet)
		exonet = null
	return ..()

/obj/item/integrated_circuit/illegal/EPv2_Spoofer/do_work()
	var/target_address = get_pin_data(IC_INPUT, 1)

	exonet.address = target_address
	address_spoofed = TRUE

/obj/item/integrated_circuit/illegal/receive_exonet_message(var/atom/origin_atom, var/origin_address, var/message, var/text)
	set_pin_data(IC_OUTPUT, 1, origin_address)
	set_pin_data(IC_OUTPUT, 2, message)
	set_pin_data(IC_OUTPUT, 3, text)

	push_data()
	activate_pin(2)

	if(address_spoofed)
		var/random = rand(1,100)
		if(random > 70)
			exonet.send_message(origin_address, message, "[random]")
*/

/obj/item/integrated_circuit/illegal/EPv2_Discoverer
	name = "\improper EPv2 Discovery circuit"
	desc = "Finds all Exonet devices currently connected to the node (even if not publicly listed)."
	extended_desc = "An EPv2 address is a string with the format of XXXX:XXXX:XXXX:XXXX.  Data can be received using the \
	second pin, with additonal data reserved for the third pin.  When a message is received, the second activation pin \
	will pulse whatever's connected to it.  Pulsing the first activation pin will set the given EPv2 address.\
	\
	Note: Discovering Exonet Devices sends off a ping to each device, making it a 'noisy' circuit."
	icon_state = "signal_illegal"
	complexity = 3
	outputs = list("addresses found" = IC_PINTYPE_LIST)
	activators = list("start discovery" = IC_PINTYPE_PULSE_IN, "on addresses found" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_ILLEGAL
	origin_tech = list(TECH_ENGINEERING = 2, TECH_DATA = 2, TECH_MAGNET = 2, TECH_BLUESPACE = 2, TECH_ILLEGAL = 1)
	power_draw_per_use = 300
	var/datum/exonet_protocol/exonet = null
	var/obj/machinery/exonet_node/node = null

/obj/item/integrated_circuit/illegal/EPv2_Discoverer/proc/get_connection_to_tcomms()
	if(node && node.on)
		return can_telecomm(src,node)
	return 0

/obj/item/integrated_circuit/illegal/EPv2_Discoverer/Initialize()
	. = ..()
	exonet = new(src)
	exonet.make_address("EPv2_Discovery_circuit-\ref[src]")
	desc += "<br>This circuit's EPv2 address is: [exonet.address]"
	node = get_exonet_node()
	message_admins("A EPv2 Discovery circuit has been created. \ref[src]")

/obj/item/integrated_circuit/illegal/EPv2_Discoverer/Destroy()
	if(exonet)
		exonet.remove_address()
		qdel(exonet)
		exonet = null
	return ..()

/obj/item/integrated_circuit/illegal/EPv2_Discoverer/do_work()
	if(!get_connection_to_tcomms())
		set_pin_data(IC_OUTPUT, 1, null)

		push_data()
		activate_pin(2)
	else
		var/list/addresses = list()

		for(var/datum/exonet_protocol/target_exonet in all_exonet_connections)
			if(target_exonet.address && istext(target_exonet.address))
				var/random = rand(200,350)
				random = random / 10
				exonet.send_message(target_exonet.address, "text", "64 bytes received from [exonet.address] ecmp_seq=1 ttl=51 time=[random] ms")
				addresses += target_exonet.address

		set_pin_data(IC_OUTPUT, 1, addresses)

		push_data()
		activate_pin(2)
