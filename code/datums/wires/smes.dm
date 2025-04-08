/datum/wires/smes
	holder_type = /obj/machinery/power/smes/buildable
	wire_count = 5
	proper_name = "SMES"

/datum/wires/smes/New(atom/_holder)
	wires = list(WIRE_SMES_RCON, WIRE_SMES_INPUT, WIRE_SMES_OUTPUT, WIRE_SMES_GROUNDING, WIRE_SMES_FAILSAFES)
	return ..()

/datum/wires/smes/interactable(mob/user)
	var/obj/machinery/power/smes/buildable/S = holder
	if(S.panel_open)
		return TRUE
	return FALSE

/datum/wires/smes/get_status()
	var/obj/machinery/power/smes/buildable/S = holder
	. = ..()
	. += "The green light is [(S.input_cut || S.input_pulsed || S.output_cut || S.output_pulsed) ? "off" : "on"]."
	. += "The red light is [(S.safeties_enabled || S.grounding) ? "off" : "blinking"]."
	. += "The blue light is [S.RCon ? "on" : "off"]."

/datum/wires/smes/on_cut(wire, mend)
	var/obj/machinery/power/smes/buildable/S = holder
	switch(wire)
		if(WIRE_SMES_RCON)
			S.RCon = mend
		if(WIRE_SMES_INPUT)
			S.input_cut = !mend
		if(WIRE_SMES_OUTPUT)
			S.output_cut = !mend
		if(WIRE_SMES_GROUNDING)
			S.grounding = mend
		if(WIRE_SMES_FAILSAFES)
			S.safeties_enabled = mend
	..()

/datum/wires/smes/on_pulse(wire)
	var/obj/machinery/power/smes/buildable/S = holder
	switch(wire)
		if(WIRE_SMES_RCON)
			if(S.RCon)
				S.RCon = 0
				spawn(10)
					S.RCon = 1
		if(WIRE_SMES_INPUT)
			S.toggle_input()
		if(WIRE_SMES_OUTPUT)
			S.toggle_output()
		if(WIRE_SMES_GROUNDING)
			S.grounding = 0
		if(WIRE_SMES_FAILSAFES)
			if(S.safeties_enabled)
				S.safeties_enabled = 0
				spawn(10)
					S.safeties_enabled = 1
	..()
