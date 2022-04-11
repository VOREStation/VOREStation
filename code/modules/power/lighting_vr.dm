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
