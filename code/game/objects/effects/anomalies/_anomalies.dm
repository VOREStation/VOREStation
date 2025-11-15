/obj/effect/anomaly
	name = "anomaly"
	desc = "A mysterious anomaly, seen commonly only in the region of space that the station orbits..."
	icon = 'icons/effects/anomalies.dmi'
	icon_state = "vortex"
	density = FALSE
	anchored = TRUE
	light_range = 3

	var/obj/item/assembly/signaler/anomaly/anomaly_core = /obj/item/assembly/signaler/anomaly
	var/area/impact_area

	var/lifespan = ANOMALY_COUNTDOWN_TIMER
	var/death_time

	var/countdown_colour
	var/obj/effect/countdown/anomaly/countdown

	var/immortal = FALSE
	var/move_chance = ANOMALY_MOVECHANCE

/obj/effect/anomaly/Initialize(mapload, new_lifespan, drops_core = TRUE)
	. = ..()

	START_PROCESSING(SSobj, src)
	impact_area = get_area(src)

	if(!impact_area)
		return INITIALIZE_HINT_QDEL

	if(!drops_core)
		anomaly_core = null

	if(anomaly_core)
		anomaly_core = new anomaly_core(src)
		anomaly_core.code = rand(1, 100)
		anomaly_core.anomaly_type = type

		anomaly_core.set_frequency(sanitize_frequency(get_rand_frequency()))

	if(new_lifespan)
		lifespan = new_lifespan
	death_time = world.time + lifespan

	countdown = new(src)
	if(countdown_colour)
		countdown_colour = countdown_colour

	if(immortal)
		return
	countdown.start()

/obj/effect/anomaly/process(seconds_per_tick)
	anomalyEffect(seconds_per_tick)
	if(death_time < world.time && !immortal)
		if(loc)
			detonate()
		qdel(src)

/obj/effect/anomaly/Destroy()
	STOP_PROCESSING(SSobj, src)
	QDEL_NULL(countdown)
	QDEL_NULL(anomaly_core)
	return ..()

/obj/effect/anomaly/proc/anomalyEffect(seconds_per_tick)
	if(prob(move_chance))
		move_anomaly()

/obj/effect/anomaly/proc/move_anomaly()
	step(src, pick(GLOB.alldirs))

/obj/effect/anomaly/proc/detonate()
	return

/obj/effect/anomaly/ex_act(strength)
	if(strength <= 1)
		qdel(src)
		return TRUE
	return FALSE

/obj/effect/anomaly/proc/anomalyNeutralize()
	new /obj/effect/effect/smoke/bad(loc)
	if(!isnull(anomaly_core))
		anomaly_core.forceMove(get_turf(src))
		anomaly_core = null
	qdel(src)

/obj/effect/anomaly/proc/stabilize(anchor = FALSE, has_core = TRUE)
	immortal = TRUE
	name = (has_core ? "stable " : "hollow ") + name
	if(!has_core)
		QDEL_NULL(anomaly_core)
	if(anchor)
		move_chance = 0
