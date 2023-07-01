/obj/effect/fake_sun
	name = "fake sun"
	desc = "Deletes itself, but first updates all the lighting on outdoor turfs."
	icon = 'icons/effects/effects_vr.dmi'
	icon_state = "fakesun"
	invisibility = INVISIBILITY_ABSTRACT
	var/atom/movable/sun_visuals/sun
	var/family = null	//Allows multipe maps that are THEORETICALLY connected to use the same settings when not in a connected Z stack
	var/shared_settings	//Automatically set if using the family var
	var/static/world_suns = list()	//List of all the fake_suns in the world, used for checking for family members

	var/list/possible_light_setups = list(
		list(
			"brightness" = 6.0,
			"color" = "#abfff7"
		),
		list(
			"brightness" = 4.0,
			"color" = "#F4EA55"
		),
		list(
			"brightness" = 2.5,
			"color" = "#EE9AC6"
		),
		list(
			"brightness" = 1.5,
			"color" = "#F07AD8"
		),
		list(
			"brightness" = 1.5,
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
			"brightness" = 1.0,
			"color" = "#A3A291"
		),
		list(
			"brightness" = 1.0,
			"color" = "#F07AD8"
		),
		list(
			"brightness" = 1.0,
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

/obj/effect/fake_sun/New(loc, ...)
	. = ..()
	world_suns += src

/obj/effect/fake_sun/Initialize()
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/effect/fake_sun/LateInitialize()
	. = ..()
	var/list/choice
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

	sun.set_color(choice["color"])
	sun.set_alpha(round(CLAMP01(choice["brightness"])*255,1))

	for(var/turf/T as anything in turfs_to_use)
		sun.apply_to_turf(T)

/obj/effect/fake_sun/warm
	name = "warm fake sun"
	desc = "Deletes itself, but first updates all the lighting on outdoor turfs to warm colors."

	possible_light_setups = list(

		list(
			"brightness" = 6.0,
			"color" = "#E9FFB8"
		),

		list(
			"brightness" = 4.0,
			"color" = "#F4EA55"
		),
		list(
			"brightness" = 4.0,
			"color" = "#F07AD8"
		),
		list(
			"brightness" = 4.0,
			"color" = "#f3932d"
		)

	)

/obj/effect/fake_sun/cool
	name = "fake sun"
	desc = "Deletes itself, but first updates all the lighting on outdoor turfs to cool colors."
	possible_light_setups = list(

		list(
			"brightness" = 6.0,
			"color" = "#abfff7"
		),
		list(
			"brightness" = 4.0,
			"color" = "#2e30c9"
		),
		list(
			"brightness" = 1.0,
			"color" = "#61AEF3"
		),
		list(
			"brightness" = 1.0,
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
