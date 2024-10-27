/obj/item/grenade/spawnergrenade/casino
	name = "Creature Container (Cat)"
	desc = "It is set to detonate in 5 seconds. It will release a cat won from the prize vendor!"
	icon = 'icons/obj/casino.dmi'
	icon_state = "casino_delivery"
	item_state = "flashbang"
	origin_tech = list(TECH_MATERIAL = 2, TECH_MAGNET = 2)
	spawner_type = /mob/living/simple_mob/animal/passive/cat

// Detonate now just handles the two loops that query for people in lockers and people who can see it.
/obj/item/grenade/spawnergrenade/casino/detonate()

	if(spawner_type && deliveryamt)
		var/turf/T = get_turf(src)
		playsound(T, 'sound/effects/phasein.ogg', 100, 1)

		for(var/i=1, i<=deliveryamt, i++)
			var/atom/movable/x = new spawner_type(T)
			if(prob(50))
				for(var/j = 1, j <= rand(1, 3), j++)
					step(x, pick(NORTH,SOUTH,EAST,WEST))
	qdel(src)
	return

//
// Creatures
//
/obj/item/grenade/spawnergrenade/casino/penguin
	desc = "It is set to detonate in 5 seconds. It will release a penguin won from the prize vendor!"
	name = "Creature Container (Penguin)"
	spawner_type = /mob/living/simple_mob/animal/passive/penguin

/obj/item/grenade/spawnergrenade/casino/chicken
	desc = "It is set to detonate in 5 seconds. It will release a chicken won from the prize vendor!"
	name = "Creature Container (Chicken)"
	spawner_type = /mob/living/simple_mob/animal/passive/chicken

/obj/item/grenade/spawnergrenade/casino/cow
	desc = "It is set to detonate in 5 seconds. It will release a cow won from the prize vendor!"
	name = "Creature Container (Cow)"
	spawner_type = /mob/living/simple_mob/animal/passive/cow

/obj/item/grenade/spawnergrenade/casino/corgi
	desc = "It is set to detonate in 5 seconds. It will release a corgi won from the prize vendor!"
	name = "Creature Container (Corgi)"
	spawner_type = /mob/living/simple_mob/animal/passive/dog/corgi

/obj/item/grenade/spawnergrenade/casino/fox
	desc = "It is set to detonate in 5 seconds. It will release a fox won from the prize vendor!"
	name = "Creature Container (Fox)"
	spawner_type = /mob/living/simple_mob/animal/passive/fox

/obj/item/grenade/spawnergrenade/casino/fennec
	desc = "It is set to detonate in 5 seconds. It will release a fennec won from the prize vendor!"
	name = "Creature Container (Fennec)"
	spawner_type = /mob/living/simple_mob/vore/fennec

/obj/item/grenade/spawnergrenade/casino/snake
	desc = "It is set to detonate in 5 seconds. It will release a snake won from the prize vendor!"
	name = "Creature Container (Snake)"
	spawner_type = /mob/living/simple_mob/animal/passive/snake

/obj/item/grenade/spawnergrenade/casino/redpanda
	desc = "It is set to detonate in 5 seconds. It will release a red panda won from the prize vendor!"
	name = "Creature Container (Red panda)"
	spawner_type = /mob/living/simple_mob/vore/redpanda

/obj/item/grenade/spawnergrenade/casino/snake
	desc = "It is set to detonate in 5 seconds. It will release a snake won from the prize vendor!"
	name = "Creature Container (Snake)"
	spawner_type = /mob/living/simple_mob/animal/passive/snake

/obj/item/grenade/spawnergrenade/casino/otie
	desc = "It is set to detonate in 5 seconds. It will release a otie won from the prize vendor!"
	name = "Creature Container (Otie)"
	spawner_type = /mob/living/simple_mob/vore/otie/friendly

/obj/item/grenade/spawnergrenade/casino/goldcrest
	desc = "It is set to detonate in 5 seconds. It will release a bird won from the prize vendor!"
	name = "Creature Container (Bird)"
	spawner_type = /mob/living/simple_mob/animal/passive/bird/goldcrest

//
// Mecha
//
/obj/item/grenade/spawnergrenade/casino/gygax
	desc = "You feel great power inside this small round sphere, with great powers comes great responsibilities!"
	name = "Mysterious Grenade"
	spawner_type = /obj/mecha/combat/gygax/dark

/obj/item/grenade/spawnergrenade/casino/gygax/mining
	name = "Mech Container (Mining Ripley)"
	spawner_type = /obj/mecha/working/ripley/mining

/obj/item/grenade/spawnergrenade/casino/gygax/firefighter
	name = "Mech Container (Firefighter Ripley)"
	spawner_type = /obj/mecha/working/ripley/firefighter

/obj/item/grenade/spawnergrenade/casino/gygax/Odysseus
	name = "Mech Container (Odysseus)"
	spawner_type = /obj/mecha/medical/odysseus/loaded

/obj/item/grenade/spawnergrenade/casino/gygax/shuttlepod
	name = "Mech Container (Shuttlepod)"
	spawner_type = /obj/mecha/working/hoverpod/shuttlepod
//
// Fighters
//
/obj/item/grenade/spawnergrenade/casino/fighter
	desc = "You feel great power inside this small round sphere, with great powers comes great responsibilities!"

/obj/item/grenade/spawnergrenade/casino/fighter/gunpod
	name = "Fighter Container (Gunpod)"
	spawner_type = /obj/mecha/combat/fighter/gunpod/loaded

/obj/item/grenade/spawnergrenade/casino/fighter/baron
	name = "Fighter Container (Baron)"
	spawner_type = /obj/mecha/combat/fighter/baron/loaded

/obj/item/grenade/spawnergrenade/casino/fighter/scoralis
	name = "Fighter Container (Scoralis)"
	spawner_type = /obj/mecha/combat/fighter/scoralis/loaded

/obj/item/grenade/spawnergrenade/casino/fighter/allure
	name = "Fighter Container (Allure)"
	spawner_type = /obj/mecha/combat/fighter/allure/loaded

/obj/item/grenade/spawnergrenade/casino/fighter/pinnace
	name = "Fighter Container (Pinnace)"
	spawner_type = /obj/mecha/combat/fighter/pinnace/loaded
