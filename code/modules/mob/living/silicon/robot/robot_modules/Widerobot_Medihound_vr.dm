//This is a modular borg module.
//It self add to global and the module list.
/hook/startup/proc/Widerobot_Module_init_Medihound()
	robot_modules["Medihound"] = /obj/item/weapon/robot_module/robot/medical/medihound //Add to borg array
	robot_module_types += "Medihound" //Index our borg into the possible array options
	return 1

//Define our module
/obj/item/weapon/robot_module/robot/medical/medihound
	name = "MediHound module"
	sprites = list(
					"Medical Hound" = "medihound",
					"Dark Medical Hound (Static)" = "medihounddark",
					"Mediborg model V-2" = "vale",
					"Borgi" = "borgi-medi",
					"Drake" = "drakemed",
					"Raptor V-4" = "medraptor"
					)

//define what happens on module build
/obj/item/weapon/robot_module/robot/medical/medihound/New(var/mob/living/silicon/robot/R)
	src.modules += new /obj/item/weapon/dogborg/jaws/small(src) //In case a patient is being attacked by carp.
	src.modules += new /obj/item/device/dogborg/boop_module(src) //Boop the crew.
	src.modules += new /obj/item/device/healthanalyzer(src) // See who's hurt specificially.
	src.modules += new /obj/item/weapon/reagent_containers/syringe(src) //In case the chemist is nice!
	src.modules += new /obj/item/weapon/reagent_containers/glass/beaker/large(src)//For holding the chemicals when the chemist is nice, made it the large variant in 2022
	src.modules += new /obj/item/device/sleevemate(src) //Lets them scan people.
	src.modules += new /obj/item/weapon/shockpaddles/robot/hound(src) //Paws of life
	src.modules += new /obj/item/weapon/inflatable_dispenser/robot(src) //This is kinda important for rescuing people without making it worse for everyone
	src.modules += new /obj/item/weapon/gripper/medical(src) //Let them do literally anything in medbay other than patch external damage and lick people
	src.modules += new /obj/item/weapon/reagent_containers/dropper/industrial(src) //dropper is nice to have for so much actually
	src.emag 	 = new /obj/item/weapon/dogborg/pounce(src) //Pounce

	var/datum/matter_synth/medicine = new /datum/matter_synth/medicine(10000)
	synths += medicine

	var/obj/item/stack/medical/advanced/clotting/C = new (src)
	var/obj/item/stack/medical/splint/S = new /obj/item/stack/medical/splint(src)
	C.uses_charge = 1
	C.charge_costs = list(5000)
	C.synths = list(medicine)
	S.uses_charge = 1
	S.charge_costs = list(1000)
	S.synths = list(medicine)
	src.modules += C
	src.modules += S

	var/datum/matter_synth/water = new /datum/matter_synth(500)
	water.name = "Water reserves"
	water.recharge_rate = 0
	R.water_res = water
	synths += water

	var/obj/item/weapon/reagent_containers/borghypo/hound/H = new /obj/item/weapon/reagent_containers/borghypo/hound(src)
	H.water = water
	src.modules += H

	var/obj/item/device/dogborg/tongue/T = new /obj/item/device/dogborg/tongue(src)
	T.water = water
	src.modules += T

	var/obj/item/device/dogborg/sleeper/B = new /obj/item/device/dogborg/sleeper(src) //So they can nom people and heal them
	B.water = water
	src.modules += B

	R.icon = 'icons/mob/widerobot_med_vr.dmi'
	R.wideborg_dept = 'icons/mob/widerobot_med_vr.dmi'
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

