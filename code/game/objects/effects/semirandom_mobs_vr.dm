var/global/list/semirandom_mob_spawner_decisions = list()

/obj/random/mob/semirandom_mob_spawner
	name = "Semi-Random Spawner"
	desc = "Spawns groups of mobs that are all of the same theme type/theme."
	icon = 'icons/mob/randomlandmarks.dmi'
	icon_state = "monster"
	mob_returns_home = 1
	mob_wander_distance = 7

	var/list/possible_mob_types = list(
		list(/mob/living/simple_mob/animal/goat),
		list(
			/mob/living/simple_mob/animal/passive/bird,
			/mob/living/simple_mob/animal/passive/bird/azure_tit,
			/mob/living/simple_mob/animal/passive/bird/black_bird,
			/mob/living/simple_mob/animal/passive/bird/european_robin,
			/mob/living/simple_mob/animal/passive/bird/goldcrest,
			/mob/living/simple_mob/animal/passive/bird/ringneck_dove,
			/mob/living/simple_mob/animal/passive/bird/parrot,
			/mob/living/simple_mob/animal/passive/bird/parrot/black_headed_caique,
			/mob/living/simple_mob/animal/passive/bird/parrot/budgerigar,
			/mob/living/simple_mob/animal/passive/bird/parrot/budgerigar/blue,
			/mob/living/simple_mob/animal/passive/bird/parrot/budgerigar/bluegreen,
			/mob/living/simple_mob/animal/passive/bird/parrot/cockatiel,
			/mob/living/simple_mob/animal/passive/bird/parrot/cockatiel/grey,
			/mob/living/simple_mob/animal/passive/bird/parrot/cockatiel/white,
			/mob/living/simple_mob/animal/passive/bird/parrot/cockatiel/yellowish,
			/mob/living/simple_mob/animal/passive/bird/parrot/eclectus,
			/mob/living/simple_mob/animal/passive/bird/parrot/grey_parrot,
			/mob/living/simple_mob/animal/passive/bird/parrot/kea,
			/mob/living/simple_mob/animal/passive/bird/parrot/pink_cockatoo,
			/mob/living/simple_mob/animal/passive/bird/parrot/sulphur_cockatoo,
			/mob/living/simple_mob/animal/passive/bird/parrot/white_caique,
			/mob/living/simple_mob/animal/passive/bird/parrot/white_cockatoo
		),
		list(
			/mob/living/simple_mob/animal/passive/cat,
			/mob/living/simple_mob/animal/passive/cat/black
		),
		list(/mob/living/simple_mob/animal/passive/chick),
		list(/mob/living/simple_mob/animal/passive/cow),
		list(/mob/living/simple_mob/animal/passive/dog/brittany),
		list(/mob/living/simple_mob/animal/passive/dog/corgi),
		list(/mob/living/simple_mob/animal/passive/dog/tamaskan),
		list(/mob/living/simple_mob/animal/passive/fox),
		list(/mob/living/simple_mob/animal/passive/hare),
		list(/mob/living/simple_mob/animal/passive/lizard),
		list(/mob/living/simple_mob/animal/passive/mouse),
		list(/mob/living/simple_mob/animal/passive/mouse/jerboa),
		list(/mob/living/simple_mob/animal/passive/opossum),
		list(/mob/living/simple_mob/animal/passive/pillbug),
		list(/mob/living/simple_mob/animal/passive/snake),
		list(/mob/living/simple_mob/animal/passive/snake/red),
		list(/mob/living/simple_mob/animal/passive/snake/python),
		list(/mob/living/simple_mob/animal/passive/tindalos),
		list(/mob/living/simple_mob/animal/passive/yithian),
		list(
			/mob/living/simple_mob/vore/wolf = 10,
			/mob/living/simple_mob/vore/wolf/direwolf = 5,
			/mob/living/simple_mob/vore/greatwolf = 1,
			/mob/living/simple_mob/vore/greatwolf/black = 1,
			/mob/living/simple_mob/vore/greatwolf/grey = 1
			),
		list(/mob/living/simple_mob/vore/rabbit),
		list(/mob/living/simple_mob/vore/redpanda),
		list(/mob/living/simple_mob/vore/woof),
		list(/mob/living/simple_mob/vore/fennec),
		list(/mob/living/simple_mob/vore/fennix),
		list(/mob/living/simple_mob/vore/hippo),
		list(/mob/living/simple_mob/vore/horse),
		list(/mob/living/simple_mob/vore/bee),
		list(
			/mob/living/simple_mob/animal/space/bear,
			/mob/living/simple_mob/animal/space/bear/brown
			),
		list(
			/mob/living/simple_mob/vore/otie/feral,
			/mob/living/simple_mob/vore/otie/feral/chubby,
			/mob/living/simple_mob/vore/otie/red,
			/mob/living/simple_mob/vore/otie/red/chubby
			),
		list(/mob/living/simple_mob/animal/sif/diyaab),
		list(/mob/living/simple_mob/animal/sif/duck),
		list(/mob/living/simple_mob/animal/sif/frostfly),
		list(
			/mob/living/simple_mob/animal/sif/glitterfly =50,
			/mob/living/simple_mob/animal/sif/glitterfly/rare = 1
			),
		list(
			/mob/living/simple_mob/animal/sif/kururak = 10,
			/mob/living/simple_mob/animal/sif/kururak/leader = 1,
			/mob/living/simple_mob/animal/sif/kururak/hibernate = 2,
			),
		list(
			/mob/living/simple_mob/animal/sif/sakimm = 10,
			/mob/living/simple_mob/animal/sif/sakimm/intelligent = 1
			),
		list(/mob/living/simple_mob/animal/sif/savik) = 5,
		list(
			/mob/living/simple_mob/animal/sif/shantak = 10,
			/mob/living/simple_mob/animal/sif/shantak/leader = 1
			),
		list(/mob/living/simple_mob/animal/sif/siffet),
		list(/mob/living/simple_mob/animal/sif/tymisian),
		list(
			/mob/living/simple_mob/animal/giant_spider/nurse = 10,
			/mob/living/simple_mob/animal/giant_spider/electric = 5,
			/mob/living/simple_mob/animal/giant_spider/frost = 5,
			/mob/living/simple_mob/animal/giant_spider/hunter = 10,
			/mob/living/simple_mob/animal/giant_spider/ion = 5,
			/mob/living/simple_mob/animal/giant_spider/lurker = 10,
			/mob/living/simple_mob/animal/giant_spider/pepper = 10,
			/mob/living/simple_mob/animal/giant_spider/phorogenic = 10,
			/mob/living/simple_mob/animal/giant_spider/thermic = 5,
			/mob/living/simple_mob/animal/giant_spider/tunneler = 10,
			/mob/living/simple_mob/animal/giant_spider/webslinger = 5,
			/mob/living/simple_mob/animal/giant_spider/broodmother = 1),
		list(/mob/living/simple_mob/creature/strong),
		list(/mob/living/simple_mob/faithless/strong),
		list(/mob/living/simple_mob/animal/goat),
		list(
			/mob/living/simple_mob/animal/sif/shantak/leader = 1,
			/mob/living/simple_mob/animal/sif/shantak = 10),
		list(/mob/living/simple_mob/animal/sif/savik,),
		list(/mob/living/simple_mob/animal/sif/hooligan_crab),
		list(
			/mob/living/simple_mob/animal/space/alien = 50,
			/mob/living/simple_mob/animal/space/alien/drone = 40,
			/mob/living/simple_mob/animal/space/alien/sentinel = 25,
			/mob/living/simple_mob/animal/space/alien/sentinel/praetorian = 15,
			/mob/living/simple_mob/animal/space/alien/queen = 10,
			/mob/living/simple_mob/animal/space/alien/queen/empress = 5,
			/mob/living/simple_mob/animal/space/alien/queen/empress/mother = 1
			),
		list(/mob/living/simple_mob/animal/space/bats/cult/strong),
		list(
			/mob/living/simple_mob/animal/space/bear,
			/mob/living/simple_mob/animal/space/bear/brown
			),
		list(
			/mob/living/simple_mob/animal/space/carp = 50,
			/mob/living/simple_mob/animal/space/carp/large = 10,
			/mob/living/simple_mob/animal/space/carp/large/huge = 5
			),
		list(/mob/living/simple_mob/animal/space/goose),
		list(/mob/living/simple_mob/vore/jelly),
		list(/mob/living/simple_mob/animal/space/tree),
		list(
			/mob/living/simple_mob/vore/aggressive/corrupthound = 10,
			/mob/living/simple_mob/vore/aggressive/corrupthound/prettyboi = 1,
			),
		list(/mob/living/simple_mob/vore/aggressive/deathclaw),
		list(/mob/living/simple_mob/vore/aggressive/dino),
		list(/mob/living/simple_mob/vore/aggressive/dragon),
		list(/mob/living/simple_mob/vore/aggressive/dragon/virgo3b),
		list(/mob/living/simple_mob/vore/aggressive/frog),
		list(/mob/living/simple_mob/vore/aggressive/giant_snake),
		list(/mob/living/simple_mob/vore/aggressive/mimic),
		list(/mob/living/simple_mob/vore/aggressive/panther),
		list(/mob/living/simple_mob/vore/aggressive/rat),
		list(/mob/living/simple_mob/vore/bee),
		list(
			/mob/living/simple_mob/vore/sect_drone = 10,
			/mob/living/simple_mob/vore/sect_queen = 1
			),
		list(/mob/living/simple_mob/vore/solargrub),
		list(
			/mob/living/simple_mob/vore/oregrub = 5,
			/mob/living/simple_mob/vore/oregrub/lava = 1
			),
		list(/mob/living/simple_mob/vore/catgirl),
		list(/mob/living/simple_mob/vore/wolfgirl),
		list(
			/mob/living/simple_mob/vore/lamia,
			/mob/living/simple_mob/vore/lamia/albino,
			/mob/living/simple_mob/vore/lamia/albino/bra,
			/mob/living/simple_mob/vore/lamia/albino/shirt,
			/mob/living/simple_mob/vore/lamia/bra,
			/mob/living/simple_mob/vore/lamia/cobra,
			/mob/living/simple_mob/vore/lamia/cobra/bra,
			/mob/living/simple_mob/vore/lamia/cobra/shirt,
			/mob/living/simple_mob/vore/lamia/copper,
			/mob/living/simple_mob/vore/lamia/copper/bra,
			/mob/living/simple_mob/vore/lamia/copper/shirt,
			/mob/living/simple_mob/vore/lamia/green,
			/mob/living/simple_mob/vore/lamia/green/bra,
			/mob/living/simple_mob/vore/lamia/green/shirt,
			/mob/living/simple_mob/vore/lamia/zebra,
			/mob/living/simple_mob/vore/lamia/zebra/bra,
			/mob/living/simple_mob/vore/lamia/zebra/shirt
			),
		list(
			/mob/living/simple_mob/humanoid/merc = 100,
			/mob/living/simple_mob/humanoid/merc/melee/sword = 50,
			/mob/living/simple_mob/humanoid/merc/ranged = 25,
			/mob/living/simple_mob/humanoid/merc/ranged/grenadier = 1,
			/mob/living/simple_mob/humanoid/merc/ranged/ionrifle = 10,
			/mob/living/simple_mob/humanoid/merc/ranged/laser = 5,
			/mob/living/simple_mob/humanoid/merc/ranged/rifle = 5,
			/mob/living/simple_mob/humanoid/merc/ranged/smg = 5,
			/mob/living/simple_mob/humanoid/merc/ranged/sniper = 1,
			/mob/living/simple_mob/humanoid/merc/ranged/space = 10,
			/mob/living/simple_mob/humanoid/merc/ranged/technician = 5
			),
		list(
			/mob/living/simple_mob/humanoid/pirate = 3,
			/mob/living/simple_mob/humanoid/pirate/ranged = 1
			),
		list(/mob/living/simple_mob/mechanical/combat_drone),
		list(/mob/living/simple_mob/mechanical/corrupt_maint_drone),
		list(
			/mob/living/simple_mob/mechanical/hivebot = 100,
			/mob/living/simple_mob/mechanical/hivebot/ranged_damage = 20,
			/mob/living/simple_mob/mechanical/hivebot/ranged_damage/backline = 10,
			/mob/living/simple_mob/mechanical/hivebot/ranged_damage/basic = 20,
			/mob/living/simple_mob/mechanical/hivebot/ranged_damage/dot = 5,
			/mob/living/simple_mob/mechanical/hivebot/ranged_damage/ion = 20,
			/mob/living/simple_mob/mechanical/hivebot/ranged_damage/laser = 10,
			/mob/living/simple_mob/mechanical/hivebot/ranged_damage/rapid = 2,
			/mob/living/simple_mob/mechanical/hivebot/ranged_damage/siege = 1,
			/mob/living/simple_mob/mechanical/hivebot/ranged_damage/siege/emp = 5,
			/mob/living/simple_mob/mechanical/hivebot/ranged_damage/siege/fragmentation = 1,
			/mob/living/simple_mob/mechanical/hivebot/ranged_damage/siege/radiation = 1,
			/mob/living/simple_mob/mechanical/hivebot/ranged_damage/strong = 3,
			/mob/living/simple_mob/mechanical/hivebot/ranged_damage/strong/guard = 3,
			/mob/living/simple_mob/mechanical/hivebot/support = 8,
			/mob/living/simple_mob/mechanical/hivebot/support/commander = 5,
			/mob/living/simple_mob/mechanical/hivebot/support/commander/autofollow = 10,
			/mob/living/simple_mob/mechanical/hivebot/swarm = 20,
			/mob/living/simple_mob/mechanical/hivebot/tank = 20,
			/mob/living/simple_mob/mechanical/hivebot/tank/armored = 20,
			/mob/living/simple_mob/mechanical/hivebot/tank/armored/anti_bullet = 20,
			/mob/living/simple_mob/mechanical/hivebot/tank/armored/anti_laser = 20,
			/mob/living/simple_mob/mechanical/hivebot/tank/armored/anti_melee = 20,
			/mob/living/simple_mob/mechanical/hivebot/tank/meatshield = 20
			),
		list(/mob/living/simple_mob/mechanical/infectionbot),
		list(/mob/living/simple_mob/mechanical/mining_drone),
		list(/mob/living/simple_mob/mechanical/technomancer_golem),
		list(
			/mob/living/simple_mob/mechanical/viscerator,
			/mob/living/simple_mob/mechanical/viscerator/piercing
			),
		list(/mob/living/simple_mob/mechanical/wahlem),
		list(/mob/living/simple_mob/animal/passive/fox/syndicate),
		list(/mob/living/simple_mob/animal/passive/fox),
		list(/mob/living/simple_mob/vore/jelly),
		list(
			/mob/living/simple_mob/vore/otie/feral,
			/mob/living/simple_mob/vore/otie/feral/chubby,
			/mob/living/simple_mob/vore/otie/red,
			/mob/living/simple_mob/vore/otie/red/chubby
			),
		list(
			/mob/living/simple_mob/shadekin/blue = 100,
			/mob/living/simple_mob/shadekin/green = 50,
			/mob/living/simple_mob/shadekin/orange = 20,
			/mob/living/simple_mob/shadekin/purple = 60,
			/mob/living/simple_mob/shadekin/red = 40,
			/mob/living/simple_mob/shadekin/yellow = 1
			),
		list(
			/mob/living/simple_mob/vore/aggressive/corrupthound,
			/mob/living/simple_mob/vore/aggressive/corrupthound/prettyboi
			),
		list(/mob/living/simple_mob/vore/aggressive/deathclaw),
		list(/mob/living/simple_mob/vore/aggressive/dino),
		list(/mob/living/simple_mob/vore/aggressive/dragon),
		list(/mob/living/simple_mob/vore/aggressive/dragon/virgo3b),
		list(/mob/living/simple_mob/vore/aggressive/frog),
		list(/mob/living/simple_mob/vore/aggressive/giant_snake),
		list(/mob/living/simple_mob/vore/aggressive/mimic),
		list(/mob/living/simple_mob/vore/aggressive/panther),
		list(/mob/living/simple_mob/vore/aggressive/rat),
		list(/mob/living/simple_mob/vore/bee),
		list(/mob/living/simple_mob/vore/catgirl),
		list(/mob/living/simple_mob/vore/cookiegirl),
		list(/mob/living/simple_mob/vore/fennec),
		list(/mob/living/simple_mob/vore/fennix),
		list(/mob/living/simple_mob/vore/hippo),
		list(/mob/living/simple_mob/vore/horse),
		list(/mob/living/simple_mob/vore/oregrub),
		list(/mob/living/simple_mob/vore/rabbit),
		list(
			/mob/living/simple_mob/vore/redpanda = 50,
			/mob/living/simple_mob/vore/redpanda/fae = 1
			),
		list(
			/mob/living/simple_mob/vore/sect_drone = 10,
			/mob/living/simple_mob/vore/sect_queen = 1
			),
		list(/mob/living/simple_mob/vore/solargrub),
		list(/mob/living/simple_mob/vore/woof),
		list(/mob/living/simple_mob/vore/alienanimals/space_ghost),
		list(/mob/living/simple_mob/vore/alienanimals/catslug),
		list(/mob/living/simple_mob/vore/alienanimals/space_jellyfish),
		list(/mob/living/simple_mob/vore/alienanimals/startreader),
		list(
			/mob/living/simple_mob/vore/bigdragon,
			/mob/living/simple_mob/vore/bigdragon/friendly),
		list(
			/mob/living/simple_mob/vore/leopardmander = 50,
			/mob/living/simple_mob/vore/leopardmander/blue = 10,
			/mob/living/simple_mob/vore/leopardmander/exotic = 1
			),
		list(/mob/living/simple_mob/vore/sheep),
		list(/mob/living/simple_mob/vore/weretiger)
		)

/obj/random/mob/semirandom_mob_spawner/item_to_spawn()
	var/list/choice = semirandom_mob_spawner_decisions[type]

	if(!choice)
		choice = pickweight(possible_mob_types)
		semirandom_mob_spawner_decisions[type] = choice

	return pickweight(choice)

/obj/random/mob/semirandom_mob_spawner/animal
	name = "Semi-Random Animal"
	desc = "Spawns groups of non-hostile mobs that are all of the same theme type/theme."
	icon_state = "animal"
	mob_faction = "animal"
	overwrite_hostility = 1
	mob_hostile = 0

	possible_mob_types = list(
		list(/mob/living/simple_mob/animal/goat) = 25,
		list(
			/mob/living/simple_mob/animal/passive/bird,
			/mob/living/simple_mob/animal/passive/bird/azure_tit,
			/mob/living/simple_mob/animal/passive/bird/black_bird,
			/mob/living/simple_mob/animal/passive/bird/european_robin,
			/mob/living/simple_mob/animal/passive/bird/goldcrest,
			/mob/living/simple_mob/animal/passive/bird/ringneck_dove,
			/mob/living/simple_mob/animal/passive/bird/parrot,
			/mob/living/simple_mob/animal/passive/bird/parrot/black_headed_caique,
			/mob/living/simple_mob/animal/passive/bird/parrot/budgerigar,
			/mob/living/simple_mob/animal/passive/bird/parrot/budgerigar/blue,
			/mob/living/simple_mob/animal/passive/bird/parrot/budgerigar/bluegreen,
			/mob/living/simple_mob/animal/passive/bird/parrot/cockatiel,
			/mob/living/simple_mob/animal/passive/bird/parrot/cockatiel/grey,
			/mob/living/simple_mob/animal/passive/bird/parrot/cockatiel/white,
			/mob/living/simple_mob/animal/passive/bird/parrot/cockatiel/yellowish,
			/mob/living/simple_mob/animal/passive/bird/parrot/eclectus,
			/mob/living/simple_mob/animal/passive/bird/parrot/grey_parrot,
			/mob/living/simple_mob/animal/passive/bird/parrot/kea,
			/mob/living/simple_mob/animal/passive/bird/parrot/pink_cockatoo,
			/mob/living/simple_mob/animal/passive/bird/parrot/sulphur_cockatoo,
			/mob/living/simple_mob/animal/passive/bird/parrot/white_caique,
			/mob/living/simple_mob/animal/passive/bird/parrot/white_cockatoo,
			/mob/living/simple_mob/animal/space/goose
			) = 25,
		list(
			/mob/living/simple_mob/animal/passive/cat,
			/mob/living/simple_mob/animal/passive/cat/black
			) = 25,
		list(
			/mob/living/simple_mob/animal/passive/chick,
			/mob/living/simple_mob/animal/passive/chicken
			) = 25,
		list(/mob/living/simple_mob/animal/passive/cow) = 25,
		list(/mob/living/simple_mob/animal/passive/dog/brittany) = 10,
		list(/mob/living/simple_mob/animal/passive/dog/corgi) = 10,
		list(/mob/living/simple_mob/animal/passive/dog/tamaskan) = 10,
		list(/mob/living/simple_mob/animal/passive/fox) = 25,
		list(/mob/living/simple_mob/animal/passive/hare) = 25,
		list(/mob/living/simple_mob/animal/passive/lizard) = 10,
		list(/mob/living/simple_mob/animal/passive/mouse) = 15,
		list(/mob/living/simple_mob/animal/passive/mouse/jerboa) = 5,
		list(/mob/living/simple_mob/animal/passive/opossum) = 10,
		list(/mob/living/simple_mob/animal/passive/pillbug) = 10,
		list(/mob/living/simple_mob/animal/passive/snake) = 10,
		list(/mob/living/simple_mob/animal/passive/snake/red) = 10,
		list(/mob/living/simple_mob/animal/passive/snake/python) = 10,
		list(/mob/living/simple_mob/animal/passive/tindalos) = 10,
		list(/mob/living/simple_mob/animal/passive/yithian) = 10,
		list(
			/mob/living/simple_mob/vore/wolf = 10,
			/mob/living/simple_mob/vore/wolf/direwolf = 5,
			/mob/living/simple_mob/vore/greatwolf = 1,
			/mob/living/simple_mob/vore/greatwolf/black = 1,
			/mob/living/simple_mob/vore/greatwolf/grey = 1
			) = 10,
		list(/mob/living/simple_mob/vore/rabbit) = 10,
		list(/mob/living/simple_mob/vore/redpanda) = 10,
		list(/mob/living/simple_mob/vore/woof) = 1,
		list(/mob/living/simple_mob/vore/fennec) = 10,
		list(/mob/living/simple_mob/vore/fennix) = 1,
		list(/mob/living/simple_mob/vore/hippo) = 5,
		list(/mob/living/simple_mob/vore/horse) = 25,
		list(/mob/living/simple_mob/vore/bee) = 10,
		list(
			/mob/living/simple_mob/animal/space/bear,
			/mob/living/simple_mob/animal/space/bear/brown
			) = 1,
		list(
			/mob/living/simple_mob/vore/otie/feral = 50,
			/mob/living/simple_mob/vore/otie/feral/chubby = 10,
			/mob/living/simple_mob/vore/otie/red = 5,
			/mob/living/simple_mob/vore/otie/red/chubby = 1
			) = 5,
		list(/mob/living/simple_mob/vore/aggressive/rat) = 15,
		list(/mob/living/simple_mob/animal/sif/diyaab) = 5,
		list(/mob/living/simple_mob/animal/sif/duck) = 5,
		list(/mob/living/simple_mob/animal/sif/frostfly) = 5,
		list(
			/mob/living/simple_mob/animal/sif/glitterfly = 50,
			/mob/living/simple_mob/animal/sif/glitterfly/rare = 1
			) = 5,
		list(
			/mob/living/simple_mob/animal/sif/kururak = 10,
			/mob/living/simple_mob/animal/sif/kururak/leader = 1,
			/mob/living/simple_mob/animal/sif/kururak/hibernate = 2,
			) = 5,
		list(
			/mob/living/simple_mob/animal/sif/sakimm = 10,
			/mob/living/simple_mob/animal/sif/sakimm/intelligent = 1
			) = 5,
		list(/mob/living/simple_mob/animal/sif/savik) = 5,
		list(
			/mob/living/simple_mob/animal/sif/shantak = 10,
			/mob/living/simple_mob/animal/sif/shantak/leader = 1
			) = 5,
		list(/mob/living/simple_mob/animal/sif/siffet) = 5,
		list(/mob/living/simple_mob/animal/sif/tymisian) = 5,
		list(/mob/living/simple_mob/vore/alienanimals/dustjumper) = 5,
		list(/mob/living/simple_mob/vore/alienanimals/space_jellyfish) = 5,
		list(/mob/living/simple_mob/vore/alienanimals/space_ghost) = 5,
		list(
			/mob/living/simple_mob/vore/leopardmander = 50,
			/mob/living/simple_mob/vore/leopardmander/blue = 10,
			/mob/living/simple_mob/vore/leopardmander/exotic = 1
			) = 5,
		list(/mob/living/simple_mob/vore/sheep) = 5,
		list(/mob/living/simple_mob/vore/weretiger) = 5,
		list(/mob/living/simple_mob/vore/alienanimals/skeleton) = 5
	)

/obj/random/mob/semirandom_mob_spawner/monster
	name = "Semi-Random Monster"
	desc = "Spawns groups of hostile mobs that are all of the same theme type/theme."
	overwrite_hostility = 1
	mob_faction = "monster"
	mob_hostile = 1
	mob_retaliate = 1

	possible_mob_types = list(
		list(
			/mob/living/simple_mob/animal/giant_spider/nurse = 10,
			/mob/living/simple_mob/animal/giant_spider/electric = 5,
			/mob/living/simple_mob/animal/giant_spider/frost = 5,
			/mob/living/simple_mob/animal/giant_spider/hunter = 10,
			/mob/living/simple_mob/animal/giant_spider/ion = 5,
			/mob/living/simple_mob/animal/giant_spider/lurker = 10,
			/mob/living/simple_mob/animal/giant_spider/pepper = 10,
			/mob/living/simple_mob/animal/giant_spider/phorogenic = 10,
			/mob/living/simple_mob/animal/giant_spider/thermic = 5,
			/mob/living/simple_mob/animal/giant_spider/tunneler = 10,
			/mob/living/simple_mob/animal/giant_spider/webslinger = 5
			) = 100,
		list(
			/mob/living/simple_mob/shadekin/red = 5,
			/mob/living/simple_mob/shadekin/orange = 1,
			/mob/living/simple_mob/shadekin/purple = 10
			) = 1,
		list(
			/mob/living/simple_mob/vore/wolf = 10,
			/mob/living/simple_mob/vore/wolf/direwolf = 5,
			/mob/living/simple_mob/vore/greatwolf = 1,
			/mob/living/simple_mob/vore/greatwolf/black = 1,
			/mob/living/simple_mob/vore/greatwolf/grey = 1
			) = 40,
		list(/mob/living/simple_mob/creature/strong) = 40,
		list(/mob/living/simple_mob/faithless/strong) = 20,
		list(/mob/living/simple_mob/animal/goat) = 1,
		list(
			/mob/living/simple_mob/animal/sif/shantak/leader = 1,
			/mob/living/simple_mob/animal/sif/shantak = 10
			) = 50,
		list(/mob/living/simple_mob/animal/sif/savik,) = 20,
		list(/mob/living/simple_mob/animal/sif/hooligan_crab) = 10,
		list(
			/mob/living/simple_mob/animal/space/alien = 50,
			/mob/living/simple_mob/animal/space/alien/drone = 40,
			/mob/living/simple_mob/animal/space/alien/sentinel = 25,
			/mob/living/simple_mob/animal/space/alien/sentinel/praetorian = 15,
			/mob/living/simple_mob/animal/space/alien/queen = 10,
			/mob/living/simple_mob/animal/space/alien/queen/empress = 5,
			/mob/living/simple_mob/animal/space/alien/queen/empress/mother = 1,
			) = 40,
		list(/mob/living/simple_mob/animal/space/bats/cult/strong) = 40,
		list(
			/mob/living/simple_mob/animal/space/bear,
			/mob/living/simple_mob/animal/space/bear/brown
			) = 40,
		list(
			/mob/living/simple_mob/animal/space/carp = 50,
			/mob/living/simple_mob/animal/space/carp/large = 10,
			/mob/living/simple_mob/animal/space/carp/large/huge = 5
			) = 50,
		list(/mob/living/simple_mob/animal/space/goose) = 50,
		list(/mob/living/simple_mob/vore/jelly) = 40,
		list(/mob/living/simple_mob/animal/space/tree) = 15,
		list(
			/mob/living/simple_mob/vore/otie/feral = 50,
			/mob/living/simple_mob/vore/otie/feral/chubby = 10,
			/mob/living/simple_mob/vore/otie/red = 5,
			/mob/living/simple_mob/vore/otie/red/chubby = 1
			) = 40,
		list(
			/mob/living/simple_mob/vore/aggressive/corrupthound = 10,
			/mob/living/simple_mob/vore/aggressive/corrupthound/prettyboi = 1,
			) = 50,
		list(/mob/living/simple_mob/vore/aggressive/deathclaw) = 40,
		list(/mob/living/simple_mob/vore/aggressive/dino) = 40,
		list(/mob/living/simple_mob/vore/aggressive/dragon) = 40,
		list(/mob/living/simple_mob/vore/aggressive/dragon/virgo3b) = 40,
		list(/mob/living/simple_mob/vore/aggressive/frog) = 40,
		list(/mob/living/simple_mob/vore/aggressive/giant_snake) = 40,
		list(/mob/living/simple_mob/vore/aggressive/mimic) = 40,
		list(/mob/living/simple_mob/vore/aggressive/panther) = 25,
		list(/mob/living/simple_mob/vore/aggressive/rat) = 50,
		list(/mob/living/simple_mob/vore/bee) = 40,
		list(
			/mob/living/simple_mob/vore/sect_drone = 10,
			/mob/living/simple_mob/vore/sect_queen = 1
			) = 20,
		list(/mob/living/simple_mob/vore/solargrub) = 15,
		list(
			/mob/living/simple_mob/vore/oregrub = 5,
			/mob/living/simple_mob/vore/oregrub/lava = 1
			) = 15,
		list(/mob/living/simple_mob/vore/alienanimals/space_jellyfish) = 5,
		list(/mob/living/simple_mob/vore/alienanimals/space_ghost) = 5,
		list(
			/mob/living/simple_mob/vore/leopardmander = 50,
			/mob/living/simple_mob/vore/leopardmander/blue = 10,
			/mob/living/simple_mob/vore/leopardmander/exotic = 1
			) = 5,
		list(/mob/living/simple_mob/vore/sheep) = 5,
		list(/mob/living/simple_mob/vore/weretiger) = 5,
		list(/mob/living/simple_mob/vore/alienanimals/skeleton) = 5,
		list(/mob/living/simple_mob/vore/alienanimals/catslug) = 5
		)

/obj/random/mob/semirandom_mob_spawner/humanoid
	name = "Semi-Random Humanoid"
	desc = "Spawns groups of humanoid mobs that may or may not be hostile, all of the same theme type/theme."
	icon_state = "humanoid"
	mob_faction = "humanoid"

	possible_mob_types = list(
		list(
			/mob/living/simple_mob/shadekin/blue = 25,
			/mob/living/simple_mob/shadekin/green = 10,
			/mob/living/simple_mob/shadekin/purple = 1,
			) = 1,
		list(/mob/living/simple_mob/vore/catgirl) = 100,
		list(/mob/living/simple_mob/vore/wolfgirl) = 100,
		list(
			/mob/living/simple_mob/vore/lamia,
			/mob/living/simple_mob/vore/lamia/albino,
			/mob/living/simple_mob/vore/lamia/albino/bra,
			/mob/living/simple_mob/vore/lamia/albino/shirt,
			/mob/living/simple_mob/vore/lamia/bra,
			/mob/living/simple_mob/vore/lamia/cobra,
			/mob/living/simple_mob/vore/lamia/cobra/bra,
			/mob/living/simple_mob/vore/lamia/cobra/shirt,
			/mob/living/simple_mob/vore/lamia/copper,
			/mob/living/simple_mob/vore/lamia/copper/bra,
			/mob/living/simple_mob/vore/lamia/copper/shirt,
			/mob/living/simple_mob/vore/lamia/green,
			/mob/living/simple_mob/vore/lamia/green/bra,
			/mob/living/simple_mob/vore/lamia/green/shirt,
			/mob/living/simple_mob/vore/lamia/zebra,
			/mob/living/simple_mob/vore/lamia/zebra/bra,
			/mob/living/simple_mob/vore/lamia/zebra/shirt
			) = 100,
// LOOK OKAY MERCS ARE HUMANOIDS SO THEY ARE HERE, but they are also kind of bullshit so they probably shouldn't be able to spawn in the same place as catgirls.
// I want some better potentially hostile humanoids that aren't stupid to fight. If they become a big issue I'll comment them out.
// For now they are just rare, and the ranged ones are way more rare than the melee ones, which I think will help balance them out.
		list(
			/mob/living/simple_mob/humanoid/merc = 100,
			/mob/living/simple_mob/humanoid/merc/melee/sword = 50,
			/mob/living/simple_mob/humanoid/merc/ranged = 25,
			/mob/living/simple_mob/humanoid/merc/ranged/grenadier = 1,
			/mob/living/simple_mob/humanoid/merc/ranged/ionrifle = 10,
			/mob/living/simple_mob/humanoid/merc/ranged/laser = 5,
			/mob/living/simple_mob/humanoid/merc/ranged/rifle = 5,
			/mob/living/simple_mob/humanoid/merc/ranged/smg = 5,
			/mob/living/simple_mob/humanoid/merc/ranged/sniper = 1,
			/mob/living/simple_mob/humanoid/merc/ranged/space = 10,
			/mob/living/simple_mob/humanoid/merc/ranged/technician = 5
			) = 5,
// PIRATES are okay though. They can be kind of a pain but you can kind of slap them around. Also it's not like. A crime. To fight and blow up pirates so it's fine.
		list(
			/mob/living/simple_mob/humanoid/pirate = 3,
			/mob/living/simple_mob/humanoid/pirate/ranged = 1
			) = 50
		)

// I am not familiar enough with robots to know which ones are fun to fight so this list isn't weighted at all SO YOU KNOW. Be careful.
/obj/random/mob/semirandom_mob_spawner/robot
	name = "Semi-Random Robot"
	desc = "Spawns groups of robotic mobs that are probably hostile, all of the same theme type/theme."
	icon_state = "robot"
	mob_faction = "robot"

	possible_mob_types = list(
		list(/mob/living/simple_mob/mechanical/combat_drone),
		list(/mob/living/simple_mob/mechanical/corrupt_maint_drone),
		list(
			/mob/living/simple_mob/mechanical/hivebot = 100,
			/mob/living/simple_mob/mechanical/hivebot/ranged_damage = 20,
			/mob/living/simple_mob/mechanical/hivebot/ranged_damage/backline = 10,
			/mob/living/simple_mob/mechanical/hivebot/ranged_damage/basic = 20,
			/mob/living/simple_mob/mechanical/hivebot/ranged_damage/dot = 5,
			/mob/living/simple_mob/mechanical/hivebot/ranged_damage/ion = 20,
			/mob/living/simple_mob/mechanical/hivebot/ranged_damage/laser = 10,
			/mob/living/simple_mob/mechanical/hivebot/ranged_damage/rapid = 2,
			/mob/living/simple_mob/mechanical/hivebot/ranged_damage/siege = 1,
			/mob/living/simple_mob/mechanical/hivebot/ranged_damage/siege/emp = 5,
			/mob/living/simple_mob/mechanical/hivebot/ranged_damage/siege/fragmentation = 1,
			/mob/living/simple_mob/mechanical/hivebot/ranged_damage/siege/radiation = 1,
			/mob/living/simple_mob/mechanical/hivebot/ranged_damage/strong = 3,
			/mob/living/simple_mob/mechanical/hivebot/ranged_damage/strong/guard = 3,
			/mob/living/simple_mob/mechanical/hivebot/support = 8,
			/mob/living/simple_mob/mechanical/hivebot/support/commander = 5,
			/mob/living/simple_mob/mechanical/hivebot/support/commander/autofollow = 10,
			/mob/living/simple_mob/mechanical/hivebot/swarm = 20,
			/mob/living/simple_mob/mechanical/hivebot/tank = 20,
			/mob/living/simple_mob/mechanical/hivebot/tank/armored = 20,
			/mob/living/simple_mob/mechanical/hivebot/tank/armored/anti_bullet = 20,
			/mob/living/simple_mob/mechanical/hivebot/tank/armored/anti_laser = 20,
			/mob/living/simple_mob/mechanical/hivebot/tank/armored/anti_melee = 20,
			/mob/living/simple_mob/mechanical/hivebot/tank/meatshield = 20
			),
		list(/mob/living/simple_mob/mechanical/infectionbot),
		list(/mob/living/simple_mob/mechanical/mining_drone),
		list(/mob/living/simple_mob/mechanical/technomancer_golem),
		list(
			/mob/living/simple_mob/mechanical/viscerator,
			/mob/living/simple_mob/mechanical/viscerator/piercing
			),
		list(/mob/living/simple_mob/mechanical/wahlem),
		list(/mob/living/simple_mob/animal/passive/fox/syndicate)
		)

/obj/random/mob/semirandom_mob_spawner/fish
	name = "Semi-Random Fish"
	desc = "Spawns groups of fish, all of the same theme type/theme."
	icon_state = "fish"
	mob_faction = "fish"
	overwrite_hostility = 1
	mob_hostile = 0
	mob_retaliate = 0


	possible_mob_types = list(
		list(/mob/living/simple_mob/animal/passive/fish/bass) = 20,
		list(/mob/living/simple_mob/animal/passive/fish/icebass) = 20,
		list(/mob/living/simple_mob/animal/passive/fish/javelin) = 20,
		list(/mob/living/simple_mob/animal/passive/fish/koi) = 10,
		list(/mob/living/simple_mob/animal/passive/fish/measelshark) = 5,
		list(/mob/living/simple_mob/animal/passive/fish/murkin) = 20,
		list(/mob/living/simple_mob/animal/passive/fish/perch) = 20,
		list(/mob/living/simple_mob/animal/passive/fish/pike) = 20,
		list(/mob/living/simple_mob/animal/passive/fish/rockfish) = 10,
		list(/mob/living/simple_mob/animal/passive/fish/salmon) = 20,
		list(/mob/living/simple_mob/animal/passive/fish/solarfish) = 5,
		list(/mob/living/simple_mob/animal/passive/fish/trout) = 20,
		list(/mob/living/simple_mob/animal/passive/crab) = 10,
		list(/mob/living/simple_mob/animal/sif/hooligan_crab) = 1
		)

/obj/random/mob/semirandom_mob_spawner/bird
	name = "Semi-Random Bird"
	desc = "Spawns groups of bird, all of the same theme type/theme."
	icon_state = "bird"
	mob_faction = "bird"

	possible_mob_types = list(
		list(/mob/living/simple_mob/animal/passive/bird),
		list(/mob/living/simple_mob/animal/passive/bird/azure_tit),
		list(/mob/living/simple_mob/animal/passive/bird/black_bird),
		list(/mob/living/simple_mob/animal/passive/bird/european_robin),
		list(/mob/living/simple_mob/animal/passive/bird/goldcrest),
		list(/mob/living/simple_mob/animal/passive/bird/ringneck_dove),
		list(/mob/living/simple_mob/animal/passive/bird/parrot),
		list(/mob/living/simple_mob/animal/passive/bird/parrot/black_headed_caique),
		list(/mob/living/simple_mob/animal/passive/bird/parrot/budgerigar),
		list(/mob/living/simple_mob/animal/passive/bird/parrot/budgerigar/blue),
		list(/mob/living/simple_mob/animal/passive/bird/parrot/budgerigar/bluegreen),
		list(/mob/living/simple_mob/animal/passive/bird/parrot/cockatiel),
		list(/mob/living/simple_mob/animal/passive/bird/parrot/cockatiel/grey),
		list(/mob/living/simple_mob/animal/passive/bird/parrot/cockatiel/white),
		list(/mob/living/simple_mob/animal/passive/bird/parrot/cockatiel/yellowish),
		list(/mob/living/simple_mob/animal/passive/bird/parrot/eclectus),
		list(/mob/living/simple_mob/animal/passive/bird/parrot/grey_parrot),
		list(/mob/living/simple_mob/animal/passive/bird/parrot/kea),
		list(/mob/living/simple_mob/animal/passive/bird/parrot/pink_cockatoo),
		list(/mob/living/simple_mob/animal/passive/bird/parrot/sulphur_cockatoo),
		list(/mob/living/simple_mob/animal/passive/bird/parrot/white_caique),
		list(/mob/living/simple_mob/animal/passive/bird/parrot/white_cockatoo),
		list(/mob/living/simple_mob/animal/space/goose),
		list(/mob/living/simple_mob/animal/passive/chicken),
		list(/mob/living/simple_mob/animal/passive/penguin)
		)

/obj/random/mob/semirandom_mob_spawner/vore
	name = "Semi-Random Voremob"
	desc = "Spawns groups of voremobs, all of the same theme type/theme."
	icon_state = "vore"
	mob_faction = "vore"

	possible_mob_types = list(
		list(
			/mob/living/simple_mob/vore/wolf/direwolf = 5,
			/mob/living/simple_mob/vore/greatwolf = 1,
			/mob/living/simple_mob/vore/greatwolf/black = 1,
			/mob/living/simple_mob/vore/greatwolf/grey = 1
			) = 100,
		list(/mob/living/simple_mob/vore/jelly) = 70,
		list(
			/mob/living/simple_mob/vore/otie/feral,
			/mob/living/simple_mob/vore/otie/feral/chubby,
			/mob/living/simple_mob/vore/otie/red,
			/mob/living/simple_mob/vore/otie/red/chubby
			) = 50,
		list(
			/mob/living/simple_mob/shadekin/blue = 100,
			/mob/living/simple_mob/shadekin/green = 50,
			/mob/living/simple_mob/shadekin/orange = 20,
			/mob/living/simple_mob/shadekin/purple = 60,
			/mob/living/simple_mob/shadekin/red = 40,
			/mob/living/simple_mob/shadekin/yellow = 1
			) = 1,
		list(
			/mob/living/simple_mob/vore/aggressive/corrupthound,
			/mob/living/simple_mob/vore/aggressive/corrupthound/prettyboi
			) = 70,
		list(/mob/living/simple_mob/vore/aggressive/deathclaw) = 70,
		list(/mob/living/simple_mob/vore/aggressive/dino) = 100,
		list(/mob/living/simple_mob/vore/aggressive/dragon) = 100,
		list(/mob/living/simple_mob/vore/aggressive/dragon/virgo3b) = 100,
		list(/mob/living/simple_mob/vore/aggressive/frog) = 100,
		list(/mob/living/simple_mob/vore/aggressive/giant_snake) = 100,
		list(/mob/living/simple_mob/vore/aggressive/mimic) = 50,
		list(/mob/living/simple_mob/vore/aggressive/panther) = 70,
		list(/mob/living/simple_mob/vore/aggressive/rat) = 100,
		list(/mob/living/simple_mob/vore/bee) = 100,
		list(/mob/living/simple_mob/vore/catgirl) = 100,
		list(/mob/living/simple_mob/vore/wolftaur) = 100,
		list(/mob/living/simple_mob/vore/cookiegirl) = 100,
		list(/mob/living/simple_mob/vore/fennec) = 100,
		list(/mob/living/simple_mob/vore/fennix) = 50,
		list(/mob/living/simple_mob/vore/hippo) = 70,
		list(/mob/living/simple_mob/vore/horse) = 100,
		list(/mob/living/simple_mob/vore/raptor) = 100,
		list(/mob/living/simple_mob/vore/succubus) = 100,
		list(/mob/living/simple_mob/vore/vampire) = 50,
		list(/mob/living/simple_mob/vore/vampire/queen) = 1,
		list(/mob/living/simple_mob/vore/bat) = 50,
		list(/mob/living/simple_mob/vore/scel) = 10,
		list(
			/mob/living/simple_mob/vore/lamia,
			/mob/living/simple_mob/vore/lamia/albino,
			/mob/living/simple_mob/vore/lamia/albino/bra,
			/mob/living/simple_mob/vore/lamia/albino/shirt,
			/mob/living/simple_mob/vore/lamia/bra,
			/mob/living/simple_mob/vore/lamia/cobra,
			/mob/living/simple_mob/vore/lamia/cobra/bra,
			/mob/living/simple_mob/vore/lamia/cobra/shirt,
			/mob/living/simple_mob/vore/lamia/copper,
			/mob/living/simple_mob/vore/lamia/copper/bra,
			/mob/living/simple_mob/vore/lamia/copper/shirt,
			/mob/living/simple_mob/vore/lamia/green,
			/mob/living/simple_mob/vore/lamia/green/bra,
			/mob/living/simple_mob/vore/lamia/green/shirt,
			/mob/living/simple_mob/vore/lamia/zebra,
			/mob/living/simple_mob/vore/lamia/zebra/bra,
			/mob/living/simple_mob/vore/lamia/zebra/shirt
			) = 100,
		list(/mob/living/simple_mob/vore/rabbit) = 100,
		list(
			/mob/living/simple_mob/vore/redpanda = 50,
			/mob/living/simple_mob/vore/redpanda/fae = 1
			) = 100,
		list(
			/mob/living/simple_mob/vore/sect_drone = 10,
			/mob/living/simple_mob/vore/sect_queen = 1
			) = 50,
		list(/mob/living/simple_mob/vore/solargrub) = 100,
		list(/mob/living/simple_mob/vore/woof) = 1
		)

/obj/random/mob/semirandom_mob_spawner/sus
	name = "Weird shit"
	desc = "Spawns groups of weird stuff, all of the same theme type/theme. Don't put this on normal maps."
	icon_state = "sus"
	mob_faction = "sus"

	possible_mob_types = list(
		list(
			/mob/living/simple_mob/vore/woof/hostile/melee = 100,
			/mob/living/simple_mob/vore/woof/hostile/ranged = 20,
			/mob/living/simple_mob/vore/woof/hostile/horrible = 10,
			/mob/living/simple_mob/vore/woof/hostile/terrible = 5,
			/mob/living/simple_mob/vore/woof/cass = 1
			),
		list(/mob/living/simple_mob/mechanical/mecha/combat/gygax/dark/advanced/recursive)
		)

/obj/random/mob/semirandom_mob_spawner/mecha
	name = "Semi-Random Mecha"
	desc = "Spawns groups of mechs, all of the same theme type/theme. Don't put this on normal maps."
	icon_state = "mecha"
	mob_faction = "mecha"

	possible_mob_types = list(
		list(/mob/living/simple_mob/mechanical/mecha/combat/durand),
		list(/mob/living/simple_mob/mechanical/mecha/combat/durand/defensive),
		list(/mob/living/simple_mob/mechanical/mecha/combat/durand/defensive/mercenary),
		list(/mob/living/simple_mob/mechanical/mecha/combat/gygax),
		list(/mob/living/simple_mob/mechanical/mecha/combat/gygax/dark),
		list(/mob/living/simple_mob/mechanical/mecha/combat/gygax/dark/advanced),
		list(/mob/living/simple_mob/mechanical/mecha/combat/gygax/manned),
		list(/mob/living/simple_mob/mechanical/mecha/combat/gygax/medgax),
		list(/mob/living/simple_mob/mechanical/mecha/combat/marauder),
		list(/mob/living/simple_mob/mechanical/mecha/combat/marauder/mauler),
		list(/mob/living/simple_mob/mechanical/mecha/combat/marauder/seraph),
		list(/mob/living/simple_mob/mechanical/mecha/combat/phazon),
		list(/mob/living/simple_mob/mechanical/mecha/hoverpod),
		list(/mob/living/simple_mob/mechanical/mecha/hoverpod/manned),
		list(/mob/living/simple_mob/mechanical/mecha/odysseus),
		list(/mob/living/simple_mob/mechanical/mecha/odysseus/manned),
		list(/mob/living/simple_mob/mechanical/mecha/odysseus/murdysseus),
		list(/mob/living/simple_mob/mechanical/mecha/odysseus/murdysseus/manned),
		list(/mob/living/simple_mob/mechanical/mecha/ripley),
		list(/mob/living/simple_mob/mechanical/mecha/ripley/blue_flames),
		list(/mob/living/simple_mob/mechanical/mecha/ripley/deathripley),
		list(/mob/living/simple_mob/mechanical/mecha/ripley/deathripley/manned),
		list(/mob/living/simple_mob/mechanical/mecha/ripley/firefighter),
		list(/mob/living/simple_mob/mechanical/mecha/ripley/firefighter/manned),
		list(/mob/living/simple_mob/mechanical/mecha/ripley/manned),
		list(/mob/living/simple_mob/mechanical/mecha/ripley/red_flames)
		)


/obj/random/mob/semirandom_mob_spawner/monster/b
	mob_faction = "monsterb"

/obj/random/mob/semirandom_mob_spawner/monster/c
	mob_faction = "monsterc"

/obj/random/mob/semirandom_mob_spawner/monster/d
	mob_faction = "monsterd"

/obj/random/mob/semirandom_mob_spawner/monster/e
	mob_faction = "monstere"

/obj/random/mob/semirandom_mob_spawner/monster/f
	mob_faction = "monsterf"

/obj/random/mob/semirandom_mob_spawner/animal/b
	mob_faction = "animalb"

/obj/random/mob/semirandom_mob_spawner/animal/c
	mob_faction = "animalc"

/obj/random/mob/semirandom_mob_spawner/animal/d
	mob_faction = "animald"

/obj/random/mob/semirandom_mob_spawner/animal/e
	mob_faction = "animale"

/obj/random/mob/semirandom_mob_spawner/animal/f
	mob_faction = "animalf"

/obj/random/mob/semirandom_mob_spawner/animal/retaliate
	mob_faction = "retanimala"
	overwrite_hostility = 1
	mob_hostile = 0
	mob_retaliate = 1

/obj/random/mob/semirandom_mob_spawner/animal/retaliate/b
	mob_faction = "retanimalb"

/obj/random/mob/semirandom_mob_spawner/animal/retaliate/c
	mob_faction = "retanimalc"

/obj/random/mob/semirandom_mob_spawner/animal/hostile
	mob_faction = "hosanimala"
	overwrite_hostility = 1
	mob_hostile = 1
	mob_retaliate = 1

/obj/random/mob/semirandom_mob_spawner/animal/hostile/b
	mob_faction = "hosanimalb"

/obj/random/mob/semirandom_mob_spawner/animal/hostile/c
	mob_faction = "hosanimalc"


/obj/random/mob/semirandom_mob_spawner/humanoid/b
	mob_faction = "humanoidb"

/obj/random/mob/semirandom_mob_spawner/humanoid/c
	mob_faction = "humanoidc"

/obj/random/mob/semirandom_mob_spawner/humanoid/d
	mob_faction = "humanoidd"

/obj/random/mob/semirandom_mob_spawner/humanoid/e
	mob_faction = "humanoide"

/obj/random/mob/semirandom_mob_spawner/humanoid/f
	mob_faction = "humanoidf"

/obj/random/mob/semirandom_mob_spawner/humanoid/retaliate
	mob_faction = "rethumanoida"
	overwrite_hostility = 1
	mob_hostile = 0
	mob_retaliate = 1

/obj/random/mob/semirandom_mob_spawner/humanoid/retaliate/b
	mob_faction = "rethumanoidb"

/obj/random/mob/semirandom_mob_spawner/humanoid/retaliate/c
	mob_faction = "rethumanoidc"

/obj/random/mob/semirandom_mob_spawner/humanoid/hostile
	mob_faction = "hoshumanoida"
	overwrite_hostility = 1
	mob_hostile = 1
	mob_retaliate = 1

/obj/random/mob/semirandom_mob_spawner/humanoid/hostile/b
	mob_faction = "hoshumanoidb"

/obj/random/mob/semirandom_mob_spawner/humanoid/hostile/c
	mob_faction = "hoshumanoidc"

/obj/random/mob/semirandom_mob_spawner/robot/b
	mob_faction = "robotb"

/obj/random/mob/semirandom_mob_spawner/robot/c
	mob_faction = "robotc"

/obj/random/mob/semirandom_mob_spawner/robot/d
	mob_faction = "robotd"

/obj/random/mob/semirandom_mob_spawner/robot/e
	mob_faction = "robote"

/obj/random/mob/semirandom_mob_spawner/robot/f
	mob_faction = "robotf"

/obj/random/mob/semirandom_mob_spawner/robot/retaliate
	mob_faction = "retrobota"
	overwrite_hostility = 1
	mob_hostile = 0
	mob_retaliate = 1

/obj/random/mob/semirandom_mob_spawner/robot/retaliate/b
	mob_faction = "retrobotb"

/obj/random/mob/semirandom_mob_spawner/robot/retaliate/c
	mob_faction = "retrobotc"

/obj/random/mob/semirandom_mob_spawner/bird/b
	mob_faction = "birdb"

/obj/random/mob/semirandom_mob_spawner/bird/c
	mob_faction = "birdc"

/obj/random/mob/semirandom_mob_spawner/bird/d
	mob_faction = "birdd"

/obj/random/mob/semirandom_mob_spawner/bird/e
	mob_faction = "birde"

/obj/random/mob/semirandom_mob_spawner/bird/f
	mob_faction = "birdf"

/obj/random/mob/semirandom_mob_spawner/fish/b
	mob_faction = "fishb"

/obj/random/mob/semirandom_mob_spawner/fish/c
	mob_faction = "fishc"

/obj/random/mob/semirandom_mob_spawner/fish/d
	mob_faction = "fishd"

/obj/random/mob/semirandom_mob_spawner/fish/e
	mob_faction = "fishe"

/obj/random/mob/semirandom_mob_spawner/fish/f
	mob_faction = "fishf"

/obj/random/mob/semirandom_mob_spawner/vore/b
	mob_faction = "voreb"

/obj/random/mob/semirandom_mob_spawner/vore/c
	mob_faction = "vorec"

/obj/random/mob/semirandom_mob_spawner/vore/d
	mob_faction = "vored"

/obj/random/mob/semirandom_mob_spawner/vore/e
	mob_faction = "voree"

/obj/random/mob/semirandom_mob_spawner/vore/f
	mob_faction = "voref"

/obj/random/mob/semirandom_mob_spawner/vore/passive
	mob_faction = "pasvorea"
	overwrite_hostility = 1
	mob_hostile = 0
	mob_retaliate = 0

/obj/random/mob/semirandom_mob_spawner/vore/passive/b
	mob_faction = "pasvoreb"

/obj/random/mob/semirandom_mob_spawner/vore/passive/c
	mob_faction = "pasvorec"

/obj/random/mob/semirandom_mob_spawner/vore/retaliate
	mob_faction = "retvorea"
	overwrite_hostility = 1
	mob_hostile = 0
	mob_retaliate = 1

/obj/random/mob/semirandom_mob_spawner/vore/retaliate/b
	mob_faction = "retvoreb"

/obj/random/mob/semirandom_mob_spawner/vore/retaliate/c
	mob_faction = "retvorec"

/obj/random/mob/semirandom_mob_spawner/vore/hostile
	mob_faction = "hosvorea"
	overwrite_hostility = 1
	mob_hostile = 1
	mob_retaliate = 1

/obj/random/mob/semirandom_mob_spawner/vore/hostile/b
	mob_faction = "hosvoreb"

/obj/random/mob/semirandom_mob_spawner/vore/hostile/c
	mob_faction = "hosvorec"

/obj/random/mob/semirandom_mob_spawner/sus/b
	mob_faction = "susb"

/obj/random/mob/semirandom_mob_spawner/sus/c
	mob_faction = "susc"

/obj/random/mob/semirandom_mob_spawner/sus/d
	mob_faction = "susd"

/obj/random/mob/semirandom_mob_spawner/sus/e
	mob_faction = "suse"

/obj/random/mob/semirandom_mob_spawner/sus/f
	mob_faction = "susf"

/obj/random/mob/semirandom_mob_spawner/mecha/b
	mob_faction = "mechab"

/obj/random/mob/semirandom_mob_spawner/mecha/c
	mob_faction = "mechac"

/obj/random/mob/semirandom_mob_spawner/mecha/d
	mob_faction = "mechad"

/obj/random/mob/semirandom_mob_spawner/mecha/e
	mob_faction = "mechae"

/obj/random/mob/semirandom_mob_spawner/mecha/f
	mob_faction = "mechaf"

/obj/random/mob/semirandom_mob_spawner/mecha/retaliate
	mob_faction = "retmecha"
	overwrite_hostility = 1
	mob_hostile = 0
	mob_retaliate = 1

/obj/random/mob/semirandom_mob_spawner/mecha/retaliate/b
	mob_faction = "retmechb"

/obj/random/mob/semirandom_mob_spawner/mecha/retaliate/c
	mob_faction = "retmechc"
