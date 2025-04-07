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

/datum/gear/accessory/armband/New()
	..()
	var/list/armbands = list()
	for(var/obj/item/clothing/accessory/armband_type as anything in (typesof(/obj/item/clothing/accessory/armband) - typesof(/obj/item/clothing/accessory/armband/med/color)))
		armbands[initial(armband_type.name)] = armband_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(armbands))

/datum/gear/accessory/armband/colored
	display_name = "armband"
	path = /obj/item/clothing/accessory/armband/med/color

/datum/gear/accessory/armband/colored/New()
	..()
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

/datum/gear/accessory/wallet/womens/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/accessory/clutch
	display_name = "clutch bag"
	path = /obj/item/storage/briefcase/clutch
	cost = 2

/datum/gear/accessory/clutch/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/accessory/purse
	display_name = "purse"
	path = /obj/item/storage/backpack/purse
	cost = 3

/datum/gear/accessory/purse/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/accessory/wcoat
	display_name = "waistcoat selection"
	path = /obj/item/clothing/accessory/wcoat
	cost = 1

/datum/gear/accessory/wcoat/New()
	..()
	var/list/wcoats = list()
	for(var/obj/item/clothing/accessory/wcoat_type as anything in typesof(/obj/item/clothing/accessory/wcoat))
		wcoats[initial(wcoat_type.name)] = wcoat_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(wcoats))

/datum/gear/accessory/holster
	display_name = "holster selection"
	description = "Select from a number of general-purpose handgun holsters, or a baton lanyard."
	path = /obj/item/clothing/accessory/holster
	allowed_roles = list(JOB_SITE_MANAGER, JOB_HEAD_OF_PERSONNEL, JOB_SECURITY_OFFICER, JOB_WARDEN, JOB_HEAD_OF_SECURITY,JOB_DETECTIVE,JOB_TALON_CAPTAIN,JOB_TALON_GUARD)

/datum/gear/accessory/holster/New()
	..()
	var/list/selector_holsters = list(
		"holster"=/obj/item/clothing/accessory/holster,
		"armpit holster, brown"=/obj/item/clothing/accessory/holster/armpit,
		"armpit holster, black"=/obj/item/clothing/accessory/holster/armpit/black,
		"waist holster, brown"=/obj/item/clothing/accessory/holster/waist,
		"waist holster, black"=/obj/item/clothing/accessory/holster/waist/black,
		"hip holster, brown"=/obj/item/clothing/accessory/holster/hip,
		"hip holster, black"=/obj/item/clothing/accessory/holster/hip/black,
		"leg holster, brown"=/obj/item/clothing/accessory/holster/leg,
		"leg holster, black"=/obj/item/clothing/accessory/holster/leg/black,
		"baton lanyard"=/obj/item/clothing/accessory/holster/waist/lanyard
	)
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(selector_holsters))

/datum/gear/accessory/tie
	display_name = "tie selection"
	path = /obj/item/clothing/accessory/tie
	cost = 1

/datum/gear/accessory/tie/New()
	..()
	var/list/ties = list()
	for(var/obj/item/clothing/accessory/tie_type as anything in typesof(/obj/item/clothing/accessory/tie))
		ties[initial(tie_type.name)] = tie_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(ties))

/datum/gear/accessory/bowtie
	display_name = "bowtie selection"
	path = /obj/item/clothing/accessory/bowtie
	cost = 1

/datum/gear/accessory/bowtie/New()
	..()
	var/list/bowties = list()
	for(var/obj/item/clothing/accessory/bowtie_type as anything in typesof(/obj/item/clothing/accessory/bowtie))
		bowties[initial(bowtie_type.name)] = bowtie_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(bowties))

/datum/gear/accessory/scarf
	display_name = "scarf selection"
	path = /obj/item/clothing/accessory/scarf
	cost = 1

/datum/gear/accessory/scarf/New()
	..()
	var/list/scarfs = list()
	for(var/obj/item/clothing/accessory/scarf_type as anything in typesof(/obj/item/clothing/accessory/scarf))
		scarfs[initial(scarf_type.name)] = scarf_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(scarfs))

/datum/gear/accessory/scarfcolor
	display_name = "scarf (recolorable)"
	path = /obj/item/clothing/accessory/scarf/white
	cost = 1

/datum/gear/accessory/scarfcolor/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/accessory/jacket
	display_name = "suit jacket selection"
	path = /obj/item/clothing/accessory/jacket
	cost = 1

/datum/gear/accessory/jacket/New()
	..()
	var/list/jackets = list()
	for(var/obj/item/clothing/accessory/jacket_type as anything in typesof(/obj/item/clothing/accessory/jacket))
		jackets[initial(jacket_type.name)] = jacket_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(jackets))

/datum/gear/accessory/suitvest
	display_name = "suit vest"
	path = /obj/item/clothing/accessory/vest

/datum/gear/accessory/webbing
	display_name = "webbing, simple"
	path = /obj/item/clothing/accessory/storage/webbing
	cost = 1

/datum/gear/accessory/webbing_selector
	display_name = "webbing selector"
	description = "Select from a number of load-bearing webbings and vests. Includes the bluespace badge."
	path = /obj/item/clothing/accessory/storage/bluespace
	cost = 2

/datum/gear/accessory/webbing_selector/New()
	..()
	var/list/selector_loadbearinggear = list(
		"webbing vest, brown"=/obj/item/clothing/accessory/storage/brown_vest,
		"webbing vest, black"=/obj/item/clothing/accessory/storage/black_vest,
		"webbing vest, white"=/obj/item/clothing/accessory/storage/white_vest,
		"drop pouches, brown"=/obj/item/clothing/accessory/storage/brown_drop_pouches,
		"drop pouches, black"=/obj/item/clothing/accessory/storage/black_drop_pouches,
		"drop pouches, white"=/obj/item/clothing/accessory/storage/white_drop_pouches,
		"bluespace badge"=/obj/item/clothing/accessory/storage/bluespace,
		"pilot's harness"=/obj/item/clothing/accessory/storage/webbing/pilot1,
		"pilot's harness, alt"=/obj/item/clothing/accessory/storage/webbing/pilot2
	)
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(selector_loadbearinggear))

/datum/gear/accessory/fannypack
	display_name = "fannypack selection"
	cost = 2
	path = /obj/item/storage/belt/fannypack

/datum/gear/accessory/fannypack/New()
	..()
	var/list/fannys = list()
	for(var/obj/item/storage/belt/fannypack/fanny_type as anything in typesof(/obj/item/storage/belt/fannypack))
		fannys[initial(fanny_type.name)] = fanny_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(fannys))

/datum/gear/accessory/chaps
	display_name = "chaps, brown"
	path = /obj/item/clothing/accessory/chaps

/datum/gear/accessory/chaps/black
	display_name = "chaps, black"
	path = /obj/item/clothing/accessory/chaps/black

/datum/gear/accessory/sweater
	display_name = "sweater selection"
	path = /obj/item/clothing/accessory/sweater

/datum/gear/accessory/sweater/New()
	..()
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

/datum/gear/accessory/virginkiller/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/accessory/bracelet/material
	display_name = "bracelet selection"
	description = "Choose from a number of bracelets."
	path = /obj/item/clothing/accessory/bracelet
	cost = 1

/datum/gear/accessory/bracelet/material/New()
	..()
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
	allowed_roles = list(JOB_CHIEF_MEDICAL_OFFICER,JOB_MEDICAL_DOCTOR,JOB_CHEMIST,JOB_PSYCHIATRIST,JOB_PARAMEDIC,JOB_TALON_DOCTOR)

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

/datum/gear/accessory/sash/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/accessory/asym
	display_name = "asymmetric jacket selection"
	path = /obj/item/clothing/accessory/asymmetric
	cost = 1

/datum/gear/accessory/asym/New()
	..()
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

/datum/gear/accessory/hawaiian_shirt/New()
	..()
	var/list/hawaiian_shirts = list(
	"Cyan Hawaiian shirt" = /obj/item/clothing/accessory/hawaiian,
	"Blue Hawaiian shirt" = /obj/item/clothing/accessory/hawaiian/blue,
	"Pink Hawaiian shirt" = /obj/item/clothing/accessory/hawaiian/pink,
	"Red Hawaiian shirt" = /obj/item/clothing/accessory/hawaiian/red,
	"Yellow Hawaiian shirt" = /obj/item/clothing/accessory/hawaiian/yellow
	)
	gear_tweaks += new/datum/gear_tweak/path(hawaiian_shirts)

/datum/gear/accessory/cowboy_vest
	display_name = "cowboy vest selection"
	path = /obj/item/clothing/accessory/cowboy_vest

/datum/gear/accessory/cowboy_vest/New()
	..()
	var/list/cowboy_vests = list(
	"Ranger Vest" = /obj/item/clothing/accessory/cowboy_vest,
	"Brown Vest" = /obj/item/clothing/accessory/cowboy_vest/brown,
	"Grey Vest" = /obj/item/clothing/accessory/cowboy_vest/grey
	)
	gear_tweaks += new/datum/gear_tweak/path(cowboy_vests)

/datum/gear/accessory/pride
	display_name = "pride pin selection"
	path = /obj/item/clothing/accessory/pride

/datum/gear/accessory/pride/New()
	..()
	var/list/pridepins = list()
	for(var/pridepin in typesof(/obj/item/clothing/accessory/pride))
		var/obj/item/clothing/accessory/pridepin_type = pridepin
		pridepins[initial(pridepin_type.name)] = pridepin_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(pridepins))

/datum/gear/accessory/badge
	display_name = "sheriff badge (Security)"
	path = /obj/item/clothing/accessory/badge/holo/sheriff
	allowed_roles = list(JOB_SECURITY_OFFICER,JOB_DETECTIVE,JOB_HEAD_OF_SECURITY,JOB_WARDEN)

/datum/gear/accessory/corpbadge
	display_name = "investigator holobadge (IAA)"
	path = /obj/item/clothing/accessory/badge/holo/investigator
	allowed_roles = list(JOB_INTERNAL_AFFAIRS_AGENT)

/datum/gear/accessory/pressbadge
	display_name = "corporate press pass"
	path = /obj/item/clothing/accessory/badge/press

/datum/gear/accessory/pressbadge_freelance
	display_name = "freelance press pass"
	path = /obj/item/clothing/accessory/badge/press/independent

/datum/gear/accessory/wristband
	display_name = "wristband (recolourable)"
	path = /obj/item/clothing/accessory/wristband

/datum/gear/accessory/wristband/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/accessory/wristband_collection
	display_name = "wristbands (selection)"
	path = /obj/item/clothing/accessory/wristband/collection

/datum/gear/accessory/wristband_collection/New()
	..()
	var/list/wristband_lists = list(
	"Green, Blue and Yellow" = /obj/item/clothing/accessory/wristband/collection,
	"Pink, Black and Red" = /obj/item/clothing/accessory/wristband/collection/pink,
	"Red and Orange" = /obj/item/clothing/accessory/wristband/collection/les,
	"White, Pink and Blue" = /obj/item/clothing/accessory/wristband/collection/trans,
	"Blue, Purple and Pink" = /obj/item/clothing/accessory/wristband/collection/bi,
	"Black, White and Grey" = /obj/item/clothing/accessory/wristband/collection/ace,
	"Spiked" = /obj/item/clothing/accessory/wristband/spiked
	)
	gear_tweaks += new/datum/gear_tweak/path(wristband_lists)

// Collars

/datum/gear/choker //A colorable choker
	display_name = "choker (colorable, tagless)"
	path = /obj/item/clothing/accessory/choker
	slot = slot_tie
	sort_category = "Accessories"

/datum/gear/choker/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/collar
	display_name = "collar, silver"
	path = /obj/item/clothing/accessory/collar/silver
	slot = slot_tie
	sort_category = "Accessories"

/datum/gear/collar/New()
	..()
	gear_tweaks += gear_tweak_collar_tag

/datum/gear/collar/golden
	display_name = "collar, golden"
	path = /obj/item/clothing/accessory/collar/gold

/datum/gear/collar/bell
	display_name = "collar, bell"
	path = /obj/item/clothing/accessory/collar/bell

/datum/gear/collar/shock
	display_name = "collar, shock"
	path = /obj/item/clothing/accessory/collar/shock

/datum/gear/collar/spike
	display_name = "collar, spike"
	path = /obj/item/clothing/accessory/collar/spike

/datum/gear/collar/pink
	display_name = "collar, pink"
	path = /obj/item/clothing/accessory/collar/pink

/datum/gear/collar/cowbell
	display_name = "collar, cowbell"
	path = /obj/item/clothing/accessory/collar/cowbell

/datum/gear/collar/planet_earth
	display_name = "collar, planet"
	path = /obj/item/clothing/accessory/collar/collarplanet_earth

/datum/gear/collar/holo
	display_name = "collar, holo"
	path = /obj/item/clothing/accessory/collar/holo

/datum/gear/collar/holo/indigestible
	display_name = "collar, holo (indigestible)"
	path = /obj/item/clothing/accessory/collar/holo/indigestible

/datum/gear/accessory/khcrystal
	display_name = "KH Life Crystal"
	path = /obj/item/storage/box/khcrystal
	description = "A small necklace device that will notify an offsite cloning facility should you expire after activating it."

/datum/gear/accessory/tronket
	display_name = "metal necklace"
	description = "A shiny steel chain with a vague metallic object dangling off it."
	path = /obj/item/clothing/accessory/tronket

/datum/gear/accessory/pilotpin
	display_name = "pilot qualification pin"
	description = "An iron pin denoting the qualification to fly spacecraft in most areas of civilized space."
	path = /obj/item/clothing/accessory/solgov/specialty/pilot

/datum/gear/accessory/flops
	display_name = "drop straps"
	description = "Wearing suspenders over shoulders? That's been so out for centuries and you know better."
	path = /obj/item/clothing/accessory/flops

/datum/gear/accessory/flops/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/accessory/dosimeter
	display_name = "Dosimeter"
	path = /obj/item/storage/box/dosimeter
	description = "A small device that will warn the bearer when they are exposed to dangerous levels of radiation."

/*
Talon pin
*/
/datum/gear/accessory/talonpin
	display_name = "Talon pin"
	description = "A small enamel pin of the Talon logo."
	path = /obj/item/clothing/accessory/talon

//Rat badge

/datum/gear/accessory/altevian_badge
	display_name = "altevian badge"
	path = /obj/item/clothing/accessory/altevian_badge

/datum/gear/accessory/maid_neck
	display_name = "maid neck cover"
	path = /obj/item/clothing/accessory/maid_neck

/datum/gear/accessory/maid_corset
	display_name = "maid corset"
	path = /obj/item/clothing/accessory/maidcorset

//Antediluvian accessories
/datum/gear/accessory/antediluvian
	display_name = "antediluvian bracers"
	path = /obj/item/clothing/accessory/antediluvian

/datum/gear/accessory/antediluvian/loin
	display_name = "antediluvian loincloth"
	path = /obj/item/clothing/accessory/antediluvian/loincloth

//Replikant accessories

/datum/gear/accessory/sleekpatch
	display_name = "sleek uniform patch"
	path = /obj/item/clothing/accessory/sleekpatch

/datum/gear/accessory/poncho/roles/cloak/custom/gestaltjacket
	display_name = "sleek uniform jacket"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/custom/gestaltjacket

/datum/gear/accessory/replika
	display_name = "replikant vest selection"
	path = /obj/item/clothing/accessory/replika

/datum/gear/accessory/replika/New()
	..()
	var/list/replika_vests = list(
	"controller replikant chestplate" = /obj/item/clothing/accessory/replika/klbr,
	"combat-engineer replikant chestplate" = /obj/item/clothing/accessory/replika/lstr,
	"security-controller replikant chestplate" = /obj/item/clothing/accessory/replika/stcr,
	"security-technician replikant chestplate" = /obj/item/clothing/accessory/replika/star
	)
	gear_tweaks += new/datum/gear_tweak/path(replika_vests)

/datum/gear/accessory/insignia
	display_name = "Insignia Selection"
	path = /obj/item/clothing/accessory/solgov/department

/datum/gear/accessory/insignia/New()
	..()
	var/insignia = list(
	"Command - Crew" = /obj/item/clothing/accessory/solgov/department/command,
	"Command - Crew Short" = /obj/item/clothing/accessory/solgov/department/command/service,
	"Command - Bands" = /obj/item/clothing/accessory/solgov/department/command/fleet,
	"Command - Echelons" = /obj/item/clothing/accessory/solgov/department/command/army,
	"Security - Crew" = /obj/item/clothing/accessory/solgov/department/security,
	"Security - Crew Short" = /obj/item/clothing/accessory/solgov/department/security/service,
	"Security - Bands" = /obj/item/clothing/accessory/solgov/department/security/fleet,
	"Security - Echelons" = /obj/item/clothing/accessory/solgov/department/security/army,
	"Medical - Crew" = /obj/item/clothing/accessory/solgov/department/medical,
	"Medical - Crew Short" = /obj/item/clothing/accessory/solgov/department/medical/service,
	"Medical - Bands" = /obj/item/clothing/accessory/solgov/department/medical/fleet,
	"Medical - Echelons" = /obj/item/clothing/accessory/solgov/department/medical/army,
	"Science - Crew" = /obj/item/clothing/accessory/solgov/department/research,
	"Science - Crew Short" = /obj/item/clothing/accessory/solgov/department/research/service,
	"Science - Bands" = /obj/item/clothing/accessory/solgov/department/research/fleet,
	"Science - Echelons" = /obj/item/clothing/accessory/solgov/department/research/army,
	"Engineering - Crew" = /obj/item/clothing/accessory/solgov/department/engineering,
	"Engineering - Crew Short" = /obj/item/clothing/accessory/solgov/department/engineering/service,
	"Engineering - Bands" = /obj/item/clothing/accessory/solgov/department/engineering/fleet,
	"Engineering - Echelons" = /obj/item/clothing/accessory/solgov/department/engineering/army,
	"Supply - Crew" = /obj/item/clothing/accessory/solgov/department/supply,
	"Supply - Crew Short" = /obj/item/clothing/accessory/solgov/department/supply/service,
	"Supply - Bands" = /obj/item/clothing/accessory/solgov/department/supply/fleet,
	"Supply - Echelons" = /obj/item/clothing/accessory/solgov/department/supply/army,
	"Service - Crew" = /obj/item/clothing/accessory/solgov/department/service,
	"Service - Crew Short" = /obj/item/clothing/accessory/solgov/department/service/service,
	"Service - Bands" = /obj/item/clothing/accessory/solgov/department/service/fleet,
	"Service - Echelons" = /obj/item/clothing/accessory/solgov/department/service/army
	)
	gear_tweaks += new/datum/gear_tweak/path(insignia)

/datum/gear/accessory/belt_selection
	display_name = "belts (selection, colorable)"
	path = /obj/item/clothing/accessory/belt

/datum/gear/accessory/belt_selection/New()
	..()
	var/list/wristband_lists = list(
	"Thin Belt" = /obj/item/clothing/accessory/belt,
	"Thick Belt" = /obj/item/clothing/accessory/belt/thick,
	"Strap Belt" = /obj/item/clothing/accessory/belt/strap,
	"Studded Belt" = /obj/item/clothing/accessory/belt/studded
	)
	gear_tweaks += new/datum/gear_tweak/path(wristband_lists)
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/accessory/bunny_tail
	display_name = "bunny tail, colorable"
	path = /obj/item/clothing/accessory/bunny_tail

/datum/gear/accessory/bunny_tail/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/accessory/legwarmer_selection
	display_name = "legwarmers (selection, colorable)"
	path = /obj/item/clothing/accessory/legwarmers

/datum/gear/accessory/legwarmer_selection/New()
	..()
	var/list/legwarmer_lists = list(
	"Legwarmers, thigh" = /obj/item/clothing/accessory/legwarmers,
	"Legwarmers, medium" = /obj/item/clothing/accessory/legwarmersmedium,
	"Legwarmers, short" = /obj/item/clothing/accessory/legwarmersshort
	)
	gear_tweaks += new/datum/gear_tweak/path(legwarmer_lists)
	gear_tweaks += gear_tweak_free_color_choice
