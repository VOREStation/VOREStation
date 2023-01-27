/*
 * Random Mobs
 */

/obj/random/mob
	name = "Random Animal"
	desc = "This is a random animal."
	icon_state = "animal"

	var/overwrite_hostility = 0

	var/mob_faction = null
	var/mob_returns_home = 0
	var/mob_wander = 1
	var/mob_wander_distance = 3
	var/mob_hostile = 0
	var/mob_retaliate = 0

/obj/random/mob/item_to_spawn()
	return pick(prob(10);/mob/living/simple_mob/animal/passive/lizard,
				prob(6);/mob/living/simple_mob/animal/sif/diyaab,
				prob(10);/mob/living/simple_mob/animal/passive/cat,
				prob(6);/mob/living/simple_mob/animal/passive/cat,
				prob(10);/mob/living/simple_mob/animal/passive/dog/corgi,
				prob(6);/mob/living/simple_mob/animal/passive/dog/corgi/puppy,
				prob(10);/mob/living/simple_mob/animal/passive/crab,
				prob(10);/mob/living/simple_mob/animal/passive/chicken,
				prob(6);/mob/living/simple_mob/animal/passive/chick,
				prob(10);/mob/living/simple_mob/animal/passive/cow,
				prob(6);/mob/living/simple_mob/animal/goat,
				prob(10);/mob/living/simple_mob/animal/passive/penguin,
				prob(10);/mob/living/simple_mob/animal/passive/mouse,
				prob(10);/mob/living/simple_mob/animal/passive/yithian,
				prob(10);/mob/living/simple_mob/animal/passive/tindalos,
				prob(10);/mob/living/simple_mob/animal/passive/pillbug,
				prob(10);/mob/living/simple_mob/animal/passive/dog/tamaskan,
				prob(10);/mob/living/simple_mob/animal/passive/dog/brittany,
				prob(3);/mob/living/simple_mob/animal/passive/bird/parrot,
				prob(1);/mob/living/simple_mob/animal/passive/crab)

/obj/random/mob/spawn_item() //These should only ever have simple mobs.
	var/build_path = item_to_spawn()

	var/mob/living/simple_mob/M = new build_path(src.loc)
	if(!istype(M))
		return
	if(M.has_AI())
		var/datum/ai_holder/AI = M.ai_holder
		AI.go_sleep() //Don't fight eachother while we're still setting up!
		AI.returns_home = mob_returns_home
		AI.wander = mob_wander
		AI.max_home_distance = mob_wander_distance
		if(overwrite_hostility)
			AI.hostile = mob_hostile
			AI.retaliate = mob_retaliate
		AI.go_wake() //Now you can kill eachother if your faction didn't override.

	if(pixel_x || pixel_y)
		M.pixel_x = pixel_x
		M.pixel_y = pixel_y

	if(mob_faction)
		M.faction = mob_faction



/obj/random/mob/sif
	name = "Random Sif Animal"
	desc = "This is a random cold weather animal."
	icon_state = "animal"

	mob_returns_home = 1
	mob_wander_distance = 10

/obj/random/mob/sif/item_to_spawn()
	return pick(prob(30);/mob/living/simple_mob/animal/sif/diyaab,
				prob(20);/mob/living/simple_mob/animal/passive/hare,
				prob(15);/mob/living/simple_mob/animal/passive/crab,
				prob(15);/mob/living/simple_mob/animal/passive/penguin,
				prob(15);/mob/living/simple_mob/animal/passive/mouse,
				prob(15);/mob/living/simple_mob/animal/passive/dog/tamaskan,
				prob(10);/mob/living/simple_mob/animal/sif/siffet,
				prob(2);/mob/living/simple_mob/animal/giant_spider/frost,
				prob(1);/mob/living/simple_mob/animal/space/goose,
				prob(20);/mob/living/simple_mob/animal/passive/crab)


/obj/random/mob/sif/peaceful
	name = "Random Peaceful Sif Animal"
	desc = "This is a random peaceful cold weather animal."
	icon_state = "animal_passive"

	mob_returns_home = 1
	mob_wander_distance = 12

/obj/random/mob/sif/peaceful/item_to_spawn()
	return pick(prob(30);/mob/living/simple_mob/animal/sif/diyaab,
				prob(20);/mob/living/simple_mob/animal/passive/hare,
				prob(15);/mob/living/simple_mob/animal/passive/crab,
				prob(15);/mob/living/simple_mob/animal/passive/penguin,
				prob(15);/mob/living/simple_mob/animal/passive/mouse,
				prob(15);/mob/living/simple_mob/animal/passive/dog/tamaskan,
				prob(20);/mob/living/simple_mob/animal/sif/hooligan_crab)

/obj/random/mob/sif/hostile
	name = "Random Hostile Sif Animal"
	desc = "This is a random hostile cold weather animal."
	icon_state = "animal_hostile"

/obj/random/mob/sif/hostile/item_to_spawn()
	return pick(prob(22);/mob/living/simple_mob/animal/sif/savik,
				prob(33);/mob/living/simple_mob/animal/giant_spider/frost,
				prob(20);/mob/living/simple_mob/animal/sif/frostfly,
				prob(10);/mob/living/simple_mob/animal/sif/tymisian,
				prob(45);/mob/living/simple_mob/animal/sif/shantak)

/obj/random/mob/sif/kururak
	name = "Random Kururak"
	desc = "This is a random kururak, either waking or hibernating. Will be hostile if more than one are waking."
	icon_state = "frost"

/obj/random/mob/sif/kururak/item_to_spawn()
	return pick(prob(1);/mob/living/simple_mob/animal/sif/kururak/hibernate,
				prob(20);/mob/living/simple_mob/animal/sif/kururak)

/obj/random/mob/spider
	name = "Random Spider" //Spiders should patrol where they spawn.
	desc = "This is a random boring spider."
	icon_state = "guard"

	mob_returns_home = 1
	mob_wander_distance = 4

/obj/random/mob/spider/item_to_spawn()
	return pick(prob(22);/mob/living/simple_mob/animal/giant_spider/nurse,
				prob(33);/mob/living/simple_mob/animal/giant_spider/hunter,
				prob(45);/mob/living/simple_mob/animal/giant_spider)

/obj/random/mob/spider/nurse
	name = "Random Nurse Spider"
	desc = "This is a random nurse spider."
	icon_state = "nurse"

	mob_returns_home = 1
	mob_wander_distance = 4

/obj/random/mob/spider/nurse/item_to_spawn()
	return pick(prob(22);/mob/living/simple_mob/animal/giant_spider/nurse/hat,
				prob(45);/mob/living/simple_mob/animal/giant_spider/nurse)

/obj/random/mob/spider/mutant
	name = "Random Mutant Spider"
	desc = "This is a random mutated spider."
	icon_state = "phoron"

/obj/random/mob/spider/mutant/item_to_spawn()
	return pick(prob(5);/obj/random/mob/spider,
				prob(10);/mob/living/simple_mob/animal/giant_spider/webslinger,
				prob(10);/mob/living/simple_mob/animal/giant_spider/carrier,
				prob(33);/mob/living/simple_mob/animal/giant_spider/lurker,
				prob(33);/mob/living/simple_mob/animal/giant_spider/tunneler,
				prob(40);/mob/living/simple_mob/animal/giant_spider/pepper,
				prob(20);/mob/living/simple_mob/animal/giant_spider/thermic,
				prob(40);/mob/living/simple_mob/animal/giant_spider/electric,
				prob(1);/mob/living/simple_mob/animal/giant_spider/phorogenic,
				prob(40);/mob/living/simple_mob/animal/giant_spider/frost)

/obj/random/mob/robotic
	name = "Random Robot Mob"
	desc = "This is a random robot."
	icon_state = "robot"

	overwrite_hostility = 1

	mob_faction = "malf_drone"
	mob_returns_home = 1
	mob_wander = 1
	mob_wander_distance = 5
	mob_hostile = 1
	mob_retaliate = 1

/obj/random/mob/robotic/item_to_spawn() //Hivebots have a total number of 'lots' equal to the lesser drone, at 60.
	return pick(prob(60);/mob/living/simple_mob/mechanical/combat_drone/lesser,
				prob(50);/mob/living/simple_mob/mechanical/combat_drone,
				prob(50);/mob/living/simple_mob/mechanical/mining_drone,
				prob(15);/mob/living/simple_mob/mechanical/mecha/ripley,
				prob(15);/mob/living/simple_mob/mechanical/mecha/odysseus,
				prob(10);/mob/living/simple_mob/mechanical/hivebot,
				prob(15);/mob/living/simple_mob/mechanical/hivebot/swarm,
				prob(10);/mob/living/simple_mob/mechanical/hivebot/ranged_damage,
				prob(5);/mob/living/simple_mob/mechanical/hivebot/ranged_damage/rapid,
				prob(5);/mob/living/simple_mob/mechanical/hivebot/ranged_damage/ion,
				prob(5);/mob/living/simple_mob/mechanical/hivebot/ranged_damage/laser,
				prob(5);/mob/living/simple_mob/mechanical/hivebot/ranged_damage/strong,
				prob(5);/mob/living/simple_mob/mechanical/hivebot/ranged_damage/strong/guard)

/obj/random/mob/robotic/drone
	name = "Random Drone"
	desc = "This is a random drone."
	icon_state = "drone_dead"

	overwrite_hostility = 1

	mob_faction = "malf_drone"
	mob_returns_home = 1
	mob_wander = 1
	mob_wander_distance = 5
	mob_hostile = 1
	mob_retaliate = 1

/obj/random/mob/robotic/drone/item_to_spawn()
	return pick(prob(6);/mob/living/simple_mob/mechanical/combat_drone/lesser,
				prob(1);/mob/living/simple_mob/mechanical/combat_drone,
				prob(3);/mob/living/simple_mob/mechanical/mining_drone)

/obj/random/mob/robotic/hivebot
	name = "Random Hivebot"
	desc = "This is a random hivebot."
	icon_state = "robot"

	mob_faction = "hivebot"

/obj/random/mob/robotic/hivebot/item_to_spawn()
	return pick(prob(10);/mob/living/simple_mob/mechanical/hivebot,
				prob(15);/mob/living/simple_mob/mechanical/hivebot/swarm,
				prob(10);/mob/living/simple_mob/mechanical/hivebot/ranged_damage,
				prob(5);/mob/living/simple_mob/mechanical/hivebot/ranged_damage/rapid,
				prob(5);/mob/living/simple_mob/mechanical/hivebot/ranged_damage/ion,
				prob(5);/mob/living/simple_mob/mechanical/hivebot/ranged_damage/laser,
				prob(5);/mob/living/simple_mob/mechanical/hivebot/ranged_damage/strong,
				prob(5);/mob/living/simple_mob/mechanical/hivebot/ranged_damage/strong/guard)

//Mice

/obj/random/mob/mouse
	name = "Random Mouse"
	desc = "This is a random boring maus."
	icon_state = "mouse"
	spawn_nothing_percentage = 15

/obj/random/mob/mouse/item_to_spawn()
	return pick(prob(15);/mob/living/simple_mob/animal/passive/mouse/white,
				prob(15);/mob/living/simple_mob/animal/passive/mouse/black,
				prob(30);/mob/living/simple_mob/animal/passive/mouse/brown,
				prob(30);/mob/living/simple_mob/animal/passive/mouse/gray,
				prob(30);/mob/living/simple_mob/animal/passive/mouse/rat)

/obj/random/mob/fish
	name = "Random Fish"
	desc = "This is a random fish found on Sif."
	icon_state = "fish"
	mob_faction = "fish"
	overwrite_hostility = 1
	mob_hostile = 0
	mob_retaliate = 0

/obj/random/mob/fish/item_to_spawn()
	return pick(prob(10);/mob/living/simple_mob/animal/passive/fish/bass,
				prob(20);/mob/living/simple_mob/animal/passive/fish/icebass,
				prob(20);/mob/living/simple_mob/animal/passive/fish/trout,
				prob(20);/mob/living/simple_mob/animal/passive/fish/salmon,
				prob(10);/mob/living/simple_mob/animal/passive/fish/pike,
				prob(10);/mob/living/simple_mob/animal/passive/fish/perch,
				prob(20);/mob/living/simple_mob/animal/passive/fish/murkin,
				prob(15);/mob/living/simple_mob/animal/passive/fish/javelin,
				prob(20);/mob/living/simple_mob/animal/passive/fish/rockfish,
				prob(5);/mob/living/simple_mob/animal/passive/fish/solarfish,
				prob(10);/mob/living/simple_mob/animal/passive/crab,
				prob(1);/mob/living/simple_mob/animal/sif/hooligan_crab)

/obj/random/mob/bird
	name = "Random Bird"
	desc = "This is a random wild/feral bird."
	icon_state = "bird"
	mob_faction = "bird"

/obj/random/mob/bird/item_to_spawn()
	return pick(prob(10);/mob/living/simple_mob/animal/passive/bird/black_bird,
				prob(10);/mob/living/simple_mob/animal/passive/bird/azure_tit,
				prob(20);/mob/living/simple_mob/animal/passive/bird/european_robin,
				prob(10);/mob/living/simple_mob/animal/passive/bird/goldcrest,
				prob(20);/mob/living/simple_mob/animal/passive/bird/ringneck_dove,
				prob(10);/mob/living/simple_mob/animal/space/goose,
				prob(5);/mob/living/simple_mob/animal/passive/chicken,
				prob(1);/mob/living/simple_mob/animal/passive/penguin)

// Mercs
/obj/random/mob/merc
	name = "Random Mercenary"
	desc = "This is a random PoI mercenary."
	icon_state = "humanoid"

	mob_faction = "syndicate"
	mob_returns_home = 1
	mob_wander_distance = 7	// People like to wander, and these people probably have a lot of stuff to guard.

/obj/random/mob/merc/item_to_spawn()
	return pick(prob(60);/mob/living/simple_mob/humanoid/merc/melee/poi,
				prob(40);/mob/living/simple_mob/humanoid/merc/melee/sword/poi,
				prob(40);/mob/living/simple_mob/humanoid/merc/ranged/poi,
				prob(30);/mob/living/simple_mob/humanoid/merc/ranged/smg/poi,
				prob(20);/mob/living/simple_mob/humanoid/merc/ranged/laser/poi,
				prob(5);/mob/living/simple_mob/humanoid/merc/ranged/ionrifle/poi,
				prob(10);/mob/living/simple_mob/humanoid/merc/ranged/grenadier/poi,
				prob(10);/mob/living/simple_mob/humanoid/merc/ranged/rifle/poi,
				prob(15);/mob/living/simple_mob/humanoid/merc/ranged/rifle/mag/poi,
				prob(10);/mob/living/simple_mob/humanoid/merc/ranged/technician/poi
				)

/obj/random/mob/merc/armored
	name = "Random Armored Infantry Merc"
	desc = "This is a random PoI exo or robot for mercs."
	icon_state = "mecha"

/obj/random/mob/merc/armored/item_to_spawn()
	return pick(prob(30);/mob/living/simple_mob/mechanical/mecha/combat/gygax/dark,
				prob(40);/mob/living/simple_mob/mechanical/mecha/combat/gygax/medgax,
				prob(40);/mob/living/simple_mob/mechanical/mecha/combat/gygax,
				prob(10);/mob/living/simple_mob/mechanical/mecha/combat/durand/defensive/mercenary,
				prob(60);/mob/living/simple_mob/mechanical/mecha/hoverpod/manned,
				prob(5);/mob/living/simple_mob/mechanical/mecha/combat/marauder,
				prob(1);/mob/living/simple_mob/mechanical/mecha/combat/marauder/seraph,
				prob(15);/mob/living/simple_mob/mechanical/mecha/odysseus/manned,
				prob(15);/mob/living/simple_mob/mechanical/mecha/odysseus/murdysseus/manned,
				prob(60);/mob/living/simple_mob/mechanical/mecha/ripley/manned
				)

/obj/random/mob/merc/all
	name = "Random Mercenary All"
	desc = "A random PoI mercenary, including armored."

/obj/random/mob/merc/all/item_to_spawn()
	return pick(prob(20);/obj/random/mob/merc,
				prob(1);/obj/random/mob/merc/armored
				)

// Multiple mobs, one spawner.
/obj/random/mob/multiple
	name = "Random Multiple Mob Spawner"
	desc = "A base multiple-mob spawner. Takes lists of lists."

/obj/random/mob/multiple/spawn_item()
	var/list/things_to_make = item_to_spawn()

	for(var/new_type in things_to_make)

		var/mob/living/simple_mob/M = new new_type(src.loc)

		if(!istype(M))
			continue

		if(M.has_AI())
			var/datum/ai_holder/AI = M.ai_holder
			AI.go_sleep() //Don't fight eachother while we're still setting up!
			AI.returns_home = mob_returns_home
			AI.wander = mob_wander
			AI.max_home_distance = mob_wander_distance
			if(overwrite_hostility)
				AI.hostile = mob_hostile
				AI.retaliate = mob_retaliate
			AI.go_wake() //Now you can kill eachother if your faction didn't override.

		if(pixel_x || pixel_y)
			M.pixel_x = pixel_x
			M.pixel_y = pixel_y

/obj/random/mob/multiple/sifmobs
	name = "Random Sifmob Pack"
	desc = "A pack of random neutral sif mobs."
	icon_state = "animal_group"

/obj/random/mob/multiple/sifmobs/item_to_spawn()
	return pick(
			prob(60);list(
				/mob/living/simple_mob/animal/sif/diyaab,
				/mob/living/simple_mob/animal/sif/diyaab,
				/mob/living/simple_mob/animal/sif/diyaab
			),
			prob(15);list(
				/mob/living/simple_mob/animal/sif/duck,
				/mob/living/simple_mob/animal/sif/duck,
				/mob/living/simple_mob/animal/sif/duck
			),
			prob(15);list(
				/mob/living/simple_mob/animal/passive/hare,
				/mob/living/simple_mob/animal/passive/hare,
				/mob/living/simple_mob/animal/passive/hare,
				/mob/living/simple_mob/animal/passive/hare
			),
			prob(10);list(
				/mob/living/simple_mob/animal/sif/shantak/retaliate,
				/mob/living/simple_mob/animal/sif/shantak/retaliate,
				/mob/living/simple_mob/animal/sif/shantak/retaliate,
				/mob/living/simple_mob/animal/sif/shantak/leader/autofollow/retaliate
			),
			prob(5);list(
				/mob/living/simple_mob/animal/sif/kururak/leader,
				/mob/living/simple_mob/animal/sif/kururak,
				/mob/living/simple_mob/animal/sif/kururak
			),
			prob(5);list(
				/mob/living/simple_mob/animal/sif/glitterfly,
				/mob/living/simple_mob/animal/sif/glitterfly,
				/mob/living/simple_mob/animal/sif/glitterfly,
				/mob/living/simple_mob/animal/sif/glitterfly,
				/mob/living/simple_mob/animal/sif/glitterfly
			),
			prob(1);list(
				/mob/living/simple_mob/animal/goat,
				/mob/living/simple_mob/animal/goat
			),
			prob(1);list(
				/mob/living/simple_mob/animal/sif/sakimm/intelligent,
				/mob/living/simple_mob/animal/sif/sakimm,
				/mob/living/simple_mob/animal/sif/sakimm,
				/mob/living/simple_mob/animal/sif/sakimm
			)
		)
