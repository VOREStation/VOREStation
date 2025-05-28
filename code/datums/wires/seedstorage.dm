/datum/wires/seedstorage
	holder_type = /obj/machinery/seed_storage
	wire_count = 4
	randomize = TRUE
	proper_name = "Seed Storage"

/datum/wires/seedstorage/New(atom/_holder)
	wires = list(WIRE_SEED_SMART, WIRE_CONTRABAND, WIRE_ELECTRIFY, WIRE_SEED_LOCKDOWN)
	return ..()

/datum/wires/seedstorage/interactable(mob/user)
	var/obj/machinery/seed_storage/V = holder
	if(V.panel_open)
		return TRUE
	return FALSE

/datum/wires/seedstorage/get_status()
	var/obj/machinery/seed_storage/V = holder
	. = ..()
	. += "The orange light is [V.seconds_electrified ? "off." : "on."]"
	. += "The red light is [V.smart ? "off." : "blinking."]"
	. += "The green light is [(V.hacked || V.emagged) ? "on." : "off."]"
	. += "The keypad lock light is [V.lockdown ? "deployed." : "retracted."]"

/datum/wires/seedstorage/on_pulse(wire)
	var/obj/machinery/seed_storage/V = holder
	switch(wire)
		if(WIRE_SEED_SMART)
			V.smart = !V.smart
		if(WIRE_CONTRABAND)
			V.hacked = !V.hacked
		if(WIRE_ELECTRIFY)
			V.seconds_electrified = 30
		if(WIRE_SEED_LOCKDOWN)
			V.lockdown = !V.lockdown
	..()

/datum/wires/seedstorage/on_cut(wire, mend)
	var/obj/machinery/seed_storage/V = holder
	switch(wire)
		if(WIRE_SEED_SMART)
			V.smart = FALSE
		if(WIRE_CONTRABAND)
			V.hacked = !mend
		if(WIRE_ELECTRIFY)
			if(mend)
				V.seconds_electrified = 0
			else
				V.seconds_electrified = -1
		if(WIRE_SEED_LOCKDOWN)
			if(mend)
				V.lockdown = TRUE
				V.req_access = list()
				V.req_one_access = list()
			else
				V.req_access = initial(V.req_access)
				V.req_one_access = initial(V.req_one_access)
	..()
