/obj/machinery/smartfridge/sheets
	name = "\improper Smart Sheet Storage"
	desc = "A storage unit for materials."
	icon = 'icons/obj/vending_vr.dmi'
	icon_state = "basesmartsheet"
	icon_base = "smartsheet"
	icon_contents = "sheets"
	stored_datum_type = /datum/stored_item/stack

/obj/machinery/smartfridge/sheets/persistent
	persistent = /datum/persistent/storage/smartfridge/sheet_storage

/obj/machinery/smartfridge/sheets/persistent_lossy
	persistent = /datum/persistent/storage/smartfridge/sheet_storage/lossy

/obj/machinery/smartfridge/sheets/accept_check(var/obj/item/O)
	return istype(O, /obj/item/stack/material)

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

/obj/machinery/smartfridge/sheets/update_icon()
	cut_overlays()
	if(stat & (NOPOWER))
		icon_state = "[icon_base]-off"
		switch(contents.len)
			if(0)
				add_overlay("[icon_base]-[icon_contents]0-off")
			if(1 to 3)
				add_overlay("[icon_base]-[icon_contents]1-off")
			if(3 to 6)
				add_overlay("[icon_base]-[icon_contents]2-off")
			if(6 to 9)
				add_overlay("[icon_base]-[icon_contents]3-off")
			if(9 to INFINITY)
				add_overlay("[icon_base]-[icon_contents]4-off")
	else
		icon_state = icon_base
		switch(contents.len)
			if(0)
				add_overlay("[icon_base]-[icon_contents]0")
			if(1 to 3)
				add_overlay("[icon_base]-[icon_contents]1")
			if(3 to 6)
				add_overlay("[icon_base]-[icon_contents]2")
			if(6 to 9)
				add_overlay("[icon_base]-[icon_contents]3")
			if(9 to INFINITY)
				add_overlay("[icon_base]-[icon_contents]4")

	if(panel_open)
		add_overlay("[icon_base]-panel")

	if(stat & (BROKEN))
		cut_overlays()
		icon_state = "[icon_base]-broken"

//Industrial sized storage (but not actually industrial sized)
/obj/machinery/smartfridge/sheets/industrial
	name = "\improper Industrial Smart Sheet Storage"
	desc = "An industrial sized storage unit for materials."
	icon_state = "baseindustrialsheet"
	icon_base = "industrialsheet"
	icon_contents = "sheet"

/obj/machinery/smartfridge/sheets/industrial/persistent
	persistent = /datum/persistent/storage/smartfridge/sheet_storage

/obj/machinery/smartfridge/sheets/industrial/persistent_lossy
	persistent = /datum/persistent/storage/smartfridge/sheet_storage/lossy

/obj/machinery/smartfridge/sheets/industrial/mining
	icon_state = "baseminersheet"
	icon_base = "minersheet"
	icon_contents = "sheet"

/obj/machinery/smartfridge/sheets/industrial/mining/persistent
	persistent = /datum/persistent/storage/smartfridge/sheet_storage

/obj/machinery/smartfridge/sheets/industrial/mining/persistent_lossy
	persistent = /datum/persistent/storage/smartfridge/sheet_storage/lossy

//Industrial sized icon code (two varients with the same overlays)
/obj/machinery/smartfridge/sheets/industrial/update_icon()
	cut_overlays()
	if(stat & (NOPOWER))
		icon_state = "[icon_base]-off"
		switch(contents.len)
			if(0)
				add_overlay("industrial-[icon_contents]0-off")
			if(1 to 3)
				add_overlay("industrial-[icon_contents]1-off")
			if(3 to 6)
				add_overlay("industrial-[icon_contents]2-off")
			if(6 to INFINITY)
				add_overlay("industrial-[icon_contents]3-off")
	else
		icon_state = icon_base
		switch(contents.len)
			if(0)
				add_overlay("industrial-[icon_contents]0")
			if(1 to 3)
				add_overlay("industrial-[icon_contents]1")
			if(3 to 6)
				add_overlay("industrial-[icon_contents]2")
			if(6 to INFINITY)
				add_overlay("industrial-[icon_contents]3")

	if(panel_open)
		add_overlay("[icon_base]-panel")

	if(stat & (BROKEN))
		cut_overlays()
		icon_state = "[icon_base]-broken"