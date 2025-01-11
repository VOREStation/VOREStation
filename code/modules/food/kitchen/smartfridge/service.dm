/*
 * Chef
 */
/obj/machinery/smartfridge/chef
	desc = "For storing all sorts of delicious foods!"

/obj/machinery/smartfridge/chef/accept_check(var/obj/item/O as obj)
	if(istype(O,/obj/item/reagent_containers/food/snacks))
		return TRUE
	return FALSE

/*
 * Bartender
 */
/obj/machinery/smartfridge/drinks
	name = "\improper Smart Drink Storage"
	desc = "A refrigerated storage unit for tasty tasty alcohol."
	icon_contents = "drinks"

/obj/machinery/smartfridge/drinks/accept_check(var/obj/item/O as obj)
	if(istype(O,/obj/item/reagent_containers/glass) || istype(O,/obj/item/reagent_containers/food/drinks) || istype(O,/obj/item/reagent_containers/food/condiment))
		return TRUE
	return FALSE

/obj/machinery/smartfridge/drinks/showcase
	name = "\improper Drink Showcase"
	icon_state = "base_showcase"
	icon_base = "showcase"

//Showcase needs a special icon update
/obj/machinery/smartfridge/drinks/showcase/update_icon()
	cut_overlays()
	if(panel_open)
		add_overlay("[icon_base]-panel")

	if(stat & (BROKEN))
		cut_overlays()
		icon_state = "[icon_base]-broken"

	if(stat & (NOPOWER))
		icon_state = "[icon_base]-off"
	else
		icon_state = icon_base
		switch(contents.len)
			if(0)
				add_overlay("[icon_base]")
			if(1 to 3)
				add_overlay("[icon_base]-fill")

/*
 * Hydroponics
 */
/obj/machinery/smartfridge/produce
	name = "\improper Smart Produce Storage"
	desc = "For storing all sorts of perishable produce!"
	icon_contents = "plants"

/obj/machinery/smartfridge/produce/persistent
	persistent = /datum/persistent/storage/smartfridge/produce

/obj/machinery/smartfridge/produce/persistent_lossy
	persistent = /datum/persistent/storage/smartfridge/produce/lossy

/obj/machinery/smartfridge/produce/accept_check(var/obj/item/O as obj)
	if(istype(O,/obj/item/reagent_containers/food/snacks/grown/) || istype(O,/obj/item/seeds/))
		return TRUE
	return FALSE

/obj/machinery/smartfridge/seeds //I honestly don't know why this exists when you can store seeds in the vendor. It's not even persistent.
	name = "\improper MegaSeed Servitor"
	desc = "When you need seeds fast!"
	icon_contents = "petri" //There's no seed base in the current batch

/obj/machinery/smartfridge/seeds/accept_check(var/obj/item/O as obj)
	if(istype(O,/obj/item/seeds/))
		return TRUE
	return FALSE
