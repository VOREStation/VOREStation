/datum/gear/suit/snowsuit/medical
	allowed_roles = list("Medical Doctor","Chief Medical Officer","Chemist","Paramedic","Geneticist", "Psychiatrist")

/datum/gear/suit/labcoat_colorable
	display_name = "labcoat, colorable"
	path = /obj/item/clothing/suit/storage/toggle/labcoat

/datum/gear/suit/labcoat_colorable/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/suit/labcoat_old
	display_name = "labcoat, old-school"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/old

/datum/gear/suit/labcoat_cmo_old
	display_name = "labcoat, CMO, oldschool"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/old/cmo
	allowed_roles = list("Chief Medical Officer")

/datum/gear/suit/roles/labcoat_old
	display_name = "labcoat selection, department, oldschool"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/old/tox
	cost = 2

/datum/gear/suit/roles/labcoat_old/New()
	..()
	var/list/labcoats = list(
	"Oldschool Scientist's Labcoat" = /obj/item/clothing/suit/storage/toggle/labcoat/old/tox,
	"Oldschool Virologist's Labcoat" = /obj/item/clothing/suit/storage/toggle/labcoat/old/vir,
	"Oldschool Chemist's Labcoat" = /obj/item/clothing/suit/storage/toggle/labcoat/old/chem
	)
	gear_tweaks += new/datum/gear_tweak/path(labcoats)

/datum/gear/suit/jacket_modular
	display_name = "jacket, modular"
	path = /obj/item/clothing/suit/storage/fluff/jacket

/datum/gear/suit/jacket_modular/New()
	..()
	var/list/the_jackets = list()
	for(var/the_jacket in typesof(/obj/item/clothing/suit/storage/fluff/jacket))
		var/obj/item/clothing/suit/jacket_type = the_jacket
		the_jackets[initial(jacket_type.name)] = jacket_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(the_jackets))

/datum/gear/suit/gntop
	display_name = "GN crop jacket"
	path = /obj/item/clothing/suit/storage/fluff/gntop

/datum/gear/suit/old_poncho //This is made from an old sprite which has been here for quite some time. Called old poncho because duplicates
	display_name = "Colorful poncho"
	description = "A Mexican looking poncho. It look like it fits wolf taurs as well."
	path = /obj/item/clothing/suit/poncho

//Detective alternative
/datum/gear/suit/detective_alt
	display_name = "sleek modern coat selection"
	path = /obj/item/clothing/suit/storage/det_trench/alt
	allowed_roles = list(JOB_HEAD_OF_SECURITY, JOB_DETECTIVE)

/datum/gear/suit/detective_alt/New()
	..()
	var/list/coats = list(
		"Modern coat (tan)" = /obj/item/clothing/suit/storage/det_trench/alt,
		"Modern coat (long, tan)" = /obj/item/clothing/suit/storage/det_trench/alt2,
		"Modern coat (black)" = /obj/item/clothing/suit/storage/det_trench/alt/black,
		"Modern coat (long, black)" = /obj/item/clothing/suit/storage/det_trench/alt2/black
	)
	gear_tweaks += new/datum/gear_tweak/path(coats)

//EMT coats, jackets and vest
/datum/gear/suit/paramedic_coat
	display_name = "paramedic outerwear selection"
	path = /obj/item/clothing/suit/storage/toggle/fr_jacket
	allowed_roles = list("Chief Medical Officer","Paramedic","Medical Doctor")

/datum/gear/suit/paramedic_coat/New()
	..()
	var/list/paramedicCoats = list(
		"First responder jacket" = /obj/item/clothing/suit/storage/toggle/fr_jacket,
		"First responder jacket, alt." = /obj/item/clothing/suit/storage/toggle/fr_jacket/ems,
		"Paramedic vest" = /obj/item/clothing/suit/storage/toggle/paramedic,
		"EMT's labcoat" = /obj/item/clothing/suit/storage/toggle/labcoat/neo_emt,
		"High visibility jacket" = /obj/item/clothing/suit/storage/toggle/labcoat/neo_highvis,
		"Red EMT jacket" = /obj/item/clothing/suit/storage/toggle/labcoat/neo_redemt,
		"Dark Blue EMT jacket" = /obj/item/clothing/suit/storage/toggle/labcoat/neo_blueemt
	)
	gear_tweaks += new/datum/gear_tweak/path(paramedicCoats)

//greek thing
/datum/gear/suit/chiton
	display_name = "chiton"
	path = /obj/item/clothing/suit/chiton

//oversized t-shirt
/datum/gear/suit/oversize
	display_name = "oversized t-shirt (colorable)"
	path = /obj/item/clothing/suit/oversize

/datum/gear/suit/oversize/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/*
Talon winter coat
*/
/datum/gear/suit/wintercoat/talon
	display_name = "winter coat, Talon"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/talon

/datum/gear/suit/armor/combat/crusader_explo
	display_name = "knight, explo"
	path = /obj/item/clothing/suit/armor/combat/crusader_explo
	//allowed_roles = list("Explorer","Pathfinder")

/datum/gear/suit/armor/combat/crusader_explo/FM
	display_name = "knight, Field Medic"
	path = /obj/item/clothing/suit/armor/combat/crusader_explo/FM
	allowed_roles = list ("Paramedic")

//Long fur coat
/datum/gear/suit/russofurcoat
	display_name = "long fur coat"
	path = /obj/item/clothing/suit/storage/vest/hoscoat/russofurcoat

//Colorable Hoodie
/datum/gear/suit/hoodie_vr
	display_name = "hoodie with hood (colorable)"
	path = /obj/item/clothing/suit/storage/hooded/hoodie

/datum/gear/suit/hoodie_vr/New()
	..()
	var/list/hoodies = list()
	for(var/hoodie_style in typesof(/obj/item/clothing/suit/storage/hooded/hoodie))
		var/obj/item/clothing/suit/storage/toggle/hoodie/hoodie = hoodie_style
		hoodies[initial(hoodie.name)] = hoodie
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(hoodies))
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/suit/cyberpunk_recolorable
	display_name = "cyberpunk jacket (recolorable)"
	path = /obj/item/clothing/suit/cyberpunk/recolorable
	cost = 2 //It's got armor, yo.

/datum/gear/suit/cyberpunk_recolorable/New()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/suit/shrine_maiden
	display_name = "shrine maiden costume"
	path = /obj/item/clothing/suit/shrine_maiden

//Antediluvian cloak
/datum/gear/suit/cloak_ante
	display_name = "cloak, antediluvian"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/antediluvian
	cost = 1

//Chaplain cloaks
/datum/gear/suit/cloak_chaplain
	display_name = "cloak, chaplain"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/chapel
	cost = 1

/datum/gear/suit/cloak_chaplain/alt
	display_name = "cloak, chaplain, alt"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/chapel/alt
	cost = 1

//Half cloak
/datum/gear/suit/cloak_half
	display_name = "cloak, half, colorable"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/half
	cost = 1

/datum/gear/suit/cloak_half/New()
	gear_tweaks += gear_tweak_free_color_choice

//Shoulder cloak
/datum/gear/suit/cloak_shoulder
	display_name = "cloak, shoulder"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/shoulder
	cost = 1

/datum/gear/suit/cloak_shoulder/New()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/suit/cloak_shoulder_right
	display_name = "cloak, shoulder right"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/shoulder/right
	cost = 1

/datum/gear/suit/cloak_shoulder_right/New()
	gear_tweaks += gear_tweak_free_color_choice

//Mantles, mostly for heads of staff
/datum/gear/suit/roles/mantle
	display_name = "mantle, colorable"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/mantle
	cost = 1

/datum/gear/suit/roles/mantle/New()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/suit/roles/mantles
	display_name = "mantle selection"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/mantle/cargo
	cost = 1

/datum/gear/suit/roles/mantles/New()
	..()
	var/list/mantles = list(
		"orange mantle"=/obj/item/clothing/accessory/poncho/roles/cloak/mantle/cargo,
		"black mantle"=/obj/item/clothing/accessory/poncho/roles/cloak/mantle/security,
		"white mantle"=/obj/item/clothing/accessory/poncho/roles/cloak/mantle/engineering,
		"purple mantle"=/obj/item/clothing/accessory/poncho/roles/cloak/mantle/research,
		"cyan mantle"=/obj/item/clothing/accessory/poncho/roles/cloak/mantle/medical,
		"blue mantle"=/obj/item/clothing/accessory/poncho/roles/cloak/mantle/hop,
		"gold mantle"=/obj/item/clothing/accessory/poncho/roles/cloak/mantle/cap
	)
	gear_tweaks += new/datum/gear_tweak/path(mantles)

//Boat cloaks
/datum/gear/suit/roles/boatcloak
	display_name = "boat cloak, colorable"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/boat

/datum/gear/suit/roles/boatcloak/New()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/suit/roles/capboatcloak
	display_name = "boat cloak, site manager"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/boat/cap
	allowed_roles = list(JOB_SITE_MANAGER)
	show_roles = FALSE

/datum/gear/suit/roles/hopboatcloak
	display_name = "boat cloak, head of personnel"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/boat/hop
	allowed_roles = list(JOB_HEAD_OF_PERSONNEL)
	show_roles = FALSE

/datum/gear/suit/roles/boatcloaks
	display_name = "boat cloak selection"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/boat/security

/datum/gear/suit/roles/boatcloaks/New()
	..()
	var/list/boatcloaks = list(
		"security boat cloak"=/obj/item/clothing/accessory/poncho/roles/cloak/boat/security,
		"engineering boat cloak"=/obj/item/clothing/accessory/poncho/roles/cloak/boat/engineering,
		"atmospherics boat cloak"=/obj/item/clothing/accessory/poncho/roles/cloak/boat/atmos,
		"medical boat cloak"=/obj/item/clothing/accessory/poncho/roles/cloak/boat/medical,
		"service boat cloak"=/obj/item/clothing/accessory/poncho/roles/cloak/boat/service,
		"cargo boat cloak"=/obj/item/clothing/accessory/poncho/roles/cloak/boat/cargo,
		"mining boat cloak"=/obj/item/clothing/accessory/poncho/roles/cloak/boat/mining,
		"research boat cloak"=/obj/item/clothing/accessory/poncho/roles/cloak/boat/science
	)
	gear_tweaks += new/datum/gear_tweak/path(boatcloaks)

//Shrouds
/datum/gear/suit/roles/shroud
	display_name = "shroud, colorable"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/shroud

/datum/gear/suit/roles/shroud/New()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/suit/roles/capshroud
	display_name = "shroud, site manager"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/shroud/cap
	allowed_roles = list(JOB_SITE_MANAGER)
	show_roles = FALSE

/datum/gear/suit/roles/hopshroud
	display_name = "shroud, head of personnel"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/shroud/hop
	allowed_roles = list(JOB_HEAD_OF_PERSONNEL)
	show_roles = FALSE

/datum/gear/suit/roles/shrouds
	display_name = "shroud selection"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/shroud/security

/datum/gear/suit/roles/shrouds/New()
	..()
	var/list/shrouds = list(
		"security shroud"=/obj/item/clothing/accessory/poncho/roles/cloak/shroud/security,
		"engineering shroud"=/obj/item/clothing/accessory/poncho/roles/cloak/shroud/engineering,
		"atmospherics shroud"=/obj/item/clothing/accessory/poncho/roles/cloak/shroud/atmos,
		"medical shroud"=/obj/item/clothing/accessory/poncho/roles/cloak/shroud/medical,
		"service shroud"=/obj/item/clothing/accessory/poncho/roles/cloak/shroud/service,
		"cargo shroud"=/obj/item/clothing/accessory/poncho/roles/cloak/shroud/cargo,
		"mining shroud"=/obj/item/clothing/accessory/poncho/roles/cloak/shroud/mining,
		"research shroud"=/obj/item/clothing/accessory/poncho/roles/cloak/shroud/science
	)
	gear_tweaks += new/datum/gear_tweak/path(shrouds)

/datum/gear/suit/roles/cropjackets
	display_name = "crop jacket selection"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/crop_jacket

/datum/gear/suit/roles/cropjackets/New()
	..()
	var/list/shrouds = list(
		"white crop jacket"=/obj/item/clothing/accessory/poncho/roles/cloak/crop_jacket,
		"blue crop jacket"=/obj/item/clothing/accessory/poncho/roles/cloak/crop_jacket/blue,
		"red crop jacket"=/obj/item/clothing/accessory/poncho/roles/cloak/crop_jacket/red,
		"green crop jacket"=/obj/item/clothing/accessory/poncho/roles/cloak/crop_jacket/green,
		"purple crop jacket"=/obj/item/clothing/accessory/poncho/roles/cloak/crop_jacket/purple,
		"orange crop jacket"=/obj/item/clothing/accessory/poncho/roles/cloak/crop_jacket/orange,
		"charcoal crop jacket"=/obj/item/clothing/accessory/poncho/roles/cloak/crop_jacket/charcoal,
		"faded reflec crop jacket"=/obj/item/clothing/accessory/poncho/roles/cloak/crop_jacket/marine,
		"drab crop jacket"=/obj/item/clothing/accessory/poncho/roles/cloak/crop_jacket/drab
	)
	gear_tweaks += new/datum/gear_tweak/path(shrouds)

//Actually colorable hoodies
/datum/gear/suit/roles/choodies
	display_name = "hoodie selection, colorable"
	path = /obj/item/clothing/suit/storage/hooded/toggle/colorable

/datum/gear/suit/roles/choodies/New()
	..()
	var/list/choodies = list(
		"normal hoodie"=/obj/item/clothing/suit/storage/hooded/toggle/colorable,
		"sleeveless hoodie"=/obj/item/clothing/suit/storage/hooded/toggle/colorable/sleeveless,
		"cropped hoodie"=/obj/item/clothing/suit/storage/hooded/toggle/colorable/cropped,
		"shortsleeve hoodie"=/obj/item/clothing/suit/storage/hooded/toggle/colorable/shortsleeve
	)
	gear_tweaks += gear_tweak_free_color_choice
	gear_tweaks += new/datum/gear_tweak/path(choodies)

//ABOUT TIME SOMEONE ADDED THIS TO A LOADOUT
/datum/gear/suit/bladerunnercoat
	display_name = "leather coat, massive"
	path = /obj/item/clothing/suit/storage/bladerunner

/datum/gear/suit/martianminer
	display_name = "martian miner's coat, basic"
	path = /obj/item/clothing/suit/storage/vest/martian_miner
