#define OUTLET_SCREWED 0
#define OUTLET_UNSCREWED 1

// the disposal outlet machine
/obj/structure/disposaloutlet
	name = "disposal outlet"
	desc = "An outlet for the pneumatic disposal system."
	icon = 'icons/obj/pipes/disposal.dmi'
	icon_state = "outlet"
	density = TRUE
	anchored = TRUE
	var/active = FALSE // Code appendix.
	var/turf/target // this will be where the output objects are 'thrown' to.
	var/mode = 0
	var/start_eject = 0
	var/eject_range = 3 //Did you know, in TGcode, it's a default of 2 tiles?

/obj/structure/disposaloutlet/Initialize(mapload)
	. = ..()

	target = get_ranged_target_turf(src, dir, 10)

	var/obj/structure/disposalpipe/trunk/trunk = locate() in get_turf(src)
	AddComponent(/datum/component/disposal_system_connection)
	RegisterSignal(src, COMSIG_DISPOSAL_RECEIVE, PROC_REF(packet_expel))
	if(trunk)
		SEND_SIGNAL(src, COMSIG_DISPOSAL_LINK, trunk)

/obj/structure/disposaloutlet/Destroy()
	target = null
	. = ..()

/obj/structure/disposaloutlet/attackby(obj/item/I, mob/user)
	if(!I || !user)
		return
	src.add_fingerprint(user)
	if(I.has_tool_quality(TOOL_SCREWDRIVER))
		if(mode == OUTLET_SCREWED)
			mode = OUTLET_UNSCREWED
			to_chat(user, "You remove the screws around the power connection.")
			playsound(src, I.usesound, 50, 1)
			return
		else if(mode == OUTLET_UNSCREWED)
			mode = OUTLET_SCREWED
			to_chat(user, "You attach the screws around the power connection.")
			playsound(src, I.usesound, 50, 1)
			return
	if(mode == OUTLET_SCREWED)
		return ..()
	if(I.has_tool_quality(TOOL_WELDER) && mode==1)
		var/obj/item/weldingtool/W = I.get_welder()
		if(!W.isOn())
			to_chat(user, span_warning("Your [W] needs to be on to complete this task."))
		if(W.remove_fuel(0,user))
			playsound(src, W.usesound, 100, 1)
			to_chat(user, "You start slicing the floorweld off the disposal outlet.")
			if(do_after(user, 2 SECONDS * W.toolspeed, target = src))
				if(!src || !W.isOn()) return
				to_chat(user, "You sliced the floorweld off the disposal outlet.")
				SEND_SIGNAL(src, COMSIG_DISPOSAL_UNLINK)
				var/obj/structure/disposalconstruct/C = new (src.loc/*, null, SOUTH, FALSE, src*/)
				src.transfer_fingerprints_to(C)
				C.set_dir(dir)
				C.ptype = 7 // 7 =  outlet
				C.update()
				C.anchored = TRUE
				C.density = TRUE
				qdel(src)
			return
		else
			to_chat(user, "You need more welding fuel to complete this task.")
			return
	else if(I.has_tool_quality(TOOL_MULTITOOL))
		var/new_range = tgui_input_number(user, "Input a new ejection distance", "Set ejection strength", 3 , 5, 1, round_value = TRUE)
		eject_range = new_range
		to_chat(user, span_notice("You set the range on the [src] to [new_range] tiles."))

/obj/structure/disposaloutlet/proc/packet_expel(datum/source, list/received_items, datum/gas_mixture/gas)
	SIGNAL_HANDLER

	flick("outlet-open", src)
	if((start_eject + 30) < world.time)
		start_eject = world.time
		playsound(src, 'sound/machines/warning-buzzer.ogg', 50, 0, 0)
		addtimer(CALLBACK(src, PROC_REF(expel_contents), received_items, gas, TRUE), 2 SECONDS)
	else
		addtimer(CALLBACK(src, PROC_REF(expel_contents), received_items, gas), 2 SECONDS)

/obj/structure/disposaloutlet/proc/expel_contents(list/ejected_items, datum/gas_mixture/gas, playsound = FALSE)
	if(playsound)
		playsound(src, 'sound/machines/hiss.ogg', 50, 0, 0)

	var/turf/T = get_turf(src)

	for(var/atom/movable/AM in ejected_items)
		AM.forceMove(T)
		AM.pipe_eject(dir)
		AM.throw_at(target, eject_range, 1)

	T.assume_air(gas)

#undef OUTLET_SCREWED
#undef OUTLET_UNSCREWED
