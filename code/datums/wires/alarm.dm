/datum/wires/alarm
	holder_type = /obj/machinery/alarm
	wire_count = 5
	proper_name = "Air alarm"

/datum/wires/alarm/New(atom/_holder)
	wires = list(
		WIRE_IDSCAN, WIRE_MAIN_POWER1, WIRE_SYPHON,
		WIRE_AI_CONTROL, WIRE_AALARM
	)
	return ..()

/datum/wires/alarm/interactable(mob/user)
	var/obj/machinery/alarm/A = holder
	if(A.panel_open)
		return TRUE
	return FALSE

/datum/wires/alarm/get_status()
	var/obj/machinery/alarm/A = holder
	. = ..()
	. += "The Air Alarm is [A.locked ? "locked." : "unlocked."]"
	. += "The Air Alarm is [(A.shorted || (A.stat & (NOPOWER|BROKEN))) ? "offline." : "working properly!"]"
	. += "The 'AI control allowed' light is [A.aidisabled ? "off" : "on"]."

/datum/wires/alarm/on_cut(wire, mend)
	var/obj/machinery/alarm/A = holder
	switch(wire)
		if(WIRE_IDSCAN)
			if(!mend)
				A.locked = TRUE

		if(WIRE_MAIN_POWER1)
			A.shock(usr, 50)
			A.shorted = !mend
			A.update_icon()

		if(WIRE_AI_CONTROL)
			A.aidisabled = !mend

		if(WIRE_SYPHON)
			if(!mend)
				A.mode = 3 // MODE_PANIC
				A.apply_mode()

		if(WIRE_AALARM)
			if(A.alarm_area.atmosalert(2, A))
				A.post_alert(2)
			A.update_icon()
	..()

/datum/wires/alarm/on_pulse(wire)
	var/obj/machinery/alarm/A = holder
	switch(wire)
		if(WIRE_IDSCAN)
			A.locked = !A.locked

		if(WIRE_MAIN_POWER1)
			if(!A.shorted)
				A.shorted = TRUE
				for(var/obj/machinery/alarm/AA in A.alarm_area)
					AA.update_icon()
			addtimer(CALLBACK(src, PROC_REF(clear_short)), 20 MINUTES, TIMER_DELETE_ME)

		if(WIRE_AI_CONTROL)
			if(!A.aidisabled)
				A.aidisabled = TRUE
			A.updateDialog()
			addtimer(VARSET_CALLBACK(A, aidisabled, FALSE), 10 SECONDS, TIMER_DELETE_ME)

		if(WIRE_SYPHON)
			if(A.mode == 1) // MODE_SCRUB
				A.mode = 3 // MODE_PANIC
			else
				A.mode = 1 // MODE_SCRUB
			A.apply_mode()

		if(WIRE_AALARM)
			if(A.alarm_area.atmosalert(0, A))
				A.post_alert(0)
			A.update_icon()

/datum/wires/alarm/proc/clear_short()
	SHOULD_NOT_OVERRIDE(TRUE)
	PRIVATE_PROC(TRUE)
	var/obj/machinery/alarm/A = holder
	if(A && A.shorted)
		A.shorted = FALSE
		A.update_icon()
