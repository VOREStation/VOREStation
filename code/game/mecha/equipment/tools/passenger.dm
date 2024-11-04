/obj/item/mecha_parts/mecha_equipment/tool/passenger
	name = "passenger compartment"
	desc = "A mountable passenger compartment for exosuits. Rather cramped."
	icon_state = "mecha_passenger"
	origin_tech = list(TECH_ENGINEERING = 1, TECH_BIO = 1)
	energy_drain = 10
	range = MELEE
	equip_cooldown = 20
	var/mob/living/carbon/occupant = null
	var/door_locked = 1
	salvageable = 0
	allow_duplicate = TRUE

	equip_type = EQUIP_HULL

/obj/item/mecha_parts/mecha_equipment/tool/passenger/destroy()
	for(var/atom/movable/AM in src)
		AM.forceMove(get_turf(src))
		to_chat(AM, span_danger("You tumble out of the destroyed [src.name]!"))
	return ..()

/obj/item/mecha_parts/mecha_equipment/tool/passenger/Exit(atom/movable/O)
	return 0

/obj/item/mecha_parts/mecha_equipment/tool/passenger/proc/move_inside(var/mob/user)
	if (chassis)
		chassis.visible_message(span_notice("[user] starts to climb into [chassis]."))

	if(do_after(user, 40, needhand=0))
		if(!src.occupant)
			user.forceMove(src)
			occupant = user
			log_message("[user] boarded.")
			occupant_message("[user] boarded.")
		else if(src.occupant != user)
			to_chat(user, span_warning("[src.occupant] was faster. Try harder next time, loser."))
	else
		to_chat(user, span_info("You stop entering the exosuit."))

/obj/item/mecha_parts/mecha_equipment/tool/passenger/container_resist(var/mob/living)
	if(occupant == living)
		eject()

/obj/item/mecha_parts/mecha_equipment/tool/passenger/verb/eject()
	set name = "Eject"
	set category = "Exosuit Interface"
	set src = usr.loc
	set popup_menu = 0

	if(usr != occupant)
		return
	if(door_locked)
		to_chat(occupant, span_notice("\The [src] is locked! You begin operating the emergency unlock mechanism. This will take one minute."))
		sleep(600)
		if(!src || !usr || !occupant || (occupant != usr)) //Check if someone's released/replaced/bombed him already
			return
		if(door_locked)
			door_locked = FALSE
			occupant_message("Passenger compartment hatch unlocked.")
			if (chassis)
				chassis.visible_message(span_infoplain("The hatch on \the [chassis] unlocks."), span_hear("You hear something latching."))
	to_chat(occupant, span_info("You climb out from \the [src]."))
	go_out()
	occupant_message("[occupant] disembarked.")
	log_message("[occupant] disembarked.")
	add_fingerprint(usr)

/obj/item/mecha_parts/mecha_equipment/tool/passenger/proc/go_out()
	if(!occupant)
		return
	occupant.forceMove(get_turf(src))
	occupant.reset_view()
	/*
	if(occupant.client)
		occupant.client.eye = occupant.client.mob
		occupant.client.perspective = MOB_PERSPECTIVE
	*/
	occupant = null
	return

/obj/item/mecha_parts/mecha_equipment/tool/passenger/attach()
	..()
	if (chassis)
		chassis.verbs |= /obj/mecha/proc/move_inside_passenger

/obj/item/mecha_parts/mecha_equipment/tool/passenger/detach()
	if(occupant)
		occupant_message("Unable to detach [src] - equipment occupied.")
		return

	var/obj/mecha/M = chassis
	..()
	if (M && !(locate(/obj/item/mecha_parts/mecha_equipment/tool/passenger) in M))
		M.verbs -= /obj/mecha/proc/move_inside_passenger

/obj/item/mecha_parts/mecha_equipment/tool/passenger/get_equip_info()
	return "[..()] <br />[occupant? "\[Occupant: [occupant]\]|" : ""]Exterior Hatch: <a href='?src=\ref[src];toggle_lock=1'>Toggle Lock</a>"

/obj/item/mecha_parts/mecha_equipment/tool/passenger/Topic(href,href_list)
	..()
	if (href_list["toggle_lock"])
		door_locked = !door_locked
		occupant_message("Passenger compartment hatch [door_locked? "locked" : "unlocked"].")
		if (chassis)
			chassis.visible_message("The hatch on \the [chassis] [door_locked? "locks" : "unlocks"].", "You hear something latching.")


#define LOCKED 1
#define OCCUPIED 2

/obj/mecha/proc/move_inside_passenger()
	set category = "Object"
	set name = "Enter Passenger Compartment"
	set src in oview(1)

	//check that usr can climb in
	if (usr.stat || !ishuman(usr))
		return

	if (!usr.Adjacent(src))
		return

	if (!isturf(usr.loc))
		to_chat(usr, span_danger("You can't reach the passenger compartment from here."))
		return

	if(iscarbon(usr))
		var/mob/living/carbon/C = usr
		if(C.handcuffed)
			to_chat(usr, span_danger("Kinda hard to climb in while handcuffed don't you think?"))
			return

	if(isliving(usr))
		var/mob/living/L = usr
		if(L.has_buckled_mobs())
			to_chat(L, span_warning("You have other entities attached to yourself. Remove them first."))
			return

	//search for a valid passenger compartment
	var/feedback = 0 //for nicer user feedback
	for(var/obj/item/mecha_parts/mecha_equipment/tool/passenger/P in src)
		if (P.occupant)
			feedback |= OCCUPIED
			continue
		if (P.door_locked)
			feedback |= LOCKED
			continue

		//found a boardable compartment
		P.move_inside(usr)
		return

	//didn't find anything
	switch (feedback)
		if (OCCUPIED)
			to_chat(usr, span_danger("The passenger compartment is already occupied!"))
		if (LOCKED)
			to_chat(usr, span_warning("The passenger compartment hatch is locked!"))
		if (OCCUPIED|LOCKED)
			to_chat(usr, span_danger("All of the passenger compartments are already occupied or locked!"))
		if (0)
			to_chat(usr, span_warning("\The [src] doesn't have a passenger compartment."))

#undef LOCKED
#undef OCCUPIED
