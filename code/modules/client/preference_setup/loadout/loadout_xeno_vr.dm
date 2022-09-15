// Upstream things
/////

/datum/gear/suit/dept/cloak/research
	allowed_roles = list("Research Director","Scientist", "Roboticist", "Xenobiologist", "Xenobotanist")

/datum/gear/uniform/dept/undercoat/research
	allowed_roles = list("Research Director","Scientist", "Roboticist", "Xenobiologist", "Xenobotanist")

/////

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

/datum/gear/mask/transparent
	display_name = "transparent breath mask"
	path = /obj/item/clothing/mask/breath/transparent
	sort_category = "Xenowear"

/datum/gear/uniform/loincloth
	display_name = "loincloth"
	path = /obj/item/clothing/suit/storage/fluff/loincloth
	sort_category = "Xenowear"

// Taj clothing
/datum/gear/eyes/tajblind
	display_name = "embroidered veil"
	path = /obj/item/clothing/glasses/tajblind
	//whitelisted = SPECIES_TAJ
	sort_category = "Xenowear"

/datum/gear/eyes/medical/tajblind
	display_name = "medical veil (Tajara) (Medical)"
	path = /obj/item/clothing/glasses/hud/health/tajblind
	//whitelisted = SPECIES_TAJ
	sort_category = "Xenowear"

/datum/gear/eyes/meson/tajblind
	display_name = "industrial veil (Tajara) (Engineering, Science)"
	path = /obj/item/clothing/glasses/meson/prescription/tajblind
	//whitelisted = SPECIES_TAJ
	sort_category = "Xenowear"

/datum/gear/eyes/material/tajblind
	display_name = "mining veil (Tajara) (Mining)"
	path = /obj/item/clothing/glasses/material/prescription/tajblind
	//whitelisted = SPECIES_TAJ
	sort_category = "Xenowear"

/datum/gear/eyes/security/tajblind
	display_name = "sleek veil (Tajara) (Security)"
	path = /obj/item/clothing/glasses/sunglasses/sechud/tajblind
	//whitelisted = SPECIES_TAJ
	sort_category = "Xenowear"

// Taur stuff
/datum/gear/suit/taur/drake_cloak
	display_name = "drake cloak (Drake-taur)"
	path = /obj/item/clothing/suit/drake_cloak
	sort_category = "Xenowear"

/datum/gear/suit/taur/white_dress
	display_name = "white wedding dress (Wolf/Horse-taur)"
	path = /obj/item/clothing/suit/taur/dress
	sort_category = "Xenowear"

/datum/gear/suit/taur/colorable_skirt
	display_name = "colorable skirt (Wolf/Horse-taur)"
	path = /obj/item/clothing/suit/taur/skirt
	sort_category = "Xenowear"

/datum/gear/suit/taur/colorable_skirt/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice
