// Gygaxes are tough but also fast.
// Their AI, unlike most, will advance towards their target instead of remaining in place.

/datum/category_item/catalogue/technology/gygax
	name = "Exosuit - Gygax"
	desc = "The Gygax is a relatively modern exosuit, built to be lightweight and agile, while still being fairly durable. \
	These traits have made them rather popular among well funded private and corporate security forces, who desire \
	the ability to rapidly respond to conflict.\
	<br><br>\
	One special feature of this model is that the actuators that \
	drive the exosuit can have their safeties disabled in order to achieve a short-term burst of unparalleled speed, \
	at the expense of damaging the exosuit considerably."
	value = CATALOGUER_REWARD_HARD

/mob/living/simple_mob/mechanical/mecha/combat/gygax
	name = "gygax"
	desc = "A lightweight, security exosuit. Popular among private and corporate security."
	catalogue_data = list(/datum/category_item/catalogue/technology/gygax)
	icon_state = "gygax"
	movement_cooldown = -1
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

	projectile_dispersion = 8
	projectiletype = /obj/item/projectile/beam/midlaser

	ai_holder_type = /datum/ai_holder/simple_mob/intentional/adv_dark_gygax

/mob/living/simple_mob/mechanical/mecha/combat/gygax/manned
	pilot_type = /mob/living/simple_mob/humanoid/merc/ranged // Carries a pistol.


// A stronger variant.

/datum/category_item/catalogue/technology/dark_gygax
	name = "Exosuit - Dark Gygax"
	desc = "This exosuit is a variant of the regular Gygax. It is generally referred to as the Dark Gygax, \
	due to being constructed from different materials that give it a darker appearance. Beyond merely looking \
	cosmetically different, the Dark Gygax also has various upgrades compared to the Gygax. It is much more \
	resilient, yet retains the agility and speed of the Gygax.\
	<br><br>\
	These are relatively rare compared to the other security exosuits, as most security forces are content with \
	a regular Gygax. Instead, this exosuit is often used by high-end asset protection teams, and mercenaries."
	value = CATALOGUER_REWARD_HARD

/mob/living/simple_mob/mechanical/mecha/combat/gygax/dark
	name = "dark gygax"
	desc = "A significantly upgraded Gygax security mech, often utilized by corporate asset protection teams and \
	PMCs."
	catalogue_data = list(/datum/category_item/catalogue/technology/dark_gygax)
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

	projectile_dispersion = 8
