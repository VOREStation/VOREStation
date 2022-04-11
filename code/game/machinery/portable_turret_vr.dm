/obj/machinery/porta_turret/stationary/CIWS
	name = "CIWS turret"
	desc = "A ship weapons turret designed for light defense."
	req_one_access = list(access_cent_general)
	health = 200
	maxhealth = 200
	enabled = TRUE
	lethal = TRUE
	check_weapons = TRUE
	can_salvage = FALSE

/obj/machinery/porta_turret/stationary/syndie/CIWS
	name = "mercenary CIWS turret"
	desc = "A ship weapons turret designed for light defense."
	req_one_access = list(access_syndicate)
	health = 200
	maxhealth = 200
	enabled = TRUE
	lethal = TRUE
	check_weapons = TRUE
	can_salvage = FALSE

/obj/machinery/porta_turret/industrial/military
	name = "military CIWS turret"
	desc = "A ship weapons turret designed for anti-fighter defense."
	req_one_access = list(access_cent_general)
	installation = /obj/item/weapon/gun/energy/pulse_rifle/destroyer
	health = 500
	maxhealth = 500
	enabled = TRUE
	lethal = TRUE
	check_weapons = TRUE
	auto_repair = TRUE
	can_salvage = FALSE