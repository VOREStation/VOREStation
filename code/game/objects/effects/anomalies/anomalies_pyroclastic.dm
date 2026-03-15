/obj/effect/anomaly/pyro
	name = "pyroclastic anomaly"
	icon_state = "pyroclastic"
	danger_mult = 1.3
	var/ticks = 0
	/// How many seconds between each gas release
	var/releasedelay = 15 SECONDS
	anomaly_core = /obj/item/assembly/signaler/anomaly/pyro

/obj/effect/anomaly/pyro/Initialize(mapload, new_lifespan, drops_core)
	. = ..()
	apply_wibbly_filters(src)

/obj/effect/anomaly/pyro/anomalyEffect(seconds_per_tick)
	..()
	if(stats)
		return
	ticks += seconds_per_tick
	if(ticks < releasedelay)
		return FALSE
	else
		ticks -= releasedelay
	burst()
	return TRUE

/obj/effect/anomaly/pyro/proc/burst(moles = 10, temperature = 700, volume = 400)
	var/turf/simulated/floor/tile = get_turf(src)
	if(istype(tile))
		tile.assume_gas(GAS_PHORON, moles, T20C)
		tile.hotspot_expose(temperature, volume)

/obj/effect/anomaly/pyro/detonate()
	burst()

	var/new_colour = pick(/mob/living/simple_mob/slime/xenobio/red, /mob/living/simple_mob/slime/xenobio/orange)
	var/mob/living/simple_mob/slime/xenobio/pyro = new new_colour(get_turf(src))
	pyro.enrage()

/obj/effect/anomaly/pyro/anomalyPulse()
	if(!..())
		return
	switch(stats.severity)
		if(0 to 15)
			var/datum/effect/effect/system/spark_spread/sparks = new /datum/effect/effect/system/spark_spread
			sparks.set_up(3, 1, src)
			sparks.start()
		if(16 to 33)
			burst()
		if(34 to 65)
			burst(20, 900, 600)
		else
			burst(30, 110, 800)
