// Use this define to register something as a creatable!
// * n - The proper name of the purchasable
// * o - The object type path of the purchasable to spawn
// * r - The amount to dispense
// * p - The price of the purchasable in biomass
#define BIOGEN_ITEM(n, o, r, p) n = new /datum/data/biogenerator_item(n, o, r, p)

// Use this define to register something as dispensable
// * n - The proper name of the purchasable
// * o - The reagent ID
// * r - The amount of reagent to dispense
// * p - The price of the purchasable in biomass
#define BIOGEN_REAGENT(n, o, r, p) n = new /datum/data/biogenerator_reagent(n, o, r, p)

/obj/machinery/biogenerator
	name = "biogenerator"
	desc = "Converts plants into biomass, which can be used for fertilizer and sort-of-synthetic products."
	icon = 'icons/obj/biogenerator_vr.dmi' //VOREStation Edit
	icon_state = "biogen-stand"
	density = TRUE
	anchored = TRUE
	circuit = /obj/item/weapon/circuitboard/biogenerator
	use_power = USE_POWER_IDLE
	idle_power_usage = 40
	var/processing = 0
	var/obj/item/weapon/reagent_containers/glass/beaker = null
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

/obj/machinery/biogenerator/Initialize()
	. = ..()
	var/datum/reagents/R = new/datum/reagents(1000)
	reagents = R
	R.my_atom = src

	beaker = new /obj/item/weapon/reagent_containers/glass/bottle(src)
	default_apply_parts()

	item_list = list()
	item_list["Food Items"] = list(
		BIOGEN_REAGENT("10 milk", "milk", 10, 20),
		BIOGEN_REAGENT("50 milk", "milk", 50, 95),
		BIOGEN_REAGENT("10 Cream", "cream", 10, 30),
		BIOGEN_REAGENT("50 Cream", "cream", 50, 120),
		BIOGEN_ITEM("Slab of meat", /obj/item/weapon/reagent_containers/food/snacks/meat, 1, 50),
		BIOGEN_ITEM("5 slabs of meat", /obj/item/weapon/reagent_containers/food/snacks/meat, 5, 250),
	)
	item_list["Cooking Ingredients"] = list(
		BIOGEN_REAGENT("10 Universal Enzyme", "enzyme", 10, 30),
		BIOGEN_REAGENT("50 Universal Enzyme", "enzyme", 50, 120),
		BIOGEN_ITEM("Nutri-spread", /obj/item/weapon/reagent_containers/food/snacks/spreads, 1, 30),
		BIOGEN_ITEM("5 nutri-spread", /obj/item/weapon/reagent_containers/food/snacks/spreads, 5, 120),
	)
	item_list["Gardening Nutrients"] = list(
		BIOGEN_ITEM("E-Z-Nutrient", /obj/item/weapon/reagent_containers/glass/bottle/eznutrient, 1, 60),
		BIOGEN_ITEM("5 E-Z-Nutrient", /obj/item/weapon/reagent_containers/glass/bottle/eznutrient, 5, 300),
		BIOGEN_ITEM("Left 4 Zed", /obj/item/weapon/reagent_containers/glass/bottle/left4zed, 1, 120),
		BIOGEN_ITEM("5 Left 4 Zed", /obj/item/weapon/reagent_containers/glass/bottle/left4zed, 5, 600),
		BIOGEN_ITEM("Robust Harvest", /obj/item/weapon/reagent_containers/glass/bottle/robustharvest, 1, 150),
		BIOGEN_ITEM("5 Robust Harvest", /obj/item/weapon/reagent_containers/glass/bottle/robustharvest, 5, 750),
	)
	item_list["Leather Products"] = list(
		BIOGEN_ITEM("Wallet", /obj/item/weapon/storage/wallet, 1, 100),
		BIOGEN_ITEM("Botanical gloves", /obj/item/clothing/gloves/botanic_leather, 1, 250),
		BIOGEN_ITEM("Plant bag", /obj/item/weapon/storage/bag/plants, 1, 320),
		BIOGEN_ITEM("Large plant bag", /obj/item/weapon/storage/bag/plants/large, 1, 640),
		BIOGEN_ITEM("Utility belt", /obj/item/weapon/storage/belt/utility, 1, 300),
		BIOGEN_ITEM("Leather Satchel", /obj/item/weapon/storage/backpack/satchel, 1, 400),
		BIOGEN_ITEM("Cash Bag", /obj/item/weapon/storage/bag/cash, 1, 400),
		BIOGEN_ITEM("Chemistry Bag", /obj/item/weapon/storage/bag/chemistry, 1, 400),
		BIOGEN_ITEM("Workboots", /obj/item/clothing/shoes/boots/workboots, 1, 400),
		BIOGEN_ITEM("Leather Chaps", /obj/item/clothing/under/pants/chaps, 1, 400),
		BIOGEN_ITEM("Leather Coat", /obj/item/clothing/suit/leathercoat, 1, 500),
		BIOGEN_ITEM("Leather Jacket", /obj/item/clothing/suit/storage/toggle/brown_jacket, 1, 500),
		BIOGEN_ITEM("Winter Coat", /obj/item/clothing/suit/storage/hooded/wintercoat, 1, 500),
		//VOREStation Edit - Algae for oxygen generator
		BIOGEN_ITEM("4 Algae Sheets", /obj/item/stack/material/algae, 4, 400),
		BIOGEN_ITEM("50 Algae Sheets", /obj/item/stack/material/algae, 50, 5000),
	)

/obj/machinery/biogenerator/tgui_static_data(mob/user)
	var/list/static_data[0]

	// Available items - in static data because we don't wanna compute this list every time! It hardly changes.
	static_data["items"] = list()
	for(var/cat in item_list)
		var/list/cat_items = list()
		for(var/prize_name in item_list[cat])
			var/datum/data/biogenerator_reagent/prize = item_list[cat][prize_name]
			cat_items[prize_name] = list("name" = prize_name, "price" = prize.cost, "reagent" = istype(prize))
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

/obj/machinery/biogenerator/tgui_act(action, params)
	if(..())
		return

	. = TRUE
	switch(action)
		if("activate")
			INVOKE_ASYNC(src, PROC_REF(activate))
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

			if(!(category in item_list) || !(name in item_list[category])) // Not trying something that's not in the list, are you?
				return

			var/datum/data/biogenerator_item/bi = item_list[category][name]
			if(!istype(bi))
				var/datum/data/biogenerator_reagent/br = item_list[category][name]
				if(!istype(br))
					return
				if(!beaker)
					return
				var/cost = round(br.cost / build_eff)
				if(cost > points)
					to_chat(usr, "<span class='danger'>Insufficient biomass.</span>")
					return
				var/amt_to_actually_dispense = round(min(beaker.reagents.get_free_space(), br.reagent_amt))
				if(amt_to_actually_dispense <= 0)
					to_chat(usr, "<span class='danger'>The loaded beaker is full!</span>")
					return
				points -= (cost * (amt_to_actually_dispense / br.reagent_amt))
				beaker.reagents.add_reagent(br.reagent_id, amt_to_actually_dispense)
				playsound(src, 'sound/machines/reagent_dispense.ogg', 25, 1)
				return

			var/cost = round(bi.cost / build_eff)
			if(cost > points)
				to_chat(usr, "<span class='danger'>Insufficient biomass.</span>")
				return

			points -= cost
			if(ispath(bi.equipment_path, /obj/item/stack))
				new bi.equipment_path(loc, bi.equipment_amt)
				playsound(src, 'sound/machines/vending/vending_drop.ogg', 100, 1)
				return TRUE

			for(var/i in 1 to bi.equipment_amt)
				new bi.equipment_path(loc)
				playsound(src, 'sound/machines/vending/vending_drop.ogg', 100, 1)
			return TRUE
		else
			return FALSE

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

/obj/machinery/biogenerator/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(default_deconstruction_screwdriver(user, O))
		return
	if(default_deconstruction_crowbar(user, O))
		return
	if(default_part_replacement(user, O))
		return
	if(default_unfasten_wrench(user, O, 40))
		return
	if(istype(O, /obj/item/weapon/reagent_containers/glass))
		if(beaker)
			to_chat(user, "<span class='notice'>\The [src] is already loaded.</span>")
		else
			user.remove_from_mob(O)
			O.loc = src
			beaker = O
			updateUsrDialog()
	else if(processing)
		to_chat(user, "<span class='notice'>\The [src] is currently processing.</span>")
	else if(istype(O, /obj/item/weapon/storage/bag/plants))
		var/i = 0
		for(var/obj/item/weapon/reagent_containers/food/snacks/grown/G in contents)
			i++
		if(i >= 10)
			to_chat(user, "<span class='notice'>\The [src] is already full! Activate it.</span>")
		else
			for(var/obj/item/weapon/reagent_containers/food/snacks/grown/G in O.contents)
				G.loc = src
				i++
				if(i >= 10)
					to_chat(user, "<span class='notice'>You fill \the [src] to its capacity.</span>")
					break
			if(i < 10)
				to_chat(user, "<span class='notice'>You empty \the [O] into \the [src].</span>")


	else if(!istype(O, /obj/item/weapon/reagent_containers/food/snacks/grown))
		to_chat(user, "<span class='notice'>You cannot put this in \the [src].</span>")
	else
		var/i = 0
		for(var/obj/item/weapon/reagent_containers/food/snacks/grown/G in contents)
			i++
		if(i >= 10)
			to_chat(user, "<span class='notice'>\The [src] is full! Activate it.</span>")
		else
			user.remove_from_mob(O)
			O.loc = src
			to_chat(user, "<span class='notice'>You put \the [O] in \the [src]</span>")
	update_icon()
	return

/obj/machinery/biogenerator/attack_hand(mob/user as mob)
	if(stat & BROKEN)
		return
	tgui_interact(user)

/obj/machinery/biogenerator/proc/activate()
	if(usr.stat)
		return
	if(stat) //NOPOWER etc
		return
	if(processing)
		to_chat(usr, "<span class='notice'>The biogenerator is in the process of working.</span>")
		return
	var/S = 0
	for(var/obj/item/weapon/reagent_containers/food/snacks/grown/I in contents)
		S += 5
		if(I.reagents.get_reagent_amount("nutriment") < 0.1)
			points += 1
		else points += I.reagents.get_reagent_amount("nutriment") * 10 * eat_eff
		qdel(I)
	if(S)
		processing = 1
		update_icon()
		playsound(src, 'sound/machines/blender.ogg', 40, 1)
		use_power(S * 30)
		sleep((S + 15) / eat_eff)
		processing = 0
		SStgui.update_uis(src)
		playsound(src, 'sound/machines/biogenerator_end.ogg', 40, 1)
		update_icon()
	else
		to_chat(usr, "<span class='warning'>Error: No growns inside. Please insert growns.</span>")
	return

/obj/machinery/biogenerator/RefreshParts()
	..()
	var/man_rating = 0
	var/bin_rating = 0

	for(var/obj/item/weapon/stock_parts/P in component_parts)
		if(istype(P, /obj/item/weapon/stock_parts/matter_bin))
			bin_rating += P.rating
		if(istype(P, /obj/item/weapon/stock_parts/manipulator))
			man_rating += P.rating

	build_eff = man_rating
	eat_eff = bin_rating
