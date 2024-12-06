
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
		REAGENT_ID_HYDROGEN, REAGENT_ID_LITHIUM, REAGENT_ID_CARBON, REAGENT_ID_NITROGEN, REAGENT_ID_OXYGEN, REAGENT_ID_FLUORINE, REAGENT_ID_SODIUM,
		REAGENT_ID_ALUMINIUM, REAGENT_ID_SILICON, REAGENT_ID_PHOSPHORUS, REAGENT_ID_SULFUR, REAGENT_ID_CHLORINE, REAGENT_ID_POTASSIUM, REAGENT_ID_IRON,
		REAGENT_ID_COPPER, REAGENT_ID_MERCURY, REAGENT_ID_RADIUM, REAGENT_ID_WATER, REAGENT_ID_ETHANOL, REAGENT_ID_SUGAR, REAGENT_ID_SACID, REAGENT_ID_TUNGSTEN,
		REAGENT_ID_CALCIUM
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
		REAGENT_ID_WATER, "ice", "coffee", "cream", "tea", "icetea", "cola", "spacemountainwind", "dr_gibb", "space_up", "tonic",
		"sodawater", "lemonjuice", "lemon_lime", REAGENT_ID_SUGAR, "orangejuice", "limejuice", "watermelonjuice", "thirteenloko", "grapesoda"
		)

/obj/machinery/chemical_dispenser/bar_alc
	dispense_reagents = list(
		"lemon_lime", REAGENT_ID_SUGAR, "orangejuice", "limejuice", "sodawater", "tonic", "beer", "kahlua",
		"whiskey", "redwine", "whitewine", "vodka", "cider", "gin", "rum", "tequilla", "vermouth", "cognac", "ale", "mead", "bitters"
		)

/obj/machinery/chemical_dispenser/bar_coffee
	dispense_reagents = list(
		"coffee", "cafe_latte", "soy_latte", "hot_coco", "milk", "cream", "tea", "ice",
		"orangejuice", "lemonjuice", "limejuice", "berryjuice", "mint", "decaf", "greentea"
		)
