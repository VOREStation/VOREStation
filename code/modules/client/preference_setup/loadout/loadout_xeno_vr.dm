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
	path = /obj/item/clothing/suit/taur_dress/white
	sort_category = "Xenowear"

/datum/gear/suit/cloak_cit
	display_name = "cloak selection (Teshari) (CitRP)"
	path = /obj/item/clothing/suit/storage/teshari/cloak_cit/standard
	whitelisted = SPECIES_TESHARI
	sort_category = "Xenowear"

//CitRP port. Their cloaks have new icons.
/datum/gear/suit/cloak_cit/New()
	..()
	var/list/cloaks = list()
	for(var/cloak in typesof(/obj/item/clothing/suit/storage/teshari/cloak_cit/standard))
		var/obj/item/clothing/suit/storage/teshari/cloak_cit/standard/cloak_type = cloak
		cloaks[initial(cloak_type.name)] = cloak_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(cloaks))

/datum/gear/suit/cloak_cit_color
	display_name = "cloak, recolorable (Teshari) (CitRP)"
	path = /obj/item/clothing/suit/storage/teshari/cloak_cit/standard/white
	whitelisted = SPECIES_TESHARI
	sort_category = "Xenowear"

/datum/gear/suit/cloak_cit_color/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

//Net new CitRP job cloaks
/datum/gear/suit/dept/cloak/cap
	display_name = "facility director cloak (Teshari)"
	path = /obj/item/clothing/suit/storage/seromi/cloak/jobs/cap
	allowed_roles = list("Site Manager")

/datum/gear/suit/dept/cloak/psych
	display_name = "psychiatrist cloak (Teshari)"
	path = /obj/item/clothing/suit/storage/seromi/cloak/jobs/psych
	allowed_roles = list("Psychiatrist")

/datum/gear/suit/dept/cloak/rd
	display_name = "research director cloak (Teshari)"
	path = /obj/item/clothing/suit/storage/seromi/cloak/jobs/rd
	allowed_roles = list("Research Director")

/datum/gear/suit/dept/cloak/hos
	display_name = "head of security cloak (Teshari)"
	path = /obj/item/clothing/suit/storage/seromi/cloak/jobs/hos
	allowed_roles = list("Head of Security")

/datum/gear/suit/dept/cloak/hop
	display_name = "head of personnel cloak (Teshari)"
	path = /obj/item/clothing/suit/storage/seromi/cloak/jobs/hop
	allowed_roles = list("Head of Personnel")

//Added from CHOMP
/datum/gear/suit/cloak_hood
	display_name = "hooded cloak selection (Teshari)"
	path = /obj/item/clothing/suit/storage/hooded/teshari/standard
	whitelisted = SPECIES_TESHARI
	sort_category = "Xenowear"

/datum/gear/suit/cloak_hood/New()
	..()
	var/list/cloaks = list()
	for(var/cloak in typesof(/obj/item/clothing/suit/storage/hooded/teshari/standard))
		var/obj/item/clothing/suit/storage/seromi/cloak/cloak_type = cloak
		cloaks[initial(cloak_type.name)] = cloak_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(cloaks))

/datum/gear/suit/beltcloak
	display_name = "belted cloak selection (Teshari)"
	path = /obj/item/clothing/suit/storage/seromi/beltcloak/standard
	whitelisted = SPECIES_TESHARI
	sort_category = "Xenowear"

/datum/gear/suit/beltcloak/New()
	..()
	var/list/cloaks = list()
	for(var/cloak in typesof(/obj/item/clothing/suit/storage/seromi/beltcloak/standard))
		var/obj/item/clothing/suit/storage/seromi/beltcloak/standard/cloak_type = cloak
		cloaks[initial(cloak_type.name)] = cloak_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(cloaks))

/datum/gear/suit/beltcloak_color
	display_name = "belted cloak, recolorable (Teshari)"
	path = /obj/item/clothing/suit/storage/seromi/beltcloak/standard/white_grey
	whitelisted = SPECIES_TESHARI
	sort_category = "Xenowear"

/datum/gear/suit/beltcloak_color/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/eyes/aerogelgoggles
	display_name = "airtight orange goggles (Teshari)"
	path = /obj/item/clothing/glasses/aerogelgoggles
	whitelisted = SPECIES_TESHARI
	sort_category = "Xenowear"
