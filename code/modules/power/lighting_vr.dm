// I hate the way macros look stupid standing near lights. I don't care how absurd this looks.

/obj/machinery/light_construct
	layer = 4

/obj/machinery/light_construct/small
	layer = 4

/obj/machinery/light_construct/flamp
	layer = 4


/obj/machinery/light
	layer = 4

//Vorestation addition, to override the New() proc further below, since this is a lamp.
/obj/machinery/light/flamp/New()
	..()
	layer = 4

// create a new lighting fixture
/obj/machinery/light/New()
	..()
	//Vorestation addition, so large mobs stop looking stupid in front of lights.
	if (dir == 2)
		layer = 5