// Wires for cameras.

/datum/wires/camera
	random = 1
	holder_type = /obj/machinery/camera
	wire_count = 6
	var/datum/wire_hint/view_hint
	var/datum/wire_hint/power_hint
	var/datum/wire_hint/light_hint
	var/datum/wire_hint/alarm_hint

/datum/wires/camera/make_wire_hints()
	view_hint = new("The focus light is on.", "The focus light is off.")
	power_hint = new("The power link light is on.", "The power link light is off.")
	light_hint = new("The camera light is off.", "The camera light is on.")
	alarm_hint = new("The alarm light is on.", "The alarm light is off.")

/datum/wires/camera/Destroy()
	view_hint = null
	power_hint = null
	light_hint = null
	alarm_hint = null
	return ..()

/datum/wires/camera/GetInteractWindow()
	. = ..()
	var/obj/machinery/camera/C = holder
	. += view_hint.show(C.view_range == initial(C.view_range))
	. += power_hint.show(C.can_use())
	. += light_hint.show(C.light_disabled)
	. += alarm_hint.show(C.alarm_on)
	return .

/datum/wires/camera/CanUse(var/mob/living/L)
	var/obj/machinery/camera/C = holder
	return C.panel_open

var/const/CAMERA_WIRE_FOCUS = 1
var/const/CAMERA_WIRE_POWER = 2
var/const/CAMERA_WIRE_LIGHT = 4
var/const/CAMERA_WIRE_ALARM = 8
var/const/CAMERA_WIRE_NOTHING1 = 16
var/const/CAMERA_WIRE_NOTHING2 = 32

/datum/wires/camera/UpdateCut(var/index, var/mended)
	var/obj/machinery/camera/C = holder

	switch(index)
		if(CAMERA_WIRE_FOCUS)
			var/range = (mended ? initial(C.view_range) : C.short_range)
			C.setViewRange(range)

		if(CAMERA_WIRE_POWER)
			if(C.status && !mended || !C.status && mended)
				C.deactivate(usr, 1)

		if(CAMERA_WIRE_LIGHT)
			C.light_disabled = !mended

		if(CAMERA_WIRE_ALARM)
			if(!mended)
				C.triggerCameraAlarm()
			else
				C.cancelCameraAlarm()
	return

/datum/wires/camera/UpdatePulsed(var/index)
	var/obj/machinery/camera/C = holder
	if(IsIndexCut(index))
		return
	switch(index)
		if(CAMERA_WIRE_FOCUS)
			var/new_range = (C.view_range == initial(C.view_range) ? C.short_range : initial(C.view_range))
			C.setViewRange(new_range)

		if(CAMERA_WIRE_LIGHT)
			C.light_disabled = !C.light_disabled

		if(CAMERA_WIRE_ALARM)
			C.visible_message("[bicon(C)] *beep*", "[bicon(C)] *beep*")
	return

/datum/wires/camera/proc/CanDeconstruct()
	if(IsIndexCut(CAMERA_WIRE_POWER) && IsIndexCut(CAMERA_WIRE_FOCUS) && IsIndexCut(CAMERA_WIRE_LIGHT) && IsIndexCut(CAMERA_WIRE_NOTHING1) && IsIndexCut(CAMERA_WIRE_NOTHING2))
		return 1
	else
		return 0
