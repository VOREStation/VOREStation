////////////////////////////
//			Wraith
////////////////////////////

/mob/living/simple_mob/construct/wraith
	name = "Wraith"
	real_name = "Wraith"
	construct_type = "wraith"
	desc = "A wicked bladed shell contraption piloted by a bound spirit."
	icon = 'icons/mob/mob.dmi'
	icon_state = "floating"
	icon_living = "floating"
	maxHealth = 200
	health = 200
	melee_damage_lower = 25
	melee_damage_upper = 30
	attack_armor_pen = 15
	attack_sharp = 1
	attack_edge = 1
	attacktext = list("slashed")
	friendly = list("pinches")
	movement_cooldown = 0
	attack_sound = 'sound/weapons/rapidslice.ogg'
	construct_spells = list(/spell/targeted/ethereal_jaunt/shift,
							/spell/targeted/ambush_mode
							)

//	environment_smash = 1	// Whatever this gets renamed to, Wraiths need to break things

/mob/living/simple_mob/construct/wraith/apply_melee_effects(var/atom/A)
	if(isliving(A))
		var/mob/living/L = A
		L.add_modifier(/datum/modifier/deep_wounds, 30 SECONDS)