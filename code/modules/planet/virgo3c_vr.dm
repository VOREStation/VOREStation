#define VIRGO3C_ONE_ATMOSPHERE	92.5 //kPa
#define VIRGO3C_AVG_TEMP	288.15 //kelvin

#define VIRGO3C_PER_N2			0.78 //percent
#define VIRGO3C_PER_O2			0.21
#define VIRGO3C_PER_N2O		0.00 //Currently no capacity to 'start' a turf with this. See turf.dm
#define VIRGO3C_PER_CO2		0.01
#define VIRGO3C_PER_PHORON		0.00

//Math only beyond this point
#define VIRGO3C_MOL_PER_TURF	(VIRGO3C_ONE_ATMOSPHERE*CELL_VOLUME/(VIRGO3C_AVG_TEMP*R_IDEAL_GAS_EQUATION))
#define VIRGO3C_MOL_N2			(VIRGO3C_MOL_PER_TURF * VIRGO3C_PER_N2)
#define VIRGO3C_MOL_O2			(VIRGO3C_MOL_PER_TURF * VIRGO3C_PER_O2)
#define VIRGO3C_MOL_N2O			(VIRGO3C_MOL_PER_TURF * VIRGO3C_PER_N2O)
#define VIRGO3C_MOL_CO2			(VIRGO3C_MOL_PER_TURF * VIRGO3C_PER_CO2)
#define VIRGO3C_MOL_PHORON		(VIRGO3C_MOL_PER_TURF * VIRGO3C_PER_PHORON)

//Turfmakers
#define VIRGO3C_SET_ATMOS	nitrogen=VIRGO3C_MOL_N2;oxygen=VIRGO3C_MOL_O2;carbon_dioxide=VIRGO3C_MOL_CO2;phoron=VIRGO3C_MOL_PHORON;temperature=VIRGO3C_AVG_TEMP
#define VIRGO3C_TURF_CREATE(x)	x/virgo3c/nitrogen=VIRGO3C_MOL_N2;x/virgo3c/oxygen=VIRGO3C_MOL_O2;x/virgo3c/carbon_dioxide=VIRGO3C_MOL_CO2;x/virgo3c/phoron=VIRGO3C_MOL_PHORON;x/virgo3c/temperature=VIRGO3C_AVG_TEMP;x/virgo3c/outdoors=TRUE;x/virgo3c/update_graphic(list/graphic_add = null, list/graphic_remove = null) return 0
#define VIRGO3C_TURF_CREATE_UN(x)	x/virgo3c/nitrogen=VIRGO3C_MOL_N2;x/virgo3c/oxygen=VIRGO3C_MOL_O2;x/virgo3c/carbon_dioxide=VIRGO3C_MOL_CO2;x/virgo3c/phoron=VIRGO3C_MOL_PHORON;x/virgo3c/temperature=VIRGO3C_AVG_TEMP

var/datum/planet/virgo3c/planet_virgo3c = null

/datum/time/virgo3c
	seconds_in_day = 6 HOURS

/datum/planet/virgo3c
	name = "Virgo-3C"
	desc = "A habitable moon of the gas giant Virgo 3. The volcanic activity of this moon keeps its atmosphere warm enough for life to flourish."
	current_time = new /datum/time/virgo3c()
	planetary_wall_type = /turf/unsimulated/wall/planetary/virgo3c

/datum/planet/virgo3c/New()
	..()
	planet_virgo3c = src
	weather_holder = new /datum/weather_holder/virgo3c(src)

/datum/planet/virgo3c/update_sun()
	..()
	var/datum/time/time = current_time
	var/length_of_day = time.seconds_in_day / 10 / 60 / 60
	var/noon = length_of_day / 2
	var/distance_from_noon = abs(text2num(time.show_time("hh")) - noon)
	sun_position = distance_from_noon / noon
	sun_position = abs(sun_position - 1)

	var/low_brightness = null
	var/high_brightness = null

	var/low_color = null
	var/high_color = null
	var/min = 0

	switch(sun_position)
		if(0 to 0.3) // Night
			low_brightness = 0.3
			low_color = "#000066"

			high_brightness = 0.4
			high_color = "#66004D"
			min = 0

		if(0.3 to 0.35) // Twilight
			low_brightness = 0.5
			low_color = "#66004D"

			high_brightness = 0.9
			high_color = "#CC3300"
			min = 0.40

		if(0.35 to 0.45) // Sunrise/set
			low_brightness = 0.9
			low_color = "#CC3300"

			high_brightness = 3.0
			high_color = "#FF9933"
			min = 0.50

		if(0.45 to 1.00) // Noon
			low_brightness = 3.0
			low_color = "#DDDDDD"

			high_brightness = 10.0
			high_color = "#FFFFFF"
			min = 0.70

	var/interpolate_weight = (abs(min - sun_position)) * 4
	var/weather_light_modifier = 1
	if(weather_holder && weather_holder.current_weather)
		weather_light_modifier = weather_holder.current_weather.light_modifier

	var/new_brightness = (LERP(low_brightness, high_brightness, interpolate_weight) ) * weather_light_modifier

	var/new_color = null
	if(weather_holder && weather_holder.current_weather && weather_holder.current_weather.light_color)
		new_color = weather_holder.current_weather.light_color
	else
		var/list/low_color_list = hex2rgb(low_color)
		var/low_r = low_color_list[1]
		var/low_g = low_color_list[2]
		var/low_b = low_color_list[3]

		var/list/high_color_list = hex2rgb(high_color)
		var/high_r = high_color_list[1]
		var/high_g = high_color_list[2]
		var/high_b = high_color_list[3]

		var/new_r = LERP(low_r, high_r, interpolate_weight)
		var/new_g = LERP(low_g, high_g, interpolate_weight)
		var/new_b = LERP(low_b, high_b, interpolate_weight)

		new_color = rgb(new_r, new_g, new_b)

	spawn(1)
		update_sun_deferred(new_brightness, new_color)


/datum/weather_holder/virgo3c
	temperature = T0C
	allowed_weather_types = list(
		WEATHER_CLEAR			= new /datum/weather/virgo3c/clear(),
		WEATHER_OVERCAST		= new /datum/weather/virgo3c/overcast(),
		WEATHER_LIGHT_SNOW		= new /datum/weather/virgo3c/light_snow(),
		WEATHER_SNOW			= new /datum/weather/virgo3c/snow(),
		WEATHER_BLIZZARD		= new /datum/weather/virgo3c/blizzard(),
		WEATHER_RAIN			= new /datum/weather/virgo3c/rain(),
		WEATHER_STORM			= new /datum/weather/virgo3c/storm(),
		WEATHER_HAIL			= new /datum/weather/virgo3c/hail(),
		WEATHER_BLOOD_MOON		= new /datum/weather/virgo3c/blood_moon(),
		WEATHER_EMBERFALL		= new /datum/weather/virgo3c/emberfall(),
		WEATHER_ASH_STORM		= new /datum/weather/virgo3c/ash_storm(),
		WEATHER_ASH_STORM_SAFE	= new /datum/weather/virgo3c/ash_storm_safe(),
		WEATHER_FALLOUT			= new /datum/weather/virgo3c/fallout()
		)
	roundstart_weather_chances = list(
		WEATHER_CLEAR		= 50,
		WEATHER_OVERCAST	= 10,
		WEATHER_RAIN		= 1,
		WEATHER_LIGHT_SNOW  = 1
		)

/datum/weather/virgo3c
	name = "virgo3c"
	temp_high = 283.15 // 10c
	temp_low = 273.15  // 0c

/datum/weather/virgo3c/clear
	name = "clear"
	transition_chances = list(
		WEATHER_CLEAR = 120,
		WEATHER_OVERCAST = 40,
		WEATHER_LIGHT_SNOW = 2,
		WEATHER_BLOOD_MOON = 2,
		WEATHER_EMBERFALL = 1)
	transition_messages = list(
		"The sky clears up.",
		"The sky is visible.",
		"The weather is calm."
		)
	sky_visible = TRUE
	observed_message = "The sky is clear."

/datum/weather/virgo3c/overcast
	name = "overcast"
	temp_high = 283.15 // 10c
	temp_low = 273.15  // 0c
	light_modifier = 0.8
	transition_chances = list(
		WEATHER_CLEAR = 50,
		WEATHER_OVERCAST = 50,
		WEATHER_RAIN = 5,
		WEATHER_LIGHT_SNOW = 5
		)
	observed_message = "It is overcast, all you can see are clouds."
	transition_messages = list(
		"All you can see above are clouds.",
		"Clouds cut off your view of the sky.",
		"It's very cloudy."
		)

/datum/weather/virgo3c/light_snow
	name = "light snow"
	icon_state = "snowfall_light"
	temp_high = 268.15 // -5c
	temp_low = 	263.15 // -10c
	light_modifier = 0.7
	transition_chances = list(
		WEATHER_LIGHT_SNOW = 25,
		WEATHER_OVERCAST = 25,
		WEATHER_SNOW = 10,
		WEATHER_RAIN = 5
		)
	observed_message = "It is snowing lightly."
	transition_messages = list(
		"Small snowflakes begin to fall from above.",
		"It begins to snow lightly.",
		)

/datum/weather/virgo3c/snow
	name = "moderate snow"
	icon_state = "snowfall_med"
	temp_high = 268.15 // -5c
	temp_low = 	263.15 // -10c
	wind_high = 2
	wind_low = 0
	light_modifier = 0.5
	flight_failure_modifier = 5
	transition_chances = list(
		WEATHER_SNOW = 25,
		WEATHER_LIGHT_SNOW = 25,
		WEATHER_BLIZZARD = 5
		)
	observed_message = "It is snowing."
	transition_messages = list(
		"It's starting to snow.",
		"The air feels much colder as snowflakes fall from above."
	)
	outdoor_sounds_type = /datum/looping_sound/weather/outside_snow
	indoor_sounds_type = /datum/looping_sound/weather/inside_snow

/datum/weather/virgo3c/blizzard
	name = "blizzard"
	icon_state = "snowfall_heavy"
	temp_high = 268.15 // -5c
	temp_low = 	263.15 // -10c
	wind_high = 4
	wind_low = 2
	light_modifier = 0.3
	flight_failure_modifier = 10
	transition_chances = list(
		WEATHER_BLIZZARD = 50,
		WEATHER_SNOW = 50
		)
	observed_message = "A blizzard blows snow everywhere."
	transition_messages = list(
		"Strong winds howl around you as a blizzard appears.",
		"It starts snowing heavily, and it feels extremly cold now."
	)
	outdoor_sounds_type = /datum/looping_sound/weather/outside_blizzard
	indoor_sounds_type = /datum/looping_sound/weather/inside_blizzard

/datum/weather/virgo3c/rain
	name = "rain"
	icon_state = "rain"
	temp_high = 283.15 // 10c
	temp_low = 273.15  // 0c
	wind_high = 2
	wind_low = 1
	light_modifier = 0.5
	effect_message = "<span class='warning'>Rain falls on you.</span>"

	transition_chances = list(
		WEATHER_OVERCAST = 25,
		WEATHER_RAIN = 25,
		WEATHER_STORM = 5,
		WEATHER_LIGHT_SNOW = 5
		)
	observed_message = "It is raining."
	transition_messages = list(
		"The sky is dark, and rain falls down upon you."
	)

/datum/weather/virgo3c/rain/process_effects()
	..()
	for(var/mob/living/L as anything in living_mob_list)
		if(L.z in holder.our_planet.expected_z_levels)
			var/turf/T = get_turf(L)
			if(!T.is_outdoors())
				continue // They're indoors, so no need to rain on them.

			// If they have an open umbrella, it'll guard from rain
			var/obj/item/weapon/melee/umbrella/U = L.get_active_hand()
			if(!istype(U) || !U.open)
				U = L.get_inactive_hand()

			if(istype(U) && U.open)
				if(show_message)
					to_chat(L, "<span class='notice'>Rain patters softly onto your umbrella.</span>")
				continue

			L.water_act(1)
			if(show_message)
				to_chat(L, effect_message)

/datum/weather/virgo3c/storm
	name = "storm"
	icon_state = "storm"
	temp_high = 283.15 // 10c
	temp_low = 273.15  // 0c
	wind_high = 4
	wind_low = 2
	light_modifier = 0.3
	flight_failure_modifier = 10
	effect_message = "<span class='warning'>Rain falls on you, drenching you in water.</span>"

	var/next_lightning_strike = 0 // world.time when lightning will strike.
	var/min_lightning_cooldown = 1 MINUTE
	var/max_lightning_cooldown = 5 MINUTE
	observed_message = "An intense storm pours down over the region."
	transition_messages = list(
		"You feel intense winds hit you as the weather takes a turn for the worst.",
		"Loud thunder is heard in the distance.",
		"A bright flash heralds the approach of a storm."
	)


	transition_chances = list(
		WEATHER_STORM = 50,
		WEATHER_RAIN = 50,
		WEATHER_BLIZZARD = 5,
		WEATHER_HAIL = 5
		)

/datum/weather/virgo3c/storm/process_effects()
	..()
	for(var/mob/living/L as anything in living_mob_list)
		if(L.z in holder.our_planet.expected_z_levels)
			var/turf/T = get_turf(L)
			if(!T.is_outdoors())
				continue // They're indoors, so no need to rain on them.

			// If they have an open umbrella, it'll guard from rain
			var/obj/item/weapon/melee/umbrella/U = L.get_active_hand()
			if(!istype(U) || !U.open)
				U = L.get_inactive_hand()

			if(istype(U) && U.open)
				if(show_message)
					to_chat(L, "<span class='notice'>Rain showers loudly onto your umbrella!</span>")
				continue


			L.water_act(2)
			if(show_message)
				to_chat(L, effect_message)

	handle_lightning()

// This gets called to do lightning periodically.
// There is a seperate function to do the actual lightning strike, so that badmins can play with it.
/datum/weather/virgo3c/storm/proc/handle_lightning()
	if(world.time < next_lightning_strike)
		return // It's too soon to strike again.
	next_lightning_strike = world.time + rand(min_lightning_cooldown, max_lightning_cooldown)
	var/turf/T = pick(holder.our_planet.planet_floors) // This has the chance to 'strike' the sky, but that might be a good thing, to scare reckless pilots.
	lightning_strike(T)

/datum/weather/virgo3c/hail
	name = "hail"
	icon_state = "hail"
	temp_high = 268.15 // -5c
	temp_low = 	263.15 // -10c
	light_modifier = 0.3
	flight_failure_modifier = 15
	timer_low_bound = 2
	timer_high_bound = 5
	effect_message = "<span class='warning'>The hail smacks into you!</span>"

	transition_chances = list(
		WEATHER_HAIL = 25,
		WEATHER_RAIN = 75
		)
	observed_message = "Ice is falling from the sky."
	transition_messages = list(
		"Ice begins to fall from the sky.",
		"It begins to hail.",
		"An intense chill is felt, and chunks of ice start to fall from the sky, towards you."
	)

/datum/weather/virgo3c/hail/process_effects()
	..()
	for(var/mob/living/carbon/H as anything in human_mob_list)
		if(H.z in holder.our_planet.expected_z_levels)
			var/turf/T = get_turf(H)
			if(!T.is_outdoors())
				continue // They're indoors, so no need to pelt them with ice.

			// If they have an open umbrella, it'll guard from hail
			var/obj/item/weapon/melee/umbrella/U = H.get_active_hand()
			if(!istype(U) || !U.open)
				U = H.get_inactive_hand()

			if(istype(U) && U.open)
				if(show_message)
					to_chat(H, "<span class='notice'>Hail patters onto your umbrella.</span>")
				continue

			var/target_zone = pick(BP_ALL)
			var/amount_blocked = H.run_armor_check(target_zone, "melee")
			var/amount_soaked = H.get_armor_soak(target_zone, "melee")

			var/damage = rand(1,3)

			if(amount_blocked >= 30)
				continue // No need to apply damage. Hardhats are 30. They should probably protect you from hail on your head.
				//Voidsuits are likewise 40, and riot, 80. Clothes are all less than 30.

			if(amount_soaked >= damage)
				continue // No need to apply damage.

			H.apply_damage(damage, BRUTE, target_zone, amount_blocked, amount_soaked, used_weapon = "hail")
			if(show_message)
				to_chat(H, effect_message)

/datum/weather/virgo3c/blood_moon
	name = "blood moon"
	light_modifier = 0.5
	light_color = "#FF0000"
	temp_high = 283.15 // 10c
	temp_low = 273.15  // 0c
	flight_failure_modifier = 25
	transition_chances = list(
		WEATHER_BLOOD_MOON = 25,
		WEATHER_CLEAR = 75
		)
	observed_message = "Everything is red. Something really ominous is going on."
	transition_messages = list(
		"The sky turns blood red!"
	)
	outdoor_sounds_type = /datum/looping_sound/weather/wind
	indoor_sounds_type = /datum/looping_sound/weather/wind/indoors

// Ash and embers fall forever, such as from a volcano or something.
/datum/weather/virgo3c/emberfall
	name = "emberfall"
	icon_state = "ashfall_light"
	light_modifier = 0.7
	light_color = "#880000"
	temp_high = 293.15	// 20c
	temp_low = 283.15	// 10c
	flight_failure_modifier = 20
	transition_chances = list(
		WEATHER_ASH_STORM = 100
		)
	observed_message = "Soot, ash, and embers float down from above."
	transition_messages = list(
		"Gentle embers waft down around you like black snow. A wall of dark, glowing ash approaches in the distance..."
	)
	outdoor_sounds_type = /datum/looping_sound/weather/wind
	indoor_sounds_type = /datum/looping_sound/weather/wind/indoors

// Like the above but a lot more harmful.
/datum/weather/virgo3c/ash_storm
	name = "ash storm"
	icon_state = "ashfall_heavy"
	light_modifier = 0.1
	light_color = "#FF0000"
	temp_high = 313.15	// 40c
	temp_low = 303.15	// 30c
	wind_high = 6
	wind_low = 3
	flight_failure_modifier = 50
	transition_chances = list(
		WEATHER_ASH_STORM = 5,
		WEATHER_CLEAR = 95
		)
	observed_message = "All that can be seen is black smoldering ash."
	transition_messages = list(
		"Smoldering clouds of scorching ash billow down around you!"
	)
	// Lets recycle.
	outdoor_sounds_type = /datum/looping_sound/weather/outside_blizzard
	indoor_sounds_type = /datum/looping_sound/weather/inside_blizzard

/datum/weather/virgo3c/ash_storm/process_effects()
	..()
	for(var/mob/living/L as anything in living_mob_list)
		if(L.z in holder.our_planet.expected_z_levels)
			var/turf/T = get_turf(L)
			if(!T.is_outdoors())
				continue // They're indoors, so no need to burn them with ash.
			else if (isanimal(L))
				continue    //Don't murder the wildlife, they live here it's fine

			L.inflict_heat_damage(1)
			to_chat(L, "<span class='warning'>Smoldering ash singes you!</span>")



//A non-lethal variant of the ash_storm. Stays on indefinitely.
/datum/weather/virgo3c/ash_storm_safe
	name = "light ash storm"
	icon_state = "ashfall_moderate"
	light_modifier = 0.1
	light_color = "#FF0000"
	temp_high = 313.15	// 40c
	temp_low = 303.15	// 30c
	wind_high = 6
	wind_low = 3
	flight_failure_modifier = 50
	transition_chances = list(
		WEATHER_ASH_STORM_SAFE = 100
		)
	observed_message = "All that can be seen is black smoldering ash."
	transition_messages = list(
		"Smoldering clouds of scorching ash billow down around you!"
	)
	// Lets recycle.
	outdoor_sounds_type = /datum/looping_sound/weather/outside_blizzard
	indoor_sounds_type = /datum/looping_sound/weather/inside_blizzard

// Totally radical.
/datum/weather/virgo3c/fallout
	name = "fallout"
	icon_state = "fallout"
	light_modifier = 0.7
	light_color = "#CCFFCC"
	flight_failure_modifier = 30
	transition_chances = list(
		WEATHER_FALLOUT = 100
		)
	observed_message = "Radioactive soot and ash rains down from the heavens."
	transition_messages = list(
		"Radioactive soot and ash start to float down around you, contaminating whatever they touch."
	)
	outdoor_sounds_type = /datum/looping_sound/weather/wind
	indoor_sounds_type = /datum/looping_sound/weather/wind/indoors

	// How much radiation a mob gets while on an outside tile.
	var/direct_rad_low = RAD_LEVEL_LOW
	var/direct_rad_high = RAD_LEVEL_MODERATE

	// How much radiation is bursted onto a random tile near a mob.
	var/fallout_rad_low = RAD_LEVEL_HIGH
	var/fallout_rad_high = RAD_LEVEL_VERY_HIGH

/datum/weather/virgo3c/fallout/process_effects()
	..()
	for(var/mob/living/L as anything in living_mob_list)
		if(L.z in holder.our_planet.expected_z_levels)
			irradiate_nearby_turf(L)
			var/turf/T = get_turf(L)
			if(!T.is_outdoors())
				continue // They're indoors, so no need to irradiate them with fallout.

			L.rad_act(rand(direct_rad_low, direct_rad_high))

// This makes random tiles near people radioactive for awhile.
// Tiles far away from people are left alone, for performance.
/datum/weather/virgo3c/fallout/proc/irradiate_nearby_turf(mob/living/L)
	if(!istype(L))
		return
	var/list/turfs = RANGE_TURFS(world.view, L)
	var/turf/T = pick(turfs) // We get one try per tick.
	if(!istype(T))
		return
	if(T.is_outdoors())
		SSradiation.radiate(T, rand(fallout_rad_low, fallout_rad_high))

/turf/unsimulated/wall/planetary/virgo3c
	name = "impassable rock"
	desc = "It's quite impassable"
	icon = 'icons/turf/walls.dmi'
	icon_state = "rock-dark"
	alpha = 0xFF
	VIRGO3C_SET_ATMOS

VIRGO3C_TURF_CREATE(/turf/simulated/floor/outdoors/newdirt)
VIRGO3C_TURF_CREATE(/turf/simulated/floor/outdoors/newdirt_nograss)
VIRGO3C_TURF_CREATE(/turf/simulated/floor/outdoors/sidewalk)
VIRGO3C_TURF_CREATE(/turf/simulated/floor/outdoors/sidewalk/side)
VIRGO3C_TURF_CREATE(/turf/simulated/floor/outdoors/sidewalk/slab)
VIRGO3C_TURF_CREATE(/turf/simulated/floor/water)
VIRGO3C_TURF_CREATE(/turf/simulated/floor/water/deep)
VIRGO3C_TURF_CREATE(/turf/simulated/floor/tiled)
VIRGO3C_TURF_CREATE(/turf/simulated/floor/reinforced)
VIRGO3C_TURF_CREATE(/turf/simulated/floor/glass/reinforced)
VIRGO3C_TURF_CREATE(/turf/simulated/floor/tiled/dark)
VIRGO3C_TURF_CREATE(/turf/simulated/mineral)
VIRGO3C_TURF_CREATE(/turf/simulated/mineral/ignore_cavegen)
VIRGO3C_TURF_CREATE(/turf/simulated/floor)
VIRGO3C_TURF_CREATE(/turf/simulated/floor/wood)
VIRGO3C_TURF_CREATE(/turf/simulated/floor/wood/sif)
VIRGO3C_TURF_CREATE(/turf/simulated/floor/beach/sand)
VIRGO3C_TURF_CREATE(/turf/simulated/floor/tiled/asteroid_steel/outdoors)



/turf/simulated/open/virgo3c
	VIRGO3C_SET_ATMOS

/turf/simulated/open/virgo3c/Initialize(mapload)
	. = ..()
	if(is_outdoors())
		SSplanets.addTurf(src)

/turf/simulated/mineral/cave/virgo3c
	VIRGO3C_SET_ATMOS
	outdoors = 0

/turf/simulated/mineral/floor/virgo3c
	VIRGO3C_SET_ATMOS
	outdoors = 0

/turf/simulated/mineral/floor/ignore_mapgen/virgo3c
	VIRGO3C_SET_ATMOS
	outdoors = 0

/turf/simulated/floor/outdoors/grass/virgo3c
	VIRGO3C_SET_ATMOS

	grass_types = list(
		/obj/structure/flora/ausbushes/sparsegrass = 50,
		/obj/structure/flora/ausbushes/fullgrass = 50,
		/obj/structure/flora/ausbushes/brflowers = 1,
		/obj/structure/flora/ausbushes/ppflowers = 1,
		/obj/structure/flora/ausbushes/ywflowers = 1
		)

/turf/simulated/floor/outdoors/grass/forest/virgo3c
	VIRGO3C_SET_ATMOS
	var/tree_chance = 5

	var/animal_chance = 0.5
	var/animal_types = list(
		/mob/living/simple_mob/vore/alienanimals/teppi = 10,
		/mob/living/simple_mob/vore/alienanimals/teppi/mutant = 1,
		/mob/living/simple_mob/vore/redpanda = 40,
		/mob/living/simple_mob/vore/redpanda/fae = 2,
		/mob/living/simple_mob/vore/sheep = 20,
		/mob/living/simple_mob/vore/rabbit/black = 20,
		/mob/living/simple_mob/vore/rabbit/white = 20,
		/mob/living/simple_mob/vore/rabbit/brown = 20,
		/mob/living/simple_mob/vore/leopardmander = 2,
		/mob/living/simple_mob/vore/horse/big = 10,
		/mob/living/simple_mob/vore/bigdragon/friendly = 1,
		/mob/living/simple_mob/vore/alienanimals/dustjumper = 20
		)


/turf/simulated/floor/outdoors/grass/forest/virgo3c/Initialize()
	if(tree_chance && prob(tree_chance) && !check_density())
		new /obj/structure/flora/tree/bigtree(src)

	if(animal_chance && prob(animal_chance) && !check_density())
		var/animal_type = pickweight(animal_types)
		new animal_type(src)

	. = ..()

/turf/simulated/floor/outdoors/grass/forest/virgo3c/notrees
	tree_chance = 0
