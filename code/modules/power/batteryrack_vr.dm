/obj/machinery/power/smes/batteryrack/mapped
	var/cell_type = /obj/item/weapon/cell/apc
	var/cell_number = 3

/obj/machinery/power/smes/batteryrack/mapped/Initialize()
	. = ..()
	for(var/i = 1 to cell_number)
		if(i > max_cells)
			break
		var/obj/item/weapon/cell/newcell = new cell_type(src.loc)
		insert_cell(newcell)

/obj/item/weapon/module/power_control/attackby(var/obj/item/I, var/mob/user)
	if(I.has_tool_quality(TOOL_MULTITOOL))
		to_chat(user, SPAN_NOTICE("You begin tweaking the power control circuits to support a power cell rack."))
		if(do_after(user, 50 * I.toolspeed))
			var/obj/item/newcircuit = new/obj/item/weapon/circuitboard/batteryrack(get_turf(user))
			qdel(src)
			user.put_in_hands(newcircuit)
			return
	return ..()
