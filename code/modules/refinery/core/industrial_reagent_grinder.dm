/obj/machinery/reagentgrinder/industrial
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

/obj/machinery/reagentgrinder/industrial/Initialize(mapload)
	. = ..()
	// custom amounts to match reagent vat machines
	beaker.possible_transfer_amounts = REFINERY_DEFAULT_TRANSFER_AMOUNTS
	// remove these
	verbs -= /obj/machinery/reagentgrinder/verb/grind_verb
	verbs -= /obj/machinery/reagentgrinder/verb/remove_beaker
	// Update neighbours and self for state
	update_neighbours()
	update_icon()

/obj/machinery/reagentgrinder/industrial/update_icon()
	overlays.Cut()
	var/image/pipe = image(icon, icon_state = "grinder_cons", dir = dir)
	add_overlay(pipe)
	if(stat & (NOPOWER|BROKEN) || !anchored)
		icon_state = "grinder_off"
	else
		icon_state = "grinder_on"
		var/image/dot = image(icon, icon_state = "grinder_dot_[ beaker.amount_per_transfer_from_this > 0 ? "on" : "off" ]")
		add_overlay(dot)
	return

/obj/machinery/reagentgrinder/industrial/proc/update_neighbours()
	// Update icons and neighbour icons to avoid loss of sanity
	for(var/direction in GLOB.cardinal)
		var/turf/T = get_step(get_turf(src),direction)
		var/obj/machinery/other = locate(/obj/machinery/reagent_refinery) in T
		if(other && other.anchored)
			other.update_icon()

/obj/machinery/reagentgrinder/industrial/process()
	if(!anchored || !beaker)
		return

	power_change()
	if(stat & (NOPOWER|BROKEN))
		return

	if(holdingitems.len > 0 && process_contents())
		//Lazy coder sound design moment. THE SEQUEL code\modules\recycling\v_garbosystem.dm
		playsound(src, 'sound/items/poster_being_created.ogg', 50, 1)
		playsound(src, 'sound/items/electronic_assembly_emptying.ogg', 50, 1)
		playsound(src, 'sound/effects/metalscrape2.ogg', 50, 1)

	if (beaker.amount_per_transfer_from_this <= 0 || beaker.reagents.total_volume <= 0)
		return

	// dump reagents to next refinery machine
	var/obj/machinery/reagent_refinery/M = locate(/obj/machinery/reagent_refinery) in get_step(loc,dir)
	if(M)
		transfer_tank( beaker.reagents, M, dir)

/obj/machinery/reagentgrinder/industrial/proc/transfer_tank( var/datum/reagents/RT, var/obj/machinery/reagent_refinery/target, var/source_forward_dir, var/filter_id = "")
	if(RT.total_volume <= 0 || !anchored || !target.anchored)
		return 0
	if(active_power_usage > 0 && !can_use_power_oneoff(active_power_usage))
		return 0
	if(!istype(target,/obj/machinery/reagent_refinery)) // cannot transfer into grinders anyway, so it's fine to do it this way.
		return 0
	var/transfered = target.handle_transfer(src,RT,source_forward_dir,filter_id)
	if(transfered > 0 && active_power_usage > 0)
		use_power_oneoff(active_power_usage)
	return transfered

/obj/machinery/reagentgrinder/industrial/Moved(atom/old_loc, direction, forced)
	. = ..()
	update_icon()

// Forward to the beaker directly instead of copypasting code
/obj/machinery/reagentgrinder/industrial/verb/set_APTFT()
	PRIVATE_PROC(TRUE)
	set name = "Set transfer amount"
	set category = "Object"
	set src in view(1)
	// durpy adjacency hack, uses old value if you walk away from it without setting
	// I don't want to edit reagent code if I can avoid it, or make a snowflake in reagent containers.
	var/old = beaker.amount_per_transfer_from_this
	beaker.set_APTFT()
	if(!Adjacent(usr))
		beaker.amount_per_transfer_from_this = old
	update_icon()

/obj/machinery/reagentgrinder/industrial/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(O.has_tool_quality(TOOL_WRENCH))
		playsound(src, O.usesound, 75, 1)
		anchored = !anchored
		user.visible_message("[user.name] [anchored ? "secures" : "unsecures"] the bolts holding [src.name] to the floor.", \
					"You [anchored ? "secure" : "unsecure"] the bolts holding [src] to the floor.", \
					"You hear a ratchet.")
		// Update icons and neighbour icons to avoid loss of sanity
		for(var/direction in GLOB.cardinal)
			var/turf/T = get_step(get_turf(src),direction)
			var/obj/machinery/other = locate(/obj/machinery/reagent_refinery) in T
			if(other && other.anchored)
				other.update_icon()
		update_icon()
		return

	if(istype(O,/obj/item/reagent_containers/glass) || \
		istype(O,/obj/item/reagent_containers/food/drinks/glass2) || \
		istype(O,/obj/item/reagent_containers/food/drinks/shaker))
		// Transfer FROM internal beaker to this.
		if (!beaker || beaker.reagents.total_volume <= 0)
			to_chat(usr,"\The [src] is empty. There is nothing to drain into \the [O].")
			return
		// Fill up the whole volume if we can, DUMP IT OUT
		var/obj/item/reagent_containers/C = O
		beaker.reagents.trans_to_obj(C, beaker.reagents.total_volume)
		playsound(src, 'sound/machines/reagent_dispense.ogg', 25, 1)
		to_chat(usr,"You drain \the [src] into \the [C].")
		return

	. = ..()

/obj/machinery/reagentgrinder/industrial/Bumped(atom/movable/AM as mob|obj)
	. = ..()
	if(!anchored)
		return
	if(!AM || QDELETED(AM))
		return
	if(holdingitems.len >= limit)
		return
	if(ismob(AM)) // No mob bumping YET - Outpost 21 TODO
		return
	if(!global.sheet_reagents[AM.type] && !global.ore_reagents[AM.type] && (!AM.reagents || !AM.reagents.total_volume)) // Outpost 21 edit - globalized grinding list
		return

	AM.forceMove(src)
	holdingitems += AM

	if(istype(AM,/obj/item/stack/material/supermatter))
		var/obj/item/stack/material/supermatter/S = AM
		set_light(l_range = max(1, S.get_amount()/10), l_power = max(1, S.get_amount()/10), l_color = "#8A8A00")
		addtimer(CALLBACK(src, PROC_REF(puny_protons)), 30 SECONDS)

/obj/machinery/reagentgrinder/industrial/verb/rotate_clockwise()
	set name = "Rotate Grinder Clockwise"
	set category = "Object"
	set src in view(1)

	if (usr.stat || usr.restrained() || anchored)
		return

	src.set_dir(turn(src.dir, 270))
	update_icon()


/obj/machinery/reagentgrinder/industrial/verb/rotate_counterclockwise()
	set name = "Rotate Grinder Counterclockwise"
	set category = "Object"
	set src in view(1)

	if (usr.stat || usr.restrained() || anchored)
		return

	src.set_dir(turn(src.dir, 90))
	update_icon()

// Disabled actions
/obj/machinery/reagentgrinder/industrial/examine(mob/user)
	. = ..() // Outpost 21 edit - Does not call parent?
	. = list(initial(desc)) // Clears the parent's messy stuff
	if(beaker)
		. += "The meter shows [beaker.reagents.total_volume]u / [beaker.reagents.maximum_volume]u. It is pumping chemicals at a rate of [beaker.amount_per_transfer_from_this]u."

/obj/machinery/reagentgrinder/industrial/grind(var/mob/user)
	return

/obj/machinery/reagentgrinder/industrial/AltClick(var/mob/user)
	return

/obj/machinery/reagentgrinder/industrial/attack_hand(var/mob/user)
	return
