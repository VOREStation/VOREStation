// Crystal-feather "ducks" are rather weak, but will become aggressive if you have food.

/datum/category_item/catalogue/fauna/crystalduck
	name = "Sivian Fauna - Crystal-Feather Duck"
	desc = "Classification: S Anatidae vitriae \
	<br><br>\
	Small, asocial omnivores with glistening, razor-thin feathers valued for their use as a reflective glitter by poachers. \
	The Crystal-Feather Duck commonly forms at most a familial group of four, a male, two females, and a single 'chosen' young. Primarily detrivorous browsers, \
	supplementing their diet with animals living below thinner shore ice-sheets. \
	Family units have been observed to form gangs and scavenge from Sivian domeciles and \
	various food transports during stressful months. \
	It is advised to seal and hide any form of food near even lone individuals, as they will become \
	increasingly aggressive."
	value = CATALOGUER_REWARD_EASY

/mob/living/simple_mob/animal/sif/duck
	name = "crystal-feather duck"
	desc = "A glittering flightless bird."
	tt_desc = "S Anatidae vitriae"
	catalogue_data = list(/datum/category_item/catalogue/fauna/crystalduck)

	faction = "duck"

	icon_state = "duck"
	icon_living = "duck"
	icon_dead = "duck_dead"
	icon = 'icons/mob/animal.dmi'
	has_eye_glow = TRUE

	maxHealth = 50
	health = 50

	movement_cooldown = 0

	melee_damage_lower = 2
	melee_damage_upper = 10
	base_attack_cooldown = 1 SECOND
	attack_edge = 1		// Razor-edged wings, and 'claws' made for digging through ice.
	attacktext = list("nipped", "bit", "cut", "clawed")

	say_list_type = /datum/say_list/duck
	ai_holder_type = /datum/ai_holder/simple_mob/retaliate/cooperative

/datum/say_list/duck
	speak = list("Wack!", "Wock?", "Wack.")
	emote_see = list("ruffles its wings","looks around", "preens itself")
	emote_hear = list("quacks", "giggles")

/mob/living/simple_mob/animal/sif/duck/IIsAlly(mob/living/L)
	. = ..()

	var/has_food = FALSE
	for(var/obj/item/I in L.get_contents())	// Do they have food?
		if(istype(I, /obj/item/weapon/reagent_containers/food))
			has_food = TRUE
			break
	if(has_food)	// Yes? Gimme the food.
		return FALSE
