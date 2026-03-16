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

	/// The single chemical we have currently selected. Used to index `reagent_volumes`, `reagent_names`, and `reagent_ids`.
	var/mode = 1
	/// Amount of power this hypo will remove from the robot user's internal cell when a reagent's stores are replenished.
	var/charge_cost = 50
	var/charge_tick = 0
	/// Time it takes for shots to recharge (in seconds)
	var/recharge_time = 5
	/// If true, can inject through things like spacesuits and armor.
	var/bypass_protection = FALSE
	/// Affects whether the TGUI will display itself as a chem or drink dispenser.
	var/is_dispensing_drinks = FALSE
	/// String contents in the TGUI search bar.
	var/ui_chemical_search
	/// Whether or not we're dispensing just a single reagent or are dispensing multiple reagents via a recipe
	var/is_dispensing_recipe = FALSE
	/// The recipe we will dispense if `is_dispensing_recipe` is `TRUE`
	var/selected_recipe_id
	var/hypo_sound = 'sound/effects/hypospray.ogg'	// What sound do we play on use?

	var/list/reagent_ids = list(REAGENT_ID_TRICORDRAZINE, REAGENT_ID_INAPROVALINE, REAGENT_ID_ANTITOXIN, REAGENT_ID_TRAMADOL, REAGENT_ID_DEXALIN ,REAGENT_ID_SPACEACILLIN)
	/// Associated list of how many units of each reagent we have. Indexed via the reagent's ID.
	var/list/reagent_volumes = list()
	/// Associated list of the names of each of our reagents. Indexed via `mode`.
	var/list/reagent_names = list()
	/// If we're currently recording a recipe, this will be set to a list containing the recipe's steps.
	var/list/recording_recipe
	/// Associated list of the recipes we have saved. Indexed via the string ID of the recipe.
	var/list/saved_recipes = list()
	/// In the hypo's TGUI, this determines the amount buttons that will be available to change this hypo's transfer amount.
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

/// Performs a single reagent addition. Returns its success (or error) status at doing so.
/obj/item/reagent_containers/borghypo/proc/try_add_reagent(var/datum/reagents/target_reagents, var/mob/user, var/reagent_id, var/amount)
	var/reagent_volume = reagent_volumes[reagent_id]
	if(!reagent_volume || reagent_volume < amount)
		return BORGHYPO_STATUS_NOCHARGE

	if(!target_reagents.get_free_space())
		return BORGHYPO_STATUS_CONTAINERFULL

	if(hypo_sound)
		playsound(src, hypo_sound, 25, TRUE)

	var/amount_to_add = min(amount, reagent_volumes[reagent_id])
	target_reagents.add_reagent(reagent_id, amount_to_add)
	reagent_volumes[reagent_id] -= amount_to_add
	return BORGHYPO_STATUS_SUCCESS

/// Attempts to add one reagent or multiple reagents, depending on if this hypo is currently set to dispense a recipe, (see `is_dispensing_recipe`.) Returns its success (or error) status at doing so.
/obj/item/reagent_containers/borghypo/proc/try_injection(var/datum/reagents/target_reagents, var/mob/user)
	if(is_dispensing_recipe && selected_recipe_id)
		// Add reagents with our selected ID
		var/foundRecipe = saved_recipes[selected_recipe_id]
		if(!foundRecipe)
			to_chat(user, span_warning("Couldn't find recipe ") + span_boldwarning(selected_recipe_id) + span_warning("! Contact a coder."))
			return BORGHYPO_STATUS_NORECIPE
		for(var/recipe_step in foundRecipe)
			var/step_reagent_id = recipe_step["id"]
			var/step_dispense_amount = recipe_step["amount"]
			var/result = try_add_reagent(target_reagents, user, step_reagent_id, step_dispense_amount)
			switch(result)
				if(BORGHYPO_STATUS_CONTAINERFULL)
					return result
				if(BORGHYPO_STATUS_NOCHARGE)
					var/datum/reagent/empty_reagent = SSchemistry.chemical_reagents[step_reagent_id]
					to_chat(user, span_warning("[src] doesn't have enough ") + span_boldwarning(empty_reagent.name) + span_warning(" to complete this recipe!"))
					return result
		return BORGHYPO_STATUS_SUCCESS
	else
		// Just add reagents
		return try_add_reagent(target_reagents, user, reagent_ids[mode], amount_per_transfer_from_this)

/obj/item/reagent_containers/borghypo/Initialize(mapload)
	. = ..()

	for(var/T in reagent_ids)
		reagent_volumes[T] = volume
		var/datum/reagent/hypo_reagent = SSchemistry.chemical_reagents[T]
		reagent_names += hypo_reagent.name

	START_PROCESSING(SSobj, src)

/obj/item/reagent_containers/borghypo/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/reagent_containers/borghypo/process() //Every [recharge_time] seconds, recharge some reagents for the cyborg+
	if(++charge_tick < recharge_time)
		return 0
	charge_tick = 0

	if(isrobot(loc))
		var/mob/living/silicon/robot/robot_user = loc
		if(robot_user && robot_user.cell)
			for(var/T in reagent_ids)
				if(reagent_volumes[T] < volume)
					if(!robot_user.use_direct_power(charge_cost, 800))
						return 0
					reagent_volumes[T] = min(reagent_volumes[T] + 5, volume)
	return 1

/obj/item/reagent_containers/borghypo/attack(var/mob/living/M, var/mob/user)
	if(!istype(M))
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

		if(M.reagents)
			var/reagent_id = reagent_ids[mode]
			var/amount_to_add = min(amount_per_transfer_from_this, reagent_volumes[reagent_id])
			var/result = try_injection(M.reagents, user)
			if(is_dispensing_recipe)
				// Log every reagent injected in the recipe
				var/foundRecipe = saved_recipes[selected_recipe_id]
				for(var/recipe_step in foundRecipe)
					var/step_reagent_id = recipe_step["id"]
					var/step_dispense_amount = recipe_step["amount"]
					add_attack_logs(user, M, "Borg injected with [step_dispense_amount] units of '[step_reagent_id]'")
			else
				add_attack_logs(user, M, "Borg injected with [amount_to_add] units of '[reagent_id]'")
			switch(result)
				if(BORGHYPO_STATUS_CONTAINERFULL)
					balloon_alert(user, "\the [M] has too many reagents in [M.p_their()] system!")
					return
				if(BORGHYPO_STATUS_NOCHARGE)
					if(is_dispensing_recipe)
						balloon_alert(user, "not enough reagents to inject full recipe!")
						balloon_alert(M, "you feel multiple tiny pricks in quick succession!")
					else
						var/datum/reagent/empty_reagent = SSchemistry.chemical_reagents[reagent_id]
						balloon_alert(user, "\the [src] doesn't have enough [empty_reagent.name]!")
					return
				if(BORGHYPO_STATUS_NORECIPE)
					balloon_alert(user, "recipe '[selected_recipe_id]' not found!")
					return
				else
					if(is_dispensing_recipe)
						balloon_alert(user, "recipe '[selected_recipe_id]' injected into \the [M].")
						balloon_alert(M, "you feel multiple tiny pricks in quick succession!")
					else
						balloon_alert(user, "[amount_to_add] units injected into \the [M].")
						balloon_alert(M, "you feel a tiny prick!")
	return

/obj/item/reagent_containers/borghypo/attack_self(mob/user) //Change the mode
	. = ..(user)
	if(.)
		return TRUE
	tgui_interact(user)
	return

/* No longer necessary because we use TGUI for this now!
/obj/item/reagent_containers/borghypo/Topic(var/href, var/list/href_list)
	if(href_list["reagent"])
		var/t = reagent_ids.Find(href_list["reagent"])
		if(t)
			playsound(src, 'sound/effects/pop.ogg', 50, 0)
			mode = t
			var/datum/reagent/new_reagent = SSchemistry.chemical_reagents[reagent_ids[mode]]
			balloon_alert(usr, "synthesizer is now producing '[new_reagent.name]'")
*/

/obj/item/reagent_containers/borghypo/tgui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui, custom_state)
	. = ..()
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		// Assuming the user is opening the UI, empty the chem search preemptively.
		ui_chemical_search = null
		ui = new(user, src, "BorgHypo", "Integrated [is_dispensing_drinks ? "Drink Dispenser" : "Chemical Hypo"]")
		ui.open()

/obj/item/reagent_containers/borghypo/tgui_static_data(mob/user)
	var/list/static_data = list()
	static_data["isDispensingDrinks"] = is_dispensing_drinks
	static_data["minTransferAmount"] = min_transfer_amount
	static_data["maxTransferAmount"] = max_transfer_amount
	return static_data

/obj/item/reagent_containers/borghypo/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = list()
	if(!isrobot(user))
		return data
	var/mob/living/silicon/robot/robot_user = user
	data["theme"] = robot_user.get_ui_theme()
	data["amount"] = amount_per_transfer_from_this
	data["transferAmounts"] = transfer_amounts

	var/list/chemicals = list()
	for(var/key, value in reagent_volumes)
		var/datum/reagent/available_reagent = SSchemistry.chemical_reagents[key]
		// If the user is searching for a particular chemical by name, only add this one if its name matches their search!
		if((ui_chemical_search && findtext(available_reagent.name, ui_chemical_search)) || !ui_chemical_search)
			UNTYPED_LIST_ADD(chemicals, list("name" = available_reagent.name, "id" = key, "volume" = value))
	data["chemicals"] = chemicals
	data["uiChemicalSearch"] = ui_chemical_search
	data["selectedReagentId"] = reagent_ids[mode]
	data["recipes"] = saved_recipes
	data["recordingRecipe"] = recording_recipe
	data["isDispensingRecipe"] = is_dispensing_recipe
	data["selectedRecipeId"] = selected_recipe_id

	return data

/obj/item/reagent_containers/borghypo/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	. = ..()
	if(.)
		return
	switch(action)
		if("select_reagent")
			var/new_mode = reagent_ids.Find(params["selectedReagentId"])
			if(new_mode)
				var/datum/reagent/selected_reagent = SSchemistry.chemical_reagents[reagent_ids[new_mode]]
				playsound(src, 'sound/effects/pop.ogg', 50, 0)
				if(recording_recipe)
					UNTYPED_LIST_ADD(recording_recipe, list("id" = selected_reagent.id, "amount" = amount_per_transfer_from_this))
				else
					mode = new_mode
					balloon_alert(ui.user, "synthesizer is now producing '[selected_reagent.name]'")
					is_dispensing_recipe = FALSE
			. = TRUE

		if("set_amount")
			amount_per_transfer_from_this = clamp(round(text2num(params["amount"]), 1), min_transfer_amount, max_transfer_amount) // Round to nearest 1, clamp between min and max transfer amount
			. = TRUE

		if("import_config")
			var/list/our_data = params["config"]
			if(!islist(our_data))
				return FALSE
			var/list/new_recipes = list()
			for(var/key, value in our_data)
				if(istext(key) && islist(value))
					for(var/list/steps in value)
						if(istext(steps["id"]) && isnum(steps["amount"]))
							new_recipes[key] += list(list("id" = steps["id"], "amount" = steps["amount"]))
			if(length(new_recipes))
				saved_recipes = new_recipes
			. = TRUE

		if("record_recipe")
			recording_recipe = list()
			. = TRUE

		if("cancel_recording")
			recording_recipe = null
			. = TRUE

		if("clear_recipes")
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
						to_chat(ui.user, span_warning("\The [src] cannot find ") + span_boldwarning(label) + span_warning("!"))
						return
				saved_recipes[name] = recording_recipe
				recording_recipe = null
				. = TRUE

		if("remove_recipe")
			var/recipe_name = params["recipe"]
			// If we've selected the recipe we're deleting, un-select it!
			if(selected_recipe_id == recipe_name)
				selected_recipe_id = null
				is_dispensing_recipe = FALSE
			saved_recipes -= recipe_name
			. = TRUE

		if("select_recipe")
			// Make sure we actually have a recipe saved with the given name before setting it!
			var/recipe_name = params["recipe"]
			var/selectedRecipe = saved_recipes[recipe_name]
			if(!selectedRecipe)
				to_chat(ui.user, span_warning("\The [src] cannot find the recipe ") + span_boldwarning(recipe_name) + span_warning("!"))
				return
			playsound(ui.user, 'sound/effects/pop.ogg', 50, 0)
			balloon_alert(ui.user, "synthesizer is using macro: '[recipe_name]'")
			is_dispensing_recipe = TRUE
			selected_recipe_id = recipe_name
			. = TRUE

		if("set_chemical_search")
			ui_chemical_search = params["uiChemicalSearch"]
			. = TRUE


/obj/item/reagent_containers/borghypo/examine(mob/user)
	. = ..()
	if(get_dist(user, src) <= 2)
		var/datum/reagent/current_reagent = SSchemistry.chemical_reagents[reagent_ids[mode]]
		. += span_notice("It is currently producing [current_reagent.name] and has [reagent_volumes[reagent_ids[mode]]] out of [volume] units left.")

/obj/item/reagent_containers/borghypo/service
	name = "integrated drink synthesizer"
	desc = "An inbuilt synthesizer capable of fabricating a broad variety of drinks."
	icon = 'icons/obj/drinks.dmi'
	icon_state = "shaker"
	charge_cost = 20
	recharge_time = 3
	volume = 60
	max_transfer_amount = 30
	is_dispensing_drinks = TRUE
	transfer_amounts = list(5, 10, 20, 30)
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

	var/result = try_injection(target.reagents, user)
	switch(result)
		if(BORGHYPO_STATUS_CONTAINERFULL)
			if(is_dispensing_recipe)
				balloon_alert(user, "\the [target] is too full to finish the recipe!")
			else
				balloon_alert(user, "\the [target] is full!")
		if(BORGHYPO_STATUS_NOCHARGE)
			if(is_dispensing_recipe)
				balloon_alert(user, "not enough reagents to finish recipe '[selected_recipe_id]'!")
			else
				var/datum/reagent/empty_reagent = SSchemistry.chemical_reagents[reagent_ids[mode]]
				balloon_alert(user, "not enough of reagent '[empty_reagent.name]'!")
		if(BORGHYPO_STATUS_NORECIPE)
			balloon_alert(user, "recipe '[selected_recipe_id]' not found!")
		else
			if(is_dispensing_recipe)
				balloon_alert(user, "recipe '[selected_recipe_id]' dispensed to \the [target].")
			else
				balloon_alert(user, "[amount_per_transfer_from_this] units dispensed to \the [target].")
	return
