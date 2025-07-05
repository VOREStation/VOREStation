/obj/machinery/pump_relay
	name = "Pump Relay"
	desc = "Pumps chemicals long distances using plastic hoses. It has multiple inputs to allow the creation of complex pump networks. Does not require power."
	icon = 'icons/obj/machines/refinery_machines.dmi'
	icon_state = "pumprelay"
	density = TRUE
	anchored = TRUE
	circuit = /obj/item/circuitboard/industrial_reagent_pump

/obj/machinery/pump_relay/Initialize(mapload)
	. = ..()
	create_reagents(200)
	default_apply_parts()

	AddComponent(/datum/component/hose_connector/input)
	AddComponent(/datum/component/hose_connector/input)
	AddComponent(/datum/component/hose_connector/output)

/obj/machinery/pump_relay/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(default_deconstruction_screwdriver(user, O))
		return
	if(default_deconstruction_crowbar(user, O))
		return
	if(default_part_replacement(user, O))
		return
	if(default_unfasten_wrench(user, O, 20))
		return

	..()

/obj/machinery/pump_relay/on_reagent_change(changetype)
	. = ..()
	if(prob(2))
		visible_message(span_infoplain("\The [src] gurgles as it pumps fluid."))

/obj/machinery/pump_relay/on_reagent_change(changetype)
	update_icon()

/obj/machinery/pump_relay/update_icon()
	. = ..()
	cut_overlays()
	// GOOBY!
	if(reagents && reagents.total_volume >= 5)
		var/percent = (reagents.total_volume / reagents.maximum_volume) * 100
		switch(percent)
			if(5  to 10)		percent = 1
			if(10 to 20)		percent = 2
			if(20 to 30)		percent = 3
			if(30 to 40)		percent = 4
			if(40 to 50)		percent = 5
			if(50 to 60)		percent = 6
			if(60 to 70)		percent = 7
			if(70 to 80)		percent = 8
			if(80 to 90)		percent = 9
			if(90 to INFINITY)	percent = 10
		var/image/filling = image(icon, loc, "pumprelay_r_[percent]",dir = dir)
		filling.color = reagents.get_color()
		add_overlay(filling)

/obj/machinery/pump_relay/examine(mob/user, infix, suffix)
	. = ..()
	. += "The meter shows [reagents.total_volume]u / [reagents.maximum_volume]u."
