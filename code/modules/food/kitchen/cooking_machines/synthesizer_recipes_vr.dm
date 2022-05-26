/datum/category_item/synthesizer/New()
	..()
	var/obj/item/I
	if(path)
		I = new path()

	if(!I)	// Something has gone horribly wrong, or right.
		log_debug("[name] created an Autolathe design without an assigned path.")
		return
	qdel(I)

/*********************
* Synthed Food Setup *
**********************/
/obj/item/weapon/reagent_containers/food/snacks/synthsized_meal
	name = "Nutrient paste meal"
	desc = "It's a synthisized edible wafer of nutrients. Everything you need and makes field rations a delicacy in comparison."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "pasteblock"
	filling_color = "#c5e384"
	center_of_mass = list("x"=16, "y"=6)
	nutriment_desc = list("undefinable blandness" = 1)
	w_class = ITEMSIZE_SMALL
	nutriment_amt = 1

//gotta make the fuel a thing, might as well make it horrid, amirite. Should only be a cargo import.
/datum/reagent/nutriment/synthsyolent
	name = "Soylent Agent Green"
	id = "synthsoygreen"
	description = "An thick, horridly rubbery fluid that somehow can be synthisized into 'edible' meals."
	taste_description = "unrefined cloying oil"
	taste_mult = 1.3
	nutriment_factor = 1
	reagent_state = LIQUID
	color = "#faebd7"

/*******************
* Category entries *
*******************/

/datum/category_item/synthesizer
	var/path
	var/hidden = FALSE
	var/voice_order
	var/voice_temp


/****************************
* Category Collection Setup *
****************************/

/datum/category_collection/synthesizer_recipes
	category_group_type = /datum/category_group/synthesizer_recipes



/*************
* Categories *
*************/

/datum/category_group/synthesizer_recipes

/datum/category_group/synthesizer_recipes/all
	name = "All"
	category_item_type = /datum/category_item/synthesizer

/datum/category_group/synthesizer_recipes/basic
	name = "Basics"
	category_item_type = /datum/category_item/synthesizer/basic

/*
/datum/category_group/synthesizer_recipes/raw
	name = "Raw"
	category_item_type = /datum/category_item/synthesizer/raw

/datum/category_group/synthesizer_recipes/cooked
	name = "Cooked"
	category_item_type = /datum/category_item/synthesizer/cooked

/datum/category_group/synthesizer_recipes/liquid
	name = "Liquid"
	category_item_type = /datum/category_item/synthesizer/liquid

/datum/category_group/synthesizer_recipes/noodle
	name = "Noodles"
	category_item_type = /datum/category_item/synthesizer/noodle

/datum/category_group/synthesizer_recipes/exotic
	name = "Exotic"
	category_item_type = /datum/category_item/synthesizer/exotic */

/datum/category_item/synthesizer/basic/meat
	name = "meat steak"
	path = /obj/item/weapon/reagent_containers/food/snacks/meat

/datum/category_item/synthesizer/basic/corgi
	name = "corgi steak"
	path = /obj/item/weapon/reagent_containers/food/snacks/meat/corgi
	hidden = TRUE