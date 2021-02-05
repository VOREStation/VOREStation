/mob/living/simple_mob/animal/passive/honkpet
	name = "Hinkle"
	desc = "At the Clown Planet Institute, these animals are mass produced for each student to raise and take care of."
	tt_desc = "Coulrian Honkus"
	icon = 'icons/mob/animal_vr.dmi'
	icon_state = "c_pet"
	icon_living = "c_pet"
	icon_dead = "c_pet_dead"

	maxHealth = 20
	health = 20
	minbodytemp = 175 // Same as Sif mobs.

	response_help  = "pets"
	response_disarm = "pushes aside"
	response_harm   = "hits"

	harm_intent_damage = 5
	melee_damage_lower = 10
	melee_damage_upper = 15
	attacktext = list("honked")

	has_langs = list("Coulrian")



/mob/living/simple_mob/animal/passive/mimepet
	name = "Dave"
	desc = "That's Dave."
	tt_desc = "Polypodavesilencia"
	icon = 'icons/mob/animal_vr.dmi'
	icon_state = "dave"
	icon_living = "dave"
	icon_dead = "dave_dead"
	movement_cooldown = 300

	maxHealth = 20
	health = 20
	minbodytemp = 175 // Same as Sif mobs.

	response_help  = "pets"
	response_disarm = "pushes aside"
	response_harm   = "hits"

	harm_intent_damage = 5
	melee_damage_lower = 10
	melee_damage_upper = 15
	attacktext = list("...")