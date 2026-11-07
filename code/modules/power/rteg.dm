/obj/machinery/power/port_gen/rteg
	name = "\improper RTEG"
	desc = "A bulky, expensive morphium-phoron pumped pseudo-RTEG meant to be used as a baseline, backup power source for large, remote installations or ships. A safe, never off source of power that is nevertheless quite expensive quite deadly if the electronics modulating the reaction go bad. They are EMP shielded, water and dust proof resistant, and hidden in a big casing, so as long as you leave it be, it should be fine. Probably."
	description_info = "Provides the bare minimum of power for a station to avoid full blackouts."
	description_antag = "You probably shouldn't emag this."
	power_gen = 600 KILOWATTS
	icon_state = "rteg"
	anchored = TRUE

/obj/machinery/power/port_gen/rteg/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/empprotection, EMP_PROTECT_SELF)
	if(anchored)
		connect_to_network()

/obj/machinery/power/port_gen/rteg/examine(mob/user)
	. = ..()
	if(Adjacent(user))
		. += span_notice("It appears to be producing [power_gen*power_output] W.")
		if(IsBroken())
			. += span_warning("It seems to have broken down.")

/obj/machinery/power/port_gen/rteg/HasFuel()
	return TRUE

/obj/machinery/power/port_gen/rteg/update_icon()
	if(active)
		icon_state = "[initial(icon_state)]"
	else
		icon_state = "[initial(icon_state)]-off"

/obj/machinery/power/port_gen/rteg/emag_act(remaining_charges, mob/user)
	if (active && prob(25))
		explode() //if they're foolish enough to emag while it's running

	if (!emagged)
		emagged = TRUE
		return TRUE

/obj/machinery/power/port_gen/rteg/attackby(obj/item/O, mob/user)
	if(!active)
		if(O.has_tool_quality(TOOL_WRENCH))
			if(!anchored)
				connect_to_network()
				to_chat(user, span_notice("You secure the generator to the floor."))
			else
				disconnect_from_network()
				to_chat(user, span_notice("You unsecure the generator from the floor."))
			playsound(src, 'sound/items/Deconstruct.ogg', 50, 1)
			anchored = !anchored
			return
		else if(default_deconstruction_screwdriver(user, O))
			return
		else if(default_deconstruction_crowbar(user, O))
			return
		else if(default_part_replacement(user, O))
			return
	return ..()

/obj/machinery/power/port_gen/rteg/explode()
	//a BIG burst of radiation
	var/rads = 300
	radiation_pulse(
		src,
		max_range = (rads/10),
		threshold = RAD_HEAVY_INSULATION,
		chance = DEFAULT_RADIATION_CHANCE,
		strength = rads
	)

	explosion(src.loc, 3, 3, 5, 3)
	qdel(src)

/obj/machinery/power/port_gen/rteg/emp_act(severity, recursive)
	. = ..()
	return

/obj/machinery/power/port_gen/rteg/attack_hand(mob/user)
	..()
	if (!anchored)
		to_chat(user, span_warning("[src] can't safely be power-cycled while being unanchored."))
		return
	add_fingerprint(user)
	TogglePower()


/obj/machinery/power/port_gen/rteg/attack_ai(mob/user)
	TogglePower()

/obj/machinery/power/port_gen/rteg/stellar_delight
	power_gen = 450 KILOWATTS

/obj/machinery/power/port_gen/rteg/tether
	power_gen = 600 KILOWATTS
