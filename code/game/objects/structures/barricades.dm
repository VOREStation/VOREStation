//Barricades!
/obj/structure/barricade
	name = "barricade"
	desc = "This space is blocked off by a barricade."
	icon = 'icons/obj/structures.dmi'
	icon_state = "barricade"
	anchored = 1.0
	density = 1.0
	var/health = 100
	var/maxhealth = 100
	var/datum/material/material

/obj/structure/barricade/New(var/newloc, var/material_name)
	..(newloc)
	if(!material_name)
		material_name = "wood"
	material = get_material_by_name("[material_name]")
	if(!material)
		qdel(src)
		return
	name = "[material.display_name] barricade"
	desc = "This space is blocked off by a barricade made of [material.display_name]."
	color = material.icon_colour
	maxhealth = material.integrity
	health = maxhealth

/obj/structure/barricade/get_material()
	return material

/obj/structure/barricade/attackby(obj/item/W as obj, mob/user as mob)
	user.setClickCooldown(user.get_attack_speed(W))
	if(istype(W, /obj/item/stack))
		var/obj/item/stack/D = W
		if(D.get_material_name() != material.name)
			return //hitting things with the wrong type of stack usually doesn't produce messages, and probably doesn't need to.
		if(health < maxhealth)
			if(D.get_amount() < 1)
				to_chat(user, "<span class='warning'>You need one sheet of [material.display_name] to repair \the [src].</span>")
				return
			visible_message("<span class='notice'>[user] begins to repair \the [src].</span>")
			if(do_after(user,20) && health < maxhealth)
				if(D.use(1))
					health = maxhealth
					visible_message("<span class='notice'>[user] repairs \the [src].</span>")
				return
		return
	else
		switch(W.damtype)
			if("fire")
				health -= W.force * 1
			if("brute")
				health -= W.force * 0.75
		if(material == (get_material_by_name(MAT_WOOD) || get_material_by_name(MAT_SIFWOOD)))
			playsound(src, 'sound/effects/woodcutting.ogg', 100, 1)
		else
			playsound(src, 'sound/weapons/smash.ogg', 50, 1)
		CheckHealth()
		..()

/obj/structure/barricade/proc/CheckHealth()
	if(health <= 0)
		dismantle()

	health = min(health, maxhealth)

	return

/obj/structure/barricade/take_damage(var/damage)
	health -= damage
	CheckHealth()
	return

/obj/structure/barricade/attack_generic(var/mob/user, var/damage, var/attack_verb)
	visible_message("<span class='danger'>[user] [attack_verb] the [src]!</span>")
	if(material == get_material_by_name("resin"))
		playsound(src, 'sound/effects/attackblob.ogg', 100, 1)
	else if(material == (get_material_by_name(MAT_CLOTH) || get_material_by_name(MAT_SYNCLOTH)))
		playsound(src, 'sound/items/drop/clothing.ogg', 100, 1)
	else if(material == (get_material_by_name(MAT_WOOD) || get_material_by_name(MAT_SIFWOOD)))
		playsound(src, 'sound/effects/woodcutting.ogg', 100, 1)
	else
		playsound(src, 'sound/weapons/smash.ogg', 50, 1)
	user.do_attack_animation(src)
	health -= damage
	CheckHealth()
	return

/obj/structure/barricade/proc/dismantle()
	material.place_dismantled_product(get_turf(src))
	visible_message("<span class='danger'>\The [src] falls apart!</span>")
	qdel(src)
	return

/obj/structure/barricade/ex_act(severity)
	switch(severity)
		if(1.0)
			dismantle()
		if(2.0)
			health -= 25
			CheckHealth()

/obj/structure/barricade/CanPass(atom/movable/mover, turf/target)//So bullets will fly over and stuff.
	if(istype(mover) && mover.checkpass(PASSTABLE))
		return TRUE
	return FALSE

/obj/structure/barricade/sandbag
	name = "sandbags"
	desc = "Bags. Bags of sand. It's rough and coarse and somehow stays in the bag."
	icon = 'icons/obj/sandbags.dmi'
	icon_state = "blank"

/obj/structure/barricade/sandbag/New(var/newloc, var/material_name)
	if(!material_name)
		material_name = "cloth"
	..(newloc, material_name)
	material = get_material_by_name("[material_name]")
	if(!material)
		qdel(src)
		return
	name = "[material.display_name] [initial(name)]"
	desc = "This space is blocked off by a barricade made of [material.display_name]."
	color = null
	maxhealth = material.integrity * 2	// These things are, commonly, used to stop bullets where possible.
	health = maxhealth
	update_connections(1)

/obj/structure/barricade/sandbag/Destroy()
	update_connections(1, src)
	..()

/obj/structure/barricade/sandbag/dismantle()
	update_connections(1, src)
	material.place_dismantled_product(get_turf(src))
	visible_message("<span class='danger'>\The [src] falls apart!</span>")
	qdel(src)
	return

/obj/structure/barricade/sandbag/update_icon()
	if(!material)
		return

	cut_overlays()
	var/image/I

	for(var/i = 1 to 4)
		I = image('icons/obj/sandbags.dmi', "sandbags[connections[i]]", dir = 1<<(i-1))
		I.color = material.icon_colour
		add_overlay(I)

	return

/obj/structure/barricade/sandbag/update_connections(propagate = 0, var/obj/structure/barricade/sandbag/ignore = null)
	if(!material)
		return
	var/list/dirs = list()
	for(var/obj/structure/barricade/sandbag/S in orange(src, 1))
		if(!S.material)
			continue
		if(S == ignore)
			continue
		if(propagate >= 1)
			S.update_connections(propagate - 1, ignore)
		if(can_join_with(S))
			dirs += get_dir(src, S)

	connections = dirs_to_corner_states(dirs)

	update_icon()

/obj/structure/barricade/sandbag/proc/can_join_with(var/obj/structure/barricade/sandbag/S)
	if(material == S.material)
		return 1
	return 0

/obj/structure/barricade/sandbag/CanPass(atom/movable/mover, turf/target)
	. = ..()

	if(.)
		if(istype(mover, /obj/item/projectile))
			var/obj/item/projectile/P = mover

			if(P.firer && get_dist(P.firer, src) > 1)	// If you're firing from adjacent turfs, you are unobstructed.
				if(P.armor_penetration < (material.protectiveness + material.hardness) || prob(33))
					return FALSE
