/obj/machinery/optable
	name = "Operating Table"
	desc = "Used for advanced medical procedures."
	icon = 'icons/obj/surgery_vr.dmi'
	icon_state = "table2-idle"
	density = TRUE
	anchored = TRUE
	unacidable = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 1
	active_power_usage = 5
	surgery_odds = 100
	throwpass = 1
	var/mob/living/carbon/human/victim = null
	var/strapped = 0.0
	var/obj/machinery/computer/operating/computer = null

/obj/machinery/optable/New()
	..()
	for(var/direction in list(NORTH,EAST,SOUTH,WEST))
		computer = locate(/obj/machinery/computer/operating, get_step(src, direction))
		if(computer)
			computer.table = src
			break
//	spawn(100) //Wont the MC just call this process() before and at the 10 second mark anyway?
//		process()

/obj/machinery/optable/ex_act(severity)
	switch(severity)
		if(1.0)
			//SN src = null
			qdel(src)
			return
		if(2.0)
			if(prob(50))
				//SN src = null
				qdel(src)
				return
		if(3.0)
			if(prob(25))
				density = FALSE
	return

/obj/machinery/optable/attack_hand(mob/user as mob)
	if(HULK in user.mutations)
		visible_message(span_danger("\The [user] destroys \the [src]!"))
		density = FALSE
		qdel(src)
	return

/obj/machinery/optable/CanPass(atom/movable/mover, turf/target)
	if(istype(mover) && mover.checkpass(PASSTABLE))
		return TRUE
	return FALSE

/obj/machinery/optable/proc/check_victim()
	if(locate(/mob/living/carbon/human, src.loc))
		var/mob/living/carbon/human/M = locate(/mob/living/carbon/human, src.loc)
		if(M.lying)
			victim = M
			if(M.pulse)
				if(M.stat)
					icon_state = "table2-sleep"
				else
					icon_state = "table2-active"
			else
				icon_state = "table2-dead"
			return 1
	victim = null
	icon_state = "table2-idle"
	return 0

/obj/machinery/optable/process()
	check_victim()

/obj/machinery/optable/proc/take_victim(mob/living/carbon/C, mob/living/carbon/user as mob)
	if(C == user)
		user.visible_message("[user] climbs on \the [src].","You climb on \the [src].")
	else
		visible_message(span_notice("\The [C] has been laid on \the [src] by [user]."))
	if(C.client)
		C.client.perspective = EYE_PERSPECTIVE
		C.client.eye = src
	C.resting = 1
	C.loc = src.loc
	for(var/obj/O in src)
		O.loc = src.loc
	add_fingerprint(user)
	if(ishuman(C))
		var/mob/living/carbon/human/H = C
		victim = H
		icon_state = H.pulse ? "table2-active" : "table2-idle"
	else
		icon_state = "table2-idle"

/obj/machinery/optable/MouseDrop_T(mob/living/carbon/target, mob/living/user)
	if(!istype(target) || !istype(user))
		return ..()

	if(!Adjacent(target) || !Adjacent(user))
		return ..()

	if(user.incapacitated() || !check_table(target, user))
		return ..()

	take_victim(target, user)

/obj/machinery/optable/verb/climb_on()
	set name = "Climb On Table"
	set category = "Object"
	set src in oview(1)

	var/mob/living/user = usr
	if(!istype(user) || user.incapacitated() || !check_table(user, user))
		return

	take_victim(user, user)

/obj/machinery/optable/attackby(obj/item/W, mob/living/carbon/user)
	if(istype(W, /obj/item/grab))
		var/obj/item/grab/G = W
		if(iscarbon(G.affecting) && check_table(G.affecting, user))
			take_victim(G.affecting, user)
			qdel(W)
			return

/obj/machinery/optable/proc/check_table(mob/living/carbon/patient, mob/living/user)
	check_victim()
	if(victim && get_turf(victim) == get_turf(src) && victim.lying)
		to_chat(user, span_warning("\The [src] is already occupied!"))
		return 0
	if(patient.buckled)
		to_chat(user, span_notice("Unbuckle \the [patient] first!"))
		return 0
	return 1
