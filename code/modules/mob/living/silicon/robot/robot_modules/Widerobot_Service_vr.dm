//This is a modular borg module.
//It self add to global and the module list.
/hook/startup/proc/Widerobot_Module_init_ServiceHound()
	robot_modules["Service-Hound"] = /obj/item/weapon/robot_module/robot/clerical/butler/brodog //Add to borg array
	robot_module_types += "Service-Hound" //Index our borg into the possible array options
	shell_module_types += "Service-Hound"//AIs should be able to use us too
	return 1


//Define our module
// Uses modified K9 sprites.
/obj/item/weapon/robot_module/robot/clerical/butler/brodog
	name = "service-hound module"
	sprites = list(
					"Blackhound" = "k50",
					"Pinkhound" = "k69",
					"ServicehoundV2" = "serve2",
					"ServicehoundV2 Darkmode" = "servedark",
					"Drake" = "drakemine"
					)
	can_be_pushed = 0


// In a nutshell, basicly service/butler robot but in dog form. - Port from CitadelRP
/obj/item/weapon/robot_module/robot/clerical/butler/brodog/New(var/mob/living/silicon/robot/R)
	src.modules += new /obj/item/weapon/gripper/service(src)
	src.modules += new /obj/item/weapon/reagent_containers/glass/bucket(src)
	src.modules += new /obj/item/weapon/material/minihoe(src)
	src.modules += new /obj/item/weapon/material/knife/machete/hatchet(src)
	src.modules += new /obj/item/device/analyzer/plant_analyzer(src)
	src.modules += new /obj/item/weapon/storage/bag/dogborg(src)
	src.modules += new /obj/item/weapon/robot_harvester(src)
	src.modules += new /obj/item/weapon/material/knife(src)
	src.modules += new /obj/item/weapon/material/kitchen/rollingpin(src)
	src.modules += new /obj/item/device/multitool(src) //to freeze trays
	src.modules += new /obj/item/weapon/dogborg/jaws/small(src)
	src.modules += new /obj/item/device/dogborg/boop_module(src)
	src.emag 	 = new /obj/item/weapon/dogborg/pounce(src) //Pounce

	var/datum/matter_synth/water = new /datum/matter_synth(500) // buffy fix, was 0
	water.name = "Water reserves"
	water.recharge_rate = 0
	water.max_energy = 1000
	R.water_res = water
	synths += water


	var/obj/item/device/dogborg/tongue/T = new /obj/item/device/dogborg/tongue(src)
	T.water = water
	src.modules += T

	var/obj/item/weapon/rsf/M = new /obj/item/weapon/rsf(src)
	M.stored_matter = 30
	src.modules += M

	src.modules += new /obj/item/weapon/reagent_containers/dropper/industrial(src)

	var/obj/item/weapon/flame/lighter/zippo/L = new /obj/item/weapon/flame/lighter/zippo(src)
	L.lit = 1
	src.modules += L

	src.modules += new /obj/item/weapon/tray/robotray(src)
	src.modules += new /obj/item/weapon/reagent_containers/borghypo/service(src)

/* // I don't know what kind of sleeper to put here, but also no need if you already have "Robot Nom" verb. - revisit later
	var/obj/item/device/dogborg/sleeper/K9/B = new /obj/item/device/dogborg/sleeper/K9(src)
	B.water = water
	src.modules += B
*/

	R.icon 		 = 'icons/mob/widerobot_ser_vr.dmi'
	R.wideborg_dept  = 'icons/mob/widerobot_ser_vr.dmi'
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
