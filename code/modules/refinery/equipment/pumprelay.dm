/obj/machinery/pump_relay
	name = "Pump Relay"
	desc = "Pumps chemicals long distances using plastic hoses. It has multiple inputs to allow the creation of complex pump networks. Does not require power."
	icon = 'icons/obj/props/decor.dmi'
	icon_state = "nt_biocan"
	density = TRUE
	anchored = TRUE
	circuit = /obj/item/circuitboard/industrial_reagent_pump

/obj/machinery/pump_relay/Initialize(mapload)
	. = ..()
	create_reagents(120)
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
