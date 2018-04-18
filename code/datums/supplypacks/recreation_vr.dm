/*
/datum/supply_packs/recreation/rover
	name = "NT Humvee"
	contains = list(
			/obj/vehicle/train/rover/engine
			)
	containertype = /obj/structure/largecrate
	containername = "NT Humvee Crate"
	cost = 100
*/
/datum/supply_packs/recreation/restraints
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

/datum/supply_packs/recreation/wolfgirl_cosplay_crate
	name = "Wolfgirl Cosplay Crate"
	contains = list(
			/obj/item/clothing/head/fluff/awoo = 1,
			/obj/item/clothing/shoes/fluff/awoo = 1,
			/obj/item/clothing/under/fluff/awoo = 1,
			/obj/item/weapon/melee/fluffstuff/awoosword = 1,
			/obj/item/weapon/shield/fluff/awooshield = 1
			)
	cost = 50
	containertype = /obj/structure/closet/crate
	containername = "wolfgirl cosplay crate"

/datum/supply_packs/randomised/recreation/figures_vr
	name = "Action figures crate"
	num_contained = 5
	contains = list(
			/obj/random/action_figure
			)
	cost = 200
	containertype = /obj/structure/closet/crate
	containername = "Action figures crate"

/datum/supply_packs/recreation/characters_vr
	name = "Tabletop miniatures"
	contains = list(
			/obj/item/weapon/storage/box/characters
			)
	containertype = /obj/structure/closet/crate
	containername = "Tabletop miniatures crate"
	cost = 50

/datum/supply_packs/randomised/recreation/plushies_vr
	name = "Plushies crate"
	num_contained = 3
	contains = list(
			/obj/random/plushie
			)
	cost = 60
	containertype = /obj/structure/closet/crate
	containername = "Plushies crate"