/obj/structure/catwalk
	name = "catwalk"
	desc = "Cats really don't like these things."
	icon = 'icons/turf/catwalks.dmi'
	icon_state = "catwalk"
	plane = DECAL_PLANE
	layer = ABOVE_UTILITY
	density = 0
	anchored = 1.0
	var/hatch_open = FALSE
	var/plating_color = null
	var/obj/item/stack/tile/plated_tile = null
	var/static/plating_colors = list(
		/obj/item/stack/tile/floor = "#858a8f",
		/obj/item/stack/tile/floor/dark = "#4f4f4f",
		/obj/item/stack/tile/floor/white = "#e8e8e8")
	var/health = 100
	var/maxhealth = 100

/obj/structure/catwalk/Initialize()
	. = ..()
	for(var/obj/structure/catwalk/C in get_turf(src))
		if(C != src)
			qdel(C)
	update_connections(1)
	update_icon()


/obj/structure/catwalk/Destroy()
	redraw_nearby_catwalks()
	update_falling()
	return ..()

/obj/structure/catwalk/proc/update_falling()
	spawn(1) //We get called in Destroy() and things. We might not be gone yet, so let's just put this off.
		if(istype(loc, /turf/simulated/open))
			var/turf/simulated/open/O = loc
			O.update() //Will cause anything on the open turf to fall if it should

/obj/structure/catwalk/proc/redraw_nearby_catwalks()
	for(var/direction in alldirs)
		var/obj/structure/catwalk/L = locate() in get_step(src, direction)
		if(L)
			L.update_connections()
			L.update_icon() //so siding get updated properly

/obj/structure/catwalk/update_icon()
	update_connections()
	cut_overlays()
	icon_state = ""
	var/image/I
	if(!hatch_open)
		for(var/i = 1 to 4)
			I = image(icon, "catwalk[connections[i]]", dir = 1<<(i-1))
			add_overlay(I)
	if(plating_color)
		I = image(icon, "plated")
		I.color = plating_color
		add_overlay(I)

/obj/structure/catwalk/ex_act(severity)
	switch(severity)
		if(1)
			new /obj/item/stack/rods(src.loc)
			qdel(src)
		if(2)
			new /obj/item/stack/rods(src.loc)
			qdel(src)

/obj/structure/catwalk/attack_robot(var/mob/user)
	if(Adjacent(user))
		attack_hand(user)

/obj/structure/catwalk/proc/deconstruct(mob/user)
	playsound(src, 'sound/items/Welder.ogg', 100, 1)
	to_chat(user, "<span class='notice'>Slicing \the [src] joints ...</span>")
	new /obj/item/stack/rods(src.loc)
	new /obj/item/stack/rods(src.loc)
	//Lattice would delete itself, but let's save ourselves a new obj
	if(isspace(loc) || isopenspace(loc))
		new /obj/structure/lattice/(src.loc)
	if(plated_tile)
		new plated_tile(src.loc)
	qdel(src)

/obj/structure/catwalk/attackby(obj/item/C as obj, mob/user as mob)
	if(istype(C, /obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/WT = C
		if(WT.isOn() && WT.remove_fuel(0, user))
			deconstruct(user)
			return
	if(C.is_crowbar() && plated_tile)
		hatch_open = !hatch_open
		if(hatch_open)
			playsound(src, 'sound/items/Crowbar.ogg', 100, 2)
			to_chat(user, "<span class='notice'>You pry open \the [src]'s maintenance hatch.</span>")
			update_falling()
		else
			playsound(src, 'sound/items/Deconstruct.ogg', 100, 2)
			to_chat(user, "<span class='notice'>You shut \the [src]'s maintenance hatch.</span>")
		update_icon()
		return
	if(istype(C, /obj/item/stack/tile/floor) && !plated_tile)
		var/obj/item/stack/tile/floor/ST = C
		to_chat(user, "<span class='notice'>Placing tile...</span>")
		if (!do_after(user, 10))
			return
		if(!ST.use(1))
			return
		to_chat(user, "<span class='notice'>You plate \the [src]</span>")
		name = "plated catwalk"
		plated_tile = C.type
		src.add_fingerprint(user)
		for(var/tiletype in plating_colors)
			if(istype(ST, tiletype))
				plating_color = plating_colors[tiletype]
		update_icon()

/obj/structure/catwalk/refresh_neighbors()
	return

/obj/structure/catwalk/take_damage(amount)
	health -= amount
	if(health <= 0)
		visible_message("<span class='warning'>\The [src] breaks down!</span>")
		playsound(src, 'sound/effects/grillehit.ogg', 50, 1)
		new /obj/item/stack/rods(get_turf(src))
		Destroy()

/obj/structure/catwalk/Crossed()
	. = ..()
	if(isliving(usr) && !usr.is_incorporeal())
		playsound(src, pick('sound/effects/footstep/catwalk1.ogg', 'sound/effects/footstep/catwalk2.ogg', 'sound/effects/footstep/catwalk3.ogg', 'sound/effects/footstep/catwalk4.ogg', 'sound/effects/footstep/catwalk5.ogg'), 25, 1)

/obj/effect/catwalk_plated
	name = "plated catwalk spawner"
	icon = 'icons/turf/catwalks.dmi'
	icon_state = "catwalk_plated"
	density = 1
	anchored = 1.0
	var/activated = FALSE
	plane = DECAL_PLANE
	layer = ABOVE_UTILITY
	var/tile = /obj/item/stack/tile/floor
	var/platecolor = "#858a8f"

/obj/effect/catwalk_plated/Initialize(mapload)
	. = ..()
	activate()

/obj/effect/catwalk_plated/CanPass()
	return 0

/obj/effect/catwalk_plated/attack_hand()
	attack_generic()

/obj/effect/catwalk_plated/attack_ghost()
	attack_generic()

/obj/effect/catwalk_plated/attack_generic()
	activate()

/obj/effect/catwalk_plated/proc/activate()
	if(activated) return

	if(locate(/obj/structure/catwalk) in loc)
		warning("Frame Spawner: A catwalk already exists at [loc.x]-[loc.y]-[loc.z]")
	else
		var/obj/structure/catwalk/C = new /obj/structure/catwalk(loc)
		C.plated_tile = tile
		C.plating_color = platecolor
		C.name = "plated catwalk"
		C.update_icon()
	activated = 1
	/* We don't have wallframes - yet
	for(var/turf/T in orange(src, 1))
		for(var/obj/effect/wallframe_spawn/other in T)
			if(!other.activated) other.activate()
	*/
	qdel(src)

/obj/effect/catwalk_plated/dark
	icon_state = "catwalk_plateddark"
	tile = /obj/item/stack/tile/floor/dark
	platecolor = "#4f4f4f"

/obj/effect/catwalk_plated/white
	icon_state = "catwalk_platedwhite"
	tile = /obj/item/stack/tile/floor/white
	platecolor = "#e8e8e8"
