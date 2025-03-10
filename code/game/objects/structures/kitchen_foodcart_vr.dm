/obj/structure/foodcart
	name = "Foodcart"
	icon = 'icons/obj/kitchen_vr.dmi'
	icon_state = "foodcart-0"
	desc = "The ultimate in food transport! When opened you notice two compartments with odd blue glows to them. One feels very warm, while the other is very cold."
	anchored = FALSE
	opacity = 0
	density = TRUE

/obj/structure/foodcart/Initialize(mapload)
	. = ..()
	for(var/obj/item/I in loc)
		if(istype(I, /obj/item/reagent_containers/food))
			I.loc = src
	update_icon()

/obj/structure/foodcart/attackby(obj/item/O as obj, mob/user as mob)
	if(istype(O, /obj/item/reagent_containers/food))
		user.drop_item()
		O.loc = src
		update_icon()
	else
		return

/obj/structure/foodcart/attack_hand(var/mob/user as mob)
	if(contents.len)
		var/obj/item/reagent_containers/food/choice = tgui_input_list(user, "What would you like to grab from the cart?", "Grab Choice", contents)
		if(choice)
			if(!user.canmove || user.stat || user.restrained() || !in_range(loc, user))
				return
			if(ishuman(user))
				if(!user.get_active_hand())
					user.put_in_hands(choice)
			else
				choice.loc = get_turf(src)
			update_icon()

/obj/structure/foodcart/update_icon()
	if(contents.len < 5)
		icon_state = "foodcart-[contents.len]"
	else
		icon_state = "foodcart-5"
