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
	display_name = "gloves, forensic (Detective)"
	path = /obj/item/clothing/gloves/forensic
	allowed_roles = list("Detective")

/datum/gear/gloves/fingerless
	display_name = "fingerless gloves"
	description = "A pair of gloves that don't actually cover the fingers. Available in classic black or recolourable white."
	path = /obj/item/clothing/gloves/fingerless

/datum/gear/gloves/fingerless/New()
	..()
	var/list/selector_uniforms = list(
		"black"=/obj/item/clothing/gloves/fingerless,
		"recolourable white"=/obj/item/clothing/gloves/fingerless_recolourable
	)
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(selector_uniforms))
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/gloves/ring
	display_name = "ring selection"
	description = "Choose from a number of rings."
	path = /obj/item/clothing/gloves/ring
	cost = 1

/datum/gear/gloves/ring/New()
	..()
	var/ringtype = list()
	ringtype["CTI ring"] = /obj/item/clothing/gloves/ring/cti
	ringtype["Mariner University ring"] = /obj/item/clothing/gloves/ring/mariner
	ringtype["engagement ring"] = /obj/item/clothing/gloves/ring/engagement
	ringtype["signet ring"] = /obj/item/clothing/gloves/ring/seal/signet
	ringtype["masonic ring"] = /obj/item/clothing/gloves/ring/seal/mason
	ringtype["ring, glass"] = /obj/item/clothing/gloves/ring/material/glass
	ringtype["ring, wood"] = /obj/item/clothing/gloves/ring/material/wood
	ringtype["ring, plastic"] = /obj/item/clothing/gloves/ring/material/plastic
	ringtype["ring, iron"] = /obj/item/clothing/gloves/ring/material/iron
	ringtype["ring, bronze"] = /obj/item/clothing/gloves/ring/material/bronze
	ringtype["ring, steel"] = /obj/item/clothing/gloves/ring/material/steel
	ringtype["ring, copper"] = /obj/item/clothing/gloves/ring/material/copper
	ringtype["ring, silver"] = /obj/item/clothing/gloves/ring/material/silver
	ringtype["ring, gold"] = /obj/item/clothing/gloves/ring/material/gold
	ringtype["ring, platinum"] = /obj/item/clothing/gloves/ring/material/platinum

	gear_tweaks += new/datum/gear_tweak/path(ringtype)

/datum/gear/gloves/circuitry
	display_name = "gloves, circuitry (empty)"
	path = /obj/item/clothing/gloves/circuitry