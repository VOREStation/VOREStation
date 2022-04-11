/datum/category_item/catalogue/fauna/pillbug
	name = "Sivian Fauna - Fire Bug"
	desc = "Classification: S Armadillidiidae calidi \
	<br><br>\
	A 10 inch long, hard-shelled insect with a natural adaption to living around terrestrial lava vents. \
	The fire bug's hard shell offers extremely effective protection against most threats, \
	though the species is almost completely docile, and will prefer to continue grazing on its diet of volcanic micro-flora \
	rather than defend itself in most situations.\
	<br>\
	The fire bug is a curiosity to most on the frontier, offering little in the way of meaningful food or resources, \
	though at least one Sivian fashion designer has used their iridescent red shells to create striking, hand-made garments."
	value = CATALOGUER_REWARD_EASY

/mob/living/simple_mob/animal/passive/pillbug
	name = "fire bug"
	desc = "A tiny plated bug found in Sif's volcanic regions."
	tt_desc = "S Armadillidiidae calidi"
	catalogue_data = list(/datum/category_item/catalogue/fauna/pillbug)

	icon_state = "pillbug"
	icon_living = "pillbug"
	icon_dead = "pillbug_dead"

	health = 15
	maxHealth = 15
	mob_size = MOB_MINISCULE

	response_help  = "gently touches"
	response_disarm = "rolls over"
	response_harm   = "stomps on"

	organ_names = /decl/mob_organ_names/pillbug

	armor = list(
		"melee" = 30,
		"bullet" = 10,
		"laser" = 50,
		"energy" = 50,
		"bomb" = 30,
		"bio" = 100,
		"rad" = 100
		)

	armor_soak = list(
		"melee" = 10,
		"bullet" = 0,
		"laser" = 10,
		"energy" = 10,
		"bomb" = 0,
		"bio" = 0,
		"rad" = 0
		)

/decl/mob_organ_names/pillbug
	hit_zones = list("cephalon", "pereon", "pleon", "left forelegs", "right forelegs", "left hind legs", "right hind legs")