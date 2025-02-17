/obj/item/mmi/digital/robot
	name = "robotic intelligence circuit"
	desc = "The pinnacle of artifical intelligence which can be achieved using classical computer science."
	icon = 'icons/obj/module.dmi'
	icon_state = "mainboard"
	w_class = ITEMSIZE_NORMAL
	origin_tech = list(TECH_ENGINEERING = 4, TECH_MATERIAL = 3, TECH_DATA = 4)

/obj/item/mmi/digital/robot/Initialize(mapload)
	. = ..()
	brainmob.name = "[pick(list("ADA","DOS","GNU","MAC","WIN"))]-[rand(1000, 9999)]"
	brainmob.real_name = brainmob.name
	name = "robotic intelligence circuit ([brainmob.name])"

/obj/item/mmi/digital/robot/transfer_identity(var/mob/living/carbon/H)
	..()
	if(brainmob.mind)
		brainmob.mind.assigned_role = JOB_ROBOTIC_INTELLIGENCE
	to_chat(brainmob, span_notify("You feel slightly disoriented. That's normal when you're little more than a complex circuit."))
	return

/obj/item/mmi/digital/robot/attack_self(mob/user)
	return //This object is technically a brain, and should not be dumping brains out of itself like its parent object does.
