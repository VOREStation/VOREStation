



// Very rare alloy that is reflective, should be used sparingly.
/datum/material/durasteel
	name = "durasteel"
	stack_type = /obj/item/stack/material/durasteel
	integrity = 600
	melting_point = 7000
	icon_base = "metal"
	icon_reinf = "reinf_metal"
	icon_colour = "#6EA7BE"
	explosion_resistance = 75
	hardness = 100
	weight = 28
	protectiveness = 60 // 75%
	reflectivity = 0.7 // Not a perfect mirror, but close.
	stack_origin_tech = list(TECH_MATERIAL = 8)
	supply_conversion_value = 9

/datum/material/durasteel/generate_recipes()
	..()
	recipes += list(
		new /datum/stack_recipe("durasteel hull sheet", /obj/item/stack/material/durasteel/hull, 2, 1, 5, time = 20, one_per_turf = 0, on_floor = 1, recycle_material = "[name]")
	)

/datum/material/titanium
	name = MAT_TITANIUM
	stack_type = /obj/item/stack/material/titanium
	conductivity = 2.38
	icon_base = "metal"
	door_icon_base = "metal"
	icon_colour = "#D1E6E3"
	icon_reinf = "reinf_metal"

/datum/material/titanium/generate_recipes()
	..()
	recipes += list(
		new /datum/stack_recipe("titanium hull sheet", /obj/item/stack/material/titanium/hull, 2, 1, 5, time = 20, one_per_turf = 0, on_floor = 1, recycle_material = "[name]")
	)

/datum/material/iron
	name = "iron"
	stack_type = /obj/item/stack/material/iron
	icon_colour = "#5C5454"
	weight = 22
	conductivity = 10
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"

/datum/material/lead
	name = MAT_LEAD
	stack_type = /obj/item/stack/material/lead
	icon_colour = "#273956"
	weight = 23 // Lead is a bit more dense than silver IRL, and silver has 22 ingame.
	conductivity = 10
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	radiation_resistance = 25 // Lead is Special and so gets to block more radiation than it normally would with just weight, totalling in 48 protection.
	supply_conversion_value = 2

/datum/material/gold
	name = "gold"
	stack_type = /obj/item/stack/material/gold
	icon_colour = "#EDD12F"
	weight = 24
	hardness = 40
	conductivity = 41
	stack_origin_tech = list(TECH_MATERIAL = 4)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	supply_conversion_value = 2

/datum/material/silver
	name = "silver"
	stack_type = /obj/item/stack/material/silver
	icon_colour = "#D1E6E3"
	weight = 22
	hardness = 50
	conductivity = 63
	stack_origin_tech = list(TECH_MATERIAL = 3)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	supply_conversion_value = 2

/datum/material/platinum
	name = "platinum"
	stack_type = /obj/item/stack/material/platinum
	icon_colour = "#9999FF"
	weight = 27
	conductivity = 9.43
	stack_origin_tech = list(TECH_MATERIAL = 2)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	supply_conversion_value = 5

/datum/material/uranium
	name = "uranium"
	stack_type = /obj/item/stack/material/uranium
	radioactivity = 12
	icon_base = "stone"
	icon_reinf = "reinf_stone"
	icon_colour = "#007A00"
	weight = 22
	stack_origin_tech = list(TECH_MATERIAL = 5)
	door_icon_base = "stone"
	supply_conversion_value = 2

/datum/material/mhydrogen
	name = "mhydrogen"
	stack_type = /obj/item/stack/material/mhydrogen
	icon_colour = "#E6C5DE"
	stack_origin_tech = list(TECH_MATERIAL = 6, TECH_POWER = 6, TECH_MAGNET = 5)
	conductivity = 100
	is_fusion_fuel = 1
	supply_conversion_value = 6

/datum/material/deuterium
	name = "deuterium"
	stack_type = /obj/item/stack/material/deuterium
	icon_colour = "#999999"
	stack_origin_tech = list(TECH_MATERIAL = 3)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	is_fusion_fuel = 1
	conductive = 0

/datum/material/tritium
	name = "tritium"
	stack_type = /obj/item/stack/material/tritium
	icon_colour = "#777777"
	stack_origin_tech = list(TECH_MATERIAL = 5)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	is_fusion_fuel = 1
	conductive = 0

/datum/material/osmium
	name = "osmium"
	stack_type = /obj/item/stack/material/osmium
	icon_colour = "#9999FF"
	stack_origin_tech = list(TECH_MATERIAL = 5)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	conductivity = 100
	supply_conversion_value = 6

/datum/material/graphite
	name = MAT_GRAPHITE
	stack_type = /obj/item/stack/material/graphite
	flags = MATERIAL_BRITTLE
	icon_base = "solid"
	icon_reinf = "reinf_mesh"
	icon_colour = "#333333"
	hardness = 75
	weight = 15
	integrity = 175
	protectiveness = 15
	conductivity = 18
	melting_point = T0C+3600
	radiation_resistance = 15
	stack_origin_tech = list(TECH_MATERIAL = 2, TECH_MAGNET = 2)

/datum/material/bronze
	name = "bronze"
	stack_type = /obj/item/stack/material/bronze
	icon_colour = "#EDD12F"
	icon_base = "solid"
	icon_reinf = "reinf_over"
	integrity = 120
	conductivity = 12
	protectiveness = 9 // 33%

/datum/material/tin
	name = "tin"
	display_name = "tin"
	use_name = "tin"
	stack_type = /obj/item/stack/material/tin
	icon_colour = "#b2afaf"
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	supply_conversion_value = 1
	hardness = 50
	weight = 13

/datum/material/copper
	name = "copper"
	display_name = "copper"
	use_name = "copper"
	stack_type = /obj/item/stack/material/copper
	conductivity = 52
	icon_colour = "#af633e"
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	supply_conversion_value = 1
	weight = 13
	hardness = 50

/datum/material/aluminium
	name = "aluminium"
	display_name = "aluminium"
	use_name = "aluminium"
	icon_colour = "#e5e2d0"
	stack_type = /obj/item/stack/material/aluminium
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	supply_conversion_value = 2
	weight = 10