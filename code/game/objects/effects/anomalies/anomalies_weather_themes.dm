/datum/anomalous_weather
	var/name = "Unnamed Weather"
	var/icon = 'icons/effects/weather.dmi'
	var/icon_state = null
	var/reagent_id
	var/weather_colour

	var/datum/reagents/reagent_holder
	var/atom/movable/weather_visuals/visuals = null

	var/telegraph_message = "The storm is coming..."
	var/patter_message = "Something patters softly onto your umbrella. You're not quite sure of what it is, actually."
	var/drench_message = "You're getting... Wet?"

	var/sounds = null
	var/datum/looping_sound/loop_sounds = null

/datum/anomalous_weather/New()
	..()
	visuals = new()

	visuals.icon = icon
	visuals.icon_state = icon_state

	loop_sounds = new sounds(list(), FALSE, TRUE)

	if(reagent_id)
		reagent_holder = new(10000, null)
		reagent_holder.add_reagent(reagent_id, 10000)
		weather_colour = reagent_holder.get_color()

	if(weather_colour)
		visuals.color = weather_colour

/datum/anomalous_weather/proc/affect_turf(turf/to_affect)
	if(iswall(to_affect))
		return

	for(var/atom/thing in to_affect)
		if(isliving(thing))
			affect_mob(thing)
			continue

		if(!reagent_id) // No reagent was given, so don't do anything past this.
			continue

		reagent_holder.touch_obj(thing, 2)

		if(!istype(thing, /obj/item/reagent_containers))
			continue

		var/obj/item/reagent_containers/container = thing
		if(!container.is_open_container() || container.reagents.total_volume >= container.reagents.maximum_volume)
			continue

		container.reagents.add_reagent(reagent_id, 2)

	if(reagent_id == REAGENT_ID_WATER)
		to_affect.wash(CLEAN_ALL)

	do_special(to_affect)

	return

/datum/anomalous_weather/proc/affect_mob(mob/living/affected_mob)
	var/obj/item/melee/umbrella/U = affected_mob.get_active_hand()

	if(!istype(U) || !U.open)
		U = affected_mob.get_inactive_hand()

	if(istype(U) && U.open)
		if(prob(5))
			to_chat(affected_mob, span_notice(patter_message))
		return

	if(prob(5))
		to_chat(affected_mob, span_danger(drench_message))

	if(!reagent_id) // No reagent was given, no need to continue.
		return

	reagent_holder.splash_mob(affected_mob, 2)

	if(reagent_id == REAGENT_ID_WATER)
		affected_mob.wash(CLEAN_ALL)
		affected_mob.water_act(2)

/datum/anomalous_weather/proc/do_special(var/turf/simulated/T)
	return

/datum/anomalous_weather/proc/hear_sounds(mob/M, adding)
	if(!sounds)
		return
	if(adding)
		loop_sounds.output_atoms |= M
		return
	loop_sounds.output_atoms -= M

/datum/anomalous_weather/rain
	name = "Rain"
	icon_state = "anom_rain"
	reagent_id = REAGENT_ID_WATER
	sounds = /datum/looping_sound/weather/rain
	telegraph_message = "Clouds begin to cover the ceiling of the area..."
	patter_message = "Rain patters softly onto your umbrella."
	drench_message = "Rain falls on you, drenching you in water."

/datum/anomalous_weather/rain/do_special(turf/simulated/T)
	if(prob(2))
		T.wet_floor(1)

/datum/anomalous_weather/rain/blood
	name = "Blood Rain" // From a lacerated sky
	reagent_id = REAGENT_ID_BLOOD
	telegraph_message = "Red clouds begin to cover the ceiling of the area..."
	patter_message = "Blood splatters and falls past your umbrella." // Bleeding it's horrors
	drench_message = "Blood splatters fall on you, covering you in it."

/datum/anomalous_weather/rain/blood/do_special(turf/simulated/T)
	if(prob(0.5))
		blood_splatter(T, null, TRUE)

/datum/anomalous_weather/rain/storm
	name = "Storm"
	icon_state = "anom_rain_fast"
	loop_sounds = /datum/looping_sound/weather/outside_blizzard
	telegraph_message = "Grey clouds begin to cover the ceiling of the area..."
	patter_message = "Rain patters continuously onto your umbrella."
	drench_message = "Rain falls on you, completely soaking you."

/datum/anomalous_weather/rain/storm/do_special(turf/simulated/T)
	if(prob(3))
		T.wet_floor(1)
	if(prob(0.025))
		lightning_strike(T)

/datum/anomalous_weather/rain/acid
	name = "Acid Rain"
	reagent_id = REAGENT_ID_SACID
	telegraph_message = "Strange clouds begin to cover the ceiling, an acidid tinge on them..."

/datum/anomalous_weather/hail
	name = "Hail"
	icon_state = "snowfall_heavy_old"
	reagent_id = REAGENT_ID_ICE
	sounds = /datum/looping_sound/weather/outside_blizzard
	telegraph_message = "Grey clouds begin to cover the ceiling of the area..."
	patter_message = "Hail patters on your umbrella."
	drench_message = "Hail pelts you"

/datum/anomalous_weather/hail/affect_mob(mob/living/affected_mob)
	..()

	var/target_zone = pick(BP_ALL)
	var/amount_blocked = affected_mob.run_armor_check(target_zone, "melee")

	var/damage = rand(1,3)

	if(amount_blocked >= 30)
		return

	affected_mob.apply_damage(damage, BRUTE, target_zone, amount_blocked, used_weapon = "hail")

/datum/anomalous_weather/ash_storm
	name = "Ash Storm"
	icon_state = "ashfall_moderate-alt"
	sounds = /datum/looping_sound/weather/outside_blizzard
	telegraph_message = "Ash clouds begin to cover the ceiling of the area..."

/datum/anomalous_weather/ash_storm/affect_mob(mob/living/affected_mob)
	affected_mob.inflict_heat_damage(rand(1, 3))

/datum/anomalous_weather/ash_storm/do_special(turf/simulated/T)
	if(prob(5) && T.can_dirty)
		T.dirt += 30

/* Activate this one for a lot of rain
/datum/anomalous_weather/rain/storm/cats_n_dogs
	name = "Cats and dogs rain"
	telegraph_message = "Strange, fuzzy clouds beging to cover the ceiling of the area..."

/datum/anomalous_weather/rain/storm/cats_n_dogs/do_special(turf/simulated/T)
	..()
	if(prob(0.01))
		var/mob/living/cat_or_dog = pick(/mob/living/simple_mob/animal/passive/cat, /mob/living/simple_mob/animal/passive/dog)
		new cat_or_dog(T.loc)
		T.visible_message(span_danger("A [cat_or_dog.name] falls from within the strange clouds!"))
*/
