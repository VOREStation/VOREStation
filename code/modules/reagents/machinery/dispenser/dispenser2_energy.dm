
/obj/machinery/chemical_dispenser
	var/_recharge_reagents = 1
	var/list/dispense_reagents = list()
	var/process_tick = 0

/obj/machinery/chemical_dispenser/process()
	if(!_recharge_reagents)
		return
	if(stat & (BROKEN|NOPOWER))
		return
	if(--process_tick <= 0)
		process_tick = 15
		. = 0
		for(var/id in dispense_reagents)
			var/datum/reagent/R = SSchemistry.chemical_reagents[id]
			if(!R)
				stack_trace("[src] at [x],[y],[z] failed to find reagent '[id]'!")
				dispense_reagents -= id
				continue
			var/obj/item/reagent_containers/chem_disp_cartridge/C = cartridges[R.name]
			if(C && C.reagents.total_volume < C.reagents.maximum_volume)
				var/to_restore = min(C.reagents.maximum_volume - C.reagents.total_volume, 5)
				use_power(to_restore * 500)
				C.reagents.add_reagent(id, to_restore)
				. = 1
		if(.)
			SStgui.update_uis(src)

/obj/machinery/chemical_dispenser
	dispense_reagents = list(
		"hydrogen", "lithium", "carbon", "nitrogen", "oxygen", "fluorine", "sodium",
		"aluminum", "silicon", "phosphorus", "sulfur", "chlorine", "potassium", "iron",
		"copper", "mercury", "radium", "water", "ethanol", "sugar", "sacid", "tungsten"
		)

/obj/machinery/chemical_dispenser/ert
	dispense_reagents = list(
		"inaprovaline", "ryetalyn", "paracetamol", "tramadol", "oxycodone", "sterilizine", "leporazine",
		"kelotane", "dermaline", "dexalin", "dexalinp", "tricordrazine", "anti_toxin", "synaptizine",
		"hyronalin", "arithrazine", "alkysine", "imidazoline", "peridaxon", "bicaridine", "hyperzine",
		"rezadone", "spaceacillin", "ethylredoxrazine", "stoxin", "chloralhydrate", "cryoxadone",
		"clonexadone"
		)

/obj/machinery/chemical_dispenser/bar_soft
	dispense_reagents = list(
		"water", "ice", "coffee", "cream", "tea", "icetea", "cola", "spacemountainwind", "dr_gibb", "space_up", "tonic",
		"sodawater", "lemon_lime", "sugar", "orangejuice", "limejuice", "watermelonjuice", "thirteenloko", "grapesoda"
		)

/obj/machinery/chemical_dispenser/bar_alc
	dispense_reagents = list(
		"lemon_lime", "sugar", "orangejuice", "limejuice", "sodawater", "tonic", "beer", "kahlua",
		"whiskey", "redwine", "whitewine", "vodka", "cider", "gin", "rum", "tequilla", "vermouth", "cognac", "ale", "mead", "bitters"
		)

/obj/machinery/chemical_dispenser/bar_coffee
	dispense_reagents = list(
		"coffee", "cafe_latte", "soy_latte", "hot_coco", "milk", "cream", "tea", "ice",
		"orangejuice", "lemonjuice", "limejuice", "berryjuice", "mint", "decaf"
		)
