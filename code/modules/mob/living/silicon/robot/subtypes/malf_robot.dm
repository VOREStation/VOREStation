/mob/living/silicon/robot/malf
	lawupdate = FALSE
	scrambledcodes = TRUE
	modtype = "Malf"
	lawchannel = "State"
	braintype = "Drone"
	idcard_type = /obj/item/card/id/lost
	ui_theme = "malfunction"

/mob/living/silicon/robot/malf/init()
	aiCamera = new/obj/item/camera/siliconcam/robot_camera(src)

	if(!restrict_modules_to)
		restrict_modules_to = GLOB.malf_module_types

	mmi = new /obj/item/mmi/digital/robot(src) // Explicitly a drone.
	cut_overlays()
	init_id()

	updatename(modtype)

	if(!cell)
		cell = new /obj/item/cell/high(src) // 15k cell, as recharging stations are a lot more rare on the Surface.

	playsound(src, 'sound/mecha/nominalsyndi.ogg', 75, 0)
