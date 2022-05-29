/datum/category_item/synthesizer/New()
	..()
	var/obj/item/I
	if(path)
		I = new path()

	if(!I)	// Something has gone horribly wrong, or right.
		log_debug("[name] created an Synthesizer design without an assigned path.")
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
	color = "#4b0082"

/****************************
* Category Collection Setup *
****************************/

/datum/category_collection/synthesizer_recipes
	category_group_type = /datum/category_group/synthesizer



/*************
* Categories *
*************/

/datum/category_group/synthesizer

/datum/category_group/synthesizer/all
	name = "All"
	category_item_type = /datum/category_item/synthesizer

/datum/category_group/synthesizer/basic
	name = "Basics"
	category_item_type = /datum/category_item/synthesizer/basic

/*
/datum/category_group/synthesizer/raw
	name = "Raw"
	category_item_type = /datum/category_item/synthesizer/raw

/datum/category_group/synthesizer/cooked
	name = "Cooked"
	category_item_type = /datum/category_item/synthesizer/cooked

/datum/category_group/synthesizer/liquid
	name = "Liquid"
	category_item_type = /datum/category_item/synthesizer/liquid

/datum/category_group/synthesizer/noodle
	name = "Noodles"
	category_item_type = /datum/category_item/synthesizer/noodle

/datum/category_group/synthesizer/exotic
	name = "Exotic"
	category_item_type = /datum/category_item/synthesizer/exotic */

/*******************
* Category entries *
*******************/

/datum/category_item/synthesizer
	var/path
	var/hidden = FALSE
	var/list/voice_order
	var/voice_temp

/datum/category_item/synthesizer/basic/meat
	name = "meat steak"
	path = /obj/item/weapon/reagent_containers/food/snacks/meat
	voice_order = list("meat slab","slab of meat","steak")
	voice_temp = "cold"

/datum/category_item/synthesizer/basic/corgi
	name = "corgi steak"
	path = /obj/item/weapon/reagent_containers/food/snacks/meat/corgi
	voice_order = list("Dog steak", "Dog", "Canine")
	voice_temp = "cold"
	hidden = TRUE

/*
/datum/category_item/synthesizer/exotic/micro
	name = "Crew Replica"
	path = /obj/item/weapon/holder/micro
	voice_order = list("micro", "crewmember", "crew member", "crew", "nerd", "snackrifice", "snacksized", "snack-sized", "snack sized")
	voice_temp = findsnackrifice(

/datum/category_item/synthesizer/exotic/micro/proc/findsnackrifice(mob/snack)
	var/mob/snack
	var/matrix/original_transform

/datum/category_item/synthesizer/exotic/micro/proc/assemblesnackrifice
	vis_contents += held
	name = held.name
	original_transform = held.transform
	held.transform = null */

/datum/category_item/synthesizer/dd_SortValue()
	return name