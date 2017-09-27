/obj/structure/gravemarker
	name = "grave marker"
	desc = "An object used in marking graves."
	icon_state = "gravestone"

	density = 1
	anchored = 1

	//Maybe make these calculate based on material?
	var/health = 100

	var/grave_name = ""		//Name of the intended occupant
	var/epitaph = ""		//A quick little blurb
//	var/dir_locked = 0		//Can it be spun?	Not currently implemented

	var/material/material

/obj/structure/gravemarker/New(var/newloc, var/material_name)
	..(newloc)
	if(!material_name)
		material_name = "wood"
	material = get_material_by_name("[material_name]")
	if(!material)
		qdel(src)
		return
	color = material.icon_colour

/obj/structure/gravemarker/examine(mob/user)
	..()
	if(get_dist(src, user) < 4)
		if(grave_name)
			to_chat(user, "Here Lies [grave_name]")
	if(get_dist(src, user) < 2)
		if(epitaph)
			to_chat(user, epitaph)

/obj/structure/gravemarker/attackby(obj/item/weapon/W, mob/user as mob)
	if(istype(W, /obj/item/weapon/screwdriver))
		var/carving_1 = sanitizeSafe(input(user, "Who is \the [src.name] for?", "Gravestone Naming", null)  as text, MAX_NAME_LEN)
		if(carving_1)
			user.visible_message("[user] starts carving \the [src.name].", "You start carving \the [src.name].")
			if(do_after(user, material.hardness * W.toolspeed))
				user.visible_message("[user] carves something into \the [src.name].", "You carve your message into \the [src.name].")
				grave_name += carving_1
				update_icon()
		var/carving_2 = sanitizeSafe(input(user, "What message should \the [src.name] have?", "Epitaph Carving", null)  as text, MAX_NAME_LEN)
		if(carving_2)
			user.visible_message("[user] starts carving \the [src.name].", "You start carving \the [src.name].")
			if(do_after(user, material.hardness * W.toolspeed))
				user.visible_message("[user] carves something into \the [src.name].", "You carve your message into \the [src.name].")
				epitaph += carving_2
				update_icon()
		return
	if(istype(W, /obj/item/weapon/wrench))
		user.visible_message("[user] starts taking down \the [src.name].", "You start taking down \the [src.name].")
		if(do_after(user, 50 * W.toolspeed))
			user.visible_message("[user] takes down \the [src.name].", "You take down \the [src.name].")
			dismantle()
	..()

/obj/structure/gravemarker/bullet_act(var/obj/item/projectile/Proj)
	var/proj_damage = Proj.get_structure_damage()
	if(!proj_damage)
		return

	..()
	damage(proj_damage)

	return

/obj/structure/gravemarker/ex_act(severity)
	switch(severity)
		if(1.0)
			visible_message("<span class='danger'>\The [src] is blown apart!</span>")
			qdel(src)
			return
		if(2.0)
			visible_message("<span class='danger'>\The [src] is blown apart!</span>")
			if(prob(50))
				dismantle()
			else
				qdel(src)
			return

/obj/structure/gravemarker/proc/damage(var/damage)
	health -= damage
	if(health <= 0)
		visible_message("<span class='danger'>\The [src] falls apart!</span>")
		dismantle()

/obj/structure/gravemarker/proc/dismantle()
	material.place_dismantled_product(get_turf(src))
	qdel(src)
	return

/*	//Need Directional Sprites
/obj/structure/gravemarker/verb/rotate()
	set name = "Rotate Grave Marker"
	set category = "Object"
	set src in oview(1)

	if(dir_locked)
		return
	if(config.ghost_interaction)
		src.set_dir(turn(src.dir, 90))
		return
	else
		if(istype(usr,/mob/living/simple_animal/mouse))
			return
		if(!usr || !isturf(usr.loc))
			return
		if(usr.stat || usr.restrained())
			return

		src.set_dir(turn(src.dir, 90))
		return
*/