/obj/structure/reflector
	name = "reflector base"
	icon = 'icons/obj/structures/tgs_structures.dmi'
	icon_state = "reflector_map"
	desc = "A base for reflector assemblies."
	anchored = FALSE
	density = FALSE
	var/deflector_icon_state
	var/image/deflector_overlay
	var/finished = FALSE
	var/admin = FALSE //Can't be rotated or deconstructed
	var/can_rotate = TRUE
	var/framebuildstacktype = /obj/item/stack/material//metal
	var/framebuildstackamount = 5
	var/buildstacktype = /obj/item/stack/material//metal
	var/buildstackamount = 0
	var/fires_projectile = /obj/item/projectile/beam/emitter
	var/fires_accuracy = 10000
	var/fires_dispersion = 0
	var/list/allowed_projectile_typecache = list(/obj/item/projectile/beam)
	var/rotation_angle = -1
	var/can_decon = TRUE
	var/list/has_projectiles = list()
	var/bullet_act_in_progress = FALSE

/obj/structure/reflector/Initialize(mapload)
	. = ..()
	icon_state = "reflector_base"
	allowed_projectile_typecache = typecacheof(allowed_projectile_typecache)
	if(deflector_icon_state)
		deflector_overlay = image(icon, deflector_icon_state)
		add_overlay(deflector_overlay)

	if(rotation_angle == -1)
		setAngle(dir2angle(dir))
	else
		setAngle(rotation_angle)

	if(admin)
		can_rotate = FALSE

	SSreflector.processing += src

/obj/structure/reflector/examine(mob/user)
	. = ..()
	if(finished)
		. += "It is set to [rotation_angle] degrees, and the rotation is [can_rotate ? "unlocked" : "locked"]."
		if(!admin)
			if(can_rotate)
				. += span_notice("Alt-click to adjust its direction.")
			else
				. += span_notice("Use screwdriver to unlock the rotation.")

/obj/structure/reflector/proc/Fire()
	UNTIL(!bullet_act_in_progress)
	var/list/angles = list()
	for(var/obj/item/projectile/P in has_projectiles)
		angles[num2text(has_projectiles[P])] += P.damage
	for(var/angle in angles)
		var/obj/item/projectile/P = new fires_projectile(src)
		P.firer = src
		P.damage = angles[angle]
		P.accuracy = 350
		P.dispersion = 0
		P.fire(text2num(angle))
	has_projectiles = list()

/obj/structure/reflector/proc/setAngle(new_angle)
	if(can_rotate)
		rotation_angle = new_angle
		if(deflector_overlay)
			cut_overlay(deflector_overlay)
			deflector_overlay.transform = turn(matrix(), new_angle)
			add_overlay(deflector_overlay)

/obj/structure/reflector/proc/redirect_projectile(obj/item/projectile/P,pangle)
	has_projectiles[P] = pangle
	qdel(P)

/obj/structure/reflector/set_dir(new_dir)
	return ..(NORTH)

/obj/structure/reflector/Crossed(atom/movable/AM)	//Ok so this is my solution to garbage projectile code. Please god let this work.
	if(istype(AM,/obj/item/projectile))
		AM.Bump(src)

/obj/structure/reflector/bullet_act(obj/item/projectile/P)
	bullet_act_in_progress = TRUE
	var/pdir = P.dir
	var/pangle = P.Angle
	var/ploc = get_turf(P)
	if(!finished || !allowed_projectile_typecache[P.type] || !(P.dir in GLOB.cardinal))
		return ..()
	if(auto_reflect(P, pdir, ploc, pangle) != 2)
		return ..()
	bullet_act_in_progress = FALSE

/obj/structure/reflector/proc/auto_reflect(obj/item/projectile/P, pdir, turf/ploc, pangle)
	P.ignore_source_check = TRUE
	return 2

/obj/structure/reflector/attackby(obj/item/W, mob/user, params)
	if(admin)
		return

	if(W.is_screwdriver())
		can_rotate = !can_rotate
		to_chat(user, span_notice("You [can_rotate ? "unlock" : "lock"] [src]'s rotation."))
		playsound(W, W.usesound, 50, 1)
		return

	if(W.is_wrench() && can_decon)
		if(anchored)
			to_chat(user, span_warning("Unweld [src] from the floor first!"))
			return
		user.visible_message(span_notice("[user] starts to dismantle [src]."), span_notice("You start to dismantle [src]..."))

		if(do_after(user, 2 SECONDS, target = src))
			user.visible_message(span_notice("[user] dismantles [src]."), span_notice("You dismantle [src]..."))
			new framebuildstacktype(drop_location(), framebuildstackamount)
			if(buildstackamount)
				new buildstacktype(drop_location(), buildstackamount)
			qdel(src)
	else if(istype(W, /obj/item/weldingtool))
		var/obj/item/weldingtool/I = W
		if(!anchored)
			if(!I.get_fuel())
				to_chat(user, span_warning("You require fuel to weld the [src]!"))
				return

			user.visible_message(span_notice("[user] starts to weld [src] to the floor."),
								span_notice("You start to weld [src] to the floor..."),
								span_hear("You hear welding."))

			if(do_after(user, 2 SECONDS, target = src))
				if(!I.remove_fuel(1,user))
					to_chat(user, span_warning("You require fuel to weld the [src]!"))
					return
			anchored = TRUE
			user.visible_message(span_notice("[user] welds [src] to the floor."),
								span_notice("You weld [src] to the floor..."),
								span_hear("You hear welding."))
		else
			if(!I.remove_fuel(1,user))
				return

			user.visible_message(span_notice("[user] starts to cut [src] free from the floor."),
								span_notice("You start to cut [src] free from the floor..."),
								span_hear("You hear welding."))
			anchored = FALSE
			to_chat(user, span_notice("You cut [src] free from the floor."))

	//Finishing the frame
	else if(istype(W, /obj/item/stack/material))
		if(finished)
			return
		var/obj/item/stack/material/S = W
		if(istype(S, /obj/item/stack/material/glass))
			if(S.use(5))
				new /obj/structure/reflector/single(drop_location())
				qdel(src)
			else
				to_chat(user, span_warning("You need five sheets of glass to create a reflector!"))
				return
		if(istype(S, /obj/item/stack/material/glass/reinforced))
			if(S.use(10))
				new /obj/structure/reflector/double(drop_location())
				qdel(src)
			else
				to_chat(user, span_warning("You need ten sheets of reinforced glass to create a double reflector!"))
				return
		if(istype(S, /obj/item/stack/material/diamond))
			if(S.use(1))
				new /obj/structure/reflector/box(drop_location())
				qdel(src)
	else
		return ..()

/obj/structure/reflector/proc/rotate(mob/user)
	if (!can_rotate || admin)
		to_chat(user, span_warning("The rotation is locked!"))
		return FALSE
	var/new_angle = tgui_input_number(user, "Input a new angle for primary reflection face.", "Reflector Angle", rotation_angle, 360, -360)
	if(!CanUseTopic(user))
		return
	if(!isnull(new_angle))
		setAngle(SIMPLIFY_DEGREES(new_angle))
	return TRUE

/obj/structure/reflector/click_alt(mob/user)
	if(!CanUseTopic(user))
		return
	else if(finished)
		rotate(user)


//TYPES OF REFLECTORS, SINGLE, DOUBLE, BOX

//SINGLE

/obj/structure/reflector/single
	name = "reflector"
	deflector_icon_state = "reflector"
	desc = "An angled mirror for reflecting laser beams."
	density = TRUE
	finished = TRUE
	buildstacktype = /obj/item/stack/material//glass
	buildstackamount = 5

/obj/structure/reflector/single/anchored
	anchored = TRUE

/obj/structure/reflector/single/mapping
	admin = TRUE
	anchored = TRUE

/obj/structure/reflector/single/auto_reflect(obj/item/projectile/P, pdir, turf/ploc, pangle)
	var/incidence = GET_ANGLE_OF_INCIDENCE(rotation_angle, (P.Angle + 180))
	if(abs(incidence) > 90 && abs(incidence) < 270)
		return FALSE
	var/new_angle = SIMPLIFY_DEGREES(rotation_angle + incidence)
	redirect_projectile(P,new_angle)
	return ..()

//DOUBLE

/obj/structure/reflector/double
	name = "double sided reflector"
	deflector_icon_state = "reflector_double"
	desc = "A double sided angled mirror for reflecting laser beams."
	density = TRUE
	finished = TRUE
	buildstacktype = /obj/item/stack/material/glass/reinforced
	buildstackamount = 10

/obj/structure/reflector/double/anchored
	anchored = TRUE

/obj/structure/reflector/double/mapping
	admin = TRUE
	anchored = TRUE

/obj/structure/reflector/double/auto_reflect(obj/item/projectile/P, pdir, turf/ploc, pangle)
	var/incidence = GET_ANGLE_OF_INCIDENCE(rotation_angle, (P.Angle + 180))
	var/new_angle = SIMPLIFY_DEGREES(rotation_angle + incidence)
	redirect_projectile(P,new_angle)
	return ..()

//BOX

/obj/structure/reflector/box
	name = "reflector box"
	deflector_icon_state = "reflector_box"
	desc = "A box with an internal set of mirrors that reflects all laser beams in a single direction."
	density = TRUE
	finished = TRUE
	buildstacktype = /obj/item/stack/material/diamond
	buildstackamount = 1

/obj/structure/reflector/box/Fire()	//Since they all end up at the same angle, this should save a tad bit of processing power and memory <3
	UNTIL(!bullet_act_in_progress)
	var/total_damage = 0
	for(var/obj/item/projectile/P in has_projectiles)
		total_damage += P.damage
	if(total_damage)
		var/obj/item/projectile/P = new fires_projectile(src)
		P.firer = src
		P.damage = total_damage
		P.accuracy = 350
		P.dispersion = 0
		P.fire(rotation_angle)
	has_projectiles = list()

/obj/structure/reflector/box/anchored
	anchored = TRUE

/obj/structure/reflector/box/mapping
	admin = TRUE
	anchored = TRUE

/obj/structure/reflector/box/auto_reflect(obj/item/projectile/P)
	redirect_projectile(P,rotation_angle)
	return ..()

/obj/structure/reflector/ex_act()
	if(admin)
		return
	else
		return ..()

/obj/structure/reflector/singularity_act()
	if(admin)
		return
	else
		return ..()

/obj/structure/reflector/box/orderable
	name = "NanoTrasen reflector box"
	desc = "A box with an internal set of mirrors that reflects all laser beams in a single direction. This one is marked with NanoTrasen's logo."
	can_decon = FALSE

/datum/material/steel/generate_recipes()
	..()
	recipes += new/datum/stack_recipe("reflector frame", /obj/structure/reflector, 5, time = 25, one_per_turf = TRUE, on_floor = TRUE)

/datum/supply_pack/eng/reflector
	name = "Reflector crate"
	cost = 35
	containername = "Reflector crate"
	containertype = /obj/structure/closet/crate/secure/einstein
	contains = list(/obj/structure/reflector/box/orderable = 3)

//Below is mostly mapping stuff for the spicy storage I added to house these new reflectors ;p

/area/engineering/secret_storage
	name = "Engineering Secret Storage"

/obj/machinery/portable_atmospherics/canister
	var/dont_burst = FALSE

/obj/machinery/portable_atmospherics/canister/phoron/cold/Initialize(mapload)
	. = ..()
	src.air_contents.temperature = 2.72
