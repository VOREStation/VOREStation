/datum/design/excavationdrill
	name = "Excavation Drill"
	desc = "Advanced archaeological drill combining ultrasonic excitation and bluespace manipulation to provide extreme precision. The silver tip is adjustable from 1 to 30 cm."
	id = "excavationdrill"
	req_tech = list(TECH_MATERIAL = 4, TECH_POWER = 3, TECH_ENGINEERING = 3, TECH_BLUESPACE = 3) //They were never used before. Now they'll be used. Hopefully.
	build_type = PROTOLATHE
	materials = list(DEFAULT_WALL_MATERIAL = 4000, "$glass" = 1000, "$silver" = 1000)
	build_path = /obj/item/weapon/pickaxe/excavationdrill