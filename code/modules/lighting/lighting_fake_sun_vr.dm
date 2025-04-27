var/static/list/fake_sunlight_zs = list()

/obj/effect/fake_sun
	name = "fake sun"
	desc = "Deletes itself, but first updates all the lighting on outdoor turfs."
	icon = 'icons/effects/effects_vr.dmi'
	icon_state = "fakesun"
	invisibility = INVISIBILITY_ABSTRACT
	var/atom/movable/sun_visuals/sun
	var/atom/movable/weather_visuals/visuals
	var/family = null	//Allows multipe maps that are THEORETICALLY connected to use the same settings when not in a connected Z stack
	var/shared_settings	//Automatically set if using the family var
	var/static/world_suns = list()	//List of all the fake_suns in the world, used for checking for family members
	var/list/choice

	var/do_sun = TRUE
	var/do_weather = FALSE
	var/advanced_lighting = FALSE

	var/list/possible_light_setups = list(
		list(
			"brightness" = 1,
			"color" = "#abfff7"
		),
		list(
			"brightness" = 1,
			"color" = "#F4EA55"
		),
		list(
			"brightness" = 1,
			"color" = "#EE9AC6"
		),
		list(
			"brightness" = 1,
			"color" = "#F07AD8"
		),
		list(
			"brightness" = 1,
			"color" = "#61AEF3"
		),
		list(
			"brightness" = 1,
			"color" = "#f3932d"
		),
		list(
			"brightness" = 1,
			"color" = "#631E8A"
		),
		list(
			"brightness" = 1,
			"color" = "#A3A291"
		),
		list(
			"brightness" = 1,
			"color" = "#F07AD8"
		),
		list(
			"brightness" = 1,
			"color" = "#61AEF3"
		),
		list(
			"brightness" = 0.7,
			"color" = "#f3932d"
		),
		list(
			"brightness" = 0.5,
			"color" = "#631E8A"
		),
		list(
			"brightness" = 0.3,
			"color" = "#253682"
		),
		list(
			"brightness" = 0.1,
			"color" = "#27024B"
		),
		list(
			"brightness" = 0.1,
			"color" = "#9AEAEE"
		),
		list(
			"brightness" = 0.1,
			"color" = "#B92B00"
		),
		list(
			"brightness" = 0,
			"color" = "#000000"
		)

	)

	var/weather_visuals_icon = 'icons/effects/weather.dmi'
	var/weather_visuals_icon_state = null

/obj/effect/fake_sun/Initialize(mapload)
	. = ..()
	world_suns += src
	if(!advanced_lighting)
		return INITIALIZE_HINT_LATELOAD
	do_sun = FALSE

	//Copied code
	if(family)	//Allows one to make multiple fake_suns to use the same settings
		for(var/obj/effect/fake_sun/l in world_suns)	//check all the suns that exist
			if(l.family == family && l.shared_settings)	//do you have settings we need?
				choice = l.shared_settings
				break
	if(!choice)	//We didn't get anything from our family, let's pick something
		choice = pick(possible_light_setups)
		if(family)	//Let's pass our settings on to our family
			shared_settings = choice
	if(choice["brightness"] <= LIGHTING_SOFT_THRESHOLD) // dark!
		return
	//Copied code end

	var/datum/simple_sun/Ssun = new()
	Ssun.brightness = CLAMP01(choice["brightness"])
	Ssun.color = choice["color"]
	var/datum/planet_sunlight_handler/pshandler = new(Ssun)
	if(z > SSlighting.z_to_pshandler.len)
		SSlighting.z_to_pshandler.len = z
	SSlighting.z_to_pshandler[z] = pshandler
	SSlighting.update_sunlight(pshandler) //Queue an update for when it starts running
	return INITIALIZE_HINT_LATELOAD

/obj/effect/fake_sun/LateInitialize()
	if(family)	//Allows one to make multiple fake_suns to use the same settings
		for(var/obj/effect/fake_sun/l in world_suns)	//check all the suns that exist
			if(l.family == family && l.shared_settings)	//do you have settings we need?
				choice = l.shared_settings
				break
	if(!choice)	//We didn't get anything from our family, let's pick something
		choice = pick(possible_light_setups)
		if(family)	//Let's pass our settings on to our family
			shared_settings = choice
	if(choice["brightness"] <= LIGHTING_SOFT_THRESHOLD) // dark!
		return

	var/list/zees = GetConnectedZlevels()
	var/min = z
	var/max = z
	for(var/zee in zees)
		if(zee < min)
			min = z
		if(zee > max)
			max = z

	var/list/all_turfs = block(locate(1, 1, min), locate(world.maxx, world.maxy, max))
	var/list/turfs_to_use = list()
	for(var/turf/T as anything in all_turfs)
		if(T.is_outdoors())
			turfs_to_use += T

	if(!turfs_to_use.len)
		warning("Fake sun placed on a level where it can't find any outdoor turfs to color at [x],[y],[z].")
		return

	sun = new(null)

	visuals = new(null)
	visuals.icon = weather_visuals_icon
	visuals.icon_state = weather_visuals_icon_state

	sun.set_color(choice["color"])
	sun.set_alpha(round(CLAMP01(choice["brightness"])*255,1))

	if(do_sun)
		fake_sunlight_zs |= z
		for(var/turf/T as anything in turfs_to_use)
			sun.apply_to_turf(T)

	if(do_weather)
		for(var/turf/T as anything in turfs_to_use)
			T.vis_contents += visuals

/obj/effect/fake_sun/warm
	name = "warm fake sun"
	desc = "Deletes itself, but first updates all the lighting on outdoor turfs to warm colors."

	possible_light_setups = list(

		list(
			"brightness" = 1,
			"color" = "#E9FFB8"
		),

		list(
			"brightness" = 1,
			"color" = "#F4EA55"
		),
		list(
			"brightness" = 1,
			"color" = "#F07AD8"
		),
		list(
			"brightness" = 1,
			"color" = "#f3932d"
		)

	)

/obj/effect/fake_sun/cool
	name = "fake sun"
	desc = "Deletes itself, but first updates all the lighting on outdoor turfs to cool colors."
	possible_light_setups = list(

		list(
			"brightness" = 1,
			"color" = "#abfff7"
		),
		list(
			"brightness" = 1,
			"color" = "#2e30c9"
		),
		list(
			"brightness" = 1,
			"color" = "#61AEF3"
		),
		list(
			"brightness" = 1,
			"color" = "#61ddf3"
		),
		list(
			"brightness" = 0.3,
			"color" = "#253682"
		),
		list(
			"brightness" = 0.1,
			"color" = "#27024B"
		)
	)

/obj/effect/fake_sun/underwater
	do_weather = TRUE
	weather_visuals_icon = 'icons/effects/weather.dmi'
	weather_visuals_icon_state = "underwater"
	possible_light_setups = list(
		list(
			"brightness" = 1,
			"color" = "#1c49ff"
		)
	)
