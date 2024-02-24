/*
 * Home of the floor chemical coating.
 */

/obj/effect/decal/cleanable/chemcoating
	icon = 'icons/effects/effects.dmi'
	icon_state = "dirt"

/obj/effect/decal/cleanable/chemcoating/New()
	..()
	create_reagents(100)

/obj/effect/decal/cleanable/chemcoating/Initialize()
	. = ..()
	var/turf/T = get_turf(src)
	if(T)
		for(var/obj/O in get_turf(src))
			if(O == src)
				continue
			if(istype(O, /obj/effect/decal/cleanable/chemcoating))
				var/obj/effect/decal/cleanable/chemcoating/C = O
				if(C.reagents && C.reagents.reagent_list.len)
					C.reagents.trans_to_obj(src,C.reagents.total_volume)
				qdel(O)

/obj/effect/decal/cleanable/chemcoating/Bumped(A as mob|obj)
	if(reagents)
		reagents.touch(A)
	return ..()

/obj/effect/decal/cleanable/chemcoating/Crossed(AM as mob|obj)
	Bumped(AM)

/obj/effect/decal/cleanable/chemcoating/update_icon()
	..()
	color = reagents.get_color()
