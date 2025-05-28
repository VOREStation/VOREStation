/datum/wires/grid_checker
	holder_type = /obj/machinery/power/grid_checker
	wire_count = 8
	proper_name = "Grid Checker"

/datum/wires/grid_checker/New(atom/_holder)
	wires = list(
		WIRE_REBOOT, WIRE_LOCKOUT, WIRE_ALLOW_MANUAL1,
		WIRE_ALLOW_MANUAL2, WIRE_ALLOW_MANUAL3, WIRE_ELECTRIFY
	)
	return ..()

/datum/wires/grid_checker/interactable(mob/user)
	var/obj/machinery/power/grid_checker/G = holder
	if(G.opened)
		return TRUE
	return FALSE

/datum/wires/grid_checker/get_status()
	var/obj/machinery/power/grid_checker/G = holder
	. = ..()
	. += "The green light is [G.power_failing ? "off." : "on."]"
	. += "The red light is [G.wire_locked_out ? "on." : "off."]"
	. += "The blue light is [(G.wire_allow_manual_1 && G.wire_allow_manual_2 && G.wire_allow_manual_3) ? "on." : "off."]"

/datum/wires/grid_checker/on_cut(wire, mend)
	var/obj/machinery/power/grid_checker/G = holder
	switch(wire)
		if(WIRE_LOCKOUT)
			G.wire_locked_out = !mend
		if(WIRE_ALLOW_MANUAL1)
			G.wire_allow_manual_1 = !mend
		if(WIRE_ALLOW_MANUAL2)
			G.wire_allow_manual_2 = !mend
		if(WIRE_ALLOW_MANUAL3)
			G.wire_allow_manual_3 = !mend
		if(WIRE_ELECTRIFY)
			if(G.wire_locked_out)
				return
			G.shock(usr, 70)
	..()

/datum/wires/grid_checker/on_pulse(wire)
	var/obj/machinery/power/grid_checker/G = holder
	switch(wire)
		if(WIRE_REBOOT)
			if(G.wire_locked_out)
				return
			if(G.power_failing && G.wire_allow_manual_1 && G.wire_allow_manual_2 && G.wire_allow_manual_3)
				G.end_power_failure(TRUE)

		if(WIRE_LOCKOUT)
			if(G.wire_locked_out)
				return

			G.wire_locked_out = TRUE
			spawn(30 SECONDS)
				G.wire_locked_out = FALSE

		if(WIRE_ELECTRIFY)
			if(G.wire_locked_out)
				return
			G.shock(usr, 70)
	..()
