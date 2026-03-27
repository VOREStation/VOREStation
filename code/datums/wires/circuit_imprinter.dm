/datum/wires/circuit_imprinter
	holder_type = /obj/machinery/rnd/production/circuit_imprinter
	wire_count = 6
	proper_name = "Circuit Imprinter"

/datum/wires/circuit_imprinter/New(atom/_holder)
	wires = list(WIRE_LATHE_HACK, WIRE_LATHE_DISABLE)
	var/obj/machinery/rnd/production/circuit_imprinter/A = _holder
	if(A.hacked)
		cut_wires += WIRE_LATHE_HACK
	return ..()

/datum/wires/circuit_imprinter/get_status()
	. = ..()
	var/obj/machinery/rnd/production/circuit_imprinter/A = holder
	. += "The red light is [A.disabled ? "off" : "on"]."
	. += "The blue light is [A.hacked ? "off" : "on"]."

/datum/wires/circuit_imprinter/interactable(mob/user)
	var/obj/machinery/rnd/production/circuit_imprinter/A = holder
	if(A.panel_open)
		return TRUE
	return FALSE

/datum/wires/circuit_imprinter/on_cut(wire, mend)
	var/obj/machinery/rnd/production/circuit_imprinter/A = holder
	switch(wire)
		if(WIRE_LATHE_HACK)
			A.hacked = !mend
			A.update_tgui_static_data(usr)
		if(WIRE_LATHE_DISABLE)
			A.disabled = !mend
	..()

/datum/wires/circuit_imprinter/on_pulse(wire)
	if(is_cut(wire))
		return
	var/obj/machinery/rnd/production/circuit_imprinter/A = holder
	switch(wire)
		if(WIRE_LATHE_HACK)
			A.hacked = !A.hacked
			A.update_tgui_static_data(usr)
			addtimer(CALLBACK(src, PROC_REF(reset_hacked), WIRE_LATHE_HACK, usr), 5 SECONDS)
		if(WIRE_LATHE_DISABLE)
			A.disabled = !A.disabled
			addtimer(CALLBACK(src, PROC_REF(reset_disable), WIRE_LATHE_DISABLE), 5 SECONDS)
	..()

/datum/wires/circuit_imprinter/proc/reset_hacked(wire, mob/user)
	var/obj/machinery/rnd/production/circuit_imprinter/A = holder
	if(A && !is_cut(wire))
		A.hacked = FALSE
		A.update_tgui_static_data(user)

/datum/wires/circuit_imprinter/proc/reset_disable(wire)
	var/obj/machinery/rnd/production/circuit_imprinter/A = holder
	if(A && !is_cut(wire))
		A.disabled = FALSE
