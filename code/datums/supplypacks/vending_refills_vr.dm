/datum/supply_pack/vending_refills
	group = "Vendor Refills"
	containertype = /obj/structure/closet/crate/plastic
	containername = "vendor refill cartridge crate"

/datum/supply_pack/randomised/vending_refills
	group = "Vendor Refills"
	containertype = /obj/structure/closet/crate/plastic
	containername = "vendor refill cartridge crate"

/datum/supply_pack/vending_refills/snack
	contains = list(/obj/item/refill_cartridge/autoname/food/snack)
	name = "Getmore Chocolate Corp Vendor Refill Cartridge"
	cost = 10

/datum/supply_pack/vending_refills/fitness
	contains = list(/obj/item/refill_cartridge/autoname/food/fitness)
	name = "SweatMAX Vendor Refill Cartridge"
	cost = 10

/datum/supply_pack/vending_refills/hotfood
	contains = list(/obj/item/refill_cartridge/autoname/food/hotfood)
	name = "Hot Foods Vendor Refill Cartridge"
	cost = 10

/datum/supply_pack/vending_refills/weeb
	contains = list(/obj/item/refill_cartridge/autoname/food/weeb)
	name = "Nippon-tan Vendor Refill Cartridge"
	cost = 10

/datum/supply_pack/vending_refills/sol
	contains = list(/obj/item/refill_cartridge/autoname/food/sol)
	name = "Sol-Snacks Vendor Refill Cartridge"
	cost = 10

/datum/supply_pack/vending_refills/snix
	contains = list(/obj/item/refill_cartridge/autoname/food/snix)
	name = "Snix Vendor Refill Cartridge"
	cost = 10

/datum/supply_pack/vending_refills/snlvend
	contains = list(/obj/item/refill_cartridge/autoname/food/snlvend)
	name = "Shop-n-Large Snacks Vendor Refill Cartridge"
	cost = 10

/datum/supply_pack/vending_refills/sovietvend
	contains = list(/obj/item/refill_cartridge/autoname/food/sovietvend)
	name = "Ration Station Vendor Refill Cartridge"
	cost = 10

/datum/supply_pack/vending_refills/coffee
	contains = list(/obj/item/refill_cartridge/autoname/drink/coffee)
	name = "Hot Drinks Vendor Refill Cartridge"
	cost = 10

/datum/supply_pack/vending_refills/cola
	contains = list(/obj/item/refill_cartridge/autoname/drink/cola)
	name = "Robust Softdrinks Vendor Refill Cartridge"
	cost = 10

/datum/supply_pack/vending_refills/cola_soft
	contains = list(/obj/item/refill_cartridge/autoname/drink/cola_soft)
	name = "Soft Robustdrinks Vendor Refill Cartridge"
	cost = 10

/datum/supply_pack/vending_refills/sovietsoda
	contains = list(/obj/item/refill_cartridge/autoname/drink/sovietsoda)
	name = "BODA Vendor Refill Cartridge"
	cost = 10

/datum/supply_pack/vending_refills/bepis
	contains = list(/obj/item/refill_cartridge/autoname/drink/bepis)
	name = "Bepis Softdrinks Vendor Refill Cartridge"
	cost = 10

/datum/supply_pack/vending_refills/cigarette
	contains = list(/obj/item/refill_cartridge/autoname/cigarette)
	name = "Cigarette Vendor Refill Cartridge"
	cost = 15

/datum/supply_pack/vending_refills/wardrobe
	contains = list(/obj/item/refill_cartridge/multitype/wardrobe)
	name = "Wardrobe Vendor Refill Cartridge"
	cost = 10

/datum/supply_pack/vending_refills/giftvendor
	contains = list(/obj/item/refill_cartridge/autoname/giftvendor)
	name = "AlliCo Baubles and Confectionaries Vendor Refill Cartridge"
	cost = 20

/datum/supply_pack/vending_refills/general_food
	contains = list(/obj/item/refill_cartridge/multitype/food = 5)
	name = "5-Pack Food Vendor Refill Cartridges"
	cost = 75

/datum/supply_pack/vending_refills/general_drink
	contains = list(/obj/item/refill_cartridge/multitype/drink = 5)
	name = "5-Pack Drink Vendor Refill Cartridges"
	cost = 75

/datum/supply_pack/vending_refills/general_clothing
	contains = list(/obj/item/refill_cartridge/multitype/clothing = 5)
	name = "5-Pack Clothing Vendor Refill Cartridges"
	cost = 75

/datum/supply_pack/vending_refills/general_technical
	contains = list(/obj/item/refill_cartridge/multitype/technical = 5)
	name = "5-Pack Technical Vendor Refill Cartridges"
	cost = 75

/datum/supply_pack/vending_refills/general_specialty
	contains = list(/obj/item/refill_cartridge/multitype/specialty = 5)
	name = "5-Pack Specialty Vendor Refill Cartridges"
	cost = 150

/datum/supply_pack/randomised/vending_refills/value_pack			// 5 random vendor-specific cartridges at lower average price. But why?
	num_contained = 5
	contains = list(/obj/item/refill_cartridge/autoname/food/snack,
					/obj/item/refill_cartridge/autoname/food/fitness,
					/obj/item/refill_cartridge/autoname/food/hotfood,
					/obj/item/refill_cartridge/autoname/food/weeb,
					/obj/item/refill_cartridge/autoname/food/sol,
					/obj/item/refill_cartridge/autoname/food/snix,
					/obj/item/refill_cartridge/autoname/food/snlvend,
					/obj/item/refill_cartridge/autoname/food/sovietvend,
					/obj/item/refill_cartridge/autoname/drink/coffee,
					/obj/item/refill_cartridge/autoname/drink/cola,
					/obj/item/refill_cartridge/autoname/drink/cola_soft,
					/obj/item/refill_cartridge/autoname/drink/sovietsoda,
					/obj/item/refill_cartridge/autoname/drink/bepis,
					/obj/item/refill_cartridge/autoname/cigarette,
					/obj/item/refill_cartridge/multitype/wardrobe,
					/obj/item/refill_cartridge/autoname/technical/assist,
					/obj/item/refill_cartridge/autoname/technical/tool,
					/obj/item/refill_cartridge/autoname/giftvendor)
	name = "5-pack Extra-Cheap Vendor Refill Cartridges"
	cost = 35
