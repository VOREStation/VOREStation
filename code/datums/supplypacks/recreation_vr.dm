/*
/datum/supply_pack/recreation/rover
	name = "NT Humvee"
	contains = list(
			/obj/vehicle/train/rover/engine
			)
	containertype = /obj/structure/largecrate
	containername = "NT Humvee Crate"
	cost = 100
*/
/datum/supply_pack/recreation/restraints
	name = "Recreational Restraints"
	contains = list(
			/obj/item/clothing/mask/muzzle,
			/obj/item/clothing/glasses/sunglasses/blindfold,
			/obj/item/weapon/handcuffs/fuzzy,
			/obj/item/weapon/tape_roll,
			/obj/item/stack/cable_coil/random,
			/obj/item/clothing/accessory/collar/shock,
			/obj/item/clothing/suit/straight_jacket,
			/obj/item/weapon/handcuffs/legcuffs/fuzzy,
			/obj/item/weapon/melee/fluff/holochain/mass,
			/obj/item/weapon/material/twohanded/fluff/riding_crop,
			/obj/item/clothing/under/fluff/latexmaid
			)
	containertype = /obj/structure/closet/crate
	containername = "Restraints crate"
	cost = 30

/datum/supply_pack/recreation/wolfgirl_cosplay_crate
	name = "Wolfgirl Cosplay Crate"
	contains = list(
			/obj/item/clothing/head/fluff/wolfgirl = 1,
			/obj/item/clothing/shoes/fluff/wolfgirl = 1,
			/obj/item/clothing/under/fluff/wolfgirl = 1,
			/obj/item/weapon/melee/fluffstuff/wolfgirlsword = 1,
			/obj/item/weapon/shield/fluff/wolfgirlshield = 1
			)
	cost = 50
	containertype = /obj/structure/closet/crate
	containername = "wolfgirl cosplay crate"

/datum/supply_pack/randomised/recreation/figures
	name = "Action figures crate"
	num_contained = 5
	contains = list(
			/obj/random/action_figure/supplypack
			)
	cost = 200
	containertype = /obj/structure/closet/crate
	containername = "Action figures crate"

/datum/supply_pack/recreation/collars
	name = "Collar bundle"
	contains = list(
			/obj/item/clothing/accessory/collar/shock = 1,
			/obj/item/clothing/accessory/collar/spike = 1,
			/obj/item/clothing/accessory/collar/silver = 1,
			/obj/item/clothing/accessory/collar/gold = 1,
			/obj/item/clothing/accessory/collar/bell = 1,
			/obj/item/clothing/accessory/collar/pink = 1,
			/obj/item/clothing/accessory/collar/holo = 1
			)
	cost = 25
	containertype = /obj/structure/closet/crate
	containername = "collar crate"
