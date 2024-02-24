/obj/structure/plasticflaps //HOW DO YOU CALL THOSE THINGS ANYWAY
	name = "\improper plastic flaps"
	desc = "Completely impassable - or are they?"
	icon = 'icons/obj/stationobjs.dmi' //Change this.
	icon_state = "plasticflaps"
	density = FALSE
	anchored = TRUE
	layer = MOB_LAYER
	plane = MOB_PLANE
	explosion_resistance = 5
	var/can_pass_lying = TRUE
	var/list/mobs_can_pass = list(
		/mob/living/bot,
		/mob/living/simple_mob/slime/xenobio,
		/mob/living/simple_mob/animal/passive/mouse,
		/mob/living/silicon/robot/drone
		)

/obj/structure/plasticflaps/attackby(obj/item/P, mob/user)
	if(P.has_tool_quality(TOOL_WIRECUTTER))
		playsound(src, P.usesound, 50, 1)
		to_chat(user, "<span class='notice'>You start to cut the plastic flaps.</span>")
		if(do_after(user, 10 * P.toolspeed))
			to_chat(user, "<span class='notice'>You cut the plastic flaps.</span>")
			new /obj/item/stack/material/plastic(src.loc, 4)
			qdel(src)
		return
	else
		return

/obj/structure/plasticflaps/CanPass(atom/A, turf/T)
	if(istype(A) && A.checkpass(PASSGLASS))
		return prob(60)

	var/obj/structure/bed/B = A
	if (istype(A, /obj/structure/bed) && B.has_buckled_mobs())//if it's a bed/chair and someone is buckled, it will not pass
		return 0

	if(istype(A, /obj/vehicle) || istype (A, /obj/mecha)) //no vehicles
		return 0

	var/mob/living/M = A
	if(istype(M))
		if(M.lying && can_pass_lying)
			return ..()
		for(var/mob_type in mobs_can_pass)
			if(istype(A, mob_type))
				return ..()
		return issmall(M)

	return ..()

/obj/structure/plasticflaps/ex_act(severity)
	switch(severity)
		if (1)
			qdel(src)
		if (2)
			if (prob(50))
				qdel(src)
		if (3)
			if (prob(5))
				qdel(src)

/obj/structure/plasticflaps/mining //A specific type for mining that doesn't allow airflow because of them damn crates
	name = "airtight plastic flaps"
	desc = "Heavy duty, airtight, plastic flaps. Have extra safety installed, preventing passage of living beings."
	can_atmos_pass = ATMOS_PASS_NO
	can_pass_lying = FALSE