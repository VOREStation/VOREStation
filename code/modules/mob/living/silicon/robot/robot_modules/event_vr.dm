/obj/item/robot_module/robot/stray
	name = "stray robot module"
	hide_on_manifest = 1
	sprites = list(
					"Stray" = "stray"
				)

/obj/item/robot_module/robot/stray/New(var/mob/living/silicon/robot/R)
	..()
	// General
	src.modules += new /obj/item/dogborg/boop_module(src)

	// Sec
	src.modules += new /obj/item/handcuffs/cyborg(src)
	src.modules += new /obj/item/dogborg/jaws/big(src)
	src.modules += new /obj/item/melee/baton/robot(src)
	src.modules += new /obj/item/dogborg/pounce(src)

	// Med
	src.modules += new /obj/item/healthanalyzer(src)
	src.modules += new /obj/item/shockpaddles/robot/hound(src)

	// Engi
	src.modules += new /obj/item/weldingtool/electric/mounted(src)
	src.modules += new /obj/item/tool/screwdriver/cyborg(src)
	src.modules += new /obj/item/tool/wrench/cyborg(src)
	src.modules += new /obj/item/tool/wirecutters/cyborg(src)
	src.modules += new /obj/item/multitool(src)

	// Boof
	src.emag 	 = new /obj/item/gun/energy/retro/mounted(src)

	var/datum/matter_synth/water = new /datum/matter_synth(500) //Starts full and has a max of 500
	water.name = "Water reserves"
	water.recharge_rate = 0
	R.water_res = water
	synths += water

	var/obj/item/reagent_containers/borghypo/hound/lost/H = new /obj/item/reagent_containers/borghypo/hound/lost(src)
	H.water = water
	src.modules += H

	var/obj/item/dogborg/tongue/T = new /obj/item/dogborg/tongue(src)
	T.water = water
	src.modules += T

	var/obj/item/dogborg/sleeper/B = new /obj/item/dogborg/sleeper(src)
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
	R.verbs |= /mob/living/silicon/robot/proc/rest_style
