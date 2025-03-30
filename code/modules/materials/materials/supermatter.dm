//R-UST port
/datum/material/supermatter
	name = MAT_SUPERMATTER
	icon_colour = "#FFFF00"
	stack_type = /obj/item/stack/material/supermatter
	shard_type = SHARD_SHARD
	radioactivity = 20
	luminescence = 3
	ignition_point = PHORON_MINIMUM_BURN_TEMPERATURE
	icon_base = "stone"
	shard_type = SHARD_SHARD
	hardness = 30
	door_icon_base = "stone"
	sheet_singular_name = "crystal"
	sheet_plural_name = "crystals"
	is_fusion_fuel = 1
	stack_origin_tech = list(TECH_MATERIAL = 8, TECH_PHORON = 5, TECH_BLUESPACE = 4)
	flags = MATERIAL_UNMELTABLE

/datum/material/supermatter/generate_recipes()
	recipes = list(
		new /datum/stack_recipe("supermatter shard", /obj/machinery/power/supermatter/shard, 30 , one_per_turf = 1, time = 600, on_floor = 1, recycle_material = "[name]")
	)
