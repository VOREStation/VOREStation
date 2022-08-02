/**
 * VOREStation global lists
*/

var/global/list/hair_accesories_list= list()// Stores /datum/sprite_accessory/hair_accessory indexed by type
var/global/list/negative_traits = list()	// Negative custom species traits, indexed by path
var/global/list/neutral_traits = list()		// Neutral custom species traits, indexed by path
var/global/list/positive_traits = list()	// Positive custom species traits, indexed by path
var/global/list/everyone_traits_positive = list()	// Neutral traits available to all species, indexed by path
var/global/list/everyone_traits_neutral = list()	// Neutral traits available to all species, indexed by path
var/global/list/everyone_traits_negative = list()	// Neutral traits available to all species, indexed by path
var/global/list/traits_costs = list()		// Just path = cost list, saves time in char setup
var/global/list/all_traits = list()			// All of 'em at once (same instances)
var/global/list/active_ghost_pods = list()

var/global/list/sensorpreflist = list("Off", "Binary", "Vitals", "Tracking", "No Preference")

// Used by the ban panel to determine what departments are offmap departments. All these share an 'offmap roles' ban.
var/global/list/offmap_departments = list(DEPARTMENT_TALON)

// Closets have magic appearances
GLOBAL_LIST_EMPTY(closet_appearances)

//stores numeric player size options indexed by name
var/global/list/player_sizes_list = list(
		"Macro" 	= RESIZE_HUGE,
		"Big" 		= RESIZE_BIG,
		"Normal" 	= RESIZE_NORMAL,
		"Small" 	= RESIZE_SMALL,
		"Tiny" 		= RESIZE_TINY)

//stores vantag settings indexed by name
var/global/list/vantag_choices_list = list(
		VANTAG_NONE		=	"No Involvement",
		VANTAG_VORE		=	"Be Prey",
		VANTAG_KIDNAP	=	"Be Kidnapped",
		VANTAG_KILL		=	"Be Killed")

//Blacklist to exclude items from object ingestion. Digestion blacklist located in digest_act_vr.dm
var/global/list/item_vore_blacklist = list(
		/obj/item/hand_tele,
		/obj/item/card/id/gold/captain/spare,
		/obj/item/gun,
		/obj/item/pinpointer,
		/obj/item/clothing/shoes/magboots,
		/obj/item/blueprints,
		/obj/item/clothing/head/helmet/space,
		/obj/item/disk/nuclear,
		/obj/item/clothing/suit/storage/hooded/wintercoat/roiz)

//Classic Vore sounds
var/global/list/classic_vore_sounds = list(
		"Gulp" = 'sound/vore/gulp.ogg',
		"Insert" = 'sound/vore/insert.ogg',
		"Insertion1" = 'sound/vore/insertion1.ogg',
		"Insertion2" = 'sound/vore/insertion2.ogg',
		"Insertion3" = 'sound/vore/insertion3.ogg',
		"Schlorp" = 'sound/vore/schlorp.ogg',
		"Squish1" = 'sound/vore/squish1.ogg',
		"Squish2" = 'sound/vore/squish2.ogg',
		"Squish3" = 'sound/vore/squish3.ogg',
		"Squish4" = 'sound/vore/squish4.ogg',
		"Rustle (cloth)" = 'sound/effects/rustle1.ogg',
		"Rustle 2 (cloth)"	= 'sound/effects/rustle2.ogg',
		"Rustle 3 (cloth)"	= 'sound/effects/rustle3.ogg',
		"Rustle 4 (cloth)"	= 'sound/effects/rustle4.ogg',
		"Rustle 5 (cloth)"	= 'sound/effects/rustle5.ogg',
		"Zipper" = 'sound/items/zip.ogg',
		"None" = null)

var/global/list/classic_release_sounds = list(
		"Rustle (cloth)" = 'sound/effects/rustle1.ogg',
		"Rustle 2 (cloth)" = 'sound/effects/rustle2.ogg',
		"Rustle 3 (cloth)" = 'sound/effects/rustle3.ogg',
		"Rustle 4 (cloth)" = 'sound/effects/rustle4.ogg',
		"Rustle 5 (cloth)" = 'sound/effects/rustle5.ogg',
		"Zipper" = 'sound/items/zip.ogg',
		"Splatter" = 'sound/effects/splat.ogg',
		"None" = null
		)

//Poojy's Fancy Sounds
var/global/list/fancy_vore_sounds = list(
		"Gulp" = 'sound/vore/sunesound/pred/swallow_01.ogg',
		"Swallow" = 'sound/vore/sunesound/pred/swallow_02.ogg',
		"Insertion1" = 'sound/vore/sunesound/pred/insertion_01.ogg',
		"Insertion2" = 'sound/vore/sunesound/pred/insertion_02.ogg',
		"Tauric Swallow" = 'sound/vore/sunesound/pred/taurswallow.ogg',
		"Stomach Move"		= 'sound/vore/sunesound/pred/stomachmove.ogg',
		"Schlorp" = 'sound/vore/sunesound/pred/schlorp.ogg',
		"Squish1" = 'sound/vore/sunesound/pred/squish_01.ogg',
		"Squish2" = 'sound/vore/sunesound/pred/squish_02.ogg',
		"Squish3" = 'sound/vore/sunesound/pred/squish_03.ogg',
		"Squish4" = 'sound/vore/sunesound/pred/squish_04.ogg',
		"Rustle (cloth)" = 'sound/effects/rustle1.ogg',
		"Rustle 2 (cloth)"	= 'sound/effects/rustle2.ogg',
		"Rustle 3 (cloth)"	= 'sound/effects/rustle3.ogg',
		"Rustle 4 (cloth)"	= 'sound/effects/rustle4.ogg',
		"Rustle 5 (cloth)"	= 'sound/effects/rustle5.ogg',
		"Zipper" = 'sound/items/zip.ogg',
		"None" = null
		)

var/global/list/fancy_release_sounds = list(
		"Rustle (cloth)" = 'sound/effects/rustle1.ogg',
		"Rustle 2 (cloth)" = 'sound/effects/rustle2.ogg',
		"Rustle 3 (cloth)" = 'sound/effects/rustle3.ogg',
		"Rustle 4 (cloth)" = 'sound/effects/rustle4.ogg',
		"Rustle 5 (cloth)" = 'sound/effects/rustle5.ogg',
		"Zipper" = 'sound/items/zip.ogg',
		"Stomach Move" = 'sound/vore/sunesound/pred/stomachmove.ogg',
		"Pred Escape" = 'sound/vore/sunesound/pred/escape.ogg',
		"Splatter" = 'sound/effects/splat.ogg',
		"None" = null
		)

var/global/list/global_vore_egg_types = list(
	"Unathi",
	"Tajara",
	"Akula",
	"Skrell",
	"Sergal",
	"Nevrean",
	"Human",
	"Slime",
	"Egg",
	"Xenochimera",
	"Xenomorph",
	"Chocolate",
	"Boney",
	"Slime glob",
	"Chicken",
	"Synthetic",
	"Bluespace Floppy",
	"Bluespace Compressed File",
	"Bluespace CD",
	"Escape pod",
	"Cooking error",
	"Web cocoon",
	"Honeycomb",
	"Bug cocoon",
	"Rock",
	"Yellow",
	"Blue",
	"Green",
	"Orange",
	"Purple",
	"Red",
	"Rainbow",
	"Spotted pink")

var/global/list/tf_vore_egg_types = list(
	"Unathi" 		= /obj/item/storage/vore_egg/unathi,
	"Tajara" 		= /obj/item/storage/vore_egg/tajaran,
	"Akula" 		= /obj/item/storage/vore_egg/shark,
	"Skrell" 		= /obj/item/storage/vore_egg/skrell,
	"Sergal"		= /obj/item/storage/vore_egg/sergal,
	"Nevrean"		= /obj/item/storage/vore_egg/nevrean,
	"Human"			= /obj/item/storage/vore_egg/human,
	"Slime"			= /obj/item/storage/vore_egg/slime,
	"Egg"			= /obj/item/storage/vore_egg,
	"Xenochimera"	= /obj/item/storage/vore_egg/scree,
	"Xenomorph"		= /obj/item/storage/vore_egg/xenomorph,
	"Chocolate"		= /obj/item/storage/vore_egg/chocolate,
	"Boney"			= /obj/item/storage/vore_egg/owlpellet,
	"Slime glob"	= /obj/item/storage/vore_egg/slimeglob,
	"Chicken"		= /obj/item/storage/vore_egg/chicken,
	"Synthetic"		= /obj/item/storage/vore_egg/synthetic,
	"Bluespace Floppy"	= /obj/item/storage/vore_egg/floppy,
	"Bluespace Compressed File"	= /obj/item/storage/vore_egg/file,
	"Bluespace CD"	= /obj/item/storage/vore_egg/cd,
	"Escape pod"	= /obj/item/storage/vore_egg/escapepod,
	"Cooking error"	= /obj/item/storage/vore_egg/badrecipe,
	"Web cocoon"	= /obj/item/storage/vore_egg/cocoon,
	"Honeycomb"	= /obj/item/storage/vore_egg/honeycomb,
	"Bug cocoon"	= /obj/item/storage/vore_egg/bugcocoon,
	"Rock"			= /obj/item/storage/vore_egg/rock,
	"Yellow"		= /obj/item/storage/vore_egg/yellow,
	"Blue"			= /obj/item/storage/vore_egg/blue,
	"Green"			= /obj/item/storage/vore_egg/green,
	"Orange"		= /obj/item/storage/vore_egg/orange,
	"Purple"		= /obj/item/storage/vore_egg/purple,
	"Red"			= /obj/item/storage/vore_egg/red,
	"Rainbow"		= /obj/item/storage/vore_egg/rainbow,
	"Spotted pink"	= /obj/item/storage/vore_egg/pinkspots)

var/global/list/edible_trash = list(/obj/item/broken_device,
				/obj/item/clothing/accessory/collar,
				/obj/item/communicator,
				/obj/item/clothing/mask,
				/obj/item/clothing/glasses,
				/obj/item/clothing/gloves,
				/obj/item/clothing/head,
				/obj/item/clothing/shoes,
				/obj/item/aicard,
				/obj/item/flashlight,
				/obj/item/mmi/digital/posibrain,
				/obj/item/paicard,
				/obj/item/pda,
				/obj/item/radio/headset,
				/obj/item/inflatable/torn,
				/obj/item/organ,
				/obj/item/stack/material/cardboard,
				/obj/item/toy,
				/obj/item/trash,
				/obj/item/digestion_remains,
				/obj/item/bananapeel,
				/obj/item/bone,
				/obj/item/broken_bottle,
				/obj/item/card/emag_broken,
				/obj/item/trash/cigbutt,
				/obj/item/circuitboard/broken,
				/obj/item/clipboard,
				/obj/item/corncob,
				/obj/item/dice,
				/obj/item/flame,
				/obj/item/light,
				/obj/item/lipstick,
				/obj/item/material/shard,
				/obj/item/newspaper,
				/obj/item/paper,
				/obj/item/paperplane,
				/obj/item/pen,
				/obj/item/photo,
				/obj/item/reagent_containers/food,
				/obj/item/reagent_containers/glass/rag,
				/obj/item/soap,
				/obj/item/spacecash,
				/obj/item/storage/box/khcrystal,
				/obj/item/storage/box/matches,
				/obj/item/storage/box/wings,
				/obj/item/storage/fancy/candle_box,
				/obj/item/storage/fancy/cigarettes,
				/obj/item/storage/fancy/crayons,
				/obj/item/storage/fancy/egg_box,
				/obj/item/storage/wallet,
				/obj/item/storage/vore_egg,
				/obj/item/bikehorn/tinytether,
				/obj/item/capture_crystal,
				/obj/item/roulette_ball
				)

var/global/list/contamination_flavors = list(
				"Generic" = contamination_flavors_generic,
				"Acrid" = contamination_flavors_acrid,
				"Dirty" = contamination_flavors_dirty,
				"Musky" = contamination_flavors_musky,
				"Smelly" = contamination_flavors_smelly,
				"Slimy" = contamination_flavors_slimy,
				"Wet" = contamination_flavors_wet)

var/global/list/contamination_flavors_generic = list("acrid",
				"bedraggled",
				"begrimed",
				"churned",
				"contaminated",
				"cruddy",
				"damp",
				"digested",
				"dirty",
				"disgusting",
				"drenched",
				"drippy",
				"filthy",
				"foul",
				"funky",
				"gloppy",
				"gooey",
				"grimy",
				"gross",
				"gruesome",
				"gunky",
				"icky",
				"juicy",
				"messy",
				"mucky",
				"mushy",
				"nasty",
				"noxious",
				"oozing",
				"pungent",
				"putrescent",
				"putrid",
				"repulsive",
				"saucy",
				"slimy",
				"sloppy",
				"sloshed",
				"sludgy",
				"smeary",
				"smelly",
				"smudgy",
				"smutty",
				"soaked",
				"soggy",
				"soiled",
				"sopping",
				"squashy",
				"squishy",
				"stained",
				"sticky",
				"stinky",
				"tainted",
				"tarnished",
				"unclean",
				"unsanitary",
				"unsavory",
				"yucky")

var/global/list/contamination_flavors_wet = list("damp",
				"drenched",
				"drippy",
				"gloppy",
				"gooey",
				"juicy",
				"oozing",
				"slimy",
				"slobbery",
				"sloppy",
				"sloshed",
				"sloughy",
				"sludgy",
				"slushy",
				"soaked",
				"soggy",
				"sopping",
				"squashy",
				"squishy",
				"sticky")

var/global/list/contamination_flavors_smelly = list("disgusting",
				"filthy",
				"foul",
				"funky",
				"gross",
				"icky",
				"malodorous",
				"nasty",
				"niffy",
				"noxious",
				"pungent",
				"putrescent",
				"putrid",
				"rancid",
				"reeking",
				"repulsive",
				"smelly",
				"stenchy",
				"stinky",
				"unsavory",
				"whiffy",
				"yucky")

var/global/list/contamination_flavors_acrid = list("acrid",
				"caustic",
				"churned",
				"chymous",
				"digested",
				"discolored",
				"disgusting",
				"drippy",
				"foul",
				"gloppy",
				"gooey",
				"grimy",
				"gross",
				"gruesome",
				"icky",
				"mucky",
				"mushy",
				"nasty",
				"noxious",
				"oozing",
				"pungent",
				"putrescent",
				"putrid",
				"repulsive",
				"saucy",
				"slimy",
				"sloppy",
				"sloshed",
				"sludgy",
				"slushy",
				"smelly",
				"smudgy",
				"soupy",
				"squashy",
				"squishy",
				"stained",
				"sticky",
				"tainted",
				"unsavory",
				"yucky")

var/global/list/contamination_flavors_dirty = list("bedraggled",
				"begrimed",
				"besmirched",
				"blemished",
				"contaminated",
				"cruddy",
				"dirty",
				"discolored",
				"filthy",
				"gloppy",
				"gooey",
				"grimy",
				"gross",
				"grubby",
				"gruesome",
				"gunky",
				"messy",
				"mucky",
				"mushy",
				"nasty",
				"saucy",
				"slimy",
				"sloppy",
				"sludgy",
				"smeary",
				"smudgy",
				"smutty",
				"soiled",
				"stained",
				"sticky",
				"tainted",
				"tarnished",
				"unclean",
				"unsanitary",
				"unsavory")

var/global/list/contamination_flavors_musky = list("drenched",
				"drippy",
				"funky",
				"gooey",
				"juicy",
				"messy",
				"musky",
				"nasty",
				"raunchy",
				"saucy",
				"slimy",
				"sloppy",
				"slushy",
				"smeary",
				"smelly",
				"smutty",
				"soggy",
				"squashy",
				"squishy",
				"sticky",
				"tainted")

var/global/list/contamination_flavors_slimy = list("slimy",
				"sloppy",
				"drippy",
				"glistening",
				"dripping",
				"gunky",
				"slimed",
				"mucky",
				"viscous",
				"dank",
				"glutinous",
				"syrupy",
				"slippery",
				"gelatinous")

var/global/list/contamination_colors = list("green",
				"white",
				"black",
				"grey",
				"yellow",
				"red",
				"blue",
				"orange",
				"purple",
				"lime",
				"brown",
				"darkred",
				"cyan",
				"beige",
				"pink")

//For the mechanic of leaving remains. Ones listed below are basically ones that got no bones or leave no trace after death.
var/global/list/remainless_species = list(SPECIES_PROMETHEAN,
				SPECIES_DIONA,
				SPECIES_ALRAUNE,
				SPECIES_PROTEAN,
				SPECIES_MONKEY,					//Exclude all monkey subtypes, to prevent abuse of it. They aren't,
				SPECIES_MONKEY_TAJ,				//set to have remains anyway, but making double sure,
				SPECIES_MONKEY_SKRELL,
				SPECIES_MONKEY_UNATHI,
				SPECIES_MONKEY_AKULA,
				SPECIES_MONKEY_NEVREAN,
				SPECIES_MONKEY_SERGAL,
				SPECIES_MONKEY_VULPKANIN,
				SPECIES_XENO,					//Same for xenos,
				SPECIES_XENO_DRONE,
				SPECIES_XENO_HUNTER,
				SPECIES_XENO_SENTINEL,
				SPECIES_XENO_QUEEN,
				SPECIES_SHADOW,
				SPECIES_GOLEM,					//Some special species that may or may not be ever used in event too,
				SPECIES_SHADEKIN)			//Shadefluffers just poof away

/var/global/list/alt_titles_with_icons = list(
				"Virologist",
				"Apprentice Engineer",
				"Medical Intern",
				"Research Intern",
				"Security Cadet",
				"Jr. Cargo Tech",
				"Jr. Explorer",
				"Server",
				"Electrician",
				"Barista")

/var/global/list/existing_solargrubs = list()

/hook/startup/proc/init_vore_datum_ref_lists()
	var/paths

	// Custom Hair Accessories
	paths = subtypesof(/datum/sprite_accessory/hair_accessory)
	for(var/path in paths)
		var/datum/sprite_accessory/hair_accessory/instance = new path()
		hair_accesories_list[path] = instance

	// Custom species traits
	paths = typesof(/datum/trait) - /datum/trait - /datum/trait/negative - /datum/trait/neutral - /datum/trait/positive
	for(var/path in paths)
		var/datum/trait/instance = new path()
		if(!instance.name)
			continue //A prototype or something
		var/cost = instance.cost
		traits_costs[path] = cost
		all_traits[path] = instance

	// Shakey shakey shake
	sortTim(all_traits, /proc/cmp_trait_datums_name, associative = TRUE)

	// Split 'em up
	for(var/traitpath in all_traits)
		var/datum/trait/T = all_traits[traitpath]
		var/category = T.category
		switch(category)
			if(-INFINITY to -0.1)
				negative_traits[traitpath] = T
				if(!(T.custom_only))
					everyone_traits_negative[traitpath] = T
			if(0)
				neutral_traits[traitpath] = T
				if(!(T.custom_only))
					everyone_traits_neutral[traitpath] = T
			if(0.1 to INFINITY)
				positive_traits[traitpath] = T
				if(!(T.custom_only))
					everyone_traits_positive[traitpath] = T


	// Weaver recipe stuff
	paths = subtypesof(/datum/weaver_recipe/structure)
	for(var/path in paths)
		var/datum/weaver_recipe/instance = new path()
		if(!instance.title)
			continue //A prototype or something
		weavable_structures[instance.title] = instance

	paths = subtypesof(/datum/weaver_recipe/item)
	for(var/path in paths)
		var/datum/weaver_recipe/instance = new path()
		if(!instance.title)
			continue //A prototype or something
		weavable_items[instance.title] = instance

	return 1 // Hooks must return 1

var/global/list/weavable_structures = list()
var/global/list/weavable_items = list()


var/global/list/xenobio_metal_materials_normal = list(
										/obj/item/stack/material/steel = 20,
										/obj/item/stack/material/glass = 15,
										/obj/item/stack/material/plastic = 12,
										/obj/item/stack/material/wood = 12,
										/obj/item/stack/material/cardboard = 6,
										/obj/item/stack/material/sandstone = 5,
										/obj/item/stack/material/log = 5,
										/obj/item/stack/material/lead = 5,
										/obj/item/stack/material/iron = 5,
										/obj/item/stack/material/graphite = 5,
										/obj/item/stack/material/copper = 4,
										/obj/item/stack/material/tin = 4,
										/obj/item/stack/material/bronze = 4,
										/obj/item/stack/material/aluminium = 4)

var/global/list/xenobio_metal_materials_adv = list(
										/obj/item/stack/material/glass/reinforced = 15,
										/obj/item/stack/material/marble = 10,
										/obj/item/stack/material/plasteel = 10,
										/obj/item/stack/material/glass/phoronglass = 10,
										/obj/item/stack/material/wood/sif = 5,
										/obj/item/stack/material/wood/hard = 5,
										/obj/item/stack/material/log/sif = 5,
										/obj/item/stack/material/log/hard = 5,
										/obj/item/stack/material/glass/phoronrglass = 5,
										/obj/item/stack/material/glass/titanium = 3,
										/obj/item/stack/material/glass/plastitanium = 3,
										/obj/item/stack/material/durasteel = 2,
										/obj/item/stack/material/painite = 1,
										/obj/item/stack/material/void_opal = 1,
										/obj/item/stack/material/quartz = 1)

var/global/list/xenobio_metal_materials_weird = list(
										/obj/item/stack/material/cloth = 10,
										/obj/item/stack/material/leather = 5,
										/obj/item/stack/material/fiber = 5,
										/obj/item/stack/material/fur/wool = 7,
										/obj/item/stack/material/snow = 3,
										/obj/item/stack/material/snowbrick = 3,
										/obj/item/stack/material/flint = 3,
										/obj/item/stack/material/stick = 3,
										/obj/item/stack/material/chitin = 1)

var/global/list/xenobio_silver_materials_basic = list(
										/obj/item/stack/material/silver = 10,
										/obj/item/stack/material/uranium = 8,
										/obj/item/stack/material/gold = 6,
										/obj/item/stack/material/titanium = 4,
										/obj/item/stack/material/phoron = 1)

var/global/list/xenobio_silver_materials_adv = list(
										/obj/item/stack/material/deuterium = 5,
										/obj/item/stack/material/tritium = 5,
										/obj/item/stack/material/osmium = 5,
										/obj/item/stack/material/mhydrogen = 3,
										/obj/item/stack/material/diamond = 2,
										/obj/item/stack/material/verdantium = 1)

var/global/list/xenobio_silver_materials_special = list(
										/obj/item/stack/material/valhollide = 1,
										/obj/item/stack/material/morphium = 1,
										/obj/item/stack/material/supermatter = 1)

var/global/list/xenobio_gold_mobs_hostile = list(
										/mob/living/simple_mob/vore/alienanimals/space_jellyfish,
										/mob/living/simple_mob/vore/alienanimals/skeleton,
										/mob/living/simple_mob/vore/alienanimals/space_ghost,
										/mob/living/simple_mob/vore/alienanimals/startreader,
										/mob/living/simple_mob/animal/passive/mouse/operative,
										/mob/living/simple_mob/animal/giant_spider,
										/mob/living/simple_mob/animal/giant_spider/frost,
										/mob/living/simple_mob/animal/giant_spider/electric,
										/mob/living/simple_mob/animal/giant_spider/hunter,
										/mob/living/simple_mob/animal/giant_spider/lurker,
										/mob/living/simple_mob/animal/giant_spider/pepper,
										/mob/living/simple_mob/animal/giant_spider/thermic,
										/mob/living/simple_mob/animal/giant_spider/tunneler,
										/mob/living/simple_mob/animal/giant_spider/webslinger,
										/mob/living/simple_mob/animal/giant_spider/phorogenic,
										/mob/living/simple_mob/animal/giant_spider/carrier,
										/mob/living/simple_mob/animal/giant_spider/nurse,
										/mob/living/simple_mob/animal/giant_spider/ion,
										/mob/living/simple_mob/animal/giant_spider/nurse/queen,
										/mob/living/simple_mob/animal/sif/diyaab,
										/mob/living/simple_mob/animal/sif/duck,
										/mob/living/simple_mob/animal/sif/frostfly,
										/mob/living/simple_mob/animal/sif/glitterfly,
										/mob/living/simple_mob/animal/sif/hooligan_crab,
										/mob/living/simple_mob/animal/sif/kururak,
										/mob/living/simple_mob/animal/sif/leech,
										/mob/living/simple_mob/animal/sif/tymisian,
										/mob/living/simple_mob/animal/sif/sakimm,
										/mob/living/simple_mob/animal/sif/savik,
										/mob/living/simple_mob/animal/sif/shantak,
										/mob/living/simple_mob/animal/sif/siffet,
										/mob/living/simple_mob/animal/space/alien,
										/mob/living/simple_mob/animal/space/alien/drone,
										/mob/living/simple_mob/animal/space/alien/sentinel,
										/mob/living/simple_mob/animal/space/alien/sentinel/praetorian,
										/mob/living/simple_mob/animal/space/alien/queen,
										/mob/living/simple_mob/animal/space/alien/queen/empress,
										/mob/living/simple_mob/animal/space/alien/queen/empress/mother,
										/mob/living/simple_mob/animal/space/bats,
										/mob/living/simple_mob/animal/space/bear,
										/mob/living/simple_mob/animal/space/carp,
										/mob/living/simple_mob/animal/space/carp/large,
										/mob/living/simple_mob/animal/space/carp/large/huge,
										/mob/living/simple_mob/animal/space/goose,
										/mob/living/simple_mob/creature,
										/mob/living/simple_mob/faithless,
										/mob/living/simple_mob/tomato,
										/mob/living/simple_mob/animal/space/tree,
										/mob/living/simple_mob/vore/aggressive/corrupthound,
										/mob/living/simple_mob/vore/aggressive/corrupthound/prettyboi,
										/mob/living/simple_mob/vore/aggressive/deathclaw,
										/mob/living/simple_mob/vore/aggressive/dino,
										/mob/living/simple_mob/vore/aggressive/dragon,
										/mob/living/simple_mob/vore/aggressive/frog,
										/mob/living/simple_mob/otie,
										/mob/living/simple_mob/otie/red,
										/mob/living/simple_mob/vore/aggressive/panther,
										/mob/living/simple_mob/vore/aggressive/rat,
										/mob/living/simple_mob/vore/aggressive/giant_snake,
										/mob/living/simple_mob/vore/sect_drone,
										/mob/living/simple_mob/vore/sect_queen,
										/mob/living/simple_mob/vore/weretiger,
										/mob/living/simple_mob/animal/wolf,
										/mob/living/simple_mob/vore/xeno_defanged)

var/global/list/xenobio_gold_mobs_bosses = list(
										/mob/living/simple_mob/animal/giant_spider/broodmother,
										/mob/living/simple_mob/vore/leopardmander,
										/mob/living/simple_mob/vore/leopardmander/blue,
										/mob/living/simple_mob/vore/leopardmander/exotic,
										/mob/living/simple_mob/vore/greatwolf,
										/mob/living/simple_mob/vore/greatwolf/black,
										/mob/living/simple_mob/vore/greatwolf/grey,
										/mob/living/simple_mob/vore/bigdragon)

var/global/list/xenobio_gold_mobs_safe = list(
										/mob/living/simple_mob/vore/alienanimals/dustjumper,
										/mob/living/simple_mob/vore/alienanimals/teppi,
										/mob/living/simple_mob/animal/passive/chicken,
										/mob/living/simple_mob/animal/passive/cow,
										/mob/living/simple_mob/animal/goat,
										/mob/living/simple_mob/animal/passive/crab,
										/mob/living/simple_mob/animal/passive/mouse/jerboa,
										/mob/living/simple_mob/animal/passive/lizard,
										/mob/living/simple_mob/animal/passive/lizard/large,
										/mob/living/simple_mob/animal/passive/yithian,
										/mob/living/simple_mob/animal/passive/tindalos,
										/mob/living/simple_mob/animal/passive/mouse,
										/mob/living/simple_mob/animal/passive/penguin,
										/mob/living/simple_mob/animal/passive/opossum,
										/mob/living/simple_mob/animal/passive/cat,
										/mob/living/simple_mob/animal/passive/dog/corgi,
										/mob/living/simple_mob/animal/passive/dog/void_puppy,
										/mob/living/simple_mob/animal/passive/dog/bullterrier,
										/mob/living/simple_mob/animal/passive/dog/tamaskan,
										/mob/living/simple_mob/animal/passive/dog/brittany,
										/mob/living/simple_mob/animal/passive/fox,
										/mob/living/simple_mob/animal/passive/fox/syndicate,
										/mob/living/simple_mob/animal/passive/hare,
										/mob/living/simple_mob/animal/passive/pillbug,
										/mob/living/simple_mob/animal/passive/gaslamp,
										/mob/living/simple_mob/animal/passive/snake,
										/mob/living/simple_mob/animal/passive/snake/red,
										/mob/living/simple_mob/animal/passive/snake/python,
										/mob/living/simple_mob/vore/bee,
										/mob/living/simple_mob/vore/fennec,
										/mob/living/simple_mob/vore/fennix,
										/mob/living/simple_mob/vore/hippo,
										/mob/living/simple_mob/vore/horse,
										/mob/living/simple_mob/animal/space/jelly,
										/mob/living/simple_mob/vore/oregrub,
										/mob/living/simple_mob/vore/oregrub/lava,
										/mob/living/simple_mob/vore/rabbit,
										/mob/living/simple_mob/vore/redpanda,
										/mob/living/simple_mob/vore/sheep,
										/mob/living/simple_mob/vore/solargrub)

var/global/list/xenobio_gold_mobs_birds = list(/mob/living/simple_mob/animal/passive/bird/black_bird,
										/mob/living/simple_mob/animal/passive/bird/azure_tit,
										/mob/living/simple_mob/animal/passive/bird/european_robin,
										/mob/living/simple_mob/animal/passive/bird/goldcrest,
										/mob/living/simple_mob/animal/passive/bird/ringneck_dove,
										/mob/living/simple_mob/animal/passive/bird/parrot,
										/mob/living/simple_mob/animal/passive/bird/parrot/kea,
										/mob/living/simple_mob/animal/passive/bird/parrot/eclectus,
										/mob/living/simple_mob/animal/passive/bird/parrot/grey_parrot,
										/mob/living/simple_mob/animal/passive/bird/parrot/black_headed_caique,
										/mob/living/simple_mob/animal/passive/bird/parrot/white_caique,
										/mob/living/simple_mob/animal/passive/bird/parrot/budgerigar,
										/mob/living/simple_mob/animal/passive/bird/parrot/budgerigar/blue,
										/mob/living/simple_mob/animal/passive/bird/parrot/budgerigar/bluegreen,
										/mob/living/simple_mob/animal/passive/bird/parrot/cockatiel,
										/mob/living/simple_mob/animal/passive/bird/parrot/cockatiel/white,
										/mob/living/simple_mob/animal/passive/bird/parrot/cockatiel/yellowish,
										/mob/living/simple_mob/animal/passive/bird/parrot/cockatiel/grey,
										/mob/living/simple_mob/animal/passive/bird/parrot/sulphur_cockatoo,
										/mob/living/simple_mob/animal/passive/bird/parrot/white_cockatoo,
										/mob/living/simple_mob/animal/passive/bird/parrot/pink_cockatoo)			//There's too dang many

var/global/list/xenobio_cerulean_potions = list(
										/obj/item/slimepotion/enhancer,
										/obj/item/slimepotion/stabilizer,
										/obj/item/slimepotion/mutator,
										/obj/item/slimepotion/docility,
										/obj/item/slimepotion/steroid,
										/obj/item/slimepotion/unity,
										/obj/item/slimepotion/loyalty,
										/obj/item/slimepotion/friendship,
										/obj/item/slimepotion/feeding,
										/obj/item/slimepotion/infertility,
										/obj/item/slimepotion/fertility,
										/obj/item/slimepotion/shrink,
										/obj/item/slimepotion/death,
										/obj/item/slimepotion/ferality,
										/obj/item/slimepotion/reinvigoration,
										/obj/item/slimepotion/mimic,
										/obj/item/slimepotion/sapience,
										/obj/item/slimepotion/obedience)

var/global/list/xenobio_rainbow_extracts = list(
										/obj/item/slime_extract/grey = 2,
										/obj/item/slime_extract/metal = 3,
										/obj/item/slime_extract/blue = 3,
										/obj/item/slime_extract/purple = 1,
										/obj/item/slime_extract/orange = 3,
										/obj/item/slime_extract/yellow = 3,
										/obj/item/slime_extract/gold = 3,
										/obj/item/slime_extract/silver = 3,
										/obj/item/slime_extract/dark_purple = 2,
										/obj/item/slime_extract/dark_blue = 3,
										/obj/item/slime_extract/red = 3,
										/obj/item/slime_extract/green = 3,
										/obj/item/slime_extract/pink = 3,
										/obj/item/slime_extract/oil = 3,
										/obj/item/slime_extract/bluespace = 3,
										/obj/item/slime_extract/cerulean = 1,
										/obj/item/slime_extract/amber = 3,
										/obj/item/slime_extract/sapphire = 3,
										/obj/item/slime_extract/ruby = 3,
										/obj/item/slime_extract/emerald = 3,
										/obj/item/slime_extract/light_pink = 1,
										/obj/item/slime_extract/rainbow = 1)
