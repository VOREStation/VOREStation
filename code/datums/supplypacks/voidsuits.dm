/*
*	Here is where any supply packs
*	related to voidsuits live.
*/


/datum/supply_pack/voidsuits
	group = "Voidsuits"

/datum/supply_pack/voidsuits/atmos
	name = "Atmospheric voidsuits"
	contains = list(
			/obj/item/clothing/suit/space/void/atmos = 2,
			/obj/item/clothing/head/helmet/space/void/atmos = 2,
			/obj/item/clothing/mask/breath = 2,
			/obj/item/clothing/shoes/magboots = 2,
			/obj/item/weapon/tank/oxygen = 2,
			)
	cost = 40
	containertype = "/obj/structure/closet/crate/secure"
	containername = "Atmospheric voidsuit crate"
	access = access_atmospherics

/datum/supply_pack/voidsuits/atmos/alt
	name = "Heavy Duty Atmospheric voidsuits"
	contains = list(
			/obj/item/clothing/suit/space/void/atmos/alt = 2,
			/obj/item/clothing/head/helmet/space/void/atmos/alt = 2,
			/obj/item/clothing/mask/breath = 2,
			/obj/item/clothing/shoes/magboots = 2,
			/obj/item/weapon/tank/oxygen = 2,
			)
	cost = 50
	containertype = "/obj/structure/closet/crate/secure"
	containername = "Heavy Duty Atmospheric voidsuit crate"
	access = access_atmospherics

/datum/supply_pack/voidsuits/engineering
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

/datum/supply_pack/voidsuits/engineering/construction
	name = "Engineering Construction voidsuits"
	contains = list(
			/obj/item/clothing/suit/space/void/engineering/construction = 2,
			/obj/item/clothing/head/helmet/space/void/engineering/construction = 2,
			/obj/item/clothing/mask/breath = 2,
			/obj/item/clothing/shoes/magboots = 2,
			/obj/item/weapon/tank/oxygen = 2
			)
	cost = 40
	containertype = "/obj/structure/closet/crate/secure"
	containername = "Engineering Construction voidsuit crate"
	access = access_engine_equip

/datum/supply_pack/voidsuits/engineering/hazmat
	name = "Engineering Hazmat voidsuits"
	contains = list(
			/obj/item/clothing/suit/space/void/engineering/hazmat = 2,
			/obj/item/clothing/head/helmet/space/void/engineering/hazmat = 2,
			/obj/item/clothing/mask/breath = 2,
			/obj/item/clothing/shoes/magboots = 2,
			/obj/item/weapon/tank/oxygen = 2
			)
	cost = 45
	containertype = "/obj/structure/closet/crate/secure"
	containername = "Engineering Hazmat voidsuit crate"
	access = access_engine_equip

/datum/supply_pack/voidsuits/engineering/alt
	name = "Reinforced Engineering voidsuits"
	contains = list(
			/obj/item/clothing/suit/space/void/engineering/alt = 2,
			/obj/item/clothing/head/helmet/space/void/engineering/alt = 2,
			/obj/item/clothing/mask/breath = 2,
			/obj/item/clothing/shoes/magboots = 2,
			/obj/item/weapon/tank/oxygen = 2
			)
	cost = 50
	containertype = "/obj/structure/closet/crate/secure"
	containername = "Reinforced Engineering voidsuit crate"
	access = access_engine_equip

/datum/supply_pack/voidsuits/medical
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

/datum/supply_pack/voidsuits/medical/emt
	name = "Medical EMT voidsuits"
	contains = list(
			/obj/item/clothing/suit/space/void/medical/emt = 2,
			/obj/item/clothing/head/helmet/space/void/medical/emt = 2,
			/obj/item/clothing/mask/breath = 2,
			/obj/item/clothing/shoes/magboots = 2,
			/obj/item/weapon/tank/oxygen = 2
			)
	cost = 40
	containertype = "/obj/structure/closet/crate/secure"
	containername = "Medical EMT voidsuit crate"
	access = access_medical_equip

/datum/supply_pack/voidsuits/medical/bio
	name = "Medical Biohazard voidsuits"
	contains = list(
			/obj/item/clothing/suit/space/void/medical/bio = 2,
			/obj/item/clothing/head/helmet/space/void/medical/bio = 2,
			/obj/item/clothing/mask/breath = 2,
			/obj/item/clothing/shoes/magboots = 2,
			/obj/item/weapon/tank/oxygen = 2
			)
	cost = 45
	containertype = "/obj/structure/closet/crate/secure"
	containername = "Medical Biohazard voidsuit crate"
	access = access_medical_equip

/datum/supply_pack/voidsuits/medical/alt
	name = "Vey-Med Medical voidsuits"
	contains = list(
			/obj/item/clothing/suit/space/void/medical/alt = 2,
			/obj/item/clothing/head/helmet/space/void/medical/alt = 2,
			/obj/item/clothing/mask/breath = 2,
			/obj/item/clothing/shoes/magboots = 2,
			/obj/item/weapon/tank/oxygen = 2
			)
	cost = 60
	containertype = "/obj/structure/closet/crate/secure"
	containername = "Vey-Med Medical voidsuit crate"
	access = access_medical_equip

/datum/supply_pack/voidsuits/security
	name = "Security voidsuits"
	contains = list(
			/obj/item/clothing/suit/space/void/security = 2,
			/obj/item/clothing/head/helmet/space/void/security = 2,
			/obj/item/clothing/mask/breath = 2,
			/obj/item/clothing/shoes/magboots = 2,
			/obj/item/weapon/tank/oxygen = 2
			)
	cost = 40
	containertype = "/obj/structure/closet/crate/secure"
	containername = "Security voidsuit crate"

/datum/supply_pack/voidsuits/security/crowd
	name = "Security Crowd Control voidsuits"
	contains = list(
			/obj/item/clothing/suit/space/void/security/riot = 2,
			/obj/item/clothing/head/helmet/space/void/security/riot = 2,
			/obj/item/clothing/mask/breath = 2,
			/obj/item/clothing/shoes/magboots = 2,
			/obj/item/weapon/tank/oxygen = 2
			)
	cost = 40
	containertype = "/obj/structure/closet/crate/secure"
	containername = "Security Crowd Control voidsuit crate"
	access = access_armory

/datum/supply_pack/voidsuits/security/alt
	name = "Security EVA Riot voidsuits"
	contains = list(
			/obj/item/clothing/suit/space/void/security/alt = 2,
			/obj/item/clothing/head/helmet/space/void/security/alt = 2,
			/obj/item/clothing/mask/breath = 2,
			/obj/item/clothing/shoes/magboots = 2,
			/obj/item/weapon/tank/oxygen = 2
			)
	cost = 50
	containertype = "/obj/structure/closet/crate/secure"
	containername = "Security EVA Riot voidsuit crate"
	access = access_armory

/datum/supply_pack/voidsuits/supply
	name = "Mining voidsuits"
	contains = list(
			/obj/item/clothing/suit/space/void/mining = 2,
			/obj/item/clothing/head/helmet/space/void/mining = 2,
			/obj/item/clothing/mask/breath = 2,
			/obj/item/weapon/tank/oxygen = 2
			)
	cost = 40
	containertype = "/obj/structure/closet/crate/secure"
	containername = "Mining voidsuit crate"
	access = access_mining

/datum/supply_pack/voidsuits/supply/alt
	name = "Frontier Mining voidsuits"
	contains = list(
			/obj/item/clothing/suit/space/void/mining/alt = 2,
			/obj/item/clothing/head/helmet/space/void/mining/alt = 2,
			/obj/item/clothing/mask/breath = 2,
			/obj/item/weapon/tank/oxygen = 2
			)
	cost = 50
	containertype = "/obj/structure/closet/crate/secure"
	containername = "Frontier Mining voidsuit crate"
	access = access_mining