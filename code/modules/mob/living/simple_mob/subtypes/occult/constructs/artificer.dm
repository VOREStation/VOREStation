////////////////////////////
//		Artificer
////////////////////////////

/mob/living/simple_mob/construct/artificer
	name = "Artificer"
	real_name = "Artificer"
	construct_type = "artificer"
	desc = "A bulbous construct dedicated to building and maintaining temples to their otherworldly lords."
	icon_state = "artificer"
	icon_living = "artificer"
	maxHealth = 150
	health = 150
	response_harm = "viciously beaten"
	harm_intent_damage = 5
	melee_damage_lower = 15 //It's not the strongest of the bunch, but that doesn't mean it can't hurt you.
	melee_damage_upper = 20
	organ_names = /decl/mob_organ_names/artificer
	attacktext = list("rammed")
	attack_sound = 'sound/weapons/rapidslice.ogg'
	construct_spells = list(/spell/aoe_turf/conjure/construct/lesser,
							/spell/aoe_turf/conjure/wall,
							/spell/aoe_turf/conjure/floor,
							/spell/aoe_turf/conjure/soulstone,
							/spell/aoe_turf/conjure/pylon,
							/spell/aoe_turf/conjure/door,
							/spell/aoe_turf/conjure/grille,
							/spell/targeted/occult_repair_aura,
							/spell/targeted/construct_advanced/mend_acolyte
							)
	ai_holder_type = /datum/ai_holder/mimic

/decl/mob_organ_names/artificer
	hit_zones = list("body", "carapace", "right manipulator", "left manipulator", "upper left appendage", "upper right appendage", "eye")

////////////////////////////
//		Ranged Artificer
////////////////////////////

/mob/living/simple_mob/construct/artificer/caster
	name = "Artificer"
	real_name = "Artificer"
	construct_type = "artificer"
	desc = "A bulbous construct dedicated to building and maintaining temples to their otherworldly lords. Its central eye glows with unknowable power."
	icon_state = "caster_artificer"
	icon_living = "caster_artificer"
	ai_holder_type = /datum/ai_holder/simple_mob/ranged/kiting
	projectiletype = /obj/item/projectile/energy/inversion
	projectiletype = /obj/item/projectile/beam/inversion
	projectilesound = 'sound/weapons/spiderlunge.ogg'

////////////////////////////
//		Artificer
////////////////////////////

/mob/living/simple_mob/construct/proteon //Weak Swarm Attacker can be safely dumped on players in large numbers without too many injuries
	name = "Proteon"
	real_name = "proton"
	construct_type = "artificer"
	desc = "A weak but speedy construction designed to assist other constructs rather than fight. Still seems bloodthirtsy though."
	icon_state = "proteon"
	icon_living = "proteon"
	maxHealth = 50
	health = 50
	response_harm = "viciously beaten"
	harm_intent_damage = 5
	melee_damage_lower = 8 //It's not the strongest of the bunch, but that doesn't mean it can't hurt you.
	melee_damage_upper = 10
	attack_armor_pen = 50 // Does so little damage already, that this can be justified.
	attacktext = list("rammed")
	attack_sound = 'sound/weapons/rapidslice.ogg'
	movement_cooldown = 0

	ai_holder_type = /datum/ai_holder/simple_mob/melee/evasive
