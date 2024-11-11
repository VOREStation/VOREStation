/datum/component/personal_crafting/Initialize()
	if(ismob(parent))
		RegisterSignal(parent, COMSIG_MOB_CLIENT_LOGIN, PROC_REF(create_mob_button))

/datum/component/personal_crafting/proc/create_mob_button(mob/user, client/CL)
	// SIGNAL_HANDLER

	var/datum/hud/H = user.hud_used
	var/obj/screen/craft/C = new()
	C.icon = H.ui_style
	C.color = H.ui_color
	C.alpha = H.ui_alpha
	LAZYADD(H.other_important, C)
	CL.screen += C
	RegisterSignal(C, COMSIG_CLICK, PROC_REF(component_ui_interact))

/datum/component/personal_crafting
	var/busy
	var/viewing_category = 1 //typical powergamer starting on the Weapons tab
	var/viewing_subcategory = 1
	var/list/categories = list(
				CAT_WEAPONRY = list(
					CAT_WEAPON,
					CAT_AMMO,
				),
				CAT_ROBOT = CAT_NONE,
				CAT_MISC = CAT_NONE,
				CAT_PRIMAL = CAT_NONE,
				CAT_FOOD = list(
					CAT_BREAD,
					CAT_BURGER,
					CAT_CAKE,
					CAT_EGG,
					CAT_ICE,
					CAT_MEAT,
					CAT_MISCFOOD,
					CAT_PASTRY,
					CAT_PIE,
					CAT_PIZZA,
					CAT_SALAD,
					CAT_SANDWICH,
					CAT_SOUP,
					CAT_SPAGHETTI,
				),
				CAT_DRINK = CAT_NONE,
				CAT_CLOTHING = CAT_NONE,
			)

	var/cur_category = CAT_NONE
	var/cur_subcategory = CAT_NONE
	var/datum/action/innate/crafting/button
	var/display_craftable_only = FALSE
	var/display_compact = TRUE
	var/tgui_category_hint

/* This is what procs do:
	get_environment - gets a list of things accessable for crafting by user
	get_surroundings - takes a list of things and makes a list of key-types to values-amounts of said type in the list
	check_contents - takes a recipe and a key-type list and checks if said recipe can be done with available stuff
	check_tools - takes recipe, a key-type list, and a user and checks if there are enough tools to do the stuff, checks bugs one level deep
	construct_item - takes a recipe and a user, call all the checking procs, calls do_after, checks all the things again, calls del_reqs, creates result, calls CheckParts of said result with argument being list returned by deel_reqs
	del_reqs - takes recipe and a user, loops over the recipes reqs var and tries to find everything in the list make by get_environment and delete it/add to parts list, then returns the said list
*/

// Returns a list of objects available
/datum/component/personal_crafting/proc/get_environment(atom/a, list/blacklist = null, radius_range = 1)
	. = list()

	if(!isturf(a.loc))
		return

	for(var/atom/movable/AM in range(radius_range, a))
		if(/*(AM.flags_1 & HOLOGRAM_1)  ||*/ (blacklist && (AM.type in blacklist)))
			continue
		. += AM

// Returns an associative list containing the types of tools available, and the paths of objects available
/datum/component/personal_crafting/proc/get_surroundings(atom/a, list/blacklist=null)
	. = list()
	.["tool_qualities"] = list() // List of tool types available
	.["other"] = list()          // List of reagents/material stacks available
	.["instances"] = list()      // List of /obj/items available, maybe?
	.["machinery"] = list()      // List of /obj/machinery available
	for(var/obj/object in get_environment(a, blacklist))
		if(isitem(object))
			var/obj/item/item = object
			LAZYADDASSOCLIST(.["instances"], item.type, item)
			if(istype(item, /obj/item/stack))
				var/obj/item/stack/stack = item
				.["other"][item.type] += stack.get_amount()
			else if(item.tool_qualities)
				.["tool_qualities"] |= item.tool_qualities
				.["other"][item.type] += 1
			else
				if(istype(item, /obj/item/reagent_containers))
					var/obj/item/reagent_containers/container = item
					// if(container.is_drainable())
					if(container.is_open_container()) // this isn't exactly the same
						for(var/datum/reagent/reagent in container.reagents.reagent_list)
							.["other"][reagent.type] += reagent.volume
				.["other"][item.type] += 1
		else if (istype(object, /obj/machinery))
			LAZYADDASSOCLIST(.["machinery"], object.type, object)

/**
 * Check that the contents of the recipe meet the requirements.
 *
 * user: The /mob that initated the crafting.
 * R: The /datum/crafting_recipe being attempted.
 * contents: List of items to search for R's reqs.
 */
/datum/component/personal_crafting/proc/check_contents(atom/a, datum/crafting_recipe/R, list/contents)
	var/list/item_instances = contents["instances"]
	contents = contents["other"]


	var/list/requirements_list = list()

	// Process all requirements
	for(var/list/requirement in R.reqs)
		var/satisfied = FALSE
		for(var/requirement_path in requirement)
			// Check we have the appropriate amount available in the contents list
			var/needed_amount = requirement[requirement_path]
			for(var/content_item_path in contents)
				// Right path and not blacklisted
				if(!ispath(content_item_path, requirement_path) || R.blacklist.Find(content_item_path))
					continue

				needed_amount -= contents[content_item_path]
				if(needed_amount <= 0)
					break

			if(needed_amount > 0)
				continue

			// Store the instances of what we will use for R.check_requirements() for requirement_path
			var/list/instances_list = list()
			for(var/instance_path in item_instances)
				if(ispath(instance_path, requirement_path))
					instances_list += item_instances[instance_path]

			requirements_list[requirement_path] = instances_list
			satisfied = TRUE
			break
		if(!satisfied)
			return FALSE

	return R.check_requirements(a, requirements_list)

/// Returns a boolean on whether the tool requirements of the input recipe are satisfied by the input source and surroundings.
/datum/component/personal_crafting/proc/check_tools(atom/source, datum/crafting_recipe/R, list/surroundings)
	if(!length(R.tool_behaviors) && !length(R.tool_paths))
		return TRUE
	var/list/available_tools = list()
	var/list/present_qualities = list()

	for(var/obj/item/contained_item in source.contents)
		// if(contained_item.GetComponent(/datum/component/storage))
		if(istype(contained_item, /obj/item/storage)) // cursed
			for(var/obj/item/subcontained_item in contained_item.contents)
				available_tools[subcontained_item.type] = TRUE
				for(var/behavior in subcontained_item.tool_qualities)
					present_qualities[behavior] = TRUE
		available_tools[contained_item.type] = TRUE
		for(var/behavior in contained_item.tool_qualities)
			present_qualities[behavior] = TRUE

	for(var/quality in surroundings["tool_behaviour"])
		present_qualities[quality] = TRUE

	for(var/path in surroundings["other"])
		available_tools[path] = TRUE

	for(var/required_quality in R.tool_behaviors)
		if(present_qualities[required_quality])
			continue
		return FALSE

	for(var/required_path in R.tool_paths)
		if(is_path_in_list(required_path, available_tools))
			continue
		return FALSE

	return TRUE

/datum/component/personal_crafting/proc/check_reagents(atom/source, datum/crafting_recipe/R, list/surroundings)
	var/list/reagents = surroundings["other"]
	for(var/requirement_path in R.chem_catalysts)
		if(reagents[requirement_path] < R.chem_catalysts[requirement_path])
			return FALSE
	return TRUE

/datum/component/personal_crafting/proc/check_machinery(atom/source, datum/crafting_recipe/R, list/surroundings)
	var/list/machines = surroundings["machinery"]
	for(var/machinery_path in R.machinery)
		if(!machines[machinery_path])//We don't care for volume with machines, just if one is there or not
			return FALSE
	return TRUE

/datum/component/personal_crafting/proc/check_requirements(atom/source, datum/crafting_recipe/R, list/surroundings)
	if(!check_contents(source, R, surroundings))
		return ", missing component."
	if(!check_tools(source, R, surroundings))
		return ", missing tool."
	if(!check_reagents(source, R, surroundings))
		return ", missing reagents."
	if(!check_machinery(source, R, surroundings))
		return  ", missing machinery."
	return

/datum/component/personal_crafting/proc/construct_item(atom/a, datum/crafting_recipe/R)
	var/list/surroundings = get_surroundings(a,R.blacklist)
	// var/send_feedback = 1
	. = check_requirements(a, R, surroundings)
	if(.)
		return

	if(R.one_per_turf)
		for(var/content in get_turf(a))
			if(istype(content, R.result))
				return ", object already present."

	//If we're a mob we'll try a do_after; non mobs will instead instantly construct the item
	if(ismob(a) && !do_after(a, R.time, target = a))
		return "."

	surroundings = get_surroundings(a, R.blacklist)
	. = check_requirements(a, R, surroundings)
	if(.)
		return

	var/list/parts = del_reqs(R, a)
	var/atom/movable/I = new R.result (get_turf(a.loc))
	I.CheckParts(parts, R)
	// if(send_feedback)
		// SSblackbox.record_feedback("tally", "object_crafted", 1, I.type)
	return I //Send the item back to whatever called this proc so it can handle whatever it wants to do with the new item

/*Del reqs works like this:

	Loop over reqs var of the recipe
	Set var amt to the value current cycle req is pointing to, its amount of type we need to delete
	Get var/surroundings list of things accessable to crafting by get_environment()
	Check the type of the current cycle req
		If its reagent then do a while loop, inside it try to locate() reagent containers, inside such containers try to locate needed reagent, if there isn't remove thing from surroundings
			If there is enough reagent in the search result then delete the needed amount, create the same type of reagent with the same data var and put it into deletion list
			If there isn't enough take all of that reagent from the container, put into deletion list, substract the amt var by the volume of reagent, remove the container from surroundings list and keep searching
			While doing above stuff check deletion list if it already has such reagnet, if yes merge instead of adding second one
		If its stack check if it has enough amount
			If yes create new stack with the needed amount and put in into deletion list, substract taken amount from the stack
			If no put all of the stack in the deletion list, substract its amount from amt and keep searching
			While doing above stuff check deletion list if it already has such stack type, if yes try to merge them instead of adding new one
		If its anything else just locate() in in the list in a while loop, each find --s the amt var and puts the found stuff in deletion loop

	Then do a loop over parts var of the recipe
		Do similar stuff to what we have done above, but now in deletion list, until the parts conditions are satisfied keep taking from the deletion list and putting it into parts list for return

	After its done loop over deletion list and delete all the shit that wasn't taken by parts loop

	del_reqs return the list of parts resulting object will receive as argument of CheckParts proc, on the atom level it will add them all to the contents, on all other levels it calls ..() and does whatever is needed afterwards but from contents list already
*/

/datum/component/personal_crafting/proc/del_reqs(datum/crafting_recipe/R, atom/a)
	var/list/surroundings = get_environment(a)
	var/list/parts = list("items" = list())
	if(R.get_parts_reagents_volume())
		parts["reagents"] = new /datum/reagents(R.get_parts_reagents_volume()) // Datums don't have create_reagents()
	var/list/requirements = list()
	if(R.reqs)
		for(var/list/L in R.reqs)
			requirements += L
	if(R.machinery)
		requirements += R.machinery

	// Try to find everything that was actually used to craft
	for(var/path_key in requirements)
		var/amt = requirements[path_key]
		if(amt <= 0)//since machinery can have 0 aka CRAFTING_MACHINERY_USE - i.e. use it, don't consume it!
			continue

		// If the path is in R.parts, we want to grab those to stuff into the product
		var/amt_to_transfer = 0
		if(is_path_in_list(path_key, R.parts))
			amt_to_transfer = R.parts[path_key]


		// Reagent: gotta go sniffing in all the beakers
		if(ispath(path_key, /datum/reagent))
			var/datum/reagent/reagent = path_key
			var/id = initial(reagent.id)

			for(var/obj/item/reagent_containers/RC in surroundings)
				// Found everything we need
				if(amt <= 0 && amt_to_transfer <= 0)
					break

				// If we need to keep any to put in the new object, pull it out
				if(amt_to_transfer > 0)
					var/A = RC.reagents.trans_id_to(parts["reagents"], id, amt_to_transfer)
					amt_to_transfer -= A
					amt -= A

				// If we need to consume some amount of it
				if(amt > 0)
					var/datum/reagent/RG = RC.reagents.get_reagent(id)
					var/A = min(RG.volume, amt)
					RC.reagents.remove_reagent(id, A)
					amt -= A
					SEND_SIGNAL(RC.reagents, COMSIG_REAGENTS_CRAFTING_PING)

		// Material stacks may have to accumulate across multiple stacks
		else if(ispath(path_key, /obj/item/stack))
			for(var/obj/item/stack/S in surroundings)
				if(amt <= 0 && amt_to_transfer <= 0)
					break

				// This could put 50 stacks in an object but frankly so long as the amount's right we don't care
				if(amt_to_transfer > 0)
					var/obj/item/stack/split = S.split(amt_to_transfer)
					if(istype(split))
						parts["items"] += split
						amt_to_transfer -= split.get_amount()
						amt -= split.get_amount()

				if(amt > 0)
					var/A = min(amt, S.get_amount())
					if(S.use(A))
						amt -= A


		else // Just a regular item. Find them all and delete them
			for(var/atom/movable/I in surroundings)
				if(amt <= 0 && amt_to_transfer <= 0)
					break

				if(!istype(I, path_key))
					continue

				// Special case: the reagents may be needed for other recipes
				if(istype(I, /obj/item/reagent_containers))
					var/obj/item/reagent_containers/RC = I
					if(RC.reagents.total_volume > 0)
						continue

				// We're using it for something
				amt--

				// Prepare to stuff inside product, don't delete it
				if(is_path_in_list(path_key, R.parts))
					parts["items"] += I
					amt_to_transfer--
					continue

				// Snowflake handling of reagent containers and storage atoms.
				// If we consumed them in our crafting, we should dump their contents out before qdeling them.
				if(istype(I, /obj/item/reagent_containers))
					var/obj/item/reagent_containers/container = I
					container.reagents.clear_reagents()
					// container.reagents.expose(container.loc, TOUCH)
				else if(istype(I, /obj/item/storage))
					var/obj/item/storage/container = I
					container.spill()
					container.close_all()
				qdel(I)
	return parts

/datum/component/personal_crafting/proc/component_ui_interact(source, location, control, params, user)
	// SIGNAL_HANDLER

	if(user == parent)
		INVOKE_ASYNC(src, PROC_REF(tgui_interact), user)

/datum/component/personal_crafting/tgui_state(mob/user)
	return GLOB.tgui_not_incapacitated_turf_state

//For the UI related things we're going to assume the user is a mob rather than typesetting it to an atom as the UI isn't generated if the parent is an atom
/datum/component/personal_crafting/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		cur_category = categories[1]
		if(islist(categories[cur_category]))
			var/list/subcats = categories[cur_category]
			cur_subcategory = subcats[1]
		else
			cur_subcategory = CAT_NONE
		ui = new(user, src, "PersonalCrafting")
		ui.open()

/datum/component/personal_crafting/tgui_data(mob/user)
	// ANNOYING. We won't know what category will be on top (and thus first selected) in the UI
	// until we crunch all the resources in tgui_static_data. So it just sets a hint and we
	// consume it and set the category on the first UI open
	if(tgui_category_hint)
		cur_category = tgui_category_hint
		tgui_category_hint = null
		if(islist(categories[cur_category]))
			var/list/subcats = categories[cur_category]
			cur_subcategory = subcats[1]
		else
			cur_subcategory = CAT_NONE

	var/list/data = list()
	data["busy"] = busy
	data["category"] = cur_category
	data["subcategory"] = cur_subcategory
	data["display_craftable_only"] = display_craftable_only
	data["display_compact"] = display_compact

	var/list/surroundings = get_surroundings(user)
	var/list/craftability = list()
	for(var/datum/crafting_recipe/R as anything in GLOB.crafting_recipes)

		if(!R.always_available && !(R.type in user?.mind?.learned_recipes)) //User doesn't actually know how to make this.
			continue

		if((R.category != cur_category) || (R.subcategory != cur_subcategory))
			continue

		craftability["[REF(R)]"] = check_contents(user, R, surroundings)

	data["craftability"] = craftability
	return data

/datum/component/personal_crafting/tgui_static_data(mob/user)
	var/list/data = list()

	var/list/crafting_recipes = list()
	for(var/datum/crafting_recipe/R as anything in GLOB.crafting_recipes)

		if(R.name == "") //This is one of the invalid parents that sneaks in
			GLOB.crafting_recipes -= R
			continue

		if(!R.always_available && !(R.type in user?.mind?.learned_recipes)) //User doesn't actually know how to make this.
			continue

		if(isnull(crafting_recipes[R.category]))
			crafting_recipes[R.category] = list()

		if(R.subcategory == CAT_NONE)
			crafting_recipes[R.category] += list(build_recipe_data(R))
		else
			if(isnull(crafting_recipes[R.category][R.subcategory]))
				crafting_recipes[R.category][R.subcategory] = list()
				crafting_recipes[R.category]["has_subcats"] = TRUE
			crafting_recipes[R.category][R.subcategory] += list(build_recipe_data(R))

	if(crafting_recipes.len)
		tgui_category_hint = crafting_recipes[1]

	data["crafting_recipes"] = crafting_recipes
	return data

/datum/component/personal_crafting/tgui_act(action, params, datum/tgui/ui)
	. = ..()
	if(.)
		return
	switch(action)
		if("make")
			var/datum/crafting_recipe/TR = locate(params["recipe"]) in GLOB.crafting_recipes
			busy = TRUE
			tgui_interact(ui.user)
			var/atom/movable/result = construct_item(ui.user, TR)
			if(!istext(result)) //We made an item and didn't get a fail message
				if(ismob(ui.user) && isitem(result)) //In case the user is actually possessing a non mob like a machine
					ui.user.put_in_hands(result)
				else
					result.forceMove(ui.user.drop_location())
				to_chat(ui.user, span_notice("[TR.name] constructed."))
				TR.on_craft_completion(ui.user, result)
			else
				to_chat(ui.user, span_warning("Construction failed[result]"))
			busy = FALSE
		if("toggle_recipes")
			display_craftable_only = !display_craftable_only
			. = TRUE
		if("toggle_compact")
			display_compact = !display_compact
			. = TRUE
		if("set_category")
			cur_category = params["category"]
			cur_subcategory = params["subcategory"] || ""
			. = TRUE

/datum/component/personal_crafting/proc/build_recipe_data(datum/crafting_recipe/R)
	var/list/data = list()
	data["name"] = R.name
	data["ref"] = "[REF(R)]"
	var/list/req_text = list()
	var/list/tool_list = list()
	var/list/catalyst_text = list()

	for(var/list/req in R.reqs)
		var/list/L = list()
		for(var/atom/req_atom as anything in req)
			//We just need the name, so cheat-typecast to /atom for speed (even tho Reagents are /datum they DO have a "name" var)
			//Also these are typepaths so sadly we can't just do "[a]"
			L += "[req[req_atom]] [initial(req_atom.name)]"
		req_text += L.Join(" OR ")

	for(var/obj/machinery/content as anything in R.machinery)
		req_text += "[R.reqs[content]] [initial(content.name)]"
	if(R.additional_req_text)
		req_text += R.additional_req_text
	data["req_text"] = req_text.Join(", ")

	for(var/atom/req_catalyst as anything in R.chem_catalysts)
		catalyst_text += "[R.chem_catalysts[req_catalyst]] [initial(req_catalyst.name)]"
	data["catalyst_text"] = catalyst_text.Join(", ")

	for(var/required_quality in R.tool_behaviors)
		tool_list += required_quality
	for(var/obj/item/required_path as anything in R.tool_paths)
		tool_list += initial(required_path.name)
	data["tool_text"] = tool_list.Join(", ")

	return data

//Mind helpers

/datum/mind/proc/teach_crafting_recipe(R)
	if(!learned_recipes)
		learned_recipes = list()
	learned_recipes |= R

// Screen objects
/obj/screen/craft
	name = "crafting menu"
	icon = 'icons/mob/screen/midnight.dmi'
	icon_state = "craft"
	screen_loc = ui_smallquad
