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
	color = "#3e5064"

/obj/machinery/light/small/fairylights/broken()
	return

/obj/machinery/light/small/fairylights/flicker
	auto_flicker = TRUE

/obj/machinery/light/small/fairylights/update_icon()

	switch(status)
		if(LIGHT_OK)
			if(shows_alerts && current_alert && on)
				icon_state = "[base_state]-alert-[current_alert]"
				add_light_overlay(FALSE)
			else
				icon_state = "[base_state][on]"
				add_light_overlay()
		if(LIGHT_EMPTY)
			icon_state = "[base_state]-empty"
			on = 0
			remove_light_overlay()
		if(LIGHT_BURNED)
			icon_state = "[base_state]-burned"
			on = 0
			remove_light_overlay()
		if(LIGHT_BROKEN)
			icon_state = "[base_state]-broken"
			on = 0
			remove_light_overlay()
	return

/obj/machinery/light
	var/image/overlay_layer = null
	var/overlay_color = null

/obj/machinery/light/proc/add_light_overlay(do_color = TRUE)
	remove_light_overlay()
	overlay_layer = image(icon, "[base_state]-overlay")
	overlay_layer.appearance_flags = RESET_COLOR|KEEP_APART
	if(overlay_color && do_color)
		overlay_layer.color = overlay_color
	overlay_layer.plane = PLANE_LIGHTING_ABOVE
	add_overlay(overlay_layer)

/obj/machinery/light/proc/remove_light_overlay()
	cut_overlay(overlay_layer)
	qdel(overlay_layer)
	overlay_layer = null


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
