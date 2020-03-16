/datum/wires/smartfridge
	holder_type = /obj/machinery/smartfridge
	wire_count = 3
	var/datum/wire_hint/zap_hint
	var/datum/wire_hint/shoot_hint
	var/datum/wire_hint/scan_id_hint

/datum/wires/smartfridge/make_wire_hints()
	zap_hint = new("The orange light is off.", "The orange light is on.")
	shoot_hint = new("The red light is off.", "The red light is blinking.")
	scan_id_hint = new("A purple light is on.", "A yellow light is on.")

/datum/wires/smartfridge/Destroy()
	zap_hint = null
	shoot_hint = null
	scan_id_hint = null
	return ..()

/datum/wires/smartfridge/secure
	random = 1
	wire_count = 4

var/const/SMARTFRIDGE_WIRE_ELECTRIFY	= 1
var/const/SMARTFRIDGE_WIRE_THROW		= 2
var/const/SMARTFRIDGE_WIRE_IDSCAN		= 4

/datum/wires/smartfridge/CanUse(var/mob/living/L)
	var/obj/machinery/smartfridge/S = holder
	if(S.panel_open)
		return 1
	return 0

/datum/wires/smartfridge/GetInteractWindow()
	var/obj/machinery/smartfridge/S = holder
	. += ..()
	. += zap_hint.show(S.seconds_electrified)
	. += shoot_hint.show(S.shoot_inventory)
	. += scan_id_hint.show(S.scan_id)

/datum/wires/smartfridge/UpdatePulsed(var/index)
	var/obj/machinery/smartfridge/S = holder
	switch(index)
		if(SMARTFRIDGE_WIRE_THROW)
			S.shoot_inventory = !S.shoot_inventory
		if(SMARTFRIDGE_WIRE_ELECTRIFY)
			S.seconds_electrified = 30
		if(SMARTFRIDGE_WIRE_IDSCAN)
			S.scan_id = !S.scan_id

/datum/wires/smartfridge/UpdateCut(var/index, var/mended)
	var/obj/machinery/smartfridge/S = holder
	switch(index)
		if(SMARTFRIDGE_WIRE_THROW)
			S.shoot_inventory = !mended
		if(SMARTFRIDGE_WIRE_ELECTRIFY)
			if(mended)
				S.seconds_electrified = 0
			else
				S.seconds_electrified = -1
		if(SMARTFRIDGE_WIRE_IDSCAN)
			S.scan_id = 1
