//This is a modular borg module.
//It self add to global and the module list.
/hook/startup/proc/Widerobot_Module_init_KMine()
	robot_modules["KMine"] = /obj/item/weapon/robot_module/robot/miner/kmine //Add to borg array
	robot_module_types += "KMine" //Index our borg into the possible array options
	return 1

//Define our module
/obj/item/weapon/robot_module/robot/miner/kmine
	name = "Supply Hound Module"
	sprites = list(
					"KMine" = "kmine",
					"CargoHound" = "cargohound",
					"CargoHoundDark" = "cargohounddark",
					"Drake" = "drakemine"
					)
	can_be_pushed = 0

/obj/item/weapon/robot_module/robot/miner/kmine/New(var/mob/living/silicon/robot/R)
	src.modules += new /obj/item/borg/sight/material(src)
	src.modules += new /obj/item/weapon/tool/wrench/cyborg(src)
	src.modules += new /obj/item/weapon/tool/screwdriver/cyborg(src)
	src.modules += new /obj/item/weapon/storage/bag/ore(src)
	src.modules += new /obj/item/weapon/pickaxe/borgdrill(src)
	src.modules += new /obj/item/weapon/storage/bag/sheetsnatcher/borg(src)
	src.modules += new /obj/item/weapon/gripper/miner(src)
	src.modules += new /obj/item/weapon/mining_scanner(src)
	src.modules += new /obj/item/weapon/dogborg/jaws/small(src)
	// New Emag gear for the minebots!
	src.emag = new /obj/item/weapon/kinetic_crusher/machete/dagger(src)

	// No reason for these, upgrade modules replace them.
	//src.emag = new /obj/item/weapon/pickaxe/plasmacutter(src)
	//src.emag = new /obj/item/weapon/pickaxe/diamonddrill(src)

	var/datum/matter_synth/water = new /datum/matter_synth(500)
	water.name = "Water reserves"
	water.recharge_rate = 0
	R.water_res = water
	synths += water

	var/obj/item/device/dogborg/tongue/T = new /obj/item/device/dogborg/tongue(src)
	T.water = water
	src.modules += T

	var/obj/item/device/dogborg/sleeper/B = new /obj/item/device/dogborg/sleeper/compactor/supply(src)
	B.water = water
	src.modules += B

	R.icon = 'icons/mob/widerobot_car_vr.dmi'
	R.wideborg_dept = 'icons/mob/widerobot_car_vr.dmi'
	R.hands.icon = 'icons/mob/screen1_robot_vr.dmi'
	R.ui_style_vr = TRUE
	R.pixel_x 	 = -16
	R.old_x  	 = -16
	R.default_pixel_x = -16
	R.dogborg = TRUE
	R.wideborg = TRUE
	R.verbs |= /mob/living/silicon/robot/proc/ex_reserve_refill
	R.verbs |= /mob/living/silicon/robot/proc/robot_mount
	R.verbs |= /mob/living/proc/toggle_rider_reins
	R.verbs |= /mob/living/proc/shred_limb
	R.verbs |= /mob/living/silicon/robot/proc/rest_style

	..()
