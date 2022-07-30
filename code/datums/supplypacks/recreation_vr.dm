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
			/obj/item/handcuffs/fuzzy,
			/obj/item/tape_roll,
			/obj/item/stack/cable_coil/random,
			/obj/item/clothing/accessory/collar/shock,
			/obj/item/clothing/suit/straight_jacket,
			/obj/item/handcuffs/legcuffs/fuzzy,
			/obj/item/melee/fluff/holochain/mass,
			/obj/item/material/twohanded/riding_crop,
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
			/obj/item/melee/fluffstuff/wolfgirlsword = 1,
			/obj/item/shield/fluff/wolfgirlshield = 1
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

/datum/supply_pack/recreation/shiny
	name = "Shiny Clothing"
	contains = list(
			/obj/item/clothing/mask/muzzle/ballgag = 1,
			/obj/item/clothing/mask/muzzle/ballgag/ringgag = 1,
			/obj/item/clothing/head/shiny_hood = 1,
			/obj/item/clothing/head/shiny_hood/poly = 1,
			/obj/item/clothing/head/shiny_hood/closed = 1,
			/obj/item/clothing/head/shiny_hood/closed/poly = 1,
			/obj/item/clothing/under/shiny/catsuit = 1,
			/obj/item/clothing/under/shiny/catsuit/poly = 1,
			/obj/item/clothing/under/shiny/leotard = 1,
			/obj/item/clothing/under/shiny/leotard/poly = 1,
			/obj/item/clothing/accessory/shiny/gloves = 1,
			/obj/item/clothing/accessory/shiny/gloves/poly = 1,
			/obj/item/clothing/accessory/shiny/socks = 1,
			/obj/item/clothing/accessory/shiny/socks/poly = 1
			)
	containertype = /obj/structure/closet/crate
	containername = "Shiny clothes crate"
	cost = 30

//3/19/21
/datum/supply_pack/recreation/smoleworld
	name = "Smole Bulding Bricks"
	contains = list(
			/obj/item/storage/smolebrickcase, /obj/item/storage/smolebrickcase,
			)
	cost = 50
	containertype = /obj/structure/closet/crate
	containername = "Smole Bulding Brick crate"

/datum/supply_pack/recreation/smolesnackplanets
	name = "Snack planets pack"
	num_contained = 4
	contains = list(
			/obj/item/storage/bagoplanets, /obj/item/storage/bagoplanets
			)
	cost = 25
	containertype = /obj/structure/closet/crate
	containername = "Snack planets crate"
