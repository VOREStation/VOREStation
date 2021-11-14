/obj/effect/overlay
	name = "overlay"
	unacidable = TRUE
	var/i_attached//Added for possible image attachments to objects. For hallucinations and the like.

/obj/effect/overlay/beam//Not actually a projectile, just an effect.
	name="beam"
	icon='icons/effects/beam.dmi'
	icon_state="b_beam"
	plane = ABOVE_OBJ_PLANE
	var/tmp/atom/BeamSource

/obj/effect/overlay/beam/Initialize()
	. = ..()
	QDEL_IN(src, 10)

/obj/effect/overlay/palmtree_r
	name = "Palm tree"
	icon = 'icons/misc/beach2.dmi'
	icon_state = "palm1"
	density = TRUE
	plane = MOB_PLANE
	layer = ABOVE_MOB_LAYER
	anchored = TRUE

/obj/effect/overlay/palmtree_l
	name = "Palm tree"
	icon = 'icons/misc/beach2.dmi'
	icon_state = "palm2"
	density = TRUE
	plane = MOB_PLANE
	layer = ABOVE_MOB_LAYER
	anchored = TRUE

/obj/effect/overlay/coconut
	name = "Coconuts"
	icon = 'icons/misc/beach.dmi'
	icon_state = "coconuts"

/obj/effect/overlay/bluespacify
	name = "Bluespace"
	icon = 'icons/turf/space_vr.dmi' //VOREStation Edit
	icon_state = "bluespacify"
	plane = ABOVE_PLANE

/obj/effect/overlay/wallrot
	name = "wallrot"
	desc = "Ick..."
	icon = 'icons/effects/wallrot.dmi'
	anchored = TRUE
	density = TRUE
	plane = MOB_PLANE
	layer = ABOVE_MOB_LAYER
	mouse_opacity = 0

/obj/effect/overlay/wallrot/Initialize()
	. = ..()
	pixel_x += rand(-10, 10)
	pixel_y += rand(-10, 10)

/obj/effect/overlay/snow
	name = "snow"
	icon = 'icons/turf/overlays.dmi'
	icon_state = "snow"
	anchored = TRUE
	plane = TURF_PLANE

// Todo: Add a version that gradually reaccumulates over time by means of alpha transparency. -Spades
/obj/effect/overlay/snow/attackby(obj/item/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/shovel))
		user.visible_message("<span class='notice'>[user] begins to shovel away \the [src].</span>")
		if(do_after(user, 40))
			to_chat(user, "<span class='notice'>You have finished shoveling!</span>")
			qdel(src)
		return

/obj/effect/overlay/snow/floor
	icon_state = "snowfloor"
	plane = TURF_PLANE
	layer = ABOVE_TURF_LAYER
	mouse_opacity = 0 //Don't block underlying tile interactions

/obj/effect/overlay/snow/floor/edges
	icon_state = "snow_edges"

/obj/effect/overlay/snow/floor/surround
	icon_state = "snow_surround"

/obj/effect/overlay/snow/airlock
	icon_state = "snowairlock"
	layer = DOOR_CLOSED_LAYER+0.01

/obj/effect/overlay/snow/floor/pointy
	icon_state = "snowfloorpointy"

/obj/effect/overlay/snow/wall
	icon_state = "snowwall"
	plane = MOB_PLANE
	layer = ABOVE_MOB_LAYER

/obj/effect/overlay/holographic
	mouse_opacity = FALSE
	anchored = TRUE
	plane = ABOVE_PLANE

// Similar to the tesla ball but doesn't actually do anything and is purely visual.
/obj/effect/overlay/energy_ball
	name = "energy ball"
	desc = "An energy ball."
	icon = 'icons/obj/tesla_engine/energy_ball.dmi'
	icon_state = "energy_ball"
	plane = PLANE_LIGHTING_ABOVE
	pixel_x = -32
	pixel_y = -32

/obj/effect/overlay/vis
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	anchored = TRUE
	vis_flags = VIS_INHERIT_DIR
	///When detected to be unused it gets set to world.time, after a while it gets removed
	var/unused = 0
	///overlays which go unused for this amount of time get cleaned up
	var/cache_expiration = 2 MINUTES

/*
/obj/effect/overlay/atmos_excited
	name = "excited group"
	icon = null
	icon_state = null
	anchored = TRUE  // should only appear in vis_contents, but to be safe
	appearance_flags = RESET_TRANSFORM | TILE_BOUND
	invisibility = INVISIBILITY_ABSTRACT
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

	plane = ATMOS_GROUP_PLANE
*/

/obj/effect/overlay/light_visible
	name = ""
	icon = 'icons/effects/light_overlays/light_32.dmi'
	icon_state = "light"
	plane = PLANE_O_LIGHTING_VISUAL
	appearance_flags = RESET_COLOR | RESET_ALPHA | RESET_TRANSFORM
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	alpha = 0
	vis_flags = NONE
	blocks_emissive = FALSE

/obj/effect/overlay/light_visible/Destroy(force)
	if(!force)
		stack_trace("Movable light visible mask deleted, but not by our component")
		return QDEL_HINT_LETMELIVE
	return ..()

/obj/effect/overlay/light_cone
	name = ""
	icon = 'icons/effects/light_overlays/light_cone.dmi'
	icon_state = "light"
	plane = PLANE_O_LIGHTING_VISUAL
	appearance_flags = RESET_COLOR | RESET_ALPHA | RESET_TRANSFORM
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	vis_flags = NONE
	alpha = 110
	blocks_emissive = FALSE

	var/static/matrix/normal_transform

/obj/effect/overlay/light_cone/Initialize()
	. = ..()
	apply_standard_transform()

/obj/effect/overlay/light_cone/proc/reset_transform(apply_standard)
	transform = initial(transform)
	if(apply_standard)
		apply_standard_transform()

/obj/effect/overlay/light_cone/proc/apply_standard_transform()
	transform = transform.Translate(-32, -32)

/obj/effect/overlay/light_cone/Destroy(force)
	if(!force)
		stack_trace("Directional light cone deleted, but not by our component")
		return QDEL_HINT_LETMELIVE
	return ..()

/obj/effect/overlay/closet_door
	anchored = TRUE
	plane = FLOAT_PLANE
	layer = FLOAT_LAYER
	vis_flags = VIS_INHERIT_ID
	appearance_flags = KEEP_TOGETHER | LONG_GLIDE | PIXEL_SCALE
