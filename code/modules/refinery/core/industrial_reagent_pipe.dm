/obj/machinery/reagent_refinery/pipe
	name = "Industrial Chemical Pipe"
	desc = "A large pipe made for transporting industrial chemicals. It has a low-power passive pump. The red marks show where the flow is coming from. Does not require power."
	icon_state = "pipe"
	density = TRUE
	anchored = TRUE
	use_power = USE_POWER_OFF // Does not require power for pipes
	idle_power_usage = 0
	active_power_usage = 0
	circuit = /obj/item/circuitboard/industrial_reagent_pipe
	default_max_vol = 60 // smoll

/obj/machinery/reagent_refinery/pipe/Initialize(mapload)
	. = ..()
	default_apply_parts()
	// Can't be set on these
	src.verbs -= /obj/machinery/reagent_refinery/verb/set_APTFT
	// Update neighbours and self for state
	update_neighbours()
	update_icon()
	AddElement(/datum/element/climbable)

/obj/machinery/reagent_refinery/pipe/process()
	if(!anchored)
		return

	if(stat & (BROKEN))
		return

	refinery_transfer()

/obj/machinery/reagent_refinery/pipe/update_icon()
	cut_overlays()
	if(anchored)
		for(var/direction in GLOB.cardinal)
			var/turf/T = get_step(get_turf(src),direction)
			var/obj/machinery/other = locate(/obj/machinery/reagent_refinery) in T
			if(other && other.anchored)
				// Waste processors do not connect to anything as outgoing
				if(istype(other,/obj/machinery/reagent_refinery/waste_processor))
					continue
				// weird handling for side connections... Otherwise, anything pointing into use gets connected back!
				if(istype(other,/obj/machinery/reagent_refinery/filter))
					var/obj/machinery/reagent_refinery/filter/filt = other
					var/check_dir = 0
					if(filt.get_filter_side() == 1)
						check_dir = turn(filt.dir, 270)
					else
						check_dir = turn(filt.dir, 90)
					if(check_dir == GLOB.reverse_dir[direction] && dir != direction)
						var/image/intake = image(icon, icon_state = "pipe_intakes", dir = direction)
						add_overlay(intake)
						continue
				if(other.dir == GLOB.reverse_dir[direction] && dir != direction)
					var/image/intake = image(icon, icon_state = "pipe_intakes", dir = direction)
					add_overlay(intake)

/obj/machinery/reagent_refinery/pipe/handle_transfer(var/atom/origin_machine, var/datum/reagents/RT, var/source_forward_dir, var/transfer_rate, var/filter_id = "")
	// no back/forth, filters don't use just their forward, they send the side too!
	if(dir == GLOB.reverse_dir[source_forward_dir])
		return 0
	. = ..(origin_machine, RT, source_forward_dir, transfer_rate, filter_id)

/obj/machinery/reagent_refinery/pipe/examine(mob/user, infix, suffix)
	. = ..()
	. += "The meter shows [reagents.total_volume]u / [reagents.maximum_volume]u."
	tutorial(REFINERY_TUTORIAL_SINGLEOUTPUT|REFINERY_TUTORIAL_NOPOWER, .)
