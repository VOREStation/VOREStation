/mob/living/silicon/robot/syndicate
	lawupdate = 0
	scrambledcodes = 1
	icon_state = "syndie_bloodhound"
	modtype = "Syndicate"
	lawchannel = "State"
	braintype = "Drone"
	idcard_type = /obj/item/card/id/syndicate
	icon_selected = FALSE

/mob/living/silicon/robot/syndicate/init()
	aiCamera = new/obj/item/camera/siliconcam/robot_camera(src)

<<<<<<< HEAD
	mmi = new /obj/item/device/mmi/digital/robot(src) // Explicitly a drone.
	cut_overlays()
=======
	mmi = new /obj/item/mmi/digital/robot(src) // Explicitly a drone.
	overlays.Cut()
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
	init_id()

	updatename("Syndicate")

	if(!cell)
		cell = new /obj/item/cell/high(src) // 15k cell, because Antag.

	laws = new /datum/ai_laws/syndicate_override()

	radio.keyslot = new /obj/item/encryptionkey/syndicate(radio)
	radio.recalculateChannels()

	playsound(src, 'sound/mecha/nominalsyndi.ogg', 75, 0)

/mob/living/silicon/robot/syndicate/protector/init()
	..()
	module = new /obj/item/robot_module/robot/syndicate/protector(src)
	updatename("Protector")

/mob/living/silicon/robot/syndicate/mechanist/init()
	..()
	module = new /obj/item/robot_module/robot/syndicate/mechanist(src)
	updatename("Mechanist")

/mob/living/silicon/robot/syndicate/combat_medic/init()
	..()
	module = new /obj/item/robot_module/robot/syndicate/combat_medic(src)
	updatename("Combat Medic")

/mob/living/silicon/robot/syndicate/speech_bubble_appearance()
	return "synthetic_evil"