
/obj/effect/abstract/aberration
	name = "Aberration"
	desc = "Some sort of weird, pulsating entity."
	icon = 'icons/effects/effects.dmi'
	icon_state = "pre_confuse"
	alpha = 255

	///If the aberration starts active or not.
	var/start_active = TRUE

	///If the aberration has a toggling effect (Turns on-off)
	var/enabled = FALSE

	///If it pulses or not. i.e. has a non-continuous effect
	var/pulses = FALSE

	///Min time for pulses to occur
	var/pulse_time_min = 15

	///Max time for pulses to occur
	var/pulse_time_max = 30

	///The cooldown for our pulse
	COOLDOWN_DECLARE(pulse)

/obj/effect/abstract/aberration/Initialize(mapload)
	. = ..()
	if(start_active)
		START_PROCESSING(SSobj, src)

/obj/effect/abstract/aberration/Destroy()
	. = ..()
	STOP_PROCESSING(SSobj, src)

/obj/effect/abstract/aberration/process()
	if(COOLDOWN_FINISHED(src, pulse))
		perform_pulse()
		COOLDOWN_START(src, pulse, rand(pulse_time_min, pulse_time_max))
	perform_ambient_effects()

/obj/effect/abstract/aberration/proc/perform_pulse()
	return

/obj/effect/abstract/aberration/proc/perform_ambient_effects()
	return


/*
//Useful for later
	var/static/list/connections = list(
		COMSIG_ATOM_ENTERED = PROC_REF(ignite_the_unworthy),
	)
	AddComponent(/datum/component/connect_range, src, connections, range)
*/
