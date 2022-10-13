/datum/gear/suit/bomber // Override version of bomber jacket selection incorporating map-specific jacket.
	display_name = "jacket, bomber selection"
	description = "A selection of jackets styled after early aviation gear."
	path = /obj/item/clothing/suit/storage/toggle/bomber
	cost = 2

/datum/gear/suit/bomber/New()
	..()
	var/bombertype = list()
	bombertype["bomber jacket"] = /obj/item/clothing/suit/storage/toggle/bomber
	bombertype["bomber jacket, alternate"] = /obj/item/clothing/suit/storage/bomber/alt
	bombertype["bomber jacket, retro"] = /obj/item/clothing/suit/storage/toggle/bomber/retro
	bombertype["bomber jacket, pilot blue"] = /obj/item/clothing/suit/storage/toggle/bomber/pilot
	gear_tweaks += new/datum/gear_tweak/path(bombertype)
