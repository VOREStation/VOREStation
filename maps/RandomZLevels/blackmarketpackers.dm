/area/awaymission/space
	name = "\improper Space"
	icon_state = "blank"
	requires_power = 1
	always_unpowered = 1
	lighting_use_dynamic = 0 // This is the hacky bit.
	power_light = 0
	power_equip = 0
	power_environ = 0
	ambience = list(
		'sound/ambience/ambispace.ogg',
		'sound/music/title2.ogg',
		'sound/music/space.ogg',
		'sound/music/main.ogg',
		'sound/music/traitor.ogg',
		'sound/music/jukebox/MinorTurbulenceFull.ogg')

// Fluff for exotic Z-levels that need power.

/obj/machinery/power/fractal_reactor/fluff/smes
	name = "power storage unit"
	desc = "A high-capacity superconducting magnetic energy storage (SMES) unit. The controls are locked."
	icon_state = "smes"

/obj/machinery/power/fractal_reactor/fluff/converter
	name = "power converter"
	desc = "A heavy duty power converter which allows the ship's engines to generate its power supply."
	icon_state = "bbox_on"
