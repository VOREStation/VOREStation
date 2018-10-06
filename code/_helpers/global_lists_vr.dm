/**
 * VOREStation global lists
*/

var/global/list/ear_styles_list = list()	// Stores /datum/sprite_accessory/ears indexed by type
var/global/list/tail_styles_list = list()	// Stores /datum/sprite_accessory/tail indexed by type
var/global/list/wing_styles_list = list()	// Stores /datum/sprite_accessory/wing indexed by type
var/global/list/negative_traits = list()	// Negative custom species traits, indexed by path
var/global/list/neutral_traits = list()		// Neutral custom species traits, indexed by path
var/global/list/positive_traits = list()	// Positive custom species traits, indexed by path
var/global/list/traits_costs = list()		// Just path = cost list, saves time in char setup
var/global/list/all_traits = list()			// All of 'em at once (same instances)

var/global/list/custom_species_bases = list() // Species that can be used for a Custom Species icon base

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

/* Time to finally undo this. Replaced with digest_act on these items.
//Important items that are preserved when people are digested, etc.
//On Polaris, different from Cryo list as MMIs need to be removed for FBPs to be logged out.
var/global/list/important_items = list(
		/obj/item/weapon/hand_tele,
		/obj/item/weapon/card/id/gold/captain/spare,
		/obj/item/device/aicard,
		/obj/item/device/mmi/digital/posibrain,
		/obj/item/device/paicard,
		/obj/item/weapon/gun,
		/obj/item/weapon/pinpointer,
		/obj/item/clothing/shoes/magboots,
		/obj/item/blueprints,
		/obj/item/clothing/head/helmet/space,
		/obj/item/weapon/disk/nuclear,
		/obj/item/clothing/suit/storage/hooded/wintercoat/roiz,
		/obj/item/device/perfect_tele_beacon)
*/

var/global/list/digestion_sounds = list(
		'sound/vore/digest1.ogg',
		'sound/vore/digest2.ogg',
		'sound/vore/digest3.ogg',
		'sound/vore/digest4.ogg',
		'sound/vore/digest5.ogg',
		'sound/vore/digest6.ogg',
		'sound/vore/digest7.ogg',
		'sound/vore/digest8.ogg',
		'sound/vore/digest9.ogg',
		'sound/vore/digest10.ogg',
		'sound/vore/digest11.ogg',
		'sound/vore/digest12.ogg')

var/global/list/death_sounds = list(
		'sound/vore/death1.ogg',
		'sound/vore/death2.ogg',
		'sound/vore/death3.ogg',
		'sound/vore/death4.ogg',
		'sound/vore/death5.ogg',
		'sound/vore/death6.ogg',
		'sound/vore/death7.ogg',
		'sound/vore/death8.ogg',
		'sound/vore/death9.ogg',
		'sound/vore/death10.ogg')

var/global/list/hunger_sounds = list(
		'sound/vore/growl1.ogg',
		'sound/vore/growl2.ogg',
		'sound/vore/growl3.ogg',
		'sound/vore/growl4.ogg',
		'sound/vore/growl5.ogg')

var/global/list/vore_sounds = list(
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
		"Rustle (cloth)" = 'sound/effects/rustle5.ogg',
		"None" = null)

var/global/list/struggle_sounds = list(
		"Squish1" = 'sound/vore/squish1.ogg',
		"Squish2" = 'sound/vore/squish2.ogg',
		"Squish3" = 'sound/vore/squish3.ogg',
		"Squish4" = 'sound/vore/squish4.ogg')


var/global/list/global_egg_types = list(
		"Unathi" 		= UNATHI_EGG,
		"Tajaran" 		= TAJARAN_EGG,
		"Akula" 		= AKULA_EGG,
		"Skrell" 		= SKRELL_EGG,
		"Nevrean"		= NEVREAN_EGG,
		"Sergal" 		= SERGAL_EGG,
		"Human"			= HUMAN_EGG,
		"Slime"			= SLIME_EGG,
		"Egg"			= EGG_EGG,
		"Xenochimera" 		= XENOCHIMERA_EGG,
		"Xenomorph"		= XENOMORPH_EGG)

var/global/list/tf_egg_types = list(
	"Unathi" 		= /obj/structure/closet/secure_closet/egg/unathi,
	"Tajara" 		= /obj/structure/closet/secure_closet/egg/tajaran,
	"Akula" 		= /obj/structure/closet/secure_closet/egg/shark,
	"Skrell" 		= /obj/structure/closet/secure_closet/egg/skrell,
	"Sergal"		= /obj/structure/closet/secure_closet/egg/sergal,
	"Nevrean"		= /obj/structure/closet/secure_closet/egg/nevrean,
	"Human"			= /obj/structure/closet/secure_closet/egg/human,
	"Slime"			= /obj/structure/closet/secure_closet/egg/slime,
	"Egg"			= /obj/structure/closet/secure_closet/egg,
	"Xenochimera"		= /obj/structure/closet/secure_closet/egg/scree,
	"Xenomorph"		= /obj/structure/closet/secure_closet/egg/xenomorph)

var/global/list/edible_trash = list(/obj/item/trash,
				/obj/item/device/flashlight,
				/obj/item/toy/figure,
				/obj/item/weapon/cigbutt,
				/obj/item/weapon/bananapeel,
				/obj/item/stack/material/cardboard,
				/obj/item/weapon/light,
				/obj/item/weapon/paper,
				/obj/item/weapon/broken_bottle,
				/obj/item/weapon/reagent_containers/food,
				/obj/item/inflatable/torn,
				/obj/item/weapon/flame/match,
				/obj/item/clothing/mask/smokable,
				/obj/item/weapon/storage/wallet,
				/obj/item/weapon/spacecash,
				/obj/item/broken_device,
				/obj/item/weapon/corncob,
				/obj/item/weapon/paperplane,
				/obj/item/weapon/pen,
				/obj/item/weapon/photo,
				/obj/item/weapon/storage/box/wings,
				/obj/item/weapon/storage/box/matches,
				/obj/item/weapon/storage/fancy/cigarettes,
				/obj/item/weapon/storage/fancy/egg_box,
				/obj/item/weapon/storage/fancy/candle_box,
				/obj/item/weapon/storage/fancy/crayons,
				/obj/item/weapon/dice,
				/obj/item/weapon/newspaper,
				/obj/item/weapon/reagent_containers/glass/rag,
				/obj/item/weapon/lipstick,
				/obj/item/weapon/soap,
				/obj/item/weapon/material/shard,
				/obj/item/device/paicard,
				/obj/item/device/mmi/digital/posibrain,
				/obj/item/device/aicard)

var/global/list/cont_flavors = list(
				"Generic" = cont_flavors_generic,
				"Acrid" = cont_flavors_acrid,
				"Dirty" = cont_flavors_dirty,
				"Musky" = cont_flavors_musky,
				"Smelly" = cont_flavors_smelly,
				"Wet" = cont_flavors_wet)

var/global/list/cont_flavors_generic = list("acrid",
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

var/global/list/cont_flavors_wet = list("damp",
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

var/global/list/cont_flavors_smelly = list("disgusting",
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

var/global/list/cont_flavors_acrid = list("acrid",
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

var/global/list/cont_flavors_dirty = list("bedraggled",
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

var/global/list/cont_flavors_musky = list("drenched",
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

/hook/startup/proc/init_vore_datum_ref_lists()
	var/paths

	// Custom Ears
	paths = typesof(/datum/sprite_accessory/ears) - /datum/sprite_accessory/ears
	for(var/path in paths)
		var/obj/item/clothing/head/instance = new path()
		ear_styles_list[path] = instance

	// Custom Tails
	paths = typesof(/datum/sprite_accessory/tail) - /datum/sprite_accessory/tail - /datum/sprite_accessory/tail/taur
	for(var/path in paths)
		var/datum/sprite_accessory/tail/instance = new path()
		tail_styles_list[path] = instance

	// Custom Wings
	paths = typesof(/datum/sprite_accessory/wing) - /datum/sprite_accessory/wing
	for(var/path in paths)
		var/datum/sprite_accessory/wing/instance = new path()
		wing_styles_list[path] = instance

	// Custom species traits
	paths = typesof(/datum/trait) - /datum/trait
	for(var/path in paths)
		var/datum/trait/instance = new path()
		if(!instance.name)
			continue //A prototype or something
		var/cost = instance.cost
		traits_costs[path] = cost
		all_traits[path] = instance
		switch(cost)
			if(-INFINITY to -0.1)
				negative_traits[path] = instance
			if(0)
				neutral_traits[path] = instance
			if(0.1 to INFINITY)
				positive_traits[path] = instance

	// Custom species icon bases
	var/list/blacklisted_icons = list(SPECIES_CUSTOM,SPECIES_PROMETHEAN) //Just ones that won't work well.
	for(var/species_name in playable_species)
		if(species_name in blacklisted_icons)
			continue
		var/datum/species/S = all_species[species_name]
		if(S.spawn_flags & SPECIES_IS_WHITELISTED)
			continue
		custom_species_bases += species_name

	return 1 // Hooks must return 1
