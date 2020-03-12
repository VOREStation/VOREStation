/datum/wires/grid_checker
	holder_type = /obj/machinery/power/grid_checker
	wire_count = 8
	var/datum/wire_hint/power_failure_hint
	var/datum/wire_hint/lock_out_hint
	var/datum/wire_hint/ready_hint

/datum/wires/grid_checker/make_wire_hints()
	power_failure_hint = new("The green light is off.", "The green light is on.")
	lock_out_hint = new("The red light is on.", "The red light is off.")
	ready_hint = new("The blue light is on.", "The blue light is off.")

/datum/wires/grid_checker/Destroy()
	power_failure_hint = null
	lock_out_hint = null
	ready_hint = null
	return ..()

var/const/GRID_CHECKER_WIRE_REBOOT	= 1			// This wire causes the grid-check to end, if pulsed.
var/const/GRID_CHECKER_WIRE_LOCKOUT	= 2			// If cut or pulsed, locks the user out for half a minute.
var/const/GRID_CHECKER_WIRE_ALLOW_MANUAL_1 = 4	// Needs to be cut for REBOOT to be possible.
var/const/GRID_CHECKER_WIRE_ALLOW_MANUAL_2 = 8	// Needs to be cut for REBOOT to be possible.
var/const/GRID_CHECKER_WIRE_ALLOW_MANUAL_3 = 16	// Needs to be cut for REBOOT to be possible.
var/const/GRID_CHECKER_WIRE_SHOCK = 32			// Shocks the user if not wearing gloves.
var/const/GRID_CHECKER_WIRE_NOTHING_1 = 64		// Does nothing, but makes it a bit harder.
var/const/GRID_CHECKER_WIRE_NOTHING_2 = 128		// Does nothing, but makes it a bit harder.


/datum/wires/grid_checker/CanUse(var/mob/living/L)
	var/obj/machinery/power/grid_checker/G = holder
	if(G.opened)
		return TRUE
	return FALSE


/datum/wires/grid_checker/GetInteractWindow()
	var/obj/machinery/power/grid_checker/G = holder
	. += ..()
	. += power_failure_hint.show(G.power_failing)
	. += lock_out_hint.show(G.wire_locked_out)
	. += ready_hint.show(G.wire_allow_manual_1 && G.wire_allow_manual_2 && G.wire_allow_manual_3)


/datum/wires/grid_checker/UpdateCut(var/index, var/mended)
	var/obj/machinery/power/grid_checker/G = holder
	switch(index)
		if(GRID_CHECKER_WIRE_LOCKOUT)
			G.wire_locked_out = !mended
		if(GRID_CHECKER_WIRE_ALLOW_MANUAL_1)
			G.wire_allow_manual_1 = !mended
		if(GRID_CHECKER_WIRE_ALLOW_MANUAL_2)
			G.wire_allow_manual_2 = !mended
		if(GRID_CHECKER_WIRE_ALLOW_MANUAL_3)
			G.wire_allow_manual_3 = !mended
		if(GRID_CHECKER_WIRE_SHOCK)
			if(G.wire_locked_out)
				return
			G.shock(usr, 70)


/datum/wires/grid_checker/UpdatePulsed(var/index)
	var/obj/machinery/power/grid_checker/G = holder
	switch(index)
		if(GRID_CHECKER_WIRE_REBOOT)
			if(G.wire_locked_out)
				return

			if(G.power_failing && G.wire_allow_manual_1 && G.wire_allow_manual_2 && G.wire_allow_manual_3)
				G.end_power_failure(TRUE)
		if(GRID_CHECKER_WIRE_LOCKOUT)
			if(G.wire_locked_out)
				return

			G.wire_locked_out = TRUE
			spawn(30 SECONDS)
				G.wire_locked_out = FALSE
		if(GRID_CHECKER_WIRE_SHOCK)
			if(G.wire_locked_out)
				return
			G.shock(usr, 70)