/*
Overview:
   Used to create objects that need a per step proc call.  Default definition of 'New()'
   stores a reference to src machine in global 'machines list'.  Default definition
   of 'Del' removes reference to src machine in global 'machines list'.

Class Variables:

   power_init_complete (boolean)
      Indicates that we have have registered our static power usage with the area.

   use_power (num)
      current state of auto power use.
      Possible Values:
         USE_POWER_OFF:0 -- no auto power use
         USE_POWER_IDLE:1 -- machine is using power at its idle power level
         USE_POWER_ACTIVE:2 -- machine is using power at its active power level

   active_power_usage (num)
      Value for the amount of power to use when in active power mode

   idle_power_usage (num)
      Value for the amount of power to use when in idle power mode

   power_channel (num)
      What channel to draw from when drawing power for power mode
      Possible Values:
         EQUIP:0 -- Equipment Channel
         LIGHT:2 -- Lighting Channel
         ENVIRON:3 -- Environment Channel

   component_parts (list)
      A list of component parts of machine used by frame based machines.

   panel_open (num)
      Whether the panel is open

   uid (num)
      Unique id of machine across all machines.

   gl_uid (global num)
      Next uid value in sequence

   stat (bitflag)
      Machine status bit flags.
      Possible bit flags:
         BROKEN:1 -- Machine is broken
         NOPOWER:2 -- No power is being supplied to machine.
         POWEROFF:4 -- tbd
         MAINT:8 -- machine is currently under going maintenance.
         EMPED:16 -- temporary broken by EMP pulse

Class Procs:
   New()                     'game/machinery/machine.dm'

   Destroy()                     'game/machinery/machine.dm'

   get_power_usage()            'game/machinery/machinery_power.dm'
      Returns the amount of power this machine uses every SSmachines cycle.
      Default definition uses 'use_power', 'active_power_usage', 'idle_power_usage'

   powered(chan = CURRENT_CHANNEL)         'game/machinery/machinery_power.dm'
      Checks to see if area that contains the object has power available for power
      channel given in 'chan'.

   use_power_oneoff(amount, chan=CURRENT_CHANNEL)   'game/machinery/machinery_power.dm'
      Deducts 'amount' from the power channel 'chan' of the area that contains the object.

   power_change()               'game/machinery/machinery_power.dm'
      Called by the area that contains the object when ever that area under goes a
      power state change (area runs out of power, or area channel is turned off).

   RefreshParts()               'game/machinery/machine.dm'
      Called to refresh the variables in the machine that are contributed to by parts
      contained in the component_parts list. (example: glass and material amounts for
      the autolathe)

      Default definition does nothing.

   assign_uid()               'game/machinery/machine.dm'
      Called by machine to assign a value to the uid variable.

   process()                  'game/machinery/machine.dm'
      Called by the 'master_controller' once per game tick for each machine that is listed in the 'machines' list.


	Compiled by Aygar
*/

/obj/machinery
	name = "machinery"
	icon = 'icons/obj/stationobjs.dmi'
	w_class = ITEMSIZE_NO_CONTAINER
	layer = UNDER_JUNK_LAYER

	var/stat = 0
	var/emagged = 0
	var/use_power = USE_POWER_IDLE
		//0 = dont run the auto
		//1 = run auto, use idle
		//2 = run auto, use active
	var/idle_power_usage = 0
	var/active_power_usage = 0
	var/power_channel = EQUIP //EQUIP, ENVIRON or LIGHT
	var/power_init_complete = FALSE
	var/list/component_parts = null //list of all the parts used to build it, if made from certain kinds of frames.
	var/uid
	var/panel_open = 0
	var/global/gl_uid = 1
	var/clicksound			// sound played on succesful interface. Just put it in the list of vars at the start.
	var/clickvol = 40		// volume
	var/interact_offline = 0 // Can the machine be interacted with while de-powered.
	var/obj/item/weapon/circuitboard/circuit = null

	var/speed_process = FALSE			//If false, SSmachines. If true, SSfastprocess.

/obj/machinery/New(l, d=0)
	..(l)
	if(d)
		set_dir(d)
	if(ispath(circuit))
		circuit = new circuit(src)

/obj/machinery/Initialize(var/mapload)
	. = ..()
	global.machines += src
	if(ispath(circuit))
		circuit = new circuit(src)
	if(!speed_process)
		START_MACHINE_PROCESSING(src)
	else
		START_PROCESSING(SSfastprocess, src)
	if(!mapload)
		power_change()

/obj/machinery/Destroy()
	if(!speed_process)
		STOP_MACHINE_PROCESSING(src)
	else
		STOP_PROCESSING(SSfastprocess, src)
	global.machines -= src
	if(component_parts)
		for(var/atom/A in component_parts)
			if(A.loc == src) // If the components are inside the machine, delete them.
				qdel(A)
			else // Otherwise we assume they were dropped to the ground during deconstruction, and were not removed from the component_parts list by deconstruction code.
				warning("[A] was still in [src]'s component_parts when it was Destroy()'d")
		component_parts.Cut()
		component_parts = null
	if(contents) // The same for contents.
		for(var/atom/A in contents)
			if(ishuman(A))
				var/mob/living/carbon/human/H = A
				H.client.eye = H.client.mob
				H.client.perspective = MOB_PERSPECTIVE
				H.loc = src.loc
			else
				qdel(A)
	return ..()

/obj/machinery/process() // Steady power usage is handled separately. If you dont use process why are you here?
	return PROCESS_KILL

/obj/machinery/emp_act(severity)
	if(use_power && stat == 0)
		use_power(7500/severity)

		var/obj/effect/overlay/pulse2 = new /obj/effect/overlay(src.loc)
		pulse2.icon = 'icons/effects/effects.dmi'
		pulse2.icon_state = "empdisable"
		pulse2.name = "emp sparks"
		pulse2.anchored = 1
		pulse2.set_dir(pick(cardinal))

		spawn(10)
			qdel(pulse2)
	..()

/obj/machinery/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if(prob(50))
				qdel(src)
				return
		if(3.0)
			if(prob(25))
				qdel(src)
				return
		else
	return

/obj/machinery/vv_edit_var(var/var_name, var/new_value)
	if(var_name == NAMEOF(src, use_power))
		update_use_power(new_value)
		return TRUE
	else if(var_name == NAMEOF(src, power_channel))
		update_power_channel(new_value)
		return TRUE
	else if(var_name == NAMEOF(src, idle_power_usage))
		update_idle_power_usage(new_value)
		return TRUE
	else if(var_name == NAMEOF(src, active_power_usage))
		update_active_power_usage(new_value)
		return TRUE
	return ..()

/obj/machinery/proc/operable(var/additional_flags = 0)
	return !inoperable(additional_flags)

/obj/machinery/proc/inoperable(var/additional_flags = 0)
	return (stat & (NOPOWER | BROKEN | additional_flags))

// Duplicate of below because we don't want to fuck around with CanUseTopic in TGUI
// TODO: Replace this with can_interact from /tg/
/obj/machinery/tgui_status(mob/user)
	if(!interact_offline && (stat & (NOPOWER | BROKEN)))
		return STATUS_CLOSE
	return ..()

/obj/machinery/CanUseTopic(var/mob/user)
	if(!interact_offline && (stat & (NOPOWER | BROKEN)))
		return STATUS_CLOSE
	return ..()

/obj/machinery/CouldUseTopic(var/mob/user)
	..()
	user.set_machine(src)

/obj/machinery/CouldNotUseTopic(var/mob/user)
	user.unset_machine()

////////////////////////////////////////////////////////////////////////////////////////////

/obj/machinery/attack_ai(mob/user as mob)
	if(isrobot(user))
		// For some reason attack_robot doesn't work
		// This is to stop robots from using cameras to remotely control machines.
		if(user.client && user.client.eye == user)
			return attack_hand(user)
	else
		return attack_hand(user)

/obj/machinery/attack_hand(mob/user as mob)

	if(inoperable(MAINT))
		return 1
	if(user.lying || user.stat)
		return 1
	if(!user.IsAdvancedToolUser())  //Vorestation edit
		to_chat(user, "<span class='warning'>You don't have the dexterity to do this!</span>")
		return 1
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.getBrainLoss() >= 55)
			visible_message("<span class='warning'>[H] stares cluelessly at [src].</span>")
			return 1
		else if(prob(H.getBrainLoss()))
			to_chat(user, "<span class='warning'>You momentarily forget how to use [src].</span>")
			return 1

	if(clicksound && istype(user, /mob/living/carbon))
		playsound(src, clicksound, clickvol)

	add_fingerprint(user)

	return ..()

/obj/machinery/proc/RefreshParts() //Placeholder proc for machines that are built using frames.
	return

/obj/machinery/proc/assign_uid()
	uid = gl_uid
	gl_uid++

/obj/machinery/proc/state(var/msg)
	for(var/mob/O in hearers(src, null))
		O.show_message("[bicon(src)] <span class = 'notice'>[msg]</span>", 2)

/obj/machinery/proc/ping(text=null)
	if(!text)
		text = "\The [src] pings."

	state(text, "blue")
	playsound(src, 'sound/machines/ping.ogg', 50, 0)

/obj/machinery/proc/shock(mob/user, prb)
	if(inoperable())
		return 0
	if(!prob(prb))
		return 0
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(5, 1, src)
	s.start()
	if(electrocute_mob(user, get_area(src), src, 0.7))
		var/area/temp_area = get_area(src)
		if(temp_area)
			var/obj/machinery/power/apc/temp_apc = temp_area.get_apc()

			if(temp_apc && temp_apc.terminal && temp_apc.terminal.powernet)
				temp_apc.terminal.powernet.trigger_warning()
		if(user.stunned)
			return 1
	return 0

/obj/machinery/proc/default_apply_parts()
	var/obj/item/weapon/circuitboard/CB = circuit
	if(!istype(CB))
		return
	CB.apply_default_parts(src)
	RefreshParts()

/obj/machinery/proc/default_use_hicell()
	var/obj/item/weapon/cell/C = locate(/obj/item/weapon/cell) in component_parts
	if(C)
		component_parts -= C
		qdel(C)
		C = new /obj/item/weapon/cell/high(src)
		component_parts += C
		return C
		RefreshParts()

/obj/machinery/proc/default_part_replacement(var/mob/user, var/obj/item/weapon/storage/part_replacer/R)
	if(!istype(R))
		return 0
	if(!component_parts)
		return 0
	to_chat(user, "<span class='notice'>Following parts detected in [src]:</span>")
	for(var/obj/item/C in component_parts)
		to_chat(user, "<span class='notice'>    [C.name]</span>")
	if(panel_open || !R.panel_req)
		var/obj/item/weapon/circuitboard/CB = circuit
		var/P
		for(var/obj/item/weapon/stock_parts/A in component_parts)
			for(var/T in CB.req_components)
				if(ispath(A.type, T))
					P = T
					break
			for(var/obj/item/weapon/stock_parts/B in R.contents)
				if(istype(B, P) && istype(A, P))
					if(B.rating > A.rating)
						R.remove_from_storage(B, src)
						R.handle_item_insertion(A, 1)
						component_parts -= A
						component_parts += B
						B.loc = null
						to_chat(user, "<span class='notice'>[A.name] replaced with [B.name].</span>")
						break
			update_icon()
			RefreshParts()
	return 1

// Default behavior for wrenching down machines.  Supports both delay and instant modes.
/obj/machinery/proc/default_unfasten_wrench(var/mob/user, var/obj/item/W, var/time = 0)
	if(!W.is_wrench())
		return FALSE
	if(panel_open)
		return FALSE // Close panel first!
	playsound(src, W.usesound, 50, 1)
	var/actual_time = W.toolspeed * time
	if(actual_time != 0)
		user.visible_message( \
			"<span class='warning'>\The [user] begins [anchored ? "un" : ""]securing \the [src].</span>", \
			"<span class='notice'>You start [anchored ? "un" : ""]securing \the [src].</span>")
	if(actual_time == 0 || do_after(user, actual_time, target = src))
		user.visible_message( \
			"<span class='warning'>\The [user] has [anchored ? "un" : ""]secured \the [src].</span>", \
			"<span class='notice'>You [anchored ? "un" : ""]secure \the [src].</span>")
		anchored = !anchored
		power_change() //Turn on or off the machine depending on the status of power in the new area.
		update_icon()
	return TRUE

/obj/machinery/proc/default_deconstruction_crowbar(var/mob/user, var/obj/item/C)
	if(!C.is_crowbar())
		return 0
	if(!panel_open)
		return 0
	. = dismantle()

/obj/machinery/proc/default_deconstruction_screwdriver(var/mob/user, var/obj/item/S)
	if(!S.is_screwdriver())
		return 0
	playsound(src, S.usesound, 50, 1)
	panel_open = !panel_open
	to_chat(user, "<span class='notice'>You [panel_open ? "open" : "close"] the maintenance hatch of [src].</span>")
	update_icon()
	return 1

/obj/machinery/proc/computer_deconstruction_screwdriver(var/mob/user, var/obj/item/S)
	if(!S.is_screwdriver())
		return 0
	if(!circuit)
		return 0
	to_chat(user, "<span class='notice'>You start disconnecting the monitor.</span>")
	playsound(src, S.usesound, 50, 1)
	if(do_after(user, 20 * S.toolspeed))
		if(stat & BROKEN)
			to_chat(user, "<span class='notice'>The broken glass falls out.</span>")
			new /obj/item/weapon/material/shard(src.loc)
		else
			to_chat(user, "<span class='notice'>You disconnect the monitor.</span>")
		. = dismantle()

/obj/machinery/proc/alarm_deconstruction_screwdriver(var/mob/user, var/obj/item/S)
	if(!S.is_screwdriver())
		return 0
	playsound(src, S.usesound, 50, 1)
	panel_open = !panel_open
	to_chat(user, "The wires have been [panel_open ? "exposed" : "unexposed"]")
	update_icon()
	return 1

/obj/machinery/proc/alarm_deconstruction_wirecutters(var/mob/user, var/obj/item/W)
	if(!W.is_wirecutter())
		return 0
	if(!panel_open)
		return 0
	user.visible_message("<span class='warning'>[user] has cut the wires inside \the [src]!</span>", "You have cut the wires inside \the [src].")
	playsound(src, W.usesound, 50, 1)
	new/obj/item/stack/cable_coil(get_turf(src), 5)
	. = dismantle()

/obj/machinery/proc/dismantle()
	playsound(src, 'sound/items/Crowbar.ogg', 50, 1)
	for(var/obj/I in contents)
		if(istype(I,/obj/item/weapon/card/id))
			I.forceMove(src.loc)
	//TFF 3/6/19 - port Cit RP fix of infinite frames. If it doesn't have a circuit board, don't create a frame. Return a smack instead. BONK!
	if(!circuit)
		return 0
	var/obj/structure/frame/A = new /obj/structure/frame(src.loc)
	var/obj/item/weapon/circuitboard/M = circuit
	A.circuit = M
	A.anchored = 1
	A.frame_type = M.board_type
	if(A.frame_type.circuit)
		A.need_circuit = 0

	if(A.frame_type.frame_class == FRAME_CLASS_ALARM || A.frame_type.frame_class == FRAME_CLASS_DISPLAY)
		A.density = 0
	else
		A.density = 1

	if(A.frame_type.frame_class == FRAME_CLASS_MACHINE)
		for(var/obj/D in component_parts)
			D.forceMove(src.loc)
		if(A.components)
			A.components.Cut()
		else
			A.components = list()
		component_parts = list()
		A.check_components()

	if(A.frame_type.frame_class == FRAME_CLASS_ALARM)
		A.state = FRAME_FASTENED
	else if(A.frame_type.frame_class == FRAME_CLASS_COMPUTER || A.frame_type.frame_class == FRAME_CLASS_DISPLAY)
		if(stat & BROKEN)
			A.state = FRAME_WIRED
		else
			A.state = FRAME_PANELED
	else
		A.state = FRAME_WIRED

	A.set_dir(dir)
	A.pixel_x = pixel_x
	A.pixel_y = pixel_y
	A.update_desc()
	A.update_icon()
	M.loc = null
	M.deconstruct(src)
	qdel(src)
	return 1

/datum/proc/apply_visual(mob/M)
	M.sight = 0 //Just reset their mesons and stuff so they can't use them, by default.
	return

/datum/proc/remove_visual(mob/M)
	return
