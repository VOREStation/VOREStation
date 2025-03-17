// concept borrowed from vgstation-coders/vgstation13#26316 on GitHub
/obj/item/mecha_parts/mecha_equipment/runningboard
	name = "hacked powered exosuit running board"
	desc = "A running board with a power-lifter attachment, to quickly catapult exosuit pilots into the cockpit. Fits any exosuit."
	icon_state = "mecha_runningboard"
	origin_tech = list(TECH_MATERIAL = 6)
	equip_type = EQUIP_HULL

/obj/item/mecha_parts/mecha_equipment/runningboard/limited
	name = "powered exosuit running board"
	desc = "A running board with a power-lifter attachment, to quickly catapult exosuit pilots into the cockpit. Only fits to working exosuits."

/obj/item/mecha_parts/mecha_equipment/runningboard/limited/can_attach(obj/mecha/M)
	if(istype(M, /obj/mecha/working)) // is this a ripley?
		. = ..()
	else
		return FALSE
