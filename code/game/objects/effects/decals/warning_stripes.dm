/obj/effect/decal/warning_stripes
	icon = 'icons/effects/warning_stripes.dmi'

/obj/effect/decal/warning_stripes/Initialize(mapload)
	. = ..()
	var/turf/T=get_turf(src)
	var/image/I=image(icon, icon_state = icon_state, dir = dir)
	I.color=color
	T.add_overlay(I)
	return INITIALIZE_HINT_QDEL
