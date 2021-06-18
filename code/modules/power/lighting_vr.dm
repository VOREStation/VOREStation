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
