/obj/machinery/power/debug_items/
	icon = 'icons/obj/power.dmi'
	icon_state = "tracker"
	anchored = TRUE
	density = TRUE
	var/show_extended_information = 1	// Set to 0 to disable extra information on examining (for example, when used on admin events)

/obj/machinery/power/debug_items/examine(mob/user)
	. = ..()
	if(show_extended_information)
		. += show_info(user)

/obj/machinery/power/debug_items/proc/show_info(var/mob/user)
	var/list/extra_info = list()
	if(!powernet)
		extra_info += "<span class='filter_notice'>This device is not connected to a powernet</span>"
		return

	extra_info += "<span class='filter_notice'>Connected to powernet: [powernet]</span>"
	extra_info += "<span class='filter_notice'>Available power: [num2text(powernet.avail, 20)] W</span>"
	extra_info += "<span class='filter_notice'>Load: [num2text(powernet.viewload, 20)] W</span>"
	extra_info += "<span class='filter_notice'>Has alert: [powernet.problem ? "YES" : "NO"]</span>"
	extra_info += "<span class='filter_notice'>Cables: [powernet.cables.len]</span>"
	extra_info += "<span class='filter_notice'>Nodes: [powernet.nodes.len]</span>"

	return extra_info

// An infinite power generator. Adds energy to connected cable.
/obj/machinery/power/debug_items/infinite_generator
	name = "fractal energy reactor"
	desc = "An experimental power generator capable of generating massive amounts of energy from subspace vacuum."
	var/power_generation_rate = 1000000

/obj/machinery/power/debug_items/infinite_generator/process()
	add_avail(power_generation_rate)

/obj/machinery/power/debug_items/infinite_generator/show_info(var/mob/user)
	. = ..()
	. += "<span class='filter_notice'>Generator is providing [num2text(power_generation_rate, 20)] W</span>"


// A cable powersink, without the explosion/network alarms normal powersink causes.
/obj/machinery/power/debug_items/infinite_cable_powersink
	name = "null point core"
	desc = "An experimental device that disperses energy, used for grid stress-testing purposes."
	var/power_usage_rate = 0
	var/last_used = 0

/obj/machinery/power/debug_items/infinite_cable_powersink/process()
	last_used = draw_power(power_usage_rate)

/obj/machinery/power/debug_items/infinite_cable_powersink/show_info(var/mob/user)
	. = ..()
	. += "<span class='filter_notice'>Power sink is demanding [num2text(power_usage_rate, 20)] W</span>"
	. += "<span class='filter_notice'>[num2text(last_used, 20)] W was actually used last tick</span>"


/obj/machinery/power/debug_items/infinite_apc_powersink
	name = "APC dummy load"
	desc = "A dummy load that connects to an APC, used for load testing purposes."
	use_power = USE_POWER_ACTIVE
	active_power_usage = 0

/obj/machinery/power/debug_items/infinite_apc_powersink/show_info(var/mob/user)
	. = ..()
	. += "<span class='filter_notice'>Dummy load is using [num2text(active_power_usage, 20)] W</span>"
	. += "<span class='filter_notice'>Powered: [powered() ? "YES" : "NO"]</span>"
