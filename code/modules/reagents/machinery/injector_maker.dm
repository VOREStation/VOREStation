/obj/machinery/injector_maker
	name = "Ready-to-Use Medicine 3000"
	desc = "Fills plastic autoinjectors with chemicals! Molds new injectors if needed!  \n Add a beaker or a bottle filled with chemicals and an autoinjector of appropriate size or sheets of plastic to use!"
	icon = 'icons/obj/chemical_vr.dmi'
	icon_state = "injector"
	use_power = USE_POWER_IDLE
	anchored = TRUE
	density = FALSE
	layer = ABOVE_WINDOW_LAYER
	vis_flags = VIS_HIDE
	unacidable = TRUE
	clicksound = "button"
	clickvol = 60
	idle_power_usage = 5
	active_power_usage = 100
	circuit = /obj/item/circuitboard/injector_maker
	var/obj/item/reagent_containers/beaker = null
	var/list/beaker_reagents_list = list()


	var/count_large_injector = 0
	var/count_small_injector = 0
	var/capacity_large_injector = 40
	var/capacity_small_injector = 40

	var/count_plastic = 0 //Given in "units", not sheets
	var/value_plastic = 2000 //1 sheet translates to 2000 units
	var/cost_plastic_small = 30
	var/cost_plastic_large = 1500
	var/capacity_plastic = 60000 // cost_plastic_large * 40


/obj/machinery/injector_maker/Initialize()
	. = ..()
	default_apply_parts()

/obj/machinery/injector_maker/update_icon()
	if(!beaker && !count_plastic && !count_small_injector && !count_large_injector) //Empty
		icon_state = "injector"
	else if(beaker != null && !count_plastic && !count_small_injector  && !count_large_injector ) //Has just beaker
		icon_state = "injector_b"
	else if(!beaker && !count_plastic && (count_large_injector > 0 || count_small_injector > 0)) //Has just injectors
		icon_state = "injector_i"
	else if(!beaker && count_plastic > 0 && !count_large_injector && !count_small_injector) //Has just plastic
		icon_state = "injector_p"
	else if(beaker != null && !count_plastic && (count_large_injector > 0 || count_small_injector > 0)) //beaker + injectors
		icon_state = "injector_ib"
	else if(beaker != null && count_plastic > 0 && !count_large_injector && !count_small_injector) //beaker + plastic
		icon_state = "injector_pb"
	else if(beaker != null && count_plastic > 0 && (count_large_injector > 0 || count_small_injector > 0)) //Has everything
		icon_state = "injector_ipb"
	return


/obj/machinery/injector_maker/attackby(var/obj/item/O as obj, var/mob/user as mob)

	if (istype(O, /obj/item/multitool))
		return ..()

	if(istype(O,/obj/item/reagent_containers/glass) || \
		istype(O,/obj/item/reagent_containers/food/drinks/glass2) || \
		istype(O,/obj/item/reagent_containers/food/drinks/shaker))

		if (beaker)
			return 1
		else
			src.beaker =  O
			user.drop_item()
			O.loc = src
			update_icon()
			src.updateUsrDialog()
			return 0



	if(istype(O,/obj/item/reagent_containers/hypospray/autoinjector/empty))
		var/obj/item/reagent_containers/hypospray/autoinjector/empty/E = O
		if(src.count_small_injector >= src.capacity_small_injector)
			to_chat(user, SPAN_WARNING("Storage is full! It can only hold [capacity_small_injector]"))
			return
		if(E.reagents.total_volume > 0)
			to_chat(user, SPAN_WARNING("You cannot put a filled injector into the machine!"))
			return
		src.count_small_injector = src.count_small_injector + 1
		qdel(E)
		update_icon()
	if(istype(O,/obj/item/reagent_containers/hypospray/autoinjector/biginjector/empty))
		var/obj/item/reagent_containers/hypospray/autoinjector/biginjector/empty/E = O
		if(src.count_large_injector >= src.capacity_large_injector)
			to_chat(user, SPAN_WARNING("Storage is full! It can only hold [capacity_large_injector]"))
			return
		if(E.reagents.total_volume > 0)
			to_chat(user, SPAN_WARNING("You cannot put a filled injector into the machine!"))
			return
		src.count_large_injector = src.count_large_injector + 1
		qdel(E)
		update_icon()


	if(istype(O,/obj/item/stack/material))
		if(O.get_material_name() == MAT_PLASTIC)
			var/obj/item/stack/S = O
			var/input_amount = tgui_input_number(user, "How many sheets would you like to add?", "Add plastic", 0, S.get_amount())
			if(input_amount == 0)
				return
			var/plastic_input = input_amount * value_plastic
			var/free_space = capacity_plastic - src.count_plastic
			if(plastic_input > free_space)
				to_chat(user, SPAN_WARNING("Storage is full! There is only [free_space] units worth of space left!"))
			else
				S.use(input_amount)
				src.count_plastic = src.count_plastic + plastic_input
				update_icon()


/obj/machinery/injector_maker/AltClick(mob/user)
	. = ..()
	if(beaker)
		if(!user.incapacitated() && Adjacent(user))
			user.put_in_hands(beaker)
		else
			beaker.forceMove(drop_location())
		src.beaker = null
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

	. += "<span class ='notice'>\The [src] contains [src.count_small_injector] small injectors and [src.count_large_injector] large injectors.\n </span>"
	. += "<span class ='notice'> It can hold [capacity_small_injector] small and [capacity_large_injector] large injectors respectively.\n </span>"
	. += "<span class ='notice'> \The [src] contains [src.count_plastic] units of plastic. It can hold up to [capacity_plastic] units.\n </span>"

	if(!(stat & (NOPOWER|BROKEN)))
		. += "<span class='notice'>The status display reads the following reagents:</span>\n"
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
			src.beaker = null
			update_icon()


		if("small injector")
			var/material = tgui_input_list(user, "Use autoinjector storage, or mold new injectors to fill?", "Choose Material", list("mold plastic", "use injectors"))
			switch(material)
				if("mold plastic")
					if(src.count_plastic < cost_plastic_small)
						to_chat(user, SPAN_WARNING("Not enough plastic! Need at least [cost_plastic_small] units."))
						return
				if("use injectors")
					if(!src.count_small_injector)
						to_chat(user, SPAN_WARNING("Small injector rack is empty!"))
						return
			if(!beaker.reagents.total_volume)
				to_chat(user, SPAN_WARNING("Chemical storage is empty!"))
				return
			var/injector_amount = tgui_input_number(user, "How many injectors would you like?", "Make small injectors", 0, 100)
			if(injector_amount > 0)
				switch(material)
					if("mold plastic")
						var/plastic_cost = cost_plastic_small * injector_amount
						if(src.count_plastic < plastic_cost)
							to_chat(user, SPAN_WARNING("Not enough plastic! Need at least [plastic_cost] units."))
							return
					if("use injectors")
						if(src.count_small_injector < injector_amount)
							to_chat(user, SPAN_WARNING("Not enough autoinjectors! You only have [src.count_small_injector]"))
							return
				var/name = sanitize(tgui_input_text(user, "Name Injector", "Naming", null, 32, 0, 0, 0, 0),MAX_MESSAGE_LEN,0,0,0)
				make_injector("small injector", injector_amount, name, material, user)
				update_icon()


		if("large injector")
			var/material = tgui_input_list(user, "Use autoinjector storage, or mold new injectors to fill?", "Choose Material", list("mold plastic", "use injectors"))
			switch(material)
				if("mold plastic")
					if(src.count_plastic < cost_plastic_large)
						to_chat(user, SPAN_WARNING("Not enough plastic! Need at least [cost_plastic_large] units."))
						return
				if("use injectors")
					if(!src.count_large_injector)
						to_chat(user, SPAN_WARNING("Large injector rack is empty!"))
						return
			if(!beaker.reagents.total_volume)
				to_chat(user, SPAN_WARNING("Chemical storage is empty!"))
				return
			var/injector_amount = tgui_input_number(user, "How many injectors would you like?", "Make large injectors", 0, 100)
			if(injector_amount > 0)
				switch(material)
					if("mold plastic")
						var/plastic_cost = cost_plastic_large * injector_amount
						if(src.count_plastic < plastic_cost)
							to_chat(user, SPAN_WARNING("Not enough plastic! Need at least [plastic_cost] units."))
							return
					if("use injectors")
						if(src.count_large_injector < injector_amount)
							to_chat(user, SPAN_WARNING("Not enough autoinjectors! You only have [src.count_large_injector]"))
							return
				var/name = sanitize(tgui_input_text(user, "Name Injector", "Naming", null, 32, 0, 0, 0, 0),MAX_MESSAGE_LEN,0,0,0)
				make_injector("large injector", injector_amount, name, material,user)
				update_icon()


/obj/machinery/injector_maker/proc/make_injector(var/size, var/amount, var/new_name, var/material, mob/user as mob)
	if(!beaker)
		return
	var/amount_per_injector = null
	var/proceed = "Yes" //Defaulting to Yes. We only check if the amount/injector gets under max volume
	switch(size)
		if("small injector")
			amount_per_injector = CLAMP(beaker.reagents.total_volume / amount, 0, 5)
		if("large injector")
			amount_per_injector = CLAMP(beaker.reagents.total_volume / amount, 0, 15)
	if((size == "small injector" && amount_per_injector < 5) || size == "large injector" && amount_per_injector < 15)
		proceed = tgui_alert(usr, "Heads up! Less than max volume per injector!\n Making [amount] [size](s) filled with [amount_per_injector] total reagent volume each!","Proceed?",list("No","Yes"))
	if(!proceed || proceed == "No" || !amount_per_injector)
		return
	for(var/i, i < amount, i++)
		switch(size)
			if("small injector")
				switch(material)
					if("mold plastic")
						if(src.count_plastic < cost_plastic_small)
							return
						else
							src.count_plastic = src.count_plastic - cost_plastic_small
					if("use injectors")
						if(!src.count_small_injector)
							return
						else
							src.count_small_injector = src.count_small_injector - 1
				var/obj/item/reagent_containers/hypospray/autoinjector/empty/P = new(loc)
				beaker.reagents.trans_to_obj(P, amount_per_injector)
				P.update_icon()
				if(new_name)
					P.name = new_name


			if("large injector")
				switch(material)
					if("mold plastic")
						if(src.count_plastic < cost_plastic_large)
							return
						else
							src.count_plastic = src.count_plastic - cost_plastic_large
					if("use injectors")
						if(!src.count_large_injector)
							return
						else
							src.count_large_injector = src.count_large_injector - 1
				var/obj/item/reagent_containers/hypospray/autoinjector/biginjector/empty/P = new(loc)
				beaker.reagents.trans_to_obj(P, amount_per_injector)
				P.update_icon()
				if(new_name)
					P.name = new_name
