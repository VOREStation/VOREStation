// Alien clothing.
/datum/gear/suit/zhan_furs
	display_name = "Zhan-Khazan furs (Tajara)"
	path = /obj/item/clothing/suit/tajaran/furs
	sort_category = "Xenowear"

/datum/gear/suit/unathi_mantle
	display_name = "hide mantle (Unathi)"
	path = /obj/item/clothing/suit/unathi/mantle
	cost = 1
	sort_category = "Xenowear"

/datum/gear/ears/skrell/chains	//Chains
	display_name = "headtail chain selection (Skrell)"
	path = /obj/item/clothing/ears/skrell/chain
	sort_category = "Xenowear"
	whitelisted = "Skrell"

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
	whitelisted = "Skrell"

/datum/gear/ears/skrell/bands/New()
	..()
	var/list/bandtypes = list()
	for(var/band_style in typesof(/obj/item/clothing/ears/skrell/band))
		var/obj/item/clothing/ears/skrell/band/band = band_style
		bandtypes[initial(band.name)] = band
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(bandtypes))

/datum/gear/ears/skrell/cloth/male
	display_name = "male headtail cloth (Skrell)"
	path = /obj/item/clothing/ears/skrell/cloth_male/black
	sort_category = "Xenowear"
	whitelisted = "Skrell"

/datum/gear/ears/skrell/cloth/male/New()
	..()
	gear_tweaks = list(gear_tweak_free_color_choice)

/datum/gear/ears/skrell/cloth/female
	display_name = "female headtail cloth (Skrell)"
	path = /obj/item/clothing/ears/skrell/cloth_female/black
	sort_category = "Xenowear"
	whitelisted = "Skrell"

/datum/gear/ears/skrell/cloth/female/New()
	..()
	gear_tweaks = list(gear_tweak_free_color_choice)

/datum/gear/ears/skrell/colored/band
	display_name = "Colored bands (Skrell)"
	path = /obj/item/clothing/ears/skrell/colored/band
	sort_category = "Xenowear"
	whitelisted = "Skrell"

/datum/gear/ears/skrell/colored/band/New()
	..()
	gear_tweaks = list(gear_tweak_free_color_choice)

/datum/gear/ears/skrell/colored/chain
	display_name = "Colored chain (Skrell)"
	path = /obj/item/clothing/ears/skrell/colored/chain
	sort_category = "Xenowear"
	whitelisted = "Skrell"

/datum/gear/ears/skrell/colored/chain/New()
	..()
	gear_tweaks = list(gear_tweak_free_color_choice)

/datum/gear/uniform/teshari
	display_name = "smock, grey (Teshari)"
	path = /obj/item/clothing/under/seromi
	whitelisted = "Teshari"
	sort_category = "Xenowear"

/datum/gear/uniform/teshari/jumpsuit
	display_name = "smock, yellow (Teshari)"
	path = /obj/item/clothing/under/seromi/yellow

/datum/gear/uniform/teshari/jumpsuit/red
	display_name = "smock, red (Teshari)"
	path = /obj/item/clothing/under/seromi/red

/datum/gear/uniform/teshari/jumpsuit/white
	display_name = "smock, white (Teshari)"
	path = /obj/item/clothing/under/seromi/white

/datum/gear/uniform/teshari/jumpsuit/medical
	display_name = "smock, Medical (Teshari)"
	path = /obj/item/clothing/under/seromi/medical

/datum/gear/uniform/teshari/jumpsuit/rainbow
	display_name = "smock, rainbow (Teshari)"
	path = /obj/item/clothing/under/seromi/rainbow

/datum/gear/mask/ipc_monitor
	display_name = "display monitor (Full Body Prosthetic)"
	path = /obj/item/clothing/mask/monitor
	sort_category = "Xenowear"

/datum/gear/uniform/harness
	display_name = "gear harness (Full Body Prosthetic, Diona)"
	path = /obj/item/clothing/under/harness
	sort_category = "Xenowear"
