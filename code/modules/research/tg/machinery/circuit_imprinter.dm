/obj/machinery/rnd/production/circuit_imprinter
	name = "circuit imprinter"
	desc = "Manufactures circuit boards for the construction of machines."
	icon_state = "circuit_imprinter"
	production_animation = "circuit_imprinter_ani"
	circuit = /obj/item/circuitboard/circuit_imprinter
	allowed_buildtypes = IMPRINTER

/obj/machinery/rnd/production/circuit_imprinter/compute_efficiency()
	var/rating = 0
	for(var/obj/item/stock_parts/manipulator/manip in component_parts)
		rating += manip.rating

	return 0.5 ** max(rating - 1, 0) // One sheet, half sheet, quarter sheet, eighth sheet.
