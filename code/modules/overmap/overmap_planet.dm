/obj/effect/overmap/visitable/planet
	name = "planet"
	icon_state = "lush"
	in_space = 0

	unknown_name = "unknown planet"
	unknown_state = "planet"

	var/datum/gas_mixture/atmosphere

	var/atmosphere_color = "FFFFFF"
	var/mountain_color = "#735555"
	var/surface_color = "#304A35"
	var/water_color = "#436499"
	var/has_rings = FALSE // set to true to get rings
	var/icecaps = null // Iconstate in icons/skybox/planet.dmi for the planet's icecaps
	var/ice_color = "E6F2F6"
	var/ring_color
	var/skybox_offset_x = 0
	var/skybox_offset_y = 0

/obj/effect/overmap/visitable/planet/Initialize()
	. = ..()

/obj/effect/overmap/visitable/planet/get_skybox_representation()
	var/image/skybox_image = image('icons/skybox/planet.dmi', "")

	skybox_image.add_overlay(get_base_image())

//	for(var/datum/exoplanet_theme/theme in themes)
//		skybox_image.add_overlay(theme.get_planet_image_extra())

	if(mountain_color)
		var/image/mountains = image('icons/skybox/planet.dmi', "mountains")
		mountains.color = mountain_color
		mountains.appearance_flags = PIXEL_SCALE
		skybox_image.add_overlay(mountains)

	if(water_color)
		var/image/water = image('icons/skybox/planet.dmi', "water")
		water.color = water_color
		water.appearance_flags = PIXEL_SCALE
//		water.transform = water.transform.Turn(rand(0,360))
		skybox_image.add_overlay(water)

	if(icecaps)
		var/image/ice = image('icons/skybox/planet.dmi', icecaps)
		ice.color = ice_color
		ice.appearance_flags = PIXEL_SCALE
		skybox_image.add_overlay(ice)

	if(atmosphere && atmosphere.return_pressure() > SOUND_MINIMUM_PRESSURE)

		var/atmo_color = get_atmosphere_color()
		if(!atmo_color)
			atmo_color = COLOR_WHITE

		var/image/clouds = image('icons/skybox/planet.dmi', "weak_clouds")

		if(water_color)
			clouds.add_overlay(image('icons/skybox/planet.dmi', "clouds"))

		clouds.color = atmo_color
		skybox_image.add_overlay(clouds)

		var/image/atmo = image('icons/skybox/planet.dmi', "atmoring")
		skybox_image.underlays += atmo

	var/image/shadow = image('icons/skybox/planet.dmi', "shadow")
	shadow.blend_mode = BLEND_MULTIPLY
	skybox_image.add_overlay(shadow)

	var/image/light = image('icons/skybox/planet.dmi', "lightrim")
	skybox_image.add_overlay(light)

	if(has_rings)
		var/image/rings = image('icons/skybox/planet_rings.dmi')
		rings.icon_state = pick("sparse", "dense")
		if(!ring_color)
			rings.color = pick("#f0fcff", "#dcc4ad", "#d1dcad", "#adb8dc")
		else
			rings.color = ring_color
		rings.pixel_x = -128
		rings.pixel_y = -128
		skybox_image.add_overlay(rings)

	skybox_image.pixel_x = rand(0,64)    + skybox_offset_x
	skybox_image.pixel_y = rand(128,256) + skybox_offset_y
	skybox_image.appearance_flags = RESET_COLOR
	return skybox_image

/obj/effect/overmap/visitable/planet/proc/get_base_image()
	var/image/base = image('icons/skybox/planet.dmi', "base")
	base.color = get_surface_color()
	return base

/obj/effect/overmap/visitable/planet/proc/get_surface_color()
	return surface_color

/obj/effect/overmap/visitable/planet/proc/get_atmosphere_color()
	return atmosphere_color
