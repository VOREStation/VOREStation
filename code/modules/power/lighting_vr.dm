// I hate the way macros look stupid standing near lights. I don't care how absurd this looks.

/obj/machinery/light_construct
	layer = BELOW_MOB_LAYER

/obj/machinery/light
	layer = BELOW_MOB_LAYER

//Vorestation addition, to override the New() proc further below, since this is a lamp.
/obj/machinery/light/flamp/New()
	..()
	layer = initial(layer)

// create a new lighting fixture
/obj/machinery/light/New()
	..()
	//Vorestation addition, so large mobs stop looking stupid in front of lights.
	if (dir == SOUTH) // Lights are backwards, SOUTH lights face north (they are on south wall)
		layer = ABOVE_MOB_LAYER

// Wall tube lights
/obj/item/weapon/light/tube
	brightness_range = 6
	brightness_power = 1

	nightshift_range = 6
	nightshift_power = 0.45

// Big tubes, unused I think
/obj/item/weapon/light/tube/large
	brightness_range = 8
	brightness_power = 2

	nightshift_range = 8
	nightshift_power = 1

// Small wall lights
/obj/item/weapon/light/bulb
	brightness_range = 4
	brightness_power = 1

	nightshift_range = 4
	nightshift_power = 0.45

// Floor lamps
/obj/item/weapon/light/bulb/large
	brightness_range = 6
	brightness_power = 1

	nightshift_range = 6
	nightshift_power = 0.45

// Floor tube lights

/obj/machinery/light/floortube
	icon_state = "floortube1"
	base_state = "floortube"
	desc = "A tube light set into a floor fixture."
	shows_alerts = FALSE
	plane = TURF_PLANE
	layer = ABOVE_TURF_LAYER
	construct_type = /obj/machinery/light_construct/floortube
	overlay_above_everything = FALSE

/obj/machinery/light/floortube/flicker
	auto_flicker = TRUE

/obj/machinery/light_construct/floortube
	name = "floor light fixture frame"
	desc = "A floor light fixture under construction."
	icon = 'icons/obj/lighting_vr.dmi'
	icon_state = "floortube-construct-stage1"
	stage = 1
	anchored = FALSE
	fixture_type = /obj/machinery/light/floortube
	sheets_refunded = 2

/obj/machinery/light_construct/floortube/verb/rotate_clockwise()
    set name = "Rotate Fixture Clockwise"
    set category = "Object"
    set src in view(1)

    if (usr.stat || usr.restrained() || anchored)
        return

    src.set_dir(turn(src.dir, 270))

/obj/machinery/light_construct/floortube/verb/rotate_counterclockwise()
    set name = "Rotate Fixture Counter-Clockwise"
    set category = "Object"
    set src in view(1)

    if (usr.stat || usr.restrained() || anchored)
        return

    src.set_dir(turn(src.dir, 90))

/obj/machinery/light_construct/floortube/update_icon()
	switch(stage)
		if(1)
			icon_state = "floortube-construct-stage1"
		if(2)
			icon_state = "floortube-construct-stage2"
		if(3)
			icon_state = "floortube-empty"

// Big Flamp

/obj/machinery/light/bigfloorlamp
	icon = 'icons/obj/lighting32x64.dmi'
	icon_state = "big_flamp1"
	base_state = "big_flamp"
	desc = "A set of tube lights on a raised, solid fixture"
	shows_alerts = FALSE
	density = TRUE
	anchored = TRUE
	plane = MOB_PLANE
	layer = ABOVE_MOB_LAYER
	construct_type = /obj/machinery/light_construct/bigfloorlamp
	overlay_above_everything = TRUE

/obj/machinery/light/bigfloorlamp/flicker
	auto_flicker = TRUE

/obj/machinery/light_construct/bigfloorlamp
	name = "big floor light fixture frame"
	desc = "A big floor light fixture under construction."
	icon = 'icons/obj/lighting32x64.dmi'
	icon_state = "big_flamp-construct-stage1"
	stage = 1
	anchored = FALSE
	fixture_type = /obj/machinery/light/bigfloorlamp
	sheets_refunded = 3

/obj/machinery/light_construct/bigfloorlamp/update_icon()
	switch(stage)
		if(1)
			icon_state = "big_flamp-construct-stage1"
		if(2)
			icon_state = "big_flamp-construct-stage2"
		if(3)
			icon_state = "big_flamp-empty"

// Fairy lights

/obj/item/weapon/light/bulb/smol
	brightness_range = 1
	brightness_power = 0.5

	nightshift_range = 1
	nightshift_power = 0.25


/obj/machinery/light/small/fairylights
	icon = 'icons/obj/lighting_vr.dmi'
	icon_state = "fairy_lights1"
	base_state = "fairy_lights"
	desc = "A set of lights on a long string of wire, anchored to the walls."
	light_type = /obj/item/weapon/light/bulb/smol
	shows_alerts = FALSE
	anchored = TRUE
	plane = ABOVE_MOB_PLANE
	layer = ABOVE_MOB_LAYER
	construct_type = null
	overlay_color = LIGHT_COLOR_INCANDESCENT_BULB
	overlay_above_everything = TRUE
	color = "#3e5064"

/obj/machinery/light/small/fairylights/broken()
	return

/obj/machinery/light/small/fairylights/flicker
	auto_flicker = TRUE

/obj/machinery/light
	var/image/overlay_layer = null
	var/overlay_above_everything = TRUE

/obj/machinery/light/proc/add_light_overlay(do_color = TRUE, provided_state = null)
	remove_light_overlay()
	if(provided_state)
		overlay_layer = image(icon, "[provided_state]-overlay")
	else
		overlay_layer = image(icon, "[base_state]-overlay")
	overlay_layer.appearance_flags = RESET_COLOR|KEEP_APART
	if(overlay_color && do_color)
		overlay_layer.color = overlay_color
	if(overlay_above_everything)
		overlay_layer.plane = PLANE_LIGHTING_ABOVE
	else
		overlay_layer.plane = PLANE_EMISSIVE

	add_overlay(overlay_layer)

/obj/machinery/light/proc/remove_light_overlay()
	if(overlay_layer)
		cut_overlay(overlay_layer)
		qdel(overlay_layer)
		overlay_layer = null

/obj/machinery/light/lamppost
	icon = 'icons/obj/lighting32x64.dmi'
	icon_state = "lamppost1"
	base_state = "lamppost"
	desc = "A tall lampost that extends over an area"
	light_type = /obj/item/weapon/light/bulb
	shows_alerts = FALSE
	anchored = TRUE
	plane = ABOVE_MOB_PLANE
	layer = ABOVE_MOB_LAYER
	construct_type = null
	overlay_color = LIGHT_COLOR_INCANDESCENT_BULB
	overlay_above_everything = TRUE

/*
/obj/machinery/light_construct/bigfloorlamp
	name = "big floor light fixture frame"
	desc = "A big floor light fixture under construction."
	icon = 'icons/obj/lighting32x64.dmi'
	icon_state = "big_flamp-construct-stage1"
	stage = 1
	anchored = FALSE
	fixture_type = /obj/machinery/light/bigfloorlamp
	sheets_refunded = 1

/obj/machinery/light_construct/bigfloorlamp/update_icon()
	switch(stage)
		if(1)
			icon_state = "big_flamp-construct-stage1"
		if(2)
			icon_state = "big_flamp-construct-stage2"
		if(3)
			icon_state = "big_flamp-empty"
*/

/obj/item/weapon/light/bulb/torch
	brightness_range = 6
	color = "#fabf87"
	brightness_color = "#fabf87"
	init_brightness_range = 6

/obj/machinery/light/small/torch
	icon = 'icons/obj/lighting_vr.dmi'
	name = "wall torch"
	icon_state = "torch1"
	base_state = "torch"
	desc = "A small torch held in a wall sconce."
	light_type = /obj/item/weapon/light/bulb/torch
	shows_alerts = FALSE
	anchored = TRUE
	plane = ABOVE_MOB_PLANE
	layer = ABOVE_MOB_LAYER
	construct_type = null
	overlay_color = LIGHT_COLOR_INCANDESCENT_BULB
	overlay_above_everything = TRUE

/obj/machinery/light/small/torch/attackby()
	return

/obj/machinery/light/broken
	icon_state = "tube-broken"

/obj/machinery/light/broken/Initialize()
	. = ..()
	broken()

/obj/machinery/light/broken/small
	icon_state = "bulb-broken"

/obj/machinery/light/broken/small/Initialize()
	. = ..()
	broken()
