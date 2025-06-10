/obj/machinery/reagent_refinery/hub
	name = "Industrial Chemical Hub"
	desc = "A platform for loading and unloading cargo tug tankers."
	icon_state = "hub"
	density = FALSE
	anchored = TRUE
	use_power = USE_POWER_OFF // Does not require power for pipes
	idle_power_usage = 0
	active_power_usage = 0
	circuit = /obj/item/circuitboard/industrial_reagent_hub
	default_max_vol = 0
	VAR_PRIVATE/wait_delay = 4 SECONDS

/obj/machinery/reagent_refinery/hub/Initialize(mapload)
	. = ..()
	default_apply_parts()
	// Update neighbours and self for state
	update_neighbours()
	update_icon()

/obj/machinery/reagent_refinery/hub/process()
	if(!anchored)
		return

	if(stat & (BROKEN))
		return

	if (amount_per_transfer_from_this <= 0)
		return

	var/obj/machinery/reagent_refinery/target = locate(/obj/machinery/reagent_refinery) in get_step(loc,dir)
	if(target && target.dir != GLOB.reverse_dir[dir])
		var/obj/vehicle/train/trolly_tank/tanker = locate(/obj/vehicle/train/trolly_tank) in loc
		if(tanker && tanker.reagents.total_volume > 0 && world.time > tanker.l_move_time + wait_delay)
			// dump reagents to next refinery machine
			transfer_tank( tanker.reagents, target, dir)

/obj/machinery/reagent_refinery/hub/update_icon()
	cut_overlays()
	var/turf/T = get_step(get_turf(src),dir)
	var/obj/machinery/other = locate(/obj/machinery/reagent_refinery) in T
	var/intake = FALSE
	if(other && other.anchored)// Waste processors do not connect to anything as outgoing
		if(!istype(other,/obj/machinery/reagent_refinery/waste_processor))
			// weird handling for side connections... Otherwise, anything pointing into use gets connected back!
			if(istype(other,/obj/machinery/reagent_refinery/filter))
				var/obj/machinery/reagent_refinery/filter/filt = other
				var/check_dir = 0
				if(filt.get_filter_side() == 1)
					check_dir = turn(filt.dir, 270)
				else
					check_dir = turn(filt.dir, 90)
				if(check_dir == GLOB.reverse_dir[dir])
					intake = TRUE
			if(other.dir == GLOB.reverse_dir[dir])
				intake = TRUE
	// Get main dir pipe
	if(intake)
		var/image/pipe = image(icon, icon_state = "hub_intakes", dir = dir)
		add_overlay(pipe)
	else
		var/image/pipe = image(icon, icon_state = "hub_cons", dir = dir)
		add_overlay(pipe)

/obj/machinery/reagent_refinery/hub/handle_transfer(var/atom/origin_machine, var/datum/reagents/RT, var/source_forward_dir, var/filter_id = "")
	if(istype(origin_machine,/obj/machinery/reagent_refinery/hub)) // Hubs cannot send into other hubs
		return 0
	if(dir != GLOB.reverse_dir[source_forward_dir] ) // The hub must be facing into its source to accept input, unlike others
		return 0
	var/obj/vehicle/train/trolly_tank/tanker = locate(/obj/vehicle/train/trolly_tank) in get_turf(src)
	if(!tanker)
		return 0
	if(world.time < tanker.l_move_time + wait_delay) // await cooldown to avoid spamming moving tanks
		return 0
	// Don't call parent, we're transfering into the holding tank instead
	if(filter_id == "")
		return RT.trans_to_obj(tanker, amount_per_transfer_from_this)
	else
		// Split out reagent...
		return RT.trans_id_to(tanker, filter_id, amount_per_transfer_from_this)

/obj/machinery/reagent_refinery/hub/examine(mob/user, infix, suffix)
	. = ..()
	. += "It is pumping chemicals at a rate of [amount_per_transfer_from_this]u."
	tutorial(REFINERY_TUTORIAL_HUB|REFINERY_TUTORIAL_NOPOWER, .)
