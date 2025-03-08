/obj/effect/graffitispawner
	name = "old scrawling"
	icon = 'icons/effects/map_effects.dmi'
	icon_state = "graffiti"

	var/graffiti_type	// The text string for the desired icon state of your graffiti.

	// If the effect's color is not set, it will be chosen at random.
	var/color_secondary	// The hexcode for the desired secondary color of your graffiti. If blank, it will inherit this effect's color.

/obj/effect/graffitispawner/Initialize(mapload)
	..()

	if(!color)
		color = rgb(rand(1,255),rand(1,255),rand(1,255))

	if(!color_secondary)
		color_secondary = color

	if(!graffiti_type)
		graffiti_type = pick("rune", "graffiti", "left", "right", "up", "down")

	var/turf/T = get_turf(src)
	var/obj/effect/decal/cleanable/crayon/C = new(T, color, color_secondary, graffiti_type)

	C.name = name

	return INITIALIZE_HINT_QDEL
