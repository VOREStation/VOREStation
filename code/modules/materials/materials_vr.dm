/material/flesh
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

/material/fluff //This is to allow for 2 handed weapons that don't want to have a prefix.
	name = " "
	display_name = ""
	icon_colour = "#000000"
	sheet_singular_name = "fluff"
	sheet_plural_name = "fluffs"
	hardness = 60
	weight = 20 //Strong as iron.

/material/metaglass
	name = "metaglass"
	display_name = "metamorphic glass"
	flags = MATERIAL_BRITTLE
	shard_type = SHARD_SHARD
	stack_type = /obj/item/stack/material/metaglass
	icon_colour = "#b2e1ff"
	opacity = 0.3
	integrity = 50 // specialised glass, inferior for construction.
	hardness = 25
	weight = 15
	protectiveness = 0 // 0%
	conductive = 0
	conductivity = 1 // Glass shards don't conduct.
