/datum/alloy/plastitanium
	metaltag = MAT_PLASTITANIUM
	requires = list(
		ORE_RUTILE = 1,
		ORE_PLATINUM = 1,
		ORE_CARBON = 2,
		)
	product_mod = 0.3
	product = /obj/item/stack/material/plastitanium

/datum/alloy/tiglass
	metaltag = MAT_TITANIUMGLASS
	requires = list(
		ORE_RUTILE = 1,
		ORE_SAND = 2
		)
	product_mod = 1
	product = /obj/item/stack/material/glass/titanium

/datum/alloy/plastiglass
	metaltag = MAT_PLASTITANIUMGLASS
	requires = list(
		ORE_RUTILE = 1,
		ORE_SAND = 2,
		ORE_PLATINUM = 1,
		ORE_CARBON = 2,
		)
	product_mod = 1
	product = /obj/item/stack/material/glass/plastitanium
