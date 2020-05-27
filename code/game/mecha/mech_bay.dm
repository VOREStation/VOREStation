/obj/machinery/mech_recharger
	name = "mech recharger"
	desc = "A mech recharger, built into the floor."
	icon = 'icons/mecha/mech_bay.dmi'
	icon_state = "recharge_floor"
	density = 0
	anchored = 1
	layer = TURF_LAYER + 0.1
	circuit = /obj/item/weapon/circuitboard/mech_recharger

	var/obj/mecha/charging = null
	var/charge = 45
	var/repair = 0

/obj/machinery/mech_recharger/Initialize()
	. = ..()
	default_apply_parts()

/obj/machinery/mech_recharger/Crossed(var/obj/mecha/M)
	. = ..()
	if(istype(M) && charging != M)
		start_charging(M)

/obj/machinery/mech_recharger/Uncrossed(var/obj/mecha/M)
	. = ..()
	if(M == charging)
		stop_charging()

/obj/machinery/mech_recharger/RefreshParts()
	..()
	charge = 0
	repair = -5
	for(var/obj/item/weapon/stock_parts/P in component_parts)
		if(istype(P, /obj/item/weapon/stock_parts/capacitor))
			charge += P.rating * 20
		if(istype(P, /obj/item/weapon/stock_parts/scanning_module))
			charge += P.rating * 5
			repair += P.rating
		if(istype(P, /obj/item/weapon/stock_parts/manipulator))
			repair += P.rating * 2

/obj/machinery/mech_recharger/process()
	..()
	if(!charging)
		return
	if(charging.loc != src.loc) // Could be qdel or teleport or something
		stop_charging()
		return
	var/done = FALSE
	if(charging.cell)	
		var/t = min(charge, charging.cell.maxcharge - charging.cell.charge)
		if(t > 0)
			charging.give_power(t)
			use_power(t * 150)
		else
			charging.occupant_message("<span class='notice'>Fully charged.</span>")
			done = TRUE
	if(repair && charging.health < initial(charging.health))
		charging.health = min(charging.health + repair, initial(charging.health))
		if(charging.health == initial(charging.health))
			charging.occupant_message("<span class='notice'>Fully repaired.</span>")
		else
			done = FALSE
	if(done)
		stop_charging()
	return

/obj/machinery/mech_recharger/attackby(var/obj/item/I, var/mob/user)
	if(default_deconstruction_screwdriver(user, I))
		return
	if(default_deconstruction_crowbar(user, I))
		return
	if(default_part_replacement(user, I))
		return

/obj/machinery/mech_recharger/proc/start_charging(var/obj/mecha/M)
	if(stat & (NOPOWER | BROKEN))
		M.occupant_message("<span class='warning'>Power port not responding. Terminating.</span>")

		return
	if(M.cell)
		M.occupant_message("<span class='notice'>Now charging...</span>")
		charging = M
	return

/obj/machinery/mech_recharger/proc/stop_charging()
	if(!charging)

		return
	charging = null