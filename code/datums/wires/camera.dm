// Wires for cameras.

/datum/wires/camera
	randomize = TRUE
	holder_type = /obj/machinery/camera
	wire_count = 6
	proper_name = "Camera"

/datum/wires/camera/New(atom/_holder)
	wires = list(WIRE_FOCUS, WIRE_MAIN_POWER1, WIRE_CAM_LIGHT, WIRE_CAM_ALARM)
	return ..()

/datum/wires/camera/get_status()
	. = ..()
	var/obj/machinery/camera/C = holder
	. += "The focus light is [(C.view_range == initial(C.view_range)) ? "on" : "off"]."
	. += "The power link light is [C.can_use() ? "on" : "off"]."
	. += "The camera light is [C.light_disabled ? "off" : "on"]."
	. += "The alarm light is [C.alarm_on ? "on" : "off"]."

/datum/wires/camera/interactable(mob/user)
	var/obj/machinery/camera/C = holder
	return C.panel_open

/datum/wires/camera/on_cut(wire, mend)
	var/obj/machinery/camera/C = holder

	switch(wire)
		if(WIRE_FOCUS)
			var/range = (mend ? initial(C.view_range) : C.short_range)
			C.setViewRange(range)

		if(WIRE_MAIN_POWER1)
			if(C.status && !mend || !C.status && mend)
				C.deactivate(usr, 1)

		if(WIRE_CAM_LIGHT)
			C.light_disabled = !mend

		if(WIRE_CAM_ALARM)
			if(!mend)
				C.triggerCameraAlarm()
			else
				C.cancelCameraAlarm()
	..()

/datum/wires/camera/on_pulse(wire)
	var/obj/machinery/camera/C = holder
	if(is_cut(wire))
		return
	switch(wire)
		if(WIRE_FOCUS)
			var/new_range = (C.view_range == initial(C.view_range) ? C.short_range : initial(C.view_range))
			C.setViewRange(new_range)

		if(WIRE_CAM_LIGHT)
			C.light_disabled = !C.light_disabled

		if(WIRE_CAM_ALARM)
			C.visible_message("\icon[C][bicon(C)] *beep*", "\icon[C][bicon(C)] *beep*")
	..()

/datum/wires/camera/proc/CanDeconstruct()
	return is_all_cut()
