
/datum/planet_sunlight_handler
	var/redint = 0
	var/greenint = 0
	var/blueint = 0
	var/red = 0.0
	var/green = 0.0
	var/blue = 0.0
	var/redshadeint = 0
	var/greenshadeint = 0
	var/blueshadeint = 0
	var/redshade = 0.0
	var/greenshade = 0.0
	var/blueshade = 0.0
	var/cache_r = 0.0
	var/cache_g = 0.0
	var/cache_b = 0.0
	var/cache_r_shade = 0.0
	var/cache_g_shade = 0.0
	var/cache_b_shade = 0.0
	var/maxlum = 0.0
	var/maxlumshade = 0.0
	var/datum/simple_sun/sun
	var/atom/movable/sun_vis_simple/vis_overhead
	var/atom/movable/sun_vis_simple/vis_shade
	var/list/shandlers = list()

/datum/planet_sunlight_handler/New(var/planet)
	. = ..()
	var/datum/planet/P = planet
	var/datum/simple_sun/S = planet
	if(istype(P))
		sun = new /datum/simple_sun/planetary(P)

	if(istype(S))
		sun = S

	vis_overhead = new(null)
	vis_shade = new(null)

/datum/planet_sunlight_handler/proc/update_sun()
	sun.update()
	var/brightness = sun.brightness * SSlighting.sun_mult
	var/list/color = hex2rgb(sun.color)
	red = brightness * (color[1] / 255.0)
	green = brightness * (color[2] / 255.0)
	blue = brightness * (color[3] / 255.0)
	redshade = 0.6 * red
	greenshade = 0.6 * green
	blueshade = 0.6 * blue
	redint = round(red * 255)
	greenint = round(green * 255)
	blueint = round(blue * 255)
	redshadeint = round(redshade * 255)
	greenshadeint = round(greenshade * 255)
	blueshadeint = round(blueshade * 255)
	vis_overhead.color = rgb(redint,greenint,blueint)
	vis_shade.color = rgb(redshadeint,greenshadeint,blueshadeint)

	var/largest_color_luminosity = max(red, green, blue) // Scale it so one of them is the strongest lum, if it is above 1.
	maxlum = largest_color_luminosity
	. = 1 // factor
	if (largest_color_luminosity > 1)
		. = 1 / largest_color_luminosity

	#if LIGHTING_SOFT_THRESHOLD != 0
	else if (largest_color_luminosity < LIGHTING_SOFT_THRESHOLD)
		. = 0 // 0 means soft lighting.

	cache_r  = round(red * ., LIGHTING_ROUND_VALUE) || LIGHTING_SOFT_THRESHOLD
	cache_g  = round(green * ., LIGHTING_ROUND_VALUE) || LIGHTING_SOFT_THRESHOLD
	cache_b  = round(blue * ., LIGHTING_ROUND_VALUE) || LIGHTING_SOFT_THRESHOLD
	#else
	cache_r  = round(red * ., LIGHTING_ROUND_VALUE)
	cache_g  = round(green * ., LIGHTING_ROUND_VALUE)
	cache_b  = round(blue * ., LIGHTING_ROUND_VALUE)
	#endif

	largest_color_luminosity = max(redshade, greenshade, blueshade) // Scale it so one of them is the strongest lum, if it is above 1.
	maxlumshade = largest_color_luminosity
	. = 1 // factor
	if (largest_color_luminosity > 1)
		. = 1 / largest_color_luminosity

	#if LIGHTING_SOFT_THRESHOLD != 0
	else if (largest_color_luminosity < LIGHTING_SOFT_THRESHOLD)
		. = 0 // 0 means soft lighting.

	cache_r_shade  = round(redshade * ., LIGHTING_ROUND_VALUE) || LIGHTING_SOFT_THRESHOLD
	cache_g_shade  = round(greenshade * ., LIGHTING_ROUND_VALUE) || LIGHTING_SOFT_THRESHOLD
	cache_b_shade  = round(blueshade * ., LIGHTING_ROUND_VALUE) || LIGHTING_SOFT_THRESHOLD
	#else
	cache_r_shade  = round(redshade * ., LIGHTING_ROUND_VALUE)
	cache_g_shade  = round(greenshade * ., LIGHTING_ROUND_VALUE)
	cache_b_shade  = round(blueshade * ., LIGHTING_ROUND_VALUE)
	#endif


//Visuals we use to remove need to update overlays for tiles that have nothing but sunlight
/atom/movable/sun_vis_simple
	icon = 'icons/effects/effects.dmi'
	icon_state = "white"
	plane = PLANE_LIGHTING
	mouse_opacity = 0
	alpha = 255
	color = "#FFFFFF"

//A simplified datum for controlling the sun color/brightness
//This allows for the sunlight system to be used outside of only planets
/datum/simple_sun
	var/brightness = 1.0
	var/color = "#FFFFFF"

//Called from planet_sunlight_handler.update_sun()
//Should update brightness and color values
/datum/simple_sun/proc/update()
	return //Do nothing. This is meant to be overridden.

/datum/simple_sun/planetary
	var/datum/sun_holder/sun

/datum/simple_sun/planetary/New(var/datum/planet/planet)
	sun = planet.sun_holder

/datum/simple_sun/planetary/update()
	. = ..()
	brightness = sun.our_brightness
	color = sun.our_color
