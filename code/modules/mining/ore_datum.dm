/ore
	var/name
	var/display_name
	var/alloy
	var/smelts_to
	var/compresses_to
	var/result_amount     // How much ore?
	var/spread = 1	      // Does this type of deposit spread?
	var/spread_chance     // Chance of spreading in any direction
	var/ore	              // Path to the ore produced when tile is mined.
	var/scan_icon         // Overlay for ore scanners.
	// Xenoarch stuff. No idea what it's for, just refactored it to be less awful.
	var/list/xarch_ages = list(
		"thousand" = 999,
		"million" = 999
		)
	var/xarch_source_mineral = "iron"
	var/reagent = "silicate"

/ore/New()
	. = ..()
	if(!display_name)
		display_name = name

/ore/uranium
	name = "uranium"
	display_name = "pitchblende"
	smelts_to = "uranium"
	result_amount = 5
	spread_chance = 10
	ore = /obj/item/ore/uranium
	scan_icon = "mineral_uncommon"
	xarch_ages = list(
		"thousand" = 999,
		"million" = 704
		)
	xarch_source_mineral = "potassium"
	reagent = "uranium"

/ore/hematite
	name = "hematite"
	display_name = "hematite"
	smelts_to = "iron"
	alloy = 1
	result_amount = 5
	spread_chance = 25
	ore = /obj/item/ore/iron
	scan_icon = "mineral_common"
	reagent = "iron"

/ore/coal
	name = "carbon"
	display_name = "raw carbon"
	smelts_to = "plastic"
	compresses_to = "graphite"
	alloy = 1
	result_amount = 5
	spread_chance = 25
	ore = /obj/item/ore/coal
	scan_icon = "mineral_common"
	reagent = "carbon"

/ore/glass
	name = "sand"
	display_name = "sand"
	smelts_to = "glass"
	alloy = 1
	compresses_to = "sandstone"

/ore/phoron
	name = "phoron"
	display_name = "phoron crystals"
	compresses_to = "phoron"
	//smelts_to = something that explodes violently on the conveyor, huhuhuhu
	result_amount = 5
	spread_chance = 25
	ore = /obj/item/ore/phoron
	scan_icon = "mineral_uncommon"
	xarch_ages = list(
		"thousand" = 999,
		"million" = 999,
		"billion" = 13,
		"billion_lower" = 10
		)
	xarch_source_mineral = "phoron"
	reagent = "phoron"

/ore/silver
	name = "silver"
	display_name = "native silver"
	smelts_to = "silver"
	result_amount = 5
	spread_chance = 10
	ore = /obj/item/ore/silver
	scan_icon = "mineral_uncommon"
	reagent = "silver"

/ore/gold
	smelts_to = "gold"
	name = "gold"
	display_name = "native gold"
	result_amount = 5
	spread_chance = 10
	ore = /obj/item/ore/gold
	scan_icon = "mineral_uncommon"
	xarch_ages = list(
		"thousand" = 999,
		"million" = 999,
		"billion" = 4,
		"billion_lower" = 3
		)
	reagent = "gold"

/ore/diamond
	name = "diamond"
	display_name = "diamond"
	alloy = 1
	compresses_to = "diamond"
	result_amount = 5
	spread_chance = 10
	ore = /obj/item/ore/diamond
	scan_icon = "mineral_rare"
	xarch_source_mineral = "nitrogen"
	reagent = "carbon"

/ore/platinum
	name = "platinum"
	display_name = "raw platinum"
	smelts_to = "platinum"
	compresses_to = "osmium"
	alloy = 1
	result_amount = 5
	spread_chance = 10
	ore = /obj/item/ore/osmium
	scan_icon = "mineral_rare"
	reagent = "platinum"

/ore/hydrogen
	name = "mhydrogen"
	display_name = "metallic hydrogen"
	smelts_to = "tritium"
	compresses_to = "mhydrogen"
	scan_icon = "mineral_rare"
	reagent = "hydrogen"

/ore/verdantium
	name = MAT_VERDANTIUM
	display_name = "crystalline verdantite"
	compresses_to = MAT_VERDANTIUM
	result_amount = 2
	spread_chance = 5
	ore = /obj/item/ore/verdantium
	scan_icon = "mineral_rare"
	xarch_ages = list(
		"billion" = 13,
		"billion_lower" = 10
		)

/ore/marble
	name = MAT_MARBLE
	display_name = "recrystallized carbonate"
	compresses_to = "marble"
	result_amount = 1
	spread_chance = 10
	ore = /obj/item/ore/marble
	scan_icon = "mineral_common"
	reagent = "calciumcarbonate"

/ore/lead
	name = MAT_LEAD
	display_name = "lead glance"
	smelts_to = "lead"
	result_amount = 3
	spread_chance = 20
	ore = /obj/item/ore/lead
	scan_icon = "mineral_rare"
	reagent = "lead"
/*
/ore/copper
	name = "copper"
	display_name = "copper"
	smelts_to = "copper"
	alloy = 1
	result_amount = 5
	spread_chance = 15
	ore = /obj/item/ore/copper
	scan_icon = "mineral_common"
	reagent = "copper"

/ore/tin
	name = "tin"
	display_name = "tin"
	smelts_to = "tin"
	alloy = 1
	result_amount = 5
	spread_chance = 10
	ore = /obj/item/ore/tin
	scan_icon = "mineral_common"

/ore/quartz
	name = "quartz"
	display_name = "unrefined quartz"
	compresses_to = "quartz"
	result_amount = 5
	spread_chance = 5
	ore = /obj/item/ore/quartz
	scan_icon = "mineral_common"

/ore/bauxite
	name = "bauxite"
	display_name = "bauxite"
	smelts_to = "aluminium"
	result_amount = 5
	spread_chance = 25
	ore = /obj/item/ore/bauxite
	scan_icon = "mineral_common"
	reagent = "aluminum"
*/
/ore/rutile
	name = "rutile"
	display_name = "rutile"
	smelts_to = "titanium"
	result_amount = 5
	spread_chance = 12
	alloy = 1
	ore = /obj/item/ore/rutile
	scan_icon = "mineral_uncommon"
/*
/ore/painite
	name = "painite"
	display_name = "rough painite"
	compresses_to = "painite"
	result_amount = 5
	spread_chance = 3
	ore = /obj/item/ore/painite
	scan_icon = "mineral_rare"

/ore/void_opal
	name = "void opal"
	display_name = "rough void opal"
	compresses_to = "void opal"
	result_amount = 5
	spread_chance = 1
	ore = /obj/item/ore/void_opal
	scan_icon = "mineral_rare"
*/