/mob/living/simple_animal/penguin
	name = "space penguin"
	desc = "An ungainly, waddling, cute, and VERY well-dressed bird."
	icon_state = "penguin"
	icon_living = "penguin"
	icon_dead = "penguin_dead"
	icon_gib = "generic_gib"

	maxHealth = 20
	health = 20

	turns_per_move = 5

	response_help  = "pets"
	response_disarm = "pushes aside"
	response_harm   = "hits"

	harm_intent_damage = 5
	melee_damage_lower = 10
	melee_damage_upper = 15
	attacktext = "pecked"

	has_langs = list("Bird")
	speak_chance = 0

	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat
