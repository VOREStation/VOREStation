////////////////////////////
//	Purity Construct - Laity
////////////////////////////

/mob/living/simple_mob/construct/laity //Weak Swarm Attacker can be safely dumped on players in large numbers without too many injuries
	name = "Laity"
	real_name = "Laity"
	construct_type = "Laity"
	faction = "purity"
	desc = "A small construct of the purity worshippers mechanical followers, not hardy or particularly strong, very numerous."
	icon_state = "laity"
	icon_living = "laity"
	ui_icons = 'modular_chomp/icons/mob/screen1_purity.dmi'
	maxHealth = 75
	health = 75
	response_harm = "viciously beaten"
	harm_intent_damage = 5
	melee_damage_lower = 4 //It's not the strongest of the bunch, but that doesn't mean it can't hurt you.
	melee_damage_upper = 8
	attack_armor_pen = 50 // Does so little damage already, that this can be justified.
	attacktext = list("rammed")
	attack_sound = 'sound/weapons/rapidslice.ogg'
	movement_cooldown = 0

	ai_holder_type = /datum/ai_holder/simple_mob/retaliate/cooperative
