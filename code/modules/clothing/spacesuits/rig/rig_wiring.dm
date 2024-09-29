/datum/wires/rig
	randomize = TRUE
	holder_type = /obj/item/rig
	wire_count = 5

/datum/wires/rig/New(atom/_holder)
	wires = list(WIRE_RIG_SECURITY, WIRE_RIG_AI_OVERRIDE, WIRE_RIG_SYSTEM_CONTROL, WIRE_RIG_INTERFACE_LOCK, WIRE_RIG_INTERFACE_SHOCK)
	return ..()
/*
 * Rig security can be snipped to disable ID access checks on rig.
 * Rig AI override can be pulsed to toggle whether or not the AI can take control of the suit.
 * System control can be pulsed to toggle some malfunctions.
 * Interface lock can be pulsed to toggle whether or not the interface can be accessed.
 */

/datum/wires/rig/on_cut(wire, mend)
	var/obj/item/rig/rig = holder
	switch(wire)
		if(WIRE_RIG_SECURITY)
			if(mend)
				rig.req_access = initial(rig.req_access)
				rig.req_one_access = initial(rig.req_one_access)
		if(WIRE_RIG_INTERFACE_SHOCK)
			rig.electrified = mend ? 0 : -1
			rig.shock(usr,100)

/datum/wires/rig/on_pulse(wire)
	var/obj/item/rig/rig = holder
	switch(wire)
		if(WIRE_RIG_SECURITY)
			rig.security_check_enabled = !rig.security_check_enabled
			rig.visible_message("\The [rig] twitches as several suit locks [rig.security_check_enabled?"close":"open"].")
		if(WIRE_RIG_AI_OVERRIDE)
			rig.ai_override_enabled = !rig.ai_override_enabled
			rig.visible_message("A small red light on [rig] [rig.ai_override_enabled?"goes dead":"flickers on"].")
		if(WIRE_RIG_SYSTEM_CONTROL)
			rig.malfunctioning += 10
			if(rig.malfunction_delay <= 0)
				rig.malfunction_delay = 20
			rig.shock(usr,100)
		if(WIRE_RIG_INTERFACE_LOCK)
			rig.interface_locked = !rig.interface_locked
			rig.visible_message("\The [rig] clicks audibly as the software interface [rig.interface_locked?"darkens":"brightens"].")
		if(WIRE_RIG_INTERFACE_SHOCK)
			if(rig.electrified != -1)
				rig.electrified = 30
			rig.shock(usr,100)

/datum/wires/rig/interactable(mob/user)
	var/obj/item/rig/rig = holder
	if(rig.open)
		return TRUE
	return FALSE