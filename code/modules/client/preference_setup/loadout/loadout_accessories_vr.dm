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

/datum/gear/accessory/holster
	display_name = "holster selection (Security, SM, HoP)"
	allowed_roles = list("Site Manager", "Head of Personnel", "Security Officer", "Warden", "Head of Security","Detective","Talon Captain","Talon Guard")

/datum/gear/accessory/brown_vest
	display_name = "webbing, brown (Eng, Sec, Med, Miner)"
	allowed_roles = list("Engineer","Atmospheric Technician","Chief Engineer","Security Officer","Detective","Head of Security","Warden","Paramedic","Chief Medical Officer","Medical Doctor","Chemist","Shaft Miner","Talon Captain","Talon Doctor","Talon Engineer","Talon Guard", "Talon Miner")

/datum/gear/accessory/black_vest
	display_name = "webbing, black (Eng, Sec, Med, Miner)"
	allowed_roles = list("Engineer","Atmospheric Technician","Chief Engineer","Security Officer","Detective","Head of Security","Warden","Paramedic","Chief Medical Officer","Medical Doctor","Chemist","Shaft Miner","Talon Captain","Talon Doctor","Talon Engineer","Talon Guard", "Talon Miner")

/datum/gear/accessory/white_vest
	display_name = "webbing, white (Medical)"
	allowed_roles = list("Paramedic","Chief Medical Officer","Medical Doctor","Chemist","Talon Doctor")

/datum/gear/accessory/brown_drop_pouches
	display_name = "drop pouches, brown (Eng, Sec, Med, Miner)"
	allowed_roles = list("Engineer","Atmospheric Technician","Chief Engineer","Security Officer","Detective","Head of Security","Warden","Paramedic","Chief Medical Officer","Medical Doctor","Chemist","Shaft Miner","Talon Captain","Talon Doctor","Talon Engineer","Talon Guard", "Talon Miner")

/datum/gear/accessory/black_drop_pouches
	display_name = "drop pouches, black (Eng, Sec, Med, Miner)"
	allowed_roles = list("Engineer","Atmospheric Technician","Chief Engineer","Security Officer","Detective","Head of Security","Warden","Paramedic","Chief Medical Officer","Medical Doctor","Chemist","Shaft Miner","Talon Captain","Talon Doctor","Talon Engineer","Talon Guard", "Talon Miner")

/datum/gear/accessory/white_drop_pouches
	display_name = "drop pouches, white (Medical)"
	allowed_roles = list("Paramedic","Chief Medical Officer","Medical Doctor","Chemist","Talon Doctor")

/datum/gear/accessory/bluespace
	display_name = "bluespace badge (Eng, Sec, Med, Miner, Pilot)"
	path = /obj/item/clothing/accessory/storage/bluespace
	allowed_roles = list("Engineer","Atmospheric Technician","Chief Engineer","Security Officer","Detective","Head of Security","Warden","Paramedic","Chief Medical Officer","Medical Doctor","Chemist","Shaft Miner","Talon Captain","Talon Doctor","Talon Engineer","Talon Guard","Talon Miner","Pilot")
	cost = 2

/datum/gear/accessory/webbing
	cost = 1

/datum/gear/accessory/stethoscope
	allowed_roles = list("Chief Medical Officer","Medical Doctor","Chemist","Psychiatrist","Paramedic","Talon Doctor")

/datum/gear/accessory/khcrystal
	display_name = "KH Life Crystal"
	path = /obj/item/weapon/storage/box/khcrystal
	description = "A small necklace device that will notify an offsite cloning facility should you expire after activating it."

/datum/gear/accessory/tronket
	display_name = "metal necklace"
	description = "A shiny steel chain with a vague metallic object dangling off it."
	path = /obj/item/clothing/accessory/tronket

/datum/gear/accessory/pilotpin
	display_name = "pilot qualification pin"
	description = "An iron pin denoting the qualification to fly SCG spacecraft."
	path = /obj/item/clothing/accessory/solgov/specialty/pilot
	allowed_roles = list("Pilot","Talon Pilot")

/datum/gear/accessory/flops
	display_name = "drop straps"
	description = "Wearing suspenders over shoulders? That's been so out for centuries and you know better."
	path = /obj/item/clothing/accessory/flops

/datum/gear/accessory/flops/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/accessory/dosimeter
	display_name = "Dosimeter"
	path = /obj/item/weapon/storage/box/dosimeter
	description = "A small device that will display dangerous levels of radiation."

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
