/mob/living/simple_mob/animal/giant_spider/electric
	base_attack_cooldown = 15

/mob/living/simple_mob/animal/giant_spider/webslinger
	base_attack_cooldown = 15

// Slightly placeholder, mostly to replace ion hivebots on V4
/mob/living/simple_mob/animal/giant_spider/ion
	desc = "Furry and green, it makes you shudder to look at it. This one has brilliant green eyes and a hint of static discharge."
	tt_desc = "X Brachypelma phorus ionus"
	icon_state = "webslinger"
	icon_living = "webslinger"
	icon_dead = "webslinger_dead"

	maxHealth = 90
	health = 90

	base_attack_cooldown = 15
	projectilesound = 'sound/weapons/taser2.ogg'
	projectiletype = /obj/item/projectile/ion/pistol

	melee_damage_lower = 8
	melee_damage_upper = 15

	poison_chance = 15
	poison_per_bite = 2
	poison_type = REAGENT_ID_PSILOCYBIN

	ai_holder_type = /datum/ai_holder/simple_mob/ranged/electric_spider

//Lost to AI refactor, returning champion of arachnophobe horror, Spider Queen
/mob/living/simple_mob/animal/giant_spider/nurse/queen
	name = "giant spider queen"
	desc = "Absolutely gigantic, this creature is horror itself."
	tt_desc = "X Brachypelma phorus tyrannus"
	icon = 'icons/mob/64x64.dmi'
	vis_height = 64
	icon_state = "spider_queen"
	icon_living = "spider_queen"
	icon_dead = "spider_queen_dead"

	maxHealth = 320
	health = 320

	melee_damage_lower = 20
	melee_damage_upper = 30
	attack_armor_pen = 25

	pixel_x = -16
	pixel_y = 0
	default_pixel_x = -16
	old_x = -16
	old_y = 0
	meat_amount = 15

	egg_type = /obj/effect/spider/eggcluster/royal

/mob/living/simple_mob/animal/giant_spider/nurse
	var/can_lay_eggs = TRUE

/mob/living/simple_mob/animal/giant_spider/nurse/eggless
	can_lay_eggs = FALSE

/mob/living/simple_mob/animal/giant_spider/nurse/queen/eggless
	can_lay_eggs = FALSE
