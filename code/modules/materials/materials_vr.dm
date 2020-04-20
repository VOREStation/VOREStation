/material/flesh
	name = "flesh"
	display_name = "chunk of flesh"
	icon_colour = "#dd90aa"
	sheet_singular_name = "meat"
	sheet_plural_name = "meats"
	integrity = 1200
	melting_point = 6000
	explosion_resistance = 200
	hardness = 500
	weight = 500

/material/fluff //This is to allow for 2 handed weapons that don't want to have a prefix.
	name = " "
	display_name = ""
	icon_colour = "#000000"
	sheet_singular_name = "fluff"
	sheet_plural_name = "fluffs"
	hardness = 60
	weight = 20 //Strong as iron.

/material/darkglass
	name = "darkglass"
	display_name = "darkglass"
	icon_base = "darkglass"
	icon_colour = "#FFFFFF"

/material/fancyblack
	name = "fancyblack"
	display_name = "fancyblack"
	icon_base = "fancyblack"
	icon_colour = "#FFFFFF"

/material/glass/titaniumglass
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
	composite_material = list(MAT_TITANIUM = SHEET_MATERIAL_AMOUNT, "glass" = SHEET_MATERIAL_AMOUNT)

/material/plastitanium
	name = MAT_PLASTITANIUM
	stack_type = /obj/item/stack/material/plastitanium
	integrity = 600
	melting_point = 9000
	icon_base = "solid"
	icon_reinf = "reinf_over"
	icon_colour = "#585658"
	explosion_resistance = 35
	hardness = 90
	weight = 40
	protectiveness = 30
	conductivity = 7
	stack_origin_tech = list(TECH_MATERIAL = 5)
	composite_material = list(MAT_TITANIUM = SHEET_MATERIAL_AMOUNT, MAT_PLASTEEL = SHEET_MATERIAL_AMOUNT)

/material/glass/plastaniumglass
	name = MAT_PLASTANIUMGLASS
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
	composite_material = list(MAT_PLASTITANIUM = SHEET_MATERIAL_AMOUNT, "glass" = SHEET_MATERIAL_AMOUNT)