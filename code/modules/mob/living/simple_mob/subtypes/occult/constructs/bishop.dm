////////////////////////////
//	Purity Construct - Bishop
////////////////////////////

/mob/living/simple_mob/construct/bishop
	name = "Bishop"
	real_name = "Bishop"
	construct_type = "Bishop"
	faction = "purity"
	desc = "A medium sized construct of the purity worshippers mechanical followers, sturdy and deadly, these constructs are commanded by an archbishop, tasked with patrolling and eliminating threats to their flock."
	icon_state = "bishop"
	icon_living = "bishop"
	ui_icons = 'icons/mob/screen1_purity.dmi'
	maxHealth = 250
	health = 250
	melee_damage_lower = 15
	melee_damage_upper = 20
	attack_armor_pen = 15
	attack_sharp = TRUE
	attack_edge = 1
	attacktext = list("slashed")
	friendly = list("pinches")
	organ_names = /decl/mob_organ_names/wraith
	movement_cooldown = -1
	attack_sound = 'sound/weapons/rapidslice.ogg'
	construct_spells = list(/spell/targeted/construct_advanced/crippling_beam,
							/spell/targeted/construct_advanced/banishment
							)

	ai_holder_type = /datum/ai_holder/simple_mob/retaliate/cooperative

//	environment_smash = 1	// Whatever this gets renamed to, Wraiths need to break things

/mob/living/simple_mob/construct/bishop/apply_melee_effects(var/atom/A)
	if(isliving(A))
		var/mob/living/L = A
		L.add_modifier(/datum/modifier/deep_wounds, 30 SECONDS)

/decl/mob_organ_names/wraith
	hit_zones = list("body", "eye", "crystaline spike", "left claw", "right claw")

////////////////////////////
//	Purity Construct - Archbishop
////////////////////////////

/mob/living/simple_mob/construct/bishop/arch
	name = "Archbishop"
	real_name = "Archbishop"
	construct_type = "Archbishop"
	faction = "purity"
	desc = "A large sized construct of the purity worshippers mechanical followers, one of their most advanced, it is the right hand of purification, dedicated to the pursuit of eradicating those who cause harm their charge."
	icon_state = "archbishop"
	icon_living = "archbishop"
	ui_icons = 'icons/mob/screen1_purity.dmi'
	maxHealth = 200
	health = 200
	melee_damage_lower = 20 //hits much harder then most purity constructs
	melee_damage_upper = 30
	attack_armor_pen = 50 //armor is no match against its religious wrath
	attack_sharp = 1
	attack_edge = 1
	attacktext = list("violently stabbed")
	friendly = list("caresses")
	organ_names = /decl/mob_organ_names/wraith
	movement_cooldown = 0

	ai_holder_type = /datum/ai_holder/simple_mob/retaliate/cooperative

	//	environment_smash = 1	// Whatever this gets renamed to, Harvesters need to break things

	attack_sound = 'sound/weapons/pierce.ogg'

/decl/mob_organ_names/wraith
	hit_zones = list("body", "eye", "crystaline spike", "left claw", "right claw")
