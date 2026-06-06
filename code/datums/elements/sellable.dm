/datum/element/sellable
	var/sale_info = "This can be sold on the cargo shuttle if packed in a crate."
	var/needs_crate = TRUE

/datum/element/sellable/Attach(datum/target)
	. = ..()
	if(!isobj(target))
		return ELEMENT_INCOMPATIBLE
	RegisterSignal(target, COMSIG_ITEM_EXPORTED, PROC_REF(sell))
	RegisterSignal(target, COMSIG_ITEM_SCAN_PROFIT, PROC_REF(calculate_sell_value))
	RegisterSignal(target, COMSIG_ATOM_EXAMINE, PROC_REF(on_examine))
	return

/datum/element/sellable/Detach(datum/source)
	UnregisterSignal(source, COMSIG_ITEM_EXPORTED)
	UnregisterSignal(source, COMSIG_ITEM_SCAN_PROFIT)
	UnregisterSignal(source, COMSIG_ATOM_EXAMINE)
	return ..()

// Override this for sub elements that need to do complex calculations when sold
/datum/element/sellable/proc/sell_error(obj/source)
	return null // returns a string explaining why the item couldn't be sold. Otherwise null to allow it to be sold.

/datum/element/sellable/proc/calculate_sell_value(obj/source)
	return 1

/datum/element/sellable/proc/calculate_sell_quantity(obj/source)
	return 1
// End overrides

/datum/element/sellable/proc/sell(obj/source, datum/exported_crate/EC, in_crate)
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
	if(!mat || !mat.supply_conversion_value)
		return 0
	return P.get_amount() * mat.supply_conversion_value

/datum/element/sellable/material_stack/calculate_sell_quantity(obj/source)
	var/obj/item/stack/P = source
	return P.get_amount()


// Money
/datum/element/sellable/spacecash
	sale_info = "This can be sold on the cargo shuttle if packed in a crate. Due to taxes, this is worth less than its face value when sold to the cargo shuttle."

/datum/element/sellable/spacecash/calculate_sell_value(obj/source)
	var/obj/item/spacecash/cashmoney = source
	return FLOOR((cashmoney.worth / SSsupply.money_per_points),1)

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
	if(!length(tank.reagents.reagent_list))
		return 0

	// Update export values
	var/datum/reagent/R = tank.reagents.reagent_list[1]
	var/reagent_value = FLOOR(R.volume * R.supply_conversion_value, 1)

	return reagent_value

/datum/element/sellable/trolley_tank/calculate_sell_quantity(obj/source)
	var/obj/vehicle/train/trolley_tank/tank = source
	if(!tank.reagents || tank.reagents.reagent_list.len == 0)
		return "0u "
	var/datum/reagent/R = tank.reagents.reagent_list[1]
	return "[R.name] [tank.reagents.total_volume]u "

/datum/element/sellable/trolley_tank/sell(obj/source, datum/exported_crate/EC, in_crate)
	. = ..()
	var/obj/vehicle/train/trolley_tank/tank = source
	if(. && tank.reagents?.reagent_list?.len)
		// Update end round data, has nothing to do with actual cargo sales
		var/datum/reagent/R = tank.reagents.reagent_list[1]
		var/reagent_value = FLOOR(R.volume * R.supply_conversion_value, 1)
		if(R.industrial_use)
			if(isnull(GLOB.refined_chems_sold[R.industrial_use]))
				var/list/data = list()
				data["units"] = FLOOR(R.volume, 1)
				data["value"] = reagent_value
				GLOB.refined_chems_sold[R.industrial_use] = data
			else
				GLOB.refined_chems_sold[R.industrial_use]["units"] += FLOOR(R.volume, 1)
				GLOB.refined_chems_sold[R.industrial_use]["value"] += reagent_value

/datum/element/sellable/salvage //For selling /obj/item/salvage

/datum/element/sellable/salvage/calculate_sell_value(obj/source)
	var/obj/item/salvage/salvagedStuff = source
	return salvagedStuff.worth

/datum/element/sellable/organ //For selling /obj/item/organ/internal
/datum/element/sellable/organ/calculate_sell_value(obj/source)
	var/obj/item/organ/internal/organ_stuff = source
	return organ_stuff.supply_conversion_value

/datum/element/sellable/organ/sell_error(obj/source)
	if(!istype(source.loc, /obj/structure/closet/crate/freezer))
		return "Error: Product was improperly packaged. Send contents in freezer crate to preserve contents for transport."
	var/obj/item/organ/internal/organ_stuff = source
	if(organ_stuff.health != initial(organ_stuff.health) )
		return "Error: Product was damaged on arrival."
	return null

// Selling slimes
/datum/element/sellable/slime_extract/calculate_sell_value(obj/source)
	var/obj/item/slime_extract/slime_stuff = source
	return FLOOR(slime_stuff.supply_conversion_value,1)


// Selling food
/datum/element/sellable/food_snack
	sale_info = "This can be sold on the cargo shuttle if packed in a freezer crate."

/datum/element/sellable/food_snack/sell_error(obj/source)
	if(!istype(source.loc, /obj/structure/closet/crate/freezer))
		return "Error: Product was improperly packaged. Send contents in freezer crate to preserve contents for transport. Payment rendered null under terms of agreement."
	var/obj/item/reagent_containers/food/food_stuff = source
	if(istype(food_stuff,/obj/item/reagent_containers/food/snacks))
		var/obj/item/reagent_containers/food/snacks/S = food_stuff
		if(S.bitecount > 0)
			return "Error: Product was partially consumed, and is unfit for sale. Payment rendered null under terms of agreement."
	return null

/datum/element/sellable/food_snack/calculate_sell_value(obj/source)
	var/obj/item/reagent_containers/food/food_stuff = source
	return FLOOR(food_stuff.price_tag,1) // Converts old price system into supply point cost


// Selling TTVs
/datum/element/sellable/transfer_valve/calculate_sell_value(obj/source)
	var/obj/item/transfer_valve/TTV = source

	if(!TTV.tank_one || !TTV.tank_two)
		return 0

	var/datum/gas_mixture/faketank = new()
	QDEL_IN(faketank,5)

	// Highest pressure must be in tank 1!
	var/obj/item/tank/tank1 = TTV.tank_one
	var/obj/item/tank/tank2 = TTV.tank_two
	faketank.volume = tank1.air_contents.volume + tank2.air_contents.volume
	faketank.copy_from(tank1.air_contents)
	var/faketank_integrity = tank1.integrity
	faketank.merge(tank2.air_contents)

	// Perform the explosion
	faketank.merge(tank2.air_contents)
	faketank.react()
	var/pressure = faketank.return_pressure()
	if(pressure <= TANK_FRAGMENT_PRESSURE)
		return 0
	var/intervals = 0
	//Very dumbed down version. Close enough for our purposes.
	while(faketank_integrity >= 7)
		if(intervals < 0 || intervals >= 13) //13 because we calculate for adminspawn bombs or pre-welded bombs, too, which start at 20 integrity. If it's losing integrity, it's going to rupture eventually!
			break
		intervals++
		faketank.react()
		pressure = faketank.return_pressure()
		if(pressure > TANK_FRAGMENT_PRESSURE)
			faketank_integrity -= 7

		else if(pressure > TANK_RUPTURE_PRESSURE)
			faketank_integrity -= 5

	if(faketank_integrity > 7)
		return 0

	faketank.react()
	faketank.react()
	faketank.react()
	pressure = faketank.return_pressure()

	var/strength = (pressure-TANK_FRAGMENT_PRESSURE)/TANK_FRAGMENT_SCALE
	var/mult = ((faketank.volume/140)**(1/2)) * (faketank.total_moles**(2/3))/((29*0.64) **(2/3)) //Don't ask me what this is, see tanks.dm

	var/dev_value = round((mult*strength)*1)
	var/heavy_value = round((mult*strength)*0.5)
	var/light_value = round((mult*strength)*0.25)

	return FLOOR(dev_value + heavy_value + light_value,1)

/datum/element/sellable/transfer_valve/sell(obj/source, datum/exported_crate/EC, in_crate)
	. = ..()
	if(. && EC.contents[EC.contents.len]["value"] > 0)
		SSsupply.warheads_sold++
		SSsupply.warheads_value += EC.contents[EC.contents.len]["value"]


// Mech selling
/datum/element/sellable/mecha
	needs_crate = FALSE
	sale_info = "This can be sold on the cargo shuttle. It's condition and parts would greatly affects its price."

/datum/element/sellable/mecha/sell_error(obj/source)
	var/obj/mecha/exo = source
	exo.wreckage = null // Exo sold, remove it's lootpile on qdel, or we'll have issues in cargo....
	var/check_val = calculate_sell_value(source)
	if(!check_val)
		if((exo.health / exo.maxhealth) < 0.5)
			return "Error: The unit is too damaged to sell, and will be used as scrap. Payment rendered null under terms of agreement."
		return "Error: The unit in its current condition has no resale value at all, and will be used as scrap. Payment rendered null under terms of agreement."
	return null

/datum/element/sellable/mecha/calculate_sell_value(obj/source)
	var/obj/mecha/exo = source
	var/amount = exo.health / 10
	amount += exo.max_temperature / 1000

	// generic bonuses
	for(var/slot in exo.internal_components)
		var/obj/item/mecha_parts/component/MC = exo.internal_components[slot]
		amount += MC.integrity
		amount += MC.emp_resistance * 10

	// special bonuses
	if(exo.internal_components[MECH_ACTUATOR])
		var/obj/item/mecha_parts/component/actuator/MC = exo.internal_components[MECH_ACTUATOR]
		amount += MC.integrity
		amount += 20 * MC.strafing_multiplier

	if(exo.internal_components[MECH_ARMOR])
		var/obj/item/mecha_parts/component/armor/MC = exo.internal_components[MECH_ARMOR]
		amount += MC.deflect_chance
		for(var/dam in MC.damage_absorption)
			amount += MC.damage_absorption[dam] * 10

	if(exo.internal_components[MECH_ELECTRIC])
		var/obj/item/mecha_parts/component/electrical/MC = exo.internal_components[MECH_ELECTRIC]
		amount += MC.integrity
		amount -= 100 * MC.charge_cost_mod

	// Extra equipment
	for(var/E in exo.hull_equipment)
		amount += 3

	for(var/E in exo.weapon_equipment)
		amount += 3

	for(var/E in exo.utility_equipment)
		amount += 2

	for(var/E in exo.universal_equipment)
		amount += 1

	for(var/E in exo.special_equipment)
		amount += 4

	// Don't bother somehow...
	if(amount < 0)
		return 0

	// Special mech multipliers
	if(istype(exo,/obj/mecha/combat/phazon))
		amount *= 30
	else if(istype(exo,/obj/mecha/combat/fighter)) // More niche
		amount *= 8
	else if(istype(exo,/obj/mecha/medical))
		amount *= 11
	else if(istype(exo,/obj/mecha/combat))
		amount *= 6
	else if(istype(exo,/obj/mecha/micro)) // Teeny weenies!
		amount *= 3.5
	else
		amount *= 1

	// Final health scaler
	amount *= (exo.health / exo.maxhealth)
	if(amount < 100)
		return 0
	return FLOOR(amount,10)


// Selling GUNZ
/datum/element/sellable/gun/calculate_sell_value(obj/source)
	var/amount = 10
	var/obj/item/gun/G = source
	var/obj/item/projectile/P = initial(G.projectile_type)

	if(istype(G,/obj/item/gun/projectile))
		var/obj/item/gun/projectile/PG = G
		amount += initial(PG.recoil) * 2 // We can assume bigger bang
		amount += initial(PG.max_shells) * 1.5 // More shots more bang

	if(istype(G,/obj/item/gun/energy))
		var/obj/item/gun/energy/EG = G
		amount += initial(EG.charge_cost) / 100 // We can assume bigger bang

	if(P)
		// Default bullet breakdown
		amount += initial(P.damage) / 2
		amount += initial(P.stun)
		amount += initial(P.weaken)
		amount += initial(P.paralyze)
		amount += initial(P.irradiate) / 2
		amount += initial(P.agony) / 2
		// Stop trying to sell donksofts
		if(initial(P.nodamage))
			amount /= 20

	return FLOOR(amount,5)
