/obj/structure/vehiclecage
	name = "vehicle cage"
	desc = "A large metal lattice that seems to exist solely to annoy consumers."
	icon = 'icons/obj/storage.dmi'
	icon_state = "vehicle_cage"
	density = TRUE
	var/obj/vehicle/my_vehicle
	var/my_vehicle_type
	var/paint_color = "#666666"

/obj/structure/vehiclecage/examine(mob/user)
	. = ..()
	if(my_vehicle)
		. += "<span class='notice'>It seems to contain \the [my_vehicle].</span>"

/obj/structure/vehiclecage/Initialize()
	. = ..()
	if(my_vehicle_type)
		my_vehicle = new my_vehicle_type(src)
		for(var/obj/I in get_turf(src))
			if(I.density || I.anchored || I == src || !I.simulated || !istype(I, my_vehicle_type))
				continue
			load_vehicle(I)
	update_icon()

/obj/structure/vehiclecage/attack_hand(mob/user as mob)
	to_chat(user, "<span class='notice'>You need a wrench to take this apart!</span>")
	return

/obj/structure/vehiclecage/attackby(obj/item/W as obj, mob/user as mob)
	var/turf/T = get_turf(src)
	if(!T)
		to_chat(user, "<span class='notice'>You can't open this here!</span>")
	if(W.has_tool_quality(TOOL_WRENCH) && do_after(user, 60 * W.toolspeed, src))
		playsound(src, W.usesound, 50, 1)
		disassemble(W, user)
		user.visible_message("<span class='notice'>[user] begins loosening \the [src]'s bolts.</span>")
	if(W.has_tool_quality(TOOL_WIRECUTTER) && do_after(user, 70 * W.toolspeed, src))
		playsound(src, W.usesound, 50, 1)
		disassemble(W, user)
		user.visible_message("<span class='notice'>[user] begins cutting \the [src]'s bolts.</span>")
	else
		return attack_hand(user)

/obj/structure/vehiclecage/update_icon()
	..()
	cut_overlays()
	underlays.Cut()

	var/image/framepaint = new(icon = 'icons/obj/storage.dmi', icon_state = "[initial(icon_state)]_a", layer = MOB_LAYER + 1.1)
	framepaint.plane = MOB_PLANE
	framepaint.color = paint_color
	add_overlay(framepaint)

	for(var/obj/vehicle/V in src.contents)
		var/image/showcase = new(V)
		showcase.layer = src.layer - 0.1
		underlays += showcase

/obj/structure/vehiclecage/MouseDrop_T(var/atom/movable/C, mob/user as mob)
	if(user && (user.buckled || user.stat || user.restrained() || !Adjacent(user) || !user.Adjacent(C)))
		return

	var/obj/vehicle/V
	if(istype(C, /obj/vehicle))
		V = C
	if(!V)
		return

	if(!my_vehicle)
		load_vehicle(V, user)

/obj/structure/vehiclecage/proc/load_vehicle(var/obj/vehicle/V, mob/user as mob)
	if(user)
		user.visible_message("<span class='notice'>[user] loads \the [V] into \the [src].</span>", \
							 "<span class='notice'>You load \the [V] into \the [src].</span>", \
							 "<span class='notice'>You hear creaking metal.</span>")

	V.forceMove(src)

	paint_color = V.paint_color

	update_icon()

/obj/structure/vehiclecage/proc/disassemble(obj/item/W as obj, mob/user as mob)
	var/turf/T = get_turf(src)
	new /obj/item/stack/material/steel(src.loc, 5)

	for(var/atom/movable/AM in contents)
		if(AM.simulated)
			AM.forceMove(T)

	my_vehicle = null
	user.visible_message("<span class='notice'>[user] release \the [src].</span>", \
						 "<span class='notice'>You finally release \the [src].</span>", \
						 "<span class='notice'>You hear creaking metal.</span>")
	qdel(src)

/obj/structure/vehiclecage/spacebike
	my_vehicle_type = /obj/vehicle/bike/random

/obj/structure/vehiclecage/quadbike
	my_vehicle_type = /obj/vehicle/train/engine/quadbike/random

/obj/structure/vehiclecage/quadtrailer
	my_vehicle_type = /obj/vehicle/train/trolley/trailer/random
