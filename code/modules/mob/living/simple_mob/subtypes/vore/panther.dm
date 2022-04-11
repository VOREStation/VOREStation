/mob/living/simple_mob/vore/aggressive/panther
	name = "panther"
	desc = "Runtime's larger, less cuddly cousin."
	tt_desc = "Panthera pardus"

	icon_state = "panther"
	icon_living = "panther"
	icon_rest = "panther-rest"
	icon_dead = "panther-dead"
	icon = 'icons/mob/vore64x64.dmi'
	vis_height = 64

	faction = "panther"
	maxHealth = 200
	health = 200
	movement_cooldown = 4
	see_in_dark = 8

	meat_amount = 8
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat

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
	movement_cooldown = 3

/mob/living/simple_mob/vore/aggressive/panther/MouseDrop_T(mob/living/M, mob/living/user)
	return

/mob/living/simple_mob/vore/aggressive/panther/init_vore()
	..()
	var/obj/belly/B = vore_selected
	B.name = "stomach"
	B.desc = "All it takes is a few more rasps of the panther's rough, barbed tongue to shovel the rest of you down its tightly rippling gullet... and with a final couple ravenous swallows, you spill out into the predatory feline's stomach! Right away, that gut's muscular walls knead and contract around you, forcing you into a curled-up ball as the panther's noisy purring rumbles into you from every direction."

	B.emote_lists[DM_HOLD] = list(
		"A steady white noise of content purring vibrates throughout you, the panther clearly enjoying the hanging, shifting swell you've given it.",
		"Your slick, gently churning surroundings abruptly clench inwards, smothering you in an all-encompassing, massage-filled hug before finally easing back.",
		"The strength of the content feline's purring is easily felt underneath its gut's constant massaging, vibrating the flesh in an utterly relaxing way.",
		"As the panther lazily struts around, its hanging, prey-laden belly on full display, you're rocked from side to side to a soothing, slosh-filled beat.",
		"For a moment, you can hear a few other sounds through the juicy sloshing and reverberating purring, such as the panther slurping its tongue over its chops.",
		"The possessive feline takes a moment to flump down into a resting position, its doughy insides kneading snugly around your curled figure until it shuffles back up.")

	B.emote_lists[DM_DIGEST] = list(
		"The big feline rumbles heartily, incredibly satisfied as it works to digest its newfound, stomach-filling catch!",
		"The surrounding stomach walls suddenly tighten inwards, smothering you in slimy, kneading flesh for a time until they finally relax back again!",
		"The purring of the content kitty is practically deafening within its churning depths, gently vibrating its gut flesh around you!",
		"The massive feline's gut sways from side to side as it prowls around, steadily coating you in hot digestive juices until you're practically soaked!",
		"You can hear the muffled sounds of the panther lickings its chops, savoring the remnants of your taste!",
		"The near-constant cacophony of digestive noises intensifies for a while, overwhelming your senses before finally calming down somewhat!")

/datum/say_list/panther
	speak = list("RAWR!","Rawr!","GRR!","Growl!")
	emote_hear = list("rawrs","rumbles","rowls","growls","roars")
	emote_see = list("stares ferociously", "snarls")
