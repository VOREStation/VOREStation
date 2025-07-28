/datum/element/sellable
	var/sale_info = "This can be sold on the cargo shuttle if packed in a crate."
	var/needs_crate = TRUE

/datum/element/sellable/Attach(datum/target)
	. = ..()
	if(!isobj(target))
		return ELEMENT_INCOMPATIBLE
	RegisterSignal(target, COMSIG_ITEM_SOLD, PROC_REF(sell))
	RegisterSignal(target, COMSIG_ITEM_SCAN_PROFIT, PROC_REF(calculate_sell_value))
	RegisterSignal(target, COMSIG_PARENT_EXAMINE, PROC_REF(on_examine))
	return

/datum/element/sellable/Detach(datum/source)
	UnregisterSignal(source, COMSIG_ITEM_SOLD)
	UnregisterSignal(source, COMSIG_ITEM_SCAN_PROFIT)
	UnregisterSignal(source, COMSIG_PARENT_EXAMINE)
	return ..()

// Override this for sub elements that need to do complex calculations when sold
/datum/element/sellable/proc/sell_error(obj/source)
	return null // returns a string explaining why the item couldn't be sold. Otherwise null to allow it to be sold.

/datum/element/sellable/proc/calculate_sell_value(obj/source)
	return 1

/datum/element/sellable/proc/calculate_sell_quantity(obj/source)
	return 1
// End overrides

/datum/element/sellable/proc/sell(obj/source, var/datum/exported_crate/EC, var/in_crate)
	SIGNAL_HANDLER

	if(needs_crate && !in_crate)
		EC.contents = list("error" = "Error: Product was improperly packaged. Payment rendered null under terms of agreement.")
		return FALSE

	var/sell_error = sell_error(source)
	if(sell_error)
		EC.contents = list("error" = sell_error)
		return FALSE

	EC.contents[++EC.contents.len] = list(
		"object" = "\proper[source.name]",
		"value" = calculate_sell_value(source),
		"quantity" = calculate_sell_quantity(source)
	)
	EC.value += EC.contents[EC.contents.len]["value"]
	return TRUE

/datum/element/sellable/proc/on_examine(datum/source, mob/user, list/examine_texts)
	SHOULD_NOT_OVERRIDE(TRUE)
	SIGNAL_HANDLER
	if(sale_info)
		examine_texts += span_notice(sale_info)

//////////////////////////////////////////////////////////////////////////////////////////////////////
// Subtypes
//////////////////////////////////////////////////////////////////////////////////////////////////////

// Manifest papers
/datum/element/sellable/manifest/calculate_sell_value(obj/source)
	var/obj/item/paper/manifest/slip = source
	if(!slip.is_copy && slip.stamped && slip.stamped.len) //yes, the clown stamp will work. clown is the highest authority on the station, it makes sense
		return SSsupply.points_per_slip
	return 0


// Material stacks
/datum/element/sellable/material_stack/calculate_sell_value(obj/source)
	var/obj/item/stack/P = source
	var/datum/material/mat = P.get_material()
	return P.get_amount() * mat.supply_conversion_value

/datum/element/sellable/material_stack/calculate_sell_quantity(obj/source)
	var/obj/item/stack/P = source
	return P.get_amount()


// Money
/datum/element/sellable/spacecash/calculate_sell_value(obj/source)
	var/obj/item/spacecash/cashmoney = source
	return cashmoney.worth * SSsupply.points_per_money

/datum/element/sellable/spacecash/calculate_sell_quantity(obj/source)
	var/obj/item/spacecash/cashmoney = source
	return cashmoney.worth


// Research samples
/datum/element/sellable/research_sample/calculate_sell_value(obj/source)
	var/obj/item/research_sample/sample = source
	return sample.supply_value


// Research containers
/datum/element/sellable/sample_container/calculate_sell_value(obj/source)
	var/obj/item/storage/sample_container/sample_can = source
	var/sample_sum = 0
	var/obj/item/research_sample/stored_sample
	if(LAZYLEN(sample_can.contents))
		for(stored_sample in sample_can.contents)
			sample_sum += stored_sample.supply_value
	return sample_sum

/datum/element/sellable/sample_container/calculate_sell_quantity(obj/source)
	var/obj/item/storage/sample_container/sample_can = source
	return "[sample_can.contents.len] sample(s) "


// Vaccine samples
/datum/element/sellable/vaccine
	sale_info = "This can be sold on the cargo shuttle if packed in a freezer crate."

/datum/element/sellable/vaccine/sell_error(obj/source)
	if(!istype(source.loc, /obj/structure/closet/crate/freezer))
		return "Error: Product was improperly packaged. Vaccines must be sold in a freezer crate to preserve for transport. Payment rendered null under terms of agreement."
	var/obj/item/reagent_containers/glass/beaker/vial/vaccine/sale_bottle = source
	if(sale_bottle.reagents.reagent_list.len != 1 || sale_bottle.reagents.get_reagent_amount(REAGENT_ID_VACCINE) < sale_bottle.volume)
		return "Error: Tainted product in vaccine batch. Was opened, contaminated, or wasn't filled to full. Payment rendered null under terms of agreement."
	return null

/datum/element/sellable/vaccine/calculate_sell_value(obj/source)
	return 5


// Refinery chemical tanks
/datum/element/sellable/trolley_tank
	sale_info = "This can be sold on the cargo shuttle if filled with a single reagent."
	needs_crate = FALSE

/datum/element/sellable/trolley_tank/sell_error(obj/source)
	var/obj/vehicle/train/trolley_tank/tank = source
	if(!tank.reagents || tank.reagents.reagent_list.len == 0)
		return "Error: Product was not filled with any reagents to sell. Payment rendered null under terms of agreement."
	var/min_tank = (CARGOTANKER_VOLUME - 100)
	if(tank.reagents.total_volume < min_tank)
		return "Error: Product was improperly packaged. Send full tanks only (minimum [min_tank] units). Payment rendered null under terms of agreement."
	if(tank.reagents.reagent_list.len > 1)
		return "Error: Product was improperly refined. Send purified mixtures only (too many reagents in tank). Payment rendered null under terms of agreement."
	return null

/datum/element/sellable/trolley_tank/calculate_sell_value(obj/source)
	var/obj/vehicle/train/trolley_tank/tank = source

	// Update export values
	var/datum/reagent/R = tank.reagents.reagent_list[1]
	var/reagent_value = FLOOR(R.volume * R.supply_conversion_value, 1)

	// Update end round data, has nothing to do with actual cargo sales
	if(R.industrial_use)
		if(isnull(GLOB.refined_chems_sold[R.industrial_use]))
			var/list/data = list()
			data["units"] = FLOOR(R.volume, 1)
			data["value"] = reagent_value
			GLOB.refined_chems_sold[R.industrial_use] = data
		else
			GLOB.refined_chems_sold[R.industrial_use]["units"] += FLOOR(R.volume, 1)
			GLOB.refined_chems_sold[R.industrial_use]["value"] += reagent_value

	return reagent_value

/datum/element/sellable/trolley_tank/calculate_sell_quantity(obj/source)
	var/obj/vehicle/train/trolley_tank/tank = source
	if(!tank.reagents || tank.reagents.reagent_list.len == 0)
		return "0u "
	var/datum/reagent/R = tank.reagents.reagent_list[1]
	return "[R.name] [tank.reagents.total_volume]u "
