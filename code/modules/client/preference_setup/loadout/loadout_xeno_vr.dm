/datum/gear/shoes/footwraps/New()					//Give color pick option for footwraps
	..()
	gear_tweaks = list(gear_tweak_free_color_choice)

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
	path = /obj/item/clothing/suit/taur_dress/white
	sort_category = "Xenowear"

//Kharmaani Stuff
/datum/gear/shoes/mantid
	display_name = "Ascent Magboots (Alate)"
	path = /obj/item/clothing/shoes/magboots/ascent
	sort_category = "Xenowear"
	whitelisted = SPECIES_MANTID_ALATE

/datum/gear/suit/mantid_harness
	display_name = "Ascent Harness (Alate)"
	path = /obj/item/clothing/suit/storage/ascent
	sort_category = "Xenowear"
	whitelisted = SPECIES_MANTID_ALATE

/datum/gear/uniform/mantid
	display_name = "Ascent Undersuit (Alate)"
	path = /obj/item/clothing/under/ascent
	sort_category = "Xenowear"
	whitelisted = SPECIES_MANTID_ALATE

/datum/gear/mask/mantid
	display_name = "Ascent Mask (Alate)"
	path = /obj/item/clothing/mask/gas/ascent
	sort_category = "Xenowear"
	whitelisted = SPECIES_MANTID_ALATE

//May comment out the spacesuit?
/datum/gear/suit/mantid_space
	display_name = "Ascent Voidsuit (Alate)"
	path = /obj/item/clothing/suit/space/void/ascent
	sort_category = "Xenowear"
	whitelisted = SPECIES_MANTID_ALATE

/datum/gear/head/mantid_space
	display_name = "Ascent Helmet (Alate)"
	path = /obj/item/clothing/head/helmet/space/void/ascent
	sort_category = "Xenowear"
	whitelisted = SPECIES_MANTID_ALATE
