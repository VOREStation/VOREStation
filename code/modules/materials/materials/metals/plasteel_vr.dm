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

/datum/material/plastitanium/generate_recipes()
	..()
	recipes += list(
		new /datum/stack_recipe("whetstone", /obj/item/weapon/whetstone, 2, time = 20),
	)
