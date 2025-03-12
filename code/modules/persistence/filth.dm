/obj/effect/decal/cleanable/filth
	name = "filth"
	desc = "Disgusting. Someone from last shift didn't do their job properly."
	icon = 'icons/effects/blood.dmi'
	icon_state = "mfloor1"
	random_icon_states = list("mfloor1", "mfloor2", "mfloor3", "mfloor4", "mfloor5", "mfloor6", "mfloor7")
	color = "#464f33"
	anchored = TRUE
	persistent = TRUE

/obj/effect/decal/cleanable/filth/Initialize(mapload)
	. = ..()
	alpha = rand(180,220)
