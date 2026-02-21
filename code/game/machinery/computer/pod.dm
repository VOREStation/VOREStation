//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/obj/machinery/computer/pod
	name = "pod launch control console"
	desc = "A control console for launching pods. Some people prefer firing Mechas."
	icon_screen = "mass_driver"
	light_color = "#00b000"
	circuit = /obj/item/circuitboard/pod
	var/id = 1.0
	var/obj/machinery/mass_driver/connected = null
	var/timing = FALSE
	var/time = 30.0
	var/title = "Mass Driver Controls"

/obj/machinery/computer/pod/Initialize(mapload)
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/computer/pod/LateInitialize()
	for(var/obj/machinery/mass_driver/M in GLOB.machines)
		if(M.id == id)
			connected = M
			break

/obj/machinery/computer/pod/proc/alarm()
	if(stat & (NOPOWER|BROKEN))
		return

	if(!( connected ))
		to_chat(viewers(null, null),"Cannot locate mass driver connector. Cancelling firing sequence!")
		return

	for(var/obj/machinery/door/blast/M in GLOB.machines)
		if(M.id == id)
			M.open()

	sleep(20)

	for(var/obj/machinery/mass_driver/M in GLOB.machines)
		if(M.id == id)
			M.power = connected.power
			M.drive()

	sleep(50)
	for(var/obj/machinery/door/blast/M in GLOB.machines)
		if(M.id == id)
			M.close()
			return
	return

/*
/obj/machinery/computer/pod/attackby(I as obj, user as mob)
	if(I.has_tool_quality(TOOL_SCREWDRIVER))
		playsound(src, W.usesound, 50, 1)
		if(do_after(user, 2 SECONDS, target = src))
			if(stat & BROKEN)
				to_chat(user, span_notice("The broken glass falls out."))
				var/obj/structure/computerframe/A = new /obj/structure/computerframe( loc )
				new /obj/item/material/shard( loc )

				//generate appropriate circuitboard. Accounts for /pod/old computer types
				var/obj/item/circuitboard/pod/M = null
				if(istype(src, /obj/machinery/computer/pod/old))
					M = new /obj/item/circuitboard/olddoor( A )
					if(istype(src, /obj/machinery/computer/pod/old/syndicate))
						M = new /obj/item/circuitboard/syndicatedoor( A )
					if(istype(src, /obj/machinery/computer/pod/old/swf))
						M = new /obj/item/circuitboard/swfdoor( A )
				else //it's not an old computer. Generate standard pod circuitboard.
					M = new /obj/item/circuitboard/pod( A )

				for (var/obj/C in src)
					C.loc = loc
				M.id = id
				A.circuit = M
				A.state = 3
				A.icon_state = "3"
				A.anchored = TRUE
				qdel(src)
			else
				to_chat(to_chat(user, span_notice("You disconnect the monitor.")))
				var/obj/structure/computerframe/A = new /obj/structure/computerframe( loc )

				//generate appropriate circuitboard. Accounts for /pod/old computer types
				var/obj/item/circuitboard/pod/M = null
				if(istype(src, /obj/machinery/computer/pod/old))
					M = new /obj/item/circuitboard/olddoor( A )
					if(istype(src, /obj/machinery/computer/pod/old/syndicate))
						M = new /obj/item/circuitboard/syndicatedoor( A )
					if(istype(src, /obj/machinery/computer/pod/old/swf))
						M = new /obj/item/circuitboard/swfdoor( A )
				else //it's not an old computer. Generate standard pod circuitboard.
					M = new /obj/item/circuitboard/pod( A )

				for (var/obj/C in src)
					C.loc = loc
				M.id = id
				A.circuit = M
				A.state = 4
				A.icon_state = "4"
				A.anchored = TRUE
				qdel(src)
	else
		attack_hand(user)
	return
*/


/obj/machinery/computer/pod/attack_ai(var/mob/user as mob)
	return attack_hand(user)

/obj/machinery/computer/pod/attack_hand(var/mob/user as mob)
	. = ..()
	if(.)
		return
	if(!Adjacent(user) && !issilicon(user))
		return
	tgui_interact(user)

/obj/machinery/computer/pod/tgui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui, custom_state)
	. = ..()

	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "PodComputer", title)
		ui.open()

/obj/machinery/computer/pod/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)

	return list(
		"connected" = connected,
		"timing" = timing,
		"time" = time,
		"power_level" = connected?.power
	)

/obj/machinery/computer/pod/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("toggle_door")
			for(var/obj/machinery/door/blast/M in GLOB.machines)
				if(M.id == id)
					if(M.density)
						M.open()
					else
						M.close()
			return TRUE
		if("start_stop")
			timing = !timing
			return TRUE
		if("test_alarm")
			alarm()
			return TRUE
		if("test_drive")
			for(var/obj/machinery/mass_driver/M in GLOB.machines)
				if(M.id == id)
					M.power = connected.power
					M.drive()
			return TRUE
		if("adjust_power")
			if(!connected)
				return FALSE
			connected.power = CLAMP(text2num(params["value"]), 0.25, 16)
			return TRUE
		if("adjust_time")
			time = CLAMP(round(text2num(params["value"])), 0, 120)
			return TRUE

/obj/machinery/computer/pod/process()
	if(!..())
		return
	if(timing)
		if(time > 0)
			time = round(time) - 1
		else
			alarm()
			time = 0
			timing = FALSE
	return

/obj/machinery/computer/pod/old
	icon_state = "oldcomp"
	icon_keyboard = null
	icon_screen = "library"
	name = "DoorMex Control Computer"
	title = "Door Controls"

/obj/machinery/computer/pod/old/syndicate
	name = "ProComp Executive IIc"
	desc = "Criminals often operate on a tight budget. Operates external airlocks."
	title = "External Airlock Controls"
	req_access = list(ACCESS_SYNDICATE)

/obj/machinery/computer/pod/old/syndicate/attack_hand(var/mob/user as mob)
	if(!allowed(user))
		to_chat(user, span_warning("Access Denied"))
		return
	else
		..()

/obj/machinery/computer/pod/old/swf
	name = "Magix System IV"
	desc = "An arcane artifact that holds much magic. Running E-Knock 2.2: Sorceror's Edition"
