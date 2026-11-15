// Use this define to register something as a creatable!
// * n - The proper name of the purchasable
// * o - The object type path of the purchasable to spawn
// * r - The maximum amount to dispense
// * p - The price of the purchasable in biomass
#define BIOGEN_ITEM(n, o, r, p) n = new /datum/data/biogenerator_item(n, o, r, p)

// Use this define to register something as dispensable
// * n - The proper name of the purchasable
// * o - The reagent ID
// * r - The maximum amount to dispense
// * p - The price of the purchasable in biomass
#define BIOGEN_REAGENT(n, o, r, p) n = new /datum/data/biogenerator_reagent(n, o, r, p)

/obj/machinery/biogenerator
	name = "biogenerator"
	desc = "Converts plants into biomass, which can be used for fertilizer and sort-of-synthetic products."
	icon = 'icons/obj/biogenerator_vr.dmi' //VOREStation Edit
	icon_state = "biogen-stand"
	density = TRUE
	anchored = TRUE
	circuit = /obj/item/circuitboard/biogenerator
	use_power = USE_POWER_IDLE
	idle_power_usage = 40
	var/processing = 0
	var/obj/item/reagent_containers/glass/beaker = null
	var/points = 0
	var/build_eff = 1
	var/eat_eff = 1

	var/list/item_list


/datum/data/biogenerator_item
	var/equipment_path = null
	var/equipment_amt = 1
	var/cost = 0

/datum/data/biogenerator_item/New(name, path, amt, cost)
	src.name = name
	src.equipment_path = path
	src.equipment_amt = amt
	src.cost = cost

/datum/data/biogenerator_reagent
	var/reagent_id = null
	var/reagent_amt = 0
	var/cost = 0

/datum/data/biogenerator_reagent/New(name, id, amt, cost)
	src.name = name
	src.reagent_id = id
	src.reagent_amt = amt
	src.cost = cost

/obj/machinery/biogenerator/Initialize(mapload)
	. = ..()
	var/datum/reagents/R = new/datum/reagents(1000)
	reagents = R
	R.my_atom = src

	beaker = new /obj/item/reagent_containers/glass/bottle(src)
	default_apply_parts()

	item_list = list()
	item_list["Food Items"] = list(
		BIOGEN_REAGENT("Milk", REAGENT_ID_MILK, 50, 2), //2 for each 1u
		BIOGEN_REAGENT("Cream", REAGENT_ID_CREAM, 50, 3), //3 for each 1u
		BIOGEN_ITEM("Slab of meat", /obj/item/reagent_containers/food/snacks/meat, 5, 50),
		BIOGEN_ITEM("Algae Sheets", /obj/item/stack/material/algae, 50, 100),
	)
	item_list["Cooking Ingredients"] = list(
		BIOGEN_REAGENT("Universal Enzyme", REAGENT_ID_ENZYME, 50, 3),
		BIOGEN_ITEM("Nutri-spread", /obj/item/reagent_containers/food/snacks/spreads, 5, 30),
		BIOGEN_REAGENT("Salt", REAGENT_ID_SODIUMCHLORIDE, 50, 2),
		BIOGEN_REAGENT("Soy Sauce", REAGENT_ID_SOYSAUCE, 50, 3),
	)
	item_list["Gardening Nutrients"] = list(
		BIOGEN_ITEM("E-Z-Nutrient", /obj/item/reagent_containers/glass/bottle/eznutrient, 5, 30),
		BIOGEN_ITEM("Left 4 Zed", /obj/item/reagent_containers/glass/bottle/left4zed, 5, 50),
		BIOGEN_ITEM("Robust Harvest", /obj/item/reagent_containers/glass/bottle/robustharvest, 5, 50),
		BIOGEN_ITEM("Diethylamine", /obj/item/reagent_containers/glass/bottle/diethylamine, 5, 60),
		BIOGEN_ITEM("Mutagen", /obj/item/reagent_containers/glass/bottle/mutagen, 15, 50),
		BIOGEN_ITEM("Plant-B-Gone", /obj/item/reagent_containers/spray/plantbgone, 5, 50),
	)
	item_list["Exotic Seeds"] = list(
		BIOGEN_ITEM("Mystery seed pack", /obj/item/seeds/random, 5, 150),
		BIOGEN_ITEM("Kudzu seed pack", /obj/item/seeds/kudzuseed, 5, 100),
	)
	item_list["Leather Products"] = list(
		BIOGEN_ITEM("Wallet", /obj/item/storage/wallet, 1, 100),
		BIOGEN_ITEM("Botanical gloves", /obj/item/clothing/gloves/botanic_leather, 1, 250),
		BIOGEN_ITEM("Plant bag", /obj/item/storage/bag/plants, 1, 320),
		BIOGEN_ITEM("Large plant bag", /obj/item/storage/bag/plants/large, 1, 640),
		BIOGEN_ITEM("Utility belt", /obj/item/storage/belt/utility, 1, 300),
		BIOGEN_ITEM("Leather Satchel", /obj/item/storage/backpack/satchel, 1, 400),
		BIOGEN_ITEM("Cash Bag", /obj/item/storage/bag/cash, 1, 400),
		BIOGEN_ITEM("Chemistry Bag", /obj/item/storage/bag/chemistry, 1, 400),
		BIOGEN_ITEM("Workboots", /obj/item/clothing/shoes/boots/workboots, 1, 400),
		BIOGEN_ITEM("Leather Chaps", /obj/item/clothing/under/pants/chaps, 1, 400),
		BIOGEN_ITEM("Leather Coat", /obj/item/clothing/suit/leathercoat, 1, 500),
		BIOGEN_ITEM("Leather Jacket", /obj/item/clothing/suit/storage/toggle/brown_jacket, 1, 500),
		BIOGEN_ITEM("Winter Coat", /obj/item/clothing/suit/storage/hooded/wintercoat, 1, 500),
	)

/obj/machinery/biogenerator/tgui_static_data(mob/user)
	var/list/static_data = list()

	// Available items - in static data because we don't wanna compute this list every time! It hardly changes.
	static_data["items"] = list()
	for(var/cat in item_list)
		var/list/cat_items = list()
		for(var/prize_name, value in item_list[cat])
			if(istype(value, /datum/data/biogenerator_item))
				var/datum/data/biogenerator_item/cat_item = value
				cat_items[prize_name] = list("name" = prize_name, "price" = cat_item.cost, "max_amount" = cat_item.equipment_amt)
				continue
			var/datum/data/biogenerator_reagent/cat_reag = value
			cat_items[prize_name] = list("name" = prize_name, "price" = cat_reag.cost, "max_amount" = cat_reag.reagent_amt, "reagent" = TRUE)

		static_data["items"][cat] = cat_items

	return static_data

/obj/machinery/biogenerator/tgui_data(mob/user)
	var/list/data = ..()

	data["build_eff"] = build_eff
	data["points"] = points
	data["processing"] = processing
	data["beaker"] = !!beaker

	return data

/obj/machinery/biogenerator/tgui_interact(mob/user, datum/tgui/ui = null)
	// Open the window
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Biogenerator", name)
		ui.open()

/obj/machinery/biogenerator/tgui_act(action, params, datum/tgui/ui)
	. = ..()
	if(.)
		return

	switch(action)
		if("activate")
			activate(ui.user)
			return TRUE
		if("detach")
			if(beaker)
				beaker.forceMove(loc)
				beaker = null
				update_icon()
			return TRUE
		if("purchase")
			var/category = params["cat"] // meow
			var/name = params["name"]
			var/amount = params["amount"]

			if(!(category in item_list) || !(name in item_list[category]) || !isnum(amount)) // Not trying something that's not in the list, are you?
				return FALSE

			var/datum/data/biogenerator_item/bi = item_list[category][name]

			if(!istype(bi))
				var/datum/data/biogenerator_reagent/br = item_list[category][name]
				if(!istype(br))
					return FALSE
				if(!beaker)
					return FALSE
				if(amount <= 0 || amount > br.reagent_amt)
					return FALSE
				var/cost = round(br.cost / build_eff)
				if(cost < 1) //No going below 1 cost.
					cost = 1
				if(cost * amount > points)
					to_chat(ui.user, span_danger("Insufficient biomass."))
					return FALSE
				var/amt_to_actually_dispense = round(min(beaker.reagents.get_free_space(), amount))
				if(amt_to_actually_dispense <= 0)
					to_chat(ui.user, span_danger("The loaded beaker is full!"))
					return FALSE
				points -= cost * amt_to_actually_dispense
				beaker.reagents.add_reagent(br.reagent_id, amt_to_actually_dispense)
				playsound(src, 'sound/machines/reagent_dispense.ogg', 25, 1)
				return FALSE

			if(amount <= 0 || amount > bi.equipment_amt)
				return FALSE

			var/cost = round(bi.cost / build_eff)
			if(cost > points)
				to_chat(ui.user, span_danger("Insufficient biomass."))
				return FALSE

			points -= cost * amount
			if(ispath(bi.equipment_path, /obj/item/stack))
				new bi.equipment_path(loc, amount)
				playsound(src, 'sound/machines/vending/vending_drop.ogg', 100, 1)
				return TRUE

			for(var/i in 1 to amount)
				new bi.equipment_path(loc)
				playsound(src, 'sound/machines/vending/vending_drop.ogg', 100, 1)
			return TRUE

/obj/machinery/biogenerator/on_reagent_change()			//When the reagents change, change the icon as well.
	update_icon()

/obj/machinery/biogenerator/update_icon()
	if(!beaker)
		icon_state = "biogen-empty"
	else if(!processing)
		icon_state = "biogen-stand"
	else
		icon_state = "biogen-work"
	return

/obj/machinery/biogenerator/attackby(obj/item/O, mob/user)
	if(default_deconstruction_screwdriver(user, O))
		return
	if(default_deconstruction_crowbar(user, O))
		return
	if(default_part_replacement(user, O))
		return
	if(default_unfasten_wrench(user, O, 40))
		return
	if(istype(O, /obj/item/reagent_containers/glass))
		if(beaker)
			to_chat(user, span_notice("\The [src] is already loaded."))
		else
			user.remove_from_mob(O)
			O.loc = src
			beaker = O
	else if(processing)
		to_chat(user, span_notice("\The [src] is currently processing."))
	else if(istype(O, /obj/item/storage/bag/plants))
		var/i = 0
		for(var/obj/item/reagent_containers/food/snacks/grown/G in contents)
			i++
		if(i >= 10)
			to_chat(user, span_notice("\The [src] is already full! Activate it."))
		else
			for(var/obj/item/reagent_containers/food/snacks/grown/G in O.contents)
				G.loc = src
				i++
				if(i >= 10)
					to_chat(user, span_notice("You fill \the [src] to its capacity."))
					break
			if(i < 10)
				to_chat(user, span_notice("You empty \the [O] into \the [src]."))


	else if(!istype(O, /obj/item/reagent_containers/food/snacks/grown))
		to_chat(user, span_notice("You cannot put this in \the [src]."))
	else
		var/i = 0
		for(var/obj/item/reagent_containers/food/snacks/grown/G in contents)
			i++
		if(i >= 10)
			to_chat(user, span_notice("\The [src] is full! Activate it."))
		else
			user.remove_from_mob(O)
			O.loc = src
			to_chat(user, span_notice("You put \the [O] in \the [src]"))
	update_icon()
	return

/obj/machinery/biogenerator/attack_hand(mob/user as mob)
	if(stat & BROKEN)
		return
	tgui_interact(user)

/obj/machinery/biogenerator/proc/activate(mob/user)
	if(user.stat)
		return
	if(stat) //NOPOWER etc
		return
	if(processing)
		to_chat(user, span_notice("The biogenerator is in the process of working."))
		return
	var/S = 0
	for(var/obj/item/reagent_containers/food/snacks/grown/I in contents)
		S += 5
		if(I.reagents.get_reagent_amount(REAGENT_ID_NUTRIMENT) < 0.1)
			points += 1
		else points += I.reagents.get_reagent_amount(REAGENT_ID_NUTRIMENT) * 10 * eat_eff
		qdel(I)
	if(!S)
		to_chat(user, span_warning("Error: No growns inside. Please insert growns."))
		return

	processing = 1
	update_icon()
	playsound(src, 'sound/machines/blender.ogg', 40, 1)
	use_power(S * 30)
	addtimer(CALLBACK(src, PROC_REF(finish_processing)), (S + 15) / eat_eff, TIMER_DELETE_ME)

/obj/machinery/biogenerator/proc/finish_processing()
	processing = 0
	SStgui.update_uis(src)
	playsound(src, 'sound/machines/biogenerator_end.ogg', 40, 1)
	update_icon()

/obj/machinery/biogenerator/RefreshParts()
	..()
	var/man_rating = 0
	var/bin_rating = 0

	for(var/obj/item/stock_parts/P in component_parts)
		if(istype(P, /obj/item/stock_parts/matter_bin))
			bin_rating += P.rating
		if(istype(P, /obj/item/stock_parts/manipulator))
			man_rating += P.rating

	build_eff = man_rating
	eat_eff = bin_rating

#undef BIOGEN_ITEM
#undef BIOGEN_REAGENT
