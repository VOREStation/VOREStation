
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
		REAGENT_ID_INAPROVALINE, REAGENT_ID_RYETALYN, REAGENT_ID_PARACETAMOL, REAGENT_ID_TRAMADOL, REAGENT_ID_OXYCODONE, REAGENT_ID_STERILIZINE, REAGENT_ID_LEPORAZINE,
		REAGENT_ID_KELOTANE, REAGENT_ID_DERMALINE, REAGENT_ID_DEXALIN, REAGENT_ID_DEXALINP, REAGENT_ID_TRICORDRAZINE, REAGENT_ID_ANTITOXIN, REAGENT_ID_SYNAPTIZINE,
		REAGENT_ID_HYRONALIN, REAGENT_ID_ARITHRAZINE, REAGENT_ID_ALKYSINE, REAGENT_ID_IMIDAZOLINE, REAGENT_ID_PERIDAXON, REAGENT_ID_BICARIDINE, REAGENT_ID_HYPERZINE,
		REAGENT_ID_REZADONE, REAGENT_ID_SPACEACILLIN, REAGENT_ID_ETHYLREDOXRAZINE, REAGENT_ID_STOXIN, REAGENT_ID_CHLORALHYDRATE, REAGENT_ID_CRYOXADONE,
		REAGENT_ID_CLONEXADONE
		)

/obj/machinery/chemical_dispenser/bar_soft
	dispense_reagents = list(
		REAGENT_ID_WATER, "ice", "coffee", "cream", "tea", "icetea", "cola", "spacemountainwind", "dr_gibb", "space_up", "tonic",
		"sodawater", "lemonjuice", "lemon_lime", REAGENT_ID_SUGAR, "orangejuice", "limejuice", "watermelonjuice", "thirteenloko", "grapesoda", "pineapplejuice"
		)

/obj/machinery/chemical_dispenser/bar_alc
	dispense_reagents = list(
		"lemon_lime", REAGENT_ID_SUGAR, "orangejuice", "limejuice", "sodawater", "tonic", "beer", "kahlua",
		"whiskey", "redwine", "whitewine", "vodka", "cider", "gin", "rum", "tequilla", "vermouth", "cognac", "ale", "mead", "bitters"
		)

/obj/machinery/chemical_dispenser/bar_coffee
	dispense_reagents = list(
		"coffee", "cafe_latte", "soy_latte", "hot_coco", "milk", "cream", "tea", "ice", "water",
		"orangejuice", "lemonjuice", "limejuice", "berryjuice", "mint", "decaf", "greentea", "milk_foam", "drip_coffee"
		)

/obj/machinery/chemical_dispenser/bar_syrup
	dispense_reagents = list(
		"syrup_pumpkin", "syrup_caramel", "syrup_salted_caramel", "syrup_irish", "syrup_almond", "syrup_cinnamon", "syrup_pistachio",
		"syrup_vanilla", "syrup_toffee", "grenadine", "syrup_cherry", "syrup_butterscotch", "syrup_chocolate", "syrup_white_chocolate", "syrup_strawberry",
		"syrup_coconut", "syrup_ginger", "syrup_gingerbread", "syrup_peppermint", "syrup_birthday"
		)
