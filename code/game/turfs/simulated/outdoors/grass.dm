var/list/grass_types = list(

)

/turf/simulated/floor/outdoors/grass
	name = "grass"
	icon_state = "grass"
	edge_blending_priority = 4
	turf_layers = list(
		/turf/simulated/floor/outdoors/rocks,
		/turf/simulated/floor/outdoors/dirt
		)
	var/grass_chance = 20

	var/list/grass_types = list(
		/obj/structure/flora/ausbushes/sparsegrass,
		/obj/structure/flora/ausbushes/fullgrass
		)

/datum/category_item/catalogue/flora/sif_grass
	name = "Sivian Flora - Moss"
	desc = "A natural moss that has adapted to the sheer cold climate of Sif. \
	The moss came to rely partially on bioluminescent bacteria provided by the local tree populations. \
	As such, the moss often grows in large clusters in the denser forests of Sif. \
	The moss has evolved into it's distinctive blue hue thanks to it's reliance on bacteria that has a similar color."
	value = CATALOGUER_REWARD_TRIVIAL

/turf/simulated/floor/outdoors/grass/sif
	name = "growth"
	icon_state = "grass_sif"
	edge_blending_priority = 4
	grass_chance = 5
	var/tree_chance = 2

	grass_types = list(
		/obj/structure/flora/sif/eyes = 1,
		/obj/structure/flora/sif/tendrils = 10
		)

	catalogue_data = list(/datum/category_item/catalogue/flora/sif_grass)
	catalogue_delay = 2 SECONDS

/turf/simulated/floor/outdoors/grass/sif/Initialize()
	if(tree_chance && prob(tree_chance) && !check_density())
		new /obj/structure/flora/tree/sif(src)
	. = ..()

/turf/simulated/floor/outdoors/grass/Initialize()
	if(prob(50))
		icon_state = "[initial(icon_state)]2"
		//edge_blending_priority++

	if(grass_chance && prob(grass_chance) && !check_density())
		var/grass_type = pickweight(grass_types)
		new grass_type(src)
	. = ..()

/turf/simulated/floor/outdoors/grass/forest
	name = "thick grass"
	icon_state = "grass-dark"
	grass_chance = 80
	//tree_chance = 20
	edge_blending_priority = 5

/turf/simulated/floor/outdoors/grass/sif/forest
	name = "thick growth"
	icon_state = "grass_sif_dark"
	edge_blending_priority = 5
	tree_chance = 10
	grass_chance = 0

