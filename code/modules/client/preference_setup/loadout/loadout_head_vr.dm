/datum/gear/head/cap/med
	display_name = "cap, medical (Medical)"
	path = /obj/item/clothing/head/soft/med
	allowed_roles = list("Chief Medical Officer","Medical Doctor","Chemist","Psychiatrist","Paramedic")

/*/datum/gear/head/cap/sol
	display_name = "cap, sol"
	path = /obj/item/clothing/head/soft/sol*/

/datum/gear/head/headbando
	display_name = "basic headband"
	path = /obj/item/clothing/head/fluff/headbando

/datum/gear/head/headbando/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/head/maid
	display_name = "maid headband selection"
	path = /obj/item/clothing/head/headband/maid

/datum/gear/head/maid/New()
	..()
	var/list/headbands_list = list()
	for(var/obj/item/clothing/head/bands as anything in typesof(/obj/item/clothing/head/headband/maid))
		headbands_list[initial(bands.name)] = bands
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(headbands_list))

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

/datum/gear/head/magic_hat
	display_name = "wizard hat, colorable"
	path = /obj/item/clothing/head/wizard/fake/realistic/colorable

/datum/gear/head/magic_hat/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/head/wedding
	display_name = "wedding veil"
	path = /obj/item/clothing/head/wedding

/datum/gear/head/wedding/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/head/halo/alt
	display_name = "halo, alt"
	path = /obj/item/clothing/head/halo/alt

/datum/gear/head/buckethat
	display_name = "hat, bucket"
	path = /obj/item/clothing/head/buckethat

/datum/gear/head/buckethat/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/head/nonla
	display_name = "hat, non la"
	path = /obj/item/clothing/head/nonla

/*
Talon hats
*/
/datum/gear/head/cap/talon
	display_name = "cap, Talon"
	path = /obj/item/clothing/head/soft/talon

/datum/gear/head/beret/talon
	display_name = "beret, Talon"
	path = /obj/item/clothing/head/beret
