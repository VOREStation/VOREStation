/obj/item/refill_cartridge
	name = "vending refill cartridge"
	desc = "A specialized cartridge used to refill vending machines with fresh product. Tamper proof."
	icon = 'icons/obj/refill_cartridges.dmi'
	icon_state = "rc_generic"
	item_state = "syringe_kit"
	var/refill_type
	var/exact_type = TRUE

/obj/item/refill_cartridge/proc/can_refill(obj/machinery/vending/V as obj)
	if(exact_type)
		if(V.type == refill_type)
			return TRUE
	else
		if(istype(V, refill_type))
			return TRUE
	return FALSE

/obj/item/refill_cartridge/multitype
	refill_type = list()
	var/refill_exceptions = list()

/obj/item/refill_cartridge/multitype/can_refill(obj/machinery/vending/V as obj)
	for(var/entry in refill_type)
		if(istype(V, entry) && !(V.type in refill_exceptions))
			return TRUE
	return FALSE

/obj/item/refill_cartridge/autoname/Initialize()
	..()
	if(refill_type && ispath(refill_type))
		var/atom/tmp = refill_type
		src.name = "[initial(tmp.name)] refill cartridge"

/obj/item/refill_cartridge/universal		// For admin/event use. Can refill any refillable vendor.
	name = "ultimate vending refill cartridge"
	desc = "A universal cartridge used to refill vending machines with fresh product."
	icon_state = "rc_mystery"

/obj/item/refill_cartridge/universal/can_refill(obj/machinery/vending/V as obj)
	return TRUE

// Multi-vendor subtypes

/obj/item/refill_cartridge/multitype/technical
	name = "technical vendor refill cartridge"
	icon_state = "rc_mechanical"
	refill_type = list(/obj/machinery/vending/assist,
					   /obj/machinery/vending/tool,
					   /obj/machinery/vending/loadout/gadget)

/obj/item/refill_cartridge/multitype/food
	name = "food vendor refill cartridge"
	icon_state = "rc_food"
	refill_type = list(/obj/machinery/vending/snack,
					   /obj/machinery/vending/fitness,
					   /obj/machinery/vending/weeb,
					   /obj/machinery/vending/sol,
					   /obj/machinery/vending/snix,
					   /obj/machinery/vending/snlvend,
					   /obj/machinery/vending/sovietvend,
					   /obj/machinery/vending/altevian)

/obj/item/refill_cartridge/multitype/drink
	name = "drinks vendor refill cartridge"
	icon_state = "rc_drink"
	refill_type = list(/obj/machinery/vending/coffee,
					   /obj/machinery/vending/cola,
					   /obj/machinery/vending/sovietsoda,
					   /obj/machinery/vending/bepis)

/obj/item/refill_cartridge/multitype/smokes			//Multitype version in case multiple smoke machine vendors exist in future.
	name = "smoking vendor refill cartridge"
	icon_state = "rc_generic"
	refill_type = list(/obj/machinery/vending/cigarette)

/obj/item/refill_cartridge/multitype/clothing
	name = "clothing vendor refill cartridge"
	icon_state = "rc_clothes"
	refill_type = list(/obj/machinery/vending/wardrobe,
					   /obj/machinery/vending/loadout)
	refill_exceptions = list(/obj/machinery/vending/loadout/gadget)

/obj/item/refill_cartridge/multitype/specialty
	name = "specialty vendor refill cartridge"
	icon_state = "rc_generic"
	refill_type = list(/obj/machinery/vending/cart,
					   /obj/machinery/vending/medical,
					   /obj/machinery/vending/phoronresearch,
					   /obj/machinery/vending/wallmed1,
					   /obj/machinery/vending/wallmed2,
					   /obj/machinery/vending/wallmed_airlock,
					   /obj/machinery/vending/security,
					   /obj/machinery/vending/hydronutrients,
					   /obj/machinery/vending/dinnerware,
					   /obj/machinery/vending/engivend,
					   /obj/machinery/vending/robotics,
					   /obj/machinery/vending/fishing,
					   /obj/machinery/vending/blood,
					   /obj/machinery/vending/entertainer)

/obj/item/refill_cartridge/autoname/food
	icon_state = "rc_food"

/obj/item/refill_cartridge/autoname/food/snack
	refill_type = /obj/machinery/vending/snack

/obj/item/refill_cartridge/autoname/food/fitness
	refill_type = /obj/machinery/vending/fitness

/obj/item/refill_cartridge/autoname/food/weeb
	refill_type = /obj/machinery/vending/weeb

/obj/item/refill_cartridge/autoname/food/sol
	refill_type = /obj/machinery/vending/sol

/obj/item/refill_cartridge/autoname/food/snix
	refill_type = /obj/machinery/vending/snix

/obj/item/refill_cartridge/autoname/food/snlvend
	refill_type = /obj/machinery/vending/snlvend

/obj/item/refill_cartridge/autoname/food/sovietvend
	refill_type = /obj/machinery/vending/sovietvend

/obj/item/refill_cartridge/autoname/food/altevian
	refill_type = /obj/machinery/vending/altevian

/obj/item/refill_cartridge/autoname/drink
	icon_state = "rc_drink"

/obj/item/refill_cartridge/autoname/drink/coffee
	refill_type = /obj/machinery/vending/coffee

/obj/item/refill_cartridge/autoname/drink/cola
	refill_type = /obj/machinery/vending/cola
	exact_type = FALSE

/obj/item/refill_cartridge/autoname/drink/sovietsoda
	refill_type = /obj/machinery/vending/sovietsoda

/obj/item/refill_cartridge/autoname/drink/bepis
	refill_type = /obj/machinery/vending/bepis

/obj/item/refill_cartridge/autoname/cigarette
	icon_state = "rc_generic"
	refill_type = /obj/machinery/vending/cigarette

/obj/item/refill_cartridge/multitype/wardrobe
	name = "specialized wardrobe refill cartridge"
	icon_state = "rc_clothes"
	refill_type = list(/obj/machinery/vending/wardrobe)

/obj/item/refill_cartridge/autoname/technical
	icon_state = "rc_mechanical"

/obj/item/refill_cartridge/autoname/technical/assist
	refill_type = /obj/machinery/vending/assist

/obj/item/refill_cartridge/autoname/technical/tool
	refill_type = /obj/machinery/vending/tool

/obj/item/refill_cartridge/autoname/giftvendor
	refill_type = /obj/machinery/vending/giftvendor
