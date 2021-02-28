/*/datum/gear/head/cap/sol
	display_name = "cap, sol"
	path = /obj/item/clothing/head/soft/sol*/

/datum/gear/head/headbando
	display_name = "basic headband"
	path = /obj/item/clothing/head/fluff/headbando

/datum/gear/head/maid
	display_name = "maid headband"
	path = /obj/item/clothing/head/headband/maid

/datum/gear/head/headbando/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

//Detective alternative
/datum/gear/head/detective_alt
	display_name = "cyberscope headgear, detective"
	path = /obj/item/clothing/head/helmet/detective_alt
	allowed_roles = list("Head of Security", "Detective")

/datum/gear/head/bearpelt
	display_name = "brown bear pelt"
	path = /obj/item/clothing/head/pelt

/datum/gear/head/wolfpelt
	display_name = "brown wolf pelt"
	path = /obj/item/clothing/head/pelt/wolfpelt

/datum/gear/head/wolfpeltblack
	display_name = "black wolf pelt"
	path = /obj/item/clothing/head/pelt/wolfpeltblack

/datum/gear/head/tigerpelt
	display_name = "shiny tiger pelt"
	path = /obj/item/clothing/head/pelt/tigerpelt

/datum/gear/head/tigerpeltsnow
	display_name = "snow tiger pelt"
	path = /obj/item/clothing/head/pelt/tigerpeltsnow

/datum/gear/head/tigerpeltpink
	display_name = "pink tiger pelt"
	path = /obj/item/clothing/head/pelt/tigerpeltpink