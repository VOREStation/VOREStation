/datum/gear/uniform/voxcasual
	display_name = "casual wear (Vox)"
	path = /obj/item/clothing/under/vox/vox_casual
	sort_category = "Xenowear"
	whitelisted = "Vox"

/datum/gear/uniform/voxrobes
	display_name = "comfy robes (Vox)"
	path = /obj/item/clothing/under/vox/vox_robes
	sort_category = "Xenowear"
	whitelisted = "Vox"

/datum/gear/accessory/vox
	display_name = "storage vest (Vox)"
	path = /obj/item/clothing/accessory/storage/vox
	sort_category = "Xenowear"
	whitelisted = "Vox"

/datum/gear/gloves/vox
	display_name = "insulated gauntlets (Vox)"
	path = /obj/item/clothing/gloves/vox
	sort_category = "Xenowear"
	whitelisted = "Vox"

/datum/gear/shoes/vox
	display_name = "magclaws (Vox)"
	path = /obj/item/clothing/shoes/magboots/vox
	sort_category = "Xenowear"
	whitelisted = "Vox"

/datum/gear/mask/vox
	display_name = "alien mask (Vox)"
	path = /obj/item/clothing/mask/gas/swat/vox
	sort_category = "Xenowear"
	whitelisted = "Vox"

//TESH STOOF

/datum/gear/uniform/tesh_undercoats
	display_name = "teshari undercoat selection"
	path = /obj/item/clothing/under/seromi/undercoat/black_orange
	sort_category = "Xenowear"
	whitelisted = "Teshari"

/datum/gear/uniform/tesh_undercoats/New()
	..()
	var/list/undercoats= list()
	for(var/coat in typesof(/obj/item/clothing/under/seromi/undercoat))
		var/obj/item/clothing/under/seromi/undercoat/coats = coat
		undercoats[initial(coats.name)] = coats
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(undercoats))

/datum/gear/suit/tesh_cloaks
	display_name = "Teshari Cloak selection"
	path = /obj/item/clothing/suit/storage/seromi/cloak/
	sort_category = "Xenowear"
	whitelisted = "Teshari"

/datum/gear/suit/tesh_cloaks/New()//i hate this code -the person who is trying for a whole day to make this code work
	..()
	var/list/teshsuits = list()
	for(var/tsuit in typesof(/obj/item/clothing/suit/storage/seromi/cloak))
		var/obj/item/clothing/suit/storage/seromi/cloak/tsuit_type = tsuit
		teshsuits[initial(tsuit_type.name)] = tsuit_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(teshsuits))
