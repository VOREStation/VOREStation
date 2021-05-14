/* Turf Data
 *
 * Contains:
 *		Jungle Grass
 *		TBD
 *
 */

///////////NSB Forbearance///////////
///////////Jungle Flooring///////////

/datum/category_item/catalogue/flora/torris/jungle_grass
	name = "Torris Flora - Sweetgrass"
	desc = "A naturaly thick grass that has adapted to the hostile climate of Torris. \
	The grass is dense and covers the moist ground of the surface of Torris. The grass \
	can't grow or survive longanywhere else as it requires the dense moisture in the \
	atmosphere to survive. When cut it gives off a plesantly sweet scent."
	value = CATALOGUER_REWARD_TRIVIAL

/turf/simulated/floor/outdoors/grass/jungle_grass
	name = "sweetgrass"
	icon = "icons/turf/torrisfloor.dmi"
	icon_state = "torris_grass"
	initial_flooring = /decl/flooring/grass/jungle
	edge_blending_priority = 4
	grass_chance = 5

	grass_types = list(
		/obj/structure/flora/torris/stones = 5,
		/obj/structure/flora/torris/tallgrass = 20,
		/obj/structure/flora/torris/nyrian = 4,
		/obj/structure/flora/torris/rafflesia = 1,
		/obj/structure/flora/torris/twilight = 6,
		/obj/structure/flora/torris/deadnettle = 5

		)

	catalogue_data = list(/datum/category_item/catalogue/flora/torris/jungle_grass)
	catalogue_delay = 2 SECONDS
