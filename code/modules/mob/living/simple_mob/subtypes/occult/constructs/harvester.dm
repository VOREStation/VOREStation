////////////////////////////
//		Harvester
////////////////////////////

/mob/living/simple_mob/construct/harvester
	name = "Harvester"
	real_name = "Harvester"
	construct_type = "harvester"
	desc = "A tendril-laden construct piloted by a chained mind."
	icon_state = "harvester"
	icon_living = "harvester"
	melee_damage_lower = 20
	melee_damage_upper = 25
	attack_sharp = TRUE
	attacktext = list("violently stabbed")
	friendly = list("caresses")
	organ_names = /decl/mob_organ_names/harvester
	movement_cooldown = -1

	//	environment_smash = 1	// Whatever this gets renamed to, Harvesters need to break things

	attack_sound = 'sound/weapons/pierce.ogg'

	armor = list(
				"melee" = 10,
				"bullet" = 20,
				"laser" = 20,
				"energy" = 20,
				"bomb" = 20,
				"bio" = 100,
				"rad" = 100)

	construct_spells = list(
			/spell/aoe_turf/knock/harvester,
			/spell/targeted/construct_advanced/inversion_beam,
			/spell/targeted/construct_advanced/agonizing_sphere,
			/spell/rune_write
		)
	ai_holder_type = /datum/ai_holder/simple_mob/melee/evasive
	attack_edge = TRUE

/decl/mob_organ_names/harvester
	hit_zones = list("cephalothorax", "eye", "carapace", "energy crystal", "mandible")

////////////////////////////
//		Greater Harvester
////////////////////////////

/mob/living/simple_mob/construct/harvester/greater
	name = "Greater Harvester"
	real_name = "Chosen"
	construct_type = "Chosen"
	desc = "A infanthomable mass of tentacles and claws ripping and tearing through all that oppose it."
	icon_state = "chosen"
	icon_living = "chosen"
	maxHealth = 100
	health = 100
	melee_damage_lower = 40 //Glass Cannon Mini-Boss/Semi-Boss large. Few hits is enough to end you.
	melee_damage_upper = 50
	attack_armor_pen = 60 //No Armor Shall Save you
	attack_sharp = 1
	attack_edge = 1
	attacktext = list("violently stabbed")
	friendly = list("caresses")
	movement_cooldown = 0

	ai_holder_type = /datum/ai_holder/simple_mob/melee/evasive

	attack_sound = 'sound/weapons/pierce.ogg'
