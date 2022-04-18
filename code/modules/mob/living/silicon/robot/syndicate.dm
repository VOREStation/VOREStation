/mob/living/silicon/robot/syndicate
	lawupdate = 0
	scrambledcodes = 1
	icon_state = "securityrobot"
	modtype = "Security"
	lawchannel = "State"
	idcard_type = /obj/item/card/id/syndicate

/mob/living/silicon/robot/syndicate/New()
	if(!cell)
		cell = new /obj/item/cell(src)
		cell.maxcharge = 25000
		cell.charge = 25000

	..()

/mob/living/silicon/robot/syndicate/init()
	aiCamera = new/obj/item/camera/siliconcam/robot_camera(src)

	laws = new /datum/ai_laws/syndicate_override
	cut_overlays()
	init_id()
	new /obj/item/robot_module/robot/syndicate(src)

	radio.keyslot = new /obj/item/encryptionkey/syndicate(radio)
	radio.recalculateChannels()

	playsound(src, 'sound/mecha/nominalsyndi.ogg', 75, 0)
