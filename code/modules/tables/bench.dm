/obj/structure/table/bench
	name = "bench frame"
	icon = 'icons/obj/bench.dmi'
	icon_state = "frame"
	desc = "It's a bench, for putting things on. Or standing on, if you really want to."
	can_reinforce = 0
	flipped = -1
	density = 0

/obj/structure/table/bench/update_desc()
	if(material)
		name = "[material.display_name] bench"
	else
		name = "bench frame"

/obj/structure/table/bench/CanPass(atom/movable/mover)
	return 1