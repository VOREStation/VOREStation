/datum/gear/suit/labcoat_colorable
	display_name = "labcoat, colorable"
	path = /obj/item/clothing/suit/storage/toggle/labcoat

/datum/gear/suit/labcoat_colorable/New()
	..()
	gear_tweaks = list(gear_tweak_free_color_choice)

/datum/gear/suit/jacket_modular
	display_name = "jacket, modular"
	path = /obj/item/clothing/suit/storage/toggle/fluff/jacket

/datum/gear/suit/jacket_modular/New()
	..()
	var/list/jackets = list()
	for(var/jacket in typesof(/obj/item/clothing/suit/storage/toggle/fluff/jacket))
		var/obj/item/clothing/suit/jacket_type = jacket
		jackets[initial(jacket_type.name)] = jacket_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(jackets))
