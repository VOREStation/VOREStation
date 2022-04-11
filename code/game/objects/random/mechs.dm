/obj/random/mech
	name = "random mech"
	desc = "This is a random single mech."
	icon_state = "mecha"
	drop_get_turf = FALSE

//This list includes the phazon, gorilla and mauler. You might want to use something else if balance is a concern.
/obj/random/mech/item_to_spawn()
	return pick(/obj/mecha/combat/gygax,
				/obj/mecha/combat/gygax/serenity,
				/obj/mecha/combat/gygax/dark,
				/obj/mecha/combat/marauder,
				/obj/mecha/combat/marauder/seraph,
				/obj/mecha/combat/marauder/mauler,
				/obj/mecha/medical/odysseus,
				/obj/mecha/combat/phazon,
				/obj/mecha/combat/phazon/janus,
				/obj/mecha/combat/durand,
				/obj/mecha/working/ripley,
				/obj/mecha/working/ripley/firefighter,
				/obj/mecha/working/ripley/deathripley,
				/obj/mecha/working/ripley/mining)

/obj/random/mech/weaker
	name = "random mech"
	desc = "This is a random single mech. Those are less potent and more common."
	drop_get_turf = FALSE

/obj/random/mech/weaker/item_to_spawn()
	return pick(/obj/mecha/combat/gygax,
				/obj/mecha/combat/gygax/serenity,
				/obj/mecha/medical/odysseus,
				/obj/mecha/combat/durand,
				/obj/mecha/working/ripley,
				/obj/mecha/working/ripley/firefighter,
				/obj/mecha/working/ripley/deathripley,
				/obj/mecha/working/ripley/mining)

/obj/random/mech/old
	name = "random mech"
	desc = "This is a random single old mech."
	drop_get_turf = FALSE

//Note that all of those are worn out and have slightly less maximal health than the standard.
/obj/random/mech/old/item_to_spawn()
	return pick(prob(10);/obj/mecha/combat/gygax/old,
				prob(1);/obj/mecha/combat/marauder/old,
				prob(1);/obj/mecha/combat/phazon/old,
				prob(10);/obj/mecha/combat/durand/old,
				prob(15);/obj/mecha/medical/odysseus/old,
				prob(20);/obj/mecha/working/ripley/mining/old)
