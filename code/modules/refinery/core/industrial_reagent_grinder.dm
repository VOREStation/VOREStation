/obj/machinery/reagent_refinery/grinder
	name = "Industrial Chemical Grinder"
	desc = "Grinds anything and everything into chemical slurry."
	icon = 'modular_outpost/icons/obj/machines/refinery_machines.dmi'
	icon_state = "grinder_off"
	density = TRUE
	anchored = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 5
	active_power_usage = 300
	circuit = /obj/item/circuitboard/industrial_reagent_grinder
	// Chemical bath funtimes!
	can_buckle = TRUE
	buckle_lying = TRUE
	default_max_vol = REAGENT_VAT_VOLUME
	VAR_PRIVATE/limit = 50
	VAR_PRIVATE/list/holdingitems = list()

/obj/machinery/reagent_refinery/grinder/Initialize(mapload)
	. = ..()
	default_apply_parts()
	// Can't be set on these
	src.verbs -= /obj/machinery/reagent_refinery/verb/set_APTFT
	// Update neighbours and self for state
	update_neighbours()
	update_icon()

/obj/machinery/reagent_refinery/grinder/attackby(var/obj/item/O as obj, var/mob/user as mob)
	. = ..()
	if(.)
		return TRUE

	// Insert grindables if not handled by parent proc
	if(holdingitems && holdingitems.len >= limit)
		to_chat(user, "The machine cannot hold anymore items.")
		return TRUE

	if(istype(O,/obj/item/storage/bag/plants))
		var/obj/item/storage/bag/plants/bag = O
		var/failed = 1
		for(var/obj/item/G in O.contents)
			if(!G.reagents || !G.reagents.total_volume)
				continue
			failed = 0
			bag.remove_from_storage(G, src)
			holdingitems += G
			if(holdingitems && holdingitems.len >= limit)
				break

		if(failed)
			to_chat(user, "Nothing in the plant bag is usable.")
			return 1

		if(!O.contents.len)
			to_chat(user, "You empty \the [O] into \the [src].")
		else
			to_chat(user, "You fill \the [src] from \the [O].")
		return FALSE

	if(istype(O,/obj/item/gripper))
		var/obj/item/gripper/B = O	//B, for Borg.
		if(!B.wrapped)
			to_chat(user, "\The [B] is not holding anything.")
			return FALSE
		else
			var/B_held = B.wrapped
			to_chat(user, "You use \the [B] to load \the [src] with \the [B_held].")
		return FALSE

	if(!global.sheet_reagents[O.type] && !global.ore_reagents[O.type] && (!O.reagents || !O.reagents.total_volume))
		to_chat(user, "\The [O] is not suitable for blending.")
		return FALSE

	user.drop_from_inventory(O,src)
	holdingitems += O
	return TRUE

/obj/machinery/reagent_refinery/grinder/process()
	if(!anchored)
		return

	power_change()
	if(stat & (NOPOWER|BROKEN))
		return

	if(holdingitems.len > 0 && process_contents())
		//Lazy coder sound design moment. THE SEQUEL
		playsound(src, 'sound/items/poster_being_created.ogg', 50, 1)
		playsound(src, 'sound/items/electronic_assembly_emptying.ogg', 50, 1)
		playsound(src, 'sound/effects/metalscrape2.ogg', 50, 1)

	if (amount_per_transfer_from_this <= 0 || reagents.total_volume <= 0)
		return

	// dump reagents to next refinery machine
	var/obj/machinery/reagent_refinery/target = locate(/obj/machinery/reagent_refinery) in get_step(loc,dir)
	if(target)
		transfer_tank( reagents, target, dir)

/obj/machinery/reagent_refinery/grinder/update_icon()
	cut_overlays()
	var/image/pipe = image(icon, icon_state = "grinder_cons", dir = dir)
	add_overlay(pipe)
	if(stat & (NOPOWER|BROKEN) || !anchored)
		icon_state = "grinder_off"
	else
		icon_state = "grinder_on"
		var/image/dot = image(icon, icon_state = "grinder_dot_[ beaker.amount_per_transfer_from_this > 0 ? "on" : "off" ]")
		add_overlay(dot)

/obj/machinery/reagent_refinery/grinder/Bumped(atom/movable/AM as mob|obj)
	. = ..()
	if(!anchored)
		return
	if(!AM || QDELETED(AM))
		return
	if(holdingitems.len >= limit)
		return
	if(ismob(AM)) // No mob bumping YET
		return
	if(!global.sheet_reagents[AM.type] && !global.ore_reagents[AM.type] && (!AM.reagents || !AM.reagents.total_volume)) // Outpost 21 edit - globalized grinding list
		return

	AM.forceMove(src)
	holdingitems += AM

/obj/machinery/reagent_refinery/grinder/verb/rotate_clockwise()
	set name = "Rotate Grinder Clockwise"
	set category = "Object"
	set src in view(1)

	if (usr.stat || usr.restrained() || anchored)
		return

	src.set_dir(turn(src.dir, 270))
	update_icon()

/obj/machinery/reagent_refinery/grinder/verb/rotate_counterclockwise()
	set name = "Rotate Grinder Counterclockwise"
	set category = "Object"
	set src in view(1)

	if (usr.stat || usr.restrained() || anchored)
		return

	src.set_dir(turn(src.dir, 90))
	update_icon()

/obj/machinery/reagent_refinery/grinder/examine(mob/user, infix, suffix)
	. = ..()
	. += "The intake cache shows [holdingitems.len] / [limit] grindable items."
	. += "The meter shows [reagents.total_volume]u / [reagents.maximum_volume]u. It is pumping chemicals at a rate of [amount_per_transfer_from_this]u."

/obj/machinery/reagent_refinery/grinder/handle_transfer(var/atom/origin_machine, var/datum/reagents/RT, var/source_forward_dir, var/filter_id = "")
	// Grinder forbids input
	return 0

/obj/machinery/reagent_refinery/grinder/proc/process_contents()
