/datum/category_item/synthesizer/New()
	..()
	var/obj/item/I
	if(path)
		I = new path()

	if(!I)	// Something has gone horribly wrong, or right.
		log_debug("[name] created an Autolathe design without an assigned path.")
		return

	if(I.matter && !resources)
		resources = list()
		for(var/material in I.matter)
			var/coeff = (no_scale ? 1 : 1.25) //most objects are more expensive to produce than to recycle
			resources[material] = I.matter[material]*coeff // but if it's a sheet or RCD cartridge, it's 1:1
	if(is_stack)
		if(istype(I, /obj/item/stack))
			var/obj/item/stack/IS = I
			max_stack = IS.max_amount
		else
			max_stack = 10
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

		var/datum/category_item/autolathe/materials/WorkDat = new(src, M)

		items |= WorkDat
		items_by_name[WorkDat.name] = WorkDat
