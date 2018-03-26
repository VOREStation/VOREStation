// Alien clothing.
/datum/gear/suit/zhan_furs
	display_name = "Zhan-Khazan furs (Tajaran)"
	path = /obj/item/clothing/suit/tajaran/furs
	sort_category = "Xenowear"

/datum/gear/head/zhan_scarf
	display_name = "Zhan headscarf"
	path = /obj/item/clothing/head/tajaran/scarf
	whitelisted = SPECIES_TAJ

/datum/gear/suit/unathi_mantle
	display_name = "hide mantle (Unathi)"
	path = /obj/item/clothing/suit/unathi/mantle
	cost = 1
	sort_category = "Xenowear"

/datum/gear/ears/skrell/chains	//Chains
	display_name = "headtail chain selection (Skrell)"
	path = /obj/item/clothing/ears/skrell/chain
	sort_category = "Xenowear"
	whitelisted = SPECIES_SKRELL

/datum/gear/ears/skrell/chains/New()
	..()
	var/list/chaintypes = list()
	for(var/chain_style in typesof(/obj/item/clothing/ears/skrell/chain))
		var/obj/item/clothing/ears/skrell/chain/chain = chain_style
		chaintypes[initial(chain.name)] = chain
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(chaintypes))

/datum/gear/ears/skrell/bands
	display_name = "headtail band selection (Skrell)"
	path = /obj/item/clothing/ears/skrell/band
	sort_category = "Xenowear"
	whitelisted = SPECIES_SKRELL

/datum/gear/ears/skrell/bands/New()
	..()
	var/list/bandtypes = list()
	for(var/band_style in typesof(/obj/item/clothing/ears/skrell/band))
		var/obj/item/clothing/ears/skrell/band/band = band_style
		bandtypes[initial(band.name)] = band
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(bandtypes))

/datum/gear/ears/skrell/cloth/short
	display_name = "short headtail cloth (Skrell)"
	path = /obj/item/clothing/ears/skrell/cloth_male/black
	sort_category = "Xenowear"
	whitelisted = SPECIES_SKRELL

/datum/gear/ears/skrell/cloth/short/New()
	..()
	var/list/shorttypes = list()
	for(var/short_style in typesof(/obj/item/clothing/ears/skrell/cloth_male))
		var/obj/item/clothing/ears/skrell/cloth_male/short = short_style
		shorttypes[initial(short.name)] = short
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(shorttypes))

/datum/gear/ears/skrell/cloth/long
	display_name = "long headtail cloth (Skrell)"
	path = /obj/item/clothing/ears/skrell/cloth_female/black
	sort_category = "Xenowear"
	whitelisted = SPECIES_SKRELL

/datum/gear/ears/skrell/cloth/long/New()
	..()
	var/list/longtypes = list()
	for(var/long_style in typesof(/obj/item/clothing/ears/skrell/cloth_female))
		var/obj/item/clothing/ears/skrell/cloth_female/long = long_style
		longtypes[initial(long.name)] = long
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(longtypes))

/datum/gear/ears/skrell/colored/band
	display_name = "Colored bands (Skrell)"
	path = /obj/item/clothing/ears/skrell/colored/band
	sort_category = "Xenowear"
	whitelisted = SPECIES_SKRELL

/datum/gear/ears/skrell/colored/band/New()
	..()
	gear_tweaks = list(gear_tweak_free_color_choice)

/datum/gear/ears/skrell/colored/chain
	display_name = "Colored chain (Skrell)"
	path = /obj/item/clothing/ears/skrell/colored/chain
	sort_category = "Xenowear"
	whitelisted = SPECIES_SKRELL

/datum/gear/ears/skrell/colored/chain/New()
	..()
	gear_tweaks = list(gear_tweak_free_color_choice)

/datum/gear/uniform/smock
	display_name = "smock selection (Teshari)"
	path = /obj/item/clothing/under/seromi/smock
	whitelisted = SPECIES_TESHARI
	sort_category = "Xenowear"

/datum/gear/uniform/smock/New()
	..()
	var/list/smocks = list()
	for(var/smock in typesof(/obj/item/clothing/under/seromi/smock))
		var/obj/item/clothing/under/seromi/smock/smock_type = smock
		smocks[initial(smock_type.name)] = smock_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(smocks))

/datum/gear/uniform/undercoat
	display_name = "undercoat selection (Teshari)"
	path = /obj/item/clothing/under/seromi/undercoat
	whitelisted = SPECIES_TESHARI
	sort_category = "Xenowear"

/datum/gear/uniform/undercoat/New()
	..()
	var/list/undercoats = list()
	for(var/undercoat in typesof(/obj/item/clothing/under/seromi/undercoat))
		var/obj/item/clothing/under/seromi/undercoat/undercoat_type = undercoat
		undercoats[initial(undercoat_type.name)] = undercoat_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(undercoats))

/datum/gear/suit/cloak
	display_name = "cloak selection (Teshari)"
	path = /obj/item/clothing/suit/storage/seromi/cloak
	whitelisted = SPECIES_TESHARI
	sort_category = "Xenowear"

/datum/gear/suit/cloak/New()
	..()
	var/list/cloaks = list()
	for(var/cloak in typesof(/obj/item/clothing/suit/storage/seromi/cloak))
		var/obj/item/clothing/suit/storage/seromi/cloak/cloak_type = cloak
		cloaks[initial(cloak_type.name)] = cloak_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(cloaks))

/datum/gear/mask/ipc_monitor
	display_name = "display monitor (Full Body Prosthetic)"
	path = /obj/item/clothing/mask/monitor
	sort_category = "Xenowear"

/datum/gear/uniform/harness
	display_name = "gear harness (Full Body Prosthetic, Diona)"
	path = /obj/item/clothing/under/harness
	sort_category = "Xenowear"

/datum/gear/shoes/footwraps
	display_name = "cloth footwraps"
	path = /obj/item/clothing/shoes/footwraps
	sort_category = "Xenowear"
	cost = 1

/datum/gear/uniform/cohesionsuits
	display_name = "cohesion suit selection (Promethean)"
	path = /obj/item/clothing/under/cohesion
	sort_category = "Xenowear"

/datum/gear/uniform/cohesionsuits/New()
	..()
	var/list/cohesionsuits = list()
	for(var/cohesionsuit in (typesof(/obj/item/clothing/under/cohesion)))
		var/obj/item/clothing/under/cohesion/cohesion_type = cohesionsuit
		cohesionsuits[initial(cohesion_type.name)] = cohesion_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(cohesionsuits))