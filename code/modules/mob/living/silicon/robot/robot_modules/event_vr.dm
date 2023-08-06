/obj/item/weapon/robot_module/robot/stray
	name = "stray robot module"
	hide_on_manifest = 1
	sprites = list(
					"Stray" = "stray"
				)

/obj/item/weapon/robot_module/robot/stray/New(var/mob/living/silicon/robot/R)
	..()
	// General
	src.modules += new /obj/item/device/dogborg/boop_module(src)

	// Sec
	src.modules += new /obj/item/weapon/handcuffs/cyborg(src)
	src.modules += new /obj/item/weapon/dogborg/jaws/big(src)
	src.modules += new /obj/item/weapon/melee/baton/robot(src)
	src.modules += new /obj/item/weapon/dogborg/pounce(src)

	// Med
	src.modules += new /obj/item/device/healthanalyzer(src)
	src.modules += new /obj/item/weapon/shockpaddles/robot/hound(src)

	// Engi
	src.modules += new /obj/item/weapon/weldingtool/electric/mounted(src)
	src.modules += new /obj/item/weapon/tool/screwdriver/cyborg(src)
	src.modules += new /obj/item/weapon/tool/wrench/cyborg(src)
	src.modules += new /obj/item/weapon/tool/wirecutters/cyborg(src)
	src.modules += new /obj/item/device/multitool(src)

	// Boof
	src.emag 	 = new /obj/item/weapon/gun/energy/retro/mounted(src)

	var/datum/matter_synth/water = new /datum/matter_synth(500) //Starts full and has a max of 500
	water.name = "Water reserves"
	water.recharge_rate = 0
	R.water_res = water
	synths += water

	var/obj/item/weapon/reagent_containers/borghypo/hound/lost/H = new /obj/item/weapon/reagent_containers/borghypo/hound/lost(src)
	H.water = water
	src.modules += H

	var/obj/item/device/dogborg/tongue/T = new /obj/item/device/dogborg/tongue(src)
	T.water = water
	src.modules += T

	var/obj/item/device/dogborg/sleeper/B = new /obj/item/device/dogborg/sleeper(src)
	B.water = water
	src.modules += B

	R.icon 		 = 'icons/mob/widerobot_vr.dmi'
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