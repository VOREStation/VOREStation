/datum/gear/suit/wintercoat/medical
	allowed_roles = list("Medical Doctor","Chief Medical Officer","Chemist","Paramedic","Geneticist", "Psychiatrist", "Field Medic")

/datum/gear/suit/wintercoat/science
	allowed_roles = list("Research Director","Scientist", "Roboticist", "Xenobiologist", "Xenobotanist", "Explorer", "Pathfinder")

/datum/gear/suit/snowsuit/medical
	allowed_roles = list("Medical Doctor","Chief Medical Officer","Chemist","Paramedic","Geneticist", "Psychiatrist", "Field Medic")

/datum/gear/suit/snowsuit/science
	allowed_roles = list("Research Director","Scientist", "Roboticist", "Xenobiologist", "Xenobotanist", "Explorer", "Pathfinder")

/datum/gear/suit/labcoat_colorable
	display_name = "labcoat, colorable"
	path = /obj/item/clothing/suit/storage/toggle/labcoat

/datum/gear/suit/labcoat_colorable/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

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
/datum/gear/uniform/detective_alt
	display_name = "sleek modern coat, detective"
	path = /obj/item/clothing/suit/storage/det_trench/alt
	allowed_roles = list("Head of Security", "Detective")

//Detective alternative
/datum/gear/uniform/detective_alt2
	display_name = "sleek modern coat (long), detective"
	path = /obj/item/clothing/suit/storage/det_trench/alt2
	allowed_roles = list("Head of Security", "Detective")

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