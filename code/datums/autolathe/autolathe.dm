var/datum/category_collection/autolathe/autolathe_recipes

/datum/category_item/autolathe/New()
	..()
	var/obj/item/I = new path()
	if(I.matter && !resources)
		resources = list()
		for(var/material in I.matter)
			resources[material] = I.matter[material]*1.25 // More expensive to produce than they are to recycle.
	if(is_stack && istype(I, /obj/item/stack))
		var/obj/item/stack/IS = I
		max_stack = IS.max_amount
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

/*******************
* Category entries *
*******************/

/datum/category_item/autolathe
	var/path
	var/list/resources
	var/hidden
	var/power_use = 0
	var/is_stack
	var/max_stack

/datum/category_item/autolathe/dd_SortValue()
	return name