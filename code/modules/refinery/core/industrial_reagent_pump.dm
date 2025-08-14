/obj/machinery/reagent_refinery/pump
	name = "Industrial Chemical Pump"
	desc = "Transports large amounts of chemicals between machines, it also has connections for various types of hoses."
	icon_state = "pump"
	density = TRUE
	anchored = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 0
	active_power_usage = 50
	circuit = /obj/item/circuitboard/industrial_reagent_pump

/obj/machinery/reagent_refinery/pump/Initialize(mapload)
	. = ..()
	default_apply_parts()
	// Update neighbours and self for state
	update_neighbours()
	update_icon()

	AddComponent(/datum/component/hose_connector/input)
	AddComponent(/datum/component/hose_connector/input)
	AddComponent(/datum/component/hose_connector/input)
	AddComponent(/datum/component/hose_connector/output)

	AddElement(/datum/element/climbable)

/obj/machinery/reagent_refinery/pump/process()
	if(!anchored)
		return

	power_change()
	if(stat & (NOPOWER|BROKEN))
		return

	refinery_transfer()

/obj/machinery/reagent_refinery/proc/minimum_reagents_for_transfer(var/obj/machinery/reagent_refinery/target)
	if(istype(target,/obj/machinery/reagent_refinery/mixer))
		return amount_per_transfer_from_this // Special handling for mixing vats. Don't pump unless we can pump all of it!
	return 0

/obj/machinery/reagent_refinery/pump/update_icon()
	cut_overlays()
	if(reagents && reagents.total_volume >= 5)
		var/image/filling = image(icon, loc, "pump_r",dir = dir)
		filling.color = reagents.get_color()
		add_overlay(filling)

/obj/machinery/reagent_refinery/pump/attack_hand(mob/user)
	set_APTFT()

/obj/machinery/reagent_refinery/pump/handle_transfer(var/atom/origin_machine, var/datum/reagents/RT, var/source_forward_dir, var/filter_id = "")
	// pumps, furnaces and filters can only be FED in a straight line
	if(source_forward_dir != dir)
		return 0
	. = ..(origin_machine, RT, source_forward_dir, filter_id)

/obj/machinery/reagent_refinery/pump/examine(mob/user, infix, suffix)
	. = ..()
	. += "The meter shows [reagents.total_volume]u / [reagents.maximum_volume]u. It is pumping chemicals at a rate of [amount_per_transfer_from_this]u."
	tutorial(REFINERY_TUTORIAL_INPUT, .)
