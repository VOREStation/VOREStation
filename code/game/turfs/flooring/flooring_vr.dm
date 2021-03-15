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
	
// Start NSB Forbearance Jungle Flooring Additions
/decl/flooring/jungle
	name = "jungle"
	desc = "you shouldn't see this"
	icon = 'icons/turf/outdoors.dmi'
	icon_base = "jungledirt"
	damage_temperature = T0C+280 // 573.15k is when wood will spontaneously burn, so we do somewhere around half that for the initial damage.

/decl/flooring/jungle/dirt
	name = "dirt"
	desc = "Moist, but more than capable of supporting weight. Some minor squish may ensue. Mind the plants."
	icon = 'icons/turf/outdoors.dmi'
	icon_base = "jungledirt"
	has_base_range = 3
	// flags = TURF_HAS_EDGES | TURF_HAS_CORNERS | TURF_REMOVE_SHOVEL // Commenting these out for now, I don't want them removable by shovel, and we don't have edge sprites.
	build_type = /obj/item/stack/tile/jungledirt
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/mud1.ogg',
		'sound/effects/footstep/mud2.ogg',
		'sound/effects/footstep/mud3.ogg',
		'sound/effects/footstep/mud4.ogg',
		'sound/effects/footstep/MedDirt1.ogg',
		'sound/effects/footstep/MedDirt2.ogg',
		'sound/effects/footstep/MedDirt3.ogg',
		'sound/effects/footstep/MedDirt4.ogg'))