/*
USAGE NOTE
For decals, the var Persistent = 'has already been saved', and is primarily used to prevent duplicate savings of generic filth (filth.dm).
This also means 'TRUE' can be used to define a decal as "Do not save at all, even as a generic replacement." if a dirt decal is considered 'too common' to save.
generic_filth = TRUE means when the decal is saved, it will be switched out for a generic green 'filth' decal.
*/

/obj/effect/decal/cleanable
	plane = DIRTY_PLANE
	layer = DIRTY_LAYER
	var/persistent = FALSE
	var/generic_filth = FALSE
	var/age = 0
	var/list/random_icon_states = list()
	var/obj/effect/decal/jan_hud/jan_icon = null

/obj/effect/decal/cleanable/Initialize(var/mapload, var/_age)
	if(!isnull(_age))
		age = _age
	if(random_icon_states && length(src.random_icon_states) > 0)
		src.icon_state = pick(src.random_icon_states)
	if(!mapload || !CONFIG_GET(flag/persistence_ignore_mapload))
		SSpersistence.track_value(src, /datum/persistent/filth)
	jan_icon = new/obj/effect/decal/jan_hud(src.loc)
	. = ..()

/obj/effect/decal/cleanable/Destroy()
	SSpersistence.forget_value(src, /datum/persistent/filth)
	QDEL_NULL(jan_icon)
	. = ..()

/obj/effect/decal/cleanable/clean_blood(var/ignore = 0)
	if(!ignore)
		qdel(src)
		return
	..()

/obj/effect/decal/cleanable/New()
	if (random_icon_states && length(src.random_icon_states) > 0)
		src.icon_state = pick(src.random_icon_states)
	..()

/obj/effect/decal/jan_hud
	plane = PLANE_JANHUD
	layer = BELOW_MOB_LAYER
	vis_flags = VIS_HIDE
	persist_storable = FALSE
	icon = 'icons/mob/hud.dmi'
	mouse_opacity = 0

/obj/effect/decal/jan_hud/Initialize()
	src.icon_state = "janhud[rand(1,9)]"
