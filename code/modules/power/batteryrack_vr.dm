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