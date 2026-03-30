/datum/wires/autolathe
	holder_type = /obj/machinery/autolathe
	wire_count = 6
	proper_name = "Autolathe"

/datum/wires/autolathe/New(atom/_holder)
	wires = list(WIRE_LATHE_HACK, WIRE_ELECTRIFY, WIRE_LATHE_DISABLE)
	var/obj/machinery/autolathe/A = _holder
	if(A.hacked)
		cut_wires += WIRE_LATHE_HACK
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
		if(WIRE_LATHE_HACK)
			A.hacked = !mend
			A.update_tgui_static_data(usr)
		if(WIRE_ELECTRIFY)
			A.shocked = !mend
		if(WIRE_LATHE_DISABLE)
			A.disabled = !mend
	..()

/datum/wires/autolathe/on_pulse(wire)
	if(is_cut(wire))
		return
	var/obj/machinery/autolathe/A = holder
	switch(wire)
		if(WIRE_LATHE_HACK)
			A.hacked = !A.hacked
			A.update_tgui_static_data(usr)
			addtimer(CALLBACK(src, PROC_REF(reset_hacked), WIRE_LATHE_HACK, usr), 5 SECONDS)
		if(WIRE_ELECTRIFY)
			A.shocked = !A.shocked
			addtimer(CALLBACK(src, PROC_REF(reset_electrify), WIRE_ELECTRIFY), 5 SECONDS)
		if(WIRE_LATHE_DISABLE)
			A.disabled = !A.disabled
			addtimer(CALLBACK(src, PROC_REF(reset_disable), WIRE_LATHE_DISABLE), 5 SECONDS)
	..()

/datum/wires/autolathe/proc/reset_hacked(wire, mob/user)
	var/obj/machinery/autolathe/A = holder
	if(A && !is_cut(wire))
		A.hacked = FALSE
		A.update_tgui_static_data(user)

/datum/wires/autolathe/proc/reset_electrify(wire)
	var/obj/machinery/autolathe/A = holder
	if(A && !is_cut(wire))
		A.shocked = FALSE

/datum/wires/autolathe/proc/reset_disable(wire)
	var/obj/machinery/autolathe/A = holder
	if(A && !is_cut(wire))
		A.disabled = FALSE
