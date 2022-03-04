/*!
	This datum should be used for handling mineral contents of machines and whatever else is supposed to hold minerals and make use of them.

	Variables:
		amount - raw amount of the mineral this container is holding, calculated by the defined value SHEET_MATERIAL_AMOUNT=2000.
		max_amount - max raw amount of mineral this container can hold.
		stack_type - type of the mineral sheet the container handles, used for output.
		parent - object that this container is being used by, used for output.
		MAX_STACK_SIZE - size of a stack of mineral sheets. Constant.
*/

/datum/component/material_container
	/// The total amount of materials this material container contains
	var/total_amount = 0
	/// The maximum amount of materials this material container can contain
	var/max_amount
	/// Map of material ref -> amount
	var/list/materials //Map of key = material ref | Value = amount
	/// The list of materials that this material container can accept
	var/list/allowed_materials
	/// The typecache of things that this material container can accept
	var/list/allowed_item_typecache
	/// The last main material that was inserted into this container
	var/last_inserted_id
	/// A callback for checking wheter we can insert a material into this container
	var/datum/callback/insertion_check
	/// A callback invoked before materials are inserted into this container
	var/datum/callback/precondition
	/// A callback invoked after materials are inserted into this container
	var/datum/callback/after_insert
	/// The material container flags. See __DEFINES/materials.dm.
	var/mat_container_flags

/// Sets up the proper signals and fills the list of materials with the appropriate references.
/datum/component/material_container/Initialize(list/init_mats, max_amt = 0, _mat_container_flags=NONE, list/allowed_mats=init_mats, list/allowed_items, datum/callback/_insertion_check, datum/callback/_precondition, datum/callback/_after_insert)
	if(!isatom(parent))
		return COMPONENT_INCOMPATIBLE

	materials = list()
	max_amount = max(0, max_amt)
	mat_container_flags = _mat_container_flags

	allowed_materials = allowed_mats || list()
	if(allowed_items)
		if(ispath(allowed_items) && allowed_items == /obj/item/stack)
			allowed_item_typecache = GLOB.typecache_stack
		else
			allowed_item_typecache = typecacheof(allowed_items)

	insertion_check = _insertion_check
	precondition = _precondition
	after_insert = _after_insert

	for(var/mat in init_mats) //Make the assoc list material reference -> amount
		var/mat_ref = GET_MATERIAL_REF(mat)
		if(isnull(mat_ref))
			continue
		var/mat_amt = init_mats[mat]
		if(isnull(mat_amt))
			mat_amt = 0
		materials[mat_ref] += mat_amt

/datum/component/material_container/Destroy(force, silent)
	materials = null
	allowed_materials = null
	if(insertion_check)
		QDEL_NULL(insertion_check)
	if(precondition)
		QDEL_NULL(precondition)
	if(after_insert)
		QDEL_NULL(after_insert)
	return ..()


/datum/component/material_container/RegisterWithParent()
	. = ..()

	if(!(mat_container_flags & MATCONTAINER_NO_INSERT))
		RegisterSignal(parent, COMSIG_PARENT_ATTACKBY, .proc/on_attackby)
	if(mat_container_flags & MATCONTAINER_EXAMINE)
		RegisterSignal(parent, COMSIG_PARENT_EXAMINE, .proc/on_examine)


/datum/component/material_container/vv_edit_var(var_name, var_value)
	var/old_flags = mat_container_flags
	. = ..()
	if(var_name == NAMEOF(src, mat_container_flags) && parent)
		if(!(old_flags & MATCONTAINER_EXAMINE) && mat_container_flags & MATCONTAINER_EXAMINE)
			RegisterSignal(parent, COMSIG_PARENT_EXAMINE, .proc/on_examine)
		else if(old_flags & MATCONTAINER_EXAMINE && !(mat_container_flags & MATCONTAINER_EXAMINE))
			UnregisterSignal(parent, COMSIG_PARENT_EXAMINE)

		if(old_flags & MATCONTAINER_NO_INSERT && !(mat_container_flags & MATCONTAINER_NO_INSERT))
			RegisterSignal(parent, COMSIG_PARENT_ATTACKBY, .proc/on_attackby)
		else if(!(old_flags & MATCONTAINER_NO_INSERT) && mat_container_flags & MATCONTAINER_NO_INSERT)
			UnregisterSignal(parent, COMSIG_PARENT_ATTACKBY)


/datum/component/material_container/proc/on_examine(datum/source, mob/user, list/examine_texts)
	SIGNAL_HANDLER

	for(var/datum/material/M as anything in materials)
		var/amt = materials[M]
		if(amt)
			examine_texts += "<span class='notice'>It has [amt] units of [lowertext(M.name)] stored.</span>"

/// Proc that allows players to fill the parent with mats
/datum/component/material_container/proc/on_attackby(datum/source, obj/item/I, mob/living/user)
	SIGNAL_HANDLER

	var/list/tc = allowed_item_typecache
	if(!(mat_container_flags & MATCONTAINER_ANY_INTENT) && user.a_intent != I_HELP)
		return
	if(tc && !is_type_in_typecache(I, tc))
		if(!(mat_container_flags & MATCONTAINER_SILENT))
			to_chat(user, "<span class='warning'>[parent] won't accept [I]!</span>")
		return
	. = COMPONENT_CANCEL_ATTACK_CHAIN
	var/datum/callback/pc = precondition
	if(pc && !pc.Invoke(user))
		return
	if(istype(I, /obj/item/stack))
		var/obj/item/stack/S = I
		user_insert_stack(S, user, mat_container_flags)
		return
	var/material_amount = get_item_material_amount(I, mat_container_flags)
	if(!material_amount)
		to_chat(user, "<span class='warning'>[I] does not contain sufficient materials to be accepted by [parent].</span>")
		return
	if(!has_space(material_amount))
		to_chat(user, "<span class='warning'>[parent] is full. Please remove materials from [parent] in order to insert more.</span>")
		return
	user_insert(I, user, mat_container_flags)

/// Proc used for when player inserts a stack
/datum/component/material_container/proc/user_insert_stack(obj/item/stack/S, mob/living/user, breakdown_flags = mat_container_flags)
	var/sheets = S.get_amount()
	if(sheets < 1)
		to_chat(user, "<span class='warning'>[S] does not contain sufficient materials to be accepted by [parent].</span>")
		return

	// Cache this since S may go away after use()
	var/list/sheet_matter = S.matter

	// Calculate total amount of material for one sheet
	var/matter_per_sheet = 0
	for(var/material in sheet_matter)
		matter_per_sheet += sheet_matter[material]

		// If any part of a sheet can't go in us, the whole sheet is invalid
		if(!can_hold_material(GET_MATERIAL_REF(material)))
			to_chat(user, "<span class='warning'>[parent] cannot contain [material].</span>")
			return

	// If we can't fit the material for one sheet, we're full.
	if(!has_space(matter_per_sheet))
		to_chat(user, "<span class='warning'>[parent] is full. Please remove materials from [parent] in order to insert more.</span>")
		return

	// Calculate the maximum amount of sheets we could possibly accept.
	var/max_sheets = round((max_amount - total_amount) / matter_per_sheet)
	if(max_sheets <= 0)
		to_chat(user, "<span class='warning'>[parent] is full. Please remove materials from [parent] in order to insert more.</span>")
		return

	// Calculate the amount of sheets we're actually going to use.
	var/sheets_to_use = min(sheets, max_sheets)

	// It shouldn't be possible to add more matter than our max
	ASSERT((total_amount + (matter_per_sheet * sheets_to_use)) <= max_amount)

	// Use the amount of sheets from the stack
	if(!S.use(sheets_to_use))
		to_chat(user, "<span class='warning'>Something went wrong with your stack. Split it manually and try again.</span>")
		return

	// We're going to blindly insert all of the materials, our assertion above says it shouldn't be possible to overflow
	var/inserted = 0
	for(var/matter in sheet_matter)
		var/datum/material/MAT = GET_MATERIAL_REF(matter)
		inserted += insert_amount_mat(sheet_matter[matter] * sheets_to_use, MAT)
		last_inserted_id = matter

	// Tell the user and wrap up.
	to_chat(user, "<span class='notice'>You insert a material total of [inserted] into [parent].</span>")
	if(after_insert)
		after_insert.Invoke(S, last_inserted_id, inserted)

/// Proc used for when player inserts materials
/datum/component/material_container/proc/user_insert(obj/item/I, mob/living/user, breakdown_flags = mat_container_flags)
	set waitfor = FALSE
	var/active_held = user.get_active_hand()  // differs from I when using TK
	if(!user.unEquip(I))
		to_chat(user, "<span class='warning'>[I] is stuck to you and cannot be placed into [parent].</span>")
		return
	var/inserted = insert_item(I, breakdown_flags = mat_container_flags)
	if(inserted)
		to_chat(user, "<span class='notice'>You insert a material total of [inserted] into [parent].</span>")
		qdel(I)
		if(after_insert)
			after_insert.Invoke(I, last_inserted_id, inserted)
	else if(I == active_held)
		user.put_in_active_hand(I)

/// Proc specifically for inserting items, returns the amount of materials entered.
/datum/component/material_container/proc/insert_item(obj/item/I, multiplier = 1, breakdown_flags = mat_container_flags)
	if(QDELETED(I))
		return FALSE

	multiplier = CEILING(multiplier, 0.01)

	var/material_amount = get_item_material_amount(I, breakdown_flags)
	if(!material_amount || !has_space(material_amount))
		return FALSE

	last_inserted_id = insert_item_materials(I, multiplier, breakdown_flags)
	return material_amount

/**
 * Inserts the relevant materials from an item into this material container.
 *
 * Arguments:
 * - [source][/obj/item]: The source of the materials we are inserting.
 * - multiplier: The multiplier for the materials being inserted.
 * - breakdown_flags: The breakdown bitflags that will be used to retrieve the materials from the source
 */
/datum/component/material_container/proc/insert_item_materials(obj/item/source, multiplier = 1, breakdown_flags = mat_container_flags)
	var/primary_mat
	var/max_mat_value = 0
	var/list/item_materials = source.get_material_composition(breakdown_flags)
	for(var/MAT in item_materials)
		if(!can_hold_material(MAT))
			continue
		materials[MAT] += item_materials[MAT] * multiplier
		total_amount += item_materials[MAT] * multiplier
		if(item_materials[MAT] > max_mat_value)
			max_mat_value = item_materials[MAT]
			primary_mat = MAT

	return primary_mat

/**
 * The default check for whether we can add materials to this material container.
 *
 * Arguments:
 * - [mat][/atom/material]: The material we are checking for insertability.
 */
/datum/component/material_container/proc/can_hold_material(datum/material/mat)
	if(mat in allowed_materials)
		return TRUE
	if(istype(mat) && ((mat.name in allowed_materials) || (mat.type in allowed_materials)))
		allowed_materials += mat // This could get messy with passing lists by ref... but if you're doing that the list expansion is probably being taken care of elsewhere anyway...
		return TRUE
	if(insertion_check?.Invoke(mat))
		allowed_materials += mat
		return TRUE
	return FALSE

/// For inserting an amount of material
/datum/component/material_container/proc/insert_amount_mat(amt, datum/material/mat)
	if(amt <= 0 || !has_space(amt))
		return 0

	var/total_amount_saved = total_amount
	if(mat)
		if(!istype(mat))
			mat = GET_MATERIAL_REF(mat)
		materials[mat] += amt
		total_amount += amt
	else
		var/num_materials = length(materials)
		if(!num_materials)
			return 0

		amt /= num_materials
		for(var/i in materials)
			materials[i] += amt
			total_amount += amt
	return (total_amount - total_amount_saved)

/// Uses an amount of a specific material, effectively removing it.
/datum/component/material_container/proc/use_amount_mat(amt, datum/material/mat)
	if(!istype(mat))
		mat = GET_MATERIAL_REF(mat)

	if(!mat)
		return 0
	var/amount = materials[mat]
	if(amount < amt)
		return 0

	materials[mat] -= amt
	total_amount -= amt
	return amt

/// Proc for transfering materials to another container.
/datum/component/material_container/proc/transer_amt_to(datum/component/material_container/T, amt, datum/material/mat)
	if(!istype(mat))
		mat = GET_MATERIAL_REF(mat)
	if((amt==0)||(!T)||(!mat))
		return FALSE
	if(amt<0)
		return T.transer_amt_to(src, -amt, mat)
	var/tr = min(amt, materials[mat], T.can_insert_amount_mat(amt, mat))
	if(tr)
		use_amount_mat(tr, mat)
		T.insert_amount_mat(tr, mat)
		return tr
	return FALSE

/// Proc for checking if there is room in the component, returning the amount or else the amount lacking.
/datum/component/material_container/proc/can_insert_amount_mat(amt, datum/material/mat)
	if(!amt || !mat)
		return 0

	if((total_amount + amt) <= max_amount)
		return amt
	else
		return (max_amount - total_amount)


/// For consuming a dictionary of materials. mats is the map of materials to use and the corresponding amounts, example: list(M/datum/material/glass =100, datum/material/iron=200)
/datum/component/material_container/proc/use_materials(list/mats, multiplier=1)
	if(!mats || !length(mats))
		return FALSE

	var/list/mats_to_remove = list() //Assoc list MAT | AMOUNT

	for(var/datum/material/req_mat as anything in mats) //Loop through all required materials
		var/imat = req_mat
		if(!istype(req_mat))
			req_mat = GET_MATERIAL_REF(req_mat) //Get the ref if necesary
		if(!materials[req_mat]) //Do we have the resource?
			return FALSE //Can't afford it
		var/amount_required = mats[imat] * multiplier
		if(!(materials[req_mat] >= amount_required)) // do we have enough of the resource?
			return FALSE //Can't afford it
		mats_to_remove[req_mat] += amount_required //Add it to the assoc list of things to remove
		continue

	var/total_amount_save = total_amount

	for(var/i in mats_to_remove)
		total_amount_save -= use_amount_mat(mats_to_remove[i], i)

	return total_amount_save - total_amount

/// For spawning mineral sheets at a specific location. Used by machines to output sheets.
/datum/component/material_container/proc/retrieve_sheets(sheet_amt, datum/material/M, atom/target = null)
	if(!M.stack_type)
		return 0 //Add greyscale sheet handling here later
	if(sheet_amt <= 0)
		return 0

	if(!target)
		var/atom/parent_atom = parent
		target = parent_atom.drop_location()
	if(materials[M] < (sheet_amt * SHEET_MATERIAL_AMOUNT))
		sheet_amt = round(materials[M] / SHEET_MATERIAL_AMOUNT)

	var/obj/item/stack/S = M.stack_type
	var/max_stack_size = initial(S.max_amount)

	var/count = 0
	while(sheet_amt > max_stack_size)
		new M.stack_type(target, max_stack_size, null, list((M) = SHEET_MATERIAL_AMOUNT))
		count += max_stack_size
		use_amount_mat(sheet_amt * SHEET_MATERIAL_AMOUNT, M)
		sheet_amt -= max_stack_size
	if(sheet_amt >= 1)
		new M.stack_type(target, sheet_amt, null, list((M) = SHEET_MATERIAL_AMOUNT))
		count += sheet_amt
		use_amount_mat(sheet_amt * SHEET_MATERIAL_AMOUNT, M)
	return count


/// Proc to get all the materials and dump them as sheets
/datum/component/material_container/proc/retrieve_all(target = null)
	var/result = 0
	for(var/MAT in materials)
		var/amount = materials[MAT]
		result += retrieve_sheets(amount2sheet(amount), MAT, target)
	return result

/// Proc that returns TRUE if the container has space
/datum/component/material_container/proc/has_space(amt = 0)
	return (total_amount + amt) <= max_amount

/// Checks if its possible to afford a certain amount of materials. Takes a dictionary of materials.
/datum/component/material_container/proc/has_materials(list/mats, multiplier=1)
	if(!mats || !mats.len)
		return FALSE

	for(var/datum/material/req_mat as anything in mats) //Loop through all required materials
		var/imat = req_mat
		if(!istype(req_mat))
			if(ispath(req_mat) || istext(req_mat)) //Is this an actual material, or is it a category?
				req_mat = GET_MATERIAL_REF(req_mat) //Get the ref

			// else // Its a category. (For example MAT_CATEGORY_RIGID)
			// 	if(!has_enough_of_category(req_mat, mats[x], multiplier)) //Do we have enough of this category?
			// 		return FALSE
			// 	else
			// 		continue

		if(!has_enough_of_material(req_mat, mats[imat], multiplier))//Not a category, so just check the normal way
			return FALSE

	return TRUE

/// Returns all the categories in a recipe.
/datum/component/material_container/proc/get_categories(list/mats)
	var/list/categories = list()
	for(var/x in mats) //Loop through all required materials
		if(!istext(x)) //This means its not a category
			continue
		categories += x
	return categories

/// Returns TRUE if you have enough of the specified material.
/datum/component/material_container/proc/has_enough_of_material(datum/material/req_mat, amount, multiplier=1)
	if(!materials[req_mat]) //Do we have the resource?
		return FALSE //Can't afford it
	var/amount_required = amount * multiplier
	if(materials[req_mat] >= amount_required) // do we have enough of the resource?
		return TRUE
	return FALSE //Can't afford it

/// Returns TRUE if you have enough of a specified material category (Which could be multiple materials)
// /datum/component/material_container/proc/has_enough_of_category(category, amount, multiplier=1)
// 	for(var/i in SSmaterials.materials_by_category[category])
// 		var/datum/material/mat = i
// 		if(materials[mat] >= amount) //we have enough
// 			return TRUE
// 	return FALSE

/// Turns a material amount into the amount of sheets it should output
/datum/component/material_container/proc/amount2sheet(amt)
	if(amt >= SHEET_MATERIAL_AMOUNT)
		return round(amt / SHEET_MATERIAL_AMOUNT)
	return FALSE

/// Turns an amount of sheets into the amount of material amount it should output
/datum/component/material_container/proc/sheet2amount(sheet_amt)
	if(sheet_amt > 0)
		return sheet_amt * SHEET_MATERIAL_AMOUNT
	return FALSE


///returns the amount of material relevant to this container; if this container does not support glass, any glass in 'I' will not be taken into account
/datum/component/material_container/proc/get_item_material_amount(obj/item/I, breakdown_flags = mat_container_flags)
	if(!istype(I) || !I.matter)
		return 0
	var/material_amount = 0
	var/list/item_materials = I.get_material_composition(breakdown_flags)
	for(var/MAT in item_materials)
		if(!can_hold_material(MAT))
			continue
		material_amount += item_materials[MAT]
	return material_amount

/// Returns the amount of a specific material in this container.
/datum/component/material_container/proc/get_material_amount(datum/material/mat)
	if(!istype(mat))
		mat = GET_MATERIAL_REF(mat)
	return materials[mat]

/// List format is list(list(name = ..., amount = ..., ref = ..., etc.), list(...))
/datum/component/material_container/tgui_data(mob/user)
	var/list/data = list()

	for(var/datum/material/material as anything in materials)
		var/amount = materials[material]

		data += list(list(
			"name" = material.name,
			"ref" = REF(material),
			"amount" = amount,
			"sheets" = round(amount / SHEET_MATERIAL_AMOUNT),
			"removable" = amount >= SHEET_MATERIAL_AMOUNT,
		))

	return data
