/datum/category_item/catalogue/fauna/wolf		//TODO: VIRGO_LORE_WRITING_WIP
	name = "Creature - Wolf"
	desc = "Some sort of wolf, a descendent or otherwise of regular Earth canidae. They look almost exactly like their \
	Earth counterparts, except for the fact that their fur is a uniform grey. Some do show signs of unique coloration, and they \
	love to nip and bite at things, as well as sniffing around. They seem to mark their territory by way of scent-marking/urinating on things."
	value = CATALOGUER_REWARD_MEDIUM

/mob/living/simple_mob/animal/wolf
	name = "grey wolf"
	desc = "My, what big jaws it has!"
	tt_desc = "Canis lupus"

	icon_dead = "wolf-dead"
	icon_living = "wolf"
	icon_state = "wolf"
	icon = 'icons/mob/vore.dmi'

	movement_cooldown = 5

	harm_intent_damage = 5
	melee_damage_lower = 5
	melee_damage_upper = 12

	minbodytemp = 200

	ai_holder_type = /datum/ai_holder/simple_mob/melee/evasive

// Activate Noms!
/mob/living/simple_mob/animal/wolf
	vore_active = 1
	vore_icons = SA_ICON_LIVING
