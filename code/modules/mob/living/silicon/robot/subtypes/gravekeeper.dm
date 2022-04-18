/mob/living/silicon/robot/gravekeeper
	lawupdate = 0
	scrambledcodes = 1
	icon_state = "drone-lost"
	modtype = "Gravekeeper"
	lawchannel = "State"
	braintype = "Drone"
	idcard_type = /obj/item/card/id
	icon_selected = FALSE
	can_be_antagged = FALSE

/mob/living/silicon/robot/gravekeeper/init()
	aiCamera = new/obj/item/camera/siliconcam/robot_camera(src)

<<<<<<< HEAD
	mmi = new /obj/item/device/mmi/digital/robot(src) // Explicitly a drone.
	module = new /obj/item/weapon/robot_module/robot/gravekeeper(src)
	cut_overlays()
=======
	mmi = new /obj/item/mmi/digital/robot(src) // Explicitly a drone.
	module = new /obj/item/robot_module/robot/gravekeeper(src)
	overlays.Cut()
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
	init_id()

	updatename("Gravekeeper")

	if(!cell)
		cell = new /obj/item/cell/high(src) // 15k cell, as recharging stations are a lot more rare on the Surface.

	laws = new /datum/ai_laws/gravekeeper()

	playsound(src, 'sound/mecha/nominalsyndi.ogg', 75, 0)
