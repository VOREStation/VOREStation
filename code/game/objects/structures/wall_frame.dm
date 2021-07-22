// Basically see-through walls. Used for windows
// If nothing has been built on the low wall, you can climb on it

/obj/structure/low_wall
	name = "low wall"
	desc = "A low wall section which serves as the base of windows, amongst other things."
	layer = TURF_LAYER
	icon = null
	icon_state = "frame"

	//atom_flags = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_CLIMBABLE | ATOM_FLAG_CAN_BE_PAINTED | ATOM_FLAG_ADJACENT_EXCEPTION
	anchored = TRUE
	density = TRUE
	throwpass = 1
	layer = TABLE_LAYER

	var/icon/frame_masks = 'icons/obj/wall_frame_bay.dmi'

	var/health = 100
	var/stripe_color
	//rad_resistance_modifier = 0.5

	// blend_objects defined on subtypes	
	noblend_objects = list(/obj/machinery/door/window)
	
	var/default_material = DEFAULT_WALL_MATERIAL
	var/datum/material/material
	var/grille_type

/obj/structure/low_wall/Initialize(var/mapload, var/materialtype)
	. = ..()
	icon_state = "blank"
	var/turf/T = loc
	if(!isturf(T) || T.density || T.opacity)
		warning("[src] on invalid turf [T] at [x],[y],[z]")
		return INITIALIZE_HINT_QDEL

	if(!materialtype)
		materialtype = default_material
	
	material = get_material_by_name(materialtype)
	
	health = material.integrity

	return INITIALIZE_HINT_LATELOAD

/obj/structure/low_wall/LateInitialize()
	. = ..()
	update_connections()
	update_icon()

/obj/structure/low_wall/Destroy()
	var/turf/location = loc
	. = ..()
	for(var/obj/structure/low_wall/W in orange(1, location))
		W.update_connections()
		W.update_icon()


/obj/structure/low_wall/examine(mob/user)
	. = ..()

	if(health == material.integrity)
		to_chat(user, "<span class='notice'>It seems to be in fine condition.</span>")
	else
		var/dam = health / material.integrity
		if(dam <= 0.3)
			to_chat(user, "<span class='notice'>It's got a few dents and scratches.</span>")
		else if(dam <= 0.7)
			to_chat(user, "<span class='warning'>A few pieces of panelling have fallen off.</span>")
		else
			to_chat(user, "<span class='danger'>It's nearly falling to pieces.</span>")

/obj/structure/low_wall/attackby(var/obj/item/W, var/mob/user)
	src.add_fingerprint(user)

	//grille placing
	if(istype(W, /obj/item/stack/rods))
		if(!grille_type)
			to_chat(user, "<span class='notice'>This type of wall frame doesn't support grilles.</span>")
			return
		for(var/obj/structure/window/WINDOW in loc)
			if(WINDOW.dir == get_dir(src, user))
				to_chat(user, "<span class='notice'>There is a window in the way.</span>")
				return
		var/obj/item/stack/rods/ST = W
		if(ST.get_amount() < 2)
			to_chat(user, "<span class='warning'>You need at least two rods to do this.</span>")
			return
		to_chat(user, "<span class='notice'>Assembling grille...</span>")
		if(!do_after(user, 10, ST, exclusive = TASK_ALL_EXCLUSIVE))
			return
		if(!ST.use(2))
			return
		new /obj/structure/grille/bay(loc)
		return

	//window placing // TODO
	else if(istype(W, /obj/item/stack/material/glass))
		new /obj/structure/window/bay(loc, SOUTHWEST, TRUE)

	if(W.is_wrench())
		for(var/obj/structure/S in loc)
			if(istype(S, /obj/structure/window))
				to_chat(user, "<span class='notice'>There is still a window on the low wall!</span>")
				return
			else if(istype(S, /obj/structure/grille))
				to_chat(user, "<span class='notice'>There is still a grille on the low wall!</span>")
				return
		playsound(src.loc, 'sound/items/Ratchet.ogg', 100, 1)
		to_chat(user, "<span class='notice'>Now disassembling the low wall...</span>")
		if(do_after(user, 40, src))
			to_chat(user, "<span class='notice'>You dissasembled the low wall!</span>")
			dismantle()
	/* TODO
	else if(istype(W, /obj/item/gun/energy/plasmacutter))
		var/obj/item/gun/energy/plasmacutter/cutter = W
		if(!cutter.slice(user))
			return
		playsound(src.loc, 'sound/items/Welder.ogg', 100, 1)
		to_chat(user, "<span class='notice'>Now slicing through the low wall...</span>")
		if(do_after(user, 20,src))
			to_chat(user, "<span class='warning'>You have sliced through the low wall!</span>")
			dismantle()
	*/
	return ..()

/obj/structure/low_wall/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group || (height==0)) return 1
	if(istype(mover,/obj/item/projectile))
		return 1
	if(istype(mover) && mover.checkpass(PASSTABLE))
		return 1

// Bay's version
/obj/structure/low_wall/bay/update_icon()
	cut_overlays()

	var/image/I
	var/main_color = material.icon_colour
	for(var/i = 1 to 4)
		if(other_connections[i] != "0")
			I = image(icon, "frame_other[other_connections[i]]", dir = 1<<(i-1))
			I.color = main_color
		else
			I = image(icon, "frame[connections[i]]", dir = 1<<(i-1))
			I.color = main_color
		add_overlay(I)

	if(stripe_color)
		for(var/i = 1 to 4)
			if(other_connections[i] != "0")
				I = image(icon, "stripe_other[other_connections[i]]", dir = 1<<(i-1))
			else
				I = image(icon, "stripe[connections[i]]", dir = 1<<(i-1))
			I.color = stripe_color
			add_overlay(I)

// Eris's version
/obj/structure/low_wall/eris/update_icon()
	cut_overlays()

	var/image/I
	var/main_color = material.icon_colour
	for(var/i = 1 to 4)
		I = image(icon, "frame[connections[i]]", dir = 1<<(i-1))
		I.color = main_color
		add_overlay(I)

		if(other_connections[i] != "0")
			I = image(icon, "frame_other[other_connections[i]]", dir = 1<<(i-1))
			I.plane = ABOVE_OBJ_PLANE
			I.layer = ABOVE_WINDOW_LAYER
			I.color = main_color
			add_overlay(I)

/obj/structure/low_wall/bullet_act(var/obj/item/projectile/Proj)
	var/proj_damage = Proj.get_structure_damage()
	var/damage = min(proj_damage, 100)
	take_damage(damage)
	return

/obj/structure/low_wall/hitby(AM as mob|obj, var/speed)
	..()
	var/tforce = 0
	if(ismob(AM)) // All mobs have a multiplier and a size according to mob_defines.dm
		var/mob/I = AM
		tforce = I.mob_size * (speed/THROWFORCE_SPEED_DIVISOR)
	else
		var/obj/O = AM
		tforce = O.throwforce * (speed/THROWFORCE_SPEED_DIVISOR)
	if (tforce < 15)
		return
	take_damage(tforce)

/obj/structure/low_wall/take_damage(damage)
	health -= damage
	if(health <= 0)
		dismantle()

/obj/structure/low_wall/proc/dismantle()
	new /obj/item/stack/material/steel(get_turf(src), 3)
	qdel(src)

/**
 * The two 'real' types
 */
/obj/structure/low_wall/bay
	icon = 'icons/obj/wall_frame_bay.dmi'
	grille_type = /obj/structure/grille/bay
	blend_objects = list(/obj/machinery/door, /turf/simulated/wall/bay)

/obj/structure/low_wall/bay/reinforced
	default_material = MAT_PLASTEEL

/obj/structure/low_wall/eris
	icon = 'icons/obj/wall_frame_eris.dmi'
	grille_type = null
	blend_objects = list(/obj/machinery/door, /turf/simulated/wall/eris)

/obj/structure/low_wall/eris/reinforced
	default_material = MAT_PLASTEEL

/**
 * Bay's fancier icon grilles
 */
/obj/structure/grille/bay
	icon = 'icons/obj/bay_grille.dmi'
	blend_objects = list(/obj/machinery/door, /turf/simulated/wall/bay) // Objects which to blend with
	noblend_objects = list(/obj/machinery/door/window)
	color = "#666666"

/obj/structure/grille/bay/Initialize()
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/structure/grille/bay/LateInitialize()
	. = ..()
	update_connections(1)
	update_icon()

/obj/structure/grille/bay/Destroy()
	var/turf/location = loc
	. = ..()
	for(var/obj/structure/grille/G in orange(1, location))
		G.update_connections()
		G.update_icon()

/obj/structure/grille/bay/update_icon()
	var/on_frame = locate(/obj/structure/low_wall/bay) in loc

	cut_overlays()
	if(destroyed)
		if(on_frame)
			icon_state = "broke_onframe"
		else
			icon_state = "broken"
	else
		var/image/I
		icon_state = ""
		if(on_frame)
			for(var/i = 1 to 4)
				if(other_connections[i] != "0")
					I = image(icon, "grille_other_onframe[connections[i]]", dir = 1<<(i-1))
				else
					I = image(icon, "grille_onframe[connections[i]]", dir = 1<<(i-1))
				add_overlay(I)
		else
			for(var/i = 1 to 4)
				if(other_connections[i] != "0")
					I = image(icon, "grille_other[connections[i]]", dir = 1<<(i-1))
				else
					I = image(icon, "grille[connections[i]]", dir = 1<<(i-1))
				add_overlay(I)

/**
 * The window types for both types of short walls
 */
/obj/structure/window/bay
	icon = 'icons/obj/bay_window.dmi'
	blend_objects = list(/obj/machinery/door, /turf/simulated/wall/bay)
	noblend_objects = list(/obj/machinery/door/window)
	icon_state = "preview_glass"
	basestate = "window"
	alpha = 180
	flags = 0
	fulltile = TRUE
	maxhealth = 24
	glasstype = /obj/item/stack/material/glass

/obj/structure/window/bay/Initialize()
	. = ..()
	var/obj/item/stack/material/glass/G = glasstype
	var/datum/material/M = get_material_by_name(initial(G.default_type))
	color = M.icon_colour
	return INITIALIZE_HINT_LATELOAD

/obj/structure/window/bay/LateInitialize()
	. = ..()
	icon_state = ""
	update_icon()

/obj/structure/window/bay/update_icon()
	cut_overlays()
	if(!anchored)
		connections = list("0","0","0","0")
		other_connections = list("0","0","0","0")
	else
		update_connections()
	
	var/percent_damage = 0 // Used for icon state of damage layer
	var/damage_alpha = 0 // Used for alpha blending of damage layer
	if (maxhealth && health < maxhealth)
		percent_damage = (maxhealth - health) / maxhealth // Percentage of damage received (Not health remaining)
		percent_damage = round(percent_damage, 0.25) // Round to nearest multiple of 25
		damage_alpha = 256 * percent_damage - 1

	var/img_dir
	var/image/I
	for(var/i = 1 to 4)
		img_dir = 1<<(i-1)
		if(other_connections[i] != "0")
			I = image(icon, "[basestate]_other_onframe[other_connections[i]]", dir = img_dir)
			I.color = color
		else
			I = image(icon, "[basestate]_onframe[connections[i]]", dir = img_dir)
			I.color = color
		add_overlay(I)

	if(damage_alpha)
		var/image/D
		D = image(icon, "window0_damage", dir = img_dir)
		D.blend_mode = BLEND_MULTIPLY
		D.alpha = damage_alpha
		add_overlay(D)

/obj/structure/window/bay/reinforced
	name = "reinforced window"
	desc = "It looks rather strong. Might take a few good hits to shatter it."
	icon_state = "preview_rglass"
	basestate = "rwindow"
	maxhealth = 80
	reinf = 1
	maximal_heat = T0C + 750
	damage_per_fire_tick = 2.0
	glasstype = /obj/item/stack/material/glass/reinforced
	force_threshold = 6

/obj/structure/window/bay/phoronbasic
	name = "phoron window"
	desc = "A borosilicate alloy window. It seems to be quite strong."
	icon_state = "preview_phoron"
	shardtype = /obj/item/weapon/material/shard/phoron
	glasstype = /obj/item/stack/material/glass/phoronglass
	maximal_heat = T0C + 2000
	damage_per_fire_tick = 1.0
	maxhealth = 40.0
	force_threshold = 5
	maxhealth = 80

/obj/structure/window/bay/phoronreinforced
	name = "reinforced borosilicate window"
	desc = "A borosilicate alloy window, with rods supporting it. It seems to be very strong."
	icon_state = "preview_rphoron"
	basestate = "rwindow"
	shardtype = /obj/item/weapon/material/shard/phoron
	glasstype = /obj/item/stack/material/glass/phoronrglass
	reinf = 1
	maximal_heat = T0C + 4000
	damage_per_fire_tick = 1.0 // This should last for 80 fire ticks if the window is not damaged at all. The idea is that borosilicate windows have something like ablative layer that protects them for a while.
	maxhealth = 160
	force_threshold = 10


/obj/structure/window/eris
	icon = 'icons/obj/eris_window.dmi'
	blend_objects = list(/obj/machinery/door, /turf/simulated/wall/eris)
	noblend_objects = list(/obj/machinery/door/window)
	icon_state = "preview_glass"
	basestate = "window"
	fulltile = TRUE
	maxhealth = 24
	alpha = 150

/obj/structure/window/eris/Initialize()
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/structure/window/eris/LateInitialize()
	. = ..()
	icon_state = ""
	update_icon()

/obj/structure/window/eris/update_icon()
	cut_overlays()
	if(!anchored)
		connections = list("0","0","0","0")
		other_connections = list("0","0","0","0")
	else
		update_connections()
	
	var/img_dir
	var/image/I
	for(var/i = 1 to 4)
		img_dir = 1<<(i-1)
		if(other_connections[i] != "0")
			I = image(icon, "[basestate][other_connections[i]]", dir = img_dir)
		else
			I = image(icon, "[basestate][connections[i]]", dir = img_dir)
		add_overlay(I)

/obj/structure/window/eris/reinforced
	name = "reinforced window"
	desc = "It looks rather strong. Might take a few good hits to shatter it."
	icon_state = "preview_rglass"
	basestate = "rwindow"
	maxhealth = 80
	reinf = 1
	maximal_heat = T0C + 750
	damage_per_fire_tick = 2.0
	glasstype = /obj/item/stack/material/glass/reinforced
	force_threshold = 6

/obj/structure/window/eris/phoronbasic
	name = "phoron window"
	desc = "A borosilicate alloy window. It seems to be quite strong."
	basestate = "preview_phoron"
	icon_state = "pwindow"
	shardtype = /obj/item/weapon/material/shard/phoron
	glasstype = /obj/item/stack/material/glass/phoronglass
	maximal_heat = T0C + 2000
	damage_per_fire_tick = 1.0
	maxhealth = 40.0
	force_threshold = 5
	maxhealth = 80

/obj/structure/window/eris/phoronreinforced
	name = "reinforced borosilicate window"
	desc = "A borosilicate alloy window, with rods supporting it. It seems to be very strong."
	basestate = "preview_rphoron"
	icon_state = "rpwindow"
	shardtype = /obj/item/weapon/material/shard/phoron
	glasstype = /obj/item/stack/material/glass/phoronrglass
	reinf = 1
	maximal_heat = T0C + 4000
	damage_per_fire_tick = 1.0 // This should last for 80 fire ticks if the window is not damaged at all. The idea is that borosilicate windows have something like ablative layer that protects them for a while.
	maxhealth = 160
	force_threshold = 10

/**
 * Spawner helpers for mapping these in
 */

/obj/effect/low_wall_spawner
	name = "low wall spawner"

	var/low_wall_type
	var/window_type
	var/grille_type

	icon = null

/obj/effect/low_wall_spawner/Initialize()
	. = ..()
	if(locate(/obj/effect/low_wall_spawner) in oview(0, src))
		warning("Duplicate low wall spawners in [x],[y],[z]!")
		return INITIALIZE_HINT_QDEL
	
	if(low_wall_type)
		new low_wall_type(loc)
	if(grille_type)
		new grille_type(loc)
	if(window_type)
		new window_type(loc)
	
	return INITIALIZE_HINT_QDEL

// Bay types
/obj/effect/low_wall_spawner/bay
	icon = 'icons/obj/wall_frame_bay.dmi'
	icon_state = "sp_glass"
	low_wall_type = /obj/structure/low_wall/bay
	window_type = /obj/structure/window/bay

/obj/effect/low_wall_spawner/bay/rglass
	icon_state = "sp_rglass"
	window_type = /obj/structure/window/bay/reinforced

/obj/effect/low_wall_spawner/bay/phoron
	icon_state = "sp_phoron"
	window_type = /obj/structure/window/bay/phoronbasic

/obj/effect/low_wall_spawner/bay/rphoron
	icon_state = "sp_rphoron"
	window_type = /obj/structure/window/bay/phoronreinforced

/obj/effect/low_wall_spawner/bay/grille
	icon = 'icons/obj/wall_frame_bay.dmi'
	icon_state = "sp_glass_g"
	low_wall_type = /obj/structure/low_wall/bay
	grille_type = /obj/structure/grille/bay
	window_type = /obj/structure/window/bay

/obj/effect/low_wall_spawner/bay/grille/rglass
	icon_state = "sp_rglass_g"
	window_type = /obj/structure/window/bay/reinforced

/obj/effect/low_wall_spawner/bay/grille/phoron
	icon_state = "sp_phoron_g"
	window_type = /obj/structure/window/bay/phoronbasic

/obj/effect/low_wall_spawner/bay/grille/rphoron
	icon_state = "sp_rphoron_g"
	window_type = /obj/structure/window/bay/phoronreinforced

// Eris types
/obj/effect/low_wall_spawner/eris
	icon = 'icons/obj/wall_frame_eris.dmi'
	icon_state = "sp_glass"
	low_wall_type = /obj/structure/low_wall/eris
	window_type = /obj/structure/window/eris

/obj/effect/low_wall_spawner/eris/rglass
	icon_state = "sp_rglass"
	window_type = /obj/structure/window/eris/reinforced

/obj/effect/low_wall_spawner/eris/phoron
	icon_state = "sp_phoron"
	window_type = /obj/structure/window/eris/phoronbasic

/obj/effect/low_wall_spawner/eris/rphoron
	icon_state = "sp_rphoron"
	window_type = /obj/structure/window/eris/phoronreinforced
