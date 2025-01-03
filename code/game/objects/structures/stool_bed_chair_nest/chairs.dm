/obj/structure/bed/chair	//YES, chairs are a type of bed, which are a type of stool. This works, believe me.	-Pete
	name = "chair"
	desc = "You sit in this. Either by will or force."
	icon = 'icons/obj/furniture_vr.dmi' //VOREStation Edit - Using Eris furniture
	icon_state = "chair_preview"
	color = "#666666"
	base_icon = "chair"
	buckle_dir = 0
	buckle_lying = 0 //force people to sit up in chairs when buckled
	var/propelled = 0 // Check for fire-extinguisher-driven chairs

/obj/structure/bed/chair/Initialize(var/newloc, var/new_material, var/new_padding_material)
	. = ..()
	update_layer()

/obj/structure/bed/chair/attackby(obj/item/W as obj, mob/user as mob)
	..()
	if(!padding_material && istype(W, /obj/item/assembly/shock_kit))
		var/obj/item/assembly/shock_kit/SK = W
		if(!SK.status)
			to_chat(user, span_notice("\The [SK] is not ready to be attached!"))
			return
		user.drop_item()
		var/obj/structure/bed/chair/e_chair/E = new (src.loc, material.name)
		playsound(src, 'sound/items/Deconstruct.ogg', 50, 1)
		E.set_dir(dir)
		E.part = SK
		SK.loc = E
		SK.master = E
		qdel(src)

/obj/structure/bed/chair/attack_tk(mob/user as mob)
	if(has_buckled_mobs())
		..()
	else
		rotate_clockwise()
	return

/obj/structure/bed/chair/post_buckle_mob()
	update_icon()

/obj/structure/bed/chair/update_icon()
	..()
	if(has_buckled_mobs())
		var/cache_key = "[base_icon]-armrest-[padding_material ? padding_material.name : "no_material"]"
		if(isnull(stool_cache[cache_key]))
			var/image/I = image(icon, "[base_icon]_armrest")
			I.plane = MOB_PLANE
			I.layer = ABOVE_MOB_LAYER
			if(padding_material)
				I.color = padding_material.icon_colour
			stool_cache[cache_key] = I
		add_overlay(stool_cache[cache_key])

/obj/structure/bed/chair/proc/update_layer()
	if(src.dir == NORTH)
		plane = MOB_PLANE
		layer = MOB_LAYER + 0.1
	else
		reset_plane_and_layer()

/obj/structure/bed/chair/set_dir()
	..()
	update_layer()
	if(has_buckled_mobs())
		for(var/mob/living/L as anything in buckled_mobs)
			L.set_dir(dir)

/obj/structure/bed/chair/verb/rotate_clockwise()
	set name = "Rotate Chair Clockwise"
	set category = "Object"
	set src in oview(1)

	if(!usr || !isturf(usr.loc))
		return
	if(usr.stat || usr.restrained())
		return
	if(ismouse(usr) || (isobserver(usr) && !CONFIG_GET(flag/ghost_interaction)))
		return

	src.set_dir(turn(src.dir, 270))

/obj/structure/bed/chair/verb/rotate_counterclockwise()
	set name = "Rotate Chair Counter-Clockwise"
	set category = "Object"
	set src in oview(1)

	if(!usr || !isturf(usr.loc))
		return
	if(usr.stat || usr.restrained())
		return
	if(ismouse(usr) || (isobserver(usr) && !CONFIG_GET(flag/ghost_interaction)))
		return

	src.set_dir(turn(src.dir, 90))

/obj/structure/bed/chair/shuttle
	name = "chair"
	icon_state = "shuttlechair"
	base_icon = "shuttlechair"
	color = null
	applies_material_colour = 0

/obj/structure/bed/chair/shuttle_padded
	icon_state = "shuttlechair2"
	base_icon = "shuttlechair2"
	color = null
	applies_material_colour = 0

/obj/structure/bed/chair/comfy
	name = "comfy chair"
	desc = "It's a chair. It looks comfy."
	icon_state = "comfychair"
	base_icon = "comfychair"

/obj/structure/bed/chair/comfy/update_icon()
	..()
	var/image/I = image(icon, "[base_icon]_over")
	I.layer = ABOVE_MOB_LAYER
	I.plane = MOB_PLANE
	I.color = material.icon_colour
	add_overlay(I)
	if(padding_material)
		I = image(icon, "[base_icon]_padding_over")
		I.layer = ABOVE_MOB_LAYER
		I.plane = MOB_PLANE
		I.color = padding_material.icon_colour
		add_overlay(I)

/obj/structure/bed/chair/comfy/brown/Initialize(var/newloc, var/new_material, var/new_padding_material)
	. = ..(newloc, MAT_STEEL, MAT_LEATHER)

/obj/structure/bed/chair/comfy/red/Initialize(var/newloc, var/new_material, var/new_padding_material)
	. = ..(newloc, MAT_STEEL, MAT_CARPET)

/obj/structure/bed/chair/comfy/teal/Initialize(var/newloc, var/new_material, var/new_padding_material)
	. = ..(newloc, MAT_STEEL, MAT_CLOTH_TEAL)

/obj/structure/bed/chair/comfy/black/Initialize(var/newloc, var/new_material, var/new_padding_material)
	. = ..(newloc, MAT_STEEL, MAT_CLOTH_BLACK)

/obj/structure/bed/chair/comfy/green/Initialize(var/newloc, var/new_material, var/new_padding_material)
	. = ..(newloc, MAT_STEEL, MAT_CLOTH_GREEN)

/obj/structure/bed/chair/comfy/purp/Initialize(var/newloc, var/new_material, var/new_padding_material)
	. = ..(newloc, MAT_STEEL, MAT_CLOTH_PURPLE)

/obj/structure/bed/chair/comfy/blue/Initialize(var/newloc, var/new_material, var/new_padding_material)
	. = ..(newloc, MAT_STEEL, MAT_CLOTH_BLUE)

/obj/structure/bed/chair/comfy/beige/Initialize(var/newloc, var/new_material, var/new_padding_material)
	. = ..(newloc, MAT_STEEL, MAT_CLOTH_BEIGE)

/obj/structure/bed/chair/comfy/lime/Initialize(var/newloc, var/new_material, var/new_padding_material)
	. = ..(newloc, MAT_STEEL, MAT_CLOTH_LIME)

/obj/structure/bed/chair/comfy/yellow/Initialize(var/newloc, var/new_material, var/new_padding_material)
	. = ..(newloc, MAT_STEEL, MAT_CLOTH_YELLOW)

/obj/structure/bed/chair/comfy/orange/Initialize(var/newloc, var/new_material, var/new_padding_material)
	. = ..(newloc, MAT_STEEL, MAT_CLOTH_ORANGE)

/obj/structure/bed/chair/comfy/rounded
	name = "rounded chair"
	desc = "It's a rounded chair. It looks comfy."
	icon_state = "roundedchair"
	base_icon = "roundedchair"

/obj/structure/bed/chair/comfy/rounded/brown/Initialize(var/newloc, var/new_material, var/new_padding_material)
	. = ..(newloc, MAT_STEEL, MAT_LEATHER)

/obj/structure/bed/chair/comfy/rounded/red/Initialize(var/newloc, var/new_material, var/new_padding_material)
	. = ..(newloc, MAT_STEEL, MAT_CARPET)

/obj/structure/bed/chair/comfy/rounded/teal/Initialize(var/newloc, var/new_material, var/new_padding_material)
	. = ..(newloc, MAT_STEEL, MAT_CLOTH_TEAL)

/obj/structure/bed/chair/comfy/rounded/black/Initialize(var/newloc, var/new_material, var/new_padding_material)
	. = ..(newloc, MAT_STEEL, MAT_CLOTH_BLACK)

/obj/structure/bed/chair/comfy/rounded/green/Initialize(var/newloc, var/new_material, var/new_padding_material)
	. = ..(newloc, MAT_STEEL, MAT_CLOTH_GREEN)

/obj/structure/bed/chair/comfy/rounded/purple/Initialize(var/newloc, var/new_material, var/new_padding_material)
	. = ..(newloc, MAT_STEEL, MAT_CLOTH_PURPLE)

/obj/structure/bed/chair/comfy/rounded/blue/Initialize(var/newloc, var/new_material, var/new_padding_material)
	. = ..(newloc, MAT_STEEL, MAT_CLOTH_BLUE)

/obj/structure/bed/chair/comfy/rounded/beige/Initialize(var/newloc, var/new_material, var/new_padding_material)
	. = ..(newloc, MAT_STEEL, MAT_CLOTH_BEIGE)

/obj/structure/bed/chair/comfy/rounded/lime/Initialize(var/newloc, var/new_material, var/new_padding_material)
	. = ..(newloc, MAT_STEEL, MAT_CLOTH_LIME)

/obj/structure/bed/chair/comfy/rounded/yellow/Initialize(var/newloc, var/new_material, var/new_padding_material)
	. = ..(newloc, MAT_STEEL, MAT_CLOTH_YELLOW)

/obj/structure/bed/chair/comfy/rounded/orange/Initialize(var/newloc, var/new_material, var/new_padding_material)
	. = ..(newloc, MAT_STEEL, MAT_CLOTH_ORANGE)

/obj/structure/bed/chair/office
	anchored = FALSE
	buckle_movable = 1

/obj/structure/bed/chair/office/update_icon()
	return

/obj/structure/bed/chair/office/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/stack) || W.has_tool_quality(TOOL_WIRECUTTER))
		return
	..()

/obj/structure/bed/chair/office/Moved(atom/old_loc, direction, forced = FALSE)
	. = ..()

	playsound(src, 'sound/effects/roll.ogg', 100, 1)

/obj/structure/bed/chair/office/handle_buckled_mob_movement(atom/new_loc, direction, movetime)
	for(var/mob/living/occupant as anything in buckled_mobs)
		occupant.buckled = null
		occupant.Move(loc, direction, movetime)
		occupant.buckled = src
		if (occupant && (loc != occupant.loc))
			if (propelled)
				for (var/mob/O in src.loc)
					if (O != occupant)
						Bump(O)
			else
				unbuckle_mob()

/obj/structure/bed/chair/office/Bump(atom/A)
	..()
	if(!has_buckled_mobs())	return

	if(propelled)
		for(var/a in buckled_mobs)
			var/mob/living/occupant = unbuckle_mob(a)

			var/def_zone = ran_zone()
			var/blocked = occupant.run_armor_check(def_zone, "melee")
			var/soaked = occupant.get_armor_soak(def_zone, "melee")
			occupant.throw_at(A, 3, propelled)
			occupant.apply_effect(6, STUN, blocked)
			occupant.apply_effect(6, WEAKEN, blocked)
			occupant.apply_effect(6, STUTTER, blocked)
			occupant.apply_damage(10, BRUTE, def_zone, blocked, soaked)
			playsound(src, 'sound/weapons/punch1.ogg', 50, 1, -1)
			if(isliving(A))
				var/mob/living/victim = A
				def_zone = ran_zone()
				blocked = victim.run_armor_check(def_zone, "melee")
				soaked = victim.get_armor_soak(def_zone, "melee")
				victim.apply_effect(6, STUN, blocked)
				victim.apply_effect(6, WEAKEN, blocked)
				victim.apply_effect(6, STUTTER, blocked)
				victim.apply_damage(10, BRUTE, def_zone, blocked, soaked)
			occupant.visible_message(span_danger("[occupant] crashed into \the [A]!"))

/obj/structure/bed/chair/office/light
	icon_state = "officechair_white"

/obj/structure/bed/chair/office/dark
	icon_state = "officechair_dark"

// Chair types
/obj/structure/bed/chair/wood
	name = "wooden chair"
	desc = "Old is never too old to not be in fashion."
	icon_state = "wooden_chair"

/obj/structure/bed/chair/wood/update_icon()
	return

/obj/structure/bed/chair/wood/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/stack) || W.has_tool_quality(TOOL_WIRECUTTER))
		return
	..()

/obj/structure/bed/chair/wood/Initialize(var/newloc)
	. = ..(newloc, MAT_WOOD)

/obj/structure/bed/chair/wood/wings
	icon_state = "wooden_chair_wings"

//sofa

/obj/structure/bed/chair/sofa
	name = "sofa"
	desc = "It's a sofa. You sit on it. Possibly with someone else."
	icon = 'icons/obj/sofas.dmi'
	base_icon = "sofamiddle"
	icon_state = "sofamiddle"
	applies_material_colour = 1
	var/sofa_material = MAT_CARPET
	var/corner_piece = FALSE

/obj/structure/bed/chair/sofa/update_icon()
	if(applies_material_colour && sofa_material)
		var/datum/material/color_material = get_material_by_name(sofa_material)
		color = color_material.icon_colour

		if(sofa_material == MAT_CARPET)
			name = "red [initial(name)]"
		else
			name = "[sofa_material] [initial(name)]"

/obj/structure/bed/chair/sofa/update_layer()
	// Corner east/west should be on top of mobs, any other state's north should be.
	if(!corner_piece && (dir & NORTH))
		plane = MOB_PLANE
		layer = MOB_LAYER + 0.1
	else
		reset_plane_and_layer()

/obj/structure/bed/chair/sofa/left
	icon_state = "sofaend_left"
	base_icon = "sofaend_left"

/obj/structure/bed/chair/sofa/right
	icon_state = "sofaend_right"
	base_icon = "sofaend_right"

/obj/structure/bed/chair/sofa/corner
	icon_state = "sofacorner"
	base_icon = "sofacorner"
	corner_piece = TRUE

/obj/structure/bed/chair/sofa/corner/update_icon()
	..()
	var/cache_key = "[base_icon]-armrest-[padding_material ? padding_material.name : "no_material"]-permanent"
	if(isnull(stool_cache[cache_key]))
		var/image/I = image(icon, "[base_icon]_armrest")
		I.plane = MOB_PLANE
		I.layer = ABOVE_MOB_LAYER
		if(padding_material)
			I.color = padding_material.icon_colour
		stool_cache[cache_key] = I
	add_overlay(stool_cache[cache_key])

// Wooden nonsofa - no corners
/obj/structure/bed/chair/sofa/pew
	name = "pew bench"
	desc = "If they want you to go to church, why do they make these so uncomfortable?"
	base_icon = "pewmiddle"
	icon_state = "pewmiddle"
	applies_material_colour = FALSE

/obj/structure/bed/chair/sofa/pew/left
	icon_state = "pewend_left"
	base_icon = "pewend_left"

/obj/structure/bed/chair/sofa/pew/right
	icon_state = "pewend_right"
	base_icon = "pewend_right"

// Metal benches from Skyrat
/obj/structure/bed/chair/sofa/bench
	name = "metal bench"
	desc = "Almost as comfortable as waiting at a bus station for hours on end."
	base_icon = "benchmiddle"
	icon_state = "benchmiddle"
	applies_material_colour = FALSE
	color = null
	var/padding_color = "#CC0000"

/obj/structure/bed/chair/sofa/bench/Initialize(var/newloc, var/new_material, var/new_padding_material)
	. = ..()
	var/mutable_appearance/MA
	// If we're north-facing, metal goes above mob, padding overlay goes below mob.
	if((dir & NORTH) && !corner_piece)
		plane = MOB_PLANE
		layer = ABOVE_MOB_LAYER
		MA = mutable_appearance(icon, icon_state = "o[icon_state]", layer = BELOW_MOB_LAYER, plane = MOB_PLANE, appearance_flags = KEEP_APART|RESET_COLOR)
	// Else just normal plane and layer for everything, which will be below mobs.
	else
		MA = mutable_appearance(icon, icon_state = "o[icon_state]", appearance_flags = KEEP_APART|RESET_COLOR)
	MA.color = padding_color
	add_overlay(MA)

/obj/structure/bed/chair/sofa/bench/left
	icon_state = "bench_left"
	base_icon = "bench_left"

/obj/structure/bed/chair/sofa/bench/right
	icon_state = "bench_right"
	base_icon = "bench_right"

/obj/structure/bed/chair/sofa/bench/corner
	icon_state = "benchcorner"
	base_icon = "benchcorner"
	//corner_piece = TRUE // These sprites work fine without the parent doing layer shenanigans

// Corporate sofa - one color fits all
/obj/structure/bed/chair/sofa/corp
	name = "black leather sofa"
	desc = "How corporate!"
	base_icon = "corp_sofamiddle"
	icon_state = "corp_sofamiddle"
	applies_material_colour = FALSE

/obj/structure/bed/chair/sofa/corp/left
	icon_state = "corp_sofaend_left"
	base_icon = "corp_sofaend_left"

/obj/structure/bed/chair/sofa/corp/right
	icon_state = "corp_sofaend_right"
	base_icon = "corp_sofaend_right"

/obj/structure/bed/chair/sofa/corp/corner
	icon_state = "corp_sofacorner"
	base_icon = "corp_sofacorner"
	corner_piece = TRUE

//color variations
//Middle sofas first
/obj/structure/bed/chair/sofa
	sofa_material = MAT_CARPET

/obj/structure/bed/chair/sofa/brown
	sofa_material = MAT_LEATHER

/obj/structure/bed/chair/sofa/teal
	sofa_material = MAT_CLOTH_TEAL

/obj/structure/bed/chair/sofa/black
	sofa_material = MAT_CLOTH_BLACK

/obj/structure/bed/chair/sofa/green
	sofa_material = MAT_CLOTH_GREEN

/obj/structure/bed/chair/sofa/purp
	sofa_material = MAT_CLOTH_PURPLE

/obj/structure/bed/chair/sofa/blue
	sofa_material = MAT_CLOTH_BLUE

/obj/structure/bed/chair/sofa/beige
	sofa_material = MAT_CLOTH_BEIGE

/obj/structure/bed/chair/sofa/lime
	sofa_material = MAT_CLOTH_LIME

/obj/structure/bed/chair/sofa/yellow
	sofa_material = MAT_CLOTH_YELLOW

/obj/structure/bed/chair/sofa/orange
	sofa_material = MAT_CLOTH_ORANGE

//sofa directions

/obj/structure/bed/chair/sofa/left
	icon_state = "sofaend_left"

/obj/structure/bed/chair/sofa/right
	icon_state = "sofaend_right"

/obj/structure/bed/chair/sofa/corner
	icon_state = "sofacorner"

/obj/structure/bed/chair/sofa/left/brown
	sofa_material = MAT_LEATHER

/obj/structure/bed/chair/sofa/right/brown
	sofa_material = MAT_LEATHER

/obj/structure/bed/chair/sofa/corner/brown
	sofa_material = MAT_LEATHER

/obj/structure/bed/chair/sofa/left/teal
	sofa_material = MAT_CLOTH_TEAL

/obj/structure/bed/chair/sofa/right/teal
	sofa_material = MAT_CLOTH_TEAL

/obj/structure/bed/chair/sofa/corner/teal
	sofa_material = MAT_CLOTH_TEAL

/obj/structure/bed/chair/sofa/left/black
	sofa_material = MAT_CLOTH_BLACK

/obj/structure/bed/chair/sofa/right/black
	sofa_material = MAT_CLOTH_BLACK

/obj/structure/bed/chair/sofa/corner/black
	sofa_material = MAT_CLOTH_BLACK

/obj/structure/bed/chair/sofa/left/green
	sofa_material = MAT_CLOTH_GREEN

/obj/structure/bed/chair/sofa/right/green
	sofa_material = MAT_CLOTH_GREEN

/obj/structure/bed/chair/sofa/corner/green
	sofa_material = MAT_CLOTH_GREEN

/obj/structure/bed/chair/sofa/left/purp
	sofa_material = MAT_CLOTH_PURPLE

/obj/structure/bed/chair/sofa/right/purp
	sofa_material = MAT_CLOTH_PURPLE

/obj/structure/bed/chair/sofa/corner/purp
	sofa_material = MAT_CLOTH_PURPLE

/obj/structure/bed/chair/sofa/left/blue
	sofa_material = MAT_CLOTH_BLUE

/obj/structure/bed/chair/sofa/right/blue
	sofa_material = MAT_CLOTH_BLUE

/obj/structure/bed/chair/sofa/corner/blue
	sofa_material = MAT_CLOTH_BLUE

/obj/structure/bed/chair/sofa/left/beige
	sofa_material = MAT_CLOTH_BEIGE

/obj/structure/bed/chair/sofa/right/beige
	sofa_material = MAT_CLOTH_BEIGE

/obj/structure/bed/chair/sofa/corner/beige
	sofa_material = MAT_CLOTH_BEIGE

/obj/structure/bed/chair/sofa/left/lime
	sofa_material = MAT_CLOTH_LIME

/obj/structure/bed/chair/sofa/right/lime
	sofa_material = MAT_CLOTH_LIME

/obj/structure/bed/chair/sofa/corner/lime
	sofa_material = MAT_CLOTH_LIME

/obj/structure/bed/chair/sofa/left/yellow
	sofa_material = MAT_CLOTH_YELLOW

/obj/structure/bed/chair/sofa/right/yellow
	sofa_material = MAT_CLOTH_YELLOW

/obj/structure/bed/chair/sofa/corner/yellow
	sofa_material = MAT_CLOTH_YELLOW

/obj/structure/bed/chair/sofa/left/orange
	sofa_material = MAT_CLOTH_ORANGE

/obj/structure/bed/chair/sofa/right/orange
	sofa_material = MAT_CLOTH_ORANGE

/obj/structure/bed/chair/sofa/corner/orange
	sofa_material = MAT_CLOTH_ORANGE
