/obj/machinery/reagent_refinery/grinder
	name = "Industrial Chemical Grinder"
	desc = "Grinds anything and everything into chemical slurry."
	icon_state = "grinder_off"
	density = TRUE
	anchored = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 5
	active_power_usage = 300
	circuit = /obj/item/circuitboard/industrial_reagent_grinder
	var/static/limit = 50
	VAR_PRIVATE/list/holdingitems = list()

/obj/machinery/reagent_refinery/grinder/Initialize(mapload)
	. = ..()
	default_apply_parts()
	// Can't be set on these
	src.verbs -= /obj/machinery/reagent_refinery/verb/set_APTFT
	// Update neighbours and self for state
	update_neighbours()
	update_icon()

/obj/machinery/reagent_refinery/grinder/Destroy()
	for(var/obj/O in holdingitems)
		O.forceMove(get_turf(src))
	holdingitems.Cut()
	. = ..()

/obj/machinery/reagent_refinery/grinder/attackby(var/obj/item/O as obj, var/mob/user as mob)
	. = ..()
	if(.)
		return

	// Insert grindables if not handled by parent proc
	if(holdingitems && holdingitems.len >= limit)
		to_chat(user, "The machine cannot hold anymore items.")
		return FALSE

	// Botany/Chemistry gameplay
	if(istype(O,/obj/item/storage/bag))
		var/obj/item/storage/bag/bag = O
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
			to_chat(user, "Nothing in \the [O] is usable.")
			return 1

		if(!O.contents.len)
			to_chat(user, "You empty \the [O] into \the [src].")
		else
			to_chat(user, "You fill \the [src] from \the [O].")
		return FALSE

	// Borgos!
	if(istype(O,/obj/item/gripper))
		var/obj/item/gripper/B = O	//B, for Borg.
		var/obj/item/wrapped = B.get_wrapped_item()
		if(!wrapped)
			to_chat(user, "\The [B] is not holding anything.")
			return FALSE
		else
			var/B_held = wrapped
			to_chat(user, "You use \the [B] to load \the [src] with \the [B_held].")
		return FALSE

	// Needs to be sheet, ore, or grindable reagent containing things
	if(istype(O,/obj/item/tool)) // Stops messages about the wrench being unsuitable to grind
		return FALSE
	if(!GLOB.sheet_reagents[O.type] && !GLOB.ore_reagents[O.type] && (!O.reagents || !O.reagents.total_volume))
		to_chat(user, "\The [O] is not suitable for blending.")
		return FALSE

	user.drop_from_inventory(O,src)
	holdingitems += O
	update_icon()
	return TRUE

/obj/machinery/reagent_refinery/grinder/process()
	if(!anchored)
		return

	power_change()
	if(stat & (NOPOWER|BROKEN))
		return

	// Get objects from incoming conveyors
	if(holdingitems.len < limit)
		for(var/D in GLOB.cardinal)
			var/turf/T = get_step(src,D)
			if(!T)
				continue
			var/obj/machinery/conveyor/C = locate() in T
			if(C && !C.stat && C.operating && C.dir == GLOB.reverse_dir[D] && T.contents.len > 1) // If an operating conveyor points into us... Check if it's moving anything
				var/obj/item/I = pick(T.contents - list(C))
				if(istype(I) && conveyor_load(I))
					break

	if(holdingitems.len > 0 && grind_items_to_reagents(holdingitems,reagents))
		//Lazy coder sound design moment. THE SEQUEL
		playsound(src, 'sound/items/poster_being_created.ogg', 50, 1)
		playsound(src, 'sound/items/electronic_assembly_emptying.ogg', 50, 1)
		playsound(src, 'sound/effects/metalscrape2.ogg', 50, 1)
		if(holdingitems.len == 0)
			update_icon()

	refinery_transfer()

/obj/machinery/reagent_refinery/grinder/update_icon()
	cut_overlays()
	var/image/pipe = image(icon, icon_state = "grinder_cons", dir = dir)
	add_overlay(pipe)
	if(stat & (NOPOWER|BROKEN) || !anchored)
		icon_state = "grinder_off"
	else
		icon_state = "grinder_on"
		var/image/dot = image(icon, icon_state = "grinder_dot_[holdingitems.len ? "on" : "off" ]")
		add_overlay(dot)

/obj/machinery/reagent_refinery/grinder/proc/conveyor_load(atom/movable/AM as mob|obj)
	if(!AM || QDELETED(AM))
		return FALSE
	if(holdingitems.len >= limit)
		return FALSE
	if(ismob(AM)) // No mob bumping YET
		return FALSE
	if(!GLOB.sheet_reagents[AM.type] && !GLOB.ore_reagents[AM.type] && (!AM.reagents || !AM.reagents.total_volume))
		return FALSE
	AM.forceMove(src)
	holdingitems += AM
	return TRUE

/obj/machinery/reagent_refinery/grinder/examine(mob/user, infix, suffix)
	. = ..()
	. += "The intake cache shows [holdingitems.len] / [limit] grindable items."
	. += "The meter shows [reagents.total_volume]u / [reagents.maximum_volume]u. It is pumping chemicals at a rate of [amount_per_transfer_from_this]u."
	tutorial(REFINERY_TUTORIAL_NOINPUT, .)

/obj/machinery/reagent_refinery/grinder/handle_transfer(var/atom/origin_machine, var/datum/reagents/RT, var/source_forward_dir, var/transfer_rate, var/filter_id = "")
	// Grinder forbids input
	return 0
