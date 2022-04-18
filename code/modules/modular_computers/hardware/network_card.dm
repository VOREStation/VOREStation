var/global/ntnet_card_uid = 1

/obj/item/computer_hardware/network_card/
	name = "basic NTNet network card"
	desc = "A basic network card for usage with standard NTNet frequencies."
	power_usage = 50
	origin_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 1)
	critical = 0
	icon_state = "netcard_basic"
	hardware_size = 1
	var/identification_id = null	// Identification ID. Technically MAC address of this device. Can't be changed by user.
	var/identification_string = "" 	// Identification string, technically nickname seen in the network. Can be set by user.
	var/long_range = 0
	var/ethernet = 0 // Hard-wired, therefore always on, ignores NTNet wireless checks.
	malfunction_probability = 1

/obj/item/computer_hardware/network_card/diagnostics(var/mob/user)
	..()
	to_chat(user, "NIX Unique ID: [identification_id]")
	to_chat(user, "NIX User Tag: [identification_string]")
	to_chat(user, "Supported protocols:")
	to_chat(user, "511.m SFS (Subspace) - Standard Frequency Spread")
	if(long_range)
		to_chat(user, "511.n WFS/HB (Subspace) - Wide Frequency Spread/High Bandiwdth")
	if(ethernet)
		to_chat(user, "OpenEth (Physical Connection) - Physical network connection port")

<<<<<<< HEAD
/obj/item/weapon/computer_hardware/network_card/New(var/l)
	..(l)
=======
/obj/item/computer_hardware/network_card/Initialize()
	. = ..()
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
	identification_id = ntnet_card_uid
	ntnet_card_uid++

/obj/item/computer_hardware/network_card/advanced
	name = "advanced NTNet network card"
	desc = "An advanced network card for usage with standard NTNet frequencies. It's transmitter is strong enough to connect even when far away."
	long_range = 1
	origin_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 2)
	power_usage = 100 // Better range but higher power usage.
	icon_state = "netcard_advanced"
	hardware_size = 1

/obj/item/computer_hardware/network_card/quantum
	name = "quantum NTNet network card"
	desc = "A network card that can connect to NTnet from anywhere, using quantum entanglement."
	long_range = 1
	origin_tech = list(TECH_DATA = 6, TECH_ENGINEERING = 7)
	power_usage = 200 // Infinite range but higher power usage.
	icon_state = "netcard_advanced"
	hardware_size = 1

/obj/item/computer_hardware/network_card/quantum/get_signal(var/specific_action = 0)
	if(!holder2)
		return 0

	if(!enabled)
		return 0

	if(!check_functionality() || !ntnet_global || is_banned())
		return 0

	return 2

/obj/item/computer_hardware/network_card/wired
	name = "wired NTNet network card"
	desc = "An advanced network card for usage with standard NTNet frequencies. This one also supports wired connection."
	ethernet = 1
	origin_tech = list(TECH_DATA = 5, TECH_ENGINEERING = 3)
	power_usage = 100 // Better range but higher power usage.
	icon_state = "netcard_ethernet"
	hardware_size = 3

/obj/item/computer_hardware/network_card/Destroy()
	if(holder2 && (holder2.network_card == src))
		holder2.network_card = null
	holder2 = null
	return ..()

// Returns a string identifier of this network card
/obj/item/computer_hardware/network_card/proc/get_network_tag()
	return "[identification_string] (NID [identification_id])"

/obj/item/computer_hardware/network_card/proc/is_banned()
	return ntnet_global.check_banned(identification_id)

// 0 - No signal, 1 - Low signal, 2 - High signal. 3 - Wired Connection
/obj/item/computer_hardware/network_card/proc/get_signal(var/specific_action = 0)
	if(!holder2) // Hardware is not installed in anything. No signal. How did this even get called?
		return 0

	if(!enabled)
		return 0

	if(!check_functionality() || !ntnet_global || is_banned())
		return 0

	if(ethernet) // Computer is connected via wired connection.
		return 3

	if(!ntnet_global.check_function(specific_action)) // NTNet is down and we are not connected via wired connection. No signal.
		return 0

	if(holder2)
		var/holderz = get_z(holder2)
		if(!holderz) //no reception in nullspace
			return 0
		var/list/zlevels_in_range = using_map.get_map_levels(holderz, FALSE)// VOREStation Edit - , om_range = DEFAULT_OVERMAP_RANGE)
		var/list/zlevels_in_long_range = using_map.get_map_levels(holderz, TRUE, om_range = DEFAULT_OVERMAP_RANGE) - zlevels_in_range
		var/best = 0
		for(var/obj/machinery/ntnet_relay/R as anything in ntnet_global.relays)
			//Relay is down
			if(!R.operable())
				continue
			//We're on the same z
			if(R.z == holderz)
				best = 2 //Every network card gets high signal on the same z as the relay
				break // No point in going further
			//Not on the same z but within range anyway
			if(R.z in zlevels_in_range)
				best = long_range ? 2 : 1 //High-power network cards get good signal further away
				break
			//Only in long range
			if(long_range && (R.z in zlevels_in_long_range))
				best = 1 //High-power network cards can get low signal even at long range
				break
		return best
	return 0 // No computer!

/obj/item/computer_hardware/network_card/Destroy()
	if(holder2 && (holder2.network_card == src))
		holder2.network_card = null
	return ..()
