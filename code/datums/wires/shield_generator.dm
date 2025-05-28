/datum/wires/shield_generator
	holder_type = /obj/machinery/power/shield_generator
	wire_count = 5
	proper_name = "Shield Generator"

/datum/wires/shield_generator/New(atom/_holder)
	wires = list(WIRE_MAIN_POWER1, WIRE_CONTRABAND, WIRE_AI_CONTROL, WIRE_SHIELD_CONTROL)
	return ..()

/datum/wires/shield_generator/interactable(mob/user)
	var/obj/machinery/power/shield_generator/S = holder
	if(S.panel_open)
		return TRUE
	return FALSE

/datum/wires/shield_generator/get_status()
	var/obj/machinery/power/shield_generator/S = holder
	. = ..()
	. += "The orange light is [S.mode_changes_locked ? "on." : "off."]"
	. += "The blue light is [S.ai_control_disabled ? "off." : "blinking."]"
	. += "The violet light is [S.hacked ? "pulsing." : "steady."]"
	. += "The red light is [S.input_cut ? "off." : "on."]"

/datum/wires/shield_generator/on_cut(wire, mend)
	var/obj/machinery/power/shield_generator/S = holder
	switch(wire)
		if(WIRE_MAIN_POWER1)
			S.input_cut = !mend
		if(WIRE_CONTRABAND)
			if(!mend)
				S.hacked = FALSE
				if(S.check_flag(MODEFLAG_BYPASS))
					S.toggle_flag(MODEFLAG_BYPASS)
				if(S.check_flag(MODEFLAG_OVERCHARGE))
					S.toggle_flag(MODEFLAG_OVERCHARGE)
		if(WIRE_SHIELD_CONTROL)
			S.mode_changes_locked = !mend
		if(WIRE_AI_CONTROL)
			S.ai_control_disabled = !mend
	..()

/datum/wires/shield_generator/on_pulse(wire)
	var/obj/machinery/power/shield_generator/S = holder
	switch(wire)
		if(WIRE_CONTRABAND)
			S.hacked = TRUE
	..()
