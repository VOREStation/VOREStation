/mob/living/simple_mob/hostile/panther
	name = "panther"
	desc = "Runtime's larger, less cuddly cousin."
	tt_desc = "Panthera pardus"
	icon = 'icons/mob/vore64x64.dmi'
	icon_state = "panther"
	icon_living = "panther"
	icon_dead = "panther-dead"

	faction = "panther"
	maxHealth = 200
	health = 200
	move_to_delay = 4

	speak_chance = 2
	speak = list("RAWR!","Rawr!","GRR!","Growl!")
	speak_emote = list("growls", "roars")
	emote_hear = list("rawrs","rumbles","rowls")
	emote_see = list("stares ferociously", "snarls")

	melee_damage_lower = 10
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
	mount_offset_y = 12

// Activate Noms!
/mob/living/simple_mob/hostile/panther
	vore_active = 1
	vore_capacity = 2
	vore_pounce_chance = 10
	vore_icons = SA_ICON_LIVING | SA_ICON_REST

/mob/living/simple_animal/hostile/panther/Login()
	. = ..()
	if(!riding_datum)
		riding_datum = new /datum/riding/simple_animal(src)
	verbs |= /mob/living/simple_animal/proc/animal_mount

/mob/living/simple_animal/hostile/panther/MouseDrop_T(mob/living/M, mob/living/user)
	return