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
	display_name = "quartz"
	use_name = "quartz"
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
	display_name = "painite"
	use_name = "painite"
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
	display_name = "void opal"
	use_name = "void opal"
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
	icon_colour = "##FFF3B2"
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
