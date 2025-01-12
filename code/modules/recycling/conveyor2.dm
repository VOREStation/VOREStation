#define OFF 0
#define FORWARDS 1
#define BACKWARDS -1

//conveyor2 is pretty much like the original, except it supports corners, but not diverters.
//note that corner pieces transfer stuff clockwise when running forward, and anti-clockwise backwards.

/obj/machinery/conveyor
	icon = 'icons/obj/recycling.dmi'
	icon_state = "conveyor0"
	name = "conveyor belt"
	desc = "A conveyor belt."
	plane = TURF_PLANE
	layer = ABOVE_TURF_LAYER
	anchored = TRUE
	active_power_usage = 100
	circuit = /obj/item/circuitboard/conveyor
	var/operating = OFF	// 1 if running forward, -1 if backwards, 0 if off
	var/operable = 1	// true if can operate (no broken segments in this belt run)
	var/forwards		// this is the default (forward) direction, set by the map dir
	var/backwards		// hopefully self-explanatory
	var/movedir			// the actual direction to move stuff in

	var/list/affecting	// the list of all items that will be moved this ptick
	var/id = ""			// the control ID	- must match controller ID

/obj/machinery/conveyor/centcom_auto
	id = "round_end_belt"

	// create a conveyor
/obj/machinery/conveyor/Initialize(mapload, newdir, on = 0)
	. = ..()
	if(newdir)
		set_dir(newdir)

	update_dir()

	if(on)
		set_operating(FORWARDS)

	default_apply_parts()

/obj/machinery/conveyor/proc/toggle_speed(var/forced)
	if(forced)
		speed_process = forced
	else
		speed_process = !speed_process // switching gears
	if(speed_process) // high gear
		update_active_power_usage(initial(idle_power_usage) * 4)
	else // low gear
		update_active_power_usage(initial(idle_power_usage))
	update()

/obj/machinery/conveyor/proc/set_operating(var/new_operating)
	if(new_operating == operating)
		return // No change
	operating = new_operating
	if(operating == FORWARDS)
		movedir = forwards
	else if(operating == BACKWARDS)
		movedir = backwards
	else
		operating = OFF
	update()

/obj/machinery/conveyor/set_dir()
	.=..()
	update_dir()

/obj/machinery/conveyor/proc/update_dir()
	if(!(dir in cardinal)) // Diagonal. Forwards is *away* from dir, curving to the right.
		forwards = turn(dir, 45)
		backwards = turn(dir, 135)
	else
		forwards = dir
		backwards = turn(dir, 180)

/obj/machinery/conveyor/proc/update()
	if(stat & BROKEN)
		icon_state = "conveyor-broken"
		operating = OFF
		update_use_power(USE_POWER_OFF)
		return
	if(!operable)
		operating = OFF
	if(stat & NOPOWER)
		operating = OFF
	icon_state = "conveyor[operating]"

	if(!operating)
		update_use_power(USE_POWER_OFF)
		return
	if(speed_process) // high gear
		STOP_MACHINE_PROCESSING(src)
		START_PROCESSING(SSfastprocess, src)
		update_use_power(USE_POWER_ACTIVE)
	else // low gear
		STOP_PROCESSING(SSfastprocess, src)
		START_MACHINE_PROCESSING(src)
		update_use_power(USE_POWER_ACTIVE)

	// machine process
	// move items to the target location
/obj/machinery/conveyor/process()
	if(stat & (BROKEN | NOPOWER))
		return PROCESS_KILL
	if(!operating)
		return PROCESS_KILL

	affecting = loc.contents - src		// moved items will be all in loc
	spawn(1)	// slight delay to prevent infinite propagation due to map order	//TODO: please no spawn() in process(). It's a very bad idea
		var/items_moved = 0
		for(var/atom/movable/A in affecting)
			if(istype(A,/obj/effect/abstract)) // Flashlight's lights are not physical objects
				continue
			if(!A.anchored)
				if(A.loc == src.loc) // prevents the object from being affected if it's not currently here.
					step(A,movedir)
					items_moved++
			if(items_moved >= 10)
				break

// attack with item, place item on conveyor
/obj/machinery/conveyor/attackby(var/obj/item/I, mob/user)
	if(isrobot(user))	return //Carn: fix for borgs dropping their modules on conveyor belts
	if(I.loc != user)	return // This should stop mounted modules ending up outside the module.

	if(default_deconstruction_screwdriver(user, I))
		return
	if(default_deconstruction_crowbar(user, I))
		return

	if(istype(I, /obj/item/multitool))
		if(panel_open)
			var/input = sanitize(tgui_input_text(user, "What id would you like to give this conveyor?", "Multitool-Conveyor interface", id))
			if(!input)
				to_chat(user, "No input found. Please hang up and try your call again.")
				return
			id = input
			for(var/obj/machinery/conveyor_switch/C in machines)
				if(C.id == id)
					C.conveyors |= src
			return

	user.drop_item(get_turf(src))
	return

// attack with hand, move pulled object onto conveyor
/obj/machinery/conveyor/attack_hand(mob/user as mob)
	if ((!( user.canmove ) || user.restrained() || !( user.pulling )))
		return
	if (user.pulling.anchored)
		return
	if ((user.pulling.loc != user.loc && get_dist(user, user.pulling) > 1))
		return
	if (ismob(user.pulling))
		var/mob/M = user.pulling
		M.stop_pulling()
		step(user.pulling, get_dir(user.pulling.loc, src))
		user.stop_pulling()
	else
		step(user.pulling, get_dir(user.pulling.loc, src))
		user.stop_pulling()
	return


// make the conveyor broken
// also propagate inoperability to any connected conveyor with the same ID
/obj/machinery/conveyor/proc/broken()
	stat |= BROKEN
	update()

	var/obj/machinery/conveyor/C = locate() in get_step(src, dir)
	if(C)
		C.set_operable(dir, id, 0)

	C = locate() in get_step(src, turn(dir,180))
	if(C)
		C.set_operable(turn(dir,180), id, 0)


//set the operable var if ID matches, propagating in the given direction

/obj/machinery/conveyor/proc/set_operable(stepdir, match_id, op)

	if(id != match_id)
		return
	operable = op

	update()
	var/obj/machinery/conveyor/C = locate() in get_step(src, stepdir)
	if(C)
		C.set_operable(stepdir, id, op)

/obj/machinery/conveyor/power_change()
	if((. = ..()))
		update()

#undef OFF
#undef FORWARDS
#undef BACKWARDS

// the conveyor control switch
//
//

/obj/machinery/conveyor_switch

	name = "conveyor switch"
	desc = "A conveyor control switch."
	icon = 'icons/obj/recycling.dmi'
	icon_state = "switch-off"
	var/position = 0			// 0 off, -1 reverse, 1 forward
	var/last_pos = -1			// last direction setting
	var/operated = 1			// true if just operated
	var/oneway = 0				// Voreadd: One way levels mid-round!

	var/id = "" 				// must match conveyor IDs to control them

	var/list/conveyors		// the list of converyors that are controlled by this switch
	anchored = TRUE
	var/speed_active = FALSE // are the linked conveyors on SSfastprocess?



/obj/machinery/conveyor_switch/Initialize()
	..()
	update()
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/conveyor_switch/LateInitialize()
	conveyors = list()
	for(var/obj/machinery/conveyor/C in machines)
		if(C.id == id)
			conveyors += C

/obj/machinery/conveyor_switch/proc/toggle_speed(var/forced)
	speed_active = !speed_active // switching gears
	if(speed_active) // high gear
		for(var/obj/machinery/conveyor/C in conveyors)
			C.toggle_speed(TRUE)
	else // low gear
		for(var/obj/machinery/conveyor/C in conveyors)
			C.toggle_speed(FALSE)

// update the icon depending on the position

/obj/machinery/conveyor_switch/proc/update()
	if(position<0)
		icon_state = "switch-rev"
	else if(position>0)
		icon_state = "switch-fwd"
	else
		icon_state = "switch-off"


// timed process
// if the switch changed, update the linked conveyors

/obj/machinery/conveyor_switch/process()
	if(!operated)
		return
	operated = 0

	for(var/obj/machinery/conveyor/C in conveyors)
		C.set_operating(position)

// attack with hand, switch position
/obj/machinery/conveyor_switch/attack_hand(mob/user)
	if(!allowed(user))
		to_chat(user, span_warning("Access denied."))
		return

	if(position == 0)
		if(last_pos < 0 || oneway == 1)
			position = 1
			last_pos = 0
		else
			position = -1
			last_pos = 0
	else
		last_pos = position
		position = 0

	operated = 1
	update()

	// find any switches with same id as this one, and set their positions to match us
	for(var/obj/machinery/conveyor_switch/S in machines)
		if(S.id == src.id)
			S.position = position
			S.update()

/obj/machinery/conveyor_switch/attackby(var/obj/item/I, mob/user)
	if(default_deconstruction_screwdriver(user, I))
		return

	if(!panel_open) //It's probably better to just check this once instead of each time
		return

	if(I.has_tool_quality(TOOL_WELDER))
		var/obj/item/weldingtool/WT = I.get_welder()
		if(!WT.remove_fuel(0, user))
			to_chat(user, "The welding tool must be on to complete this task.")
			return
		playsound(src, WT.usesound, 50, 1)
		if(do_after(user, 20 * WT.toolspeed))
			if(!src || !WT.isOn()) return
			to_chat(user, span_notice("You deconstruct the frame."))
			new /obj/item/stack/material/steel( src.loc, 2 )
			qdel(src)
			return

	if(I.has_tool_quality(TOOL_MULTITOOL))
		var/input = sanitize(tgui_input_text(user, "What id would you like to give this conveyor switch?", "Multitool-Conveyor interface", id))
		if(!input)
			to_chat(user, "No input found. Please hang up and try your call again.")
			return
		id = input
		conveyors = list() // Clear list so they aren't double added.
		for(var/obj/machinery/conveyor/C in machines)
			if(C.id == id)
				conveyors += C
		return

	if(I.has_tool_quality(TOOL_WRENCH))
		if(oneway == 1)
			to_chat(user, "You set the switch to two way operation.")
			oneway = 0
			playsound(src, I.usesound, 50, 1)
			return
		else
			to_chat(user, "You set the switch to one way operation.")
			oneway = 1
			playsound(src, I.usesound, 50, 1)
			return

	//Ports making conveyors fast from CHOMPstation
	if(I.has_tool_quality(TOOL_WIRECUTTER))
		toggle_speed()
		to_chat(user, "You adjust the speed of the conveyor switch")
		return

/obj/machinery/conveyor_switch/oneway
	oneway = 1

/obj/machinery/conveyor_switch/examine()
	.=..()
	if(oneway == 1)
		. += " It appears to only go in one direction."
