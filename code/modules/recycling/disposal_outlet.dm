// the disposal outlet machine
/obj/structure/disposaloutlet
	name = "disposal outlet"
	desc = "An outlet for the pneumatic disposal system."
	icon = 'icons/obj/pipes/disposal.dmi'
	icon_state = "outlet"
	density = TRUE
	anchored = TRUE
	var/active = 0
	var/mode = 0

/obj/structure/disposaloutlet/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/disposal_system_connection/disposaloutlet) // Special subtype for directional tossing and it's animation/buzzer

/obj/structure/disposaloutlet/attackby(obj/item/I, mob/user)
	if(!I || !user)
		return
	src.add_fingerprint(user)
	if(I.has_tool_quality(TOOL_SCREWDRIVER))
		if(mode==0)
			mode=1
			to_chat(user, "You remove the screws around the power connection.")
			playsound(src, I.usesound, 50, 1)
			return
		else if(mode==1)
			mode=0
			to_chat(user, "You attach the screws around the power connection.")
			playsound(src, I.usesound, 50, 1)
			return
	else if(I.has_tool_quality(TOOL_WELDER) && mode==1)
		var/obj/item/weldingtool/W = I.get_welder()
		if(W.remove_fuel(0,user))
			playsound(src, W.usesound, 100, 1)
			to_chat(user, "You start slicing the floorweld off the disposal outlet.")
			if(do_after(user, 2 SECONDS * W.toolspeed, target = src))
				if(!src || !W.isOn()) return
				to_chat(user, "You sliced the floorweld off the disposal outlet.")
				var/obj/structure/disposalconstruct/C = new (src.loc)
				src.transfer_fingerprints_to(C)
				C.ptype = 7 // 7 =  outlet
				C.update()
				C.anchored = TRUE
				C.density = TRUE
				qdel(src)
			return
		else
			to_chat(user, "You need more welding fuel to complete this task.")
			return
