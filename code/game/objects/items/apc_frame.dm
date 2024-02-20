// APC HULL

/obj/item/frame/apc
	name = "\improper APC frame"
	desc = "Used for repairing or building APCs"
	icon = 'icons/obj/apc_repair.dmi'
	icon_state = "apc_frame"
	refund_amt = 2
	build_wall_only = TRUE
	matter = list(MAT_STEEL = 100, MAT_GLASS = 30)

/obj/item/frame/apc/try_build(turf/on_wall, mob/user as mob)
	if (get_dist(on_wall, user)>1)
		return
	var/ndir = get_dir(user, on_wall)
	if (!(ndir in cardinal))
		return
	var/turf/loc = get_turf(user)
	var/area/A = loc.loc
	if (!istype(loc, /turf/simulated/floor))
		to_chat(user, "<span class='warning'>APC cannot be placed on this spot.</span>")
		return
	if (A.requires_power == 0 || istype(A, /area/space))
		to_chat(user, "<span class='warning'>APC cannot be placed in this area.</span>")
		return
	if (A.get_apc())
		to_chat(user, "<span class='warning'>This area already has an APC.</span>")
		return //only one APC per area
	for(var/obj/machinery/power/terminal/T in loc)
		if (T.master)
			to_chat(user, "<span class='warning'>There is another network terminal here.</span>")
			return
		else
			new /obj/item/stack/cable_coil(loc, 10)
			to_chat(user, "You cut the cables and disassemble the unused power terminal.")
			qdel(T)
	new /obj/machinery/power/apc(loc, ndir, 1)
	qdel(src)
