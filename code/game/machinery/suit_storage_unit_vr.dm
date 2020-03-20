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
		SPECIES_ZORREN_HIGH
	)

// Old Exploration is too WIP to use right now
/obj/machinery/suit_cycler/exploration
	req_access = list(access_explorer)
	departments = list("Exploration")

/obj/machinery/suit_cycler/pilot
	req_access = list(access_pilot)
