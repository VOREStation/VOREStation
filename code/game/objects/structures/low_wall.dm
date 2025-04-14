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
	climbable = TRUE
	throwpass = 1
	layer = TABLE_LAYER

	var/icon/frame_masks = 'icons/obj/wall_frame_bay.dmi'

	var/health = 100
	var/stripe_color
	//rad_resistance_modifier = 0.5

	// blend_objects defined on subtypes
	noblend_objects = list(/obj/machinery/door/window, /obj/machinery/door/firedoor)

	var/default_material = DEFAULT_WALL_MATERIAL
	var/datum/material/material
	var/grille_type

/obj/structure/low_wall/Initialize(mapload, var/materialtype)
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
	update_connections(1)
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
		to_chat(user, span_notice("It seems to be in fine condition."))
	else
		var/dam = health / material.integrity
		if(dam <= 0.3)
			to_chat(user, span_notice("It's got a few dents and scratches."))
		else if(dam <= 0.7)
			to_chat(user, span_warning("A few pieces of panelling have fallen off."))
		else
			to_chat(user, span_danger("It's nearly falling to pieces."))

/obj/structure/low_wall/attackby(var/obj/item/W, var/mob/user, var/hit_modifier, var/click_parameters)
	src.add_fingerprint(user)

	// Making grilles (only works on Bay ones currently)
	if(istype(W, /obj/item/stack/rods))
		handle_rod_use(user, W)
		return

	// Making windows, different per subtype
	else if(istype(W, /obj/item/stack/material/glass) || istype(W, /obj/item/stack/material/cyborg/glass))
		handle_glass_use(user, W)
		return

	// Dismantling the half wall
	if(W.has_tool_quality(TOOL_WRENCH))
		for(var/obj/structure/S in loc)
			if(istype(S, /obj/structure/window))
				to_chat(user, span_notice("There is still a window on the low wall!"))
				return
			else if(istype(S, /obj/structure/grille))
				to_chat(user, span_notice("There is still a grille on the low wall!"))
				return
		playsound(src.loc, 'sound/items/Ratchet.ogg', 100, 1)
		to_chat(user, span_notice("Now disassembling the low wall..."))
		if(do_after(user, 40, src))
			to_chat(user, span_notice("You dissasembled the low wall!"))
			dismantle()
			return

	// Handle placing things
	if(isrobot(user))
		return

	if(W.loc != user) // This should stop mounted modules ending up outside the module.
		return

	if(can_place_items() && user.unEquip(W, 0, src.loc) && user.client?.prefs?.read_preference(/datum/preference/toggle/precision_placement))
		auto_align(W, click_parameters)
		return 1

	return ..()

/obj/structure/low_wall/proc/can_place_items()
	for(var/obj/structure/S in loc)
		if(S == src)
			continue
		if(S.density)
			return FALSE
	return TRUE

/obj/structure/low_wall/MouseDrop_T(atom/movable/AM, mob/user, src_location, over_location, src_control, over_control, params)
	if(AM == user)
		var/mob/living/H = user
		if(istype(H) && can_climb(H))
			do_climb(AM)
	var/obj/O = AM
	if(!istype(O))
		return
	if(istype(O, /obj/structure/window))
		var/obj/structure/window/W = O
		if(Adjacent(W) && !W.anchored)
			to_chat(user, span_notice("You hoist [W] up onto [src]."))
			W.forceMove(loc)
			return
	if(isrobot(user))
		return
	if(can_place_items())
		if(ismob(O.loc)) //If placing an item
			if(!isitem(O) || user.get_active_hand() != O)
				return ..()
			if(isrobot(user))
				return
			user.drop_item()
			if(O.loc != src.loc)
				step(O, get_dir(O, src))

		else if(isturf(O.loc) && isitem(O)) //If pushing an item on the tabletop
			var/obj/item/I = O
			if(I.anchored)
				return

			if((isliving(user)) && (Adjacent(user)) && !(user.incapacitated()))
				if(O.w_class <= user.can_pull_size)
					O.forceMove(loc)
					auto_align(I, params, TRUE)
				else
					to_chat(user, span_warning("\The [I] is too big for you to move!"))
				return

/obj/structure/low_wall/proc/handle_rod_use(mob/user, obj/item/stack/rods/R)
	if(!grille_type)
		to_chat(user, span_notice("This type of wall frame doesn't support grilles."))
		return
	for(var/obj/structure/window/WINDOW in loc)
		if(WINDOW.dir == get_dir(src, user))
			to_chat(user, span_notice("There is a window in the way."))
			return
	if(R.get_amount() < 2)
		to_chat(user, span_warning("You need at least two rods to do this."))
		return
	to_chat(user, span_notice("Assembling grille..."))
	if(!do_after(user, 1 SECONDS, R, exclusive = TASK_ALL_EXCLUSIVE))
		return
	if(!R.use(2))
		return
	new grille_type(loc)
	return

/obj/structure/low_wall/proc/handle_glass_use(mob/user, obj/item/stack/material/glass/G)
	var/window_type = get_window_build_type(user, G)
	if(!window_type)
		to_chat(user, span_notice("You can't build that type of window on this type of low wall."))
		return
	for(var/obj/structure/window/WINDOW in loc)
		if(WINDOW.dir == get_dir(src, user))
			to_chat(user, span_notice("There is already a window here."))
			return
	if(G.get_amount() < 4)
		to_chat(user, span_warning("You need at least four sheets of glass to do this."))
		return
	to_chat(user, span_notice("Assembling window..."))
	if(!do_after(user, 4 SECONDS, G, exclusive = TASK_ALL_EXCLUSIVE))
		return
	if(!G.use(4))
		return
	new window_type(loc, null, TRUE)
	return

/obj/structure/low_wall/proc/get_window_build_type(mob/user, obj/item/stack/material/glass/G)
	return null

/obj/structure/low_wall/CanPass(atom/movable/mover, turf/target)
	if(istype(mover,/obj/item/projectile))
		return TRUE
	if(istype(mover) && mover.checkpass(PASSTABLE))
		return TRUE
	return FALSE

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

/obj/structure/low_wall/attack_generic(var/mob/user, var/damage, var/attack_verb)
	visible_message(span_danger("[user] [attack_verb] the [src]!"))
	user.do_attack_animation(src)
	take_damage(damage)
	return ..()

/obj/structure/low_wall/proc/dismantle()
	var/stacktype = material?.stack_type
	if(stacktype)
		new stacktype(get_turf(src), 3)
	// If we were violently dismantled
	for(var/obj/structure/window/W in loc)
		if(W.anchored)
			W.shatter()
	for(var/obj/structure/grille/G in loc)
		if(G.anchored)
			G.health = 0
			G.healthcheck()
	qdel(src)

/**
 * The two 'real' types
 */
/obj/structure/low_wall/bay
	icon = 'icons/obj/wall_frame_bay.dmi'
	grille_type = /obj/structure/grille/bay
	blend_objects = list(/obj/machinery/door, /turf/simulated/wall/bay, /turf/simulated/wall/tgmc)

/obj/structure/low_wall/bay/reinforced
	default_material = MAT_PLASTEEL

/obj/structure/low_wall/bay/get_window_build_type(mob/user, obj/item/stack/material/glass/G)
	switch(G.material.name)
		if(MAT_GLASS)
			return /obj/structure/window/bay
		if(MAT_RGLASS)
			return /obj/structure/window/bay/reinforced
		if(MAT_PGLASS)
			return /obj/structure/window/bay/phoronbasic
		if(MAT_RPGLASS)
			return /obj/structure/window/bay/phoronreinforced

/obj/structure/low_wall/eris
	icon = 'icons/obj/wall_frame_eris.dmi'
	grille_type = null
	blend_objects = list(/obj/machinery/door, /turf/simulated/wall/eris, /turf/simulated/wall/tgmc)

/obj/structure/low_wall/eris/reinforced
	default_material = MAT_PLASTEEL

/obj/structure/low_wall/eris/get_window_build_type(mob/user, obj/item/stack/material/glass/G)
	switch(G.material.name)
		if(MAT_GLASS)
			return /obj/structure/window/eris
		if(MAT_RGLASS)
			return /obj/structure/window/eris/reinforced
		if(MAT_PGLASS)
			return /obj/structure/window/eris/phoronbasic
		if(MAT_RPGLASS)
			return /obj/structure/window/eris/phoronreinforced

/**
 * Bay's fancier icon grilles
 */
/obj/structure/grille/bay
	icon = 'icons/obj/bay_grille.dmi'
	blend_objects = list(/obj/machinery/door, /turf/simulated/wall/bay) // Objects which to blend with
	noblend_objects = list(/obj/machinery/door/window)
	color = "#666666"

/obj/structure/grille/bay/Initialize(mapload)
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/structure/grille/bay/LateInitialize()
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
	noblend_objects = list(/obj/machinery/door/window, /obj/machinery/door/firedoor)
	icon_state = "preview_glass"
	basestate = "window"
	alpha = 180
	flags = 0
	fulltile = TRUE
	maxhealth = 24
	glasstype = /obj/item/stack/material/glass

/obj/structure/window/bay/Initialize(mapload)
	. = ..()
	var/obj/item/stack/material/glass/G = glasstype
	var/datum/material/M = get_material_by_name(initial(G.default_type))
	color = M.icon_colour
	return INITIALIZE_HINT_LATELOAD

/obj/structure/window/bay/LateInitialize()
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
	shardtype = /obj/item/material/shard/phoron
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
	shardtype = /obj/item/material/shard/phoron
	glasstype = /obj/item/stack/material/glass/phoronrglass
	reinf = 1
	maximal_heat = T0C + 4000
	damage_per_fire_tick = 1.0 // This should last for 80 fire ticks if the window is not damaged at all. The idea is that borosilicate windows have something like ablative layer that protects them for a while.
	maxhealth = 160
	force_threshold = 10


/obj/structure/window/eris
	icon = 'icons/obj/eris_window.dmi'
	blend_objects = list(/obj/machinery/door, /turf/simulated/wall/eris)
	noblend_objects = list(/obj/machinery/door/window, /obj/machinery/door/firedoor)
	icon_state = "preview_glass"
	basestate = "window"
	fulltile = TRUE
	maxhealth = 24
	alpha = 150

/obj/structure/window/eris/Initialize(mapload)
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/structure/window/eris/LateInitialize()
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
	shardtype = /obj/item/material/shard/phoron
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
	shardtype = /obj/item/material/shard/phoron
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

/obj/effect/low_wall_spawner/Initialize(mapload)
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

/obj/effect/low_wall_spawner/bay/reinforced
	icon_state = "spr_glass_g"
	low_wall_type = /obj/structure/low_wall/bay/reinforced
	grille_type = /obj/structure/grille/bay
	window_type = /obj/structure/window/bay

/obj/effect/low_wall_spawner/bay/reinforced/rglass
	icon_state = "spr_rglass_g"
	window_type = /obj/structure/window/bay/reinforced

/obj/effect/low_wall_spawner/bay/reinforced/phoron
	icon_state = "spr_phoron_g"
	window_type = /obj/structure/window/bay/phoronbasic

/obj/effect/low_wall_spawner/bay/reinforced/rphoron
	icon_state = "spr_rphoron_g"
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

/obj/effect/low_wall_spawner/eris/reinforced
	icon_state = "spr_glass"
	low_wall_type = /obj/structure/low_wall/eris/reinforced
	window_type = /obj/structure/window/eris

/obj/effect/low_wall_spawner/eris/reinforced/rglass
	icon_state = "spr_rglass"
	window_type = /obj/structure/window/eris/reinforced

/obj/effect/low_wall_spawner/eris/reinforced/phoron
	icon_state = "spr_phoron"
	window_type = /obj/structure/window/eris/phoronbasic

/obj/effect/low_wall_spawner/eris/reinforced/rphoron
	icon_state = "spr_rphoron"
	window_type = /obj/structure/window/eris/phoronreinforced
