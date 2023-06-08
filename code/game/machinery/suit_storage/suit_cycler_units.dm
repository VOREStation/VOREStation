/obj/machinery/suit_cycler/refit_only
	name = "Suit cycler"
	desc = "A dedicated industrial machine that can refit voidsuits for \
	different species, but not change the suit's overall appearance or \
	departmental scheme."
	model_text = "General Access"
	req_access = null
	limit_departments = list()

/obj/machinery/suit_cycler/engineering
	name = "Engineering suit cycler"
	model_text = "Engineering"
	icon_state = "engi_cycler"
	req_access = list(access_construction)
	limit_departments = list(
		/datum/suit_cycler_choice/department/eng
	)

/obj/machinery/suit_cycler/mining
	name = "Mining suit cycler"
	model_text = "Mining"
	icon_state = "industrial_cycler"
	req_access = list(access_mining)
	limit_departments = list(
		/datum/suit_cycler_choice/department/crg
	)

/obj/machinery/suit_cycler/security
	name = "Security suit cycler"
	model_text = "Security"
	icon_state = "sec_cycler"
	req_access = list(access_security)
	limit_departments = list(
		/datum/suit_cycler_choice/department/sec
	)

/obj/machinery/suit_cycler/medical
	name = "Medical suit cycler"
	model_text = "Medical"
	icon_state = "med_cycler"
	req_access = list(access_medical)
	limit_departments = list(
		/datum/suit_cycler_choice/department/med
	)

/obj/machinery/suit_cycler/syndicate
	name = "Nonstandard suit cycler"
	model_text = "Nonstandard"
	icon_state = "red_cycler"
	req_access = list(access_syndicate)
	limit_departments = list(
		/datum/suit_cycler_choice/department/emag
	)
	can_repair = 1

/obj/machinery/suit_cycler/exploration
	name = "Explorer suit cycler"
	model_text = "Exploration"
	icon_state = "explo_cycler"
	limit_departments = list(
		/datum/suit_cycler_choice/department/exp
	)

/obj/machinery/suit_cycler/pilot
	name = "Pilot suit cycler"
	model_text = "Pilot"
	icon_state = "pilot_cycler"
	limit_departments = list(
		/datum/suit_cycler_choice/department/pil
	)

/obj/machinery/suit_cycler/vintage
	name = "Vintage Crew suit cycler"
	model_text = "Vintage"
	icon_state = "industrial_cycler"
	limit_departments = list(
		/datum/suit_cycler_choice/department/vintage/crew
	)
	req_access = null

/obj/machinery/suit_cycler/vintage/pilot
	name = "Vintage Pilot suit cycler"
	model_text = "Vintage Pilot"
	limit_departments = list(
		/datum/suit_cycler_choice/department/vintage/pilot
	)

/obj/machinery/suit_cycler/vintage/medsci
	name = "Vintage MedSci suit cycler"
	model_text = "Vintage MedSci"
	limit_departments = list(
		/datum/suit_cycler_choice/department/vintage/research,
		/datum/suit_cycler_choice/department/vintage/med
	)

/obj/machinery/suit_cycler/vintage/rugged
	name = "Vintage Ruggedized suit cycler"
	model_text = "Vintage Ruggedized"

	limit_departments = list(
		/datum/suit_cycler_choice/department/vintage/eng,
		/datum/suit_cycler_choice/department/vintage/marine,
		/datum/suit_cycler_choice/department/vintage/officer,
		/datum/suit_cycler_choice/department/vintage/merc
	)

/obj/machinery/suit_cycler/vintage/omni
	name = "Vintage Master suit cycler"
	model_text = "Vintage Master"
	limit_departments = list(
		/datum/suit_cycler_choice/department/vintage
	)