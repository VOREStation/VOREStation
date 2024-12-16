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
	var/xarch_source_mineral = REAGENT_ID_IRON
	var/reagent = REAGENT_SILICATE

/ore/New()
	. = ..()
	if(!display_name)
		display_name = name

/ore/uranium
	name = ORE_URANIUM
	display_name = "pitchblende"
	smelts_to = MAT_URANIUM
	result_amount = 5
	spread_chance = 10
	ore = /obj/item/ore/uranium
	scan_icon = "mineral_uncommon"
	xarch_ages = list(
		"thousand" = 999,
		"million" = 704
		)
	xarch_source_mineral = REAGENT_ID_POTASSIUM
	reagent = REAGENT_ID_URANIUM

/ore/hematite
	name = ORE_HEMATITE
	display_name = ORE_HEMATITE
	smelts_to = MAT_IRON
	alloy = 1
	result_amount = 5
	spread_chance = 25
	ore = /obj/item/ore/iron
	scan_icon = "mineral_common"
	reagent = REAGENT_ID_IRON

/ore/coal
	name = ORE_CARBON
	display_name = "raw carbon"
	smelts_to = MAT_PLASTIC
	compresses_to = MAT_GRAPHITE
	alloy = 1
	result_amount = 5
	spread_chance = 25
	ore = /obj/item/ore/coal
	scan_icon = "mineral_common"
	reagent = REAGENT_ID_CARBON

/ore/glass
	name = ORE_SAND
	display_name = ORE_SAND
	smelts_to = MAT_GLASS
	alloy = 1
	compresses_to = MAT_SANDSTONE

/ore/phoron
	name = ORE_PHORON
	display_name = "phoron crystals"
	compresses_to = MAT_PHORON
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
	xarch_source_mineral = REAGENT_ID_PHORON
	reagent = REAGENT_ID_PHORON

/ore/silver
	name = ORE_SILVER
	display_name = "native silver"
	smelts_to = MAT_SILVER
	result_amount = 5
	spread_chance = 10
	ore = /obj/item/ore/silver
	scan_icon = "mineral_uncommon"
	reagent = REAGENT_ID_SILVER

/ore/gold
	name = ORE_GOLD
	smelts_to = MAT_GOLD
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
	reagent = REAGENT_ID_GOLD

/ore/diamond
	name = ORE_DIAMOND
	display_name = ORE_DIAMOND
	alloy = 1
	compresses_to = MAT_DIAMOND
	result_amount = 5
	spread_chance = 10
	ore = /obj/item/ore/diamond
	scan_icon = "mineral_rare"
	xarch_source_mineral = REAGENT_ID_NITROGEN
	reagent = REAGENT_ID_CARBON

/ore/platinum
	name = ORE_PLATINUM
	display_name = "raw platinum"
	smelts_to = MAT_PLATINUM
	compresses_to = MAT_OSMIUM
	alloy = 1
	result_amount = 5
	spread_chance = 10
	ore = /obj/item/ore/osmium
	scan_icon = "mineral_rare"
	reagent = REAGENT_ID_PLATINUM

/ore/hydrogen
	name = ORE_MHYDROGEN
	display_name = "metallic hydrogen"
	smelts_to = MAT_TRITIUM
	compresses_to = MAT_METALHYDROGEN
	scan_icon = "mineral_rare"
	reagent = REAGENT_ID_HYDROGEN

/ore/verdantium
	name = ORE_VERDANTIUM
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
	name = ORE_MARBLE
	display_name = "recrystallized carbonate"
	compresses_to = MAT_MARBLE
	result_amount = 1
	spread_chance = 10
	ore = /obj/item/ore/marble
	scan_icon = "mineral_common"
	reagent = REAGENT_ID_CALCIUMCARBONATE

/ore/lead
	name = ORE_LEAD
	display_name = "lead glance"
	smelts_to = MAT_LEAD
	result_amount = 3
	spread_chance = 20
	ore = /obj/item/ore/lead
	scan_icon = "mineral_rare"
	reagent = REAGENT_ID_LEAD
/*
/ore/copper
	name = ORE_COPPER
	display_name = ORE_COPPER
	smelts_to = MAT_COPPER
	alloy = 1
	result_amount = 5
	spread_chance = 15
	ore = /obj/item/ore/copper
	scan_icon = "mineral_common"
	reagent = REAGENT_ID_COPPER

/ore/tin
	name = ORE_TIN
	display_name = ORE_TIN
	smelts_to = MAT_TIN
	alloy = 1
	result_amount = 5
	spread_chance = 10
	ore = /obj/item/ore/tin
	scan_icon = "mineral_common"

/ore/quartz
	name = ORE_QUARTZ
	display_name = "unrefined quartz"
	compresses_to = MAT_QUARTZ
	result_amount = 5
	spread_chance = 5
	ore = /obj/item/ore/quartz
	scan_icon = "mineral_common"

/ore/bauxite
	name = ORE_BAUXITE
	display_name = ORE_BAUXITE
	smelts_to = MAT_ALUMINIUM
	result_amount = 5
	spread_chance = 25
	ore = /obj/item/ore/bauxite
	scan_icon = "mineral_common"
	reagent = REAGENT_ID_ALUMINIUM
*/
/ore/rutile
	name = ORE_RUTILE
	display_name = ORE_RUTILE
	smelts_to = MAT_TITANIUM
	result_amount = 5
	spread_chance = 12
	alloy = 1
	ore = /obj/item/ore/rutile
	scan_icon = "mineral_uncommon"
/*
/ore/painite
	name = ORE_PAINITE
	display_name = "rough painite"
	compresses_to = MAT_PAINITE
	result_amount = 5
	spread_chance = 3
	ore = /obj/item/ore/painite
	scan_icon = "mineral_rare"

/ore/void_opal
	name = ORE_VOPAL
	display_name = "rough void opal"
	compresses_to = MAT_VOPAL
	result_amount = 5
	spread_chance = 1
	ore = /obj/item/ore/void_opal
	scan_icon = "mineral_rare"
*/
