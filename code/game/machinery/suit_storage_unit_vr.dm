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
