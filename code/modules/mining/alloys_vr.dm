/datum/alloy/plastitanium
	metaltag = MAT_PLASTITANIUM
	requires = list(
		"rutile" = 1,
		"platinum" = 1,
		REAGENT_ID_CARBON = 2,
		)
	product_mod = 0.3
	product = /obj/item/stack/material/plastitanium

/datum/alloy/tiglass
	metaltag = MAT_TITANIUMGLASS
	requires = list(
		"rutile" = 1,
		"sand" = 2
		)
	product_mod = 1
	product = /obj/item/stack/material/glass/titanium

/datum/alloy/plastiglass
	metaltag = MAT_PLASTITANIUMGLASS
	requires = list(
		"rutile" = 1,
		"sand" = 2,
		"platinum" = 1,
		REAGENT_ID_CARBON = 2,
		)
	product_mod = 1
	product = /obj/item/stack/material/glass/plastitanium
