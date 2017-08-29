#define SOLID 1
#define LIQUID 2
#define GAS 3

#define REAGENTS_PER_SHEET 20


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/obj/machinery/chem_master
	name = "ChemMaster 3000"
	density = 1
	anchored = 1
	icon = 'icons/obj/chemical.dmi'
	icon_state = "mixer0"
	use_power = 1
	idle_power_usage = 20
	var/beaker = null
	var/obj/item/weapon/storage/pill_bottle/loaded_pill_bottle = null
	var/mode = 0
	var/condi = 0
	var/useramount = 15 // Last used amount
	var/pillamount = 10
	var/bottlesprite = "1"
	var/pillsprite = "1"
	var/max_pill_count = 20
	var/tab = "home"
	var/analyze_data[0]
	flags = OPENCONTAINER

/obj/machinery/chem_master/New()
	..()
	var/datum/reagents/R = new/datum/reagents(120)
	reagents = R
	R.my_atom = src

/obj/machinery/chem_master/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if (prob(50))
				qdel(src)
				return

/obj/machinery/chem_master/attackby(var/obj/item/weapon/B as obj, var/mob/user as mob)

	if(istype(B, /obj/item/weapon/reagent_containers/glass) || istype(B, /obj/item/weapon/reagent_containers/food))

		if(src.beaker)
			user << "\A [beaker] is already loaded into the machine."
			return
		src.beaker = B
		user.drop_item()
		B.loc = src
		user << "You add \the [B] to the machine!"
		icon_state = "mixer1"

	else if(istype(B, /obj/item/weapon/storage/pill_bottle))

		if(src.loaded_pill_bottle)
			user << "A \the [loaded_pill_bottle] s already loaded into the machine."
			return

		src.loaded_pill_bottle = B
		user.drop_item()
		B.loc = src
		user << "You add \the [loaded_pill_bottle] into the dispenser slot!"
	return

/obj/machinery/chem_master/attack_hand(mob/user as mob)
	if(stat & BROKEN)
		return
	user.set_machine(src)
	ui_interact(user)

/**
 *  Display the NanoUI window for the chem master.
 *
 *  See NanoUI documentation for details.
 */
/obj/machinery/chem_master/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	user.set_machine(src)

	var/list/data = list()
	data["tab"] = tab
	data["condi"] = condi

	if(loaded_pill_bottle)
		data["pillBottle"] = list("total" = loaded_pill_bottle.contents.len, "max" = loaded_pill_bottle.max_storage_space)
	else
		data["pillBottle"] = null

	if(beaker)
		var/datum/reagents/R = beaker:reagents
		var/ui_reagent_beaker_list[0]
		for(var/datum/reagent/G in R.reagent_list)
			ui_reagent_beaker_list[++ui_reagent_beaker_list.len] = list("name" = G.name, "volume" = G.volume, "description" = G.description, "id" = G.id)

		data["beaker"] = list("total_volume" = R.total_volume, "reagent_list" = ui_reagent_beaker_list)
	else
		data["beaker"] = null

	if(reagents.total_volume)
		var/ui_reagent_list[0]
		for(var/datum/reagent/N in reagents.reagent_list)
			ui_reagent_list[++ui_reagent_list.len] = list("name" = N.name, "volume" = N.volume, "description" = N.description, "id" = N.id)

		data["reagents"] = list("total_volume" = reagents.total_volume, "reagent_list" = ui_reagent_list)
	else
		data["reagents"] = null

	data["mode"] = mode

	if(analyze_data)
		data["analyzeData"] = list("name" = analyze_data["name"], "desc" = analyze_data["desc"], "blood_type" = analyze_data["blood_type"], "blood_DNA" = analyze_data["blood_DNA"])
	else
		data["analyzeData"] = null

	data["pillSprite"] = pillsprite
	data["bottleSprite"] = bottlesprite

	var/P[20] //how many pill sprites there are. Sprites are taken from chemical.dmi and can be found in nano/images/pill.png
	for(var/i = 1 to P.len)
		P[i] = i
	data["pillSpritesAmount"] = P

	data["bottleSpritesAmount"] = list(1, 2, 3, 4) //how many bottle sprites there are. Sprites are taken from chemical.dmi and can be found in nano/images/pill.png

	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "chem_master.tmpl", src.name, 575, 400)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(5)

/obj/machinery/chem_master/Topic(href, href_list)
	if(stat & (BROKEN|NOPOWER)) return
	if(usr.stat || usr.restrained()) return
	if(!in_range(src, usr)) return

	src.add_fingerprint(usr)
	usr.set_machine(src)

	if(href_list["tab_select"])
		tab = href_list["tab_select"]

	if (href_list["ejectp"])
		if(loaded_pill_bottle)
			loaded_pill_bottle.loc = src.loc
			loaded_pill_bottle = null

	if(beaker)
		var/datum/reagents/R = beaker:reagents
		if (tab == "analyze")
			analyze_data["name"] = href_list["name"]
			analyze_data["desc"] = href_list["desc"]
			if(!condi)
				if(href_list["name"] == "Blood")
					var/datum/reagent/blood/G
					for(var/datum/reagent/F in R.reagent_list)
						if(F.name == href_list["name"])
							G = F
							break
					analyze_data["name"] = G.name
					analyze_data["blood_type"] = G.data["blood_type"]
					analyze_data["blood_DNA"] = G.data["blood_DNA"]

		else if (href_list["add"])

			if(href_list["amount"])
				var/id = href_list["add"]
				var/amount = Clamp((text2num(href_list["amount"])), 0, 200)
				R.trans_id_to(src, id, amount)

		else if (href_list["addcustom"])

			var/id = href_list["addcustom"]
			useramount = input("Select the amount to transfer.", 30, useramount) as num
			useramount = Clamp(useramount, 0, 200)
			src.Topic(null, list("amount" = "[useramount]", "add" = "[id]"))

		else if (href_list["remove"])

			if(href_list["amount"])
				var/id = href_list["remove"]
				var/amount = Clamp((text2num(href_list["amount"])), 0, 200)
				if(mode)
					reagents.trans_id_to(beaker, id, amount)
				else
					reagents.remove_reagent(id, amount)


		else if (href_list["removecustom"])

			var/id = href_list["removecustom"]
			useramount = input("Select the amount to transfer.", 30, useramount) as num
			useramount = Clamp(useramount, 0, 200)
			src.Topic(null, list("amount" = "[useramount]", "remove" = "[id]"))

		else if (href_list["toggle"])
			mode = !mode

		else if (href_list["eject"])
			if(beaker)
				beaker:loc = src.loc
				beaker = null
				reagents.clear_reagents()
				icon_state = "mixer0"
		else if (href_list["createpill"] || href_list["createpill_multiple"])
			var/count = 1

			if(reagents.total_volume/count < 1) //Sanity checking.
				return

			if (href_list["createpill_multiple"])
				count = input("Select the number of pills to make.", "Max [max_pill_count]", pillamount) as num
				count = Clamp(count, 1, max_pill_count)

			if(reagents.total_volume/count < 1) //Sanity checking.
				return

			var/amount_per_pill = reagents.total_volume/count
			if (amount_per_pill > 60) amount_per_pill = 60

			var/name = sanitizeSafe(input(usr,"Name:","Name your pill!","[reagents.get_master_reagent_name()] ([amount_per_pill] units)"), MAX_NAME_LEN)

			if(reagents.total_volume/count < 1) //Sanity checking.
				return
			while (count--)
				var/obj/item/weapon/reagent_containers/pill/P = new/obj/item/weapon/reagent_containers/pill(src.loc)
				if(!name) name = reagents.get_master_reagent_name()
				P.name = "[name] pill"
				P.pixel_x = rand(-7, 7) //random position
				P.pixel_y = rand(-7, 7)
				P.icon_state = "pill"+pillsprite
				reagents.trans_to_obj(P,amount_per_pill)
				if(src.loaded_pill_bottle)
					if(loaded_pill_bottle.contents.len < loaded_pill_bottle.max_storage_space)
						P.loc = loaded_pill_bottle

		else if (href_list["createbottle"])
			if(!condi)
				var/name = sanitizeSafe(input(usr,"Name:","Name your bottle!",reagents.get_master_reagent_name()), MAX_NAME_LEN)
				var/obj/item/weapon/reagent_containers/glass/bottle/P = new/obj/item/weapon/reagent_containers/glass/bottle(src.loc)
				if(!name) name = reagents.get_master_reagent_name()
				P.name = "[name] bottle"
				P.pixel_x = rand(-7, 7) //random position
				P.pixel_y = rand(-7, 7)
				P.icon_state = "bottle-"+bottlesprite
				reagents.trans_to_obj(P,60)
				P.update_icon()
			else
				var/obj/item/weapon/reagent_containers/food/condiment/P = new/obj/item/weapon/reagent_containers/food/condiment(src.loc)
				reagents.trans_to_obj(P,50)

		else if(href_list["pill_sprite"])
			pillsprite = href_list["pill_sprite"]
		else if(href_list["bottle_sprite"])
			bottlesprite = href_list["bottle_sprite"]

	nanomanager.update_uis(src)

/obj/machinery/chem_master/attack_ai(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/chem_master/condimaster
	name = "CondiMaster 3000"
	condi = 1

////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
/obj/machinery/reagentgrinder

	name = "All-In-One Grinder"
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "juicer1"
	layer = 2.9
	density = 0
	anchored = 0
	use_power = 1
	idle_power_usage = 5
	active_power_usage = 100
	circuit = /obj/item/weapon/circuitboard/grinder
	var/inuse = 0
	var/obj/item/weapon/reagent_containers/beaker = null
	var/limit = 10
	var/list/holdingitems = list()
	var/list/sheet_reagents = list(
		/obj/item/stack/material/iron = "iron",
		/obj/item/stack/material/uranium = "uranium",
		/obj/item/stack/material/phoron = "phoron",
		/obj/item/stack/material/gold = "gold",
		/obj/item/stack/material/silver = "silver",
		/obj/item/stack/material/mhydrogen = "hydrogen"
		)

/obj/machinery/reagentgrinder/New()
	..()
	beaker = new /obj/item/weapon/reagent_containers/glass/beaker/large(src)
	component_parts = list()
	component_parts += new /obj/item/weapon/stock_parts/motor(src)
	component_parts += new /obj/item/weapon/stock_parts/gear(src)
	RefreshParts()
	return

/obj/machinery/reagentgrinder/update_icon()
	icon_state = "juicer"+num2text(!isnull(beaker))
	return

/obj/machinery/reagentgrinder/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(beaker)
		if(default_deconstruction_screwdriver(user, O))
			return
		if(default_deconstruction_crowbar(user, O))
			return

	if (istype(O,/obj/item/weapon/reagent_containers/glass) || \
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

	if(holdingitems && holdingitems.len >= limit)
		usr << "The machine cannot hold anymore items."
		return 1

	if(!istype(O))
		return

	if(istype(O,/obj/item/weapon/storage/bag/plants))
		var/obj/item/weapon/storage/bag/plants/bag = O
		var/failed = 1
		for(var/obj/item/G in O.contents)
			if(!G.reagents || !G.reagents.total_volume)
				continue
			failed = 0
			bag.remove_from_storage(G, src)
			holdingitems += G
			if(holdingitems && holdingitems.len >= limit)
				break

		if(failed)
			user << "Nothing in the plant bag is usable."
			return 1

		if(!O.contents.len)
			user << "You empty \the [O] into \the [src]."
		else
			user << "You fill \the [src] from \the [O]."

		src.updateUsrDialog()
		return 0

	if(istype(O,/obj/item/weapon/gripper))
		var/obj/item/weapon/gripper/B = O	//B, for Borg.
		if(!B.wrapped)
			user << "\The [B] is not holding anything."
			return 0
		else
			var/B_held = B.wrapped
			user << "You use \the [B] to load \the [src] with \the [B_held]."

		return 0

	if(!sheet_reagents[O.type] && (!O.reagents || !O.reagents.total_volume))
		user << "\The [O] is not suitable for blending."
		return 1

	user.remove_from_mob(O)
	O.loc = src
	holdingitems += O
	src.updateUsrDialog()
	return 0

/obj/machinery/reagentgrinder/attack_hand(mob/user as mob)
	user.set_machine(src)
	interact(user)

/obj/machinery/reagentgrinder/interact(mob/user as mob) // The microwave Menu
	var/is_chamber_empty = 0
	var/is_beaker_ready = 0
	var/processing_chamber = ""
	var/beaker_contents = ""
	var/dat = ""

	if(!inuse)
		for (var/obj/item/O in holdingitems)
			processing_chamber += "\A [O.name]<BR>"

		if (!processing_chamber)
			is_chamber_empty = 1
			processing_chamber = "Nothing."
		if (!beaker)
			beaker_contents = "<B>No beaker attached.</B><br>"
		else
			is_beaker_ready = 1
			beaker_contents = "<B>The beaker contains:</B><br>"
			var/anything = 0
			for(var/datum/reagent/R in beaker.reagents.reagent_list)
				anything = 1
				beaker_contents += "[R.volume] - [R.name]<br>"
			if(!anything)
				beaker_contents += "Nothing<br>"


		dat = {"
	<b>Processing chamber contains:</b><br>
	[processing_chamber]<br>
	[beaker_contents]<hr>
	"}
		if (is_beaker_ready && !is_chamber_empty && !(stat & (NOPOWER|BROKEN)))
			dat += "<A href='?src=\ref[src];action=grind'>Process the reagents</a><BR>"
		if(holdingitems && holdingitems.len > 0)
			dat += "<A href='?src=\ref[src];action=eject'>Eject the reagents</a><BR>"
		if (beaker)
			dat += "<A href='?src=\ref[src];action=detach'>Detach the beaker</a><BR>"
	else
		dat += "Please wait..."
	user << browse("<HEAD><TITLE>All-In-One Grinder</TITLE></HEAD><TT>[dat]</TT>", "window=reagentgrinder")
	onclose(user, "reagentgrinder")
	return


/obj/machinery/reagentgrinder/Topic(href, href_list)
	if(..())
		return
	usr.set_machine(src)
	switch(href_list["action"])
		if ("grind")
			grind()
		if("eject")
			eject()
		if ("detach")
			detach()
	src.updateUsrDialog()
	return

/obj/machinery/reagentgrinder/proc/detach()

	if (usr.stat != 0)
		return
	if (!beaker)
		return
	beaker.loc = src.loc
	beaker = null
	update_icon()

/obj/machinery/reagentgrinder/proc/eject()

	if (usr.stat != 0)
		return
	if (!holdingitems || holdingitems.len == 0)
		return

	for(var/obj/item/O in holdingitems)
		O.loc = src.loc
		holdingitems -= O
	holdingitems.Cut()

/obj/machinery/reagentgrinder/proc/grind()

	power_change()
	if(stat & (NOPOWER|BROKEN))
		return

	// Sanity check.
	if (!beaker || (beaker && beaker.reagents.total_volume >= beaker.reagents.maximum_volume))
		return

	playsound(src.loc, 'sound/machines/blender.ogg', 50, 1)
	inuse = 1

	// Reset the machine.
	spawn(60)
		inuse = 0
		interact(usr)

	// Process.
	for (var/obj/item/O in holdingitems)

		var/remaining_volume = beaker.reagents.maximum_volume - beaker.reagents.total_volume
		if(remaining_volume <= 0)
			break

		if(sheet_reagents[O.type])
			var/obj/item/stack/stack = O
			if(istype(stack))
				var/amount_to_take = max(0,min(stack.amount,round(remaining_volume/REAGENTS_PER_SHEET)))
				if(amount_to_take)
					stack.use(amount_to_take)
					if(QDELETED(stack))
						holdingitems -= stack
					beaker.reagents.add_reagent(sheet_reagents[stack.type], (amount_to_take*REAGENTS_PER_SHEET))
					continue

		if(O.reagents)
			O.reagents.trans_to(beaker, min(O.reagents.total_volume, remaining_volume))
			if(O.reagents.total_volume == 0)
				holdingitems -= O
				qdel(O)
			if (beaker.reagents.total_volume >= beaker.reagents.maximum_volume)
				break

#undef REAGENTS_PER_SHEET
