/obj/item/weapon/grenade/spawnergrenade/casino
	name = "Casino Creature Container (Cat)"
	desc = "It is set to detonate in 5 seconds. It will release a cat won from the casino prize vendor!"
	icon = 'icons/obj/casino.dmi'
	icon_state = "casino_delivery"
	item_state = "flashbang"
	origin_tech = list(TECH_MATERIAL = 2, TECH_MAGNET = 2)
	spawner_type = /mob/living/simple_mob/animal/passive/cat

// Detonate now just handles the two loops that query for people in lockers and people who can see it.
/obj/item/weapon/grenade/spawnergrenade/casino/detonate()

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
/obj/item/weapon/grenade/spawnergrenade/casino/penguin
	desc = "It is set to detonate in 5 seconds. It will release a penguin won from the casino prize vendor!"
	name = "Casino Creature Container (Penguin)"
	spawner_type = /mob/living/simple_mob/animal/passive/penguin

/obj/item/weapon/grenade/spawnergrenade/casino/chicken
	desc = "It is set to detonate in 5 seconds. It will release a chicken won from the casino prize vendor!"
	name = "Casino Creature Container (Chicken)"
	spawner_type = /mob/living/simple_mob/animal/passive/chicken

/obj/item/weapon/grenade/spawnergrenade/casino/cow
	desc = "It is set to detonate in 5 seconds. It will release a cow won from the casino prize vendor!"
	name = "Casino Creature Container (Cow)"
	spawner_type = /mob/living/simple_mob/animal/passive/cow

/obj/item/weapon/grenade/spawnergrenade/casino/corgi
	desc = "It is set to detonate in 5 seconds. It will release a corgi won from the casino prize vendor!"
	name = "Casino Creature Container (Corgi)"
	spawner_type = /mob/living/simple_mob/animal/passive/dog/corgi

/obj/item/weapon/grenade/spawnergrenade/casino/fox
	desc = "It is set to detonate in 5 seconds. It will release a fox won from the casino prize vendor!"
	name = "Casino Creature Container (Fox)"
	spawner_type = /mob/living/simple_mob/animal/passive/fox

/obj/item/weapon/grenade/spawnergrenade/casino/fennec
	desc = "It is set to detonate in 5 seconds. It will release a fennec won from the casino prize vendor!"
	name = "Casino Creature Container (Fennec)"
	spawner_type = /mob/living/simple_mob/vore/fennec

/obj/item/weapon/grenade/spawnergrenade/casino/snake
	desc = "It is set to detonate in 5 seconds. It will release a snake won from the casino prize vendor!"
	name = "Casino Creature Container (Snake)"
	spawner_type = /mob/living/simple_mob/animal/passive/snake

/obj/item/weapon/grenade/spawnergrenade/casino/redpanda
	desc = "It is set to detonate in 5 seconds. It will release a red panda won from the casino prize vendor!"
	name = "Casino Creature Container (Red panda)"
	spawner_type = /mob/living/simple_mob/vore/redpanda

/obj/item/weapon/grenade/spawnergrenade/casino/snake
	desc = "It is set to detonate in 5 seconds. It will release a snake won from the casino prize vendor!"
	name = "Casino Creature Container (Snake)"
	spawner_type = /mob/living/simple_mob/animal/passive/snake

/obj/item/weapon/grenade/spawnergrenade/casino/otie
	desc = "It is set to detonate in 5 seconds. It will release a otie won from the casino prize vendor!"
	name = "Casino Creature Container (Otie)"
	spawner_type = /mob/living/simple_mob/vore/otie/friendly

/obj/item/weapon/grenade/spawnergrenade/casino/goldcrest
	desc = "It is set to detonate in 5 seconds. It will release a bird won from the casino prize vendor!"
	name = "Casino Creature Container (Bird)"
	spawner_type = /mob/living/simple_mob/animal/passive/bird/goldcrest

//
// Mecha
//
/obj/item/weapon/grenade/spawnergrenade/casino/gygax
	desc = "You feel great power inside this small round sphere, with great powers comes great responsibilities!"
	name = "Mysterious Grenade"
	spawner_type = /obj/mecha/combat/gygax/dark

/obj/item/weapon/grenade/spawnergrenade/casino/gygax/mining
	name = "Casino Mech Container (Mining Ripley)"
	spawner_type = /obj/mecha/working/ripley/mining

/obj/item/weapon/grenade/spawnergrenade/casino/gygax/firefighter
	name = "Casino Mech Container (Firefighter Ripley)"
	spawner_type = /obj/mecha/working/ripley/firefighter

/obj/item/weapon/grenade/spawnergrenade/casino/gygax/Odysseus
	name = "Casino Mech Container (Odysseus)"
	spawner_type = /obj/mecha/medical/odysseus/loaded

/obj/item/weapon/grenade/spawnergrenade/casino/gygax/shuttlepod
	name = "Casino Mech Container (Shuttlepod)"
	spawner_type = /obj/mecha/working/hoverpod/shuttlepod
