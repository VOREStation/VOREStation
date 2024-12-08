/obj/machinery/pump
	name = "fluid pump"
	desc = "A fluid pumping machine."

	description_info = "A machine that can pump fluid from certain turfs.<br>\
	Water can be pumped from any body of water. Certain locations or environmental\
	conditions  can cause different byproducts to be produced.<br>\
	Magma or Lava can be pumped to produce mineralized fluid."

	anchored = 0
	density = 1

	icon = 'icons/obj/machines/reagent.dmi'
	icon_state = "pump"

	circuit = /obj/item/circuitboard/fluidpump
	active_power_usage = 200 * CELLRATE

	var/obj/item/cell/cell = null
	var/obj/item/hose_connector/output/Output = null
	var/reagents_per_cycle = 5 // severe nerf to unupgraded speed
	var/on = 0
	var/unlocked = 0
	var/open = 0

/obj/machinery/pump/Initialize()
	create_reagents(200)
	. = ..()
	default_apply_parts()
	cell = default_use_hicell()

	Output = new(src)

	RefreshParts()
	update_icon()

/obj/machinery/pump/Destroy()
	QDEL_NULL(cell)
	QDEL_NULL(Output)
	. = ..()

/obj/machinery/pump/RefreshParts()
	var/obj/item/stock_parts/manipulator/SM = locate() in component_parts
	active_power_usage = initial(active_power_usage) / SM.rating

	var/motor_power = 0
	for(var/obj/item/stock_parts/motor/M in component_parts)
		motor_power += M.rating
	reagents_per_cycle = initial(reagents_per_cycle) * motor_power / 2

	var/bin_size = 0
	for(var/obj/item/stock_parts/matter_bin/SB in component_parts)
		bin_size += SB.rating

	// New holder might have different volume. Transfer everything to a new holder to account for this.
	var/datum/reagents/R = new(round(initial(reagents.maximum_volume) + 100 * bin_size), src)
	src.reagents.trans_to_holder(R, src.reagents.total_volume)
	qdel(src.reagents)
	src.reagents = R

	cell = locate(/obj/item/cell) in src

/obj/machinery/pump/update_icon()
	..()
	cut_overlays()
	add_overlay("[icon_state]-tank")
	if(!(cell?.check_charge(active_power_usage)))
		add_overlay("[icon_state]-lowpower")

	if(reagents.total_volume >= 1)
		var/image/I = image(icon, "[icon_state]-volume")
		I.color = reagents.get_color()
		add_overlay(I)
	add_overlay("[icon_state]-glass")

	if(open)
		add_overlay("[icon_state]-open")
		if(istype(cell))
			add_overlay("[icon_state]-cell")

	icon_state = "[initial(icon_state)][on ? "-running" : ""]"

/obj/machinery/pump/process()
	if(!on)
		return

	if(!anchored || !(cell?.use(active_power_usage)))
		set_state(FALSE)
		return

	var/turf/T = get_turf(src)
	if(!istype(T))
		return
	T.pump_reagents(reagents, reagents_per_cycle)
	update_icon()

	if(Output.get_pairing())
		reagents.trans_to_holder(Output.reagents, Output.reagents.maximum_volume)
		if(prob(5))
			visible_message(span_notice("\The [src] gurgles as it pumps fluid."))


// Sets the power state, if possible.
// Returns TRUE/FALSE on power state changing
// var/target = target power state
// var/message = TRUE/FALSE whether to make a message about state change
/obj/machinery/pump/proc/set_state(var/target, var/message = TRUE)
	if(target == on)
		return FALSE

	if(!on && (!(cell?.check_charge(active_power_usage)) || !anchored))
		return FALSE

	on = !on
	update_icon()
	if(message)
		if(on)
			message = span_notice("\The [src] turns on.")
		else
			message = span_notice("\The [src] shuts down.")
		visible_message(message)
	return TRUE

/obj/machinery/pump/attack_robot(mob/user)
	return attack_hand(user)

/obj/machinery/pump/attack_ai(mob/user)
	if(!set_state(!on))
		to_chat(user, span_notice("You try to toggle \the [src] but it does not respond."))

/obj/machinery/pump/attack_hand(mob/user)
	if(open && istype(cell))
		user.put_in_hands(cell)
		cell.add_fingerprint(user)
		cell.update_icon()
		cell = null
		set_state(FALSE)
		to_chat(user, span_notice("You remove the power cell."))
		return

	if(!set_state(!on))
		to_chat(user, span_notice("You try to toggle \the [src] but it does not respond."))

/obj/machinery/pump/attackby(obj/item/W, mob/user)
	. = TRUE
	if(W.has_tool_quality(TOOL_SCREWDRIVER) && !open)
		to_chat(user, span_notice("You [unlocked ? "screw" : "unscrew"] the battery panel."))
		unlocked = !unlocked

	else if(W.has_tool_quality(TOOL_CROWBAR) && unlocked)
		to_chat(user, open ? \
			span_notice("You crowbar the battery panel in place.") : \
			span_notice("You remove the battery panel.") \
		)
		open = !open

	else if(W.has_tool_quality(TOOL_WRENCH))
		if(on)
			to_chat(user, span_notice("\The [src] is active. Turn it off before trying to move it!"))
			return FALSE
		default_unfasten_wrench(user, W, 2 SECONDS)

	else if(istype(W, /obj/item/cell))
		if(!open)
			if(unlocked)
				to_chat(user, span_notice("The battery panel is screwed shut."))
			else
				to_chat(user, span_notice("The battery panel is watertight and cannot be opened without a crowbar."))
			return FALSE
		if(istype(cell))
			to_chat(user, span_notice("There is a power cell already installed."))
			return FALSE
		user.drop_from_inventory(W, src)
		to_chat(user, span_notice("You insert the power cell."))

	else
		. = ..()

	RefreshParts() // Handles cell assignment
	update_icon()


/turf/proc/pump_reagents()
	return

/turf/simulated/floor/lava/pump_reagents(var/datum/reagents/R, var/volume)
	. = ..()
	R.add_reagent(REAGENT_ID_MINERALIZEDFLUID, round(volume / 2, 0.1))


/turf/simulated/floor/water/pump_reagents(var/datum/reagents/R, var/volume)
	. = ..()
	R.add_reagent(REAGENT_ID_WATER, round(volume, 0.1))

	var/datum/gas_mixture/air = return_air() // v
	if(air.temperature <= T0C) // Uses the current air temp, instead of the turf starting temp
		R.add_reagent(REAGENT_ID_ICE, round(volume / 2, 0.1))

	for(var/turf/simulated/mineral/M in orange(5,src)) // Uses the turf as center instead of an unset usr
		if(M.mineral && prob(40)) // v
			R.add_reagent(M.mineral.reagent, round(volume / 5, 0.1)) // Was the turf's reagents variable not the R argument, and changed ore_reagent to M.mineral.reagent because of above change. Also nerfed amount to 1/5 instead of 1/2

/turf/simulated/floor/water/pool/pump_reagents(var/datum/reagents/R, var/volume)
	. = ..()
	R.add_reagent(REAGENT_ID_CHLORINE, round(volume / 10, 0.1))

/turf/simulated/floor/water/deep/pool/pump_reagents(var/datum/reagents/R, var/volume)
	. = ..()
	R.add_reagent(REAGENT_ID_CHLORINE, round(volume / 10, 0.1))

/turf/simulated/floor/water/contaminated/pump_reagents(var/datum/reagents/R, var/volume)
	. = ..()
	R.add_reagent(REAGENT_ID_VATSTABILIZER, round(volume / 2, 0.1))
