// For mappers to make invisible borders. For best results, place at least 8 tiles away from map edge.

/obj/effect/blocker
	desc = "You can't go there!"
	icon = 'icons/turf/wall_masks.dmi'
	icon_state = "rdebug"
	anchored = 1.0
	opacity = 0
	density = 1
	unacidable = 1

/obj/effect/blocker/Initialize() // For non-gateway maps.
	. = ..()
	icon = null
	icon_state = null
