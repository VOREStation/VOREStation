/obj/machinery/smartfridge/produce
	name = "\improper Smart Produce Storage"
	desc = "For storing all sorts of perishable foods!"
	icon_contents = "boxes"

/obj/machinery/smartfridge/produce/persistent
	persistent = /datum/persistent/storage/smartfridge/produce

/obj/machinery/smartfridge/produce/persistent_lossy
	persistent = /datum/persistent/storage/smartfridge/produce/lossy

/obj/machinery/smartfridge/produce/accept_check(var/obj/item/O as obj)
	if(istype(O,/obj/item/reagent_containers/food/snacks/grown/) || istype(O,/obj/item/seeds/))
		return TRUE
	return FALSE

/obj/machinery/smartfridge/drinks
	name = "\improper Smart Drink Storage"
	desc = "A refrigerated storage unit for tasty tasty alcohol."
	icon_contents = "drinks"

/obj/machinery/smartfridge/drinks/showcase
	name = "\improper Drink Showcase"
	icon_state = "showcase"
	icon_base = "showcase"

/obj/machinery/smartfridge/drinks/accept_check(var/obj/item/O as obj)
	if(istype(O,/obj/item/reagent_containers/glass) || istype(O,/obj/item/reagent_containers/food/drinks) || istype(O,/obj/item/reagent_containers/food/condiment))
		return TRUE
	return FALSE

/obj/machinery/smartfridge/seeds
	name = "\improper MegaSeed Servitor"
	desc = "When you need seeds fast!"
	icon_contents = "boxes"

/obj/machinery/smartfridge/seeds/accept_check(var/obj/item/O as obj)
	if(istype(O,/obj/item/seeds/))
		return 1
	return 0

/obj/machinery/smartfridge/secure/extract
	name = "\improper Biological Sample Storage"
	desc = "A refrigerated storage unit for xenobiological samples."
	req_access = list(access_research)
	icon_contents = "drinks"

/obj/machinery/smartfridge/secure/extract/accept_check(var/obj/item/O as obj)
	if(istype(O, /obj/item/slime_extract))
		return TRUE
	if(istype(O, /obj/item/slimepotion))
		return TRUE
	return FALSE