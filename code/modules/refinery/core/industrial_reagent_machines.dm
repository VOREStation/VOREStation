/obj/machinery/reagent_refinery
	icon = 'icons/obj/machines/refinery_machines.dmi'
	VAR_PROTECTED/default_max_vol = 120
	VAR_PROTECTED/amount_per_transfer_from_this = 120
	VAR_PROTECTED/possible_transfer_amounts = REFINERY_DEFAULT_TRANSFER_AMOUNTS
	VAR_PROTECTED/reagent_type = /datum/reagents

/obj/machinery/reagent_refinery/Initialize(mapload)
	. = ..()
	// reagent control
	if(default_max_vol > 0)
		create_reagents(default_max_vol, reagent_type)
	// Update neighbours and self for state
	update_neighbours()
	update_icon()
	AddElement(/datum/element/rotatable)

/obj/machinery/reagent_refinery/Destroy()
	reagent_flush()
	. = ..()

/obj/machinery/reagent_refinery/dismantle()
	reagent_flush()
	. = ..()

/obj/machinery/reagent_refinery/set_dir(newdir)
	. = ..()
	update_icon()

/obj/machinery/reagent_refinery/on_reagent_change(changetype)
	update_icon()

/// Splashes reagents all over the floor, called from destroy and dismantle.
/obj/machinery/reagent_refinery/proc/reagent_flush()
	if(reagents && reagents.total_volume > 30)
		visible_message(span_danger("\The [src] splashes everywhere as it is disassembled!"))
		reagents.splash_area(get_turf(src),2)

/obj/machinery/reagent_refinery/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if (istype(O, /obj/item/multitool)) // Solar grubs
		return ..()
	if(O.has_tool_quality(TOOL_WRENCH))
		if(!anchored)
			for(var/obj/machinery/reagent_refinery/R in loc.contents)
				if(R != src)
					to_chat(usr,span_warning("You cannot anchor \the [src] until \The [R] is moved out of the way!"))
					return
		playsound(src, O.usesound, 75, 1)
		anchored = !anchored
		user.visible_message("[user.name] [anchored ? "secures" : "unsecures"] the bolts holding [src.name] to the floor.", \
					"You [anchored ? "secure" : "unsecure"] the bolts holding [src] to the floor.", \
					"You hear a ratchet.")
		update_neighbours()
		update_icon()
		return
	if(reagents && (istype(O,/obj/item/reagent_containers/glass) || \
		istype(O,/obj/item/reagent_containers/food/drinks/glass2) || \
		istype(O,/obj/item/reagent_containers/food/drinks/shaker)))
		// Transfer FROM internal beaker to this.
		if (reagents.total_volume <= 0)
			to_chat(usr,"\The [src] is empty. There is nothing to drain into \the [O].")
			return
		// Fill up the whole volume if we can, DUMP IT OUT
		var/obj/item/reagent_containers/C = O
		reagents.trans_to_obj(C, reagents.total_volume)
		playsound(src, 'sound/machines/reagent_dispense.ogg', 25, 1)
		to_chat(usr,"You drain \the [src] into \the [C].")
		return
	if(default_deconstruction_screwdriver(user, O))
		return
	if(default_deconstruction_crowbar(user, O))
		return
	. = ..()

/// Updates the icons of all neighbour machines, used when connecting.
/obj/machinery/reagent_refinery/proc/update_neighbours()
	// Update icons and neighbour icons to avoid loss of sanity
	for(var/direction in GLOB.cardinal)
		var/turf/T = get_step(get_turf(src),direction)
		var/obj/machinery/other = locate(/obj/machinery/reagent_refinery) in T
		if(other && other.anchored)
			other.update_icon()

/// Changes the transfer rate of reagents from this machine to the next
/obj/machinery/reagent_refinery/verb/set_APTFT() //set amount_per_transfer_from_this
	PROTECTED_PROC(TRUE)
	set name = "Set transfer amount"
	set category = "Object"
	set src in view(1)
	var/N = tgui_input_list(usr, "Amount per transfer from this:","[src]", possible_transfer_amounts)
	if(N && Adjacent(usr))
		amount_per_transfer_from_this = N
		update_icon()

/// Transfers reagents from us to the next machine. Calls handle_transfer() on any target machines to check if they can accept reagents.
/obj/machinery/reagent_refinery/proc/transfer_tank( var/datum/reagents/RT, var/obj/machinery/reagent_refinery/target, var/source_forward_dir, var/filter_id = "")
	PROTECTED_PROC(TRUE)
	if(RT.total_volume <= 0 || !anchored || !target.anchored)
		return 0
	if(active_power_usage > 0 && !can_use_power_oneoff(active_power_usage))
		return 0
	if(!istype(target,/obj/machinery/reagent_refinery)) // cannot transfer into grinders anyway, so it's fine to do it this way.
		return 0
	var/transfered = target.handle_transfer(src,RT,source_forward_dir, amount_per_transfer_from_this, filter_id)
	if(transfered > 0 && active_power_usage > 0)
		use_power_oneoff(active_power_usage)
	return transfered

/// Handles reagent recieving from transfer_tank(), returns how much reagent was transfered if successful. Overriden to prevent access from certain sides or for filtering.
/obj/machinery/reagent_refinery/proc/handle_transfer(var/atom/origin_machine, var/datum/reagents/RT, var/source_forward_dir, var/transfer_rate, var/filter_id = "") // Handle transfers in an override, instead of one monster function that typechecks like transfer_tank() used to be
	// Transfer to target in amounts every process tick!
	if(filter_id == "")
		var/amount = RT.trans_to_obj(src, transfer_rate)
		return amount
	// Split out reagent...
	return RT.trans_id_to(src, filter_id, transfer_rate, TRUE)

/obj/machinery/reagent_refinery/proc/refinery_transfer()
	if(amount_per_transfer_from_this <= 0 || reagents.total_volume <= 0)
		return 0

	// dump reagents to next refinery machine
	var/obj/machinery/reagent_refinery/target = locate(/obj/machinery/reagent_refinery) in get_step(get_turf(src),dir)
	if(!target)
		return 0
	if(reagents.total_volume < minimum_reagents_for_transfer(target))
		return 0

	return transfer_tank( reagents, target, dir)

/// Handle transfers that require a minimum amount of reagents to happen
/obj/machinery/reagent_refinery/proc/minimum_reagents_for_transfer(var/obj/machinery/reagent_refinery/target)
	return 0

/obj/machinery/reagent_refinery/proc/tutorial(var/flags,var/list/examine_list)
	// Specialty
	if(flags & REFINERY_TUTORIAL_HUB)
		examine_list += "A trolly tanker can be drained or filled depending on if this machine is attached to the input or output of another machine. "
	// Input handling
	if(flags & REFINERY_TUTORIAL_NOINPUT)
		examine_list += "This machine does not accept any inputs, and only outputs. "
	if(flags & REFINERY_TUTORIAL_ALLIN)
		examine_list += "This machine accepts input from all sides. "
	if(flags & REFINERY_TUTORIAL_SINGLEOUTPUT)
		examine_list += "This machine accepts inputs on all sides, except for its output. "
	if(flags & REFINERY_TUTORIAL_NOOUTPUT)
		examine_list += "This machine does not have any outputs. "
	// Pipe markings
	if(flags & REFINERY_TUTORIAL_INPUT)
		examine_list += "The red pipe marks the input. "
	if(flags & REFINERY_TUTORIAL_FILTER)
		examine_list += "The purple pipe marks the filtered output. "
	// No power needed
	if(flags & REFINERY_TUTORIAL_NOPOWER)
		examine_list += "Does not require power. "
