/*/datum/gear/head/cap/sol
	display_name = "cap, sol"
	path = /obj/item/clothing/head/soft/sol*/

/datum/gear/head/headbando
	display_name = "Basic Headband"
	path = /obj/item/clothing/head/fluff/headbando

/datum/gear/head/headbando/New()
	..()
	gear_tweaks = list(gear_tweak_free_color_choice)