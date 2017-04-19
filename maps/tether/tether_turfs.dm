//Simulated
VIRGO3B_TURF_CREATE(/turf/simulated/open)
/turf/simulated/open/virgo3b
	edge_blending_priority = 0.5 //Turfs which also have e_b_p and higher than this will plop decorative edges onto this turf
/turf/simulated/open/virgo3b/New()
	. = ..()
	outdoor_turfs.Add(src)
	return .

VIRGO3B_TURF_CREATE(/turf/simulated/floor/outdoors/rocks)

VIRGO3B_TURF_CREATE(/turf/simulated/floor/outdoors/grass/sif)

VIRGO3B_TURF_CREATE(/turf/simulated/floor/reinforced)
/turf/simulated/floor/reinforced/virgo3b/New()
	. = ..()
	outdoor_turfs.Add(src)
	return .

VIRGO3B_TURF_CREATE(/turf/simulated/floor/tiled/steel_dirty)
/turf/simulated/floor/tiled/steel_dirty/virgo3b/New()
	. = ..()
	outdoor_turfs.Add(src)
	return .

//Unsimulated
/turf/unsimulated/wall/planetary/virgo3b
	name = "facility wall"
	desc = "An eight-meter tall carbyne wall. For when the wildlife on your planet is mostly militant megacorps."
	alpha = 0xFF
	VIRGO3B_SET_ATMOS
