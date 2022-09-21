/datum/material/plasteel
	name = MAT_PLASTEEL
	stack_type = /obj/item/stack/material/plasteel
	integrity = 400
	melting_point = 6000
	icon_base = "solid"
	icon_reinf = "reinf_over"
	icon_colour = "#777777"
	explosion_resistance = 25
	hardness = 80
	weight = 23
	protectiveness = 20 // 50%
	conductivity = 13 // For the purposes of balance.
	stack_origin_tech = list(TECH_MATERIAL = 2)
	composite_material = list(MAT_STEEL = SHEET_MATERIAL_AMOUNT, "platinum" = SHEET_MATERIAL_AMOUNT) //todo
	supply_conversion_value = 6

/datum/material/plasteel/generate_recipes()
	..()
	recipes += list(
		new /datum/stack_recipe("AI core", /obj/structure/AIcore, 4, time = 50, one_per_turf = 1, recycle_material = "[name]"),
		new /datum/stack_recipe("Metal crate", /obj/structure/closet/crate, 10, time = 50, one_per_turf = 1, recycle_material = "[name]"),
		new /datum/stack_recipe("knife grip", /obj/item/weapon/material/butterflyhandle, 4, time = 20, one_per_turf = 0, on_floor = 1, supplied_material = "[name]"),
		new /datum/stack_recipe("dark floor tile", /obj/item/stack/tile/floor/dark, 1, 4, 20, recycle_material = "[name]"),
		new /datum/stack_recipe("roller bed", /obj/item/roller, 5, time = 30, on_floor = 1, recycle_material = "[name]"),
		new /datum/stack_recipe("whetstone", /obj/item/weapon/whetstone, 2, time = 10, recycle_material = "[name]"),
		new /datum/stack_recipe("plasteel rebar", /obj/item/stack/material/plasteel/rebar, 1, time = 5, recycle_material = "[name]"),
		new /datum/stack_recipe_list("reinforced low walls",list(
			new /datum/stack_recipe("reinforced low wall (bay style)", /obj/structure/low_wall/bay/reinforced, 3, one_per_turf = 1, on_floor = 1, supplied_material = "[name]", recycle_material = "[name]"),
			new /datum/stack_recipe("reinforced low wall (eris style)", /obj/structure/low_wall/eris/reinforced, 3, one_per_turf = 1, on_floor = 1, supplied_material = "[name]", recycle_material = "[name]")
		)),
	)

/datum/material/plasteel/rebar //to give a different reinforced overlay
	name = MAT_PLASTEELREBAR
	icon_reinf = "reinf_metal"
	icon_colour = "#6A6A6A"
	stack_type = /obj/item/stack/material/plasteel/rebar
	sheet_singular_name = "rod"
	sheet_plural_name = "rods"
