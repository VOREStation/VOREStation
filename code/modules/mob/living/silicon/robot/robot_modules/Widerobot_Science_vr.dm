//This is a modular borg module.
//It self add to global and the module list.
/hook/startup/proc/Widerobot_Module_init_SciHound()
	robot_modules["Sci-borg"] = /obj/item/weapon/robot_module/robot/research/sciencehound //Add to borg array
	robot_module_types += "Sci-borg" //Index our borg into the possible array options
	return 1


//Define our module
/obj/item/weapon/robot_module/robot/research/sciencehound
	name = "Research Hound Module"
	sprites = list(
					"Research Hound" = "science",
					"Borgi" = "borgi-sci",
					"SciHound" = "scihound",
					"SciHoundDark" = "scihounddark",
					"Drake" = "drakesci",
					"Raptor V-4" = "sciraptor"
					)
	can_be_pushed = 0

/obj/item/weapon/robot_module/robot/research/sciencehound/New(var/mob/living/silicon/robot/R)
	src.modules += new /obj/item/weapon/dogborg/jaws/small(src)
	src.modules += new /obj/item/device/dogborg/boop_module(src)
	src.modules += new /obj/item/weapon/gripper/research(src)
	src.modules += new /obj/item/weapon/gripper/no_use/loader(src)
	src.modules += new /obj/item/weapon/tool/screwdriver/cyborg(src)
	src.modules += new /obj/item/weapon/weldingtool/electric/mounted/cyborg(src)
	src.modules += new /obj/item/weapon/tool/wrench/cyborg(src)
	src.modules += new /obj/item/weapon/tool/wirecutters/cyborg(src)
	src.modules += new /obj/item/device/multitool(src)
	src.modules += new /obj/item/weapon/reagent_containers/glass/beaker/large(src)
	src.modules += new /obj/item/weapon/storage/part_replacer(src)
	src.modules += new /obj/item/device/robotanalyzer(src)
	src.modules += new /obj/item/weapon/card/robot(src)
	//Added a circuit gripper
	src.modules += new /obj/item/weapon/gripper/circuit(src)
	src.modules += new /obj/item/weapon/gripper/no_use/organ/robotics(src)
	//src.modules += new /obj/item/weapon/surgical/scalpel/cyborg(src) //these are on the normal one, but do not appear to have a purpose other than borging
	//src.modules += new /obj/item/weapon/surgical/circular_saw/cyborg(src) //so I am leaving them here but commented out because robotics no do the borging w/o medical
	src.modules += new /obj/item/weapon/portable_destructive_analyzer(src) //destructive analyzer option for pref respect while also being able to do job
	src.modules += new /obj/item/weapon/gripper/no_use/mech(src)
	src.modules += new /obj/item/weapon/shockpaddles/robot/jumper(src) //unkilling synths may be important actually
	src.modules += new /obj/item/weapon/melee/baton/slime/robot(src) //save the xenobio from themselves
	src.modules += new /obj/item/weapon/gun/energy/taser/xeno/robot(src) //save the xenobio from themselves from a distance
	src.modules += new /obj/item/device/xenoarch_multi_tool(src) //go find fancy rock
	src.modules += new /obj/item/weapon/pickaxe/excavationdrill(src) //go get fancy rock
	src.emag = new /obj/item/weapon/hand_tele(src)

	var/datum/matter_synth/water = new /datum/matter_synth(500)
	water.name = "Water reserves"
	water.recharge_rate = 0
	R.water_res = water
	synths += water

	var/obj/item/device/dogborg/tongue/T = new /obj/item/device/dogborg/tongue(src)
	T.water = water
	src.modules += T

	var/obj/item/device/dogborg/sleeper/compactor/analyzer/B = new /obj/item/device/dogborg/sleeper/compactor/analyzer(src)
	B.water = water
	src.modules += B

	var/datum/matter_synth/nanite = new /datum/matter_synth/nanite(10000)
	synths += nanite
	var/datum/matter_synth/wire = new /datum/matter_synth/wire()
	synths += wire

	var/obj/item/stack/nanopaste/N = new /obj/item/stack/nanopaste(src)
	N.uses_charge = 1
	N.charge_costs = list(1000)
	N.synths = list(nanite)
	src.modules += N

	var/obj/item/stack/cable_coil/cyborg/C = new /obj/item/stack/cable_coil/cyborg(src)
	C.synths = list(wire)
	src.modules += C

	R.icon 		 = 'icons/mob/widerobot_sci_vr.dmi'
	R.wideborg_dept  = 'icons/mob/widerobot_sci_vr.dmi'
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
