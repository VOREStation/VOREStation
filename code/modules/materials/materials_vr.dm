/datum/material/flesh
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

/datum/material/fluff //This is to allow for 2 handed weapons that don't want to have a prefix.
	name = " "
	display_name = ""
	icon_colour = "#000000"
	sheet_singular_name = "fluff"
	sheet_plural_name = "fluffs"
	hardness = 60
	weight = 20 //Strong as iron.

/datum/material/darkglass
	name = "darkglass"
	display_name = "darkglass"
	icon_base = "darkglass"
	icon_colour = "#FFFFFF"

/datum/material/fancyblack
	name = "fancyblack"
	display_name = "fancyblack"
	icon_base = "fancyblack"
	icon_colour = "#FFFFFF"

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
	composite_material = list(MAT_TITANIUM = SHEET_MATERIAL_AMOUNT, "glass" = SHEET_MATERIAL_AMOUNT)

/datum/material/plastitanium
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
	supply_conversion_value = 8

/datum/material/plastitanium/hull
	name = MAT_PLASTITANIUMHULL
	stack_type = /obj/item/stack/material/plastitanium/hull
	icon_base = "hull"
	icon_reinf = "reinf_mesh"
	icon_colour = "#585658"
	explosion_resistance = 50

/datum/material/plastitanium/hull/place_sheet(var/turf/target) //Deconstructed into normal plasteel sheets.
	new /obj/item/stack/material/plastitanium(target)

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
	composite_material = list(MAT_PLASTITANIUM = SHEET_MATERIAL_AMOUNT, "glass" = SHEET_MATERIAL_AMOUNT)

/datum/material/gold/hull
	name = MAT_GOLDHULL
	stack_type = /obj/item/stack/material/gold/hull
	icon_base = "hull"
	icon_reinf = "reinf_mesh"
	explosion_resistance = 50

/datum/material/gold/hull/place_sheet(var/turf/target) //Deconstructed into normal plasteel sheets.
	new /obj/item/stack/material/gold(target)