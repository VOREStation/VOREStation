/obj/item/grenade/spawnergrenade
	desc = "It is set to detonate in 5 seconds. It will unleash an unspecified anomaly into the vicinity."
	name = "delivery grenade"
	icon = 'icons/obj/grenade.dmi'
	icon_state = "delivery"
	item_state = "flashbang"
	origin_tech = list(TECH_MATERIAL = 3, TECH_MAGNET = 4)
	var/banglet = 0
	var/spawner_type = null // must be an object path
	var/deliveryamt = 1 // amount of type to deliver

// Detonate now just handles the two loops that query for people in lockers and people who can see it.
/obj/item/grenade/spawnergrenade/detonate()

	if(spawner_type && deliveryamt)
		// Make a quick flash
		var/turf/T = get_turf(src)
		playsound(src, 'sound/effects/phasein.ogg', 100, 1)
		for(var/mob/living/carbon/human/M in viewers(T, null))
			if(M:eyecheck() <= 0)
				M.flash_eyes()

		// Spawn some hostile syndicate critters
		for(var/i=1, i<=deliveryamt, i++)
			var/atom/movable/x = new spawner_type(T)
			if(prob(50))
				for(var/j = 1, j <= rand(1, 3), j++)
					step(x, pick(NORTH,SOUTH,EAST,WEST))
	qdel(src)
	return

/obj/item/grenade/spawnergrenade/manhacks
	name = "manhack delivery grenade"
	spawner_type = /mob/living/simple_mob/mechanical/viscerator
	deliveryamt = 5
	origin_tech = list(TECH_MATERIAL = 3, TECH_MAGNET = 4, TECH_ILLEGAL = 4)

/obj/item/grenade/spawnergrenade/manhacks/mercenary
	spawner_type = /mob/living/simple_mob/mechanical/viscerator/mercenary

/obj/item/grenade/spawnergrenade/manhacks/raider
	spawner_type = /mob/living/simple_mob/mechanical/viscerator/raider

/obj/item/grenade/spawnergrenade/manhacks/station
	desc = "It is set to detonate in 5 seconds. It will deploy three weaponized survey drones."
	deliveryamt = 3
	spawner_type = /mob/living/simple_mob/mechanical/viscerator/station
	origin_tech = list(TECH_MATERIAL = 3, TECH_MAGNET = 3, TECH_ILLEGAL = 1)

/obj/item/grenade/spawnergrenade/ward
	name = "sentry delivery grenade"
	desc = "It is set to detonate in 5 seconds. It will deploy a single thermal-optic sentry drone."
	spawner_type = /mob/living/simple_mob/mechanical/ward/monitor/crew
	deliveryamt = 1
	origin_tech = list(TECH_MATERIAL = 4, TECH_MAGNET = 3, TECH_BLUESPACE = 2)

/obj/item/grenade/spawnergrenade/spesscarp
	name = "carp delivery grenade"
	spawner_type = /mob/living/simple_mob/animal/space/carp
	deliveryamt = 5
	origin_tech = list(TECH_MATERIAL = 3, TECH_MAGNET = 4, TECH_ILLEGAL = 4)

/obj/item/grenade/spawnergrenade/spider
	name = "spider delivery grenade"
	spawner_type = /mob/living/simple_mob/animal/giant_spider/hunter
	deliveryamt = 3
	origin_tech = list(TECH_MATERIAL = 3, TECH_MAGNET = 4, TECH_ILLEGAL = 4)

//Sometimes you just need a sudden influx of spiders.
/obj/item/grenade/spawnergrenade/spider/briefcase
	name = "briefcase"
	desc = "It's made of AUTHENTIC faux-leather and has a price-tag still attached. Its owner must be a real professional."
	icon_state = "briefcase"
	item_state = "briefcase"
	force = 8.0
	throw_speed = 1
	throw_range = 4
	w_class = ITEMSIZE_LARGE
	deliveryamt = 6
