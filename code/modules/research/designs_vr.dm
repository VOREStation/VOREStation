/datum/design/excavationdrill
	name = "Excavation Drill"
	desc = "Advanced archaeological drill combining ultrasonic excitation and bluespace manipulation to provide extreme precision. The silver tip is adjustable from 1 to 30 cm."
	id = "excavationdrill"
	req_tech = list(TECH_MATERIAL = 4, TECH_POWER = 3, TECH_ENGINEERING = 3, TECH_BLUESPACE = 3) //They were never used before. Now they'll be used. Hopefully.
	build_type = PROTOLATHE
	materials = list(DEFAULT_WALL_MATERIAL = 4000, "glass" = 1000, "silver" = 1000)
	build_path = /obj/item/weapon/pickaxe/excavationdrill

/datum/design/item/implant/language
	name = "language implant"
	id = "implant_language"
	req_tech = list(TECH_MATERIAL = 5, TECH_BIO = 5, TECH_DATA = 4, TECH_ENGINEERING = 4) //This is not an easy to make implant.
	materials = list(DEFAULT_WALL_MATERIAL = 7000, "glass" = 7000, "gold" = 2000, "diamond" = 3000)
	build_path = /obj/item/weapon/implantcase/language

/datum/design/item/weapon/sizegun
	name = "shrink ray"
	id = "shrinkray"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3, TECH_POWER = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 3000, "glass" = 2000, "uranium" = 2000)
	build_path = /obj/item/weapon/gun/energy/sizegun
	sort_string = "TAAAB"
