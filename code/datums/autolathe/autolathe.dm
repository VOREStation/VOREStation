<<<<<<< HEAD
=======
var/global/datum/category_collection/autolathe/autolathe_recipes

>>>>>>> 21bd8477c7e... Merge pull request #8531 from Spookerton/spkrtn/sys/global-agenda
/datum/category_item/autolathe/New()
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

/****************************
* Category Collection Setup *
****************************/

/datum/category_collection/autolathe
	category_group_type = /datum/category_group/autolathe

/*************
* Categories *
*************/

/datum/category_group/autolathe

/datum/category_group/autolathe/all
	name = "All"
	category_item_type = /datum/category_item/autolathe

// Copypasted from materials, they should show in All
/datum/category_group/autolathe/all/New()
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

///datum/category_group/autolathe/all/New()

/datum/category_group/autolathe/arms
	name = "Arms and Ammunition"
	category_item_type = /datum/category_item/autolathe/arms

/datum/category_group/autolathe/devices
	name = "Devices and Components"
	category_item_type = /datum/category_item/autolathe/devices

/datum/category_group/autolathe/engineering
	name = "Engineering"
	category_item_type = /datum/category_item/autolathe/engineering

/datum/category_group/autolathe/general
	name = "General"
	category_item_type = /datum/category_item/autolathe/general

/datum/category_group/autolathe/medical
	name = "Medical"
	category_item_type = /datum/category_item/autolathe/medical

/datum/category_group/autolathe/tools
	name = "Tools"
	category_item_type = /datum/category_item/autolathe/tools

/datum/category_group/autolathe/materials
	name = "Materials"
	category_item_type = /datum/category_item/autolathe/materials

/datum/category_group/autolathe/materials/New()
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

/*******************
* Category entries *
*******************/

/datum/category_item/autolathe
	var/path
	var/list/resources
	var/hidden
	var/power_use = 0
	var/is_stack // Creates multiple of an item if applied to non-stack items
	var/max_stack
	var/no_scale
	var/man_rating = 0

/datum/category_item/autolathe/dd_SortValue()
	return name