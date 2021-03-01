// This is used to have vacuums inside the asteroid be more present.

/turf/space/cracked_asteroid
	icon = 'icons/turf/flooring/asteroid.dmi'
	name = "cracked sand"
	desc = "Rough sand with a huge crack.  It probably leads out into the void."
	icon_state = "asteroid_cracked"
	dynamic_lighting = TRUE
	keep_sprite = TRUE
	plane = TURF_PLANE //It's not really space

/turf/space/cracked_asteroid/is_space() // So people don't start floating when standing on it.
	return FALSE
