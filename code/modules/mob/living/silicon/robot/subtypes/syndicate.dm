/mob/living/silicon/robot/syndicate
	lawupdate = FALSE
	scrambledcodes = TRUE
	emagged = TRUE
	modtype = "Syndicate"
	lawchannel = "State"
	braintype = "Drone"
	idcard_type = /obj/item/card/id/syndicate
	ui_theme = "syndicate"

/mob/living/silicon/robot/syndicate/init()
	aiCamera = new/obj/item/camera/siliconcam/robot_camera(src)

	if(!restrict_modules_to)
		restrict_modules_to = GLOB.antag_module_types
	mmi = new /obj/item/mmi/digital/robot(src) // Explicitly a drone.

	updatename(modtype)

	if(!cell)
		cell = new /obj/item/cell/robot_syndi(src) // 25k cell, because Antag.

	// new /obj/item/robot_module/robot/syndicate(src)

	laws = new /datum/ai_laws/syndicate_override()

	radio.keyslot = new /obj/item/encryptionkey/syndicate(radio)
	radio.recalculateChannels()

	playsound(src, 'sound/mecha/nominalsyndi.ogg', 75, 0)

/mob/living/silicon/robot/syndicate/protector/init()
	..()
	module = new /obj/item/robot_module/robot/syndicate/protector(src)
	modtype = "Protector"
	restrict_modules_to = list("Protector")

/mob/living/silicon/robot/syndicate/mechanist/init()
	..()
	module = new /obj/item/robot_module/robot/syndicate/mechanist(src)
	modtype = "Mechanist"
	restrict_modules_to = list("Mechanist")

/mob/living/silicon/robot/syndicate/combat_medic/init()
	..()
	module = new /obj/item/robot_module/robot/syndicate/combat_medic(src)
	modtype = "Combat Medic"
	restrict_modules_to = list("Combat Medic")

/mob/living/silicon/robot/syndicate/ninja/init()
	..()
	module = new /obj/item/robot_module/robot/syndicate/ninja(src)
	modtype = "Ninja"
	restrict_modules_to = list("Ninja")

/mob/living/silicon/robot/syndicate/speech_bubble_appearance()
	return "synthetic_evil"
