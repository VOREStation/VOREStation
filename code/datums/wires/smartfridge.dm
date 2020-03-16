/datum/wires/smartfridge
	holder_type = /obj/machinery/smartfridge
	wire_count = 3

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
	. += show_hint(0x1, S.seconds_electrified,	"The orange light is off.",	"The orange light is on.")
	. += show_hint(0x2, S.shoot_inventory,		"The red light is off.",	"The red light is blinking.")
	. += show_hint(0x4, S.scan_id,				"A purple light is on.",	"A yellow light is on.")

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
