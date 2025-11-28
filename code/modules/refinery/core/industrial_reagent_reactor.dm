#define REACTOR_MODE_INTAKE 0
#define REACTOR_MODE_OUTPUT 1

/obj/machinery/reagent_refinery/reactor
	name = "Industrial Chemical Reactor"
	desc = "A reinforced chamber for high temperature distillation. Can be connected to a pipe network to change the interior atmosphere. It outputs chemicals on a timer, to allow for distillation."
	icon_state = "reactor"
	density = TRUE
	anchored = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 0
	active_power_usage = 500
	circuit = /obj/item/circuitboard/industrial_reagent_reactor
	default_max_vol = REAGENT_VAT_VOLUME
	reagent_type = /datum/reagents/distilling

	VAR_PRIVATE/obj/machinery/portable_atmospherics/canister/internal_tank
	VAR_PRIVATE/toggle_mode = REACTOR_MODE_INTAKE
	VAR_PRIVATE/next_mode_toggle = 0

	VAR_PRIVATE/dis_time = 30
	VAR_PRIVATE/drain_time = 10

/obj/machinery/reagent_refinery/reactor/Initialize(mapload)
	. = ..()
	default_apply_parts()
	internal_tank = new /obj/machinery/portable_atmospherics/canister/empty()
	update_gas_network()
	next_mode_toggle = world.time + dis_time SECONDS
	// Update neighbours and self for state
	update_neighbours()
	update_icon()
	AddElement(/datum/element/climbable)

/obj/machinery/reagent_refinery/reactor/Destroy()
	. = ..()
	QDEL_NULL(internal_tank)

/obj/machinery/reagent_refinery/reactor/process()
	if(!anchored)
		return

	power_change()
	if(stat & (NOPOWER|BROKEN))
		return

	if(next_mode_toggle < world.time)
		if(toggle_mode == REACTOR_MODE_INTAKE)
			if(reagents && reagents.total_volume > 0 && amount_per_transfer_from_this > 0)
				toggle_mode = REACTOR_MODE_OUTPUT // Only drain if anything in it!
			next_mode_toggle = world.time + drain_time SECONDS
		else
			toggle_mode = REACTOR_MODE_INTAKE
			next_mode_toggle = world.time + dis_time SECONDS
		update_icon()

	if(amount_per_transfer_from_this <= 0 || reagents.total_volume <= 0)
		return

	if(toggle_mode == REACTOR_MODE_INTAKE)
		// perform reactions
		reagents.handle_reactions()
	else
		// dump reagents to next refinery machine
		var/obj/machinery/reagent_refinery/target = locate(/obj/machinery/reagent_refinery) in get_step(loc,dir)
		if(target)
			transfer_tank( reagents, target, dir)

/obj/machinery/reagent_refinery/reactor/update_icon()
	cut_overlays()
	// Get main dir pipe
	var/image/pipe = image(icon, icon_state = "reactor_cons", dir = dir)
	add_overlay(pipe)
	if(anchored)
		if(!(stat & (NOPOWER|BROKEN)))
			var/image/dot = image(icon, icon_state = "vat_dot_[ toggle_mode > REACTOR_MODE_INTAKE ? "on" : "off" ]") // Show refinery output mode
			add_overlay(dot)
		update_input_connection_overlays("reactor_intakes")

/obj/machinery/reagent_refinery/reactor/handle_transfer(var/atom/origin_machine, var/datum/reagents/RT, var/source_forward_dir, var/transfer_rate, var/filter_id = "")
	// no back/forth, filters don't use just their forward, they send the side too!
	if(dir == GLOB.reverse_dir[source_forward_dir])
		return 0
	// locked until distilling mode
	if(toggle_mode == REACTOR_MODE_OUTPUT)
		return 0
	. = ..(origin_machine, RT, source_forward_dir, transfer_rate, filter_id)

/obj/machinery/reagent_refinery/reactor/examine(mob/user, infix, suffix)
	. = ..()
	. += "The meter shows [reagents.total_volume]u / [reagents.maximum_volume]u. It is pumping chemicals at a rate of [amount_per_transfer_from_this]u."
	var/datum/gas_mixture/GM = internal_tank.return_air()
	. += "The internal temperature is [GM.temperature]k at [GM.return_pressure()]kpa. It is currently in a [toggle_mode ? "pumping cycle, outputting stored chemicals" : "distilling cycle, accepting input chemicals"]."
	tutorial(REFINERY_TUTORIAL_SINGLEOUTPUT, .)

/obj/machinery/reagent_refinery/reactor/attackby(var/obj/item/O as obj, var/mob/user as mob)
	. = ..()
	if(O.has_tool_quality(TOOL_WRENCH))
		update_gas_network() // Handles anchoring
		toggle_mode = REACTOR_MODE_INTAKE
		next_mode_toggle = world.time + dis_time SECONDS

/obj/machinery/reagent_refinery/reactor/proc/update_gas_network()
	if(!internal_tank)
		return
	// think of this as we JUST anchored/deanchored
	var/obj/machinery/atmospherics/portables_connector/pad = locate() in get_turf(src)
	if(pad && !pad.connected_device)
		if(anchored)
			// Perform the connection, forcibly... we're ignoring adjacency checks with this
			internal_tank.connected_port = pad
			pad.connected_device = internal_tank
			pad.on = 1 //Activate port updates
			// Actually enforce the air sharing
			var/datum/pipe_network/network = pad.return_network(internal_tank)
			if(network && !network.gases.Find(internal_tank.air_contents))
				network.gases += internal_tank.air_contents
				network.update = 1
			// Sfx
			playsound(src, 'sound/mecha/gasconnected.ogg', 50, 1)
		else
			internal_tank.disconnect()
			playsound(src, 'sound/mecha/gasdisconnected.ogg', 50, 1)
	else if(internal_tank.connected_port)
		internal_tank.disconnect() // How did we get here? qdelled pad?
		playsound(src, 'sound/mecha/gasdisconnected.ogg', 50, 1)

/obj/machinery/reagent_refinery/reactor/return_air()
	if(internal_tank)
		return internal_tank.return_air()
	. = ..()

#undef REACTOR_MODE_INTAKE
#undef REACTOR_MODE_OUTPUT
