//Most interesting stuff happens in disperser_fire.dm
//This is just basic construction and deconstruction and the like

/obj/machinery/disperser
	name = "abstract parent for disperser"
	desc = "You should never see one of these, bap your mappers."
	icon = 'icons/obj/disperser.dmi'
	idle_power_usage = 200
	density = TRUE
	anchored = TRUE

/obj/machinery/disperser/Initialize(mapload)
	. = ..()
	default_apply_parts()

/obj/machinery/disperser/examine(mob/user)
	. = ..()
	if(panel_open)
		to_chat(user, "The maintenance panel is open.")

/obj/machinery/disperser/attackby(obj/item/I, mob/user)
	if(I && I.has_tool_quality(TOOL_WRENCH))
		if(panel_open)
			user.visible_message(span_infoplain(span_bold("\The [user]") + " rotates \the [src] with \the [I]."),
				span_notice("You rotate \the [src] with \the [I]."))
			set_dir(turn(dir, 90))
			playsound(src, 'sound/items/jaws_pry.ogg', 50, 1)
		else
			to_chat(user, span_notice("The maintenance panel must be screwed open for this!"))
		return
	if(default_deconstruction_screwdriver(user, I))
		return
	if(default_deconstruction_crowbar(user, I))
		return
	if(default_part_replacement(user, I))
		return
	return ..()

/obj/machinery/disperser/front
	name = "obstruction removal ballista beam generator"
	desc = "A complex machine which shoots concentrated material beams.\
		<br>A sign on it reads: <i>STAY CLEAR! DO NOT BLOCK!</i>"
	icon_state = "front"
	circuit = /obj/item/circuitboard/disperserfront

/obj/machinery/disperser/middle
	name = "obstruction removal ballista fusor"
	desc = "A complex machine which transmits immense amount of data \
		from the material deconstructor to the particle beam generator.\
		<br>A sign on it reads: <i>EXPLOSIVE! DO NOT OVERHEAT!</i>"
	icon_state = "middle"
	circuit = /obj/item/circuitboard/dispersermiddle
	// maximum_component_parts = list(/obj/item/stock_parts = 15)

/obj/machinery/disperser/back
	name = "obstruction removal ballista material deconstructor"
	desc = "A prototype machine which can deconstruct materials atom by atom.\
		<br>A sign on it reads: <i>KEEP AWAY FROM LIVING MATERIAL!</i>"
	icon_state = "back"
	circuit = /obj/item/circuitboard/disperserback
	density = FALSE
	layer = UNDER_JUNK_LAYER //So the charges go above us.
