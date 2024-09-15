/mob/living/simple_mob/vore/aggressive/dino
	name = "voracious lizard"
	desc = "These gluttonous little bastards used to be regular lizards that were mutated by long-term exposure to phoron!"

	icon_dead = "dino-dead"
	icon_living = "dino"
	icon_state = "dino"
	icon = 'icons/mob/vore.dmi'

	ai_holder_type = /datum/ai_holder/simple_mob/melee

	// By default, this is what most vore mobs are capable of.
	response_help = "pets"
	response_disarm = "gently pushes aside"
	response_harm = "hits"
	movement_cooldown = 0.5
	harm_intent_damage = 5
	melee_damage_lower = 5
	melee_damage_upper = 12
	attacktext = list("bitten")
	attack_sound = 'sound/weapons/bite.ogg'
	minbodytemp = 200
	maxbodytemp = 370
	heat_damage_per_tick = 15
	cold_damage_per_tick = 10
	unsuitable_atoms_damage = 10

	meat_amount = 5
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat

	//Phoron dragons aren't affected by atmos.
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0

	allow_mind_transfer = TRUE

// Activate Noms!
/mob/living/simple_mob/vore/aggressive/dino
	vore_active = 1
	swallowTime = 1 SECOND // Hungry little bastards.
	vore_icons = SA_ICON_LIVING

/mob/living/simple_mob/vore/aggressive/dino/virgo3b
	faction = FACTION_VIRGO3B
