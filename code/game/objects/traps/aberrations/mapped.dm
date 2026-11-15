/obj/random/aberration
	name = "Random aberration"
	desc = "This is a random aberration."
	icon = 'icons/obj/toy.dmi'
	icon_state = "generic"
	spawn_nothing_percentage = 25

/obj/random/aberration/item_to_spawn()
	return pick(prob(15);/obj/effect/abstract/aberration/spawner/fire,
				prob(15);/obj/effect/abstract/aberration/spawner/glass,
				prob(15);/obj/effect/abstract/aberration/spawner/lightning,
				prob(15);/obj/effect/abstract/aberration/spawner/emp)
