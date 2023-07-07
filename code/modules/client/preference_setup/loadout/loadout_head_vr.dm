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
	display_name = "animal pelt selection"
	description = "Select from a range of (probably, hopefully) synthetic/artificial animal pelts."
	path = /obj/item/clothing/head/pelt

/datum/gear/head/bearpelt/New()
	..()
	var/list/selector_uniforms = list(
		"bear, brown"=/obj/item/clothing/head/pelt,
		"wolf, brown"=/obj/item/clothing/head/pelt/wolfpelt,
		"wolf, black"=/obj/item/clothing/head/pelt/wolfpeltblack,
		"tiger, plain"=/obj/item/clothing/head/pelt/tigerpelt,
		"tiger, white"=/obj/item/clothing/head/pelt/tigerpeltsnow,
		"tiger, pink"=/obj/item/clothing/head/pelt/tigerpeltpink
	)
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(selector_uniforms))

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

// tiny tophat

/datum/gear/head/tiny_tophat
	display_name = "tiny tophat"
	path = /obj/item/clothing/head/tinytophat
