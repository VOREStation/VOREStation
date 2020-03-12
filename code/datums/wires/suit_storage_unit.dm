/datum/wires/suit_storage_unit
	holder_type = /obj/machinery/suit_cycler
	wire_count = 3
	var/datum/wire_hint/zap_hint
	var/datum/wire_hint/safeties_hint
	var/datum/wire_hint/locked_hint

/datum/wires/suit_storage_unit/make_wire_hints()
	zap_hint = new("The orange light is off.", "The orange light is on.")
	safeties_hint = new("The red light is off.", "The red light is blinking.")
	locked_hint = new("The yellow light is on.", "The yellow light is off.")

/datum/wires/suit_storage_unit/Destroy()
	zap_hint = null
	safeties_hint = null
	locked_hint = null
	return ..()

var/const/SUIT_STORAGE_WIRE_ELECTRIFY	= 1
var/const/SUIT_STORAGE_WIRE_SAFETY		= 2
var/const/SUIT_STORAGE_WIRE_LOCKED		= 4

/datum/wires/suit_storage_unit/CanUse(var/mob/living/L)
	var/obj/machinery/suit_cycler/S = holder
	if(!istype(L, /mob/living/silicon))
		if(S.electrified)
			if(S.shock(L, 100))
				return 0
	if(S.panel_open)
		return 1
	return 0

/datum/wires/suit_storage_unit/GetInteractWindow()
	var/obj/machinery/suit_cycler/S = holder
	. += ..()
	. += zap_hint.show(S.electrified)
	. += safeties_hint.show(S.safeties)
	. += locked_hint.show(S.locked)

/datum/wires/suit_storage_unit/UpdatePulsed(var/index)
	var/obj/machinery/suit_cycler/S = holder
	switch(index)
		if(SUIT_STORAGE_WIRE_SAFETY)
			S.safeties = !S.safeties
		if(SUIT_STORAGE_WIRE_ELECTRIFY)
			S.electrified = 30
		if(SUIT_STORAGE_WIRE_LOCKED)
			S.locked = !S.locked

/datum/wires/suit_storage_unit/UpdateCut(var/index, var/mended)
	var/obj/machinery/suit_cycler/S = holder
	switch(index)
		if(SUIT_STORAGE_WIRE_SAFETY)
			S.safeties = mended
		if(SUIT_STORAGE_WIRE_LOCKED)
			S.locked = mended
		if(SUIT_STORAGE_WIRE_ELECTRIFY)
			if(mended)
				S.electrified = 0
			else
				S.electrified = -1
