/*
 * Industrial Sized Sheet Storage (but not actually industrial sized)
 */
/obj/machinery/smartfridge/sheets
	name = "\improper Industrial Sheet Storage"
	desc = "An industrial sized storage unit for materials."
	icon_state = "base_industrial"
	icon_base = "industrial"
	icon_contents = "sheet"
	stored_datum_type = /datum/stored_item/stack

/obj/machinery/smartfridge/sheets/persistent
	persistent = /datum/persistent/storage/smartfridge/sheet_storage

/obj/machinery/smartfridge/sheets/persistent_lossy
	persistent = /datum/persistent/storage/smartfridge/sheet_storage/lossy

/obj/machinery/smartfridge/sheets/accept_check(var/obj/item/O)
	return istype(O, /obj/item/stack/material) && !istype(O, /obj/item/stack/material/cyborg)

/obj/machinery/smartfridge/sheets/vend(datum/stored_item/stack/I, var/count)
	var/amount = I.get_amount()
	if(amount < 1)
		return

	count = min(count, amount)

	while(count > 0)
		var/obj/item/stack/S = I.get_product(get_turf(src), count)
		count -= S.get_amount()
	SStgui.update_uis(src)

/obj/machinery/smartfridge/sheets/find_record(var/obj/item/O)
	for(var/datum/stored_item/stack/I as anything in item_records)
		if(O.type == I.item_path) // Typecheck should evaluate material-specific subtype
			return I
	return null

/*
 * Mining Variant
 */
/obj/machinery/smartfridge/sheets/mining
	name = "\improper Mining Sheet Storage"
	icon_state = "base_mining"
	icon_base = "mining"
	icon_contents = "sheet"

/obj/machinery/smartfridge/sheets/mining/persistent
	persistent = /datum/persistent/storage/smartfridge/sheet_storage
/obj/machinery/smartfridge/sheets/mining/persistent_lossy
	persistent = /datum/persistent/storage/smartfridge/sheet_storage/lossy
