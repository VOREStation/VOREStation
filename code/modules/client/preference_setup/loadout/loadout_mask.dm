// Mask
/datum/gear/mask
	display_name = "bandana, blue"
	path = /obj/item/clothing/mask/bandana/blue
	slot = slot_wear_mask
	sort_category = "Masks and Facewear"

/datum/gear/mask/gold
	display_name = "bandana, gold"
	path = /obj/item/clothing/mask/bandana/gold

/datum/gear/mask/green
	display_name = "bandana, green 2"
	path = /obj/item/clothing/mask/bandana/green

/datum/gear/mask/red
	display_name = "bandana, red"
	path = /obj/item/clothing/mask/bandana/red

/datum/gear/mask/sterile
	display_name = "sterile mask"
	path = /obj/item/clothing/mask/surgical
	cost = 2

/datum/gear/mask/sterile/white
	display_name = "white sterile mask"
	path = /obj/item/clothing/mask/surgical/white
	cost = 2

/datum/gear/mask/sterile/white/dust
	display_name = "dust mask"
	path = /obj/item/clothing/mask/surgical/dust

/datum/gear/mask/sterile/white/cloth
	display_name = "cloth face mask"
	path = /obj/item/clothing/mask/surgical/cloth

/datum/gear/mask/plaguedoctor
	display_name = "plague doctor's mask"
	path = /obj/item/clothing/mask/gas/plaguedoctor
	cost = 3 ///Because it functions as a gas mask, and therefore has a mechanical advantage.

/datum/gear/mask/plaguedoctor2
	display_name = "golden plague doctor's mask"
	path = /obj/item/clothing/mask/gas/plaguedoctor/gold
	cost = 3 ///Because it functions as a gas mask, and therefore has a mechanical advantage.

/datum/gear/mask/mouthwheat
	display_name = "mouth wheat"
	path = /obj/item/clothing/mask/mouthwheat

/datum/gear/mask/papermask
	display_name = "paper mask"
	path = /obj/item/clothing/mask/paper

/datum/gear/mask/emotionalmask
	display_name = "emotional mask"
	path = /obj/item/clothing/mask/emotions

/datum/gear/mask/gaiter
	display_name = "neck gaiter selection"
	path = /obj/item/clothing/accessory/gaiter
	cost = 1

/datum/gear/mask/gaiter/New()
	..()
	var/list/gaiters = list()
	for(var/gaiter in typesof(/obj/item/clothing/accessory/gaiter))
		var/obj/item/clothing/accessory/gaiter_type = gaiter
		gaiters[initial(gaiter_type.name)] = gaiter_type
	gear_tweaks += new/datum/gear_tweak/path(sortTim(gaiters, /proc/cmp_text_asc))

	var/masks = list()
	masks["gas mask"] = /obj/item/clothing/mask/gas
	masks["clear gas mask"] = /obj/item/clothing/mask/gas/clear
	masks["plague doctor mask"] = /obj/item/clothing/mask/gas/plaguedoctor
	masks["gold plague doctor mask"] = /obj/item/clothing/mask/gas/plaguedoctor/gold
	gear_tweaks += new/datum/gear_tweak/path(masks)

/datum/gear/mask/cloth
	display_name = "cloth mask (recolorable)"
	path = /obj/item/clothing/mask/surgical/cloth
	cost = 2

/datum/gear/mask/cloth/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/mask/dust
	display_name = "dust mask"
	path = /obj/item/clothing/mask/surgical/dust
	cost = 2
