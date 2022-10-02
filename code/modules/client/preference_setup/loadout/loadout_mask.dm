// Mask
/datum/gear/mask
	display_name = "mask, sterile"
	path = /obj/item/clothing/mask/surgical
	slot = slot_wear_mask
	sort_category = "Masks and Facewear"

/datum/gear/mask/bandanas
	display_name = "face bandana selection"
	path = /obj/item/clothing/mask/bandana/blue

<<<<<<< HEAD
/datum/gear/mask/sterile
	display_name = "sterile mask"
	path = /obj/item/clothing/mask/surgical
	cost = 2
=======
/datum/gear/mask/bandanas/New()
	..()
	var/list/bandanas = list()
	for(var/bandana in typesof(/obj/item/clothing/mask/bandana))
		var/obj/item/clothing/mask/bandana/bandana_type = bandana
		bandanas[initial(bandana_type.name)] = bandana_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(bandanas))
>>>>>>> 3748572e9e7... Consolidates Loadout Lists (#8714)

/datum/gear/mask/sterile/white
	display_name = "white sterile mask"
	path = /obj/item/clothing/mask/surgical/white
	cost = 2

<<<<<<< HEAD
/datum/gear/mask/sterile/white/dust
	display_name = "dust mask"
	path = /obj/item/clothing/mask/surgical/dust

/datum/gear/mask/sterile/white/cloth
	display_name = "cloth face mask"
=======
/datum/gear/mask/gasmasks/New()
	..()
	var/masks = list()
	masks["gas mask"] = /obj/item/clothing/mask/gas
	masks["clear gas mask"] = /obj/item/clothing/mask/gas/clear
	masks["plague doctor mask"] = /obj/item/clothing/mask/gas/plaguedoctor
	masks["gold plague doctor mask"] = /obj/item/clothing/mask/gas/plaguedoctor/gold
	gear_tweaks += new/datum/gear_tweak/path(masks)

/datum/gear/mask/cloth
	display_name = "mask, cloth (colorable)"
>>>>>>> 3748572e9e7... Consolidates Loadout Lists (#8714)
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