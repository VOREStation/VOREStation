////////////////////////////
//	Purity Construct - Deacon
////////////////////////////

/mob/living/simple_mob/construct/deacon
	name = "Deacon"
	real_name = "Deacon"
	construct_type = "Deacon"
	faction = "purity"
	desc = "A small construct of the purity worshippers mechanical followers, hardy but mostly harmless."
	icon_state = "deacon"
	icon_living = "deacon"
	ui_icons = 'modular_chomp/icons/mob/screen1_purity.dmi'
	maxHealth = 150
	health = 150
	melee_damage_lower = 8 //not meant for combat but can hold its own in a pinch
	melee_damage_upper = 12
	attack_armor_pen = 60 //used to carve stone and other metals, cuts through armor just as well
	attack_sharp = 1
	attack_edge = 1
	attacktext = list("violently stabbed")
	friendly = list("caresses")
	organ_names = /decl/mob_organ_names/harvester
	movement_cooldown = -1

	ai_holder_type = /datum/ai_holder/simple_mob/retaliate/cooperative

	//	environment_smash = 1	// Whatever this gets renamed to, Harvesters need to break things

	attack_sound = 'sound/weapons/pierce.ogg'

	armor = list(
				"melee" = 20,
				"bullet" = 10,
				"laser" = 10,
				"energy" = 10,
				"bomb" = 10,
				"bio" = 100,
				"rad" = 100)

	construct_spells = list(
			/spell/aoe_turf/knock/harvester,
			/spell/targeted/construct_advanced/force_beam,
			/spell/targeted/construct_advanced/soothing_sphere,
		)

/decl/mob_organ_names/harvester
	hit_zones = list("cephalothorax", "eye", "carapace", "energy crystal", "mandible")
