// Gygaxes are tough but also fast.
// Their AI, unlike most, will advance towards their target instead of remaining in place.

/mob/living/simple_mob/mechanical/mecha/combat/gygax
	name = "gygax"
	desc = "A lightweight, security exosuit. Popular among private and corporate security."
	icon_state = "gygax"
	movement_cooldown = 0
	wreckage = /obj/structure/loot_pile/mecha/gygax

	maxHealth = 300
	armor = list(
				"melee"		= 25,
				"bullet"	= 20,
				"laser"		= 30,
				"energy"	= 15,
				"bomb"		= 0,
				"bio"		= 100,
				"rad"		= 100
				)

	projectiletype = /obj/item/projectile/beam/midlaser

	ai_holder_type = /datum/ai_holder/simple_mob/intentional/adv_dark_gygax

/mob/living/simple_mob/mechanical/mecha/combat/gygax/manned
	pilot_type = /mob/living/simple_mob/humanoid/merc/ranged // Carries a pistol.


// A stronger variant.
/mob/living/simple_mob/mechanical/mecha/combat/gygax/dark
	name = "dark gygax"
	desc = "A significantly upgraded Gygax security mech, often utilized by corporate asset protection teams and \
	PMCs."
	icon_state = "darkgygax"
	wreckage = /obj/structure/loot_pile/mecha/gygax/dark

	maxHealth = 400
	deflect_chance = 25
	has_repair_droid = TRUE
	armor = list(
				"melee"		= 40,
				"bullet"	= 40,
				"laser"		= 50,
				"energy"	= 35,
				"bomb"		= 20,
				"bio"		= 100,
				"rad"		= 100
				)

/mob/living/simple_mob/mechanical/mecha/combat/gygax/medgax
	name = "medgax"
	desc = "An unorthodox fusion of the Gygax and Odysseus exosuits, this one is fast, sturdy, and carries a wide array of \
	potent chemicals and delivery mechanisms. The doctor is in!"
	icon_state = "medgax"
	wreckage = /obj/structure/loot_pile/mecha/gygax/medgax

