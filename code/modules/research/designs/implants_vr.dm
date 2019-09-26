/datum/design/item/implant/backup
	name = "Backup implant"
	id = "implant_backup"
	req_tech = list(TECH_MATERIAL = 2, TECH_BIO = 2, TECH_DATA = 4, TECH_ENGINEERING = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 2000, "glass" = 2000)
	build_path = /obj/item/weapon/implantcase/backup
	sort_string = "MFAVA"

/datum/design/item/implant/sizecontrol
	name = "Size control implant"
	id = "implant_size"
	req_tech = list(TECH_MATERIAL = 3, TECH_BIO = 4, TECH_DATA = 4, TECH_ENGINEERING = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 2000, "glass" = 2000, "silver" = 3000)
	build_path = /obj/item/weapon/implanter/sizecontrol
	sort_string = "MFAVB"

/* Make language great again
/datum/design/item/implant/language
	name = "Language implant"
	id = "implant_language"
	req_tech = list(TECH_MATERIAL = 5, TECH_BIO = 5, TECH_DATA = 4, TECH_ENGINEERING = 4) //This is not an easy to make implant.
	materials = list(DEFAULT_WALL_MATERIAL = 7000, "glass" = 7000, "gold" = 2000, "diamond" = 3000)
	build_path = /obj/item/weapon/implantcase/vrlanguage
	sort_string = "MFAVC"
*/