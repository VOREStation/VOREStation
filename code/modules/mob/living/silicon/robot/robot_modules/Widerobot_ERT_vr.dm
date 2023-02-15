//This is a modular borg module.
//It self add to global and the module list.
/hook/startup/proc/Widerobot_Module_init_ERT()
	robot_modules["ERT"] = /obj/item/weapon/robot_module/robot/security/ert //Add to borg array
	emergency_module_types += "ERT" //Index our borg into the possible EMERGENCY array options
	return 1

//Define our module
/obj/item/weapon/robot_module/robot/security/ert
	name = "Emergency Responce module"
	sprites = list(
					"Standard" = "ert",
					"Classic" = "ertold",
					"Borgi" = "borgi"
					)

/obj/item/weapon/robot_module/robot/security/ert/New(var/mob/living/silicon/robot/R)
	src.modules += new /obj/item/weapon/handcuffs/cyborg(src)
	src.modules += new /obj/item/weapon/dogborg/jaws/ert(src)
	src.modules += new /obj/item/taperoll/police(src)
	src.modules += new /obj/item/weapon/gun/energy/taser/mounted/cyborg/ertgun(src)
	src.modules += new /obj/item/weapon/dogborg/swordtail(src)
	src.emag     = new /obj/item/weapon/gun/energy/laser/mounted(src)

	var/datum/matter_synth/water = new /datum/matter_synth(500)
	water.name = "Water reserves"
	water.recharge_rate = 0
	R.water_res = water
	synths += water

	var/obj/item/device/dogborg/tongue/T = new /obj/item/device/dogborg/tongue(src)
	T.water = water
	src.modules += T

	var/obj/item/device/dogborg/sleeper/K9/B = new /obj/item/device/dogborg/sleeper/K9/ert(src)
	B.water = water
	src.modules += B

	R.icon 		 = 'icons/mob/widerobot_ert_vr.dmi'
	R.wideborg_dept = 'icons/mob/widerobot_ert_vr.dmi'
	R.hands.icon = 'icons/mob/screen1_robot_vr.dmi'
	R.ui_style_vr = TRUE
	R.pixel_x 	 = -16
	R.old_x 	 = -16
	R.default_pixel_x = -16
	R.dogborg = TRUE
	R.wideborg = TRUE
	R.verbs |= /mob/living/silicon/robot/proc/ex_reserve_refill
	R.verbs |= /mob/living/silicon/robot/proc/robot_mount
	R.verbs |= /mob/living/proc/toggle_rider_reins
	R.verbs |= /mob/living/proc/shred_limb
	R.verbs |= /mob/living/silicon/robot/proc/rest_style
	..()
