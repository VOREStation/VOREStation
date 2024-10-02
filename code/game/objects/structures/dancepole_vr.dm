//Dance pole
/obj/structure/dancepole
	name = "dance pole"
	desc = "Engineered for your entertainment"
	icon = 'icons/obj/casino.dmi'
	icon_state = "dance_pole"
	density = FALSE
	anchored = TRUE
	density = 0

/obj/structure/dancepole/attack_hand(mob/user)
	dance(user)
	user.spin(32,2)
	..()

/obj/structure/dancepole/proc/dance(mob/user)
	if(layer == BELOW_MOB_LAYER)
		layer = ABOVE_MOB_LAYER
	else
		layer = BELOW_MOB_LAYER

/obj/structure/dancepole/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(O.has_tool_quality(TOOL_SCREWDRIVER))
		anchored = !anchored
		playsound(src, O.usesound, 50, 1)
		if(anchored)
			to_chat(user, span_blue("You secure \the [src]."))
		else
			to_chat(user, span_blue("You unsecure \the [src]."))
	if(O.has_tool_quality(TOOL_WRENCH))
		playsound(src, O.usesound, 50, 1)
		to_chat(user, span_notice("Now disassembling \the [src]..."))
		if(do_after(user, 30 * O.toolspeed))
			if(!src) return
			to_chat(user, span_notice("You dissasembled \the [src]!"))
			new /obj/item/stack/material/steel(src.loc, 1)
			qdel(src)
