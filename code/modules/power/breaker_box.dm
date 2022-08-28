// Updated version of old powerswitch by Atlantis
// Has better texture, and is now considered electronic device
// AI has ability to toggle it in 5 seconds
// Humans need 30 seconds (AI is faster when it comes to complex electronics)
// Used for advanced grid control (read: Substations)

/obj/machinery/power/breakerbox
	name = "Breaker Box"
	desc = "Large machine with heavy duty switching circuits used for advanced grid control."
	icon = 'icons/obj/power.dmi'
	icon_state = "bbox_off"
	//directwired = 0
	var/icon_state_on = "bbox_on"
	var/icon_state_off = "bbox_off"
	density = TRUE
	anchored = TRUE
	unacidable = TRUE
	circuit = /obj/item/weapon/circuitboard/breakerbox
	var/on = 0
	var/busy = 0
	var/directions = list(1,2,4,8,5,6,9,10)
	var/RCon_tag = "NO_TAG"
	var/update_locked = 0

/obj/machinery/power/breakerbox/Destroy()
	for(var/obj/structure/cable/C in src.loc)
		qdel(C)
	. = ..()
	for(var/datum/tgui_module/rcon/R in world)
		R.FindDevices()

/obj/machinery/power/breakerbox/Initialize()
	. = ..()
	default_apply_parts()

/obj/machinery/power/breakerbox/activated
	icon_state = "bbox_on"

// Enabled on server startup. Used in substations to keep them in bypass mode.
/obj/machinery/power/breakerbox/activated/Initialize()
<<<<<<< HEAD
	. = ..()
	return INITIALIZE_HINT_LATELOAD
		
/obj/machinery/power/breakerbox/activated/LateInitialize()
=======
	..()
	return INITIALIZE_HINT_LATELOAD // Lateload due to problems with powernet initialization and ordering

/obj/machinery/power/breakerbox/activated/LateInitialize()
	..()
>>>>>>> 59bcd710205... Merge pull request #8692 from MistakeNot4892/breaker
	set_state(1)

/obj/machinery/power/breakerbox/examine(mob/user)
	. = ..()
	if(on)
		. += "<span class='notice'>It seems to be online.</span>"
	else
		. += "<span class='warning'>It seems to be offline.</span>"

/obj/machinery/power/breakerbox/attack_ai(mob/user)
	if(update_locked)
		to_chat(user, "<font color='red'>System locked. Please try again later.</font>")
		return

	if(busy)
		to_chat(user, "<font color='red'>System is busy. Please wait until current operation is finished before changing power settings.</font>")
		return

	busy = 1
	to_chat(user, "<font color='green'>Updating power settings...</font>")
	if(do_after(user, 50))
		set_state(!on)
		to_chat(user, "<font color='green'>Update Completed. New setting:[on ? "on": "off"]</font>")
		update_locked = 1
		spawn(600)
			update_locked = 0
	busy = 0


/obj/machinery/power/breakerbox/attack_hand(mob/user)
	if(update_locked)
		to_chat(user, "<font color='red'>System locked. Please try again later.</font>")
		return

	if(busy)
		to_chat(user, "<font color='red'>System is busy. Please wait until current operation is finished before changing power settings.</font>")
		return

	busy = 1
	for(var/mob/O in viewers(user))
		O.show_message(text("<font color='red'>[user] started reprogramming [src]!</font>"), 1)

	if(do_after(user, 50))
		set_state(!on)
		user.visible_message(\
		"<span class='notice'>[user.name] [on ? "enabled" : "disabled"] the breaker box!</span>",\
		"<span class='notice'>You [on ? "enabled" : "disabled"] the breaker box!</span>")
		update_locked = 1
		spawn(600)
			update_locked = 0
	busy = 0

/obj/machinery/power/breakerbox/attackby(var/obj/item/weapon/W as obj, var/mob/user as mob)
	if(istype(W, /obj/item/device/multitool))
		var/newtag = tgui_input_text(user, "Enter new RCON tag. Use \"NO_TAG\" to disable RCON or leave empty to cancel.", "SMES RCON system")
		if(newtag)
			RCon_tag = newtag
			to_chat(user, "<span class='notice'>You changed the RCON tag to: [newtag]</span>")
	if(on)
		to_chat(user, "<font color='red'>Disable the breaker before performing maintenance.</font>")
		return
	if(default_deconstruction_screwdriver(user, W))
		return
	if(default_deconstruction_crowbar(user, W))
		return
	if(default_part_replacement(user, W))
		return

/obj/machinery/power/breakerbox/proc/set_state(var/state)
	on = state
	if(on)
		icon_state = icon_state_on
		var/list/connection_dirs = list()
		for(var/direction in directions)
			for(var/obj/structure/cable/C in get_step(src,direction))
				if(C.d1 == turn(direction, 180) || C.d2 == turn(direction, 180))
					connection_dirs += direction
					break

		for(var/direction in connection_dirs)
			var/obj/structure/cable/C = new/obj/structure/cable(src.loc)
			C.d1 = 0
			C.d2 = direction
			C.icon_state = "[C.d1]-[C.d2]"
			C.breaker_box = src

			var/datum/powernet/PN = new()
			PN.add_cable(C)

			C.mergeConnectedNetworks(C.d2)
			C.mergeConnectedNetworksOnTurf()

			if(C.d2 & (C.d2 - 1))// if the cable is layed diagonally, check the others 2 possible directions
				C.mergeDiagonalsNetworks(C.d2)

	else
		icon_state = icon_state_off
		for(var/obj/structure/cable/C in src.loc)
			qdel(C)

// Used by RCON to toggle the breaker box.
/obj/machinery/power/breakerbox/proc/auto_toggle()
	if(!update_locked)
		set_state(!on)
		update_locked = 1
		spawn(600)
			update_locked = 0

/obj/machinery/power/breakerbox/process()
	return 1
