#define SEED_WIRE_SMART 1
#define SEED_WIRE_CONTRABAND 2
#define SEED_WIRE_ELECTRIFY 4
#define SEED_WIRE_LOCKDOWN 8

/datum/wires/seedstorage
	holder_type = /obj/machinery/seed_storage
	wire_count = 4
	random = 1
	var/datum/wire_hint/zap_hint
	var/datum/wire_hint/smart_hint
	var/datum/wire_hint/hacked_hint
	var/datum/wire_hint/lockdown_hint

/datum/wires/seedstorage/make_wire_hints()
	zap_hint = new("The orange light is off.", "The orange light is on.")
	smart_hint = new("The red light is off.", "The red light is blinking.")
	hacked_hint = new("The green light is on.", "The green light is off.")
	lockdown_hint = new("The keypad lock is deployed.", "The keypad lock is retracted.")

/datum/wires/seedstorage/Destroy()
	zap_hint = null
	smart_hint = null
	hacked_hint = null
	lockdown_hint = null
	return ..()

/datum/wires/seedstorage/CanUse(var/mob/living/L)
	var/obj/machinery/seed_storage/V = holder
	if(V.panel_open)
		return 1
	return 0

/datum/wires/seedstorage/GetInteractWindow()
	var/obj/machinery/seed_storage/V = holder
	. += ..()
	. += zap_hint.show(V.seconds_electrified)
	. += smart_hint.show(V.smart)
	. += hacked_hint.show(V.hacked || V.emagged)
	. += lockdown_hint.show(V.lockdown)

/datum/wires/seedstorage/UpdatePulsed(var/index)
	var/obj/machinery/seed_storage/V = holder
	switch(index)
		if(SEED_WIRE_SMART)
			V.smart = !V.smart
		if(SEED_WIRE_CONTRABAND)
			V.hacked = !V.hacked
		if(SEED_WIRE_ELECTRIFY)
			V.seconds_electrified = 30
		if(SEED_WIRE_LOCKDOWN)
			V.lockdown = !V.lockdown

/datum/wires/seedstorage/UpdateCut(var/index, var/mended)
	var/obj/machinery/seed_storage/V = holder
	switch(index)
		if(SEED_WIRE_SMART)
			V.smart = 0
		if(SEED_WIRE_CONTRABAND)
			V.hacked = !mended
		if(SEED_WIRE_ELECTRIFY)
			if(mended)
				V.seconds_electrified = 0
			else
				V.seconds_electrified = -1
		if(SEED_WIRE_LOCKDOWN)
			if(mended)
				V.lockdown = 1
				V.req_access = list()
				V.req_one_access = list()
			else
				V.req_access = initial(V.req_access)
				V.req_one_access = initial(V.req_one_access)
