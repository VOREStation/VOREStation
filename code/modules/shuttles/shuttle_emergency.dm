// Formerly /datum/shuttle/ferry/emergency
/datum/shuttle/autodock/ferry/emergency
	category = /datum/shuttle/autodock/ferry/emergency

/datum/shuttle/autodock/ferry/emergency/New()
	..()
	if(emergency_shuttle.shuttle)
		CRASH("An emergency shuttle has already been defined.")
	emergency_shuttle.shuttle = src

/datum/shuttle/autodock/ferry/emergency/arrived()
	. = ..()
	if (istype(in_use, /obj/machinery/computer/shuttle_control/emergency))
		var/obj/machinery/computer/shuttle_control/emergency/C = in_use
		C.reset_authorization()

	emergency_shuttle.shuttle_arrived()

/datum/shuttle/autodock/ferry/emergency/long_jump(var/destination, var/interim, var/travel_time)
	if (!location)
		travel_time = SHUTTLE_TRANSIT_DURATION_RETURN
	else
		travel_time = SHUTTLE_TRANSIT_DURATION

	//update move_time and launch_time so we get correct ETAs
	move_time = travel_time
	emergency_shuttle.launch_time = world.time

	..(destination, interim, travel_time, direction)

/datum/shuttle/autodock/ferry/emergency/perform_shuttle_move()
	if (current_location == landmark_station)	//leaving the station
		spawn(0)
			emergency_shuttle.departed = 1
			var/estimated_time = round(emergency_shuttle.estimate_arrival_time()/60,1)

			if (emergency_shuttle.evac)
				priority_announcement.Announce(replacetext(replacetext(using_map.emergency_shuttle_leaving_dock, "%dock_name%", "[using_map.dock_name]"),  "%ETA%", "[estimated_time] minute\s"))
			else
				priority_announcement.Announce(replacetext(replacetext(using_map.shuttle_leaving_dock, "%dock_name%", "[using_map.dock_name]"),  "%ETA%", "[estimated_time] minute\s"), "Transfer System", 'sound/AI/tramdepart.ogg')
	..()

/datum/shuttle/autodock/ferry/emergency/can_launch(var/user)
	if (istype(user, /obj/machinery/computer/shuttle_control/emergency))
		var/obj/machinery/computer/shuttle_control/emergency/C = user
		if (!C.has_authorization())
			return 0
	return ..()

/datum/shuttle/autodock/ferry/emergency/can_force(var/user)
	if (istype(user, /obj/machinery/computer/shuttle_control/emergency))
		var/obj/machinery/computer/shuttle_control/emergency/C = user

		//Initiating or cancelling a launch ALWAYS requires authorization, but if we are already set to launch anyways than forcing does not.
		//This is so that people can force launch if the docking controller cannot safely undock without needing X heads to swipe.
		if (!(process_state == WAIT_LAUNCH || C.has_authorization()))
			return 0
	return ..()

/datum/shuttle/autodock/ferry/emergency/can_cancel(var/user)
	if (istype(user, /obj/machinery/computer/shuttle_control/emergency))
		var/obj/machinery/computer/shuttle_control/emergency/C = user
		if (!C.has_authorization())
			return 0
	return ..()

/datum/shuttle/autodock/ferry/emergency/launch(var/user)
	if (!can_launch(user)) return

	if (istype(user, /obj/machinery/computer/shuttle_control/emergency))	//if we were given a command by an emergency shuttle console
		if (emergency_shuttle.autopilot)
			emergency_shuttle.autopilot = 0
			to_world(span_boldnotice("Alert: The shuttle autopilot has been overridden. Launch sequence initiated!"))

	if(usr)
		log_admin("[key_name(usr)] has overridden the departure shuttle's autopilot and activated the launch sequence.")
		message_admins("[key_name_admin(usr)] has overridden the departure shuttle's autopilot and activated the launch sequence.")

	..(user)

/datum/shuttle/autodock/ferry/emergency/force_launch(var/user)
	if (!can_force(user)) return

	if (istype(user, /obj/machinery/computer/shuttle_control/emergency))	//if we were given a command by an emergency shuttle console
		if (emergency_shuttle.autopilot)
			emergency_shuttle.autopilot = 0
			to_world(span_boldnotice("Alert: The shuttle autopilot has been overridden. Bluespace drive engaged!"))

	if(usr)
		log_admin("[key_name(usr)] has overridden the departure shuttle's autopilot and forced immediate launch.")
		message_admins("[key_name_admin(usr)] has overridden the departure shuttle's autopilot and forced immediate launch.")

	..(user)

/datum/shuttle/autodock/ferry/emergency/cancel_launch(var/user)
	if (!can_cancel(user)) return

	if (istype(user, /obj/machinery/computer/shuttle_control/emergency))	//if we were given a command by an emergency shuttle console
		if (emergency_shuttle.autopilot)
			emergency_shuttle.autopilot = 0
			to_chat(world, span_boldnotice("Alert: The shuttle autopilot has been overridden. Launch sequence aborted!"))

	if(usr)
		log_admin("[key_name(usr)] has overridden the departure shuttle's autopilot and cancelled the launch sequence.")
		message_admins("[key_name_admin(usr)] has overridden the departure shuttle's autopilot and cancelled the launch sequence.")

	..(user)



/obj/machinery/computer/shuttle_control/emergency
	shuttle_tag = "Escape"
	var/debug = 0
	var/req_authorizations = 2
	var/list/authorized = list()

/obj/machinery/computer/shuttle_control/emergency/proc/has_authorization()
	return (authorized.len >= req_authorizations || emagged)

/obj/machinery/computer/shuttle_control/emergency/proc/reset_authorization()
	//No need to reset emagged status. If they really want to go back to the station they can.
	authorized = initial(authorized)

//returns 1 if the ID was accepted and a new authorization was added, 0 otherwise
/obj/machinery/computer/shuttle_control/emergency/proc/read_authorization(var/obj/item/ident)
	if (!ident || !istype(ident))
		return 0
	if (authorized.len >= req_authorizations)
		return 0	//don't need any more

	var/list/access
	var/auth_name
	var/dna_hash

	var/obj/item/card/id/ID = ident.GetID()

	if(!ID)
		return

	access = ID.GetAccess()
	auth_name = "[ID.registered_name] ([ID.assignment])"
	dna_hash = ID.dna_hash

	if (!access || !istype(access))
		return 0	//not an ID

	if (dna_hash in authorized)
		src.visible_message("\The [src] buzzes. That ID has already been scanned.")
		playsound(src, 'sound/machines/buzz-sigh.ogg', 50, 0)
		return 0

	if (!(access_heads in access))
		src.visible_message("\The [src] buzzes, rejecting [ident].")
		playsound(src, 'sound/machines/deniedbeep.ogg', 50, 0)
		return 0

	src.visible_message("\The [src] beeps as it scans [ident].")
	playsound(src, 'sound/machines/twobeep.ogg', 50, 0)
	authorized[dna_hash] = auth_name
	if (req_authorizations - authorized.len)
		to_chat(world, span_boldnotice("Alert: [req_authorizations - authorized.len] authorization\s needed to override the shuttle autopilot.")) //TODO- Belsima, make this an announcement instead of magic.

	if(usr)
		log_admin("[key_name(usr)] has inserted [ID] into the shuttle control computer - [req_authorizations - authorized.len] authorisation\s needed")
		message_admins("[key_name_admin(usr)] has inserted [ID] into the shuttle control computer - [req_authorizations - authorized.len] authorisation\s needed")

	return 1

/obj/machinery/computer/shuttle_control/emergency/emag_act(var/remaining_charges, var/mob/user)
	if (!emagged)
		to_chat(user, span_notice("You short out \the [src]'s authorization protocols."))
		emagged = 1
		return 1

/obj/machinery/computer/shuttle_control/emergency/attackby(obj/item/W as obj, mob/user as mob)
	read_authorization(W)
	..()
