/obj/structure/bench
	name = "bench frame"
	icon = 'icons/obj/bench.dmi'
	icon_state = "frame"
	desc = "It's a bench, for putting things on. Or standing on, if you really want to."
	anchored = 1
	layer = 2.8
	throwpass = 1
	var/maxhealth = 10
	var/health = 10

	// For racks.
	var/can_plate = 1

	var/manipulating = 0
	var/material/material = null

	// I'd prefer reinforced with carpet/felt/cloth/whatever, but AFAIK it's either harder or impossible to get /obj/item/stack/material of those.
	// Convert if/when you can easily get stacks of these.
	var/carpeted = 0

	var/list/connections = list("nw0", "ne0", "sw0", "se0")

	standard
		icon_state = "plain_preview"
		color = "#EEEEEE"
		New()
			material = get_material_by_name(DEFAULT_TABLE_MATERIAL)
			..()

	padded
		icon_state = "padded_preview"
		New()
			material = get_material_by_name(DEFAULT_TABLE_MATERIAL)
			carpeted = 1
			..()

/*
/obj/structure/bench/padded
	icon_state = "bench_padded_preview" //set for the map

/obj/structure/bench/New(var/newloc, var/new_material, var/new_padding_material)
	..(newloc)
	if(!new_material)
		new_material = DEFAULT_WALL_MATERIAL
	material = get_material_by_name(new_material)
	if(new_padding_material)
		padding_material = get_material_by_name(new_padding_material)
	if(!istype(material))
		qdel(src)
		return
	update_icon()

/obj/structure/bench/padded/New(var/newloc, var/new_material)
	..(newloc, "steel", "carpet")*/

/obj/structure/bench/proc/update_material()
	var/old_maxhealth = maxhealth
	if(!material)
		maxhealth = 10
	else
		maxhealth = material.integrity / 2

	health += maxhealth - old_maxhealth

/obj/structure/bench/proc/take_damage(amount)
	// If the bench is made of a brittle material, and is *not* reinforced with a non-brittle material, damage is multiplied by TABLE_BRITTLE_MATERIAL_MULTIPLIER
	if(material && material.is_brittle())
		amount *= TABLE_BRITTLE_MATERIAL_MULTIPLIER
	health -= amount
	if(health <= 0)
		visible_message("<span class='warning'>\The [src] breaks down!</span>")
		return break_to_parts() // if we break and form shards, return them to the caller to do !FUN! things with

/obj/structure/bench/initialize()
	..()

	// One bench per turf.
	for(var/obj/structure/bench/T in loc)
		if(T != src)
			// There's another bench here that's not us, break to metal.
			// break_to_parts calls qdel(src)
			break_to_parts(full_return = 1)
			return

	// reset color/alpha, since they're set for nice map previews
	color = "#ffffff"
	alpha = 255
	update_connections(1)
	update_icon()
	update_desc()
	update_material()

/obj/structure/bench/Destroy()
	material = null
	update_connections(1) // Update benchs around us to ignore us (material=null forces no connections)
	for(var/obj/structure/bench/T in oview(src, 1))
		T.update_icon()
	..()

/obj/structure/bench/examine(mob/user)
	. = ..()
	if(health < maxhealth)
		switch(health / maxhealth)
			if(0.0 to 0.5)
				user << "<span class='warning'>It looks severely damaged!</span>"
			if(0.25 to 0.5)
				user << "<span class='warning'>It looks damaged!</span>"
			if(0.5 to 1.0)
				user << "<span class='notice'>It has a few scrapes and dents.</span>"

/obj/structure/bench/attackby(obj/item/weapon/W, mob/user)

	if(carpeted && istype(W, /obj/item/weapon/crowbar))
		user.visible_message("<span class='notice'>\The [user] removes the carpet from \the [src].</span>",
		                              "<span class='notice'>You remove the carpet from \the [src].</span>")
		new /obj/item/stack/tile/carpet(loc)
		carpeted = 0
		update_icon()
		return 1

	if(!carpeted && material && istype(W, /obj/item/stack/tile/carpet))
		var/obj/item/stack/tile/carpet/C = W
		if(C.use(1))
			user.visible_message("<span class='notice'>\The [user] adds \the [C] to \the [src].</span>",
			                              "<span class='notice'>You add \the [C] to \the [src].</span>")
			carpeted = 1
			update_icon()
			return 1
		else
			user << "<span class='warning'>You don't have enough carpet!</span>"

	if(!carpeted && material && istype(W, /obj/item/weapon/wrench))
		remove_material(W, user)
		if(!material)
			update_connections(1)
			update_icon()
			for(var/obj/structure/bench/T in oview(src, 1))
				T.update_icon()
			update_desc()
			update_material()
		return 1

	if(!carpeted && !material && istype(W, /obj/item/weapon/wrench))
		dismantle(W, user)
		return 1

	if(health < maxhealth && istype(W, /obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/F = W
		if(F.welding)
			user << "<span class='notice'>You begin reparing damage to \the [src].</span>"
			playsound(src.loc, 'sound/items/Welder.ogg', 50, 1)
			if(!do_after(user, 20) || !F.remove_fuel(1, user))
				return
			user.visible_message("<span class='notice'>\The [user] repairs some damage to \the [src].</span>",
			                              "<span class='notice'>You repair some damage to \the [src].</span>")
			health = max(health+(maxhealth/5), maxhealth) // 20% repair per application
			return 1

	if(!material && can_plate && istype(W, /obj/item/stack/material))
		material = common_material_add(W, user, "plat")
		if(material)
			update_connections(1)
			update_icon()
			update_desc()
			update_material()
		return 1

	return ..()

/obj/structure/bench/proc/update_desc()
	if(material)
		name = "[material.display_name] bench"
	else
		name = "bench frame"

// Returns the material to set the bench to.
/obj/structure/bench/proc/common_material_add(obj/item/stack/material/S, mob/user, verb) // Verb is actually verb without 'e' or 'ing', which is added. Works for 'plate'/'plating' and 'reinforce'/'reinforcing'.
	var/material/M = S.get_material()
	if(!istype(M))
		user << "<span class='warning'>You cannot [verb]e \the [src] with \the [S].</span>"
		return null

	if(manipulating) return M
	manipulating = 1
	user << "<span class='notice'>You begin [verb]ing \the [src] with [M.display_name].</span>"
	if(!do_after(user, 20) || !S.use(1))
		manipulating = 0
		return null
	user.visible_message("<span class='notice'>\The [user] [verb]es \the [src] with [M.display_name].</span>", "<span class='notice'>You finish [verb]ing \the [src].</span>")
	manipulating = 0
	return M

// Returns the material to set the bench to.
/obj/structure/bench/proc/common_material_remove(mob/user, material/M, delay, what, type_holding, sound)
	if(!M.stack_type)
		user << "<span class='warning'>You are unable to remove the [what] from this bench!</span>"
		return M

	if(manipulating) return M
	manipulating = 1
	user.visible_message("<span class='notice'>\The [user] begins removing the [type_holding] holding \the [src]'s [M.display_name] [what] in place.</span>",
	                              "<span class='notice'>You begin removing the [type_holding] holding \the [src]'s [M.display_name] [what] in place.</span>")
	if(sound)
		playsound(src.loc, sound, 50, 1)
	if(!do_after(user, 40))
		manipulating = 0
		return M
	user.visible_message("<span class='notice'>\The [user] removes the [M.display_name] [what] from \the [src].</span>",
	                              "<span class='notice'>You remove the [M.display_name] [what] from \the [src].</span>")
	new M.stack_type(src.loc)
	manipulating = 0
	return null

/obj/structure/bench/proc/remove_material(obj/item/weapon/wrench/W, mob/user)
	material = common_material_remove(user, material, 20, "plating", "bolts", 'sound/items/Ratchet.ogg')

/obj/structure/bench/proc/dismantle(obj/item/weapon/wrench/W, mob/user)
	if(manipulating) return
	manipulating = 1
	user.visible_message("<span class='notice'>\The [user] begins dismantling \the [src].</span>",
	                              "<span class='notice'>You begin dismantling \the [src].</span>")
	playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
	if(!do_after(user, 20))
		manipulating = 0
		return
	user.visible_message("<span class='notice'>\The [user] dismantles \the [src].</span>",
	                              "<span class='notice'>You dismantle \the [src].</span>")
	new /obj/item/stack/material/steel(src.loc)
	qdel(src)
	return

// Returns a list of /obj/item/weapon/material/shard objects that were created as a result of this bench's breakage.
// Used for !fun! things such as embedding shards in the faces of tableslammed people.

// The repeated
//     S = [x].place_shard(loc)
//     if(S) shards += S
// is to avoid filling the list with nulls, as place_shard won't place shards of certain materials (holo-wood, holo-steel)

/obj/structure/bench/proc/break_to_parts(full_return = 0)
	var/list/shards = list()
	var/obj/item/weapon/material/shard/S = null
	if(material)
		if(material.stack_type && (full_return || prob(20)))
			material.place_sheet(loc)
		else
			S = material.place_shard(loc)
			if(S) shards += S
	if(carpeted && (full_return || prob(50))) // Higher chance to get the carpet back intact, since there's no non-intact option
		new /obj/item/stack/tile/carpet(src.loc)
	if(full_return || prob(20))
		new /obj/item/stack/material/steel(src.loc)
	else
		var/material/M = get_material_by_name(DEFAULT_WALL_MATERIAL)
		S = M.place_shard(loc)
		if(S) shards += S
	qdel(src)
	return shards

/obj/structure/bench/update_icon()
	icon_state = "blank"
	overlays.Cut()

	var/image/I

	// Base frame shape. Mostly done for glass/diamond benchs, where this is visible.
	for(var/i = 1 to 4)
		I = image(icon, dir = 1<<(i-1), icon_state = connections[i])
		overlays += I

	// Standard bench image
	if(material)
		for(var/i = 1 to 4)
			I = image(icon, "[material.icon_base]_[connections[i]]", dir = 1<<(i-1))
			if(material.icon_colour) I.color = material.icon_colour
			I.alpha = 255 * material.opacity
			overlays += I

	if(carpeted)
		for(var/i = 1 to 4)
			I = image(icon, "carpet_[connections[i]]", dir = 1<<(i-1))
			overlays += I

// set propagate if you're updating a bench that should update benches around it too, for example if it's a new bench or something important has changed (like material).
/obj/structure/bench/proc/update_connections(propagate=0)
	if(!material)
		connections = list("0", "0", "0", "0")

		if(propagate)
			for(var/obj/structure/bench/T in oview(src, 1))
				T.update_connections()
		return

	var/list/blocked_dirs = list()
	for(var/obj/structure/window/W in get_turf(src))
		if(W.is_fulltile())
			connections = list("0", "0", "0", "0")
			return
		blocked_dirs |= W.dir

	for(var/D in list(NORTH, SOUTH, EAST, WEST) - blocked_dirs)
		var/turf/T = get_step(src, D)
		for(var/obj/structure/window/W in T)
			if(W.is_fulltile() || W.dir == reverse_dir[D])
				blocked_dirs |= D
				break
			else
				if(W.dir != D) // it's off to the side
					blocked_dirs |= W.dir|D // blocks the diagonal

	for(var/D in list(NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST) - blocked_dirs)
		var/turf/T = get_step(src, D)

		for(var/obj/structure/window/W in T)
			if(W.is_fulltile() || W.dir & reverse_dir[D])
				blocked_dirs |= D
				break

	// Blocked cardinals block the adjacent diagonals too. Prevents weirdness with benchs.
	for(var/x in list(NORTH, SOUTH))
		for(var/y in list(EAST, WEST))
			if((x in blocked_dirs) || (y in blocked_dirs))
				blocked_dirs |= x|y

	var/list/connection_dirs = list()

	for(var/obj/structure/bench/T in orange(src, 1))
		var/T_dir = get_dir(src, T)
		if(T_dir in blocked_dirs) continue
		if(material && T.material && material.name == T.material.name)
			connection_dirs |= T_dir
		if(propagate)
			spawn(0)
				T.update_connections()
				T.update_icon()

	connections = dirs_to_corner_states(connection_dirs)
