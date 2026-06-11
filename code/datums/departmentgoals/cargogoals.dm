/datum/goal/cargo
	category = GOAL_CARGO

/datum/goal/cargo/New()
	. = ..()
	RegisterSignal(SSdcs,COMSIG_GLOB_SUPPLY_SHUTTLE_SELL_ITEM,PROC_REF(handle_cargo_sale))

/datum/goal/cargo/Destroy(force)
	UnregisterSignal(SSdcs,COMSIG_GLOB_SUPPLY_SHUTTLE_SELL_ITEM)
	. = ..()

/datum/goal/cargo/proc/handle_cargo_sale(datum/source, atom/movable/sold_item, sold_successfully, datum/exported_crate/export_data, area/shuttle_subarea)
	SIGNAL_HANDLER
	return


// Sell sheets
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/datum/goal/cargo/sell_sheets
	name = "Sell Refined Materials"
	var/mat_to_sell = MAT_STEEL

/datum/goal/cargo/sell_sheets/New()
	. = ..()

	// Decide the sheet to sell
	mat_to_sell = pick(list(
						MAT_STEEL,
						MAT_BRONZE,
						MAT_COPPER,
						MAT_DIAMOND,
						MAT_GOLD,
						MAT_LEAD,
						MAT_IRON,
						MAT_PLATINUM,
						MAT_PHORON,
						MAT_DURASTEEL,
						MAT_PLASTEEL,
						MAT_MORPHIUM,
						MAT_METALHYDROGEN,
						MAT_VALHOLLIDE,
						MAT_SUPERMATTER
						))
	switch(mat_to_sell)
		if(MAT_SUPERMATTER, MAT_VALHOLLIDE, MAT_METALHYDROGEN, MAT_MORPHIUM)
			goal_count = rand(25,50)
		else
			goal_count = rand(150,300)

	var/datum/material/mat_datum = get_material_by_name(mat_to_sell)
	goal_text = "Export a total of [goal_count] [mat_datum.name] [mat_datum.sheet_plural_name]."

/datum/goal/cargo/sell_sheets/handle_cargo_sale(datum/source, atom/movable/sold_item, sold_successfully, datum/exported_crate/export_data, area/shuttle_subarea)
	if(!sold_successfully)
		return
	if(!istype(sold_item,/obj/structure/closet/crate))
		return
	for(var/obj/item/stack/material/sheet_stack in sold_item)
		if(!sheet_stack.material || sheet_stack.material.name != mat_to_sell)
			continue
		current_count += sheet_stack.amount


// Sell chemicals
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/datum/goal/cargo/sell_chemicals
	name = "Export Chemical Tanks"
	var/chosen_reagent = null

/datum/goal/cargo/sell_chemicals/New()
	. = ..()
	goal_count = rand(6,10) * CARGOTANKER_VOLUME
	chosen_reagent = pick(list(
							REAGENT_ID_BICARIDINE,
							REAGENT_ID_ANTITOXIN,
							REAGENT_ID_KELOTANE,
							REAGENT_ID_DERMALINE,
							REAGENT_ID_TRICORDRAZINE,
							REAGENT_ID_ADRANOL,
							REAGENT_ID_INAPROVALINE,
							REAGENT_ID_DEXALIN,
							REAGENT_ID_TRAMADOL,
							REAGENT_ID_ALKYSINE,
							REAGENT_ID_IMIDAZOLINE,
							REAGENT_ID_SPACEACILLIN,
							REAGENT_ID_CARTHATOLINE,
							REAGENT_ID_HYRONALIN,
							REAGENT_ID_RYETALYN,
							REAGENT_ID_PERIDAXON,
							REAGENT_ID_LUBE,
							REAGENT_ID_CLEANER,
							REAGENT_ID_PAINT,
							REAGENT_ID_SACID,
							REAGENT_ID_PACID
							))
	var/datum/reagent/chem = SSchemistry.chemical_reagents[chosen_reagent]
	goal_text = "Export [goal_count]u of [chem.name]."

/datum/goal/cargo/sell_chemicals/handle_cargo_sale(datum/source, atom/movable/sold_item, sold_successfully, datum/exported_crate/export_data, area/shuttle_subarea)
	if(!sold_successfully)
		return
	if(!istype(sold_item,/obj/vehicle/train/trolley_tank))
		return
	current_count += sold_item.reagents.get_reagent_amount(chosen_reagent)


// Drill Rock
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/datum/goal/cargo/mine_rock
	name = "Mining Productivity"

/datum/goal/cargo/mine_rock/New()
	goal_count = rand(3500,5500)
	goal_text = "Drill through at least [goal_count] rock walls, keeping our miners in shape!"

/datum/goal/cargo/mine_rock/check_completion()
	current_count = GLOB.rocks_drilled_roundstat
	. = ..()
