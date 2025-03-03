/* * * * * * * * * * * * * * * * * * * * * * * * * *
 * /datum/recipe by rastaf0            13 apr 2011 *
 * * * * * * * * * * * * * * * * * * * * * * * * * *
 * This is powerful and flexible recipe system.
 * It exists not only for food.
 * supports both reagents and objects as prerequisites.
 * In order to use this system you have to define a deriative from /datum/recipe
 * * reagents are reagents. Acid, milc, booze, etc.
 * * items are objects. Fruits, tools, circuit boards.
 * * result is type to create as new object
 * * time is optional parameter, you shall use in in your machine,
     default /datum/recipe/ procs does not rely on this parameter.
 *
 *  Functions you need:
 *  /datum/recipe/proc/make(var/obj/container as obj)
 *    Creates result inside container,
 *    deletes prerequisite reagents,
 *    transfers reagents from prerequisite objects,
 *    deletes all prerequisite objects (even not needed for recipe at the moment).
 *
 *  /proc/select_recipe(list/datum/recipe/available_recipes, obj/obj as obj, exact = 1)
 *    Wonderful function that select suitable recipe for you.
 *    obj is a machine (or magik hat) with prerequisites,
 *    exact = 0 forces algorithm to ignore superfluous stuff.
 *
 *
 *  Functions you do not need to call directly but could:
 *  /datum/recipe/proc/check_reagents(var/datum/reagents/avail_reagents)
 *  /datum/recipe/proc/check_items(var/obj/container as obj)
 *
 * */

/datum/recipe
	var/list/reagents		// Example: = list(REAGENT_ID_BERRYJUICE = 5) // do not list same reagent twice
	var/list/items			// Example: = list(/obj/item/tool/crowbar, /obj/item/welder) // place /foo/bar before /foo
	var/list/fruit			// Example: = list("fruit" = 3)
	var/coating = null		// Required coating on all items in the recipe. The default value of null explitly requires no coating
							// A value of -1 is permissive and cares not for any coatings
							// Any typepath indicates a specific coating that should be present
							// Coatings are used for batter, breadcrumbs, beer-batter, colonel's secret coating, etc

	var/result				// Example: = /obj/item/reagent_containers/food/snacks/donut/normal
	var/result_quantity = 1 // Number of instances of result that are created.
	var/time = 100			// 1/10 part of second

	//Only the reagents present in the result at compiletime are used
	#define RECIPE_REAGENT_MAX	1 //The result will contain the maximum of each reagent present between the two pools. Compiletime result, and sum of ingredients
	#define RECIPE_REAGENT_MIN 2 //As above, but the minimum, ignoring zero values.
	#define RECIPE_REAGENT_SUM 3 //The entire quantity of the ingredients are added to the result

	var/reagent_mix = RECIPE_REAGENT_MAX	//How to handle reagent differences between the ingredients and the results

	var/appliance = MICROWAVE // Which apppliances this recipe can be made in. New Recipes will DEFAULT to using the Microwave, as a catch-all (and just in case)
	// List of defines is in _defines/misc.dm. But for reference they are:
	/*
		MICROWAVE
		FRYER
		OVEN
		CANDYMAKER
		CEREALMAKER
	*/
	// This is a bitfield, more than one type can be used
	// Grill is presently unused and not listed

/datum/recipe/proc/check_reagents(var/datum/reagents/avail_reagents, var/exact = FALSE)
	if(!reagents || !reagents.len)
		return TRUE

	if(!avail_reagents)
		return FALSE

	. = TRUE
	for(var/r_r in reagents)
		var/aval_r_amnt = avail_reagents.get_reagent_amount(r_r)
		if(aval_r_amnt - reagents[r_r] >= 0)
			if(aval_r_amnt>(reagents[r_r]) && exact)
				. = FALSE
		else
			return FALSE

	if((reagents?(reagents.len):(0)) < avail_reagents.reagent_list.len)
		return FALSE
	return .

/datum/recipe/proc/check_fruit(var/obj/container, var/exact = FALSE)
	if (!fruit || !fruit.len)
		return TRUE

	. = TRUE
	if(fruit && fruit.len)
		var/list/checklist = list()
		 // You should trust Copy().
		checklist = fruit.Copy()
		for(var/obj/item/reagent_containers/food/snacks/grown/G in container)
			if(!G.seed || !G.seed.kitchen_tag || isnull(checklist[G.seed.kitchen_tag]))
				continue
			if(check_coating(G))
				checklist[G.seed.kitchen_tag]--
		for(var/ktag in checklist)
			if(!isnull(checklist[ktag]))
				if(checklist[ktag] < 0 && exact)
					. = FALSE
				else if(checklist[ktag] > 0)
					. = FALSE
					break
	return .

/datum/recipe/proc/check_items(var/obj/container as obj, var/exact = FALSE)
	if(!items || !items.len)
		return TRUE

	. = TRUE
	if(items && items.len)
		var/list/checklist = list()
		checklist = items.Copy() // You should really trust Copy
		if(istype(container, /obj/machinery))
			var/obj/machinery/machine = container
			for(var/obj/O in ((machine.contents - machine.component_parts) - machine.circuit))
				if(istype(O,/obj/item/reagent_containers/food/snacks/grown))
					continue // Fruit is handled in check_fruit().
				var/found = FALSE
				for(var/i = 1; i < checklist.len+1; i++)
					var/item_type = checklist[i]
					if (istype(O,item_type))
						checklist.Cut(i, i+1)
						found = TRUE
						break
				if(!found && exact)
					return FALSE
		else
			for(var/obj/O in container.contents)
				if(istype(O,/obj/item/reagent_containers/food/snacks/grown))
					continue // Fruit is handled in check_fruit().
				var/found = FALSE
				for(var/i = 1; i < checklist.len+1; i++)
					var/item_type = checklist[i]
					if (istype(O,item_type))
						if(check_coating(O))
							checklist.Cut(i, i+1)
							found = TRUE
							break
				if (!found && exact)
					return FALSE
		if(checklist.len)
			return FALSE
	return .

//This is called on individual items within the container.
/datum/recipe/proc/check_coating(var/obj/O, var/exact = FALSE)
	if(!istype(O,/obj/item/reagent_containers/food/snacks))
		return TRUE //Only snacks can be battered

	if (coating == -1)
		return TRUE //-1 value doesnt care

	var/obj/item/reagent_containers/food/snacks/S = O
	if (!S.coating)
		if (!coating)
			return TRUE
		return FALSE
	else if (S.coating.type == coating)
		return TRUE

	return FALSE

//general version
/datum/recipe/proc/make(var/obj/container as obj)
	var/obj/result_obj = new result(container)
	if(istype(container, /obj/machinery))
		var/obj/machinery/machine = container
		for (var/obj/O in ((machine.contents-result_obj - machine.component_parts) - machine.circuit))
			O.reagents.trans_to_obj(result_obj, O.reagents.total_volume)
			qdel(O)
	else
		for (var/obj/O in (container.contents-result_obj))
			O.reagents.trans_to_obj(result_obj, O.reagents.total_volume)
			qdel(O)
	container.reagents.clear_reagents()
	return result_obj

// food-related
// This proc is called under the assumption that the container has already been checked and found to contain the necessary ingredients
/datum/recipe/proc/make_food(var/obj/container as obj)
	if(!result)
		log_runtime(EXCEPTION(span_danger("Recipe [type] is defined without a result, please bug report this.")))
		if(istype(container, /obj/machinery/microwave))
			var/obj/machinery/microwave/M = container
			M.dispose(FALSE)

		else if(istype(container, /obj/item/reagent_containers/cooking_container))
			var/obj/item/reagent_containers/cooking_container/CC = container
			CC.clear()

		container.visible_message(span_warning("[container] inexplicably spills, and its contents are lost!"))

		return


//We will subtract all the ingredients from the container, and transfer their reagents into a holder
//We will not touch things which are not required for this recipe. They will be left behind for the caller
//to decide what to do. They may be used again to make another recipe or discarded, or merged into the results,
//thats no longer the concern of this proc
	var/datum/reagents/buffer = new /datum/reagents(10000000000, null)//


	//Find items we need
	if (items && items.len)
		for (var/i in items)
			var/obj/item/I = locate(i) in container
			if (I && I.reagents)
				I.reagents.trans_to_holder(buffer,I.reagents.total_volume)
			// Outpost 21 upport start - Handle holders dropping mobs on destruction. No more endless mice burgers
			if(istype(I,/obj/item/holder))
				var/obj/item/holder/hol = I
				if(hol.held_mob?.client)
					hol.held_mob.ghostize()
				qdel(hol.held_mob)
				hol.held_mob = null
			// Outpost 21 upport end
			qdel(I)

	//Find fruits
	if (fruit && fruit.len)
		var/list/checklist = list()
		checklist = fruit.Copy()

		for(var/obj/item/reagent_containers/food/snacks/grown/G in container)
			if(!G.seed || !G.seed.kitchen_tag || isnull(checklist[G.seed.kitchen_tag]))
				continue

			if (checklist[G.seed.kitchen_tag] > 0)
				//We found a thing we need
				checklist[G.seed.kitchen_tag]--
				if (G && G.reagents)
					G.reagents.trans_to_holder(buffer,G.reagents.total_volume)
				qdel(G)

	//And lastly deduct necessary quantities of reagents
	if (reagents && reagents.len)
		for (var/r in reagents)
			//Doesnt matter whether or not there's enough, we assume that check is done before
			container.reagents.trans_type_to(buffer, r, reagents[r])

	/*
	Now we've removed all the ingredients that were used and we have the buffer containing the total of
	all their reagents.
	Next up we create the result, and then handle the merging of reagents depending on the mix setting
	*/
	var/tally = 0

	/*
	If we have multiple results, holder will be used as a buffer to hold reagents for the result objects.
	If, as in the most common case, there is only a single result, then it will just be a reference to
	the single-result's reagents
	*/
	var/datum/reagents/holder = new/datum/reagents(10000000000)
	var/list/results = list()
	while (tally < result_quantity)
		var/obj/result_obj = new result(container)
		results.Add(result_obj)

		if (!result_obj.reagents)//This shouldn't happen
			//If the result somehow has no reagents defined, then create a new holder
			result_obj.reagents = new /datum/reagents(buffer.total_volume*1.5, result_obj)

		if (result_quantity == 1)
			qdel(holder)
			holder = result_obj.reagents
		else
			result_obj.reagents.trans_to(holder, result_obj.reagents.total_volume)
		tally++


	switch(reagent_mix)
		if (RECIPE_REAGENT_REPLACE)
			pass() //We do no transferring
		if (RECIPE_REAGENT_SUM)
			//Sum is easy, just shove the entire buffer into the result
			buffer.trans_to_holder(holder, buffer.total_volume)
		if (RECIPE_REAGENT_MAX)
			//We want the highest of each.
			//Iterate through everything in buffer. If the target has less than the buffer, then top it up
			for (var/datum/reagent/R in buffer.reagent_list)
				var/rvol = holder.get_reagent_amount(R.id)
				if (rvol < R.volume)
					//Transfer the difference
					buffer.trans_type_to(holder, R.id, R.volume-rvol)

		if (RECIPE_REAGENT_MIN)
			//Min is slightly more complex. We want the result to have the lowest from each side
			//But zero will not count. Where a side has zero its ignored and the side with a nonzero value is used
			for (var/datum/reagent/R in buffer.reagent_list)
				var/rvol = holder.get_reagent_amount(R.id)
				if (rvol == 0) //If the target has zero of this reagent
					buffer.trans_type_to(holder, R.id, R.volume)
					//Then transfer all of ours

				else if (rvol > R.volume)
					//if the target has more than ours
					//Remove the difference
					holder.remove_reagent(R.id, rvol-R.volume)


	if (results.len > 1)
		//If we're here, then holder is a buffer containing the total reagents for all the results.
		//So now we redistribute it among them
		var/total = holder.total_volume
		for (var/i in results)
			var/atom/a = i //optimisation
			holder.trans_to(a, total / results.len)

	return results

// When exact is false, extraneous ingredients are ignored
// When exact is true, extraneous ingredients will fail the recipe
// In both cases, the full set of required ingredients is still needed
/proc/select_recipe(var/list/datum/recipe/available_recipes, var/obj/obj as obj, var/exact)
	var/highest_count = 0
	var/count = 0
	for (var/datum/recipe/recipe in available_recipes)
		if(!recipe.check_reagents(obj.reagents, exact) || !recipe.check_items(obj, exact)  || !recipe.check_fruit(obj, exact))
			continue
		// Taken from cmp_recipe_complexity_dsc, but is way faster.
		count = LAZYLEN(recipe.items) + LAZYLEN(recipe.reagents) + LAZYLEN(recipe.fruit)
		if(count >= highest_count)
			highest_count = count
			. = recipe

// Both of these are just placeholders to allow special behavior for mob holders, but you can do other things in here later if you feel like it.
/datum/recipe/proc/before_cook(obj/container) // Called Before the Microwave starts delays and cooking stuff


/datum/recipe/proc/after_cook(obj/container) // Called When the Microwave is finished.

#undef RECIPE_REAGENT_MAX
#undef RECIPE_REAGENT_MIN
#undef RECIPE_REAGENT_SUM
