// For mappers to make invisible borders. For best results, place at least 8 tiles away from map edge.

/obj/effect/blocker
	desc = "You can't go there!"
	icon = 'icons/turf/wall_masks.dmi'
	icon_state = "rdebug"
	anchored = TRUE
	opacity = 0
	density = TRUE
	unacidable = TRUE
	plane = PLANE_BUILDMODE

/*	//VOREStation Edit
/obj/effect/blocker/Initialize() // For non-gateway maps.
	. = ..()
	icon = null
	icon_state = null
*/
