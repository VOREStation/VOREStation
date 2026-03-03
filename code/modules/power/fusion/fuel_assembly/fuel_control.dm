/obj/machinery/computer/fusion_fuel_control
	name = "fuel injection control computer"
	desc = "Displays information about the fuel rods."
	circuit = /obj/item/circuitboard/fusion_fuel_control

	icon_keyboard = "tech_key"
	icon_screen = "fuel_screen"

	var/id_tag
	var/scan_range = 25
	var/datum/tgui_module/rustfuel_control/monitor

/obj/machinery/computer/fusion_fuel_control/Initialize(mapload)
	. = ..()
	monitor = new(src)
	monitor.fuel_tag = id_tag

/obj/machinery/computer/fusion_fuel_control/Destroy()
	QDEL_NULL(monitor)
	. = ..()

/obj/machinery/computer/fusion_fuel_control/attack_ai(var/mob/user)
	attack_hand(user)

/obj/machinery/computer/fusion_fuel_control/attack_hand(var/mob/user as mob)
	..()
	if(stat & (BROKEN|NOPOWER))
		return

	monitor.tgui_interact(user)

/obj/machinery/computer/fusion_fuel_control/attackby(var/obj/item/W, var/mob/user)
	..()
	if(istype(W, /obj/item/multitool))
		var/new_ident = tgui_input_text(user, "Enter a new ident tag.", "Fuel Control", monitor.fuel_tag, MAX_NAME_LEN)
		if(new_ident && user.Adjacent(src))
			monitor.fuel_tag = new_ident
		return
