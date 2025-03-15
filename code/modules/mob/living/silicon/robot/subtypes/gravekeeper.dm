/mob/living/silicon/robot/gravekeeper
	lawupdate = 0
	scrambledcodes = 1
	icon_state = "drone-lost"
	modtype = "Gravekeeper"
	lawchannel = "State"
	braintype = "Drone"
	idcard_type = /obj/item/card/id/lost
	icon_selected = FALSE
	can_be_antagged = FALSE
	restrict_modules_to = list("Gravekeeper")
	ui_theme = "malfunction"

/mob/living/silicon/robot/gravekeeper/init()
	aiCamera = new/obj/item/camera/siliconcam/robot_camera(src)

	mmi = new /obj/item/mmi/digital/robot(src) // Explicitly a drone.
	module = new /obj/item/robot_module/robot/gravekeeper(src)
	cut_overlays()
	init_id()

	updatename("Gravekeeper")

	if(!cell)
		cell = new /obj/item/cell/high(src) // 15k cell, as recharging stations are a lot more rare on the Surface.

	laws = new /datum/ai_laws/gravekeeper()

	playsound(src, 'sound/mecha/nominalsyndi.ogg', 75, 0)

/mob/living/silicon/robot/gravekeeper/proc/scramble_hardware(var/chance)
	if(prob(chance))  //Small chance to spawn with a scrambled
		emag_items = 1

/mob/living/silicon/robot/gravekeeper/handle_special_unlocks()
	if(!emag_items)
		scramble_hardware(10)
	if (churn_count == 5)
		module.emag += new /obj/item/self_repair_system/advanced(module)
		hud_used.update_robot_modules_display()
