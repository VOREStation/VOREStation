/obj/effect/anomaly/pyro
	name = "pyroclastic anomaly"
	icon_state = "pyroclastic"
	var/ticks = 0
	/// How many seconds between each gas release
	var/releasedelay = 15 SECONDS
	anomaly_core = /obj/item/assembly/signaler/anomaly/pyro

/obj/effect/anomaly/pyro/Initialize(mapload, new_lifespan, drops_core)
	. = ..()
	apply_wibbly_filters(src)

/obj/effect/anomaly/pyro/anomalyEffect(seconds_per_tick)
	..()
	ticks += seconds_per_tick
	if(ticks < releasedelay)
		return FALSE
	else
		ticks -= releasedelay
	var/turf/simulated/floor/tile = get_turf(src)
	if(istype(tile))
		tile.assume_gas(GAS_PHORON, 10, T20C)
		tile.hotspot_expose(700, 400)
	return TRUE

/obj/effect/anomaly/pyro/detonate()
	var/turf/simulated/floor/tile = get_turf(src)
	if(istype(tile))
		tile.assume_gas(GAS_PHORON, 10, T20C)
		tile.hotspot_expose(700, 400)

	var/new_colour = pick(/mob/living/simple_mob/slime/xenobio/red, /mob/living/simple_mob/slime/xenobio/orange)
	var/mob/living/simple_mob/slime/xenobio/pyro = new new_colour(tile)
	pyro.enrage()
