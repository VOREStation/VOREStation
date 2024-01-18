/obj/effect/floor_decal/atoll
	name = "mural"
	icon = 'maps/redgate/falls/icons/decals/marble_decals.dmi'
	icon_state = "mural"

/obj/effect/floor_decal/atoll/damage
	name = "damaged flooring"
	icon_state = "damage"

/obj/effect/floor_decal/atoll/bronze
	name = "bronze filling"
	icon_state = "bronze"

/obj/effect/floor_decal/atoll/border
	name = "marble border"
	icon_state = "border"

/obj/effect/floor_decal/atoll/border/invert
	icon_state = "border_invert"

/obj/effect/floor_decal/atoll/stairs
	name = "marble stairs"
	icon_state = "stairs"

/obj/effect/floor_decal/atoll/stairs/Initialize()
	dir = pick(cardinal)
	. = ..()

/obj/effect/floor_decal/atoll/moss
	name = "moss"
	icon_state = "moss"

/obj/effect/floor_decal/atoll/moss/random/Initialize()
	dir = pick(alldirs)
	. = ..()

/obj/effect/floor_decal/atoll/power
	icon_state = "power"

//Fake shadows and silhouettes
/obj/effect/decal/shadow
	icon = 'maps/redgate/falls/icons/decals/wall_decals.dmi'
	icon_state = "wall_shadow"
	anchored = 1
	mouse_opacity = 0

/obj/effect/decal/shadow/silhouette
	icon_state = "silhouette"

/obj/effect/decal/shadow/silhouette/pillar
	icon_state = "silhouette_p"

/obj/effect/decal/shadow/silhouette/support
	icon_state = "silhouette_support"

/obj/effect/decal/shadow/floor
	icon_state = "floor_shadow"

/obj/effect/decal/whitecaps
	icon = 'maps/redgate/falls/icons/turfs/water.dmi'
	icon_state = "1"
	anchored = 1
	mouse_opacity = 0

/obj/effect/decal/whitecaps/Initialize()
	icon_state = pick("1","2","3")
	. = ..()

//Godrays
/obj/effect/decal/godray
	icon = 'maps/redgate/falls/icons/decals/godrays.dmi'
	icon_state = "godrays"
	anchored = 1
	mouse_opacity = 0
	layer = MOB_LAYER + 0.5
	plane = MOB_PLANE
