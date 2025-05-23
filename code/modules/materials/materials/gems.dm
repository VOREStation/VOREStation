/datum/material/phoron
	name = MAT_PHORON
	stack_type = /obj/item/stack/material/phoron
	ignition_point = PHORON_MINIMUM_BURN_TEMPERATURE
	icon_base = "stone"
	table_icon_base = "stone"
	icon_colour = "#FC2BC5"
	shard_type = SHARD_SHARD
	hardness = 30
	stack_origin_tech = list(TECH_MATERIAL = 2, TECH_PHORON = 2)
	door_icon_base = "stone"
	sheet_singular_name = "crystal"
	sheet_plural_name = "crystals"
	supply_conversion_value = 5

/*
// Commenting this out while fires are so spectacularly lethal, as I can't seem to get this balanced appropriately.
/datum/material/phoron/combustion_effect(var/turf/T, var/temperature, var/effect_multiplier)
	if(isnull(ignition_point))
		return 0
	if(temperature < ignition_point)
		return 0
	var/totalPhoron = 0
	for(var/turf/simulated/floor/target_tile in range(2,T))
		var/phoronToDeduce = (temperature/30) * effect_multiplier
		totalPhoron += phoronToDeduce
		target_tile.assume_gas(GAS_PHORON, phoronToDeduce, 200+T0C)
		spawn (0)
			target_tile.hotspot_expose(temperature, 400)
	return round(totalPhoron/100)
*/

/datum/material/diamond
	name = MAT_DIAMOND
	stack_type = /obj/item/stack/material/diamond
	flags = MATERIAL_UNMELTABLE
	cut_delay = 60
	icon_colour = "#00FFE1"
	opacity = 0.4
	reflectivity = 0.6
	conductive = 0
	conductivity = 1
	shard_type = SHARD_SHARD
	tableslam_noise = 'sound/effects/Glasshit.ogg'
	hardness = 100
	stack_origin_tech = list(TECH_MATERIAL = 6)
	supply_conversion_value = 8
	icon_base = "stone"
	table_icon_base = "stone"

/datum/material/quartz
	name = MAT_QUARTZ
	display_name = MAT_QUARTZ
	use_name = MAT_QUARTZ
	icon_colour = "#e6d7df"
	stack_type = /obj/item/stack/material/quartz
	tableslam_noise = 'sound/effects/Glasshit.ogg'
	sheet_singular_name = "crystal"
	sheet_plural_name = "crystals"
	supply_conversion_value = 4
	icon_base = "stone"
	table_icon_base = "stone"

/datum/material/painite
	name = MAT_PAINITE
	display_name = MAT_PAINITE
	use_name = MAT_PAINITE
	icon_colour = "#6b4947"
	stack_type = /obj/item/stack/material/painite
	flags = MATERIAL_UNMELTABLE
	reflectivity = 0.3
	tableslam_noise = 'sound/effects/Glasshit.ogg'
	sheet_singular_name = "gem"
	sheet_plural_name = "gems"
	supply_conversion_value = 4
	icon_base = "stone"
	table_icon_base = "stone"

/datum/material/void_opal
	name = MAT_VOPAL
	display_name = MAT_VOPAL
	use_name = MAT_VOPAL
	icon_colour = "#0f0f0f"
	stack_type = /obj/item/stack/material/void_opal
	flags = MATERIAL_UNMELTABLE
	cut_delay = 60
	reflectivity = 0
	conductivity = 1
	shard_type = SHARD_SHARD
	tableslam_noise = 'sound/effects/Glasshit.ogg'
	hardness = 100
	stack_origin_tech = list(TECH_ARCANE = 1, TECH_MATERIAL = 6)
	sheet_singular_name = "gem"
	sheet_plural_name = "gems"
	supply_conversion_value = 30	// These are hilariously rare.
	icon_base = "stone"
	table_icon_base = "stone"

// Particle Smasher and other exotic materials.
/datum/material/valhollide
	name = MAT_VALHOLLIDE
	stack_type = /obj/item/stack/material/valhollide
	icon_base = "stone"
	door_icon_base = "stone"
	icon_reinf = "reinf_mesh"
	icon_colour = "#FFF3B2"
	protectiveness = 30
	integrity = 240
	weight = 30
	hardness = 45
	negation = 2
	conductive = 0
	conductivity = 5
	reflectivity = 0.5
	radiation_resistance = 20
	spatial_instability = 30
	stack_origin_tech = list(TECH_MATERIAL = 7, TECH_PHORON = 5, TECH_BLUESPACE = 5)
	sheet_singular_name = "gem"
	sheet_plural_name = "gems"
	icon_base = "stone"
	table_icon_base = "stone"

/datum/material/verdantium
	name = MAT_VERDANTIUM
	stack_type = /obj/item/stack/material/verdantium
	icon_base = "metal"
	door_icon_base = "metal"
	icon_reinf = "reinf_metal"
	icon_colour = "#4FE95A"
	integrity = 80
	protectiveness = 15
	weight = 15
	hardness = 30
	shard_type = SHARD_SHARD
	negation = 15
	conductivity = 60
	reflectivity = 0.3
	radiation_resistance = 5
	stack_origin_tech = list(TECH_MATERIAL = 6, TECH_POWER = 5, TECH_BIO = 4)
	sheet_singular_name = "sheet"
	sheet_plural_name = "sheets"
	supply_conversion_value = 8
	icon_base = "stone"
	table_icon_base = "stone"

/datum/material/morphium
	name = MAT_MORPHIUM
	stack_type = /obj/item/stack/material/morphium
	icon_base = "metal"
	door_icon_base = "metal"
	icon_colour = "#37115A"
	icon_reinf = "reinf_metal"
	protectiveness = 60
	integrity = 300
	conductive = 0
	conductivity = 1.5
	hardness = 90
	shard_type = SHARD_SHARD
	weight = 30
	negation = 25
	explosion_resistance = 85
	reflectivity = 0.2
	radiation_resistance = 10
	stack_origin_tech = list(TECH_MATERIAL = 8, TECH_PHORON = 4, TECH_BLUESPACE = 4)
	supply_conversion_value = 13
	icon_base = "stone"
	table_icon_base = "stone"

/datum/material/glamour
	name = MAT_GLAMOUR
	stack_type = /obj/item/stack/material/glamour
	icon_base = "stone"
	door_icon_base = "stone"
	icon_colour = "#fffee7"
	icon_reinf = "reinf_mesh"
	protectiveness = 70
	integrity = 300
	conductive = 1
	conductivity = 20
	hardness = 120
	shard_type = SHARD_SHARD
	weight = 20
	negation = 35
	explosion_resistance = 20
	reflectivity = 1
	radiation_resistance = 100
	stack_origin_tech = list(TECH_MATERIAL = 4, TECH_BLUESPACE = 8)
	supply_conversion_value = 15
	icon_base = "stone"
	table_icon_base = "stone"

/datum/material/glamour/generate_recipes()
	..()
	recipes += list(
		new /datum/stack_recipe("oar", /obj/item/oar, 2, time = 30, supplied_material = "[name]", pass_stack_color = TRUE),
		new /datum/stack_recipe("boat", /obj/vehicle/boat, 20, time = 10 SECONDS, supplied_material = "[name]", pass_stack_color = TRUE),
		new /datum/stack_recipe("dragon boat", /obj/vehicle/boat/dragon, 50, time = 30 SECONDS, supplied_material = "[name]", pass_stack_color = TRUE),
		new /datum/stack_recipe("glamour sandals", /obj/item/clothing/shoes/sandal, 1, pass_stack_color = TRUE, recycle_material = "[name]"),
		new /datum/stack_recipe("glamour circlet", /obj/item/clothing/head/woodcirclet, 1, pass_stack_color = TRUE, recycle_material = "[name]"),
		new /datum/stack_recipe("book shelf", /obj/structure/bookcase, 5, time = 15, one_per_turf = 1, on_floor = 1, pass_stack_color = TRUE, recycle_material = "[name]"),
		new /datum/stack_recipe("glamour shelves", /obj/structure/table/rack/shelf/wood, 1, one_per_turf = TRUE, time = 5, on_floor = TRUE, recycle_material = "[name]"),
		new /datum/stack_recipe("glamour standup figure", /obj/structure/barricade/cutout, 5, time = 10 SECONDS, pass_stack_color = TRUE, recycle_material = "[name]"),
		new /datum/stack_recipe("glamour bandage", /obj/item/stack/medical/crude_pack, 1, time = 2 SECONDS, pass_stack_color = TRUE, recycle_material = "[name]"),
		new /datum/stack_recipe("bedsheet", /obj/item/bedsheet, 10, time = 30 SECONDS, pass_stack_color = TRUE, recycle_material = "[name]"),
		new /datum/stack_recipe("uniform", /obj/item/clothing/under/color/white, 8, time = 15 SECONDS, pass_stack_color = TRUE, recycle_material = "[name]"),
		new /datum/stack_recipe("foot wraps", /obj/item/clothing/shoes/footwraps, 2, time = 5 SECONDS, pass_stack_color = TRUE, recycle_material = "[name]"),
		new /datum/stack_recipe("gloves", /obj/item/clothing/gloves/white, 2, time = 5 SECONDS, pass_stack_color = TRUE, recycle_material = "[name]"),
		new /datum/stack_recipe("wig", /obj/item/clothing/head/powdered_wig, 4, time = 10 SECONDS, pass_stack_color = TRUE, recycle_material = "[name]"),
		new /datum/stack_recipe("philosopher's wig", /obj/item/clothing/head/philosopher_wig, 50, time = 2 MINUTES, pass_stack_color = TRUE, recycle_material = "[name]"),
		new /datum/stack_recipe("taqiyah", /obj/item/clothing/head/taqiyah, 3, time = 6 SECONDS, pass_stack_color = TRUE, recycle_material = "[name]"),
		new /datum/stack_recipe("turban", /obj/item/clothing/head/turban, 3, time = 6 SECONDS, pass_stack_color = TRUE, recycle_material = "[name]"),
		new /datum/stack_recipe("hijab", /obj/item/clothing/head/hijab, 3, time = 6 SECONDS, pass_stack_color = TRUE, recycle_material = "[name]"),
		new /datum/stack_recipe("kippa", /obj/item/clothing/head/kippa, 3, time = 6 SECONDS, pass_stack_color = TRUE, recycle_material = "[name]"),
		new /datum/stack_recipe("scarf", /obj/item/clothing/accessory/scarf/white, 4, time = 5 SECONDS, pass_stack_color = TRUE, recycle_material = "[name]"),
		new /datum/stack_recipe("baggy pants", /obj/item/clothing/under/pants/baggy/white, 8, time = 10 SECONDS, pass_stack_color = TRUE, recycle_material = "[name]"),
		new /datum/stack_recipe("belt pouch", /obj/item/storage/belt/fannypack/white, 25, time = 1 MINUTE, pass_stack_color = TRUE, recycle_material = "[name]"),
		new /datum/stack_recipe("glamour net", /obj/item/material/fishing_net, 10, time = 5 SECONDS, supplied_material = "[name]", pass_stack_color = TRUE),
		new /datum/stack_recipe("glamour ring", /obj/item/clothing/accessory/ring/material, 1, on_floor = 1, supplied_material = "[name]", pass_stack_color = TRUE),
		new /datum/stack_recipe("glamour bracelet", /obj/item/clothing/accessory/bracelet/material, 1, on_floor = 1, supplied_material = "[name]", pass_stack_color = TRUE),
		new /datum/stack_recipe("glamour armor plate", /obj/item/material/armor_plating, 1, time = 20, on_floor = 1, supplied_material = "[name]", pass_stack_color = TRUE),
		new /datum/stack_recipe("whip", /obj/item/material/whip, 5, time = 15 SECONDS, pass_stack_color = TRUE, supplied_material = "[name]"),
		new /datum/stack_recipe("Transparent Glamour", /obj/item/potion_material/glamour_transparent, 25, time = 15 SECONDS, pass_stack_color = FALSE, supplied_material = "[name]"),
		new /datum/stack_recipe("Shrinking Glamour", /obj/item/potion_material/glamour_shrinking, 10, time = 15 SECONDS, pass_stack_color = FALSE, supplied_material = "[name]"),
		new /datum/stack_recipe("Twinkling Glamour", /obj/item/potion_material/glamour_twinkling, 15, time = 15 SECONDS, pass_stack_color = FALSE, supplied_material = "[name]"),
		new /datum/stack_recipe("Glamour Shard", /obj/item/potion_material/glamour_shard, 15, time = 20 SECONDS, pass_stack_color = FALSE, supplied_material = "[name]"),
		new /datum/stack_recipe("Glamour Cell", /obj/item/capture_crystal/glamour, 50, time = 15 SECONDS, pass_stack_color = FALSE, supplied_material = "[name]"),
		new /datum/stack_recipe("Speaking Glamour", /obj/item/universal_translator/glamour, 50, time = 15 SECONDS, pass_stack_color = FALSE, supplied_material = "[name]"),
		new /datum/stack_recipe("Glamour Bubble", /obj/item/clothing/mask/gas/glamour, 20, time = 15 SECONDS, pass_stack_color = FALSE, supplied_material = "[name]"),
		new /datum/stack_recipe("Pocket of Glamour", /obj/item/clothing/under/permit/glamour, 5, time = 15 SECONDS, pass_stack_color = FALSE, supplied_material = "[name]"),
		new /datum/stack_recipe("glamour bow", /obj/item/gun/launcher/crossbow/bow/glamour, 15, time = 15 SECONDS, pass_stack_color = FALSE, supplied_material = "[name]"),
		new /datum/stack_recipe("glamour arrow", /obj/item/arrow/standard/glamour, 1, time = 15 SECONDS, pass_stack_color = FALSE, supplied_material = "[name]")
	)
