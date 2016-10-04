// -- Areas -- //

/area/awaymission/zoo
	icon_state = "blank"
	requires_power = 0
	always_unpowered = 0
	lighting_use_dynamic = 0
	base_turf = /turf/snow/snow2
	ambience = list('sound/ambience/ambispace.ogg','sound/music/title2.ogg','sound/music/space.ogg','sound/music/main.ogg','sound/music/traitor.ogg')
//	base_turf = /turf/simulated/floor/snow/snow2

/*
/area/awaymission/snowfield/outside
	icon_state = "green"
	requires_power = 1
	always_unpowered = 1
	lighting_use_dynamic = 1
	power_light = 0
	power_equip = 0
	power_environ = 0
	mobcountmax = 100
	floracountmax = 7000
	valid_mobs = list(/mob/living/simple_animal/hostile/samak/polar, /mob/living/simple_animal/hostile/diyaab/polar,
					/mob/living/simple_animal/hostile/shantak/polar, /mob/living/simple_animal/hostile/vore/polarbear,
					/mob/living/simple_animal/hostile/vore/wolf)
	valid_flora = list(/obj/structure/flora/tree/pine, /obj/structure/flora/tree/pine, /obj/structure/flora/tree/pine,
					/obj/structure/flora/tree/dead, /obj/structure/flora/grass/brown, /obj/structure/flora/grass/green,
					/obj/structure/flora/grass/both, /obj/structure/flora/bush, /obj/structure/flora/ausbushes/grassybush,
					/obj/structure/flora/ausbushes/sunnybush, /obj/structure/flora/ausbushes/genericbush, /obj/structure/flora/ausbushes/pointybush,
					/obj/structure/flora/ausbushes/lavendergrass, /obj/structure/flora/ausbushes/sparsegrass, /obj/structure/flora/ausbushes/fullgrass)
*/

/obj/machinery/vending/food
	name = "Food-O-Mat"
	desc = "A technological marvel, supposedly able to cook or mix a large variety of food or drink."
	icon_state = "boozeomat"
	icon_deny = "boozeomat-deny"
	products = list(/obj/item/weapon/reagent_containers/food/drinks/bottle/orangejuice = 4,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/tomatojuice = 4,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/limejuice = 4,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/cream = 4,
					/obj/item/weapon/reagent_containers/food/drinks/milk = 4,
					/obj/item/weapon/reagent_containers/food/drinks/cans/cola = 8,
					/obj/item/weapon/reagent_containers/food/drinks/cans/sodawater = 15,
					/obj/item/weapon/reagent_containers/food/drinks/flask/barflask = 2,
					/obj/item/weapon/reagent_containers/food/drinks/flask/vacuumflask = 2,
					/obj/item/weapon/reagent_containers/food/drinks/ice = 9,
					/obj/item/weapon/reagent_containers/food/drinks/tea = 10,
					/obj/item/weapon/reagent_containers/food/snacks/appletart = 4,
					/obj/item/weapon/reagent_containers/food/snacks/cheeseburger = 10,
					/obj/item/weapon/reagent_containers/food/snacks/creamcheesebreadslice = 10,
					/obj/item/weapon/reagent_containers/food/snacks/grilledcheese = 10,
					/obj/item/weapon/reagent_containers/food/snacks/hotdog = 10,
					/obj/item/weapon/reagent_containers/food/snacks/loadedbakedpotato = 10,
					/obj/item/weapon/reagent_containers/food/snacks/margheritaslice = 10,
					/obj/item/weapon/reagent_containers/food/snacks/muffin = 10,
					/obj/item/weapon/reagent_containers/food/snacks/omelette = 10,
					/obj/item/weapon/reagent_containers/food/snacks/pastatomato = 10,
					/obj/item/weapon/reagent_containers/food/snacks/tofuburger = 10,
					/obj/item/weapon/reagent_containers/food/snacks/waffles = 10
					)
	contraband = list(/obj/item/weapon/reagent_containers/food/snacks/mysterysoup = 10)
	vend_delay = 15


/*

Sif is a terrestrial planet in the Vir system. It is somewhat earth-like, in that it has oceans, a breathable atmosphere,
a magnetic field, weather, and similar gravity to Earth. It is currently the capital planet of Vir. Its center of government
is the equatorial city and site of first settlement, New Reykjavik.

Sif has stabilized its local economy and, following through with their original mission plans (if now for themselves rather
than their original corporate backers), become a self-sufficient and popular snow resort and garden world with a huge ocean
farming and fishing industry. Modern Sif is a popular world for settlement that enjoys a steady population growth around its
equatorial warm belt through immigration, and no longer a protectorate but a full member of the confederacy.

/mob/living/simple_animal/hostile/samak
	name = "samak"
	desc = "A fast, armoured predator accustomed to hiding and ambushing in cold terrain."

/mob/living/simple_animal/hostile/diyaab
	name = "diyaab"
	desc = "A small pack animal. Although omnivorous, it will hunt meat on occasion."

/mob/living/simple_animal/hostile/shantak
	name = "shantak"
	desc = "A piglike creature with a bright iridiscent mane that sparkles as though lit by an inner light. Don't be fooled by its beauty though."

/mob/living/simple_animal/yithian
	name = "yithian"
	desc = "A friendly creature vaguely resembling an oversized snail without a shell."

/mob/living/simple_animal/tindalos
	name = "tindalos"
	desc = "It looks like a large, flightless grasshopper."

*/