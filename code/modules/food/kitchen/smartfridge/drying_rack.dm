/obj/machinery/smartfridge/drying_rack
	name = "\improper Drying Rack"
	desc = "A machine for drying plants."
	wrenchable = 1
	icon_state = "drying_rack"
	icon_base = "drying_rack"

/obj/machinery/smartfridge/drying_rack/accept_check(var/obj/item/O as obj)
	if(istype(O, /obj/item/reagent_containers/food/snacks/))
		var/obj/item/reagent_containers/food/snacks/S = O
		if (S.dried_type)
			return 1

	if(istype(O, /obj/item/stack/wetleather))
		return 1

	return 0

/obj/machinery/smartfridge/drying_rack/process()
	..()
	if(stat & (BROKEN|NOPOWER))
		return
	if(contents.len)
		dry()
		update_icon()

/obj/machinery/smartfridge/drying_rack/update_icon()
	var/not_working = stat & (BROKEN|NOPOWER)
	var/hasItems
	for(var/datum/stored_item/I in item_records)
		if(I.get_amount())
			hasItems = 1
			break
	if(hasItems)
		if(not_working)
			icon_state = "[icon_base]-plant-off"
		else
			icon_state = "[icon_base]-plant"
	else
		if(not_working)
			icon_state = "[icon_base]-off"
		else
			icon_state = "[icon_base]"

/obj/machinery/smartfridge/drying_rack/proc/dry()
	for(var/datum/stored_item/I in item_records)
		for(var/obj/item/reagent_containers/food/snacks/S in I.instances)
			if(S.dry) continue
			if(S.dried_type == S.type)
				S.dry = 1
				S.name = "dried [S.name]"
				S.color = "#AAAAAA"
				I.instances -= S
				S.forceMove(get_turf(src))
			else
				var/D = S.dried_type
				new D(get_turf(src))
				qdel(S)
			return

		for(var/obj/item/stack/wetleather/WL in I.instances)
			if(!WL.wetness)
				if(WL.get_amount())
					WL.forceMove(get_turf(src))
					WL.dry()
				I.instances -= WL
				break

			WL.wetness = max(0, WL.wetness - rand(1, 3))

	return