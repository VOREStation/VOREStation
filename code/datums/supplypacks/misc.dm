/*
*	Here is where any supply packs
*	that don't belong elsewhere live.
*/


/datum/supply_packs/misc
	group = "Miscellaneous"

/datum/supply_packs/randomised/misc
	group = "Miscellaneous"


/datum/supply_packs/randomised/misc/card_packs
	num_contained = 5
	contains = list(
			/obj/item/weapon/pack/cardemon,
			/obj/item/weapon/pack/spaceball,
			/obj/item/weapon/deck/holder
			)
	name = "Trading Card Crate"
	cost = 10
	containertype = /obj/structure/closet/crate
	containername = "cards crate"

/datum/supply_packs/misc/eftpos
	contains = list(/obj/item/device/eftpos)
	name = "EFTPOS scanner"
	cost = 10
	containertype = /obj/structure/closet/crate
	containername = "EFTPOS crate"

/datum/supply_packs/misc/chaplaingear
	name = "Chaplain equipment"
	contains = list(
			/obj/item/clothing/under/rank/chaplain,
			/obj/item/clothing/shoes/black,
			/obj/item/clothing/suit/nun,
			/obj/item/clothing/head/nun_hood,
			/obj/item/clothing/suit/storage/hooded/chaplain_hoodie,
			/obj/item/clothing/suit/holidaypriest,
			/obj/item/clothing/under/wedding/bride_white,
			/obj/item/weapon/storage/backpack/cultpack,
			/obj/item/weapon/storage/fancy/candle_box = 3
			)
	cost = 10
	containertype = "/obj/structure/closet/crate"
	containername = "Chaplain equipment crate"

/datum/supply_packs/misc/hoverpod
	name = "Hoverpod Shipment"
	contains = list()
	cost = 80
	containertype = /obj/structure/largecrate/hoverpod
	containername = "Hoverpod Crate"

/datum/supply_packs/randomised/misc/webbing
	name = "Webbing crate"
	num_contained = 4
	contains = list(
			/obj/item/clothing/accessory/storage/black_vest,
			/obj/item/clothing/accessory/storage/brown_vest,
			/obj/item/clothing/accessory/storage/white_vest,
			/obj/item/clothing/accessory/storage/black_drop_pouches,
			/obj/item/clothing/accessory/storage/brown_drop_pouches,
			/obj/item/clothing/accessory/storage/white_drop_pouches,
			/obj/item/clothing/accessory/storage/webbing
			)
	cost = 10
	containertype = "/obj/structure/closet/crate"
	containername = "Webbing crate"
