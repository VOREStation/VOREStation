//Look Sir, free crabs!
/mob/living/simple_mob/animal/passive/crab
	name = "crab"
	desc = "A hard-shelled crustacean. Seems quite content to lounge around all the time."
	tt_desc = "E Cancer bellianus"
	faction = "crabs"

	icon_state = "crab"
	icon_living = "crab"
	icon_dead = "crab_dead"

	mob_size = MOB_SMALL

	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "stomps"
	friendly = "pinches"

	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat/crab

	say_list_type = /datum/say_list/crab

//COFFEE! SQUEEEEEEEEE!
/mob/living/simple_mob/animal/passive/crab/Coffee
	name = "Coffee"
	real_name = "Coffee"
	desc = "It's Coffee, the other pet!"

// Sif!

/datum/category_item/catalogue/fauna/sif_crab
	name = "Sivian Fauna - Shelf Crab"
	desc = "Classification: S Ocypode glacian\
	<br><br>\
	A small crustacean sometimes considered a pest to Sivian fisheries, \
	as the creatures often tend to ignore non-native fish species when feeding. This \
	results in an unfortunate advantage for invasive species. \
	<br>\
	Otherwise, these animals are enjoyed as a reliable source of high-grade meat."
	value = CATALOGUER_REWARD_EASY

/mob/living/simple_mob/animal/passive/crab/sif
	icon = 'icons/mob/fish.dmi'
	tt_desc = "S Ocypode glacian"

	catalogue_data = list(/datum/category_item/catalogue/fauna/sif_crab)

/mob/living/simple_mob/animal/passive/crab/sif/Initialize()
	. = ..()
	adjust_scale(rand(5,12) / 10)

// Meat!

/obj/item/weapon/reagent_containers/food/snacks/meat/crab
	name = "meat"
	desc = "A chunk of meat."
	icon_state = "crustacean-meat"