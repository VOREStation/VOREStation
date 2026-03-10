// Constantly emites radiation from the tile it's placed on.
/obj/effect/map_effect/radiation_emitter
	name = "radiation emitter"
	icon_state = "radiation_emitter"
	var/range = 3
	var/radiation_power = 30 // Bigger numbers means more radiation.
	var/last_event = 0
	/// Mutex to prevent infinite recursion when propagating radiation pulses
	var/active = null
	var/strength = 50

/obj/effect/map_effect/radiation_emitter/process()
	radiate()
	..()

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
		strenght = strength
	)
	last_event = world.time
	active = FALSE


/obj/effect/map_effect/radiation_emitter/Initialize(mapload)
	START_PROCESSING(SSobj, src)
	return ..()

/obj/effect/map_effect/radiation_emitter/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/effect/map_effect/radiation_emitter/strong
	range = 7
	radiation_power = 100
	strength = 250
