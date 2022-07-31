/datum/gear/gloves/goldring
	display_name = "wedding ring, gold"
	path = /obj/item/clothing/gloves/ring/wedding

/datum/gear/gloves/silverring
	display_name = "wedding ring, silver"
	path = /obj/item/clothing/gloves/ring/wedding/silver

/datum/gear/gloves/colored
	display_name = "gloves, colorable"
	path = /obj/item/clothing/gloves/color

/datum/gear/gloves/colored/Initialize()
	. = ..()
	gear_tweaks += gear_tweak_free_color_choice


/datum/gear/gloves/latex/colorable
	display_name = "gloves, latex, colorable"
	path = /obj/item/clothing/gloves/sterile/latex

/datum/gear/gloves/latex/colorable/Initialize()
	. = ..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/gloves/siren
	display_name = "gloves, Siren"
	path = /obj/item/clothing/gloves/fluff/siren
