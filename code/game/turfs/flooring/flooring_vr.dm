/decl/flooring/flesh
	name = "flesh"
	desc = "This slick flesh ripples and squishes under your touch"
	icon = 'icons/turf/stomach_vr.dmi'
	icon_base = "flesh_floor"

/decl/flooring/grass/outdoors
	flags = TURF_REMOVE_SHOVEL

/decl/flooring/grass/outdoors/forest
	icon = 'icons/turf/outdoors.dmi'
	icon_base = "grass-dark"

/turf/simulated/floor/tiled/freezer/cold
	temperature = T0C - 5

///////////NSB Forbearance///////////
///////////Jungle Flooring///////////

/decl/flooring/grass/jungle
	name = "grass"
	desc = "A thick and heavy grass that's adapted to the humid and unforgiving climate."
	icon = 'icons/turf/flooring/torrisfloor.dmi'
	icon_base = "torris_grass"
	has_base_range = 1
	damage_temperature = T0C+80
	flags = TURF_HAS_EDGES | TURF_HAS_CORNERS | TURF_REMOVE_SHOVEL
	build_type = /obj/item/stack/tile/grass/jungle
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/grass1.ogg',
		'sound/effects/footstep/grass2.ogg',
		'sound/effects/footstep/grass3.ogg',
		'sound/effects/footstep/grass4.ogg'))

/decl/flooring/dirt/jungle
	name = "dirt"
	desc = "Moist, but more than capable of supporting weight. Some minor squish may ensue."
	icon = 'icons/turf/flooring/torrisfloor.dmi'
	icon_base = "torris_dirt"
	flags = TURF_HAS_EDGES

/decl/flooring/dirt/volcanic
	name = "volcanic dirt"
	desc = "Dirt that's been cooked by the hostile atmosphere of a volcano. Crunchy."
	icon = 'icons/turf/flooring/torrisfloor.dmi'
	icon_base = "torris_volcanic_dirt"
	flags = TURF_HAS_EDGES