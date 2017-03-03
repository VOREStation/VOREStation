var/list/grass_types = list(
	/obj/structure/flora/ausbushes/sparsegrass,
	/obj/structure/flora/ausbushes/fullgrass
)

/turf/simulated/floor/outdoors/grass
	name = "grass"
	icon_state = "grass"
	edge_blending_priority = 3
	turf_layers = list(
		/turf/simulated/floor/outdoors/rocks,
		/turf/simulated/floor/outdoors/dirt
		)
	var/grass_chance = 20

/turf/simulated/floor/outdoors/grass/sif
	name = "growth"
	icon_state = "grass_sif"
	edge_blending_priority = 3
	grass_chance = 0

/turf/simulated/floor/outdoors/grass/New()
	if(prob(50))
		icon_state += "2"
		//edge_blending_priority++

	if(grass_chance && prob(grass_chance))
		var/grass_type = pick(grass_types)
		new grass_type(src)
	..()

/turf/simulated/floor/outdoors/grass/forest
	name = "thick grass"
	icon_state = "grass-dark"
	grass_chance = 80
	//tree_prob = 20
	edge_blending_priority = 4

/turf/simulated/floor/outdoors/grass/sif/forest
	name = "thick growth"
	icon_state = "grass_sif_dark"
	edge_blending_priority = 4