////////////////////////////
//		Harvester
////////////////////////////

/mob/living/simple_mob/construct/harvester
	name = "Harvester"
	real_name = "Harvester"
	construct_type = "harvester"
	desc = "A tendril-laden construct piloted by a chained mind."
	icon = 'icons/mob/mob.dmi'
	icon_state = "harvester"
	icon_living = "harvester"
	maxHealth = 150
	health = 150
	melee_damage_lower = 20
	melee_damage_upper = 25
	attack_sharp = TRUE
	attacktext = list("violently stabbed")
	friendly = list("caresses")
	organ_names = /decl/mob_organ_names/harvester
	movement_cooldown = 0

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

/decl/mob_organ_names/harvester
	hit_zones = list("cephalothorax", "eye", "carapace", "energy crystal", "mandible")