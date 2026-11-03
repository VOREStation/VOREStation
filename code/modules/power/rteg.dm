/obj/machinery/power/port_gen/rteg
	name = "\improper RTEG"
	desc = "A power generator that runs on solid phoron sheets. Rated for 80 kW max safe output."
	power_gen = 600 KILOWATTS	//Watts output per power_output level
	icon_state = "smes"
	anchored = TRUE

/obj/machinery/power/port_gen/rteg/Initialize(mapload)
	. = ..()
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

/obj/machinery/power/port_gen/rteg/attack_hand(mob/user)
	..()
	if (!anchored)
		to_chat(user, "[src] can't safely be power-cycled while being unanchored.")
		return
	add_fingerprint(user)
	TogglePower()


/obj/machinery/power/port_gen/rteg/attack_ai(mob/user as mob)
	TogglePower()
