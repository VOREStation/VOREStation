/datum/material/snow
	name = MAT_SNOW
	stack_type = /obj/item/stack/material/snow
	flags = MATERIAL_BRITTLE
	icon_base = "solid"
	icon_reinf = "reinf_over"
	icon_colour = "#FFFFFF"
	integrity = 1
	hardness = 1
	weight = 1
	protectiveness = 0 // 0%
	stack_origin_tech = list(TECH_MATERIAL = 1)
	melting_point = T0C+1
	destruction_desc = "crumples"
	sheet_singular_name = "pile"
	sheet_plural_name = "pile" //Just a bigger pile
	radiation_resistance = 1

/datum/material/snow/generate_recipes()
	recipes = list(
		new /datum/stack_recipe("snowball", /obj/item/material/snow/snowball, 1, time = 10, recycle_material = "[name]"),
		new /datum/stack_recipe("snow brick", /obj/item/stack/material/snowbrick, 2, time = 10, recycle_material = "[name]"),
		new /datum/stack_recipe("snowman", /obj/structure/snowman, 2, time = 15, recycle_material = "[name]"),
		new /datum/stack_recipe("snow robot", /obj/structure/snowman/borg, 2, time = 10, recycle_material = "[name]"),
		new /datum/stack_recipe("snow spider", /obj/structure/snowman/spider, 3, time = 20, recycle_material = "[name]")
	)

/datum/material/snowbrick //only slightly stronger than snow, used to make igloos mostly
	name = "packed snow"
	flags = MATERIAL_BRITTLE
	stack_type = /obj/item/stack/material/snowbrick
	icon_base = "stone"
	icon_reinf = "reinf_stone"
	icon_colour = "#D8FDFF"
	integrity = 50
	weight = 2
	hardness = 2
	protectiveness = 0 // 0%
	stack_origin_tech = list(TECH_MATERIAL = 1)
	melting_point = T0C+1
	destruction_desc = "crumbles"
	sheet_singular_name = "brick"
	sheet_plural_name = "bricks"
	radiation_resistance = 1

/datum/material/snowbrick/generate_recipes()
	recipes = list(
		new /datum/stack_recipe("[display_name] door", /obj/structure/simple_door, 10, one_per_turf = 1, on_floor = 1, supplied_material = "[name]"),
		new /datum/stack_recipe("[display_name] barricade", /obj/structure/barricade, 5, time = 50, one_per_turf = 1, on_floor = 1, supplied_material = "[name]"),
		new /datum/stack_recipe("[display_name] stool", /obj/item/stool, one_per_turf = 1, on_floor = 1, supplied_material = "[name]"),
		new /datum/stack_recipe("[display_name] chair", /obj/structure/bed/chair, one_per_turf = 1, on_floor = 1, supplied_material = "[name]"),
		new /datum/stack_recipe("[display_name] bed", /obj/structure/bed, 2, one_per_turf = 1, on_floor = 1, supplied_material = "[name]"),
		new /datum/stack_recipe("[display_name] double bed", /obj/structure/bed/double, 4, one_per_turf = 1, on_floor = 1, supplied_material = "[name]"),
		new /datum/stack_recipe("[display_name] wall girders", /obj/structure/girder, 2, time = 50, one_per_turf = 1, on_floor = 1, supplied_material = "[name]"),
		new /datum/stack_recipe("[display_name] ashtray", /obj/item/material/ashtray, 2, one_per_turf = 1, on_floor = 1, supplied_material = "[name]")
	)