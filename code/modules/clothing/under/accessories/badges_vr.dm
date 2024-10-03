/obj/item/clothing/accessory/dosimeter
	name = "dosimeter"
	desc = "A small device used to measure body radiation and warning one after a certain threshold. \
	Read manual before use! Can be held, attached to the uniform or worn around the neck."
	w_class = ITEMSIZE_SMALL
	icon = 'icons/inventory/accessory/item_vr.dmi'
	icon_override = 'icons/inventory/accessory/item_vr.dmi'
	icon_state = "dosimeter"
	item_state = "dosimeter"
	overlay_state = "dosimeter"
	slot_flags = SLOT_TIE
	var/obj/item/dosimeter_film/current_film = null

/obj/item/clothing/accessory/dosimeter/New()
	..()
	current_film = new /obj/item/dosimeter_film(src)
	update_state(current_film.state)
	START_PROCESSING(SSobj, src)

/obj/item/clothing/accessory/dosimeter/Destroy()
	return ..()

/obj/item/clothing/accessory/dosimeter/process()
	check_holder()
	if(current_film.state > 1)
		STOP_PROCESSING(SSobj, src)

/obj/item/clothing/accessory/dosimeter/attack_hand(mob/user as mob)
	if(user.get_inactive_hand() == src)
		if(current_film)
			user.put_in_hands(current_film)
			current_film = null
			to_chat(user, span_notice("You pulled out the film out of \the [src]."))
			desc = "This seems like a dosimeter, but there is no film inside."
			STOP_PROCESSING(SSobj, src)
			update_state(0)
			return
		..()
	else
		return ..()

/obj/item/clothing/accessory/dosimeter/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/dosimeter_film))
		if(!current_film)
			user.drop_item()
			I.loc = src
			current_film = I
			update_state(current_film.state)

			to_chat(user, span_notice("You inserted the film into \the [src]."))
			desc = "This seems like a dosimeter. It has a film inside."

			if(current_film.state < 2)
				START_PROCESSING(SSobj, src)
		else
			to_chat(user, span_notice("\The [src] already has a film inside."))
	else
		return ..()

/obj/item/clothing/accessory/dosimeter/proc/check_holder()
	if(wearer)
		if(current_film && (wearer.radiation >= 25) && (current_film.state == 0))
			update_state(1)
			visible_message(span_warning("The film of \the [src] starts to darken."))
			desc = "This seems like a dosimeter, but the film has darkened."
			sleep(30)
		else if(current_film && (wearer.radiation >= 50) && (current_film.state == 1))
			visible_message(span_warning("The film of \the [src] has turned black!"))
			update_state(2)
			desc = "This seems like a dosimeter, but the film has turned black."

/obj/item/clothing/accessory/dosimeter/proc/update_state(var/tostate)
	if(current_film)
		current_film.state = tostate
		icon_state = "[initial(icon_state)][tostate]"
		current_film.icon_state = "dosimeter_film[tostate]"
	else
		icon_state = "[initial(icon_state)]-empty"
	update_icon()

/obj/item/dosimeter_film
	name = "dosimeter film"
	desc = "These films can be inserted into dosimeters. It turns from white to black, depending on how much radiation it endured."
	w_class = ITEMSIZE_SMALL
	icon = 'icons/inventory/accessory/item_vr.dmi'
	icon_override = 'icons/inventory/accessory/item_vr.dmi'
	icon_state = "dosimeter_film0"
	var/state = 0 //0 - White, 1 - Darker, 2 - Black (same as iconstates)

/obj/item/dosimeter_film/proc/update_state(var/tostate)
	icon_state = tostate
	update_icon()

/obj/item/paper/dosimeter_manual
	name = "Dosimeter manual"
	info = {"<h4>Dosimeter</h4>
	<h5>Usage</h5>
	<ol>
		<li>Insert film into dosimeter.</li>
		<li>Attach dosimeter to clothing or carry it.</li>
		<li>Replace film if current film turned black.</li>
	</ol>
	<br />
	<h5>Purpose</h5>
	<p>This device will let you know about any dangerous radiation levels, that your body is exposed to.
	A white film indicates that everything is alright. A darker film indicates, that the radiation level is starting to get dangerous for your body.
	The body has absorbed too much radiation if the film turned black.</p>"}

/obj/item/storage/box/dosimeter
	name = "dosimeter case"
	desc = "This case can only hold the Dosimeter, a few films and a manual."
	icon = 'icons/inventory/accessory/item_vr.dmi'
	icon_override = 'icons/inventory/accessory/item_vr.dmi'
	icon_state = "dosimeter_case"
	item_state_slots = list(slot_r_hand_str = "syringe_kit", slot_l_hand_str = "syringe_kit")
	storage_slots = 5
	can_hold = list(/obj/item/paper/dosimeter_manual, /obj/item/clothing/accessory/dosimeter, /obj/item/dosimeter_film)
	max_storage_space = (ITEMSIZE_COST_SMALL * 4) + (ITEMSIZE_COST_TINY * 1)
	w_class = ITEMSIZE_SMALL

/obj/item/storage/box/dosimeter/New()
	..()
	new /obj/item/paper/dosimeter_manual(src)
	new /obj/item/clothing/accessory/dosimeter(src)
	new /obj/item/dosimeter_film(src)
	new /obj/item/dosimeter_film(src)
	new /obj/item/dosimeter_film(src)
