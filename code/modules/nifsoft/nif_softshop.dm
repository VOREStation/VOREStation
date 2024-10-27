//Custom vendors
/obj/machinery/vending/nifsoft_shop
	name = "NIFSoft Shop"
	desc = "For all your mindware and mindware accessories."
	product_ads = "Let us get into your head!;Looking for an upgrade?;Surpass Humanity!;Why be normal when you can be SUPERnormal?;Jack in with NIFSoft!"

	icon = 'icons/obj/machines/ar_elements.dmi'
	icon_state = "proj"

	products = list()
	contraband = list()
	premium = list()
	var/global/list/starting_legal_nifsoft
	var/global/list/starting_illegal_nifsoft

	density = FALSE
	opacity = 0
	var/datum/entopic/entopic

/obj/machinery/vending/nifsoft_shop/Initialize()
	. = ..()

	if(wires)
		qdel(wires)
	wires = new /datum/wires/vending/no_contraband(src) //These wires can't be hacked for contraband.
	entopic = new(aholder = src, aicon = icon, aicon_state = "beacon")

/obj/machinery/vending/nifsoft_shop/tgui_data(mob/user)
	. = ..()
	.["chargesMoney"] = TRUE

/obj/machinery/vending/nifsoft_shop/Destroy()
	QDEL_NULL(entopic)
	return ..()

/obj/machinery/vending/nifsoft_shop/power_change()
	..()
	if(!entopic) return //Early APC init(), ignore
	if(stat & BROKEN)
		icon_state = "[initial(icon_state)]-broken"
		entopic.hide()
	else
		if(!(stat & NOPOWER))
			icon_state = initial(icon_state)
			entopic.show()
		else
			spawn(rand(0, 15))
				icon_state = "[initial(icon_state)]-off"
				entopic.hide()

/obj/machinery/vending/nifsoft_shop/malfunction()
	stat |= BROKEN
	icon_state = "[initial(icon_state)]-broken"
	entopic.hide()
	return

// Special Treatment!
/obj/machinery/vending/nifsoft_shop/build_inventory()
	//Firsties
	if(!starting_legal_nifsoft)
		starting_legal_nifsoft = list()
		starting_illegal_nifsoft = list()
		for(var/datum/nifsoft/NS as anything in (subtypesof(/datum/nifsoft) - typesof(/datum/nifsoft/package)))
			if(initial(NS.vended))
				switch(initial(NS.illegal))
					if(TRUE)
						starting_illegal_nifsoft += NS
					if(FALSE)
						starting_legal_nifsoft += NS

	products = starting_legal_nifsoft.Copy()
	contraband = starting_illegal_nifsoft.Copy()

	var/list/all_products = list(
		list(products, CAT_NORMAL),
		list(contraband, CAT_HIDDEN),
		list(premium, CAT_COIN))

	for(var/current_list in all_products)
		var/category = current_list[CAT_HIDDEN]

		for(var/datum/nifsoft/NS as anything in current_list[CAT_NORMAL])
			var/applies_to = initial(NS.applies_to)
			var/context = ""
			if(!(applies_to & NIF_SYNTHETIC))
				context = " (Org Only)"
			else if(!(applies_to & NIF_ORGANIC))
				context = " (Syn Only)"
			var/name = "[initial(NS.name)][context]"
			var/datum/stored_item/vending_product/product = new/datum/stored_item/vending_product(src, NS, name)

			product.price = initial(NS.cost)
			product.amount = 10
			product.category = category
			product.item_desc = initial(NS.desc)

			product_records.Add(product)

/obj/machinery/vending/nifsoft_shop/can_buy(datum/stored_item/vending_product/R, mob/user)
	. = ..()
	if(.)
		var/datum/nifsoft/path = R.item_path
		if(!ishuman(user))
			return FALSE

		var/mob/living/carbon/human/H = user
		if(!H.nif || !H.nif.stat == NIF_WORKING)
			to_chat(H, span_warning("[src] seems unable to connect to your NIF..."))
			return FALSE

		if(!H.nif.can_install(path))
			flick("[icon_state]-deny", entopic.my_image)
			return FALSE

		if(initial(path.access))
			var/list/soft_access = list(initial(path.access))
			var/list/usr_access = user.GetAccess()
			if(scan_id && !has_access(soft_access, list(), usr_access) && !emagged)
				to_chat(user, span_warning("You aren't authorized to buy [initial(path.name)]."))
				flick("[icon_state]-deny", entopic.my_image)
				return FALSE

// Also special treatment!
/obj/machinery/vending/nifsoft_shop/vend(datum/stored_item/vending_product/R, mob/user)
	var/mob/living/carbon/human/H = user
	if(!can_buy(R, user))	//For SECURE VENDING MACHINES YEAH
		to_chat(user, span_warning("Purchase not allowed."))	//Unless emagged of course
		flick("[icon_state]-deny",entopic.my_image)
		return
	vend_ready = 0 //One thing at a time!!
	SStgui.update_uis(src)

	if(R.category & CAT_COIN)
		if(!coin)
			to_chat(user, span_notice("You need to insert a coin to get this item."))
			return
		if(coin.string_attached)
			if(prob(50))
				to_chat(user, span_notice("You successfully pull the coin out before \the [src] could swallow it."))
			else
				to_chat(user, span_notice("You weren't able to pull the coin out fast enough, the machine ate it, string and all."))
				qdel(coin)
				coin = null
				categories &= ~CAT_COIN
		else
			qdel(coin)
			coin = null
			categories &= ~CAT_COIN

	if(((last_reply + (vend_delay + 200)) <= world.time) && vend_reply)
		spawn(0)
			speak(vend_reply)
			last_reply = world.time

	use_power(vend_power_usage)	//actuators and stuff
	spawn(vend_delay)
		R.amount--
		new R.item_path(H.nif)
		H.nif.notify("New software installed: [R.item_name]")
		flick("[icon_state]-vend",entopic.my_image)
		if(has_logs)
			do_logging(R, user, 1)

		vend_ready = 1
		currently_vending = null
		SStgui.update_uis(src)
	return 1

//Can't throw intangible software at people.
/obj/machinery/vending/nifsoft_shop/throw_item()
	//TODO: Make it throw disks at people with random software? That might be fun. EVEN THE ILLEGAL ONES? ;o
	return 0

/datum/wires/vending/no_contraband

/datum/wires/vending/no_contraband/on_pulse(index) //Can't hack for contraband, need emag.
	if(index != WIRE_CONTRABAND)
		..(index)

/obj/machinery/vending/nifsoft_shop/emag_act(remaining_charges, mob/user) //Yeees, YEEES! Give me that black market tech.
	if(!emagged || !(categories & CAT_HIDDEN))
		emagged = 1
		categories |= CAT_HIDDEN
		to_chat(user, "You short out [src]'s access lock & stock restrictions.")
		return 1
