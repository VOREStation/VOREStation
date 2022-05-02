/datum/wires/suit_storage_unit
	holder_type = /obj/machinery/suit_cycler
	wire_count = 3
	proper_name = "Suit storage unit"

/datum/wires/suit_storage_unit/New(atom/_holder)
	wires = list(WIRE_IDSCAN, WIRE_ELECTRIFY, WIRE_SAFETY)
	return ..()

/datum/wires/suit_storage_unit/interactable(mob/user)
	var/obj/machinery/suit_cycler/S = holder
	if(ishuman(user) && S.Adjacent(user) && S.electrified)
		return !S.shock(user, 100)
	if(S.panel_open)
		return TRUE
	return FALSE

/datum/wires/suit_storage_unit/get_status()
	. = ..()
	var/obj/machinery/suit_cycler/A = holder
	. += "The orange light is [A.electrified ? "off" : "on"]."
	. += "The red light is [A.safeties ? "off" : "blinking"]."
	. += "The yellow light is [A.locked ? "on" : "off"]."

/datum/wires/suit_storage_unit/on_pulse(wire)
	var/obj/machinery/suit_cycler/S = holder
	switch(wire)
		if(WIRE_SAFETY)
			S.safeties = !S.safeties
		if(WIRE_ELECTRIFY)
			S.electrified = 30
		if(WIRE_IDSCAN)
			S.locked = !S.locked

/datum/wires/suit_storage_unit/on_cut(wire, mend)
	var/obj/machinery/suit_cycler/S = holder
	switch(wire)
		if(WIRE_SAFETY)
			S.safeties = mend
		if(WIRE_IDSCAN)
			S.locked = mend
		if(WIRE_ELECTRIFY)
			if(mend)
				S.electrified = 0
			else
				S.electrified = -1
