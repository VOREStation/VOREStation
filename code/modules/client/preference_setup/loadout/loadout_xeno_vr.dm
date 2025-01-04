// Upstream things
/////

/datum/gear/suit/dept/cloak/research
	allowed_roles = list(JOB_RESEARCH_DIRECTOR,JOB_SCIENTIST, JOB_ROBOTICIST, JOB_XENOBIOLOGIST, JOB_XENOBOTANIST)

/datum/gear/uniform/dept/undercoat/research
	allowed_roles = list(JOB_RESEARCH_DIRECTOR,JOB_SCIENTIST, JOB_ROBOTICIST, JOB_XENOBIOLOGIST, JOB_XENOBOTANIST)

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
	//whitelisted = SPECIES_TAJARAN
	sort_category = "Xenowear"

/datum/gear/eyes/medical/tajblind
	display_name = "medical veil (Tajara) (Medical)"
	path = /obj/item/clothing/glasses/hud/health/tajblind
	//whitelisted = SPECIES_TAJARAN
	sort_category = "Xenowear"

/datum/gear/eyes/meson/tajblind
	display_name = "industrial veil (Tajara) (Engineering, Science)"
	path = /obj/item/clothing/glasses/meson/prescription/tajblind
	//whitelisted = SPECIES_TAJARAN
	sort_category = "Xenowear"

/datum/gear/eyes/material/tajblind
	display_name = "mining veil (Tajara) (Mining)"
	path = /obj/item/clothing/glasses/material/prescription/tajblind
	//whitelisted = SPECIES_TAJARAN
	sort_category = "Xenowear"

/datum/gear/eyes/security/tajblind
	display_name = "sleek veil (Tajara) (Security)"
	path = /obj/item/clothing/glasses/sunglasses/sechud/tajblind
	//whitelisted = SPECIES_TAJARAN
	sort_category = "Xenowear"

/datum/gear/mask/altevian_breath
	display_name = "spacer tuned mask (Altevian)"
	path = /obj/item/clothing/mask/altevian_breath
	sort_category = "Xenowear"

/datum/gear/uniform/altevian_outfit
	description = "A uniform commonly seen worn by altevians. The material on this uniform is made of a durable thread that can handle the stress of most forms of labor."
	display_name = "altevian duty jumpsuit selection (Altevian)"
	whitelisted = SPECIES_ALTEVIAN
	sort_category = "Xenowear"

/datum/gear/uniform/altevian_outfit/New()
	..()
	var/list/pants = list()
	for(var/obj/item/clothing/under/altevian/uniform_type as anything in typesof(/obj/item/clothing/under/altevian))
		pants[initial(uniform_type.name)] = uniform_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(pants))

/datum/gear/accessory/altevian_aquila
	description = "An emblem found across all altevian vessels. The specific metals and jewels denote ranks. Otherwise, it's just a pretty rat skull emblem with a set of crystals for their eyes and fangs."
	display_name = "royal altevian navy emblem selection"
	whitelisted = SPECIES_ALTEVIAN
	sort_category = "Xenowear"

/datum/gear/accessory/altevian_aquila/New()
	..()
	var/list/badges = list(
						"gold emblem" = /obj/item/clothing/accessory/altevian_badge/aquila,
						"silver emblem" = /obj/item/clothing/accessory/altevian_badge/aquila/silver,
						"bronze emblem" = /obj/item/clothing/accessory/altevian_badge/aquila/bronze,
						"black emblem" = /obj/item/clothing/accessory/altevian_badge/aquila/black,
						"blue emblem" = /obj/item/clothing/accessory/altevian_badge/aquila/exotic,
						"purple emblem" = /obj/item/clothing/accessory/altevian_badge/aquila/phoron,
						"red emblem" = /obj/item/clothing/accessory/altevian_badge/aquila/hydrogen)
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(badges))

/datum/gear/suit/altevian_officer_suit
	description = "A comfortable official suit for altevian command officers."
	display_name = "altevian officer's suit selection, site manager"
	whitelisted = SPECIES_ALTEVIAN
	allowed_roles = list(JOB_SITE_MANAGER)
	sort_category = "Xenowear"

/datum/gear/suit/altevian_officer_suit/New()
	..()
	var/list/suits = list()
	for(var/ratsuit in typesof(/obj/item/clothing/suit/captunic/capjacket/altevian_admiral))
		var/obj/item/clothing/suit/captunic/capjacket/altevian_admiral/specific_ratsuit = ratsuit
		suits[initial(specific_ratsuit.name)] = specific_ratsuit
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(suits))

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
