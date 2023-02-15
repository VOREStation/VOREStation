//This is a modular borg module.
//It self add to global and the module list.
/hook/startup/proc/Widerobot_Module_init_TraumaHound()
	robot_modules["TraumaHound"] = /obj/item/weapon/robot_module/robot/medical/traumahound //Add to borg array
	robot_module_types += "TraumaHound" //Index our borg into the possible array options
	return 1


/obj/item/weapon/robot_module/robot/medical/traumahound
	name = "traumahound robot module"
	sprites = list(
					"Traumahound" = "traumavale",
					"Drake" = "draketrauma",
					"Borgi" = "borgi-trauma"
					)

/obj/item/weapon/robot_module/robot/medical/traumahound/New(var/mob/living/silicon/robot/R)
	src.modules += new /obj/item/device/healthanalyzer(src)
	src.modules += new /obj/item/weapon/dogborg/jaws/small(src)
	src.modules += new /obj/item/device/dogborg/boop_module(src)
	src.modules += new /obj/item/weapon/autopsy_scanner(src)
	src.modules += new /obj/item/weapon/surgical/scalpel/cyborg(src)
	src.modules += new /obj/item/weapon/surgical/hemostat/cyborg(src)
	src.modules += new /obj/item/weapon/surgical/retractor/cyborg(src)
	src.modules += new /obj/item/weapon/surgical/cautery/cyborg(src)
	src.modules += new /obj/item/weapon/surgical/bonegel/cyborg(src)
	src.modules += new /obj/item/weapon/surgical/FixOVein/cyborg(src)
	src.modules += new /obj/item/weapon/surgical/bonesetter/cyborg(src)
	src.modules += new /obj/item/weapon/surgical/circular_saw/cyborg(src)
	src.modules += new /obj/item/weapon/surgical/surgicaldrill/cyborg(src)
	src.modules += new /obj/item/weapon/surgical/bioregen/cyborg(src) //let them succ
	src.modules += new /obj/item/weapon/gripper/no_use/organ(src)
	src.modules += new /obj/item/weapon/gripper/medical(src)
	src.modules += new /obj/item/weapon/shockpaddles/robot/hound(src) //Paws of life
	src.modules += new /obj/item/weapon/reagent_containers/dropper(src) // Allows surgeon borg to fix necrosis
	src.modules += new /obj/item/weapon/reagent_containers/syringe(src)
	src.emag 	= new /obj/item/weapon/dogborg/pounce(src) //Pounce, also, lets not give them polyacid spray

	var/datum/matter_synth/water = new /datum/matter_synth(500)
	water.name = "Water reserves"
	water.recharge_rate = 0
	R.water_res = water
	synths += water

	var/obj/item/device/dogborg/tongue/T = new /obj/item/device/dogborg/tongue(src)
	T.water = water
	src.modules += T

	var/obj/item/weapon/reagent_containers/borghypo/hound/trauma/H = new /obj/item/weapon/reagent_containers/borghypo/hound/trauma(src) //surgeon chems
	H.water = water
	src.modules += H

	var/obj/item/device/dogborg/sleeper/compactor/trauma/B = new /obj/item/device/dogborg/sleeper/compactor/trauma(src) //So they can nom people and heal them
	B.water = water
	src.modules += B

	var/datum/matter_synth/medicine = new /datum/matter_synth/medicine(10000) //this is so they can do brute/burn surgeries and fix assisted/prosthetic organs
	synths += medicine

	var/obj/item/stack/nanopaste/N = new /obj/item/stack/nanopaste(src)
	var/obj/item/stack/medical/advanced/bruise_pack/S = new /obj/item/stack/medical/advanced/bruise_pack(src)
	var/obj/item/stack/medical/advanced/ointment/O = new /obj/item/stack/medical/advanced/ointment(src)
	N.uses_charge = 1
	N.charge_costs = list(1000)
	N.synths = list(medicine)
	S.uses_charge = 1
	S.charge_costs = list(1000)
	S.synths = list(medicine)
	O.uses_charge = 1
	O.charge_costs = list(1000)
	O.synths = list(medicine)
	src.modules += N
	src.modules += S
	src.modules += O

	R.icon = 'icons/mob/widerobot_trauma_vr.dmi'
	R.wideborg_dept = 'icons/mob/widerobot_trauma_vr.dmi'
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
