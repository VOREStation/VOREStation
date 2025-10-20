/obj/item/reagent_containers/borghypo
	name = "cyborg hypospray"
	desc = "An advanced chemical synthesizer and injection system, designed for heavy-duty medical equipment."
	icon = 'icons/obj/syringe.dmi'
	item_state = "hypo"
	icon_state = "borghypo"
	amount_per_transfer_from_this = 5
	min_transfer_amount = 1
	volume = 30
	max_transfer_amount = 10

	var/mode = 1
	var/charge_cost = 50
	var/charge_tick = 0
	var/recharge_time = 5 //Time it takes for shots to recharge (in seconds)
	var/bypass_protection = FALSE // If true, can inject through things like spacesuits and armor.
	var/ui_title = "Cyborg Chemical Synthesizer"
	var/ui_chemicals_name = "Chemicals"
	var/ui_chemical_search // Chem search bar contents
	var/ui_window_height = 540
	var/is_dispensing_recipe = FALSE // Whether or not we're dispensing just a reagent or are dispensing reagents via a recipe
	var/selected_recipe // The recipe we will dispense if the above is TRUE
	var/hypo_sound = 'sound/effects/hypospray.ogg'	// What sound do we play on use?

	var/list/reagent_ids = list(REAGENT_ID_TRICORDRAZINE, REAGENT_ID_INAPROVALINE, REAGENT_ID_ANTITOXIN, REAGENT_ID_TRAMADOL, REAGENT_ID_DEXALIN ,REAGENT_ID_SPACEACILLIN)
	var/list/reagent_volumes = list()
	var/list/reagent_names = list()
	var/list/recording_recipe
	var/list/saved_recipes = list()
	var/list/transfer_amounts = list(5, 10)

/obj/item/reagent_containers/borghypo/surgeon
	reagent_ids = list(REAGENT_ID_INAPROVALINE, REAGENT_ID_DEXALIN, REAGENT_ID_TRICORDRAZINE, REAGENT_ID_SPACEACILLIN, REAGENT_ID_OXYCODONE)

/obj/item/reagent_containers/borghypo/crisis
	reagent_ids = list(REAGENT_ID_INAPROVALINE, REAGENT_ID_BICARIDINE, REAGENT_ID_KELOTANE, REAGENT_ID_ANTITOXIN, REAGENT_ID_DEXALIN, REAGENT_ID_TRICORDRAZINE, REAGENT_ID_SPACEACILLIN, REAGENT_ID_TRAMADOL)

/obj/item/reagent_containers/borghypo/lost
	reagent_ids = list(REAGENT_ID_TRICORDRAZINE, REAGENT_ID_BICARIDINE, REAGENT_ID_DEXALIN, REAGENT_ID_ANTITOXIN, REAGENT_ID_TRAMADOL, REAGENT_ID_SPACEACILLIN)

/obj/item/reagent_containers/borghypo/merc
	name = "advanced cyborg hypospray"
	desc = "An advanced nanite and chemical synthesizer and injection system, designed for heavy-duty medical equipment.  This type is capable of safely bypassing \
	thick materials that other hyposprays would struggle with."
	bypass_protection = TRUE // Because mercs tend to be in spacesuits.
	reagent_ids = list(REAGENT_ID_HEALINGNANITES, REAGENT_ID_HYPERZINE, REAGENT_ID_TRAMADOL, REAGENT_ID_OXYCODONE, REAGENT_ID_SPACEACILLIN, REAGENT_ID_PERIDAXON, REAGENT_ID_OSTEODAXON, REAGENT_ID_MYELAMINE, REAGENT_ID_SYNTHBLOOD)

/obj/item/reagent_containers/borghypo/Initialize(mapload)
	. = ..()

	for(var/T in reagent_ids)
		reagent_volumes[T] = volume
		var/datum/reagent/R = SSchemistry.chemical_reagents[T]
		reagent_names += R.name

	START_PROCESSING(SSobj, src)

/obj/item/reagent_containers/borghypo/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/reagent_containers/borghypo/process() //Every [recharge_time] seconds, recharge some reagents for the cyborg+
	if(++charge_tick < recharge_time)
		return 0
	charge_tick = 0

	if(isrobot(loc))
		var/mob/living/silicon/robot/R = loc
		if(R && R.cell)
			for(var/T in reagent_ids)
				if(reagent_volumes[T] < volume)
					R.cell.use(charge_cost)
					reagent_volumes[T] = min(reagent_volumes[T] + 5, volume)
	return 1

/obj/item/reagent_containers/borghypo/attack(var/mob/living/M, var/mob/user)
	if(!istype(M))
		return

	if(!reagent_volumes[reagent_ids[mode]])
		balloon_alert(user, "the injector is empty.")
		return

	var/mob/living/carbon/human/H = M
	if(istype(H))
		var/obj/item/organ/external/affected = H.get_organ(user.zone_sel.selecting)
		if(!affected)
			balloon_alert(user, "\the [H] is missing that limb!")
			return
		/* since synths have oil/coolant streams now, it only makes sense that you should be able to inject stuff. preserved for posterity.
		else if(affected.robotic >= ORGAN_ROBOT)
			to_chat(user, span_danger("You cannot inject a robotic limb."))
			return
		*/

	if(M.can_inject(user, 1, ignore_thickness = bypass_protection))
		balloon_alert(user, "you inject [M] with the injector.")
		balloon_alert(M, "you feel a tiny prick!")

		if(M.reagents)
			var/t = min(amount_per_transfer_from_this, reagent_volumes[reagent_ids[mode]])
			M.reagents.add_reagent(reagent_ids[mode], t)
			reagent_volumes[reagent_ids[mode]] -= t
			add_attack_logs(user, M, "Borg injected with [reagent_ids[mode]]")
			to_chat(user, span_notice("[t] units injected. [reagent_volumes[reagent_ids[mode]]] units remaining."))

		if(hypo_sound)
			playsound(src, hypo_sound, 25)
	return

/obj/item/reagent_containers/borghypo/attack_self(mob/user as mob) //Change the mode
	tgui_interact(user)
	return

/obj/item/reagent_containers/borghypo/Topic(var/href, var/list/href_list)
	if(href_list["reagent"])
		var/t = reagent_ids.Find(href_list["reagent"])
		if(t)
			playsound(src, 'sound/effects/pop.ogg', 50, 0)
			mode = t
			var/datum/reagent/R = SSchemistry.chemical_reagents[reagent_ids[mode]]
			balloon_alert(usr, "synthesizer is now producing '[R.name]'")

/obj/item/reagent_containers/borghypo/tgui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui, custom_state)
	. = ..()
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		// Assuming the user is opening the UI, empty the chem search preemptively.
		ui_chemical_search = null
		ui = new(user, src, "BorgHypo", ui_title)
		ui.open()

/obj/item/reagent_containers/borghypo/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = list()
	data["amount"] = amount_per_transfer_from_this
	data["transferAmounts"] = transfer_amounts

	var/chemicals[0]
	for(var/key, value in reagent_volumes)
		var/datum/reagent/R = SSchemistry.chemical_reagents[key]
		// If the user is searching for a particular chemical by name, only add this one if its name matches their search!
		if((ui_chemical_search && findtext(R.name, ui_chemical_search)) || !ui_chemical_search)
			chemicals.Add(list(list("name" = R.name, "id" = key, "volume" = value))) // list in a list because Byond merges the first list...
	data["uiTitle"] = ui_title
	data["chemicals"] = chemicals
	data["uiChemicalsName"] = ui_chemicals_name
	data["uiChemicalSearch"] = ui_chemical_search
	data["uiWindowHeight"] = ui_window_height

	data["selectedReagentId"] = reagent_ids[mode]
	data["recipes"] = saved_recipes
	data["recordingRecipe"] = recording_recipe
	data["minTransferAmount"] = min_transfer_amount
	data["maxTransferAmount"] = max_transfer_amount
	data["isDispensingRecipe"] = is_dispensing_recipe
	data["selectedRecipe"] = selected_recipe
	return data

/obj/item/reagent_containers/borghypo/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	. = ..()
	if(.)
		return
	switch(action)
		if("select_reagent")
			var/t = reagent_ids.Find(params["selectedReagentId"])
			if(t)
				var/datum/reagent/R = SSchemistry.chemical_reagents[reagent_ids[t]]
				playsound(src, 'sound/effects/pop.ogg', 50, 0)
				if(recording_recipe)
					recording_recipe += list(list("id" = R.id, "amount" = amount_per_transfer_from_this))
					balloon_alert(usr, "synthesizer recorded '[R.name]'")
				else
					mode = t
					balloon_alert(usr, "synthesizer is now producing '[R.name]'")
					is_dispensing_recipe = FALSE
			. = TRUE

		if("set_amount")
			amount_per_transfer_from_this = clamp(round(text2num(params["amount"]), 1), min_transfer_amount, max_transfer_amount) // Round to nearest 1, clamp between min and max transfer amount
			. = TRUE

		if("record_recipe")
			recording_recipe = list()
			. = TRUE

		if("cancel_recording")
			recording_recipe = null
			. = TRUE

		if("clear_recipes")
			if(tgui_alert(ui.user, "Clear all recipes?", "Clear?", list("No", "Yes")) == "Yes")
				saved_recipes = list()
			. = TRUE

		if("save_recording")
			var/name = tgui_input_text(ui.user, "What do you want to name this recipe?", "Recipe Name?", "Recipe Name", MAX_NAME_LEN)
			if(tgui_status(ui.user, state) != STATUS_INTERACTIVE)
				return
			if(saved_recipes[name] && tgui_alert(ui.user, "\"[name]\" already exists, do you want to overwrite it?",, list("No", "Yes")) != "Yes")
				return
			if(name && recording_recipe)
				for(var/list/L in recording_recipe)
					var/label = L["id"]
					// Verify this hypo can dispense every chemical
					if(!reagent_ids.Find(label))
						to_chat(ui.user, span_warning("\The [src] cannot find <b>[label]</b>!"))
						return
				saved_recipes[name] = recording_recipe
				recording_recipe = null
				. = TRUE

		if("remove_recipe")
			saved_recipes -= params["recipe"]
			. = TRUE

		if("select_recipe")
			// Make sure we actually have a recipe saved with the given name before setting it!
			var/R = params["selectedRecipe"]
			if(!saved_recipes[R])
				to_chat(ui.user, span_warning("\The [src] cannot find the recipe <b>[R]</b>!"))
				return
			is_dispensing_recipe = TRUE
			selected_recipe = R
			. = TRUE

		if("set_chemical_search")
			ui_chemical_search = params["uiChemicalSearch"]
			. = TRUE


/obj/item/reagent_containers/borghypo/examine(mob/user)
	. = ..()
	if(get_dist(user, src) <= 2)
		var/datum/reagent/R = SSchemistry.chemical_reagents[reagent_ids[mode]]
		. += span_notice("It is currently producing [R.name] and has [reagent_volumes[reagent_ids[mode]]] out of [volume] units left.")

/obj/item/reagent_containers/borghypo/service
	name = "cyborg drink synthesizer"
	desc = "A portable drink dispencer."
	icon = 'icons/obj/drinks.dmi'
	icon_state = "shaker"
	charge_cost = 20
	recharge_time = 3
	volume = 60
	max_transfer_amount = 30
	ui_chemicals_name = "Drinks"
	ui_title = "Drink Synthesizer"
	ui_window_height = 590
	transfer_amounts = list(5, 10, 15, 20, 30)
	hypo_sound = 'sound/machines/reagent_dispense.ogg'
	reagent_ids = list(REAGENT_ID_ALE,
		REAGENT_ID_BEER,
		REAGENT_ID_BERRYJUICE,
		REAGENT_ID_BITTERS,
		REAGENT_ID_BLUECURACAO,
		REAGENT_ID_CIDER,
		REAGENT_ID_COFFEE,
		REAGENT_ID_COGNAC,
		REAGENT_ID_COLA,
		REAGENT_ID_CREAM,
		REAGENT_ID_DRGIBB,
		REAGENT_ID_EGG,
		REAGENT_ID_GIN,
		REAGENT_ID_GINGERALE,
		REAGENT_ID_HOTCOCO,
		REAGENT_ID_ICE,
		REAGENT_ID_ICETEA,
		REAGENT_ID_KAHLUA,
		REAGENT_ID_LEMONJUICE,
		REAGENT_ID_LEMONLIME,
		REAGENT_ID_LIMEJUICE,
		REAGENT_ID_MEAD,
		REAGENT_ID_MELONLIQUOR,
		REAGENT_ID_MILK,
		REAGENT_ID_MINT,
		REAGENT_ID_ORANGEJUICE,
		REAGENT_ID_REDWINE,
		REAGENT_ID_RUM,
		REAGENT_ID_SAKE,
		REAGENT_ID_SODAWATER,
		REAGENT_ID_SOYMILK,
		REAGENT_ID_SPACEUP,
		REAGENT_ID_SPACEMOUNTAINWIND,
		REAGENT_ID_SPACESPICE,
		REAGENT_ID_SPECIALWHISKEY,
		REAGENT_ID_SUGAR,
		REAGENT_ID_TEA,
		REAGENT_ID_TEQUILA,
		REAGENT_ID_TOMATOJUICE,
		REAGENT_ID_TONIC,
		REAGENT_ID_VERMOUTH,
		REAGENT_ID_VODKA,
		REAGENT_ID_WATER,
		REAGENT_ID_WATERMELONJUICE,
		REAGENT_ID_WHISKEY)

/obj/item/reagent_containers/borghypo/service/attack(var/mob/M, var/mob/user)
	return

/obj/item/reagent_containers/borghypo/service/afterattack(var/obj/target, var/mob/user, var/proximity)
	if(!proximity)
		return

	if(!target.is_open_container() || !target.reagents)
		return

	if(!reagent_volumes[reagent_ids[mode]])
		to_chat(user, span_notice("[src] is out of this reagent, give it some time to refill."))
		return

	if(!target.reagents.get_free_space())
		balloon_alert(user, "[target] is full!")
		return

	if(hypo_sound)
		playsound(src, hypo_sound, 25)

	var/t = min(amount_per_transfer_from_this, reagent_volumes[reagent_ids[mode]])
	target.reagents.add_reagent(reagent_ids[mode], t)
	reagent_volumes[reagent_ids[mode]] -= t
	balloon_alert(user, "transfered [t] units to [target].")
	return
