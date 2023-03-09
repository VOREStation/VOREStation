/datum/material/grass
	name = MAT_GRASS
	display_name = "grass"
	stack_type = /obj/item/stack/tile/grass
	ignition_point = T0C+300
	melting_point = T0C+300
	protectiveness = 0
	conductive = 0
	integrity = 10
	supply_conversion_value = 1

/datum/material/grass/generate_recipes()
	recipes = list(
		new /datum/stack_recipe_list("bushes and flowers",list(
			new /datum/stack_recipe("bush", /obj/structure/flora/ausbushes, 3, one_per_turf = 0, on_floor = 1, recycle_material = "[name]"),
			new /datum/stack_recipe("reed bush", /obj/structure/flora/ausbushes/reedbush, 3, one_per_turf = 0, on_floor = 1, recycle_material = "[name]"),
			new /datum/stack_recipe("leafy bush", /obj/structure/flora/ausbushes/leafybush, 3, one_per_turf = 0, on_floor = 1, recycle_material = "[name]"),
			new /datum/stack_recipe("pale bush", /obj/structure/flora/ausbushes/palebush, 3, one_per_turf = 0, on_floor = 1, recycle_material = "[name]"),
			new /datum/stack_recipe("stalky bush", /obj/structure/flora/ausbushes/stalkybush, 3, one_per_turf = 0, on_floor = 1, recycle_material = "[name]"),
			new /datum/stack_recipe("grassy bush", /obj/structure/flora/ausbushes/grassybush, 3, one_per_turf = 0, on_floor = 1, recycle_material = "[name]"),
			new /datum/stack_recipe("ferny bush", /obj/structure/flora/ausbushes/fernybush, 3, one_per_turf = 0, on_floor = 1, recycle_material = "[name]"),
			new /datum/stack_recipe("sunny bush", /obj/structure/flora/ausbushes/sunnybush, 3, one_per_turf = 0, on_floor = 1, recycle_material = "[name]"),
			new /datum/stack_recipe("pointy bush", /obj/structure/flora/ausbushes/pointybush, 3, one_per_turf = 0, on_floor = 1, recycle_material = "[name]"),
			new /datum/stack_recipe("lavender grass", /obj/structure/flora/ausbushes/lavendergrass, 3, one_per_turf = 0, on_floor = 1, recycle_material = "[name]"),
			new /datum/stack_recipe("yellow-and-white flowers", /obj/structure/flora/ausbushes/ywflowers, 3, one_per_turf = 0, on_floor = 1, recycle_material = "[name]"),
			new /datum/stack_recipe("blue-and-red flowers", /obj/structure/flora/ausbushes/brflowers, 3, one_per_turf = 0, on_floor = 1, recycle_material = "[name]"),
			new /datum/stack_recipe("pink-and-purple flowers", /obj/structure/flora/ausbushes/ppflowers, 3, one_per_turf = 0, on_floor = 1, recycle_material = "[name]"),
			new /datum/stack_recipe("sparse grass", /obj/structure/flora/ausbushes/sparsegrass, 3, one_per_turf = 0, on_floor = 1, recycle_material = "[name]"),
			new /datum/stack_recipe("full grass", /obj/structure/flora/ausbushes/fullgrass, 3, one_per_turf = 0, on_floor = 1, recycle_material = "[name]")
			))
	)