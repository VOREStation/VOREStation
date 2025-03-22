/area
	luminosity           = TRUE
	var/dynamic_lighting = TRUE

/area/Initialize(mapload)
	. = ..()

	if(dynamic_lighting)
		luminosity = FALSE
