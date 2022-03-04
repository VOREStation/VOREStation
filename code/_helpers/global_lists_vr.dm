/**
 * VOREStation global lists
*/

var/global/list/hair_accesories_list= list()// Stores /datum/sprite_accessory/hair_accessory indexed by type
var/global/list/negative_traits = list()	// Negative custom species traits, indexed by path
var/global/list/neutral_traits = list()		// Neutral custom species traits, indexed by path
var/global/list/everyone_traits = list()	// Neutral traits available to all species, indexed by path
var/global/list/positive_traits = list()	// Positive custom species traits, indexed by path
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
		/obj/item/weapon/hand_tele,
		/obj/item/weapon/card/id/gold/captain/spare,
		/obj/item/weapon/gun,
		/obj/item/weapon/pinpointer,
		/obj/item/clothing/shoes/magboots,
		/obj/item/blueprints,
		/obj/item/clothing/head/helmet/space,
		/obj/item/weapon/disk/nuclear,
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
		"None" = null)

var/global/list/classic_release_sounds = list(
		"Rustle (cloth)" = 'sound/effects/rustle1.ogg',
		"Rustle 2 (cloth)" = 'sound/effects/rustle2.ogg',
		"Rustle 3 (cloth)" = 'sound/effects/rustle3.ogg',
		"Rustle 4 (cloth)" = 'sound/effects/rustle4.ogg',
		"Rustle 5 (cloth)" = 'sound/effects/rustle5.ogg',
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
		"None" = null
		)

var/global/list/fancy_release_sounds = list(
		"Rustle (cloth)" = 'sound/effects/rustle1.ogg',
		"Rustle 2 (cloth)" = 'sound/effects/rustle2.ogg',
		"Rustle 3 (cloth)" = 'sound/effects/rustle3.ogg',
		"Rustle 4 (cloth)" = 'sound/effects/rustle4.ogg',
		"Rustle 5 (cloth)" = 'sound/effects/rustle5.ogg',
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
	"Unathi" 		= /obj/item/weapon/storage/vore_egg/unathi,
	"Tajara" 		= /obj/item/weapon/storage/vore_egg/tajaran,
	"Akula" 		= /obj/item/weapon/storage/vore_egg/shark,
	"Skrell" 		= /obj/item/weapon/storage/vore_egg/skrell,
	"Sergal"		= /obj/item/weapon/storage/vore_egg/sergal,
	"Nevrean"		= /obj/item/weapon/storage/vore_egg/nevrean,
	"Human"			= /obj/item/weapon/storage/vore_egg/human,
	"Slime"			= /obj/item/weapon/storage/vore_egg/slime,
	"Egg"			= /obj/item/weapon/storage/vore_egg,
	"Xenochimera"	= /obj/item/weapon/storage/vore_egg/scree,
	"Xenomorph"		= /obj/item/weapon/storage/vore_egg/xenomorph,
	"Chocolate"		= /obj/item/weapon/storage/vore_egg/chocolate,
	"Boney"			= /obj/item/weapon/storage/vore_egg/owlpellet,
	"Slime glob"	= /obj/item/weapon/storage/vore_egg/slimeglob,
	"Chicken"		= /obj/item/weapon/storage/vore_egg/chicken,
	"Synthetic"		= /obj/item/weapon/storage/vore_egg/synthetic,
	"Bluespace Floppy"	= /obj/item/weapon/storage/vore_egg/floppy,
	"Bluespace Compressed File"	= /obj/item/weapon/storage/vore_egg/file,
	"Bluespace CD"	= /obj/item/weapon/storage/vore_egg/cd,
	"Escape pod"	= /obj/item/weapon/storage/vore_egg/escapepod,
	"Cooking error"	= /obj/item/weapon/storage/vore_egg/badrecipe,
	"Web cocoon"	= /obj/item/weapon/storage/vore_egg/cocoon,
	"Honeycomb"	= /obj/item/weapon/storage/vore_egg/honeycomb,
	"Bug cocoon"	= /obj/item/weapon/storage/vore_egg/bugcocoon,
	"Rock"			= /obj/item/weapon/storage/vore_egg/rock,
	"Yellow"		= /obj/item/weapon/storage/vore_egg/yellow,
	"Blue"			= /obj/item/weapon/storage/vore_egg/blue,
	"Green"			= /obj/item/weapon/storage/vore_egg/green,
	"Orange"		= /obj/item/weapon/storage/vore_egg/orange,
	"Purple"		= /obj/item/weapon/storage/vore_egg/purple,
	"Red"			= /obj/item/weapon/storage/vore_egg/red,
	"Rainbow"		= /obj/item/weapon/storage/vore_egg/rainbow,
	"Spotted pink"	= /obj/item/weapon/storage/vore_egg/pinkspots)

var/global/list/edible_trash = list(/obj/item/broken_device,
				/obj/item/clothing/accessory/collar,
				/obj/item/device/communicator,
				/obj/item/clothing/mask,
				/obj/item/clothing/glasses,
				/obj/item/clothing/gloves,
				/obj/item/clothing/head,
				/obj/item/clothing/shoes,
				/obj/item/device/aicard,
				/obj/item/device/flashlight,
				/obj/item/device/mmi/digital/posibrain,
				/obj/item/device/paicard,
				/obj/item/device/pda,
				/obj/item/device/radio/headset,
				/obj/item/inflatable/torn,
				/obj/item/organ,
				/obj/item/stack/material/cardboard,
				/obj/item/toy,
				/obj/item/trash,
				/obj/item/weapon/digestion_remains,
				/obj/item/weapon/bananapeel,
				/obj/item/weapon/bone,
				/obj/item/weapon/broken_bottle,
				/obj/item/weapon/card/emag_broken,
				/obj/item/trash/cigbutt,
				/obj/item/weapon/circuitboard/broken,
				/obj/item/weapon/clipboard,
				/obj/item/weapon/corncob,
				/obj/item/weapon/dice,
				/obj/item/weapon/flame,
				/obj/item/weapon/light,
				/obj/item/weapon/lipstick,
				/obj/item/weapon/material/shard,
				/obj/item/weapon/newspaper,
				/obj/item/weapon/paper,
				/obj/item/weapon/paperplane,
				/obj/item/weapon/pen,
				/obj/item/weapon/photo,
				/obj/item/weapon/reagent_containers/food,
				/obj/item/weapon/reagent_containers/glass/rag,
				/obj/item/weapon/soap,
				/obj/item/weapon/spacecash,
				/obj/item/weapon/storage/box/khcrystal,
				/obj/item/weapon/storage/box/matches,
				/obj/item/weapon/storage/box/wings,
				/obj/item/weapon/storage/fancy/candle_box,
				/obj/item/weapon/storage/fancy/cigarettes,
				/obj/item/weapon/storage/fancy/crayons,
				/obj/item/weapon/storage/fancy/egg_box,
				/obj/item/weapon/storage/wallet,
				/obj/item/weapon/storage/vore_egg,
				/obj/item/weapon/bikehorn/tinytether,
				/obj/item/capture_crystal
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
			if(0)
				neutral_traits[traitpath] = T
				if(!(T.custom_only))
					everyone_traits[traitpath] = T
			if(0.1 to INFINITY)
				positive_traits[traitpath] = T


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
