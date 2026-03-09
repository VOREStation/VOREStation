// Constantly emites radiation from the tile it's placed on.
/obj/effect/map_effect/radiation_emitter
	name = "radiation emitter"
	icon_state = "radiation_emitter"
	var/range = 3
	var/radiation_power = 30 // Bigger numbers means more radiation.
	var/last_event = 0
	/// Mutex to prevent infinite recursion when propagating radiation pulses
	var/active = null

/obj/effect/map_effect/radiation_emitter/proc/radiate()
	SIGNAL_HANDLER
	if(active)
		return
	if(world.time <= last_event + 1.5 SECONDS)
		return
	active = TRUE
	radiation_pulse(
		src,
		max_range = range,
		threshold = RAD_LIGHT_INSULATION,
		chance = radiation_power,
		minimum_exposure_time = URANIUM_RADIATION_MINIMUM_EXPOSURE_TIME,
	)
	propagate_radiation_pulse()
	last_event = world.time
	active = FALSE


/obj/effect/map_effect/radiation_emitter/Initialize(mapload)
	RegisterSignal(src, COMSIG_ATOM_PROPAGATE_RAD_PULSE, PROC_REF(radiate))
	return ..()

/obj/effect/map_effect/radiation_emitter/Destroy()
	UnregisterSignal(src, COMSIG_ATOM_PROPAGATE_RAD_PULSE)
	return ..()

/obj/effect/map_effect/radiation_emitter/strong
	range = 7
	radiation_power = 100
