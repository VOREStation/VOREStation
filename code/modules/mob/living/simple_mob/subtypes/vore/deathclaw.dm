/datum/category_item/catalogue/fauna/deathclaw		//TODO: VIRGO_LORE_WRITING_WIP
	name = "Creature - Deathclaw"
	desc = "A massive beast, tall as three standard-size humans, with massive, terrifying claws, \
	and dark, black fangs. It's entire body is yellowish, like sand, and it's skin is leathery and tough. \
	It seems to have adapted to the harsh desert environment on Virgo 4, and makes it's home inside the caves."
	value = CATALOGUER_REWARD_HARD

/mob/living/simple_mob/vore/aggressive/deathclaw
	name = "deathclaw"
	desc = "Big! Big! The size of three men! Claws as long as my forearm! Ripped apart! Ripped apart!"

	icon_dead = "deathclaw-dead"
	icon_living = "deathclaw"
	icon_state = "deathclaw"
	icon = 'icons/mob/vore64x64.dmi'

	attacktext = list("mauled")

	faction = "deathclaw"

	maxHealth = 200
	health = 200

	melee_damage_lower = 5
	melee_damage_upper = 30

	old_x = -16
	old_y = 0
	default_pixel_x = -16
	pixel_x = -16
	pixel_y = 0

	max_buckled_mobs = 1 //Yeehaw
	can_buckle = TRUE
	buckle_movable = TRUE
	buckle_lying = FALSE
	mount_offset_x = 5
	mount_offset_y = 30

	ai_holder_type = /datum/ai_holder/simple_mob/melee/deathclaw

// Activate Noms!
/mob/living/simple_mob/vore/aggressive/deathclaw
	vore_active = 1
	vore_capacity = 2
	vore_max_size = RESIZE_HUGE
	vore_min_size = RESIZE_SMALL
	vore_pounce_chance = 0 // Beat them into crit before eating.
	vore_icons = SA_ICON_LIVING

/* //VOREStation AI Temporary Removal
/mob/living/simple_animal/hostile/deathclaw/Login()
	. = ..()
	if(!riding_datum)
		riding_datum = new /datum/riding/simple_animal(src)
	verbs |= /mob/living/simple_animal/proc/animal_mount

/mob/living/simple_animal/hostile/deathclaw/MouseDrop_T(mob/living/M, mob/living/user)
	return
*/

/datum/ai_holder/simple_mob/melee/deathclaw
	can_breakthrough = TRUE
	violent_breakthrough = TRUE
