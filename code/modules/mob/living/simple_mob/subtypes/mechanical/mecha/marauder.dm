// Marauders are even tougher than Durands.

/mob/living/simple_mob/mechanical/mecha/combat/marauder
	name = "marauder"
	desc = "A heavy-duty, combat exosuit, developed after the Durand model. This is rarely found among civilian populations."
	icon_state = "marauder"
	movement_cooldown = 5
	wreckage = /obj/structure/loot_pile/mecha/marauder

	maxHealth = 500
	deflect_chance = 25
	sight = SEE_SELF | SEE_MOBS
	armor = list(
				"melee"		= 50,
				"bullet"	= 55,
				"laser"		= 40,
				"energy"	= 30,
				"bomb"		= 30,
				"bio"		= 100,
				"rad"		= 100
				)
	melee_damage_lower = 45
	melee_damage_upper = 45
	base_attack_cooldown = 2 SECONDS
	projectiletype = /obj/item/projectile/beam/heavylaser


// Slightly stronger, used to allow comdoms to frontline without dying instantly, I guess.
/mob/living/simple_mob/mechanical/mecha/combat/marauder/seraph
	name = "seraph"
	desc = "A heavy-duty, combat/command exosuit. This one is specialized towards housing important commanders such as high-ranking \
	military personnel. It's stronger than the regular Marauder model, but not by much."
	icon_state = "seraph"
	wreckage = /obj/structure/loot_pile/mecha/marauder/seraph
	health = 550
	melee_damage_lower = 55 // The real version hits this hard apparently. Ouch.
	melee_damage_upper = 55


/mob/living/simple_mob/mechanical/mecha/combat/marauder/mauler
	name = "mauler"
	desc = "A heavy duty, combat exosuit that is based off of the Marauder model."
	icon_state = "mauler"
	wreckage = /obj/structure/loot_pile/mecha/marauder/mauler
