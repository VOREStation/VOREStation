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
	description = "A mexican looking poncho. It look like it fits wolf taurs as well."
	path = /obj/item/clothing/suit/poncho

//Detective alternative
/datum/gear/suit/detective_alt
	display_name = "sleek modern coat selection, detective"
	path = /obj/item/clothing/suit/storage/det_trench/alt
	allowed_roles = list("Head of Security", "Detective")

/datum/gear/suit/detective_alt/New()
	..()
	var/list/coats = list(
		"Modern coat (tan)" = /obj/item/clothing/suit/storage/det_trench/alt,
		"Modern coat (long, tan)" = /obj/item/clothing/suit/storage/det_trench/alt2,
		"Modern coat (black)" = /obj/item/clothing/suit/storage/det_trench/alt/black,
		"Modern coat (long, black)" = /obj/item/clothing/suit/storage/det_trench/alt2/black
	)
	gear_tweaks += new/datum/gear_tweak/path(coats)

//Emergency Responder jackets for Parameds & EMTs, but also general Medical Staff
/datum/gear/suit/roles/medical/ems_jacket
	display_name = "first responder jacket"
	path = /obj/item/clothing/suit/storage/toggle/fr_jacket
	allowed_roles = list("Chief Medical Officer","Paramedic","Medical Doctor")

//imo-superior 'martian' style jacket with the star-of-life design
/datum/gear/suit/roles/medical/ems_jacket/alt
	display_name = "first responder jacket, alt."
	path = /obj/item/clothing/suit/storage/toggle/fr_jacket/ems

//paramedic vest
/datum/gear/suit/roles/medical/paramedic_vest
	display_name = "paramedic vest"
	path = /obj/item/clothing/suit/storage/toggle/paramedic
	allowed_roles = list("Chief Medical Officer","Paramedic","Medical Doctor")

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
	allowed_roles = list("Explorer","Pathfinder")

/datum/gear/suit/armor/combat/crusader_explo/FM
	display_name = "knight, Field Medic"
	path = /obj/item/clothing/suit/armor/combat/crusader_explo/FM
	allowed_roles = list ("Field Medic")

//Atmos-coloured hazard vest
	display_name = "hazard vest, atmospherics"
	path = /obj/item/clothing/suit/storage/hazardvest/atmos
	allowed_roles = list("Chief Engineer","Atmospheric Technician", "Engineer")

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
