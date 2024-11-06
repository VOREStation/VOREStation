/datum/category_item/catalogue/fauna/sect_drone
	name = "Creature - Sect Drone"
	desc = "Classification: V Insecta gigantus\
	<br><br>\
	A massively-sized insect that is native to Virgo 3B. Much like its queen, it bears the combined physical traits \
	of several of Earth's insects. Its forelegs have claws bearing serrated edges much like a Mantis, which it uses \
	in both self-defense and during its hunts. On it's back are two large semi transparent wings like a beetle that it \
	uses for increased mobility. Covering its body is a layer of light, thick, and protective chitin, resilient enough to absorb \
	most physical damage while being light enough for the Sect Drone to hover. \
	<br>\
	It is not uncommon for a Sect Drone to go out alone to search for potential prey to bring back to the nest. \
	Regardless of reason, it is cautioned against approaching a Sect Drone as, like their queen, their behaviour is wildly \
	inconsistent. A Sect Drone can vary from hostile to docile depending on certain factors that scientists have \
	yet to uncover. \
	<br>\
	The lack  of chitin on the underside of its abdomen is deliberate, as the flesh is very elastic and stretchable, \
	allowing the drone to carry multiple large prey inside of its stomach with relative ease."
	value = CATALOGUER_REWARD_MEDIUM

/mob/living/simple_mob/vore/sect_drone
	name = "sect drone"
	desc = "A large, chitin-plated insectoid whose multiple cyan eyes cast a frightful blue light. Its \
	abdomen has an unusually soft and... flexible-looking underbelly..."
	tt_desc = "V Insecta gigantus"
	catalogue_data = list(/datum/category_item/catalogue/fauna/sect_drone)

	icon_dead = "sect_drone_dead"
	icon_living = "sect_drone"
	icon_state = "sect_drone"
	icon = 'icons/mob/vore64x64.dmi'
	vis_height = 64
	has_eye_glow = TRUE
	vore_eyes = TRUE
	custom_eye_color = "#00FFFF"

	faction = FACTION_INSECTS
	maxHealth = 90
	health = 90
	see_in_dark = 8

	movement_cooldown = 0

	melee_damage_lower = 6
	melee_damage_upper = 12
	grab_resist = 100 // you can't even wrap your arms around this thing, how could you hope to grab it???

	vore_active = 1
	vore_capacity = 1
	vore_pounce_chance = 70 // v hongry buggo
	vore_icons = SA_ICON_LIVING

	meat_amount = 4
	meat_type = /obj/item/reagent_containers/food/snacks/xenomeat/spidermeat

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

	allow_mind_transfer = TRUE

/mob/living/simple_mob/vore/sect_drone/Login()
	. = ..()
	add_verb(src,  /mob/living/simple_mob/vore/sect_drone/proc/set_abdomen_color)

/mob/living/simple_mob/vore/sect_drone/proc/set_abdomen_color()
	set name = "Set Glow Color"
	set desc = "Customize your eyes and abdomen glow color."
	set category = "Abilities.Sect Drone"

	var/new_color = input(src, "Please select color.", "Glow Color", custom_eye_color) as color|null
	if(new_color)
		custom_eye_color = new_color
		remove_eyes()
		add_eyes()

/datum/say_list/sect_drone
	say_got_target = list("chitters threateningly!")
