/mob/living/simple_mob/tomato
	name = "tomato"
	desc = "It's a horrifyingly enormous beef tomato, and it's packing extra beef!"
	tt_desc = "X Solanum abominable"
	icon_state = "tomato"
	icon_living = "tomato"
	icon_dead = "tomato_dead"

	mob_class = MOB_CLASS_PLANT

	faction = "plants"
	maxHealth = 15
	health = 15
	poison_resist = 1.0

	response_help  = "prods"
	response_disarm = "pushes aside"
	response_harm   = "smacks"

	harm_intent_damage = 5
	melee_damage_upper = 15
	melee_damage_lower = 10
	attacktext = list("mauled")

	ai_holder_type = /datum/ai_holder/simple_mob/melee

	meat_type = /obj/item/weapon/reagent_containers/food/snacks/tomatomeat
