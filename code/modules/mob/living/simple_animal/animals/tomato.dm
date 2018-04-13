/mob/living/simple_animal/hostile/tomato
	name = "tomato"
	desc = "It's a horrifyingly enormous beef tomato, and it's packing extra beef!"
	icon_state = "tomato"
	icon_living = "tomato"
	icon_dead = "tomato_dead"
	intelligence_level = SA_PLANT

	faction = "plants"
	maxHealth = 15
	health = 15
	turns_per_move = 5

	response_help  = "prods"
	response_disarm = "pushes aside"
	response_harm   = "smacks"

	harm_intent_damage = 5
	melee_damage_upper = 15
	melee_damage_lower = 10
	attacktext = list("mauled")

	meat_type = /obj/item/weapon/reagent_containers/food/snacks/tomatomeat
