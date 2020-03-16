/datum/wires/vending
	holder_type = /obj/machinery/vending
	wire_count = 4
	var/datum/wire_hint/zap_hint
	var/datum/wire_hint/shoot_hint
	var/datum/wire_hint/hidden_hint
	var/datum/wire_hint/scan_id_hint

/datum/wires/vending/make_wire_hints()
	zap_hint = new("The orange light is off.", "The orange light is on.")
	shoot_hint = new("The red light is off.", "The red light is blinking.")
	hidden_hint = new("A green light is on.", "A green light is off.")
	scan_id_hint = new("A purple light is on.", "A yellow light is on.")

/datum/wires/vending/Destroy()
	zap_hint = null
	shoot_hint = null
	hidden_hint = null
	scan_id_hint = null
	return ..()

var/const/VENDING_WIRE_THROW = 1
var/const/VENDING_WIRE_CONTRABAND = 2
var/const/VENDING_WIRE_ELECTRIFY = 4
var/const/VENDING_WIRE_IDSCAN = 8

/datum/wires/vending/CanUse(var/mob/living/L)
	var/obj/machinery/vending/V = holder
	if(V.panel_open)
		return 1
	return 0

/datum/wires/vending/GetInteractWindow()
	var/obj/machinery/vending/V = holder
	. += ..()
	. += zap_hint.show(V.seconds_electrified)
	. += shoot_hint.show(V.shoot_inventory)
	. += hidden_hint.show(V.categories & CAT_HIDDEN)
	. += scan_id_hint.show(V.scan_id)

/datum/wires/vending/UpdatePulsed(var/index)
	var/obj/machinery/vending/V = holder
	switch(index)
		if(VENDING_WIRE_THROW)
			V.shoot_inventory = !V.shoot_inventory
		if(VENDING_WIRE_CONTRABAND)
			V.categories ^= CAT_HIDDEN
		if(VENDING_WIRE_ELECTRIFY)
			V.seconds_electrified = 30
		if(VENDING_WIRE_IDSCAN)
			V.scan_id = !V.scan_id

/datum/wires/vending/UpdateCut(var/index, var/mended)
	var/obj/machinery/vending/V = holder
	switch(index)
		if(VENDING_WIRE_THROW)
			V.shoot_inventory = !mended
		if(VENDING_WIRE_CONTRABAND)
			V.categories &= ~CAT_HIDDEN
		if(VENDING_WIRE_ELECTRIFY)
			if(mended)
				V.seconds_electrified = 0
			else
				V.seconds_electrified = -1
		if(VENDING_WIRE_IDSCAN)
			V.scan_id = 1
