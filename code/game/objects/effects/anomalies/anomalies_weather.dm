/obj/effect/anomaly/weather
	name = "weather anomaly"
	icon_state = "weather"
	anomaly_core = /obj/item/assembly/signaler/anomaly/weather
	lifespan = ANOMALY_COUNTDOWN_TIMER * 2.5
	var/telegraph_percent = 7

	var/list/area/affected_areas = list()
	var/list/turf/affected_turfs = list()

	var/datum/anomalous_weather/selected_weather

	var/is_raining = FALSE

/obj/effect/anomaly/weather/Initialize(mapload, new_lifespan, drops_core)
	. = ..()

	affected_areas.Add(impact_area)

	if(selected_weather)
		selected_weather = new selected_weather
	else
		pick_weather()

	var/telegraph = lifespan / telegraph_percent

	for(var/spread_dir in GLOB.alldirs)
		var/area/nearby = find_adjacent_impacted_area(spread_dir)
		if(isnull(nearby) || nearby.flag_check(AREA_FORBID_EVENTS))
			continue
		if(istype(nearby, /area/space))
			continue
		affected_areas |= nearby

	for(var/area/area in affected_areas)
		for(var/mob/mob in area)
			to_chat(mob, span_notice(selected_weather.telegraph_message))
		for(var/turf/turf in area)
			if(isopenturf(turf))
				affected_turfs.Add(GetBelow(turf))
			affected_turfs.Add(turf)

	apply_wibbly_filters(src)

	addtimer(CALLBACK(src, PROC_REF(start_weather)), telegraph, TIMER_DELETE_ME)

/obj/effect/anomaly/weather/proc/find_adjacent_impacted_area(check_dir)
	var/limit = 10
	var/turf/next_turf = get_step(src, check_dir)
	while(next_turf.loc == impact_area && limit > 0)
		next_turf = get_step(next_turf, check_dir)
		if(isnull(next_turf))
			return null
		limit -= 1

	return next_turf.loc

/obj/effect/anomaly/weather/anomalyNeutralize()
	clear_weather()
	return ..()

/obj/effect/anomaly/weather/detonate()
	new /obj/effect/effect/smoke/bad/burntfood(loc) // OOoooOooh spooky cloud... Doesn't do ANYTHING
	qdel(src)

/obj/effect/anomaly/weather/anomalyEffect(seconds_per_tick)
	..()
	if(!is_raining)
		return

	for(var/turf/turf in affected_turfs)
		if(isopenturf(turf))
			turf = GetBelow(turf)
		selected_weather.affect_turf(turf)

	for(var/mob/mob as anything in GLOB.player_list)
		if(get_area(mob) in affected_areas)
			selected_weather.hear_sounds(mob, TRUE)
		else
			selected_weather.hear_sounds(mob, FALSE)

/obj/effect/anomaly/weather/proc/pick_weather(new_weather_path)
	if(!new_weather_path)
		new_weather_path = pick(subtypesof(/datum/anomalous_weather))

	selected_weather = new new_weather_path

/obj/effect/anomaly/weather/proc/start_weather()
	if(QDELETED(src))
		return

	is_raining = TRUE

	if(selected_weather.loop_sounds)
		selected_weather.loop_sounds.start()

	for(var/turf/area_turf in affected_turfs)
		selected_weather.apply_to_turf(area_turf)

/obj/effect/anomaly/weather/proc/clear_weather()
	if(!is_raining)
		return

	if(selected_weather.sounds)
		selected_weather.loop_sounds.stop()

	for(var/area in affected_areas)
		for(var/mob/mob in area)
			selected_weather.hear_sounds(mob, FALSE)

	for(var/turf/turf in affected_turfs)
		selected_weather.remove_from_turf(turf)

/obj/effect/anomaly/weather/Destroy()
	clear_weather()
	. = ..()

/obj/effect/anomaly/weather/proc/update_reagent(reagent)
	selected_weather.update_reagent(reagent)

/obj/effect/anomaly/weather/rain
	selected_weather = /datum/anomalous_weather/rain

/obj/effect/anomaly/weather/acidrain
	selected_weather = /datum/anomalous_weather/rain/acid

/obj/effect/anomaly/weather/storm
	selected_weather = /datum/anomalous_weather/rain/storm

/obj/effect/anomaly/weather/bloodrain
	selected_weather = /datum/anomalous_weather/rain/blood

/obj/effect/anomaly/weather/ashstorm
	selected_weather = /datum/anomalous_weather/ash_storm

/obj/effect/anomaly/weather/hail
	selected_weather = /datum/anomalous_weather/hail
