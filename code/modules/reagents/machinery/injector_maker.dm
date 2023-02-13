/obj/machinery/injector_maker
	name = "Ready-to-Use Medicine 3000"
	desc = "Fills plastic autoinjectors with chemicals!  \n Add a beaker or a bottle filled with chemicals and an autoinjector of appropriate size to use!"
	icon = 'icons/obj/chemical_vr.dmi'
	icon_state = "injector"
	use_power = USE_POWER_IDLE
	anchored = FALSE
	density = FALSE
	clicksound = "button"
	clickvol = 30
	idle_power_usage = 5
	active_power_usage = 100
	circuit = /obj/item/weapon/circuitboard/injector_maker
	var/obj/item/weapon/reagent_containers/beaker = null
	var/count_large_injector = 0
	var/count_small_injector = 0
	var/capacity_large_injector = 10
	var/capacity_small_injector = 30
	var/list/beaker_reagents_list = list()


/obj/machinery/injector_maker/Initialize()
	. = ..()
	default_apply_parts()

/obj/machinery/injector_maker/update_icon()
	if(!count_large_injector && !count_small_injector && !beaker)
		icon_state = "injector"
	else if(!count_large_injector && !count_small_injector && beaker != null)
		icon_state = "injector_b"
	else if(!beaker && (count_large_injector > 0 || count_small_injector > 0))
		icon_state = "injector_i"
	else if(beaker != null && count_large_injector > 0 && count_small_injector > 0)
		icon_state = "injector_ib"
	return


/obj/machinery/injector_maker/attackby(var/obj/item/O as obj, var/mob/user as mob)

	if (istype(O, /obj/item/device/multitool))
		return ..()

	if(istype(O,/obj/item/weapon/reagent_containers/glass) || \
		istype(O,/obj/item/weapon/reagent_containers/food/drinks/glass2) || \
		istype(O,/obj/item/weapon/reagent_containers/food/drinks/shaker))

		if (beaker)
			return 1
		else
			src.beaker =  O
			user.drop_item()
			O.loc = src
			update_icon()
			src.updateUsrDialog()
			return 0



	if(istype(O,/obj/item/weapon/reagent_containers/hypospray/autoinjector/empty))
		var/obj/item/weapon/reagent_containers/hypospray/autoinjector/empty/E = O
		if(src.count_small_injector >= src.capacity_small_injector)
			to_chat(user, SPAN_WARNING("Storage is full! It can only hold [capacity_small_injector]"))
			return
		if(E.reagents.total_volume > 0)
			to_chat(user, SPAN_WARNING("You cannot put a filled injector into the machine!"))
			return
		src.count_small_injector = src.count_small_injector + 1
		qdel(E)
		update_icon()

	if(istype(O,/obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/empty))
		var/obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/empty/E = O
		if(src.count_large_injector >= src.capacity_large_injector)
			to_chat(user, SPAN_WARNING("Storage is full! It can only hold [capacity_large_injector]"))
			return
		if(E.reagents.total_volume > 0)
			to_chat(user, SPAN_WARNING("You cannot put a filled injector into the machine!"))
			return
		src.count_large_injector = src.count_large_injector + 1
		qdel(E)
		update_icon()


/obj/machinery/injector_maker/AltClick(mob/user)
	. = ..()
	if(beaker)
		if(!user.incapacitated() && Adjacent(user))
			user.put_in_hands(beaker)
		else
			beaker.forceMove(drop_location())
		beaker = null
		update_icon()

/obj/machinery/injector_maker/examine(mob/user)
	. = ..()
	if(!in_range(user, src) && !issilicon(user) && !isobserver(user))
		. += "<span class='warning'>You're too far away to examine [src]'s contents and display!</span>"
		return

	if(beaker)
		. += "<span class='notice'>\The [src] contains:</span>"
		if(beaker)
			. += "<span class='notice'>- \A [beaker].</span>"

	. += "<span class ='notice'>\The [src] contains [count_small_injector] small injectors and [count_large_injector] large injectors.\n </span>"
	. += "<span_class ='notice'> It can hold [capacity_small_injector] small and [capacity_large_injector] large injectors respectively.\n </span>"

	if(!(stat & (NOPOWER|BROKEN)))
		. += "<span class='notice'>The status display reads:</span>\n"
		if(beaker)
			for(var/datum/reagent/R in beaker.reagents.reagent_list)
				. += "<span class='notice'>- [R.volume] units of [R.name].</span>"

/obj/machinery/injector_maker/attack_hand(mob/user as mob)
	interact(user)

/obj/machinery/injector_maker/interact(mob/user as mob)
	if(user.incapacitated() || !beaker)
		return

	var/choice = tgui_input_list(user, "There are [src.count_small_injector] small and [src.count_large_injector]  large injectors left.", "Choose what to do", list("large injector", "small injector", "eject beaker", "cancel"))

	switch(choice)
		if("cancel")
			return
		if("eject beaker")
			if(!user.incapacitated() && Adjacent(user))
				user.put_in_hands(beaker)
			else
				beaker.forceMove(drop_location())
			beaker = null
			update_icon()
		if("small injector")
			if(!beaker.reagents.total_volume)
				to_chat(user, SPAN_WARNING("Chemical storage is empty!"))
				return
			if(!src.capacity_small_injector)
				to_chat(user, SPAN_WARNING("Small injector rack is empty!!"))
				return
			var/injector_amount = tgui_input_number(user, "How many injectors would you like?", "Make small injectors", 0, 100, 0, 0, TRUE)
			if(injector_amount > 0)

				if(src.count_small_injector < injector_amount )
					to_chat(user, SPAN_WARNING("Not enough autoinjectors! You only have [src.count_small_injector]"))
					return
				var/name = sanitize(tgui_input_text(user, "Name Injector", "Naming", null, 32, 0, 0, 0, 0),MAX_MESSAGE_LEN,0,0,0)
				make_injector("large injector", injector_amount, name)
				update_icon()
		if("large injector")
			if(!beaker.reagents.total_volume)
				to_chat(user, SPAN_WARNING("Chemical storage is empty!"))
				return
			if(!src.capacity_large_injector)
				to_chat(user, SPAN_WARNING("Large injector rack is empty!"))
				return
			var/injector_amount = tgui_input_number(user, "How many injectors would you like?", "Make small injectors", 0, 100, 0, 0, TRUE)
			if(injector_amount > 0)
				if(src.count_large_injector < injector_amount)
					to_chat(user, SPAN_WARNING("Not enough autoinjectors! You only have [src.count_large_injector]"))
					return
				var/name = sanitize(tgui_input_text(user, "Name Injector", "Naming", null, 32, 0, 0, 0, 0),MAX_MESSAGE_LEN,0,0,0)
				make_injector("large injector", injector_amount, name)
				update_icon()

/obj/machinery/injector_maker/proc/make_injector(var/size, var/amount, var/new_name)
	if(!beaker)
		return
	for(var/i, i < amount, i++)
		switch(size)
			if("small injector")
				var/amount_per_injector = CLAMP(beaker.reagents.total_volume / amount, 0, 15)
				if(!amount_per_injector || src.count_small_injector < 1)
					return
				var/obj/item/weapon/reagent_containers/hypospray/autoinjector/empty/P = new(loc)
				beaker.reagents.trans_to_obj(P, amount_per_injector)
				P.update_icon()
				if(new_name)
					P.name = new_name
				src.count_small_injector = src.count_small_injector - 1

			if("large injector")
				var/amount_per_injector = CLAMP(beaker.reagents.total_volume / amount, 0, 15)
				if(!amount_per_injector || src.count_large_injector < 1)
					return
				var/obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/empty/P = new(loc)
				beaker.reagents.trans_to_obj(P, amount_per_injector)
				P.update_icon()
				if(new_name)
					P.name = new_name
				src.count_large_injector = src.count_large_injector - 1
