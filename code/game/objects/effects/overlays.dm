/obj/effect/overlay
	name = "overlay"
	unacidable = 1
	var/i_attached//Added for possible image attachments to objects. For hallucinations and the like.

/obj/effect/overlay/beam//Not actually a projectile, just an effect.
	name="beam"
	icon='icons/effects/beam.dmi'
	icon_state="b_beam"
	var/tmp/atom/BeamSource
	New()
		..()
		spawn(10) qdel(src)

/obj/effect/overlay/palmtree_r
	name = "Palm tree"
	icon = 'icons/misc/beach2.dmi'
	icon_state = "palm1"
	density = 1
	layer = 5
	anchored = 1

/obj/effect/overlay/palmtree_l
	name = "Palm tree"
	icon = 'icons/misc/beach2.dmi'
	icon_state = "palm2"
	density = 1
	layer = 5
	anchored = 1

/obj/effect/overlay/coconut
	name = "Coconuts"
	icon = 'icons/misc/beach.dmi'
	icon_state = "coconuts"

/obj/effect/overlay/bluespacify
	name = "Bluespace"
	icon = 'icons/turf/space.dmi'
	icon_state = "bluespacify"
	layer = 10

/obj/effect/overlay/wallrot
	name = "wallrot"
	desc = "Ick..."
	icon = 'icons/effects/wallrot.dmi'
	anchored = 1
	density = 1
	layer = 5
	mouse_opacity = 0

/obj/effect/overlay/wallrot/New()
	..()
	pixel_x += rand(-10, 10)
	pixel_y += rand(-10, 10)

/obj/effect/overlay/snow
	name = "snow"
	icon = 'icons/turf/overlays.dmi'
	icon_state = "snow"
	anchored = 1

/obj/effect/overlay/snow/floor
	icon_state = "snowfloor"
	layer = 2.01 //Just above floor

/obj/effect/overlay/snow/floor/edges
	icon_state = "snow_edges"

/obj/effect/overlay/snow/floor/surround
	icon_state = "snow_surround"

/obj/effect/overlay/snow/airlock
	icon_state = "snowairlock"
	layer = 3.2 //Just above airlocks

/obj/effect/overlay/snow/floor/north
	icon_state = "snowfloor_n"

/obj/effect/overlay/snow/floor/south
	icon_state = "snowfloor_s"

/obj/effect/overlay/snow/floor/east
	icon_state = "snowfloor_e"

/obj/effect/overlay/snow/floor/west
	icon_state = "snowfloor_w"

/obj/effect/overlay/snow/wall/north
	icon_state = "snowwall_n"
	layer = 5 //Same as lights so humans can stand under it

/obj/effect/overlay/snow/wall/south
	icon_state = "snowwall_s"

/obj/effect/overlay/snow/wall/east
	icon_state = "snowwall_e"

/obj/effect/overlay/snow/wall/west
	icon_state = "snowwall_w"