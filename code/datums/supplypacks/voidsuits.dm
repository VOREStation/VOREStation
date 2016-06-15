/*
*	Here is where any supply packs
*	related to voidsuits live.
*/


/datum/supply_packs/voidsuits
	group = "Voidsuits"

/datum/supply_packs/voidsuits/atmos
	name = "Atmospheric voidsuits"
	contains = list(
			/obj/item/clothing/suit/space/void/atmos = 2,
			/obj/item/clothing/head/helmet/space/void/atmos = 2,
			/obj/item/clothing/mask/breath = 2,
			/obj/item/clothing/shoes/magboots = 2,
			/obj/item/weapon/tank/oxygen = 2,
			)
	cost = 45
	containertype = "/obj/structure/closet/crate/secure"
	containername = "Atmospheric voidsuit crate"
	access = access_atmospherics

/datum/supply_packs/voidsuits/engineering
	name = "Engineering voidsuits"
	contains = list(
			/obj/item/clothing/suit/space/void/engineering = 2,
			/obj/item/clothing/head/helmet/space/void/engineering = 2,
			/obj/item/clothing/mask/breath = 2,
			/obj/item/clothing/shoes/magboots = 2,
			/obj/item/weapon/tank/oxygen = 2
			)
	cost = 40
	containertype = "/obj/structure/closet/crate/secure"
	containername = "Engineering voidsuit crate"
	access = access_engine_equip

/datum/supply_packs/voidsuits/medical
	name = "Medical voidsuits"
	contains = list(
			/obj/item/clothing/suit/space/void/medical = 2,
			/obj/item/clothing/head/helmet/space/void/medical = 2,
			/obj/item/clothing/mask/breath = 2,
			/obj/item/clothing/shoes/magboots = 2,
			/obj/item/weapon/tank/oxygen = 2
			)
	cost = 40
	containertype = "/obj/structure/closet/crate/secure"
	containername = "Medical voidsuit crate"
	access = access_medical_equip

/datum/supply_packs/voidsuits/security
	name = "Security voidsuits"
	contains = list(
			/obj/item/clothing/suit/space/void/security = 2,
			/obj/item/clothing/head/helmet/space/void/security = 2,
			/obj/item/clothing/mask/breath = 2,
			/obj/item/clothing/shoes/magboots = 2,
			/obj/item/weapon/tank/oxygen = 2
			)
	cost = 55
	containertype = "/obj/structure/closet/crate/secure"
	containername = "Security voidsuit crate"

/datum/supply_packs/voidsuits/supply
	name = "Mining voidsuits"
	contains = list(
			/obj/item/clothing/suit/space/void/mining = 2,
			/obj/item/clothing/head/helmet/space/void/mining = 2,
			/obj/item/clothing/mask/breath = 2,
			/obj/item/weapon/tank/oxygen = 2
			)
	cost = 35
	containertype = "/obj/structure/closet/crate/secure"
	containername = "Mining voidsuit crate"
	access = access_mining