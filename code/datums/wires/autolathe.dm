/datum/wires/autolathe

	holder_type = /obj/machinery/autolathe
	wire_count = 6

var/const/AUTOLATHE_HACK_WIRE = 1
var/const/AUTOLATHE_SHOCK_WIRE = 2
var/const/AUTOLATHE_DISABLE_WIRE = 4

/datum/wires/autolathe/GetInteractWindow()
	var/obj/machinery/autolathe/A = holder
	. += ..()
	. += show_hint(0x1, A.disabled,	"The red light is off.", "The red light is on.")
	. += show_hint(0x2, A.shocked,	"The green light is off.", "The green light is on.")
	. += show_hint(0x4, A.hacked,	"The blue light is off.", "The blue light is on.")

/datum/wires/autolathe/CanUse()
	var/obj/machinery/autolathe/A = holder
	if(A.panel_open)
		return 1
	return 0

/datum/wires/autolathe/proc/update_autolathe_ui(mob/living/user)
	if(CanUse(user))
		var/obj/machinery/autolathe/A = holder
		A.interact(user)

/datum/wires/autolathe/UpdateCut(index, mended)
	var/obj/machinery/autolathe/A = holder
	switch(index)
		if(AUTOLATHE_HACK_WIRE)
			A.hacked = !mended
		if(AUTOLATHE_SHOCK_WIRE)
			A.shocked = !mended
		if(AUTOLATHE_DISABLE_WIRE)
			A.disabled = !mended
	update_autolathe_ui(usr)

/datum/wires/autolathe/UpdatePulsed(index)
	if(IsIndexCut(index))
		return
	var/obj/machinery/autolathe/A = holder
	switch(index)
		if(AUTOLATHE_HACK_WIRE)
			A.hacked = !A.hacked
			spawn(50)
				if(A && !IsIndexCut(index))
					A.hacked = 0
					update_autolathe_ui(usr)
		if(AUTOLATHE_SHOCK_WIRE)
			A.shocked = !A.shocked
			spawn(50)
				if(A && !IsIndexCut(index))
					A.shocked = 0
		if(AUTOLATHE_DISABLE_WIRE)
			A.disabled = !A.disabled
			spawn(50)
				if(A && !IsIndexCut(index))
					A.disabled = 0
					update_autolathe_ui(usr)
	update_autolathe_ui(usr)
