/datum/gear/accessory
	display_name = "accessory"
	slot = slot_tie
	sort_category = "Accessories"
	type_category = /datum/gear/accessory
	path = /obj/item/clothing/accessory
	cost = 1

/datum/gear/accessory/armband
	display_name = "armband selection"
	path = /obj/item/clothing/accessory/armband

/datum/gear/accessory/armband/Initialize()
	. = ..()
	var/list/armbands = list()
	for(var/obj/item/clothing/accessory/armband_type as anything in (typesof(/obj/item/clothing/accessory/armband) - typesof(/obj/item/clothing/accessory/armband/med/color)))
		armbands[initial(armband_type.name)] = armband_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(armbands))

/datum/gear/accessory/armband/colored
	display_name = "armband"
	path = /obj/item/clothing/accessory/armband/med/color

/datum/gear/accessory/armband/colored/Initialize()
	. = ..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/accessory/wallet
	display_name = "wallet, orange"
	path = /obj/item/storage/wallet/random

/datum/gear/accessory/wallet_poly
	display_name = "wallet, polychromic"
	path = /obj/item/storage/wallet/poly
	cost = 0 //VOREStation Edit


/datum/gear/accessory/wallet/womens
	display_name = "wallet, womens"
	path = /obj/item/storage/wallet/womens
	cost = 0 //VOREStation Edit

/datum/gear/accessory/wallet/womens/Initialize()
	. = ..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/accessory/clutch
	display_name = "clutch bag"
	path = /obj/item/storage/briefcase/clutch
	cost = 2

/datum/gear/accessory/clutch/Initialize()
	. = ..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/accessory/purse
	display_name = "purse"
	path = /obj/item/storage/backpack/purse
	cost = 3

/datum/gear/accessory/purse/Initialize()
	. = ..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/accessory/wcoat
	display_name = "waistcoat selection"
	path = /obj/item/clothing/accessory/wcoat
	cost = 1

/datum/gear/accessory/wcoat/Initialize()
	. = ..()
	var/list/wcoats = list()
	for(var/obj/item/clothing/accessory/wcoat_type as anything in typesof(/obj/item/clothing/accessory/wcoat))
		wcoats[initial(wcoat_type.name)] = wcoat_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(wcoats))

/datum/gear/accessory/holster
	display_name = "holster selection (Security, CD, HoP)"
	path = /obj/item/clothing/accessory/holster
	allowed_roles = list("Site Manager", "Head of Personnel", "Security Officer", "Warden", "Head of Security","Detective")

/datum/gear/accessory/holster/Initialize()
	. = ..()
	var/list/holsters = list()
	for(var/obj/item/clothing/accessory/holster_type as anything in typesof(/obj/item/clothing/accessory/holster))
		holsters[initial(holster_type.name)] = holster_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(holsters))

/datum/gear/accessory/tie
	display_name = "tie selection"
	path = /obj/item/clothing/accessory/tie
	cost = 1

/datum/gear/accessory/tie/Initialize()
	. = ..()
	var/list/ties = list()
	for(var/obj/item/clothing/accessory/tie_type as anything in typesof(/obj/item/clothing/accessory/tie))
		ties[initial(tie_type.name)] = tie_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(ties))

/datum/gear/accessory/bowtie
	display_name = "bowtie selection"
	path = /obj/item/clothing/accessory/bowtie
	cost = 1

/datum/gear/accessory/bowtie/Initialize()
	. = ..()
	var/list/bowties = list()
	for(var/obj/item/clothing/accessory/bowtie_type as anything in typesof(/obj/item/clothing/accessory/bowtie))
		bowties[initial(bowtie_type.name)] = bowtie_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(bowties))

/datum/gear/accessory/scarf
	display_name = "scarf selection"
	path = /obj/item/clothing/accessory/scarf
	cost = 1

/datum/gear/accessory/scarf/Initialize()
	. = ..()
	var/list/scarfs = list()
	for(var/obj/item/clothing/accessory/scarf_type as anything in typesof(/obj/item/clothing/accessory/scarf))
		scarfs[initial(scarf_type.name)] = scarf_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(scarfs))

/datum/gear/accessory/scarfcolor
	display_name = "scarf (recolorable)"
	path = /obj/item/clothing/accessory/scarf/white
	cost = 1

/datum/gear/accessory/scarfcolor/Initialize()
	. = ..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/accessory/jacket
	display_name = "suit jacket selection"
	path = /obj/item/clothing/accessory/jacket
	cost = 1

/datum/gear/accessory/jacket/Initialize()
	. = ..()
	var/list/jackets = list()
	for(var/obj/item/clothing/accessory/jacket_type as anything in typesof(/obj/item/clothing/accessory/jacket))
		jackets[initial(jacket_type.name)] = jacket_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(jackets))

/datum/gear/accessory/suitvest
	display_name = "suit vest"
	path = /obj/item/clothing/accessory/vest

/datum/gear/accessory/brown_vest
	display_name = "webbing, brown"
	path = /obj/item/clothing/accessory/storage/brown_vest
	allowed_roles = list("Engineer","Atmospheric Technician","Chief Engineer","Security Officer","Detective","Head of Security","Warden","Paramedic","Chief Medical Officer","Medical Doctor", "Search and Rescue")

/datum/gear/accessory/black_vest
	display_name = "webbing, black"
	path = /obj/item/clothing/accessory/storage/black_vest
	allowed_roles = list("Engineer","Atmospheric Technician","Chief Engineer","Security Officer","Detective","Head of Security","Warden","Paramedic","Chief Medical Officer","Medical Doctor", "Search and Rescue")

/datum/gear/accessory/white_vest
	display_name = "webbing, white"
	path = /obj/item/clothing/accessory/storage/white_vest
	allowed_roles = list("Engineer","Atmospheric Technician","Chief Engineer","Security Officer","Detective","Head of Security","Warden","Paramedic","Chief Medical Officer","Medical Doctor", "Search and Rescue")

/datum/gear/accessory/brown_drop_pouches
	display_name = "drop pouches, brown"
	path = /obj/item/clothing/accessory/storage/brown_drop_pouches
	allowed_roles = list("Engineer","Atmospheric Technician","Chief Engineer","Security Officer","Detective","Head of Security","Warden","Paramedic","Chief Medical Officer","Medical Doctor", "Search and Rescue")

/datum/gear/accessory/black_drop_pouches
	display_name = "drop pouches, black"
	path = /obj/item/clothing/accessory/storage/black_drop_pouches
	allowed_roles = list("Engineer","Atmospheric Technician","Chief Engineer","Security Officer","Detective","Head of Security","Warden","Paramedic","Chief Medical Officer","Medical Doctor", "Search and Rescue")

/datum/gear/accessory/white_drop_pouches
	display_name = "drop pouches, white"
	path = /obj/item/clothing/accessory/storage/white_drop_pouches
	allowed_roles = list("Engineer","Atmospheric Technician","Chief Engineer","Security Officer","Detective","Head of Security","Warden","Paramedic","Chief Medical Officer","Medical Doctor", "Search and Rescue")

/datum/gear/accessory/fannypack
	display_name = "fannypack selection"
	cost = 2
	path = /obj/item/storage/belt/fannypack

/datum/gear/accessory/fannypack/Initialize()
	. = ..()
	var/list/fannys = list()
	for(var/obj/item/storage/belt/fannypack/fanny_type as anything in typesof(/obj/item/storage/belt/fannypack))
		fannys[initial(fanny_type.name)] = fanny_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(fannys))

/datum/gear/accessory/webbing
	display_name = "webbing, simple"
	path = /obj/item/clothing/accessory/storage/webbing
	cost = 2

/datum/gear/accessory/chaps
	display_name = "chaps, brown"
	path = /obj/item/clothing/accessory/chaps

/datum/gear/accessory/chaps/black
	display_name = "chaps, black"
	path = /obj/item/clothing/accessory/chaps/black

/datum/gear/accessory/sweater
	display_name = "sweater selection"
	path = /obj/item/clothing/accessory/sweater

/datum/gear/accessory/sweater/Initialize()
	. = ..()
	var/list/sweaters = list()
	for(var/sweater in typesof(/obj/item/clothing/accessory/sweater))
		if(sweater in typesof(/obj/item/clothing/accessory/sweater/fluff))	//VOREStation addition
			continue														//VOREStation addition
		var/obj/item/clothing/suit/sweater_type = sweater
		sweaters[initial(sweater_type.name)] = sweater_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(sweaters))

/datum/gear/accessory/virginkiller
	display_name = "virgin killer sweater (colorable)"
	path = /obj/item/clothing/accessory/sweater/virgin

/datum/gear/accessory/virginkiller/Initialize()
	. = ..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/accessory/bracelet/material
	display_name = "bracelet selection"
	description = "Choose from a number of bracelets."
	path = /obj/item/clothing/accessory/bracelet
	cost = 1

/datum/gear/accessory/bracelet/material/Initialize()
	. = ..()
	var/bracelettype = list()
	bracelettype["bracelet, steel"] = /obj/item/clothing/accessory/bracelet/material/steel
	bracelettype["bracelet, iron"] = /obj/item/clothing/accessory/bracelet/material/iron
	bracelettype["bracelet, silver"] = /obj/item/clothing/accessory/bracelet/material/silver
	bracelettype["bracelet, gold"] = /obj/item/clothing/accessory/bracelet/material/gold
	bracelettype["bracelet, platinum"] = /obj/item/clothing/accessory/bracelet/material/platinum
	bracelettype["bracelet, glass"] = /obj/item/clothing/accessory/bracelet/material/glass
	bracelettype["bracelet, wood"] = /obj/item/clothing/accessory/bracelet/material/wood
	bracelettype["bracelet, plastic"] = /obj/item/clothing/accessory/bracelet/material/plastic
	gear_tweaks += new/datum/gear_tweak/path(bracelettype)

/datum/gear/accessory/bracelet/friendship
	display_name = "friendship bracelet"
	path = /obj/item/clothing/accessory/bracelet/friendship

/datum/gear/accessory/stethoscope
	display_name = "stethoscope"
	path = /obj/item/clothing/accessory/stethoscope
	allowed_roles = list("Chief Medical Officer","Medical Doctor","Chemist","Psychiatrist","Paramedic", "Search and Rescue")

/datum/gear/accessory/locket
	display_name = "locket"
	path = /obj/item/clothing/accessory/locket

/datum/gear/accessory/halfcape
	display_name = "half cape"
	path = /obj/item/clothing/accessory/halfcape

/datum/gear/accessory/fullcape
	display_name = "full cape"
	path = /obj/item/clothing/accessory/fullcape

/datum/gear/accessory/sash
	display_name = "sash (colorable)"
	path = /obj/item/clothing/accessory/sash

/datum/gear/accessory/sash/Initialize()
	. = ..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/accessory/asym
	display_name = "asymmetric jacket selection"
	path = /obj/item/clothing/accessory/asymmetric
	cost = 1

/datum/gear/accessory/asym/Initialize()
	. = ..()
	var/list/asyms = list()
	for(var/obj/item/clothing/accessory/asymmetric_type as anything in typesof(/obj/item/clothing/accessory/asymmetric))
		asyms[initial(asymmetric_type.name)] = asymmetric_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(asyms))

/datum/gear/accessory/cowledvest
	display_name = "cowled vest"
	path = /obj/item/clothing/accessory/cowledvest

/datum/gear/accessory/asymovercoat
	display_name = "orange asymmetrical overcoat"
	path = /obj/item/clothing/accessory/asymovercoat

/datum/gear/accessory/hawaiian_shirt
	display_name = "hawaiian shirt selection"
	path = /obj/item/clothing/accessory/hawaiian

/datum/gear/accessory/hawaiian_shirt/Initialize()
	. = ..()
	var/list/hawaiian_shirts = list(
	"Cyan Hawaiian shirt" = /obj/item/clothing/accessory/hawaiian,
	"Blue Hawaiian shirt" = /obj/item/clothing/accessory/hawaiian/blue,
	"Pink Hawaiian shirt" = /obj/item/clothing/accessory/hawaiian/pink,
	"Red Hawaiian shirt" = /obj/item/clothing/accessory/hawaiian/red,
	"Yellow Hawaiian shirt" = /obj/item/clothing/accessory/hawaiian/yellow
	)
	gear_tweaks += new/datum/gear_tweak/path(hawaiian_shirts)

/datum/gear/accessory/cowboy_vest
	display_name = "cowboy selection"
	path = /obj/item/clothing/accessory/cowboy_vest

/datum/gear/accessory/cowboy_vest/Initialize()
	. = ..()
	var/list/cowboy_vests = list(
	"Ranger Vest" = /obj/item/clothing/accessory/cowboy_vest,
	"Brown Vest" = /obj/item/clothing/accessory/cowboy_vest/brown,
	"Grey Vest" = /obj/item/clothing/accessory/cowboy_vest/grey
	)
	gear_tweaks += new/datum/gear_tweak/path(cowboy_vests)

/datum/gear/accessory/pride
	display_name = "pride pin selection"
	path = /obj/item/clothing/accessory/pride

/datum/gear/accessory/pride/Initialize()
	. = ..()
	var/list/pridepins = list()
	for(var/obj/item/clothing/accessory/pridepin_type as anything in typesof(/obj/item/clothing/accessory/pride))
		pridepins[initial(pridepin_type.name)] = pridepin_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(pridepins))

/datum/gear/accessory/badge
	display_name = "sheriff badge (Security)"
	path = /obj/item/clothing/accessory/badge/holo/sheriff
	allowed_roles = list("Security Officer","Detective","Head of Security","Warden")

/datum/gear/accessory/corpbadge
	display_name = "investigator holobadge (IAA)"
	path = /obj/item/clothing/accessory/badge/holo/investigator
	allowed_roles = list("Internal affairs agent")

/datum/gear/accessory/pressbadge
	display_name = "corporate press pass"
	path = /obj/item/clothing/accessory/badge/press

/datum/gear/accessory/pressbadge
	display_name = "freelance press pass"
	path = /obj/item/clothing/accessory/badge/press/independent
