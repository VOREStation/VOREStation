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
	icon_state = "pasteblock"
	filling_color = "#c5e384"
	center_of_mass = list("x"=16, "y"=6)
	nutriment_desc = list("undefinable blandness" = 1)
	w_class = ITEMSIZE_SMALL
	nutriment_amt = 3

/*******************
* Category entries *
*******************/

/datum/category_item/synthesizer
	var/path
	var/list/nutriment_desc
	var/hidden
	var/icon
	var/icon_state
	var/desc
	var/filling_color

/datum/category_item/synthesizer/dd_SortValue()
	return name

/****************************
* Category Collection Setup *
****************************/

/datum/category_collection/synthesizer_recipes
	category_group_type = /datum/category_group/synthesizer_recipes

/datum/category_collection/synthesizer_recipes/proc/replicate(var/what, var/temp, var/mob/living/user)

/*************
* Categories *
*************/

/datum/category_group/synthesizer_recipes

/datum/category_group/synthesizer_recipes/all
	name = "All"
	category_item_type = /datum/category_item/synthesizer

// Copypasted from materials, they should show in All
/datum/category_group/synthesizer_recipes/all/New()
	..()

	for(var/Name in name_to_material)
		var/datum/material/M = name_to_material[Name]

		if(!M.stack_type)	// Shouldn't happen, but might. Never know.
			continue

		if(istype(M, /datum/material/alienalloy))
			continue

		var/obj/item/stack/material/S = M.stack_type
		if(initial(S.name) in items_by_name)
			continue

		var/datum/category_item/synthesizer/materials/WorkDat = new(src, M)

		items |= WorkDat
		items_by_name[WorkDat.name] = WorkDat

/datum/category_group/synthesizer_recipes/basic
	name = "Basics"
	category_item_type = /datum/category_item/synthesizer/basics

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
	category_item_type = /datum/category_item/synthesizer/exotic

/datum/category_item/synthesizer/general/ashtray_glass
	name = "glass ashtray"
	path =/obj/item/weapon/material/ashtray/glass