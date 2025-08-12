////////////////////////////
//	Purity Construct - Priest
////////////////////////////

/mob/living/simple_mob/construct/priest
	name = "Priest"
	real_name = "Priest"
	construct_type = "Priest"
	faction = "purity"
	desc = "A medium sized construct of the purity worshippers mechanical followers, sturdy but lacking strength."
	icon_state = "priest"
	icon_living = "priest"
	ui_icons = 'icons/mob/screen1_purity.dmi'
	maxHealth = 200
	health = 200
	response_harm = "viciously beaten"
	harm_intent_damage = 5
	melee_damage_lower = 10 //It's not the strongest of the bunch, but that doesn't mean it can't hurt you.
	melee_damage_upper = 15
	organ_names = /decl/mob_organ_names/artificer
	attacktext = list("rammed")
	attack_sound = 'sound/weapons/rapidslice.ogg'
	construct_spells = list(/spell/targeted/purity_repair_aura,
							/spell/targeted/construct_advanced/mend_purity
							)

	ai_holder_type = /datum/ai_holder/simple_mob/retaliate/cooperative

/decl/mob_organ_names/artificer
	hit_zones = list("body", "carapace", "right manipulator", "left manipulator", "upper left appendage", "upper right appendage", "eye")
