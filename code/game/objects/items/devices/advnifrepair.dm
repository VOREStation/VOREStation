//Programs nanopaste into NIF repair nanites
/obj/item/nifrepairer
	name = "advanced NIF repair tool"
	desc = "A tool that accepts nanopaste and converts the nanites into NIF repair nanites for injection/ingestion. Insert paste, deposit into container."
	icon = 'icons/obj/device_alt.dmi'
	icon_state = "hydro"
	item_state = "gun"
	slot_flags = SLOT_BELT
	throwforce = 3
	w_class = ITEMSIZE_SMALL
	throw_speed = 5
	throw_range = 10
	matter = list(MAT_STEEL = 4000, MAT_GLASS = 6000)
	origin_tech = list(TECH_MAGNET = 5, TECH_BLUESPACE = 5, TECH_MATERIAL = 5, TECH_ENGINEERING = 5, TECH_DATA = 5)
	var/datum/reagents/supply
	var/efficiency = 15 //How many units reagent per 1 unit nanopaste
	pickup_sound = 'sound/items/pickup/device.ogg'
	drop_sound = 'sound/items/drop/device.ogg'

/obj/item/nifrepairer/Initialize(mapload)
	. = ..()

	supply = new(max = 60, A = src)

/obj/item/nifrepairer/attackby(obj/W, mob/user)
	if(istype(W,/obj/item/stack/nanopaste))
		var/obj/item/stack/nanopaste/np = W
		if((supply.get_free_space() >= efficiency) && np.use(1))
			to_chat(user, span_notice("You convert some nanopaste into programmed nanites inside \the [src]."))
			supply.add_reagent(id = REAGENT_ID_NIFREPAIRNANITES, amount = efficiency)
			update_icon()
		else if(supply.get_free_space() < efficiency)
			to_chat(user, span_warning("\The [src] is too full. Empty it into a container first."))
			return

/obj/item/nifrepairer/update_icon()
	if(supply.total_volume)
		icon_state = "[initial(icon_state)]2"
	else
		icon_state = initial(icon_state)

/obj/item/nifrepairer/afterattack(var/atom/target, var/mob/user, var/proximity)
	if(!target.is_open_container() || !target.reagents)
		return 0

	if(!supply || !supply.total_volume)
		to_chat(user, span_warning("[src] is empty. Feed it nanopaste."))
		return 1

	if(!target.reagents.get_free_space())
		to_chat(user, span_warning("[target] is already full."))
		return 1

	var/trans = supply.trans_to(target, 15)
	to_chat(user, span_notice("You transfer [trans] units of the programmed nanites to [target]."))
	update_icon()
	return 1

/obj/item/nifrepairer/examine(mob/user)
	. = ..()
	if(Adjacent(user))
		if(supply.total_volume)
			. += span_notice("\The [src] contains [supply.total_volume] units of programmed nanites, ready for dispensing.")
		else
			. += span_notice("\The [src] is empty and ready to accept nanopaste.")
