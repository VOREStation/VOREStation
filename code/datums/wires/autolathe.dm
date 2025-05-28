/datum/wires/autolathe
	holder_type = /obj/machinery/autolathe
	wire_count = 6
	proper_name = "Autolathe"

/datum/wires/autolathe/New(atom/_holder)
	wires = list(WIRE_AUTOLATHE_HACK, WIRE_ELECTRIFY, WIRE_AUTOLATHE_DISABLE)
	return ..()

/datum/wires/autolathe/get_status()
	. = ..()
	var/obj/machinery/autolathe/A = holder
	. += "The red light is [A.disabled ? "off" : "on"]."
	. += "The green light is [A.shocked ? "off" : "on"]."
	. += "The blue light is [A.hacked ? "off" : "on"]."

/datum/wires/autolathe/interactable(mob/user)
	var/obj/machinery/autolathe/A = holder
	if(A.panel_open)
		return TRUE
	return FALSE

/datum/wires/autolathe/on_cut(wire, mend)
	var/obj/machinery/autolathe/A = holder
	switch(wire)
		if(WIRE_AUTOLATHE_HACK)
			A.hacked = !mend
			A.update_tgui_static_data(usr)
		if(WIRE_ELECTRIFY)
			A.shocked = !mend
		if(WIRE_AUTOLATHE_DISABLE)
			A.disabled = !mend
	..()

/datum/wires/autolathe/on_pulse(wire)
	if(is_cut(wire))
		return
	var/obj/machinery/autolathe/A = holder
	switch(wire)
		if(WIRE_AUTOLATHE_HACK)
			A.hacked = !A.hacked
			A.update_tgui_static_data(usr)
			spawn(50)
				if(A && !is_cut(wire))
					A.hacked = 0
					A.update_tgui_static_data(usr)
		if(WIRE_ELECTRIFY)
			A.shocked = !A.shocked
			spawn(50)
				if(A && !is_cut(wire))
					A.shocked = 0
		if(WIRE_AUTOLATHE_DISABLE)
			A.disabled = !A.disabled
			spawn(50)
				if(A && !is_cut(wire))
					A.disabled = 0
	..()
