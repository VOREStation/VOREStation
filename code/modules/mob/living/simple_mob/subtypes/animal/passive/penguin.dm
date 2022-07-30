/mob/living/simple_mob/animal/passive/penguin
	name = "penguin"
	desc = "An ungainly, waddling, cute, and VERY well-dressed bird."
	tt_desc = "Aptenodytes forsteri"
	icon_state = "penguin"
	icon_living = "penguin"
	icon_dead = "penguin_dead"

	maxHealth = 20
	health = 20
	minbodytemp = 175 // Same as Sif mobs.

	response_help  = "pets"
	response_disarm = "pushes aside"
	response_harm   = "hits"

	organ_names = /decl/mob_organ_names/penguin

	meat_amount = 3
	meat_type = /obj/item/reagent_containers/food/snacks/meat/chicken

	harm_intent_damage = 5
	melee_damage_lower = 10
	melee_damage_upper = 15
	attacktext = list("pecked")

	has_langs = list("Bird")

/mob/living/simple_mob/animal/passive/penguin/tux
	name = "Tux"
	desc = "A penguin that has been known to associate with gnus."
	speak_emote = list("interjects")

/decl/mob_organ_names/penguin
	hit_zones = list("chest", "left leg", "right leg", "left flipper", "right flipper", "head")
