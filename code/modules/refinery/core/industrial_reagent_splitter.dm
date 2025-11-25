/obj/machinery/reagent_refinery/splitter
	name = "Industrial Chemical Splitter"
	desc = "A large pipe made for transfering industrial chemicals to multiple machines. It has a low-power passive pump. The red marks show where the flow is coming from. Does not require power."
	icon_state = "splitter"
	density = TRUE
	anchored = TRUE
	use_power = USE_POWER_OFF // Does not require power for pipes
	idle_power_usage = 0
	active_power_usage = 0
	circuit = /obj/item/circuitboard/industrial_reagent_splitter
	default_max_vol = 60 // smoll

/obj/machinery/reagent_refinery/splitter/Initialize(mapload)
	. = ..()
	default_apply_parts()
	// Can't be set on these
	src.verbs -= /obj/machinery/reagent_refinery/verb/set_APTFT
	// Update neighbours and self for state
	update_neighbours()
	update_icon()
	AddElement(/datum/element/climbable)
	amount_per_transfer_from_this = default_max_vol / 2 // Half and half

/obj/machinery/reagent_refinery/splitter/process()
	if(!anchored)
		return

	if(stat & (BROKEN))
		return

	splitter_transfer()

/obj/machinery/reagent_refinery/proc/splitter_transfer()
	if(amount_per_transfer_from_this <= 0 || reagents.total_volume <= 0)
		return 0

	var/list/target_list = list()
	var/list/dir_list = list()
	var/list/dir_list =  list(turn(dir, 90), turn(dir, -90))
	if(prob(50)) // So neither side has priority
		dir_list =  list(turn(dir, -90), turn(dir, 90))

	for(var/dir_check in dir_list)
		var/obj/machinery/reagent_refinery/target = locate() in get_step(get_turf(src),dir_check)
		if(!target)
			continue
		target_list += list(target)
		dir_list += list(dir_check)
	if(!target_list.len)
		return 0

	var/transfer_rate = min(reagents.total_volume,amount_per_transfer_from_this) / target_list.len
	if(transfer_rate < 1)
		return 0

	var/total_transfered = 0
	for(var/i = 1 to target_list.len)
		var/scan_dir = dir_list[i]
		var/scan_targ = target_list[i]
		if(reagents.total_volume >= minimum_reagents_for_transfer(scan_targ))
			total_transfered += transfer_tank(reagents, scan_targ, scan_dir)
	return total_transfered

/obj/machinery/reagent_refinery/splitter/handle_transfer(var/atom/origin_machine, var/datum/reagents/RT, var/source_forward_dir, var/transfer_rate, var/filter_id = "")
	// pumps, furnaces, splitters and filters can only be FED in a straight line
	if(source_forward_dir != dir)
		return 0
	. = ..(origin_machine, RT, source_forward_dir, transfer_rate, filter_id)

/obj/machinery/reagent_refinery/splitter/examine(mob/user, infix, suffix)
	. = ..()
	. += "The meter shows [reagents.total_volume]u / [reagents.maximum_volume]u."
	tutorial(REFINERY_TUTORIAL_SPLITTEROUTPUT|REFINERY_TUTORIAL_INPUT|REFINERY_TUTORIAL_NOPOWER, .)
