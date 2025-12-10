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
	var/flash = TRUE //Will the grenade flash on detonation?

// Detonate now just handles the two loops that query for people in lockers and people who can see it.
/obj/item/grenade/spawnergrenade/detonate()

	if(spawner_type && deliveryamt)
		// Make a quick flash
		var/turf/T = get_turf(src)
		playsound(src, 'sound/effects/phasein.ogg', 100, 1)
		if(flash)
			for(var/mob/living/carbon/human/M in viewers(T, null))
				if(M.eyecheck() <= 0)
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

/obj/item/grenade/spawnergrenade/manhacks/station/locked
	desc = "It is set to detonate in 5 seconds. It will deploy three weaponized survey drones. This one has a safety interlock that prevents release if used while in proximity to the facility."
	req_access = list(ACCESS_ARMORY) //for toggling safety
	var/locked = 1

/obj/item/grenade/spawnergrenade/manhacks/station/locked/detonate()
	if(locked)
		var/turf/T = get_turf(src)
		if(T.z in using_map.station_levels)
			icon_state = initial(icon_state)
			active = 0
			return 0
	return ..()

/obj/item/grenade/spawnergrenade/manhacks/station/locked/attackby(obj/item/I, mob/user)
	var/obj/item/card/id/id = I.GetID()
	if(istype(id))
		if(check_access(id))
			locked = !locked
			to_chat(user, span_warning("You [locked ? "enable" : "disable"] the safety lock on \the [src]."))
		else
			to_chat(user, span_warning("Access denied."))
		user.visible_message(span_notice("[user] swipes \the [I] against \the [src]."))
	else
		return ..()

/obj/item/grenade/spawnergrenade/manhacks/station/locked/emag_act(var/remaining_charges,var/mob/user)
	..()
	locked = !locked
	to_chat(user, span_warning("You [locked ? "enable" : "disable"] the safety lock on \the [src]!"))

// Generic creature spawner grenades for loadout.
/obj/item/grenade/spawnergrenade/loadout
	name = "Creature Container (Cat)"
	desc = "It is set to detonate in 5 seconds. It will release a cat won from the grenade!"
	icon = 'icons/obj/casino.dmi'
	icon_state = "generic_delivery"
	flash = FALSE

/obj/item/grenade/spawnergrenade/loadout/penguin
	desc = "It is set to detonate in 5 seconds. It will release a penguin from the grenade!"
	name = "Creature Container (Penguin)"
	spawner_type = /mob/living/simple_mob/animal/passive/penguin

/obj/item/grenade/spawnergrenade/loadout/chicken
	desc = "It is set to detonate in 5 seconds. It will release a chicken from the grenade!"
	name = "Creature Container (Chicken)"
	spawner_type = /mob/living/simple_mob/animal/passive/chicken

/obj/item/grenade/spawnergrenade/loadout/cow
	desc = "It is set to detonate in 5 seconds. It will release a cow from the grenade!"
	name = "Creature Container (Cow)"
	spawner_type = /mob/living/simple_mob/animal/passive/cow

/obj/item/grenade/spawnergrenade/loadout/corgi
	desc = "It is set to detonate in 5 seconds. It will release a corgi from the grenade!"
	name = "Creature Container (Corgi)"
	spawner_type = /mob/living/simple_mob/animal/passive/dog/corgi

/obj/item/grenade/spawnergrenade/loadout/fox
	desc = "It is set to detonate in 5 seconds. It will release a fox from the grenade!"
	name = "Creature Container (Fox)"
	spawner_type = /mob/living/simple_mob/animal/passive/fox

/obj/item/grenade/spawnergrenade/loadout/fennec
	desc = "It is set to detonate in 5 seconds. It will release a fennec from the grenade!"
	name = "Creature Container (Fennec)"
	spawner_type = /mob/living/simple_mob/vore/fennec

/obj/item/grenade/spawnergrenade/loadout/snake
	desc = "It is set to detonate in 5 seconds. It will release a snake from the grenade!"
	name = "Creature Container (Snake)"
	spawner_type = /mob/living/simple_mob/animal/passive/snake

/obj/item/grenade/spawnergrenade/loadout/redpanda
	desc = "It is set to detonate in 5 seconds. It will release a red panda from the grenade!"
	name = "Creature Container (Red panda)"
	spawner_type = /mob/living/simple_mob/vore/redpanda

/obj/item/grenade/spawnergrenade/loadout/otie
	desc = "It is set to detonate in 5 seconds. It will release a otie from the grenade!"
	name = "Creature Container (Otie)"
	spawner_type = /mob/living/simple_mob/vore/otie/friendly

/obj/item/grenade/spawnergrenade/loadout/goldcrest
	desc = "It is set to detonate in 5 seconds. It will release a bird from the grenade!"
	name = "Creature Container (Bird)"
	spawner_type = /mob/living/simple_mob/animal/passive/bird/goldcrest

/obj/item/grenade/spawnergrenade/loadout/teppi
	desc = "It is set to detonate in 5 seconds. It will release a teppi from the grenade!"
	name = "Creature Container (Teppi)"
	spawner_type = /mob/living/simple_mob/vore/alienanimals/teppi
