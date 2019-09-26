/datum/design/item/weapon/xenobio/AssembleDesignName()
	..()
	name = "Xenobiology equipment design ([item_name])"

// Xenobio Weapons

/datum/design/item/weapon/xenobio/slimebaton
	id = "slimebaton"
	req_tech = list(TECH_MATERIAL = 2, TECH_BIO = 2, TECH_POWER = 3, TECH_COMBAT = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 5000)
	build_path = /obj/item/weapon/melee/baton/slime
	sort_string = "HAAAA"

/datum/design/item/weapon/xenobio/slimetaser
	id = "slimetaser"
	req_tech = list(TECH_MATERIAL = 3, TECH_BIO = 3, TECH_POWER = 4, TECH_COMBAT = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 5000)
	build_path = /obj/item/weapon/gun/energy/taser/xeno
	sort_string = "HAAAB"

// Other

/datum/design/item/weapon/xenobio/slime_scanner
	name = "slime scanner"
	desc = "A hand-held body scanner able to learn information about slimes."
	id = "slime_scanner"
	req_tech = list(TECH_MAGNET = 2, TECH_BIO = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 500, "glass" = 500)
	build_path = /obj/item/device/slime_scanner
	sort_string = "HBAAA"