// Don't need a new list for every grinder in the game
var/global/list/sheet_reagents = list( //have a number of reagents divisible by REAGENTS_PER_SHEET (default 20) unless you like decimals.
	/obj/item/stack/material/plastic = list(REAGENT_ID_CARBON,REAGENT_ID_CARBON,REAGENT_ID_OXYGEN,REAGENT_ID_CHLORINE,REAGENT_ID_SULFUR),
	/obj/item/stack/material/copper = list(REAGENT_ID_COPPER),
	/obj/item/stack/material/wood = list(REAGENT_ID_CARBON,REAGENT_ID_WOODPULP,REAGENT_ID_NITROGEN,REAGENT_ID_POTASSIUM,REAGENT_ID_SODIUM),
	/obj/item/stack/material/stick = list(REAGENT_ID_CARBON,REAGENT_ID_WOODPULP,REAGENT_ID_NITROGEN,REAGENT_ID_POTASSIUM,REAGENT_ID_SODIUM),
	/obj/item/stack/material/log = list(REAGENT_ID_CARBON,REAGENT_ID_WOODPULP,REAGENT_ID_NITROGEN,REAGENT_ID_POTASSIUM,REAGENT_ID_SODIUM),
	/obj/item/stack/material/algae = list(REAGENT_ID_CARBON,REAGENT_ID_NITROGEN,REAGENT_ID_NITROGEN,REAGENT_ID_PHOSPHORUS,REAGENT_ID_PHOSPHORUS),
	/obj/item/stack/material/graphite = list(REAGENT_ID_CARBON),
	/obj/item/stack/material/aluminium = list(REAGENT_ID_ALUMINIUM), // The material is aluminium, but the reagent is aluminum...
	/obj/item/stack/material/glass/reinforced = list(REAGENT_ID_SILICON,REAGENT_ID_SILICON,REAGENT_ID_SILICON,REAGENT_ID_IRON,REAGENT_ID_CARBON),
	/obj/item/stack/material/leather = list(REAGENT_ID_CARBON,REAGENT_ID_CARBON,REAGENT_ID_PROTEIN,REAGENT_ID_PROTEIN,REAGENT_ID_TRIGLYCERIDE),
	/obj/item/stack/material/cloth = list(REAGENT_ID_CARBON,REAGENT_ID_CARBON,REAGENT_ID_CARBON,REAGENT_ID_PROTEIN,REAGENT_ID_SODIUM),
	/obj/item/stack/material/fiber = list(REAGENT_ID_CARBON,REAGENT_ID_CARBON,REAGENT_ID_CARBON,REAGENT_ID_PROTEIN,REAGENT_ID_SODIUM),
	/obj/item/stack/material/fur = list(REAGENT_ID_CARBON,REAGENT_ID_CARBON,REAGENT_ID_CARBON,REAGENT_ID_SULFUR,REAGENT_ID_SODIUM),
	/obj/item/stack/material/deuterium = list(REAGENT_ID_HYDROGEN),
	/obj/item/stack/material/glass/phoronrglass = list(REAGENT_ID_SILICON,REAGENT_ID_SILICON,REAGENT_ID_SILICON,REAGENT_ID_PHORON,REAGENT_ID_PHORON),
	/obj/item/stack/material/diamond = list(REAGENT_ID_CARBON),
	/obj/item/stack/material/durasteel = list(REAGENT_ID_IRON,REAGENT_ID_IRON,REAGENT_ID_CARBON,REAGENT_ID_CARBON,REAGENT_ID_PLATINUM),
	/obj/item/stack/material/wax = list(REAGENT_ID_ETHANOL,REAGENT_ID_TRIGLYCERIDE),
	/obj/item/stack/material/iron = list(REAGENT_ID_IRON),
	/obj/item/stack/material/uranium = list(REAGENT_ID_URANIUM),
	/obj/item/stack/material/phoron = list(REAGENT_ID_PHORON),
	/obj/item/stack/material/gold = list(REAGENT_ID_GOLD),
	/obj/item/stack/material/silver = list(REAGENT_ID_SILVER),
	/obj/item/stack/material/platinum = list(REAGENT_ID_PLATINUM),
	/obj/item/stack/material/mhydrogen = list(REAGENT_ID_HYDROGEN),
	/obj/item/stack/material/steel = list(REAGENT_ID_IRON, REAGENT_ID_CARBON),
	/obj/item/stack/material/plasteel = list(REAGENT_ID_IRON, REAGENT_ID_IRON, REAGENT_ID_CARBON, REAGENT_ID_CARBON, REAGENT_ID_PLATINUM), //8 iron, 8 carbon, 4 platinum,
	/obj/item/stack/material/snow = list(REAGENT_ID_WATER),
	/obj/item/stack/material/sandstone = list(REAGENT_ID_SILICON, REAGENT_ID_OXYGEN),
	/obj/item/stack/material/glass = list(REAGENT_ID_SILICON),
	/obj/item/stack/material/glass/phoronglass = list(REAGENT_ID_PLATINUM, REAGENT_ID_SILICON, REAGENT_ID_SILICON, REAGENT_ID_SILICON), //5 platinum, 15 silicon,
	/obj/item/stack/material/supermatter = list(REAGENT_ID_SUPERMATTER)
	)

var/global/list/ore_reagents = list( //have a number of reageents divisible by REAGENTS_PER_ORE (default 20) unless you like decimals.
	/obj/item/ore/glass = list(REAGENT_ID_SILICON),
	/obj/item/ore/iron = list(REAGENT_ID_IRON),
	/obj/item/ore/coal = list(REAGENT_ID_CARBON),
	/obj/item/ore/phoron = list(REAGENT_ID_PHORON),
	/obj/item/ore/silver = list(REAGENT_ID_SILVER),
	/obj/item/ore/gold = list(REAGENT_ID_GOLD),
	/obj/item/ore/marble = list(REAGENT_ID_SILICON,REAGENT_ID_ALUMINIUM,REAGENT_ID_ALUMINIUM,REAGENT_ID_SODIUM,REAGENT_ID_CALCIUM), // Some nice variety here
	/obj/item/ore/uranium = list(REAGENT_ID_URANIUM),
	/obj/item/ore/diamond = list(REAGENT_ID_CARBON),
	/obj/item/ore/osmium = list(REAGENT_ID_PLATINUM), // should contain osmium
	/obj/item/ore/lead = list(REAGENT_ID_LEAD),
	/obj/item/ore/hydrogen = list(REAGENT_ID_HYDROGEN),
	/obj/item/ore/verdantium = list(REAGENT_ID_RADIUM,REAGENT_ID_PHORON,REAGENT_ID_NITROGEN,REAGENT_ID_PHOSPHORUS,REAGENT_ID_SODIUM), // Some fun stuff to be useful with
	/obj/item/ore/rutile = list(REAGENT_ID_TITANIUMDIOX,REAGENT_ID_OXYGEN),
	/obj/item/ore/copper = list(REAGENT_ID_COPPER),
	/obj/item/ore/tin = list(REAGENT_ID_TIN),
	/obj/item/ore/void_opal = list(REAGENT_ID_SILICON,REAGENT_ID_SILICON,REAGENT_ID_OXYGEN,REAGENT_ID_WATER),
	/obj/item/ore/painite = list(REAGENT_ID_CALCIUM,REAGENT_ID_ALUMINIUM,REAGENT_ID_OXYGEN,REAGENT_ID_OXYGEN),
	/obj/item/ore/quartz = list(REAGENT_ID_SILICON,REAGENT_ID_OXYGEN),
	/obj/item/ore/bauxite = list(REAGENT_ID_ALUMINIUM,REAGENT_ID_ALUMINIUM),
)

var/global/list/reagent_sheets = list( // Recompressing reagents back into sheets
	REAGENT_ID_COPPER 			= MAT_COPPER,
	REAGENT_ID_TIN 				= MAT_TIN,
	REAGENT_ID_WOODPULP 		= MAT_CARDBOARD,
	REAGENT_ID_CARBON 			= MAT_GRAPHITE,
	REAGENT_ID_ALUMINIUM 		= MAT_ALUMINIUM,
	REAGENT_ID_TITANIUM 		= MAT_TITANIUM,
	REAGENT_ID_IRON 			= MAT_IRON,
	REAGENT_ID_LEAD				= MAT_LEAD,
	REAGENT_ID_URANIUM			= MAT_URANIUM,
	REAGENT_ID_PHORON 			= MAT_PHORON,
	REAGENT_ID_GOLD 			= MAT_GOLD,
	REAGENT_ID_SILVER 			= MAT_SILVER,
	REAGENT_ID_PLATINUM			= MAT_PLATINUM,
	REAGENT_ID_SILICON 			= MAT_GLASS,
	// Mostly harmless
	REAGENT_ID_PROTEIN			= REFINERY_SINTERING_SMOKE,
	REAGENT_ID_TRIGLYCERIDE 	= REFINERY_SINTERING_SMOKE,
	REAGENT_ID_SODIUM	 		= REFINERY_SINTERING_SMOKE,
	REAGENT_ID_PHOSPHORUS 		= REFINERY_SINTERING_SMOKE,
	REAGENT_ID_ETHANOL 			= REFINERY_SINTERING_SMOKE,
	// Extremely stupid ones
	REAGENT_ID_OXYGEN 			= REFINERY_SINTERING_EXPLODE,
	REAGENT_ID_HYDROGEN 		= REFINERY_SINTERING_EXPLODE,
	REAGENT_ID_SUPERMATTER 		= REFINERY_SINTERING_EXPLODE,
	// Nothing is funnier to me
	REAGENT_ID_SPIDEREGG 		= REFINERY_SINTERING_SPIDERS,
	)
