/mob/living/silicon/robot/malf/gravekeeper
	icon_state = "drone-lost"
	modtype = "Gravekeeper"
	can_be_antagged = FALSE
	restrict_modules_to = list("Gravekeeper")

/mob/living/silicon/robot/malf/gravekeeper/init()
	..()
	module = new /obj/item/robot_module/robot/gravekeeper(src)
	laws = new /datum/ai_laws/gravekeeper()
