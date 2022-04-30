/datum/gear/contraband
	display_name = "ambrosia box"
	description = "A box of a familiar plant."
	path = /obj/item/storage/box/ambrosia_grown
	cost = 1
	sort_category = "Contraband"

/datum/gear/contraband/pills
	display_name = "unlabeled pill bottle"
	description = "A pill bottle of more... recreational sorts."
	path = /obj/item/storage/pill_bottle
	cost = 2

/datum/gear/contraband/pills/New()
	..()
	var/drug_type = list()
	drug_type["Bliss"] = /obj/item/storage/pill_bottle/bliss
	drug_type["Snowflake"] = /obj/item/storage/pill_bottle/snowflake
	drug_type["Royale"] = /obj/item/storage/pill_bottle/royale
	drug_type["Sinkhole"] = /obj/item/storage/pill_bottle/sinkhole
	drug_type["Colorspace"] = /obj/item/storage/pill_bottle/colorspace
	drug_type["Schnappi"] = /obj/item/storage/pill_bottle/schnappi
	gear_tweaks += new/datum/gear_tweak/path(drug_type)

/datum/gear/contraband/rollingpaper
	display_name = "rolling papers"
	description = "Paper for rolling various smokeables. Now you just need something to roll up inside..."
	path = /obj/item/storage/rollingpapers
	cost = 1

/datum/gear/contraband/rollingpaper/New()
	..()
	var/paperselect = list("rolling papers" = /obj/item/storage/rollingpapers,
							"blunt wrappers" = /obj/item/storage/rollingpapers/blunt)
	gear_tweaks += new/datum/gear_tweak/path(paperselect)