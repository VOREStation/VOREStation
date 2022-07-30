/obj/machinery/power/grid_checker
	name = "grid checker"
	desc = "A machine that reacts to unstable conditions in the powernet, by safely shutting everything down.  Probably better \
	than the alternative."
	icon_state = "gridchecker_on"
	circuit = /obj/item/circuitboard/grid_checker
	density = TRUE
	anchored = TRUE
	var/power_failing = FALSE // Turns to TRUE when the grid check event is fired by the Game Master, or perhaps a cheeky antag.
	// Wire stuff below.
	var/datum/wires/grid_checker/wires
	var/wire_locked_out = FALSE
	var/wire_allow_manual_1 = FALSE
	var/wire_allow_manual_2 = FALSE
	var/wire_allow_manual_3 = FALSE
	var/opened = FALSE

/obj/machinery/power/grid_checker/Initialize()
	. = ..()
	connect_to_network()
	update_icon()
	wires = new(src)
	default_apply_parts()

/obj/machinery/power/grid_checker/Destroy()
	qdel(wires)
	wires = null
	return ..()

/obj/machinery/power/grid_checker/update_icon()
	if(power_failing)
		icon_state = "gridchecker_off"
		set_light(2, 2, "#F86060")
	else
		icon_state = "gridchecker_on"
		set_light(2, 2, "#A8B0F8")

/obj/machinery/power/grid_checker/attackby(obj/item/W, mob/user)
	if(!user)
		return
	if(W.is_screwdriver())
		default_deconstruction_screwdriver(user, W)
		opened = !opened
	else if(W.is_crowbar())
		default_deconstruction_crowbar(user, W)
	else if(istype(W, /obj/item/multitool) || W.is_wirecutter())
		attack_hand(user)

/obj/machinery/power/grid_checker/attack_hand(mob/user)
	if(!user)
		return
	add_fingerprint(user)
	interact(user)

/obj/machinery/power/grid_checker/interact(mob/user)
	if(!user)
		return

	if(opened)
		wires.Interact(user)

	return tgui_interact(user)

/obj/machinery/power/grid_checker/proc/power_failure(var/announce = TRUE)
	if(announce)
		command_announcement.Announce("Abnormal activity detected in [station_name()]'s powernet. As a precautionary measure, \
		the colony's power will be shut off for an indeterminate duration while the powernet monitor restarts automatically, or \
		when Engineering can manually resolve the issue.",
		"Critical Power Failure",
		new_sound = 'sound/AI/poweroff.ogg')
	power_failing = TRUE
	if(powernet)
		for(var/obj/machinery/power/terminal/T in powernet.nodes) // APCs that are "downstream" of the powernet.

			if(istype(T.master, /obj/machinery/power/apc))
				var/obj/machinery/power/apc/A = T.master
				if(A.is_critical)
					continue
				A.do_grid_check()

		for(var/obj/machinery/power/smes/smes in powernet.nodes) // These are "upstream"
			smes.do_grid_check()

	update_icon()

	spawn(rand(4 MINUTES, 10 MINUTES) )
		if(power_failing) // Check to see if engineering didn't beat us to it.
			end_power_failure(TRUE)

/obj/machinery/power/grid_checker/proc/end_power_failure(var/announce = TRUE)
	if(announce)
		command_announcement.Announce("Power has been restored to [station_name()]. We apologize for the inconvenience.",
		"Power Systems Nominal",
		new_sound = 'sound/AI/poweron.ogg')
	power_failing = FALSE
	update_icon()

	for(var/obj/machinery/power/terminal/T in powernet.nodes)
		if(istype(T.master, /obj/machinery/power/apc))
			var/obj/machinery/power/apc/A = T.master
			if(A.is_critical)
				continue
			A.grid_check = FALSE

	for(var/obj/machinery/power/smes/smes in powernet.nodes) // These are "upstream"
		smes.grid_check = FALSE
