#define ICECREAM_VANILLA 1
#define ICECREAM_CHOCOLATE 2
#define ICECREAM_STRAWBERRY 3
#define ICECREAM_BLUE 4
#define CONE_WAFFLE 5
#define CONE_CHOC 6

// Ported wholesale from Apollo Station.

/obj/machinery/icecream_vat
	name = "icecream vat"
	desc = "Ding-aling ding dong. Get your NanoTrasen-approved ice cream!"
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "icecream_vat"
	density = TRUE
	anchored = FALSE
	use_power = USE_POWER_OFF
	flags = OPENCONTAINER | NOREACT

	var/list/product_types = list()
	var/dispense_flavour = ICECREAM_VANILLA
	var/flavour_name = "vanilla"

/obj/machinery/icecream_vat/proc/get_ingredient_list(type)
	switch(type)
		if(ICECREAM_CHOCOLATE)
			return list(REAGENT_ID_MILK, REAGENT_ID_ICE, REAGENT_ID_COCO)
		if(ICECREAM_STRAWBERRY)
			return list(REAGENT_ID_MILK, REAGENT_ID_ICE, REAGENT_ID_BERRYJUICE)
		if(ICECREAM_BLUE)
			return list(REAGENT_ID_MILK, REAGENT_ID_ICE, REAGENT_ID_SINGULO)
		if(CONE_WAFFLE)
			return list(REAGENT_ID_FLOUR, REAGENT_ID_SUGAR)
		if(CONE_CHOC)
			return list(REAGENT_ID_FLOUR, REAGENT_ID_SUGAR, REAGENT_ID_COCO)
		else
			return list(REAGENT_ID_MILK, REAGENT_ID_ICE)

/obj/machinery/icecream_vat/proc/get_flavour_name(flavour_type)
	switch(flavour_type)
		if(ICECREAM_CHOCOLATE)
			return "chocolate"
		if(ICECREAM_STRAWBERRY)
			return "strawberry"
		if(ICECREAM_BLUE)
			return "blue"
		if(CONE_WAFFLE)
			return "waffle"
		if(CONE_CHOC)
			return "chocolate"
		else
			return "vanilla"

/obj/machinery/icecream_vat/Initialize(mapload)
	. = ..()
	create_reagents(100)
	while(product_types.len < 6)
		product_types.Add(5)
	reagents.add_reagent(REAGENT_ID_MILK, 5)
	reagents.add_reagent(REAGENT_ID_FLOUR, 5)
	reagents.add_reagent(REAGENT_ID_SUGAR, 5)
	reagents.add_reagent(REAGENT_ID_ICE, 5)

/obj/machinery/icecream_vat/attack_hand(mob/user)
	user.set_machine(src)
	tgui_interact(user)

/obj/machinery/icecream_vat/tgui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui, custom_state)
	. = ..()
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "IcecreamVat", name)
		ui.open()

/obj/machinery/icecream_vat/proc/build_icecream_data(list/ice_types)
	var/ice_data = list()
	if(!length(ice_types))
		return ice_data
	for(var/entry in ice_types)
		UNTYPED_LIST_ADD(ice_data, list("index" = entry, "name" = get_flavour_name(entry), "amount_left" = product_types[entry], "ingredients" = get_ingredient_list(entry)))
	return ice_data

/obj/machinery/icecream_vat/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)

	var/list/reagent_data = list()
	for(var/datum/reagent/current_reagent in reagents.reagent_list)
		UNTYPED_LIST_ADD(reagent_data, list("name" = current_reagent.name, "volume" = current_reagent.volume, "id" = current_reagent.id))

	return list(
		"current_flavor" = flavour_name,
		"icecrem_data" = build_icecream_data(list(ICECREAM_VANILLA, ICECREAM_STRAWBERRY, ICECREAM_CHOCOLATE, ICECREAM_BLUE)),
		"cone_data" = build_icecream_data(list(CONE_WAFFLE, CONE_CHOC)),
		"reagent_data" = reagent_data
	)

/obj/machinery/icecream_vat/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("index_action")
			var/index_action = text2num(params["iceIndex"])
			if(index_action <= 0)
				return FALSE
			if(index_action < 5)
				dispense_flavour = index_action
				flavour_name = get_flavour_name(dispense_flavour)
				visible_message(span_notice("[ui.user] sets [src] to dispense [flavour_name] flavoured icecream."))
				return TRUE
			if(index_action < 7)
				var/cone_name = get_flavour_name(index_action)
				if(product_types[index_action] >= 1)
					product_types[index_action] -= 1
					var/obj/item/reagent_containers/food/snacks/icecream/I = new(src.loc)
					I.cone_type = cone_name
					I.icon_state = "icecream_cone_[cone_name]"
					I.desc = "Delicious [cone_name] cone, but no ice cream."
					visible_message(span_info("[ui.user] dispenses a crunchy [cone_name] cone from [src]."))
				else
					to_chat(ui.user, span_warning("There are no [cone_name] cones left!"))
			return TRUE
		if("make_type")
			var/amount = text2num(params["amount"])
			if(amount <= 0 || amount > 10)
				return FALSE
			var/index = text2num(params["index"])
			if(index <= 0 || index > 6)
				return FALSE
			make(ui.user, index, amount)
			return TRUE
		if("clear_reagent")
			var/reagent_id = params["id"]
			if(!reagent_id)
				return FALSE
			reagents.del_reagent(reagent_id)
			return TRUE

/obj/machinery/icecream_vat/attackby(obj/item/O, mob/user)
	if(istype(O, /obj/item/reagent_containers/food/snacks/icecream))
		var/obj/item/reagent_containers/food/snacks/icecream/I = O
		if(!I.ice_creamed)
			if(product_types[dispense_flavour] > 0)
				src.visible_message("[icon2html(src,viewers(src))] " + span_info("[user] scoops delicious [flavour_name] icecream into [I]."))
				product_types[dispense_flavour] -= 1
				I.add_ice_cream(flavour_name)
			//	if(beaker)
			//		beaker.reagents.trans_to(I, 10)
				if(I.reagents.total_volume < 10)
					I.reagents.add_reagent(REAGENT_ID_SUGAR, 10 - I.reagents.total_volume)
			else
				to_chat(user, span_warning("There is not enough icecream left!"))
		else
			to_chat(user, span_notice("[O] already has icecream in it."))
		return 1
	else if(O.is_open_container())
		return
	else
		..()

/obj/machinery/icecream_vat/proc/make(mob/user, make_type, amount)
	for(var/R in get_ingredient_list(make_type))
		if(reagents.has_reagent(R, amount))
			continue
		amount = 0
		break
	if(amount)
		for(var/R in get_ingredient_list(make_type))
			reagents.remove_reagent(R, amount)
		product_types[make_type] += amount
		var/flavour = get_flavour_name(make_type)
		if(make_type > 4)
			src.visible_message(span_info("[user] cooks up some [flavour] cones."))
		else
			src.visible_message(span_info("[user] whips up some [flavour] icecream."))
	else
		to_chat(user, span_warning("You don't have the ingredients to make this."))

/obj/item/reagent_containers/food/snacks/icecream
	name = "ice cream cone"
	desc = "Delicious waffle cone, but no ice cream."
	icon_state = "icecream_cone_waffle" //default for admin-spawned cones, href_list["cone"] should overwrite this all the time
	bitesize = 3

	var/ice_creamed = 0
	var/cone_type

/obj/item/reagent_containers/food/snacks/icecream/Initialize(mapload)
	. = ..()
	create_reagents(20)
	reagents.add_reagent(REAGENT_ID_NUTRIMENT, 5)

/obj/item/reagent_containers/food/snacks/icecream/proc/add_ice_cream(flavour_name)
	name = "[flavour_name] icecream"
	add_overlay("icecream_[flavour_name]")
	desc = "Delicious [cone_type] cone with a dollop of [flavour_name] ice cream."
	ice_creamed = 1

#undef ICECREAM_VANILLA
#undef ICECREAM_CHOCOLATE
#undef ICECREAM_STRAWBERRY
#undef ICECREAM_BLUE
#undef CONE_WAFFLE
#undef CONE_CHOC
