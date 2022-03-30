/obj/machinery/pipelayer
	name = "automatic pipe layer"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "pipe_d"
	density = TRUE
	circuit = /obj/item/weapon/circuitboard/pipelayer
	var/turf/old_turf		// Last turf we were on.
	var/old_dir				// Last direction we were facing.
	var/on = 0				// Pipelaying online?
	var/a_dis = 0			// Auto-dismantling - If enabled it will remove floor tiles
	var/P_type = null		// Currently selected pipe type
	var/P_type_t = ""		// Name of currently selected pipe type
	var/max_metal = 50		// Max capacity for internal metal storage
	var/metal = 0			// Current amount in internal metal storage
	var/pipe_cost = 0.25	// Cost in steel for each pipe.
	var/obj/item/weapon/tool/wrench/W // Internal wrench used for wrenching down the pipes
	var/list/Pipes = list(
		"regular pipes" = /obj/machinery/atmospherics/pipe/simple,
		"scrubbers pipes" = /obj/machinery/atmospherics/pipe/simple/hidden/scrubbers,
		"supply pipes" = /obj/machinery/atmospherics/pipe/simple/hidden/supply,
		"heat exchange pipes" = /obj/machinery/atmospherics/pipe/simple/heat_exchanging
	)

/obj/machinery/pipelayer/New()
	W = new(src)
	..()
	default_apply_parts()
	update_icon()

/obj/machinery/pipelayer/Destroy()
	QDEL_NULL(W)
	. = ..()

/obj/machinery/pipelayer/RefreshParts()
	var/mb_rating = 0
	for(var/obj/item/weapon/stock_parts/matter_bin/M in component_parts)
		mb_rating += M.rating
	max_metal = mb_rating * initial(max_metal)

/obj/machinery/pipelayer/dismantle()
	eject_metal()
	..()

// Whenever we move, if enabled try and lay pipe
/obj/machinery/pipelayer/Moved(atom/old_loc, direction, forced = FALSE)
	. = ..()

	if(on && a_dis)
		dismantleFloor(old_turf)
	layPipe(old_turf, direction, old_dir)

	old_turf = loc
	old_dir = turn(direction, 180)

/obj/machinery/pipelayer/attack_hand(mob/user as mob)
	if(..())
		return
	if(panel_open)
		if(metal < 1)
			to_chat(user, "\The [src] is empty.")
			return
		var/answer = tgui_alert(user, "Do you want to eject all the metal in \the [src]?", "Eject?", list("Yes","No"))
		if(answer == "Yes")
			var/amount_ejected = eject_metal()
			user.visible_message("<span class='notice'>[user] removes [amount_ejected] sheet\s of [MAT_STEEL] from the \the [src].</span>",
				"<span class='notice'>You remove [amount_ejected] sheet\s of [MAT_STEEL] from \the [src].</span>")
		return
	if(!metal && !on)
		to_chat(user, "<span class='warning'>\The [src] doesn't work without metal.</span>")
		return
	on = !on
	old_turf = get_turf(src)
	old_dir = dir
	user.visible_message("<span class='notice'>[user] has [!on?"de":""]activated \the [src].</span>", "<span class='notice'>You [!on?"de":""]activate \the [src].</span>")
	return

/obj/machinery/pipelayer/attackby(var/obj/item/W as obj, var/mob/user as mob)
	if(default_deconstruction_screwdriver(user, W))
		return
	if(default_deconstruction_crowbar(user, W))
		return
	if(default_part_replacement(user, W))
		return
	if (!panel_open && W.is_wrench())
<<<<<<< HEAD
		P_type_t = tgui_input_list(usr, "Choose pipe type", "Pipe type", Pipes)
=======
		P_type_t = input("Choose pipe type", "Pipe type") as null|anything in Pipes
>>>>>>> 50c97504321... Merge pull request #8491 from Atermonera/revert_tool_qualities
		P_type = Pipes[P_type_t]
		user.visible_message("<span class='notice'>[user] has set \the [src] to manufacture [P_type_t].</span>", "<span class='notice'>You set \the [src] to manufacture [P_type_t].</span>")
		return
	if(!panel_open && W.is_crowbar())
		a_dis = !a_dis
		user.visible_message("<span class='notice'>[user] has [!a_dis?"de":""]activated auto-dismantling.</span>", "<span class='notice'>You [!a_dis?"de":""]activate auto-dismantling.</span>")
		return
	if(istype(W, /obj/item/pipe))
		// NOTE - We must check for matter, otherwise the (free) pipe dispenser can be used to get infinite steel.
		if(!W.matter || W.matter[MAT_STEEL] < pipe_cost * SHEET_MATERIAL_AMOUNT)
			to_chat(user, "<span class='warning'>\The [W] doesn't contain enough [MAT_STEEL] to recycle.</span>")
		else if(metal + pipe_cost > max_metal)
			to_chat(user, "<span class='notice'>\The [src] is full.</span>")
		else
			user.drop_from_inventory(W)
			metal += pipe_cost
			to_chat(user, "<span class='notice'>You recycle \the [W].</span>")
			qdel(W)
		return
	if(istype(W, /obj/item/stack/material) && W.get_material_name() == MAT_STEEL)
		var/result = load_metal(W)
		if(isnull(result))
			to_chat(user, "<span class='warning'>Unable to load [W] - no metal found.</span>")
		else if(!result)
			to_chat(user, "<span class='notice'>\The [src] is full.</span>")
		else
			user.visible_message("<span class='notice'>[user] has loaded metal into \the [src].</span>", "<span class='notice'>You load metal into \the [src]</span>")
		return

	..()

/obj/machinery/pipelayer/examine(mob/user)
	. = ..()
	. += "[src] has [metal] sheet\s, is set to produce [P_type_t], and auto-dismantling is [!a_dis?"de":""]activated."

/obj/machinery/pipelayer/proc/reset()
	on = 0
	return

/obj/machinery/pipelayer/proc/load_metal(var/obj/item/stack/MM)
	if(istype(MM) && MM.get_amount())
		var/cur_amount = metal
		var/to_load = max(max_metal - round(cur_amount),0)
		if(to_load)
			to_load = min(MM.get_amount(), to_load)
			metal += to_load
			MM.use(to_load)
			return to_load
		else
			return 0
	return

/obj/machinery/pipelayer/proc/use_metal(amount)
	if(!metal || metal < amount)
		visible_message("\The [src] deactivates as its metal source depletes.")
		return
	metal -= amount
	return 1

/obj/machinery/pipelayer/proc/eject_metal()
	var/amount_ejected = 0
	while (metal >= 1)
		var/datum/material/M = get_material_by_name(MAT_STEEL)
		var/obj/item/stack/material/S = new M.stack_type(get_turf(src), metal)
		metal -= S.get_amount()
		amount_ejected += S.get_amount()
	return amount_ejected

/obj/machinery/pipelayer/proc/dismantleFloor(var/turf/new_turf)
	if(istype(new_turf, /turf/simulated/floor))
		var/turf/simulated/floor/T = new_turf
		if(!T.is_plating())
			T.make_plating(!(T.broken || T.burnt))
	return new_turf.is_plating()

/obj/machinery/pipelayer/proc/layPipe(var/turf/w_turf,var/M_Dir,var/old_dir)
	if(!on || !(M_Dir in list(NORTH, SOUTH, EAST, WEST)) || M_Dir==old_dir)
		return reset()
	if(!use_metal(pipe_cost))
		return reset()
	var/fdirn = turn(M_Dir, 180)
	var/obj/machinery/atmospherics/p_type = P_type
	var/p_layer = initial(p_type.piping_layer)
	var/p_dir
	if (fdirn!=old_dir)
		p_dir=old_dir+M_Dir
	else
		p_dir=M_Dir

	var/pi_type = initial(p_type.construction_type)
	var/obj/item/pipe/P = new pi_type(w_turf, p_type, p_dir)
	P.setPipingLayer(p_layer)
	// We used metal to make these, so should be reclaimable!
	P.matter = list(MAT_STEEL = pipe_cost * SHEET_MATERIAL_AMOUNT)
	P.attackby(W , src)

	return 1
