/datum/category_item/catalogue/fauna/sect_drone
	name = "Creature - Sect Drone"
	desc = "Database Update Pending"			//TODO: Virgo Lore Writing WIP
	value = CATALOGUER_REWARD_MEDIUM

/mob/living/simple_mob/vore/sect_drone
	name = "sect drone"
	desc = "A large, chitin-plated insectoid whose multiple cyan eyes cast a frightful blue light. Its \
	abdomen has an unusually soft and... flexible-looking underbelly..."

	icon_dead = "sect_drone_dead"
	icon_living = "sect_drone"
	icon_state = "sect_drone"
	icon = 'icons/mob/vore64x64.dmi'
	vis_height = 64
	has_eye_glow = TRUE

	faction = "insects"
	maxHealth = 90
	health = 90
	see_in_dark = 8

	movement_cooldown = 3

	melee_damage_lower = 6
	melee_damage_upper = 12
	grab_resist = 100 // you can't even wrap your arms around this thing, how could you hope to grab it???

	vore_active = 1
	vore_capacity = 1
	vore_pounce_chance = 70 // v hongry buggo
	vore_icons = SA_ICON_LIVING

	//Beeg bug don't give a fuck about atmos. Something something, phoron mutation.
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0

	response_help = "pats"
	response_disarm = "tries to shove"
	response_harm = "hits"
	attacktext = list("slashed")
	friendly = list("nuzzles", "caresses", "headbumps against", "leans against", "nibbles affectionately on", "antennae tickles") // D'awww

	old_x = -16
	old_y = 0
	default_pixel_x = -16
	pixel_x = -16
	pixel_y = 0

	max_buckled_mobs = 1 //Yeehaw
	can_buckle = TRUE
	buckle_movable = TRUE
	buckle_lying = FALSE
	mount_offset_y = 7

	ai_holder_type = /datum/ai_holder/simple_mob/melee
	say_list_type = /datum/say_list/sect_drone

/datum/say_list/sect_drone
	say_got_target = list("chitters threateningly!")