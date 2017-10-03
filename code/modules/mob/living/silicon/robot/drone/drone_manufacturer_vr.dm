/obj/machinery/drone_fabricator/MouseDrop_T(mob/living/silicon/robot/drone/target, mob/user)
	if(!istype(target))
		return
	if(user.incapacitated(INCAPACITATION_ALL))
		return
	if(stat & NOPOWER || !produce_drones)
		return
	visible_message("<span class='notice'>[user==target?"\The [user] starts climbing":"\The [user] starts putting \the [target]"] into \the [src]s return chute.</span>")
	if(!do_mob(user, target, 30))
		return
	to_chat(target, "<span class='notice'>You enter \the [src]s drone return chute and shut down.</span>")
	if(drone_progress<99)
		drone_progress = 100
		visible_message("\The [src] voices a strident beep, indicating a drone chassis is prepared.")
	qdel(target)