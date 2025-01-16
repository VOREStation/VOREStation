// Gloves
/datum/gear/gloves
	display_name = "gloves, black"
	path = /obj/item/clothing/gloves/black
	cost = 1
	slot = slot_gloves
	sort_category = "Gloves and Handwear"

/datum/gear/gloves/selector
	display_name = "coloured gloves selector"
	description = "Pick from a range of plain coloured gloves."
	path = /obj/item/clothing/gloves/black

/datum/gear/gloves/selector/New()
	..()
	var/list/selector_uniforms = list(
		"black"=/obj/item/clothing/gloves/black,
		"blue"=/obj/item/clothing/gloves/blue,
		"brown"=/obj/item/clothing/gloves/brown,
		"light brown"=/obj/item/clothing/gloves/light_brown,
		"green"=/obj/item/clothing/gloves/green,
		"grey"=/obj/item/clothing/gloves/grey,
		"orange"=/obj/item/clothing/gloves/orange,
		"purple"=/obj/item/clothing/gloves/purple,
		"rainbow"=/obj/item/clothing/gloves/rainbow,
		"red"=/obj/item/clothing/gloves/red,
		"white"=/obj/item/clothing/gloves/white
	)
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(selector_uniforms))

/datum/gear/gloves/latex
	display_name = "gloves, latex"
	path = /obj/item/clothing/gloves/sterile/latex
	cost = 2

/datum/gear/gloves/nitrile
	display_name = "gloves, nitrile"
	path = /obj/item/clothing/gloves/sterile/nitrile
	cost = 2

/datum/gear/gloves/evening
	display_name = "evening gloves"
	path = /obj/item/clothing/gloves/evening

/datum/gear/gloves/evening/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/gloves/duty
	display_name = "gloves, work"
	path = /obj/item/clothing/gloves/duty
	cost = 3

/datum/gear/gloves/forensic
	display_name = "gloves, forensic"
	path = /obj/item/clothing/gloves/forensic
	allowed_roles = list(JOB_DETECTIVE)

/datum/gear/gloves/fingerless
	display_name = "fingerless gloves"
	description = "A pair of gloves that don't actually cover the fingers. Available in classic black or recolourable white, with or without cutouts."
	path = /obj/item/clothing/gloves/fingerless

/datum/gear/gloves/fingerless/New()
	..()
	var/list/selector_uniforms = list(
		"black"=/obj/item/clothing/gloves/fingerless,
		"black, alt" =/obj/item/clothing/gloves/fingerless/alt,
		"recolourable white"=/obj/item/clothing/gloves/fingerless_recolourable,
		"recolourable, alt"=/obj/item/clothing/gloves/fingerless_recolourable/alt
	)
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(selector_uniforms))
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/gloves/ring
	display_name = "ring selection"
	description = "Choose from a number of rings."
	path = /obj/item/clothing/accessory/ring
	cost = 1

/datum/gear/gloves/ring/New()
	..()
	var/ringtype = list()
	ringtype["CTI ring"] = /obj/item/clothing/accessory/ring/cti
	ringtype["Mariner University ring"] = /obj/item/clothing/accessory/ring/mariner
	ringtype["engagement ring"] = /obj/item/clothing/accessory/ring/engagement
	ringtype["signet ring"] = /obj/item/clothing/accessory/ring/seal/signet
	ringtype["masonic ring"] = /obj/item/clothing/accessory/ring/seal/mason
	ringtype["ring, glass"] = /obj/item/clothing/accessory/ring/material/glass
	ringtype["ring, wood"] = /obj/item/clothing/accessory/ring/material/wood
	ringtype["ring, plastic"] = /obj/item/clothing/accessory/ring/material/plastic
	ringtype["ring, iron"] = /obj/item/clothing/accessory/ring/material/iron
	ringtype["ring, bronze"] = /obj/item/clothing/accessory/ring/material/bronze
	ringtype["ring, steel"] = /obj/item/clothing/accessory/ring/material/steel
	ringtype["ring, copper"] = /obj/item/clothing/accessory/ring/material/copper
	ringtype["ring, silver"] = /obj/item/clothing/accessory/ring/material/silver
	ringtype["ring, gold"] = /obj/item/clothing/accessory/ring/material/gold
	ringtype["ring, platinum"] = /obj/item/clothing/accessory/ring/material/platinum

	gear_tweaks += new/datum/gear_tweak/path(ringtype)

/datum/gear/gloves/circuitry
	display_name = "gloves, circuitry (empty)"
	path = /obj/item/clothing/gloves/circuitry

/datum/gear/gloves/watch
	display_name = "wristwatch selector"
	description = "Pick from a range of wristwatches."
	path = /obj/item/clothing/accessory/watch

/datum/gear/gloves/watch/New()
	..()
	var/list/selector_watches = list(
		"plain plastic"=/obj/item/clothing/accessory/watch,
		"silver"=/obj/item/clothing/accessory/watch/silver,
		"gold"=/obj/item/clothing/accessory/watch/gold,
		"survival"=/obj/item/clothing/accessory/watch/survival
	)
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(selector_watches))

/datum/gear/gloves/goldring
	display_name = "wedding ring, gold"
	path = /obj/item/clothing/accessory/ring/wedding

/datum/gear/gloves/silverring
	display_name = "wedding ring, silver"
	path = /obj/item/clothing/accessory/ring/wedding/silver

/datum/gear/gloves/colored
	display_name = "gloves, colorable"
	path = /obj/item/clothing/gloves/color

/datum/gear/gloves/colored/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/gloves/latex/colorable
	display_name = "gloves, latex, colorable"
	path = /obj/item/clothing/gloves/sterile/latex

/datum/gear/gloves/latex/colorable/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/gloves/siren
	display_name = "gloves, Siren"
	path = /obj/item/clothing/gloves/fluff/siren

/datum/gear/gloves/maid_arms
	display_name = "maid arm covers"
	path = /obj/item/clothing/accessory/maid_arms
