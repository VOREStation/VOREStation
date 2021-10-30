/obj/machinery/power/emitter
	icon = 'icons/obj/singularity_vr.dmi' // New emitter sprite
	icon_state = "emitter0"
	var/previous_state = 0

/obj/machinery/power/emitter/Initialize()
	. = ..()
	previous_state = state

/obj/machinery/power/emitter/update_icon()
	cut_overlays()
	icon_state = "emitter[state]"
	if (state != previous_state)
		flick("emitterflick-[previous_state][state]",src)
		previous_state = state

	if(powered && powernet && avail(active_power_usage) && active)
		var/image/emitterbeam = image(icon,"emitter-beam")
		emitterbeam.plane = PLANE_LIGHTING_ABOVE
		add_overlay(emitterbeam)

	if(locked)
		var/image/emitterlock = image(icon,"emitter-lock")
		emitterlock.plane = PLANE_LIGHTING_ABOVE
		add_overlay(emitterlock)

// The old emitter sprite
/obj/machinery/power/emitter/antique
	name = "antique emitter"
	desc = "An old fashioned heavy duty industrial laser."
	icon_state = "emitter"

/obj/machinery/power/emitter/antique/update_icon()
	if(powered && powernet && avail(active_power_usage) && active)
		icon_state = "emitter_+a"
	else
		icon_state = "emitter"

