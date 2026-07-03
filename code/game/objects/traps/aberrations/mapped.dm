/obj/random/aberration
	name = "Random Abberation"
	desc = "This is a random abberation."
	icon = 'icons/obj/toy.dmi'
	icon_state = "generic"
	spawn_nothing_percentage = 25

/obj/random/aberration/item_to_spawn()
	return pick(prob(15);/obj/effect/abstract/abberation/spawner/fire,
				prob(15);/obj/effect/abstract/abberation/spawner/glass)
