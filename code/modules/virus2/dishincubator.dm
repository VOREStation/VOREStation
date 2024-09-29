/obj/machinery/disease2/incubator/
	name = "pathogenic incubator"
	desc = "Encourages the growth of diseases. This model comes with a dispenser system and a small radiation generator."
	density = TRUE
	anchored = TRUE
	icon = 'icons/obj/virology_vr.dmi' //VOREStation Edit
	icon_state = "incubator"
	var/obj/item/virusdish/dish
	var/obj/item/reagent_containers/glass/beaker = null
	var/radiation = 0

	var/on = 0
	var/power = 0

	var/foodsupply = 0
	var/toxins = 0

/obj/machinery/disease2/incubator/attackby(var/obj/O as obj, var/mob/user as mob)
	if(default_unfasten_wrench(user, O, 20))
		return

	if(istype(O, /obj/item/reagent_containers/glass) || istype(O,/obj/item/reagent_containers/syringe))

		if(beaker)
			to_chat(user, "\The [src] is already loaded.")
			return

		beaker = O
		user.drop_item()
		O.loc = src

		user.visible_message("[user] adds \a [O] to \the [src]!", "You add \a [O] to \the [src]!")
		SStgui.update_uis(src)

		src.attack_hand(user)
		return

	if(istype(O, /obj/item/virusdish))

		if(dish)
			to_chat(user, "The dish tray is aleady full!")
			return

		dish = O
		user.drop_item()
		O.loc = src

		user.visible_message("[user] adds \a [O] to \the [src]!", "You add \a [O] to \the [src]!")
		SStgui.update_uis(src)

		src.attack_hand(user)

/obj/machinery/disease2/incubator/attack_hand(mob/user as mob)
	if(stat & (NOPOWER|BROKEN))
		return
	tgui_interact(user)

/obj/machinery/disease2/incubator/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "DishIncubator", name)
		ui.set_autoupdate(FALSE)
		ui.open()

/obj/machinery/disease2/incubator/tgui_data(mob/user)
	var/data[0]
	data["chemicals_inserted"] = !!beaker
	data["dish_inserted"] = !!dish
	data["food_supply"] = foodsupply
	data["radiation"] = radiation
	data["toxins"] = min(toxins, 100)
	data["on"] = on
	data["system_in_use"] = foodsupply > 0 || radiation > 0 || toxins > 0
	data["chemical_volume"] = beaker ? beaker.reagents.total_volume : 0
	data["max_chemical_volume"] = beaker ? beaker.volume : 1
	data["virus"] = dish ? dish.virus2 : null
	data["growth"] = dish ? min(dish.growth, 100) : 0
	data["infection_rate"] = dish && dish.virus2 ? dish.virus2.infectionchance * 10 : 0
	data["analysed"] = dish && dish.analysed ? 1 : 0
	data["can_breed_virus"] = null
	data["blood_already_infected"] = null

	if(beaker)
		var/datum/reagent/blood/B = locate(/datum/reagent/blood) in beaker.reagents.reagent_list
		data["can_breed_virus"] = dish && dish.virus2 && B

		if(B)
			if(!B.data["virus2"])
				B.data["virus2"] = list()

			var/list/virus = B.data["virus2"]
			for (var/ID in virus)
				data["blood_already_infected"] = virus[ID]

	return data

/obj/machinery/disease2/incubator/process()
	if(dish && on && dish.virus2)
		use_power(50,EQUIP)
		if(!powered(EQUIP))
			on = 0
			icon_state = "incubator"

		if(foodsupply)
			if(dish.growth + 3 >= 100 && dish.growth < 100)
				ping("\The [src] pings, \"Sufficient viral growth density achieved.\"")

			foodsupply -= 1
			dish.growth += 3
			SStgui.update_uis(src)

		if(radiation)
			if(radiation > 50 & prob(5))
				dish.virus2.majormutate()
				if(dish.info)
					dish.info = "OUTDATED : [dish.info]"
					dish.basic_info = "OUTDATED: [dish.basic_info]"
					dish.analysed = 0
				ping("\The [src] pings, \"Mutant viral strain detected.\"")
			else if(prob(5))
				dish.virus2.minormutate()
			radiation -= 1
			SStgui.update_uis(src)
		if(toxins && prob(5))
			dish.virus2.infectionchance -= 1
			SStgui.update_uis(src)
		if(toxins > 50)
			dish.growth = 0
			dish.virus2 = null
			SStgui.update_uis(src)
	else if(!dish)
		on = 0
		icon_state = "incubator"
		SStgui.update_uis(src)

	if(beaker)
		if(foodsupply < 100 && beaker.reagents.remove_reagent("virusfood",5))
			if(foodsupply + 10 <= 100)
				foodsupply += 10
			SStgui.update_uis(src)

		if(locate(/datum/reagent/toxin) in beaker.reagents.reagent_list && toxins < 100)
			for(var/datum/reagent/toxin/T in beaker.reagents.reagent_list)
				toxins += max(T.strength,1)
				beaker.reagents.remove_reagent(T.id,1)
				if(toxins > 100)
					toxins = 100
					break
			SStgui.update_uis(src)

/obj/machinery/disease2/incubator/tgui_act(action, params)
	if(..())
		return TRUE

	var/mob/user = usr
	add_fingerprint(user)
	switch(action)
		if("ejectchem")
			if(beaker)
				beaker.loc = src.loc
				beaker = null
			. = TRUE

		if("power")
			if(dish)
				on = !on
				icon_state = on ? "incubator_on" : "incubator"
			. = TRUE

		if("ejectdish")
			if(dish)
				dish.loc = src.loc
				dish = null
			. = TRUE

		if("rad")
			radiation = min(100, radiation + 10)
			. = TRUE

		if("flush")
			radiation = 0
			toxins = 0
			foodsupply = 0
			. = TRUE

		if("virus")
			if(!dish)
				return TRUE

			var/datum/reagent/blood/B = locate(/datum/reagent/blood) in beaker.reagents.reagent_list
			if(!B)
				return TRUE

			if(!B.data["virus2"])
				B.data["virus2"] = list()

			var/list/virus = list("[dish.virus2.uniqueID]" = dish.virus2.getcopy())
			B.data["virus2"] += virus

			ping("\The [src] pings, \"Injection complete.\"")
			. = TRUE
