/obj/machinery/suit_cycler
	species = list(
		SPECIES_HUMAN,
		SPECIES_SKRELL,
		SPECIES_UNATHI,
		SPECIES_TAJ,
		SPECIES_TESHARI,
		SPECIES_AKULA,
		SPECIES_ALRAUNE,
		SPECIES_NEVREAN,
		SPECIES_RAPALA,
		SPECIES_SERGAL,
		SPECIES_VASILISSAN,
		SPECIES_VULPKANIN,
		SPECIES_XENOCHIMERA,
		SPECIES_XENOHYBRID,
		SPECIES_ZORREN_FLAT,
		SPECIES_ZORREN_HIGH
	)

/obj/machinery/suit_cycler/explorer
	name = "Explorer suit cycler"
	model_text = "Exploration"
	req_access = list(access_pilot)
	departments = list("Exploration","Pilot")

/obj/machinery/suit_cycler/explorer/initialize()
	species -= SPECIES_TESHARI
	return ..()

/obj/machinery/suit_cycler/apply_paintjob()
	if(!target_species || !target_department)
		return

	if(target_species)
		if(helmet) helmet.refit_for_species(target_species)
		if(suit) suit.refit_for_species(target_species)

	switch(target_department)
		if("Exploration")
			if(helmet)
				helmet.name = "exploration voidsuit helmet"
				helmet.icon_state = "helm_explorer"
				helmet.item_state = "helm_explorer"
			if(suit)
				suit.name = "exploration voidsuit"
				suit.icon_state = "void_explorer"
				suit.item_state = "void_explorer"
				suit.item_state_slots[slot_r_hand_str] = "wiz_voidsuit"
				suit.item_state_slots[slot_l_hand_str] = "wiz_voidsuit"
		if("Pilot")
			if(helmet)
				helmet.name = "pilot voidsuit helmet"
				helmet.icon_state = "rig0_pilot"
				helmet.item_state = "pilot_helm"
			if(suit)
				suit.name = "pilot voidsuit"
				suit.icon_state = "rig-pilot"
				suit.item_state = "rig-pilot"
				suit.item_state_slots[slot_r_hand_str] = "sec_voidsuitTG"
				suit.item_state_slots[slot_l_hand_str] = "sec_voidsuitTG"
		else
			return ..()

