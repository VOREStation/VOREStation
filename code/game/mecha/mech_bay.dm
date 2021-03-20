/obj/machinery/mech_recharger
	name = "mech recharger"
	desc = "A mech recharger, built into the floor."
	icon = 'icons/mecha/mech_bay.dmi'
	icon_state = "recharge_floor"
	density = 0
	anchored = 1
	layer = TURF_LAYER + 0.1
	circuit = /obj/item/weapon/circuitboard/mech_recharger

	var/atom/movable/charging
	var/charge = 45
	var/repair = 0
	var/list/chargable_types = list(
		/obj/mecha,
		/mob/living/silicon/robot/platform
	)

/obj/machinery/mech_recharger/Initialize()
	. = ..()
	default_apply_parts()

/obj/machinery/mech_recharger/Crossed(var/atom/movable/M)
	. = ..()
	if(charging == M)
		return
	for(var/mtype in chargable_types)
		if(istype(M, mtype))
			start_charging(M)
			return

/obj/machinery/mech_recharger/Uncrossed(var/atom/movable/M)
	. = ..()
	if(M == charging)
		charging = null

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
		charging = null
		return

	var/done = FALSE
	var/obj/mecha/mech = charging
	var/obj/item/weapon/cell/cell = charging.get_cell()
	if(cell)	
		var/t = min(charge, cell.maxcharge - cell.charge)
		if(t > 0)
			if(istype(mech))
				mech.give_power(t)
			else
				cell.give(t)
			use_power(t * 150)
		else
			if(istype(mech))
				mech.occupant_message(SPAN_NOTICE("Fully charged."))
			done = TRUE

	if(repair && istype(mech) && mech.health < initial(mech.health))
		mech.health = min(mech.health + repair, initial(mech.health))
		if(mech.health == initial(mech.health))
			mech.occupant_message(SPAN_NOTICE("Fully repaired."))
		else
			done = FALSE
	if(done)
		charging = null

/obj/machinery/mech_recharger/attackby(var/obj/item/I, var/mob/user)
	if(default_deconstruction_screwdriver(user, I))
		return
	if(default_deconstruction_crowbar(user, I))
		return
	if(default_part_replacement(user, I))
		return

/obj/machinery/mech_recharger/proc/start_charging(var/atom/movable/M)

	var/obj/mecha/mech = M
	if(stat & (NOPOWER | BROKEN))
		if(istype(mech))
			mech.occupant_message(SPAN_WARNING("Power port not responding. Terminating."))
		else
			to_chat(M, SPAN_WARNING("Power port not responding. Terminating."))
		return
	if(M.get_cell())
		if(istype(mech))
			mech.occupant_message(SPAN_NOTICE("Now charging..."))
		else
			to_chat(M, SPAN_NOTICE("Now charging..."))
		charging = M
	return
