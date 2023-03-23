/datum/material/stone
	name = "sandstone"
	stack_type = /obj/item/stack/material/sandstone
	icon_base = "stone"
	icon_reinf = "reinf_stone"
	icon_colour = "#D9C179"
	shard_type = SHARD_STONE_PIECE
	weight = 22
	hardness = 55
	protectiveness = 5 // 20%
	conductive = 0
	conductivity = 5
	door_icon_base = "stone"
	sheet_singular_name = "brick"
	sheet_plural_name = "bricks"

/datum/material/stone/generate_recipes()
	..()
	recipes += new /datum/stack_recipe("planting bed", /obj/machinery/portable_atmospherics/hydroponics/soil, 3, time = 10, one_per_turf = 1, on_floor = 1, recycle_material = "[name]")

/datum/material/stone/marble
	name = "marble"
	icon_colour = "#AAAAAA"
	weight = 26
	hardness = 30 //VOREStation Edit - Please.
	integrity = 201 //hack to stop kitchen benches being flippable, todo: refactor into weight system
	stack_type = /obj/item/stack/material/marble
	supply_conversion_value = 2

/datum/material/stone/marble/generate_recipes()
	..()
	recipes += list(
		new /datum/stack_recipe("light marble floor tile", /obj/item/stack/tile/wmarble, 1, 4, 20, recycle_material = "[name]"),
		new /datum/stack_recipe("dark marble floor tile", /obj/item/stack/tile/bmarble, 1, 4, 20, recycle_material = "[name]")
	)
//VOREStation Addition Start
/datum/material/stone/flint
	name = "flint"
	icon_colour = "#9e9c99"
	weight = 20
	hardness = 30
	integrity = 100
	stack_type = /obj/item/stack/material/flint
	supply_conversion_value = 2
	sheet_singular_name = "piece"
	sheet_plural_name = "pieces"

/datum/material/stone/flint/generate_recipes()
	return
//VOREStation Addition End

/datum/material/stone/concrete
	name = MAT_CONCRETE
	stack_type = /obj/item/stack/material/concrete
	icon_base = "brick"
	icon_colour = COLOR_GRAY
	integrity = 150
	melting_point = 1550
	protectiveness = 10
	weight = 27
	hardness = 60
	var/image/texture

/datum/material/stone/concrete/generate_recipes()
	..()
	recipes += list(
		new /datum/stack_recipe_list("Concrete Pathing",list(
			new /datum/stack_recipe("Concrete Flooring", /obj/item/stack/tile/floor/concrete, 1, 4, 20, recycle_material = "[name]"),
			new /datum/stack_recipe("Concrete Sidewalk", /obj/item/stack/tile/floor/sidewalk, 1, 4, 20, recycle_material = "[name]"),
			new /datum/stack_recipe("Concrete Sidewalk (Side)", /obj/item/stack/tile/floor/sidewalk/side, 1, 4, 20, recycle_material = "[name]"),
			new /datum/stack_recipe("Concrete Sidewalk (Slab)", /obj/item/stack/tile/floor/sidewalk/slab, 1, 4, 20, recycle_material = "[name]")
		)),
		)

/datum/material/stone/concrete/New()
	. = ..()
	texture = image('icons/turf/wall_texture.dmi', "concrete")
	texture.blend_mode = BLEND_MULTIPLY

/datum/material/stone/concrete/get_wall_texture()
	return texture
