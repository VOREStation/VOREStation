/client/proc/kaboom()
	var/power = tgui_input_number(src, "power?", "power?")
	var/turf/T = get_turf(src.mob)
	explosion(T, power)

/turf
	var/explosion_resistance

/turf/space
	explosion_resistance = 3

/turf/simulated/open
	explosion_resistance = 3

/turf/simulated/floor
	explosion_resistance = 1

/turf/simulated/mineral
	explosion_resistance = 2

/turf/simulated/shuttle/floor
	explosion_resistance = 1

/turf/simulated/shuttle/floor4
	explosion_resistance = 1

/turf/simulated/shuttle/plating
	explosion_resistance = 1

/turf/simulated/shuttle/wall
	explosion_resistance = 10

/turf/simulated/wall
	explosion_resistance = 10


// Lets pretend we're plating, these should only exist at places like central.
/turf/unsimulated
	explosion_resistance = 1

/turf/unsimulated/wall
	explosion_resistance = 10
