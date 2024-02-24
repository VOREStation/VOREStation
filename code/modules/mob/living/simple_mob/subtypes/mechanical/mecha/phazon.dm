// Phazons are weird.

/mob/living/simple_mob/mechanical/mecha/combat/phazon
	name = "phazon"
	desc = "An extremly enigmatic exosuit."
	icon_state = "phazon"
	movement_cooldown = 1.5
	wreckage = /obj/structure/loot_pile/mecha/phazon

	maxHealth = 200
	deflect_chance = 30
	armor = list(
				"melee"		= 30,
				"bullet"	= 30,
				"laser"		= 30,
				"energy"	= 30,
				"bomb"		= 30,
				"bio"		= 100,
				"rad"		= 100
				)
	projectiletype = /obj/item/projectile/energy/declone
