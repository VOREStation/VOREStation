// Beeg bug do beeg noms. It also glows in the dark for maximum spook power.

/datum/category_item/catalogue/fauna/sect_queen
	name = "Creature - Sect Queen"
	desc = "A massively-sized insect that is native, although rarely spotted outside of its colony, to Virgo 3B. \
	It bears the combined physical traits of several of Earth's insects. Its forelegs have claws bearing serrated \
	edges, which it uses in both self-defense and during its hunts. Covering its body is a layer of thick and \
	protective chitin, resilient enough to absorb most physical damage. It is not uncommon for a queen to go out \
	alone to search for potential new nesting grounds... or perhaps it does so to seek bigger prey that its much \
	smaller drones might be unable to acquire. The lack  of chitin on the underside of its abdomen is deliberate, \
	as the flesh is very elastic and stretchable, allowing the queen to carry multiple large prey inside of its \
	stomach with ease."
	value = CATALOGUER_REWARD_MEDIUM

/mob/living/simple_mob/vore/sect_queen
	name = "sect queen"
	desc = "A titanic, chitin-plated insectoid whose multiple crimson eyes cast a frightful red light. Its \
	abdomen has an unusually soft and... flexible-looking underbelly..."

	icon_dead = "sect_queen_dead"
	icon_living = "sect_queen"
	icon_state = "sect_queen"
	icon = 'icons/mob/vore64x64.dmi'
	vis_height = 64
	has_eye_glow = TRUE

	faction = "insects"
	maxHealth = 200
	health = 200
	see_in_dark = 8


	melee_damage_lower = 8
	melee_damage_upper = 16
	grab_resist = 100 // you can't even wrap your arms around this thing, how could you hope to grab it???

	vore_active = 1
	vore_capacity = 2
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
	mount_offset_y = 26

	ai_holder_type = /datum/ai_holder/simple_mob/melee
	say_list_type = /datum/say_list/sect_queen

/datum/say_list/sect_queen
	say_got_target = list("chitters angrily!")