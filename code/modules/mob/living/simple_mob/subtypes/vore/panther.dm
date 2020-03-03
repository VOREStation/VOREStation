/mob/living/simple_mob/vore/aggressive/panther
	name = "panther"
	desc = "Runtime's larger, less cuddly cousin."
	tt_desc = "Panthera pardus"

	icon_state = "panther"
	icon_living = "panther"
	icon_dead = "panther-dead"
	icon = 'icons/mob/vore64x64.dmi'
	vis_height = 64

	faction = "panther"
	maxHealth = 200
	health = 200
	movement_cooldown = 4
	see_in_dark = 8

	melee_damage_lower = 5
	melee_damage_upper = 15
	attack_sharp = TRUE

	response_help = "pats"
	response_disarm = "tries to shove"
	response_harm = "hits"

	old_x = -16
	old_y = 0
	default_pixel_x = -16
	pixel_x = -16
	pixel_y = 0

	max_buckled_mobs = 1 //Yeehaw
	can_buckle = TRUE
	buckle_movable = TRUE
	buckle_lying = FALSE
	mount_offset_y = 12

	say_list_type = /datum/say_list/panther
	ai_holder_type = /datum/ai_holder/simple_mob/melee/evasive

// Activate Noms!
/mob/living/simple_mob/vore/aggressive/panther
	vore_active = 1
	vore_capacity = 2
	vore_pounce_chance = 10
	vore_icons = SA_ICON_LIVING | SA_ICON_REST

/mob/living/simple_mob/vore/aggressive/panther/Login()
	. = ..()
	if(!riding_datum)
		riding_datum = new /datum/riding/simple_mob(src)
	verbs |= /mob/living/simple_mob/proc/animal_mount
	verbs |= /mob/living/proc/toggle_rider_reins
	movement_cooldown = 0

/mob/living/simple_mob/vore/aggressive/panther/MouseDrop_T(mob/living/M, mob/living/user)
	return

/datum/say_list/panther
	speak = list("RAWR!","Rawr!","GRR!","Growl!")
	emote_hear = list("rawrs","rumbles","rowls","growls","roars")
	emote_see = list("stares ferociously", "snarls")
