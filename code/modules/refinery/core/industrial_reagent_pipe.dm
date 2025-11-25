/obj/machinery/reagent_refinery/pipe
	name = "Industrial Chemical Pipe"
	desc = "A large pipe made for transporting industrial chemicals."
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
		update_input_connection_overlays("pipe_intakes")

/obj/machinery/reagent_refinery/pipe/handle_transfer(var/atom/origin_machine, var/datum/reagents/RT, var/source_forward_dir, var/transfer_rate, var/filter_id = "")
	// no back/forth, filters don't use just their forward, they send the side too!
	if(dir == GLOB.reverse_dir[source_forward_dir])
		return 0
	. = ..(origin_machine, RT, source_forward_dir, transfer_rate, filter_id)

/obj/machinery/reagent_refinery/pipe/examine(mob/user, infix, suffix)
	. = ..()
	. += "The meter shows [reagents.total_volume]u / [reagents.maximum_volume]u."
	tutorial(REFINERY_TUTORIAL_SINGLEOUTPUT|REFINERY_TUTORIAL_NOPOWER, .)
