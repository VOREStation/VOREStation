/obj/machinery/suit_cycler
	departments = list("Engineering","Mining","Medical","Security","Atmos","HAZMAT","Construction","Biohazard","Emergency Medical Response","Crowd Control","Exploration","Pilot Blue","Pilot","Director","Prototype")
	species = list(SPECIES_HUMAN, SPECIES_SKRELL, SPECIES_UNATHI, SPECIES_TAJ, SPECIES_TESHARI, SPECIES_AKULA, SPECIES_SERGAL, SPECIES_VULPKANIN)

// Old Exploration is too WIP to use right now
/obj/machinery/suit_cycler/exploration
	req_access = list(access_explorer)
	departments = list("Exploration")

/obj/machinery/suit_cycler/pilot
	req_access = list(access_pilot)

/obj/machinery/suit_cycler/captain
	name = "Director suit cycler"
	model_text = "Director"
	req_access = list(access_captain)
	departments = list("Director")

/obj/machinery/suit_cycler/captain/Initialize() //No Teshari Sprites
	species -= SPECIES_TESHARI
	return ..()

/obj/machinery/suit_cycler/prototype
	name = "Prototype suit cycler"
	model_text = "Prototype"
	req_access = list(access_cent_specops)
	departments = list("Prototype")

/obj/machinery/suit_cycler/prototype/Initialize() //No Teshari Sprites
	species -= SPECIES_TESHARI
	return ..()
