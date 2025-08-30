// Old Exploration is too WIP to use right now

/obj/machinery/suit_cycler/exploration
	req_access = null
	req_one_access = list(ACCESS_EXPLORER,ACCESS_MEDICAL_EQUIP)

/obj/machinery/suit_cycler/pilot
	req_access = list(ACCESS_PILOT)

/obj/machinery/suit_cycler/captain
	name = "Manager suit cycler"
	model_text = "Manager"
	icon_state = "cap_cycler"
	req_access = list(ACCESS_CAPTAIN)
	departments = list(/datum/suit_cycler_choice/department/captain)

/obj/machinery/suit_cycler/prototype
	name = "Prototype suit cycler"
	model_text = "Prototype"
	icon_state = "industrial_cycler"
	req_access = list(ACCESS_HOS)
	departments = list(/datum/suit_cycler_choice/department/prototype)

/obj/machinery/suit_cycler/vintage/tcrew
	name = "Talon crew suit cycler"
	model_text = "Talon crew"
	icon_state = "dark_cycler"
	req_access = list(ACCESS_TALON)
	departments = list(/datum/suit_cycler_choice/department/talon/crew)

/obj/machinery/suit_cycler/vintage/tpilot
	name = "Talon pilot suit cycler"
	model_text = "Talon pilot"
	icon_state = "dark_cycler"
	req_access = list(ACCESS_TALON)
	departments = list(/datum/suit_cycler_choice/department/talon/pilot)

/obj/machinery/suit_cycler/vintage/tengi
	name = "Talon engineer suit cycler"
	model_text = "Talon engineer"
	icon_state = "dark_cycler"
	req_access = list(ACCESS_TALON)
	departments = list(/datum/suit_cycler_choice/department/talon/eng)

/obj/machinery/suit_cycler/vintage/tguard
	name = "Talon guard suit cycler"
	model_text = "Talon guard"
	icon_state = "dark_cycler"
	req_access = list(ACCESS_TALON)
	departments = list(/datum/suit_cycler_choice/department/talon/marine)

/obj/machinery/suit_cycler/vintage/tmedic
	name = "Talon doctor suit cycler"
	model_text = "Talon doctor"
	icon_state = "dark_cycler"
	req_access = list(ACCESS_TALON)
	departments = list(/datum/suit_cycler_choice/department/talon/med)

/obj/machinery/suit_cycler/vintage/tcaptain
	name = "Talon captain suit cycler"
	model_text = "Talon captain"
	icon_state = "dark_cycler"
	req_access = list(ACCESS_TALON)
	departments = list(/datum/suit_cycler_choice/department/talon/officer)

/obj/machinery/suit_cycler/vintage/tminer
	name = "Talon miner suit cycler"
	model_text = "Talon miner"
	icon_state = "dark_cycler"
	req_access = list(ACCESS_TALON)
	departments = list(/datum/suit_cycler_choice/department/talon/miner)
