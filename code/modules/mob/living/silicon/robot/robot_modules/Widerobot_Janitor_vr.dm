//This is a modular borg module.
//It self add to global and the module list.
/hook/startup/proc/Widerobot_Module_init_JaniHound()
	robot_modules["Janihound"] = /obj/item/weapon/robot_module/robot/janitor/scrubpup //Add to borg array
	robot_module_types += "Janihound" //Index our borg into the possible array options
	return 1

//Define our module
/obj/item/weapon/robot_module/robot/janitor/scrubpup
	name = "Custodial Hound module"
	sprites = list(
					"Custodial Hound" = "scrubpup",
					"Janihound model V-2" = "J9",
					"Borgi" = "borgi-jani",
					"Otieborg" = "otiej",
					"Drake" = "drakejanit"
					)
	can_be_pushed = 0

/obj/item/weapon/robot_module/robot/janitor/scrubpup/New(var/mob/living/silicon/robot/R)
	src.modules += new /obj/item/weapon/dogborg/jaws/small(src)
	src.modules += new /obj/item/device/dogborg/boop_module(src)
	src.modules += new /obj/item/pupscrubber(src)
	src.emag 	 = new /obj/item/weapon/dogborg/pounce(src) //Pounce

	//Starts empty. Can only recharge with recycled material.
	var/datum/matter_synth/metal = new /datum/matter_synth/metal()
	metal.name = "Steel reserves"
	metal.recharge_rate = 0
	metal.max_energy = 50000
	metal.energy = 0
	var/datum/matter_synth/glass = new /datum/matter_synth/glass()
	glass.name = "Glass reserves"
	glass.recharge_rate = 0
	glass.max_energy = 50000
	glass.energy = 0
	var/datum/matter_synth/water = new /datum/matter_synth(500)
	water.name = "Water reserves"
	water.recharge_rate = 0
	R.water_res = water

	synths += metal
	synths += glass
	synths += water

	var/obj/item/device/dogborg/tongue/T = new /obj/item/device/dogborg/tongue(src)
	T.water = water
	src.modules += T

	var/obj/item/device/lightreplacer/dogborg/LR = new /obj/item/device/lightreplacer/dogborg(src)
	LR.glass = glass
	src.modules += LR

	var/obj/item/device/dogborg/sleeper/compactor/C = new /obj/item/device/dogborg/sleeper/compactor(src)
	C.metal = metal
	C.glass = glass
	C.water = water
	src.modules += C

	//Sheet refiners can only produce raw sheets.
	var/obj/item/stack/material/cyborg/steel/M = new (src)
	M.name = "steel recycler"
	M.desc = "A device that refines recycled steel into sheets."
	M.synths = list(metal)
	M.recipes = list()
	M.recipes += new/datum/stack_recipe("steel sheet", /obj/item/stack/material/steel, 1, 1, 20)
	src.modules += M

	var/obj/item/stack/material/cyborg/glass/G = new (src)
	G.name = "glass recycler"
	G.desc = "A device that refines recycled glass into sheets."
	G.material = get_material_by_name("placeholder") //Hacky shit but we want sheets, not windows.
	G.synths = list(glass)
	G.recipes = list()
	G.recipes += new/datum/stack_recipe("glass sheet", /obj/item/stack/material/glass, 1, 1, 20)
	src.modules += G

	R.icon 		 = 'icons/mob/widerobot_jan_vr.dmi'
	R.wideborg_dept  = 'icons/mob/widerobot_jan_vr.dmi'
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
