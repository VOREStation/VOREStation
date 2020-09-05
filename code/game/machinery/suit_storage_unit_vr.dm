/obj/machinery/suit_cycler
	departments = list("Engineering","Mining","Medical","Security","Atmos","HAZMAT","Construction","Biohazard","Emergency Medical Response","Crowd Control","Exploration","Pilot Blue","Pilot","Manager","Prototype")
	species = list(SPECIES_HUMAN, SPECIES_SKRELL, SPECIES_UNATHI, SPECIES_TAJ, SPECIES_TESHARI, SPECIES_AKULA, SPECIES_SERGAL, SPECIES_VULPKANIN)

// Old Exploration is too WIP to use right now
/obj/machinery/suit_cycler/exploration
	req_access = list(access_explorer)
	departments = list("Exploration")

/obj/machinery/suit_cycler/pilot
	req_access = list(access_pilot)

/obj/machinery/suit_cycler/captain
	name = "Manager suit cycler"
	model_text = "Manager"
	req_access = list(access_captain)
	departments = list("Manager")

/obj/machinery/suit_cycler/captain/Initialize() //No Teshari Sprites
	species -= SPECIES_TESHARI
	return ..()

/obj/machinery/suit_cycler/prototype
	name = "Prototype suit cycler"
	model_text = "Prototype"
	req_access = list(access_hos)
	departments = list("Prototype")

/obj/machinery/suit_cycler/prototype/Initialize() //No Teshari Sprites
	species -= SPECIES_TESHARI
	return ..()

/obj/machinery/suit_cycler/vintage/tcrew
	name = "Talon crew suit cycler"
	model_text = "Talon crew"
	req_access = list(access_talon)
	departments = list("Talon Crew")

/obj/machinery/suit_cycler/vintage/tpilot
	name = "Talon pilot suit cycler"
	model_text = "Talon pilot"
	req_access = list(access_talon)
	departments = list("Talon Pilot (Bubble Helm)","Talon Pilot (Closed Helm)")

/obj/machinery/suit_cycler/vintage/tengi
	name = "Talon engineer suit cycler"
	model_text = "Talon engineer"
	req_access = list(access_talon)
	departments = list("Talon Engineering")

/obj/machinery/suit_cycler/vintage/tguard
	name = "Talon guard suit cycler"
	model_text = "Talon guard"
	req_access = list(access_talon)
	departments = list("Talon Marine","Talon Mercenary")

/obj/machinery/suit_cycler/vintage/tmedic
	name = "Talon doctor suit cycler"
	model_text = "Talon doctor"
	req_access = list(access_talon)
	departments = list("Talon Medical (Bubble Helm)","Talon Medical (Closed Helm)")

/obj/machinery/suit_cycler/vintage/tcaptain
	name = "Talon captain suit cycler"
	model_text = "Talon captain"
	req_access = list(access_talon)
	departments = list("Talon Officer")