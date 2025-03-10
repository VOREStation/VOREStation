/obj/effect/wire_deleter
	name = "wire deleter"
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x2"
	anchored = TRUE
	unacidable = TRUE
	simulated = FALSE
	invisibility = 100

/obj/effect/wire_deleter/Initialize(mapload)
	. = ..()

	for(var/c in loc.contents)
		if(istype(c, /obj/structure/cable))
			if(prob(33))
				qdel(c)
	qdel(src)
