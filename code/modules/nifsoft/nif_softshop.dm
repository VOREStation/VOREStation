//Custom vendors
/obj/machinery/vending/nifsoft_shop
	name = "NIFSoft Shop"
	desc = "For all your mindware and mindware accessories."
	product_ads = "Let us get into your head!;Looking for an upgrade?;Surpass Humanity!;Why be normal when you can be SUPERnormal?;Jack in with NIFSoft!"
	icon_state = "nifsoft"
	icon_vend = "nifsoft-purchase"
	icon_deny = "nifsoft-problem"
	products = list()
	contraband = list()
	premium = list()
	var/global/list/starting_legal_nifsoft
	var/global/list/starting_illegal_nifsoft

// Special Treatment!
/obj/machinery/vending/nifsoft_shop/build_inventory()
	//Firsties
	if(!starting_legal_nifsoft)
		starting_legal_nifsoft = list()
		starting_illegal_nifsoft = list()
		for(var/P in subtypesof(/datum/nifsoft) - /datum/nifsoft/package)
			var/datum/nifsoft/NS = P
			if(initial(NS.initial))
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
		var/category = current_list[2]

		for(var/entry in current_list[1])
			var/datum/nifsoft/NS = entry
			var/name = initial(NS.name)
			var/datum/stored_item/vending_product/product = new/datum/stored_item/vending_product(src, entry, name)

			product.price = initial(NS.cost)
			product.amount = 10
			product.category = category

			product_records.Add(product)

/obj/machinery/vending/nifsoft_shop/allowed(mob/user)
	if(!ishuman(user))
		return FALSE

	var/mob/living/carbon/human/H = user
	if(!H.nif || !H.nif.stat == NIF_WORKING)
		to_chat(H,"<span class='warning'>[src] seems unable to connect to your NIF...</span>")
		flick(icon_deny,src)
		return FALSE

	return ..()

// Also special treatment!
/obj/machinery/vending/nifsoft_shop/vend(datum/stored_item/vending_product/R, mob/user)
	var/mob/living/carbon/human/H = user
	if((!allowed(usr)) && !emagged && scan_id && istype(H))	//For SECURE VENDING MACHINES YEAH
		usr << "<span class='warning'>Purchase not allowed.</span>"	//Unless emagged of course
		flick(icon_deny,src)
		return
	vend_ready = 0 //One thing at a time!!
	status_message = "Installing..."
	status_error = 0
	nanomanager.update_uis(src)

	if(R.category & CAT_COIN)
		if(!coin)
			user << "<span class='notice'>You need to insert a coin to get this item.</span>"
			return
		if(coin.string_attached)
			if(prob(50))
				user << "<span class='notice'>You successfully pull the coin out before \the [src] could swallow it.</span>"
			else
				user << "<span class='notice'>You weren't able to pull the coin out fast enough, the machine ate it, string and all.</span>"
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
		flick(icon_vend,src)
		if(has_logs)
			do_logging(R, user, 1)

		status_message = ""
		status_error = 0
		vend_ready = 1
		currently_vending = null
		nanomanager.update_uis(src)
	return 1
