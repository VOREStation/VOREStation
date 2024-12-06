//Alloys that contain subsets of each other's ingredients must be ordered in the desired sequence
//eg. steel comes after plasteel because plasteel's ingredients contain the ingredients for steel and
//it would be impossible to produce.

/datum/alloy
	var/list/requires
	var/product_mod = 1
	var/product
	var/metaltag

/datum/alloy/durasteel
	metaltag = MAT_DURASTEEL
	requires = list(
		ORE_DIAMOND = 1,
		ORE_PLATINUM = 1,
		ORE_CARBON = 2,
		ORE_HEMATITE = 2
		)
	product_mod = 0.3
	product = /obj/item/stack/material/durasteel

/datum/alloy/plasteel
	metaltag = MAT_PLASTEEL
	requires = list(
		ORE_PLATINUM = 1,
		ORE_CARBON = 2,
		ORE_HEMATITE = 2
		)
	product_mod = 0.3
	product = /obj/item/stack/material/plasteel

/datum/alloy/steel
	metaltag = MAT_STEEL
	requires = list(
		ORE_CARBON = 1,
		ORE_HEMATITE = 1
		)
	product = /obj/item/stack/material/steel

/datum/alloy/borosilicate
	metaltag = MAT_PGLASS
	requires = list(
		ORE_PLATINUM = 1,
		ORE_SAND = 2
		)
	product = /obj/item/stack/material/glass/phoronglass
/*
/datum/alloy/bronze
	metaltag = MAT_BRONZE
	requires = list(
		ORE_COPPER = 2,
		ORE_TIN = 1
		)
	product = /obj/item/stack/material/bronze
*/
