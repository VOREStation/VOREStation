/* Stack type objects!
 * Contains:
 * 		Stacks
 * 		Recipe datum
 * 		Recipe list datum
 */

/*
 * Stacks
 */

/obj/item/stack
	gender = PLURAL
	origin_tech = list(TECH_MATERIAL = 1)
	icon = 'icons/obj/stacks.dmi'
	randpixel = 7
	center_of_mass = null
	var/list/datum/stack_recipe/recipes
	var/singular_name
	var/amount = 1
	var/max_amount //also see stack recipes initialisation, param "max_res_amount" must be equal to this max_amount
	var/stacktype //determines whether different stack types can merge
	var/build_type = null //used when directly applied to a turf
	var/uses_charge = 0
	var/list/charge_costs = null
	var/list/datum/matter_synth/synths = null
	var/no_variants = TRUE // Determines whether the item should update it's sprites based on amount.

	var/pass_color = FALSE // Will the item pass its own color var to the created item? Dyed cloth, wood, etc.
	var/strict_color_stacking = FALSE // Will the stack merge with other stacks that are different colors? (Dyed cloth, wood, etc)

/obj/item/stack/Initialize(var/ml, var/starting_amount)
	. = ..()
	if(!stacktype)
		stacktype = type
	if(!isnull(starting_amount)) // Could be 0
		// Negative numbers are 'give full stack', like -1
		if(starting_amount < 0)
			// But sometimes a coder forgot to define what that even means
			if(max_amount)
				starting_amount = max_amount
			else
				starting_amount = 1
		set_amount(starting_amount, TRUE)
	update_icon()

/obj/item/stack/Destroy()
	if(uses_charge)
		return 1
	if (src && usr && usr.machine == src)
		usr << browse(null, "window=stack")
	return ..()

/obj/item/stack/update_icon()
	if(no_variants)
		icon_state = initial(icon_state)
	else
		if(amount <= (max_amount * (1/3)))
			icon_state = initial(icon_state)
		else if (amount <= (max_amount * (2/3)))
			icon_state = "[initial(icon_state)]_2"
		else
			icon_state = "[initial(icon_state)]_3"
		item_state = initial(icon_state)

/obj/item/stack/proc/get_examine_string()
	if(!uses_charge)
		return "There [src.amount == 1 ? "is" : "are"] [src.amount] [src.singular_name]\s in the stack."
	else
		return "There is enough charge for [get_amount()]."

/obj/item/stack/examine(mob/user)
	. = ..()

	if(Adjacent(user))
		. += get_examine_string()

/obj/item/stack/attack_self(mob/user)
	tgui_interact(user)

/obj/item/stack/tgui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Stack", name)
		ui.open()

/obj/item/stack/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = ..()

	data["amount"] = get_amount()

	return data

/obj/item/stack/tgui_static_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = ..()

	data["recipes"] = recursively_build_recipes(recipes)

	return data

/obj/item/stack/proc/recursively_build_recipes(list/recipe_to_iterate)
	var/list/L = list()
	for(var/recipe in recipe_to_iterate)
		if(istype(recipe, /datum/stack_recipe_list))
			var/datum/stack_recipe_list/R = recipe
			L["[R.title]"] = recursively_build_recipes(R.recipes)
		if(istype(recipe, /datum/stack_recipe))
			var/datum/stack_recipe/R = recipe
			L["[R.title]"] = build_recipe(R)

	return L

/obj/item/stack/proc/build_recipe(datum/stack_recipe/R)
	return list(
		"res_amount" = R.res_amount,
		"max_res_amount" = R.max_res_amount,
		"req_amount" = R.req_amount,
		"ref" = "\ref[R]",
	)

/obj/item/stack/tgui_state(mob/user)
	return GLOB.tgui_hands_state

/obj/item/stack/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	if(..())
		return TRUE

	switch(action)
		if("make")
			if(get_amount() < 1)
				qdel(src)
				return

			var/datum/stack_recipe/R = locate(params["ref"])
			if(!is_valid_recipe(R, recipes)) //href exploit protection
				return FALSE
			var/multiplier = text2num(params["multiplier"])
			if(!multiplier || (multiplier <= 0)) //href exploit protection
				return
			produce_recipe(R, multiplier, usr)
			return TRUE

/obj/item/stack/proc/is_valid_recipe(datum/stack_recipe/R, list/recipe_list)
	for(var/S in recipe_list)
		if(S == R)
			return TRUE
		if(istype(S, /datum/stack_recipe_list))
			var/datum/stack_recipe_list/L = S
			if(is_valid_recipe(R, L.recipes))
				return TRUE

	return FALSE

/obj/item/stack/proc/produce_recipe(datum/stack_recipe/recipe, var/quantity, mob/user)
	var/required = quantity*recipe.req_amount
	var/produced = min(quantity*recipe.res_amount, recipe.max_res_amount)

	if (!can_use(required))
		if (produced>1)
			to_chat(user, "<span class='warning'>You haven't got enough [src] to build \the [produced] [recipe.title]\s!</span>")
		else
			to_chat(user, "<span class='warning'>You haven't got enough [src] to build \the [recipe.title]!</span>")
		return

	if (recipe.one_per_turf && (locate(recipe.result_type) in user.loc))
		to_chat(user, "<span class='warning'>There is another [recipe.title] here!</span>")
		return

	if (recipe.on_floor && !isfloor(user.loc))
		to_chat(user, "<span class='warning'>\The [recipe.title] must be constructed on the floor!</span>")
		return

	if (recipe.time)
		to_chat(user, "<span class='notice'>Building [recipe.title] ...</span>")
		if (!do_after(user, recipe.time))
			return

	if (use(required))
		var/atom/O
		if(recipe.use_material)
			O = new recipe.result_type(user.loc, recipe.use_material)

			if(istype(O, /obj))
				var/obj/Ob = O

				if(LAZYLEN(Ob.matter))	// Law of equivalent exchange.
					Ob.matter.Cut()

				else
					Ob.matter = list()

				var/mattermult = istype(Ob, /obj/item) ? min(2000, 400 * Ob.w_class) : 2000

				Ob.matter[recipe.use_material] = mattermult / produced * required

		else
			O = new recipe.result_type(user.loc)

			if(recipe.matter_material)
				if(istype(O, /obj))
					var/obj/Ob = O

					if(LAZYLEN(Ob.matter))	// Law of equivalent exchange.
						Ob.matter.Cut()

					else
						Ob.matter = list()

					var/mattermult = istype(Ob, /obj/item) ? min(2000, 400 * Ob.w_class) : 2000

					Ob.matter[recipe.matter_material] = mattermult / produced * required

		O.set_dir(user.dir)
		O.add_fingerprint(user)
		//VOREStation Addition Start - Let's not store things that get crafted with materials like this, they won't spawn correctly when retrieved.
		if (isobj(O))
			var/obj/P = O
			P.persist_storable = FALSE
		//VOREStation Addition End
		if (istype(O, /obj/item/stack))
			var/obj/item/stack/S = O
			S.amount = produced
			S.add_to_stacks(user)

		if (istype(O, /obj/item/storage)) //BubbleWrap - so newly formed boxes are empty
			for (var/obj/item/I in O)
				qdel(I)

		if ((pass_color || recipe.pass_color))
			if(!color)
				if(recipe.use_material)
					var/datum/material/MAT = get_material_by_name(recipe.use_material)
					if(MAT.icon_colour)
						O.color = MAT.icon_colour
				else
					return
			else
				O.color = color

//Return 1 if an immediate subsequent call to use() would succeed.
//Ensures that code dealing with stacks uses the same logic
/obj/item/stack/proc/can_use(var/used)
	if(used < 0 || (used != round(used)))
		stack_trace("Tried to use a bad stack amount: [used]")
		return 0
	if(get_amount() < used)
		return 0
	return 1

/obj/item/stack/proc/use(var/used)
	if(!can_use(used))
		return 0
	if(!uses_charge)
		amount -= used
		if (amount <= 0)
			qdel(src) //should be safe to qdel immediately since if someone is still using this stack it will persist for a little while longer
		update_icon()
		return 1
	else
		if(get_amount() < used)
			return 0
		for(var/i = 1 to uses_charge)
			var/datum/matter_synth/S = synths[i]
			S.use_charge(charge_costs[i] * used) // Doesn't need to be deleted
		return 1

/obj/item/stack/proc/add(var/extra)
	if(extra < 0 || (extra != round(extra)))
		stack_trace("Tried to add a bad stack amount: [extra]")
		return 0
	if(!uses_charge)
		if(amount + extra > get_max_amount())
			return 0
		else
			amount += extra
		update_icon()
		return 1
	else if(!synths || synths.len < uses_charge)
		return 0
	else
		for(var/i = 1 to uses_charge)
			var/datum/matter_synth/S = synths[i]
			S.add_charge(charge_costs[i] * extra)

/obj/item/stack/proc/set_amount(var/new_amount, var/no_limits = FALSE)
	if(new_amount < 0 || (new_amount != round(new_amount)))
		stack_trace("Tried to set a bad stack amount: [new_amount]")
		return 0

	// Clean up the new amount
	new_amount = max(round(new_amount), 0)

	// Can exceed max if you really want
	if(new_amount > max_amount && !no_limits)
		new_amount = max_amount

	amount = new_amount

	// Can set it to 0 without qdel if you really want
	if(amount == 0 && !no_limits)
		qdel(src)
		return FALSE

	return TRUE

/*
	The transfer and split procs work differently than use() and add().
	Whereas those procs take no action if the desired amount cannot be added or removed these procs will try to transfer whatever they can.
	They also remove an equal amount from the source stack.
*/

//attempts to transfer amount to S, and returns the amount actually transferred
/obj/item/stack/proc/transfer_to(obj/item/stack/S, var/tamount=null, var/type_verified)
	if (!get_amount())
		return 0
	if ((stacktype != S.stacktype) && !type_verified)
		return 0
	if ((strict_color_stacking || S.strict_color_stacking) && S.color != color)
		return 0

	if (isnull(tamount))
		tamount = src.get_amount()

	if(tamount < 0 || (tamount != round(tamount)))
		stack_trace("Tried to transfer a bad stack amount: [tamount]")
		return 0

	var/transfer = max(min(tamount, src.get_amount(), (S.get_max_amount() - S.get_amount())), 0)

	var/orig_amount = src.get_amount()
	if (transfer && src.use(transfer))
		S.add(transfer)
		if (prob(transfer/orig_amount * 100))
			transfer_fingerprints_to(S)
			if(blood_DNA)
				if(S.blood_DNA)
					S.blood_DNA |= blood_DNA
				else
					S.blood_DNA = blood_DNA.Copy()
		return transfer
	return 0

//creates a new stack with the specified amount
/obj/item/stack/proc/split(var/tamount)
	if (!amount)
		return null
	if(uses_charge)
		return null

	if(tamount < 0 || (tamount != round(tamount)))
		stack_trace("Tried to split a bad stack amount: [tamount]")
		return null

	var/transfer = max(min(tamount, src.amount, initial(max_amount)), 0)

	var/orig_amount = src.amount
	if (transfer && src.use(transfer))
		var/obj/item/stack/newstack = new src.type(loc, transfer)
		newstack.color = color
		if (prob(transfer/orig_amount * 100))
			transfer_fingerprints_to(newstack)
			if(blood_DNA)
				newstack.blood_DNA |= blood_DNA
		return newstack
	return null

/obj/item/stack/proc/get_amount()
	if(uses_charge)
		if(!synths || synths.len < uses_charge)
			return 0
		var/datum/matter_synth/S = synths[1]
		. = round(S.get_charge() / charge_costs[1])
		if(uses_charge > 1)
			for(var/i = 2 to uses_charge)
				S = synths[i]
				. = min(., round(S.get_charge() / charge_costs[i]))
		return
	return amount

/obj/item/stack/proc/get_max_amount()
	if(uses_charge)
		if(!synths || synths.len < uses_charge)
			return 0
		var/datum/matter_synth/S = synths[1]
		. = round(S.max_energy / charge_costs[1])
		if(uses_charge > 1)
			for(var/i = 2 to uses_charge)
				S = synths[i]
				. = min(., round(S.max_energy / charge_costs[i]))
		return
	return max_amount

/obj/item/stack/proc/add_to_stacks(mob/user as mob)
	for (var/obj/item/stack/item in user.loc)
		if (item==src)
			continue
		var/transfer = src.transfer_to(item)
		if (transfer)
			to_chat(user, "<span class='notice'>You add a new [item.singular_name] to the stack. It now contains [item.amount] [item.singular_name]\s.</span>")
		if(!amount)
			break

/obj/item/stack/attack_hand(mob/user as mob)
	if (user.get_inactive_hand() == src)
		var/N = tgui_input_number(usr, "How many stacks of [src] would you like to split off?  There are currently [amount].", "Split stacks", 1, amount, 1)
		if(N != round(N))
			to_chat(user, "<span class='warning'>You cannot separate a non-whole number of stacks!</span>")
			return
		if(N)
			var/obj/item/stack/F = src.split(N)
			if (F)
				user.put_in_hands(F)
				src.add_fingerprint(user)
				F.add_fingerprint(user)
				spawn(0)
					if (src && usr.machine==src)
						src.interact(usr)
	else
		..()
	return

/obj/item/stack/attackby(obj/item/W as obj, mob/user as mob)
	if (istype(W, /obj/item/stack))
		var/obj/item/stack/S = W
		src.transfer_to(S)

		spawn(0) //give the stacks a chance to delete themselves if necessary
			if (S && usr.machine==S)
				S.interact(usr)
			if (src && usr.machine==src)
				src.interact(usr)
	else
		return ..()

/obj/item/stack/proc/combine_in_loc()
	return //STUBBED for now, as it seems to randomly delete stacks

/obj/item/stack/dropped(atom/old_loc)
	. = ..()
	if(isturf(loc))
		combine_in_loc()

/obj/item/stack/Moved(atom/old_loc, direction, forced)
	. = ..()
	if(pulledby && isturf(loc))
		combine_in_loc()

/*
 * Recipe datum
 */
/datum/stack_recipe
	var/title = "ERROR"
	var/result_type
	var/req_amount = 1 //amount of material needed for this recipe
	var/res_amount = 1 //amount of stuff that is produced in one batch (e.g. 4 for floor tiles)
	var/max_res_amount = 1
	var/time = 0
	var/one_per_turf = 0
	var/on_floor = 0
	var/use_material
	var/pass_color
	var/matter_material 	// Material type used for recycling. Default, uses use_material. For non-material-based objects however, matter_material is needed.

/datum/stack_recipe/New(title, result_type, req_amount = 1, res_amount = 1, max_res_amount = 1, time = 0, one_per_turf = 0, on_floor = 0, supplied_material = null, pass_stack_color, recycle_material = null)
	src.title = title
	src.result_type = result_type
	src.req_amount = req_amount
	src.res_amount = res_amount
	src.max_res_amount = max_res_amount
	src.time = time
	src.one_per_turf = one_per_turf
	src.on_floor = on_floor
	src.use_material = supplied_material
	src.pass_color = pass_stack_color

	if(!recycle_material && src.use_material)
		src.matter_material = src.use_material

	else if(recycle_material)
		src.matter_material = recycle_material

/*
 * Recipe list datum
 */
/datum/stack_recipe_list
	var/title = "ERROR"
	var/list/recipes = null
/datum/stack_recipe_list/New(title, recipes)
	src.title = title
	src.recipes = recipes
