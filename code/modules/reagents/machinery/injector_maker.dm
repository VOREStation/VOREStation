/obj/machinery/injector_maker
	name = "Ready-to-Use Medicine 3000"
	desc = "Molds plastic into autoinjectors and fills them with chemicals. \n Add a beaker or a bottle filled with chemicals and a sheet of plastic to use!"
	icon = 'icons/obj/chemical_vr.dmi' //placeholder for testing
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
	var/plastic_amount = 0
	var/max_plastic = 10000
	var/stack_value = 2000
	var/material_per_sheet = 2000
	var/plastic_cost_small = 10
	var/plastic_cost_large = 500
	var/list/beaker_reagents_list = list()


/obj/machinery/injector_maker/Initialize()
	. = ..()
	default_apply_parts()

/obj/machinery/injector_maker/update_icon()
	if(!plastic_amount && !beaker)
		icon_state = "injector"
	else if(!plastic_amount && beaker != null)
		icon_state = "injector_b"
	else if(!beaker && plastic_amount > 0)
		icon_state = "injector_p"
	else if(beaker != null && plastic_amount > 0)
		icon_state = "injector_pb"
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

	if(istype(O,/obj/item/stack/material))
		if(O.get_material_name() == MAT_PLASTIC)
			var/obj/item/stack/S = O
			var/input_amount = tgui_input_number(user, "How many sheets would you like to add?", "Add plastic", 0, S.get_amount(), 0, 0, TRUE)
			if(input_amount == 0)
				return
			var/plastic_input = input_amount * stack_value
			var/free_space = max_plastic - src.plastic_amount
			if(plastic_input > free_space)
				to_chat(user, SPAN_WARNING("Storage is full! There is only [free_space] units worth of space left!"))
			else
				S.use(input_amount)
				src.plastic_amount = plastic_input
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

	. += "<span class ='notice'>\The [src] contains [plastic_amount] units of plastic.\n It can hold up to [max_plastic] units! 1 sheet gives [stack_value] units.</span>"

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

	var/choice = tgui_input_list(user, "There is [plastic_amount] units of plastic left", "Choose what to do", list("large injector", "small injector", "eject", "cancel"))

	switch(choice)
		if("cancel")
			return
		if("eject")
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
			if(!plastic_amount)
				to_chat(user, SPAN_WARNING("No plastic in storage! Add at least 1 sheet of plastic."))
				return
			var/injector_amount = tgui_input_number(user, "How many injectors would you like?", "Make small injectors", 0, 100, 0, 0, TRUE)
			if(injector_amount > 0)
				var/plastic_needed = injector_amount * plastic_cost_small
				if(src.plastic_amount < plastic_needed )
					to_chat(user, SPAN_WARNING("Not enough plastic! You only have enough plastic for [src.plastic_amount / plastic_cost_small] small injectors!"))
					return
				var/name = sanitize(tgui_input_text(user, "Name Injector", "Naming", null, 32, 0, 0, 0, 0),MAX_MESSAGE_LEN,0,0,0)
				make_injector("large injector", injector_amount, name)
				update_icon()
		if("large injector")
			if(!beaker.reagents.total_volume)
				to_chat(user, SPAN_WARNING("Chemical storage is empty!"))
				return
			if(!plastic_amount)
				to_chat(user, SPAN_WARNING("No plastic in storage! Add at least 1 sheet of plastic."))
				return
			var/injector_amount = tgui_input_number(user, "How many injectors would you like?", "Make small injectors", 0, 100, 0, 0, TRUE)
			if(injector_amount > 0)
				var/plastic_needed = injector_amount * plastic_cost_small
				if(src.plastic_amount < plastic_needed)
					to_chat(user, SPAN_WARNING("Not enough plastic! You only have enough plastic for [src.plastic_amount / plastic_cost_large] large injectors!"))
					return
				var/name = sanitize(tgui_input_text(user, "Name Injector", "Naming", null, 32, 0, 0, 0, 0),MAX_MESSAGE_LEN,0,0,0)
				make_injector("large injector", injector_amount, name)
				update_icon()

/obj/machinery/injector_maker/proc/make_injector(var/size, var/amount, var/new_name)
	if(!beaker)
		return
	for(var/i, i <= amount, i++)
		switch(size)
			if("small injector")
				to_world("Making [size], checking if we got enough.")
				var/amount_per_injector = CLAMP(beaker.reagents.total_volume / amount, 0, 15)
				if(!amount_per_injector || (plastic_cost_small > src.plastic_amount))
					return
				to_world("Enough")
				var/obj/item/weapon/reagent_containers/hypospray/autoinjector/empty/P = new(loc)
				beaker.reagents.trans_to_obj(P, amount_per_injector)
				P.update_icon()
				if(new_name)
					P.name = new_name
				src.plastic_amount = src.plastic_amount - plastic_cost_small

			if("large injector")
				var/amount_per_injector = CLAMP(beaker.reagents.total_volume / amount, 0, 15)
				if(!amount_per_injector || (plastic_cost_large > src.plastic_amount))
					return
				var/obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/empty/P = new(loc)
				beaker.reagents.trans_to_obj(P, amount_per_injector)
				P.update_icon()
				if(new_name)
					P.name = new_name
				src.plastic_amount = src.plastic_amount - plastic_cost_large
