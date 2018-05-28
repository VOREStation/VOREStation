/*
 * Random Mobs
 */

/obj/random/mob
	name = "Random Animal"
	desc = "This is a random animal."
	icon = 'icons/mob/animal.dmi'
	icon_state = "chicken_white"

	var/overwrite_hostility = 0

	var/mob_faction = null
	var/mob_returns_home = 0
	var/mob_wander = 1
	var/mob_wander_distance = 3
	var/mob_hostile = 0
	var/mob_retaliate = 0

/obj/random/mob/item_to_spawn()
	return pick(prob(10);/mob/living/simple_animal/lizard,
				prob(6);/mob/living/simple_animal/retaliate/diyaab,
				prob(10);/mob/living/simple_animal/cat/fluff,
				prob(6);/mob/living/simple_animal/cat/kitten,
				prob(10);/mob/living/simple_animal/corgi,
				prob(6);/mob/living/simple_animal/corgi/puppy,
				prob(10);/mob/living/simple_animal/crab,
				prob(10);/mob/living/simple_animal/chicken,
				prob(6);/mob/living/simple_animal/chick,
				prob(10);/mob/living/simple_animal/cow,
				prob(6);/mob/living/simple_animal/retaliate/goat,
				prob(10);/mob/living/simple_animal/penguin,
				prob(10);/mob/living/simple_animal/mouse,
				prob(10);/mob/living/simple_animal/yithian,
				prob(10);/mob/living/simple_animal/tindalos,
				prob(10);/mob/living/simple_animal/corgi/tamaskan,
				prob(3);/mob/living/simple_animal/parrot,
				prob(1);/mob/living/simple_animal/giant_crab)

/obj/random/mob/spawn_item() //These should only ever have simple mobs.
	var/build_path = item_to_spawn()

	var/mob/living/simple_animal/M = new build_path(src.loc)
	M.ai_inactive = 1 //Don't fight eachother while we're still setting up!
	if(mob_faction)
		M.faction = mob_faction
	M.returns_home = mob_returns_home
	M.wander = mob_wander
	M.wander_distance = mob_wander_distance
	if(overwrite_hostility)
		M.hostile = mob_hostile
		M.retaliate = mob_retaliate
	M.ai_inactive = 0 //Now you can kill eachother if your faction didn't override.

	if(pixel_x || pixel_y)
		M.pixel_x = pixel_x
		M.pixel_y = pixel_y

/obj/random/mob/sif
	name = "Random Sif Animal"
	desc = "This is a random cold weather animal."
	icon_state = "penguin"

	mob_returns_home = 1
	mob_wander_distance = 10

/obj/random/mob/sif/item_to_spawn()
	return pick(prob(30);/mob/living/simple_animal/retaliate/diyaab,
				prob(15);/mob/living/simple_animal/crab,
				prob(15);/mob/living/simple_animal/penguin,
				prob(15);/mob/living/simple_animal/mouse,
				prob(15);/mob/living/simple_animal/corgi/tamaskan,
				prob(2);/mob/living/simple_animal/hostile/giant_spider/frost,
				prob(1);/mob/living/simple_animal/hostile/goose,
				prob(20);/mob/living/simple_animal/giant_crab)


/obj/random/mob/sif/peaceful
	name = "Random Peaceful Sif Animal"
	desc = "This is a random peaceful cold weather animal."
	icon_state = "penguin"

	mob_returns_home = 1
	mob_wander_distance = 12

/obj/random/mob/sif/peaceful/item_to_spawn()
	return pick(prob(30);/mob/living/simple_animal/retaliate/diyaab,
				prob(15);/mob/living/simple_animal/crab,
				prob(15);/mob/living/simple_animal/penguin,
				prob(15);/mob/living/simple_animal/mouse,
				prob(15);/mob/living/simple_animal/corgi/tamaskan,
				prob(20);/mob/living/simple_animal/giant_crab)

/obj/random/mob/sif/hostile
	name = "Random Hostile Sif Animal"
	desc = "This is a random hostile cold weather animal."
	icon_state = "frost"

/obj/random/mob/sif/hostile/item_to_spawn()
	return pick(prob(22);/mob/living/simple_animal/hostile/savik,
				prob(33);/mob/living/simple_animal/hostile/giant_spider/frost,
				prob(45);/mob/living/simple_animal/hostile/shantak)

/obj/random/mob/spider
	name = "Random Spider" //Spiders should patrol where they spawn.
	desc = "This is a random boring spider."
	icon_state = "guard"

	mob_returns_home = 1
	mob_wander_distance = 4

/obj/random/mob/spider/item_to_spawn()
	return pick(prob(22);/mob/living/simple_animal/hostile/giant_spider/nurse,
				prob(33);/mob/living/simple_animal/hostile/giant_spider/hunter,
				prob(45);/mob/living/simple_animal/hostile/giant_spider)

/obj/random/mob/spider/nurse
	name = "Random Nurse Spider"
	desc = "This is a random nurse spider."
	icon_state = "nurse"

	mob_returns_home = 1
	mob_wander_distance = 4

/obj/random/mob/spider/nurse/item_to_spawn()
	return pick(prob(22);/mob/living/simple_animal/hostile/giant_spider/nurse/hat,
				prob(45);/mob/living/simple_animal/hostile/giant_spider/nurse)

/obj/random/mob/spider/mutant
	name = "Random Mutant Spider"
	desc = "This is a random mutated spider."
	icon_state = "phoron"

/obj/random/mob/spider/mutant/item_to_spawn()
	return pick(prob(5);/obj/random/mob/spider,
				prob(10);/mob/living/simple_animal/hostile/giant_spider/webslinger,
				prob(10);/mob/living/simple_animal/hostile/giant_spider/carrier,
				prob(33);/mob/living/simple_animal/hostile/giant_spider/lurker,
				prob(33);/mob/living/simple_animal/hostile/giant_spider/tunneler,
				prob(40);/mob/living/simple_animal/hostile/giant_spider/pepper,
				prob(20);/mob/living/simple_animal/hostile/giant_spider/thermic,
				prob(40);/mob/living/simple_animal/hostile/giant_spider/electric,
				prob(1);/mob/living/simple_animal/hostile/giant_spider/phorogenic,
				prob(40);/mob/living/simple_animal/hostile/giant_spider/frost)

/obj/random/mob/robotic
	name = "Random Robot Mob"
	desc = "This is a random robot."
	icon_state = "drone_dead"

	overwrite_hostility = 1

	mob_faction = "malf_drone"
	mob_returns_home = 1
	mob_wander = 1
	mob_wander_distance = 5
	mob_hostile = 1
	mob_retaliate = 1

/obj/random/mob/robotic/item_to_spawn() //Hivebots have a total number of 'lots' equal to the lesser drone, at 60.
	return pick(prob(60);/mob/living/simple_animal/hostile/malf_drone/lesser,
				prob(50);/mob/living/simple_animal/hostile/malf_drone,
				prob(15);/mob/living/simple_animal/hostile/mecha/malf_drone,
				prob(10);/mob/living/simple_animal/hostile/hivebot,
				prob(15);/mob/living/simple_animal/hostile/hivebot/swarm,
				prob(10);/mob/living/simple_animal/hostile/hivebot/range,
				prob(5);/mob/living/simple_animal/hostile/hivebot/range/rapid,
				prob(5);/mob/living/simple_animal/hostile/hivebot/range/ion,
				prob(5);/mob/living/simple_animal/hostile/hivebot/range/laser,
				prob(5);/mob/living/simple_animal/hostile/hivebot/range/strong,
				prob(5);/mob/living/simple_animal/hostile/hivebot/range/guard)

/obj/random/mob/robotic/hivebot
	name = "Random Hivebot"
	desc = "This is a random hivebot."
	icon_state = "drone3"

	mob_faction = "hivebot"

/obj/random/mob/robotic/hivebot/item_to_spawn()
	return pick(prob(10);/mob/living/simple_animal/hostile/hivebot,
				prob(15);/mob/living/simple_animal/hostile/hivebot/swarm,
				prob(10);/mob/living/simple_animal/hostile/hivebot/range,
				prob(5);/mob/living/simple_animal/hostile/hivebot/range/rapid,
				prob(5);/mob/living/simple_animal/hostile/hivebot/range/ion,
				prob(5);/mob/living/simple_animal/hostile/hivebot/range/laser,
				prob(5);/mob/living/simple_animal/hostile/hivebot/range/strong,
				prob(5);/mob/living/simple_animal/hostile/hivebot/range/guard)
