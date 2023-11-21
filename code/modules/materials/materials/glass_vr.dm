/datum/material/glass/titaniumglass
	name = MAT_TITANIUMGLASS
	display_name = "titanium glass"
	stack_type = /obj/item/stack/material/glass/titanium
	integrity = 150
	hardness = 50
	weight = 50
	flags = MATERIAL_BRITTLE
	icon_colour = "#A7A3A6"
	stack_origin_tech = list(TECH_MATERIAL = 5)
	window_options = list("One Direction" = 1, "Full Window" = 4)
	created_window = /obj/structure/window/titanium
	created_fulltile_window = /obj/structure/window/titanium/full
	wire_product = null
	rod_product = /obj/item/stack/material/glass/titanium

/datum/material/glass/plastaniumglass
	name = MAT_PLASTITANIUMGLASS
	display_name = "plas-titanium glass"
	stack_type = /obj/item/stack/material/glass/plastitanium
	integrity = 200
	hardness = 60
	weight = 80
	flags = MATERIAL_BRITTLE
	icon_colour = "#676366"
	stack_origin_tech = list(TECH_MATERIAL = 6)
	window_options = list("One Direction" = 1, "Full Window" = 4)
	created_window = /obj/structure/window/plastitanium
	created_fulltile_window = /obj/structure/window/plastitanium/full
	wire_product = null
	rod_product = /obj/item/stack/material/glass/plastitanium
