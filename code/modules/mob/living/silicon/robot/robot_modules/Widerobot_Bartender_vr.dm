//This is a modular borg module.
//It self add to global and the module list.
/hook/startup/proc/Widerobot_Module_init_BoozeHound()
	robot_modules["BoozeHound"] = /obj/item/weapon/robot_module/robot/clerical/butler/booze //Add to borg array
	robot_module_types += "BoozeHound" //Index our borg into the possible array options
	shell_module_types += "BoozeHound"//AIs should be able to use us too
	return 1


//Define our module
/obj/item/weapon/robot_module/robot/clerical/butler/booze
	name = "BoozeHound robot module"
	can_be_pushed = 0
	sprites = list(
				"Beer Buddy" = "boozeborg",
				"Brilliant Blue" = "boozeborg(blue)",
				"Caffine Dispenser" = "boozeborg(coffee)",
				"Gamer Juice Maker" = "boozeborg(green)",
				"Liqour Licker" = "boozeborg(orange)",
				"The Grapist" = "boozeborg(purple)",
				"Vampire's Aid" = "boozeborg(red)"
				)

/obj/item/weapon/robot_module/robot/clerical/butler/booze/New(var/mob/living/silicon/robot/R)
	..()
	src.modules += new /obj/item/weapon/gripper/service(src)
	//src.modules += new /obj/item/weapon/reagent_containers/glass/bucket(src)
	//src.modules += new /obj/item/weapon/material/minihoe(src)
	//src.modules += new /obj/item/device/analyzer/plant_analyzer(src)
	//src.modules += new /obj/item/weapon/storage/bag/plants(src)
	//src.modules += new /obj/item/weapon/robot_harvester(src)
	src.modules += new /obj/item/weapon/material/knife(src)
	src.modules += new /obj/item/weapon/material/kitchen/rollingpin(src)
	src.modules += new /obj/item/device/multitool(src) //to freeze trays
	src.modules += new /obj/item/weapon/dogborg/jaws/small(src)
	src.modules += new /obj/item/weapon/tray/robotray
	src.modules += new /obj/item/device/dogborg/boop_module(src)
	src.modules += new /obj/item/device/dogborg/sleeper/compactor/brewer(src)
	src.emag 	 = new /obj/item/weapon/dogborg/pounce(src)
	R.verbs += /mob/living/silicon/robot/proc/reskin_booze

	var/obj/item/weapon/rsf/M = new /obj/item/weapon/rsf(src)
	M.stored_matter = 30
	src.modules += M

	src.modules += new /obj/item/weapon/reagent_containers/dropper/industrial(src)

	var/obj/item/weapon/flame/lighter/zippo/L = new /obj/item/weapon/flame/lighter/zippo(src)
	L.lit = 1
	src.modules += L

	src.modules += new /obj/item/weapon/tray/robotray(src)
	src.modules += new /obj/item/weapon/reagent_containers/borghypo/service(src)

	R.icon 		 = 'icons/mob/widerobot_colors_vr.dmi'
	R.wideborg_dept = 'icons/mob/widerobot_colors_vr.dmi'
	R.hands.icon = 'icons/mob/screen1_robot_vr.dmi'
	R.ui_style_vr = TRUE
	R.pixel_x 	 = -16
	R.old_x 	 = -16
	R.default_pixel_x = -16
	R.dogborg = TRUE
	R.wideborg = TRUE
	R.verbs |= /mob/living/silicon/robot/proc/ex_reserve_refill
	..()

/obj/item/weapon/robot_module/robot/clerical/butler/booze/respawn_consumable(var/mob/living/silicon/robot/R, var/amount)
	var/obj/item/weapon/reagent_containers/food/condiment/enzyme/E = locate() in src.modules
	E.reagents.add_reagent("enzyme", 2 * amount)
