// Gloves
/datum/gear/gloves
	display_name = "gloves, black"
	path = /obj/item/clothing/gloves/black
	cost = 1
	slot = slot_gloves
	sort_category = "Gloves and Handwear"

/datum/gear/gloves/blue
	display_name = "gloves, blue"
	path = /obj/item/clothing/gloves/blue

/datum/gear/gloves/brown
	display_name = "gloves, brown"
	path = /obj/item/clothing/gloves/brown

/datum/gear/gloves/light_brown
	display_name = "gloves, light-brown"
	path = /obj/item/clothing/gloves/light_brown

/datum/gear/gloves/green
	display_name = "gloves, green"
	path = /obj/item/clothing/gloves/green

/datum/gear/gloves/grey
	display_name = "gloves, grey"
	path = /obj/item/clothing/gloves/grey

/datum/gear/gloves/latex
	display_name = "gloves, latex"
	path = /obj/item/clothing/gloves/sterile/latex
	cost = 2

/datum/gear/gloves/nitrile
	display_name = "gloves, nitrile"
	path = /obj/item/clothing/gloves/sterile/nitrile
	cost = 2

/datum/gear/gloves/orange
	display_name = "gloves, orange"
	path = /obj/item/clothing/gloves/orange

/datum/gear/gloves/purple
	display_name = "gloves, purple"
	path = /obj/item/clothing/gloves/purple

/datum/gear/gloves/rainbow
	display_name = "gloves, rainbow"
	path = /obj/item/clothing/gloves/rainbow

/datum/gear/gloves/red
	display_name = "gloves, red"
	path = /obj/item/clothing/gloves/red

/datum/gear/gloves/white
	display_name = "gloves, white"
	path = /obj/item/clothing/gloves/white

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
	path = /obj/item/clothing/gloves/fingerless

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