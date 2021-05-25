/datum/supply_pack/voidsuits/atmos
	contains = list(
			/obj/item/clothing/suit/space/void/atmos = 3,
			/obj/item/clothing/head/helmet/space/void/atmos = 3,
			/obj/item/clothing/mask/breath = 3,
			/obj/item/clothing/shoes/magboots = 3,
			/obj/item/weapon/tank/oxygen = 3,
			)

/datum/supply_pack/voidsuits/engineering
	contains = list(
			/obj/item/clothing/suit/space/void/engineering = 3,
			/obj/item/clothing/head/helmet/space/void/engineering = 3,
			/obj/item/clothing/mask/breath = 3,
			/obj/item/clothing/shoes/magboots = 3,
			/obj/item/weapon/tank/oxygen = 3
			)

/datum/supply_pack/voidsuits/medical
	contains = list(
			/obj/item/clothing/suit/space/void/medical = 3,
			/obj/item/clothing/head/helmet/space/void/medical = 3,
			/obj/item/clothing/mask/breath = 3,
			/obj/item/clothing/shoes/magboots = 3,
			/obj/item/weapon/tank/oxygen = 3
			)

/datum/supply_pack/voidsuits/medical/alt
	contains = list(
			/obj/item/clothing/suit/space/void/medical/alt = 3,
			/obj/item/clothing/head/helmet/space/void/medical/alt = 3,
			/obj/item/clothing/mask/breath = 3,
			/obj/item/clothing/shoes/magboots = 3,
			/obj/item/weapon/tank/oxygen = 3
			)

/datum/supply_pack/voidsuits/security
	contains = list(
			/obj/item/clothing/suit/space/void/security = 3,
			/obj/item/clothing/head/helmet/space/void/security = 3,
			/obj/item/clothing/mask/breath = 3,
			/obj/item/clothing/shoes/magboots = 3,
			/obj/item/weapon/tank/oxygen = 3
			)

/datum/supply_pack/voidsuits/security/crowd
	contains = list(
			/obj/item/clothing/suit/space/void/security/riot = 3,
			/obj/item/clothing/head/helmet/space/void/security/riot = 3,
			/obj/item/clothing/mask/breath = 3,
			/obj/item/clothing/shoes/magboots = 3,
			/obj/item/weapon/tank/oxygen = 3
			)

/datum/supply_pack/voidsuits/security/alt
	contains = list(
			/obj/item/clothing/suit/space/void/security/alt = 3,
			/obj/item/clothing/head/helmet/space/void/security/alt = 3,
			/obj/item/clothing/mask/breath = 3,
			/obj/item/clothing/shoes/magboots = 3,
			/obj/item/weapon/tank/oxygen = 3
			)

/datum/supply_pack/voidsuits/supply
	contains = list(
			/obj/item/clothing/suit/space/void/mining = 3,
			/obj/item/clothing/head/helmet/space/void/mining = 3,
			/obj/item/clothing/mask/breath = 3,
			/obj/item/weapon/tank/oxygen = 3
			)

/datum/supply_pack/voidsuits/explorer
	name = "Exploration voidsuits"
	contains = list(
			/obj/item/clothing/suit/space/void/exploration = 3,
			/obj/item/clothing/head/helmet/space/void/exploration = 3,
			/obj/item/clothing/mask/breath = 3,
			/obj/item/clothing/shoes/magboots = 3,
			/obj/item/weapon/tank/oxygen = 3
			)
	cost = 50
	containertype = /obj/structure/closet/crate/secure
	containername = "Exploration voidsuit crate"
	access = access_explorer

/datum/supply_pack/voidsuits/explorer_medic
	name = "Expedition Medic voidsuits"
	contains = list(
			/obj/item/clothing/suit/space/void/exploration = 2,
			/obj/item/clothing/head/helmet/space/void/exploration = 2,
			/obj/item/clothing/mask/breath = 2,
			/obj/item/clothing/shoes/magboots = 2,
			/obj/item/weapon/tank/oxygen = 2
			)
	cost = 35
	containertype = /obj/structure/closet/crate/secure
	containername = "Expedition Medic voidsuit crate"
	access = access_explorer

/datum/supply_pack/voidsuits/pilot
	name = "Pilot voidsuits"
	contains = list(
			/obj/item/clothing/suit/space/void/pilot = 1,
			/obj/item/clothing/head/helmet/space/void/pilot = 1,
			/obj/item/clothing/mask/breath = 1,
			/obj/item/clothing/shoes/magboots = 1,
			/obj/item/weapon/tank/oxygen = 1
			)
	cost = 20
	containertype = /obj/structure/closet/crate/secure
	containername = "Pilot voidsuit crate"
	access = access_pilot