/obj/machinery/floorlayer
	name = "automatic floor layer"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "pipe_d"
	density = TRUE
	var/turf/old_turf
	var/on = 0
	var/obj/item/stack/tile/T
	var/list/mode = list("dismantle"=0,"laying"=0,"collect"=0)

/obj/machinery/floorlayer/New()
	T = new/obj/item/stack/tile/floor(src)
	..()

/obj/machinery/floorlayer/Moved(atom/old_loc, direction, forced = FALSE)
	. = ..()

	if(on)
		if(mode["dismantle"])
			dismantleFloor(old_turf)

		if(mode["laying"])
			layFloor(old_turf)

		if(mode["collect"])
			CollectTiles(old_turf)


	old_turf = loc

/obj/machinery/floorlayer/attack_hand(mob/user as mob)
	on=!on
	user.visible_message(span_notice("[user] has [!on?"de":""]activated \the [src]."), span_notice("You [!on?"de":""]activate \the [src]."))
	return

/obj/machinery/floorlayer/attackby(var/obj/item/W as obj, var/mob/user as mob)
	if(W.has_tool_quality(TOOL_WRENCH))
		var/m = tgui_input_list(usr, "Choose work mode", "Mode", mode)
		mode[m] = !mode[m]
		var/O = mode[m]
		user.visible_message(span_notice("[usr] has set \the [src] [m] mode [!O?"off":"on"]."), span_notice("You set \the [src] [m] mode [!O?"off":"on"]."))
		return

	if(istype(W, /obj/item/stack/tile))
		to_chat(user, span_notice("\The [W] successfully loaded."))
		user.drop_item(T)
		TakeTile(T)
		return

	if(W.has_tool_quality(TOOL_CROWBAR))
		if(!length(contents))
			to_chat(user, span_notice("\The [src] is empty."))
		else
			var/obj/item/stack/tile/E = tgui_input_list(usr, "Choose remove tile type.", "Tiles", contents)
			if(E)
				to_chat(user, span_notice("You remove the [E] from \the [src]."))
				E.loc = src.loc
				T = null
		return

	if(W.has_tool_quality(TOOL_SCREWDRIVER))
		T = tgui_input_list(usr, "Choose tile type.", "Tiles", contents)
		return
	..()

/obj/machinery/floorlayer/examine(mob/user)
	. = ..()
	var/dismantle = mode["dismantle"]
	var/laying = mode["laying"]
	var/collect = mode["collect"]
	. += span_notice("[src] [!T ? "don't " : ""]has [!T ? "" : "[T.get_amount()] [T] "]tile\s, dismantle is [dismantle ? "on" : "off"], laying is [laying ? "on" : "off"], collect is [collect ? "on" : "off"].")

/obj/machinery/floorlayer/proc/reset()
	on=0
	return

/obj/machinery/floorlayer/proc/dismantleFloor(var/turf/new_turf)
	if(istype(new_turf, /turf/simulated/floor))
		var/turf/simulated/floor/T = new_turf
		if(!T.is_plating())
			T.make_plating(!(T.broken || T.burnt))
	return new_turf.is_plating()

/obj/machinery/floorlayer/proc/TakeNewStack()
	for(var/obj/item/stack/tile/tile in contents)
		T = tile
		return 1
	return 0

/obj/machinery/floorlayer/proc/SortStacks()
	for(var/obj/item/stack/tile/tile1 in contents)
		for(var/obj/item/stack/tile/tile2 in contents)
			tile2.transfer_to(tile1)

/obj/machinery/floorlayer/proc/layFloor(var/turf/w_turf)
	if(!T)
		if(!TakeNewStack())
			return 0
	w_turf.attackby(T , src)
	return 1

/obj/machinery/floorlayer/proc/TakeTile(var/obj/item/stack/tile/tile)
	if(!T)	T = tile
	tile.loc = src

	SortStacks()

/obj/machinery/floorlayer/proc/CollectTiles(var/turf/w_turf)
	for(var/obj/item/stack/tile/tile in w_turf)
		TakeTile(tile)
