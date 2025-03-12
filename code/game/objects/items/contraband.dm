// Let's get some REAL contraband stuff in here. Because come on, getting brigged for LIPSTICK is no fun.
//
// Includes drug powder.
//
// Illicit drugs~
/obj/item/storage/pill_bottle/happy
	name = "bottle of Happy pills"
	desc = "Highly illegal drug. When you want to see the rainbow."
	wrapper_color = COLOR_PINK
	starts_with = list(/obj/item/reagent_containers/pill/happy = 7)

/obj/item/storage/pill_bottle/zoom
	name = "bottle of Zoom pills"
	desc = "Highly illegal drug. Trade brain for speed."
	wrapper_color = COLOR_BLUE
	starts_with = list(/obj/item/reagent_containers/pill/zoom = 7)

/obj/item/reagent_containers/glass/beaker/vial/random
	flags = 0
	var/list/random_reagent_list = list(list(REAGENT_ID_WATER = 15) = 1, list(REAGENT_ID_CLEANER = 15) = 1)

/obj/item/reagent_containers/glass/beaker/vial/random/toxin
	random_reagent_list = list(
		list(REAGENT_ID_MINDBREAKER = 10, REAGENT_ID_BLISS = 20)	= 3,
		list(REAGENT_ID_CARPOTOXIN = 15)							= 2,
		list(REAGENT_ID_IMPEDREZENE = 15)						= 2,
		list(REAGENT_ID_ZOMBIEPOWDER = 10)						= 1)

/obj/item/reagent_containers/glass/beaker/vial/random/Initialize(mapload)
	. = ..()
	if(is_open_container())
		flags ^= OPENCONTAINER

	var/list/picked_reagents = pickweight(random_reagent_list)
	for(var/reagent in picked_reagents)
		reagents.add_reagent(reagent, picked_reagents[reagent])

	var/list/names = new
	for(var/datum/reagent/R in reagents.reagent_list)
		names += R.name

	desc = "Contains [english_list(names)]."
	update_icon()

//
// Drug Powder
//
/obj/item/reagent_containers/powder
	name = "powder"
	desc = "A powdered form of... something."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "powder"
	item_state = "powder"
	amount_per_transfer_from_this = 2
	possible_transfer_amounts = 2
	w_class = ITEMSIZE_TINY
	volume = 50

/obj/item/reagent_containers/powder/examine(mob/user)
	if(reagents)
		var/datum/reagent/R = reagents.get_master_reagent()
		desc = "A powdered form of what appears to be [R.name]. There's about [reagents.total_volume] units here."
	return ..()

/obj/item/reagent_containers/powder/Initialize(mapload)
	. = ..()
	get_appearance()

/obj/item/reagent_containers/powder/proc/get_appearance()
	/// Names and colors based on dominant reagent.
	if (reagents.reagent_list.len > 0)
		color = reagents.get_color()
		var/datum/reagent/R = reagents.get_master_reagent()
		var/new_name = lowertext(R)
		name = "powdered [new_name]"

/// Snorting.

/obj/item/reagent_containers/powder/attackby(var/obj/item/W, var/mob/living/user)

	if(!ishuman(user)) /// You gotta be fleshy to snort the naughty drugs.
		return ..()

	if(!istype(W, /obj/item/glass_extra/straw) && !istype(W, /obj/item/reagent_containers/rollingpaper))
		return ..()

	user.visible_message(span_warning("[user] snorts [src] with [W]!"))
	playsound(loc, 'sound/effects/snort.ogg', 50, 1)

	if(reagents)
		reagents.trans_to_mob(user, amount_per_transfer_from_this, CHEM_BLOOD)

	if(!reagents.total_volume) /// Did we use all of it?
		qdel(src)

////// End powder. /////////
