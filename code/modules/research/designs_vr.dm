/datum/design/excavationdrill
	name = "Excavation Drill"
	desc = "Advanced archaeological drill combining ultrasonic excitation and bluespace manipulation to provide extreme precision. The diamond tip is adjustable from 1 to 30 cm."
	id = "excavationdrill"
	req_tech = list(TECH_MATERIAL = 5, TECH_POWER = 3, TECH_ENGINEERING = 3, TECH_BLUESPACE = 4)
	build_type = PROTOLATHE
	materials = list(DEFAULT_WALL_MATERIAL = 4000, "$glass" = 1000, "$silver" = 1000, "$diamond" = 500)
	build_path = /obj/item/weapon/pickaxe/excavationdrill