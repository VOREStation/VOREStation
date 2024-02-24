/mob/living/simple_mob/animal/giant_spider/frost/broodling
	maxHealth = 40
	health = 40

	melee_damage_lower = 10
	melee_damage_upper = 15

	movement_cooldown = 3

/mob/living/simple_mob/animal/giant_spider/frost/broodling/Initialize()
	. = ..()
	adjust_scale(0.75)
	addtimer(CALLBACK(src, PROC_REF(death)), 2 MINUTES)

/mob/living/simple_mob/animal/giant_spider/frost/broodling/death()
	new /obj/effect/decal/cleanable/spiderling_remains(src.loc)
	qdel(src)

/mob/living/simple_mob/animal/giant_spider/electric/broodling
	maxHealth = 30
	health = 30

	taser_kill = TRUE
	base_attack_cooldown = 20

	movement_cooldown = -1

/mob/living/simple_mob/animal/giant_spider/electric/broodling/Initialize()
	. = ..()
	adjust_scale(0.75)
	addtimer(CALLBACK(src, PROC_REF(death)), 2 MINUTES)

/mob/living/simple_mob/animal/giant_spider/electric/broodling/death()
	new /obj/effect/decal/cleanable/spiderling_remains(src.loc)
	qdel(src)

/mob/living/simple_mob/animal/giant_spider/hunter/broodling
	maxHealth = 40
	health = 40

	movement_cooldown = 0

/mob/living/simple_mob/animal/giant_spider/hunter/broodling/Initialize()
	. = ..()
	adjust_scale(0.75)
	addtimer(CALLBACK(src, PROC_REF(death)), 2 MINUTES)

/mob/living/simple_mob/animal/giant_spider/hunter/broodling/death()
	new /obj/effect/decal/cleanable/spiderling_remains(src.loc)
	qdel(src)

/mob/living/simple_mob/animal/giant_spider/lurker/broodling
	maxHealth = 40
	health = 40

	movement_cooldown = 0

/mob/living/simple_mob/animal/giant_spider/lurker/broodling/Initialize()
	. = ..()
	adjust_scale(0.75)
	addtimer(CALLBACK(src, PROC_REF(death)), 2 MINUTES)

/mob/living/simple_mob/animal/giant_spider/lurker/broodling/death()
	new /obj/effect/decal/cleanable/spiderling_remains(src.loc)
	qdel(src)

/mob/living/simple_mob/animal/giant_spider/nurse/broodling
	maxHealth = 60
	health = 60

	movement_cooldown = 3
	ai_holder_type = /datum/ai_holder/simple_mob/melee

/mob/living/simple_mob/animal/giant_spider/nurse/broodling/Initialize()
	. = ..()
	adjust_scale(0.75)
	addtimer(CALLBACK(src, PROC_REF(death)), 2 MINUTES)

/mob/living/simple_mob/animal/giant_spider/nurse/broodling/death()
	new /obj/effect/decal/cleanable/spiderling_remains(src.loc)
	qdel(src)

/mob/living/simple_mob/animal/giant_spider/pepper/broodling
	maxHealth = 40
	health = 40

	movement_cooldown = 3

/mob/living/simple_mob/animal/giant_spider/pepper/broodling/Initialize()
	. = ..()
	adjust_scale(0.75)
	addtimer(CALLBACK(src, PROC_REF(death)), 2 MINUTES)

/mob/living/simple_mob/animal/giant_spider/pepper/broodling/death()
	new /obj/effect/decal/cleanable/spiderling_remains(src.loc)
	qdel(src)

/mob/living/simple_mob/animal/giant_spider/thermic/broodling
	maxHealth = 40
	health = 40

	melee_damage_lower = 10
	melee_damage_upper = 15

	movement_cooldown = 1

/mob/living/simple_mob/animal/giant_spider/thermic/broodling/Initialize()
	. = ..()
	adjust_scale(0.75)
	addtimer(CALLBACK(src, PROC_REF(death)), 2 MINUTES)

/mob/living/simple_mob/animal/giant_spider/thermic/broodling/death()
	new /obj/effect/decal/cleanable/spiderling_remains(src.loc)
	qdel(src)

/mob/living/simple_mob/animal/giant_spider/tunneler/broodling
	maxHealth = 40
	health = 40

	movement_cooldown = 1

/mob/living/simple_mob/animal/giant_spider/tunneler/broodling/Initialize()
	. = ..()
	adjust_scale(0.75)
	addtimer(CALLBACK(src, PROC_REF(death)), 2 MINUTES)

/mob/living/simple_mob/animal/giant_spider/tunneler/broodling/death()
	new /obj/effect/decal/cleanable/spiderling_remains(src.loc)
	qdel(src)

/mob/living/simple_mob/animal/giant_spider/webslinger/broodling
	maxHealth = 30
	health = 30

	base_attack_cooldown = 20

	movement_cooldown = 1.5

/mob/living/simple_mob/animal/giant_spider/webslinger/broodling/Initialize()
	. = ..()
	adjust_scale(0.75)
	addtimer(CALLBACK(src, PROC_REF(death)), 2 MINUTES)

/mob/living/simple_mob/animal/giant_spider/webslinger/broodling/death()
	new /obj/effect/decal/cleanable/spiderling_remains(src.loc)
	qdel(src)

/mob/living/simple_mob/animal/giant_spider/broodling
	maxHealth = 60
	health = 60

	melee_damage_lower = 10
	melee_damage_upper = 20

	movement_cooldown = 3

/mob/living/simple_mob/animal/giant_spider/broodling/Initialize()
	. = ..()
	adjust_scale(0.75)
	addtimer(CALLBACK(src, PROC_REF(death)), 2 MINUTES)

/mob/living/simple_mob/animal/giant_spider/broodling/death()
	new /obj/effect/decal/cleanable/spiderling_remains(src.loc)
	qdel(src)
