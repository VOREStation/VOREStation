/obj/machinery/smartfridge/produce
	name = "\improper Smart Produce Storage"
	desc = "For storing all sorts of perishable foods!"
	icon = 'icons/obj/vending.dmi'
	icon_state = "fridge_food"
	icon_base = "fridge_food"
	icon_contents = "food"

/obj/machinery/smartfridge/produce/persistent
	persistent = /datum/persistent/storage/smartfridge/produce

/obj/machinery/smartfridge/produce/persistent_lossy
	persistent = /datum/persistent/storage/smartfridge/produce/lossy

/obj/machinery/smartfridge/produce/accept_check(var/obj/item/O as obj)
	if(istype(O,/obj/item/weapon/reagent_containers/food/snacks/grown/) || istype(O,/obj/item/seeds/))
		return TRUE
	return FALSE

/obj/machinery/smartfridge/drinks
	name = "\improper Drink Showcase"
	desc = "A refrigerated storage unit for tasty tasty alcohol."
	icon_state = "fridge_drinks"
	icon_base = "fridge_drinks"
	icon_contents = "drink"

/obj/machinery/smartfridge/drinks/accept_check(var/obj/item/O as obj)
	if(istype(O,/obj/item/weapon/reagent_containers/glass) || istype(O,/obj/item/weapon/reagent_containers/food/drinks) || istype(O,/obj/item/weapon/reagent_containers/food/condiment))
		return TRUE
	return FALSE

/obj/machinery/smartfridge/seeds
	name = "\improper MegaSeed Servitor"
	desc = "When you need seeds fast!"
	icon_contents = "chem"

/obj/machinery/smartfridge/seeds/accept_check(var/obj/item/O as obj)
	if(istype(O,/obj/item/seeds/))
		return 1
	return 0

/obj/machinery/smartfridge/secure/extract
	name = "\improper Biological Sample Storage"
	desc = "A refrigerated storage unit for xenobiological samples."
	icon_contents = "slime"
	req_access = list(access_research)

/obj/machinery/smartfridge/secure/extract/accept_check(var/obj/item/O as obj)
	if(istype(O, /obj/item/slime_extract))
		return TRUE
	if(istype(O, /obj/item/slimepotion))
		return TRUE
	return FALSE