/// Returns a randomly picked poster decl of the subtype specified by the path argument. If the exact argument is true, it will return the decl from the decls_repository of the exact path specified.
/proc/get_poster_decl(var/path = null, var/exact = TRUE, var/forbid_types)
	if(ispath(path))
		if(exact)
			return decls_repository.get_decl(path)
		else
			// Get the list of decals and Remove some forbidden types. These two base types don't have proper icon_states so they're illegal.
			var/list/L = decls_repository.get_decls_of_type(path)
			L -= decls_repository.get_decl(/decl/poster/lewd)
			if(forbid_types)
				L -= decls_repository.get_decls_of_type(forbid_types)
			return L[pick(L)]
	return null

/obj/item/poster
	name = "rolled-up poster"
	desc = "The poster comes with its own automatic adhesive mechanism, for easy pinning to any vertical surface."
	icon = 'icons/obj/contraband.dmi'
	icon_state = "rolled_poster"
	drop_sound = 'sound/items/drop/wrapper.ogg'
	pickup_sound = 'sound/items/pickup/wrapper.ogg'
	force = 0
	VAR_PROTECTED/decl/poster/poster_decl = null
	VAR_PROTECTED/poster_type = /obj/structure/sign/poster

/obj/item/poster/Initialize(mapload, var/decl/poster/P = null)
	if(ispath(poster_decl))
		poster_decl = get_poster_decl(poster_decl, TRUE, null)
	else if(istype(P))
		poster_decl = P
	else if(ispath(P))
		poster_decl = get_poster_decl(P, TRUE, null)
	else
		poster_decl = get_poster_decl(/decl/poster, FALSE, /decl/poster/lewd)

	name += " - [poster_decl.name]"
	return ..()

/// Get the current poster_decl
/obj/item/poster/proc/get_decl()
	RETURN_TYPE(/decl/poster)
	SHOULD_NOT_OVERRIDE(TRUE)
	return poster_decl

//Places the poster on a wall
/obj/item/poster/afterattack(var/atom/A, var/mob/user, var/adjacent, var/clickparams)
	if(!adjacent)
		return FALSE

	//must place on a wall and user must not be inside a closet/mecha/whatever
	var/turf/W = A
	if(!iswall(W) || !isturf(user.loc))
		to_chat(user, span_warning("You can't place this here!"))
		return FALSE

	var/placement_dir = get_dir(user, W)
	if(!(placement_dir in GLOB.cardinal))
		to_chat(user, span_warning("You must stand directly in front of the wall you wish to place that on."))
		return FALSE

	//just check if there is a poster on or adjacent to the wall
	var/stuff_on_wall = 0
	if(locate(/obj/structure/sign/poster) in W)
		stuff_on_wall = 1

	//crude, but will cover most cases. We could do stuff like check pixel_x/y but it's not really worth it.
	for (var/dir in GLOB.cardinal)
		var/turf/T = get_step(W, dir)
		if (locate(/obj/structure/sign/poster) in T)
			stuff_on_wall = 1
			break

	if(stuff_on_wall)
		to_chat(user, span_notice("There is already a poster there!"))
		return FALSE

	to_chat(user, span_notice("You start placing the poster on the wall...")) //Looks like it's uncluttered enough. Place the poster.

	var/obj/structure/sign/poster/P = new poster_type(user.loc, get_dir(user, W), src)

	if(do_after(user, 17)) //Let's check if everything is still there
		to_chat(user, span_notice("You place the poster!"))
		qdel(src)
		return TRUE

	P.roll_and_drop(P.loc)
	qdel(src)
	return FALSE

//############################## THE ACTUAL DECALS ###########################

/obj/structure/sign/poster
	name = "poster"
	desc = "A large piece of space-resistant printed paper. "
	icon = 'icons/obj/contraband_vr.dmi' //VOREStation Edit
	icon_state = "poster" //VOREStation Edit
	anchored = TRUE
	VAR_PROTECTED/decl/poster/poster_decl = null // Assigned by Initialize() to a random poster decl. If this is mapset to a path, it will be used to locate the decl specified by that path.
	VAR_PROTECTED/roll_type = /obj/item/poster
	VAR_PRIVATE/ruined = FALSE

/obj/structure/sign/poster/Initialize(mapload, var/placement_dir = null, var/obj/item/poster/P = null)
	. = ..()

	if(ispath(poster_decl))
		poster_decl = get_poster_decl(poster_decl, TRUE, null)
	else if(istype(P))
		poster_decl = P.get_decl()
		roll_type = P.type
	else if(ispath(P))
		poster_decl = get_poster_decl(P, TRUE, null)
	else
		poster_decl = get_poster_decl(/decl/poster, FALSE, /decl/poster/lewd)

	name = "[initial(name)] - [poster_decl.name]"
	desc = "[initial(desc)] [poster_decl.desc]"
	if(poster_decl.icon_override)
		icon = poster_decl.icon_override
	icon_state = poster_decl.icon_state

	if(placement_dir)
		dir = placement_dir

	switch (dir)
		if (NORTH)
			pixel_x = 0
			pixel_y = 32
		if (SOUTH)
			pixel_x = 0
			pixel_y = -32
		if (EAST)
			pixel_x = 32
			pixel_y = 0
		if (WEST)
			pixel_x = -32
			pixel_y = 0

	flick("poster_being_set", src) // If you don't see this animation, check that the decl/poster's icon_override dmi file has the icon states for poster_being_set and poster_ripped in it.

/obj/structure/sign/poster/attackby(obj/item/W as obj, mob/user as mob)
	if(W.has_tool_quality(TOOL_WIRECUTTER))
		playsound(src, W.usesound, 100, 1)
		if(ruined)
			to_chat(user, span_notice("You remove the remnants of the poster."))
			qdel(src)
		else
			to_chat(user, span_notice("You carefully remove the poster from the wall."))
			roll_and_drop(get_turf(user))
		return

/obj/structure/sign/poster/attack_hand(mob/user as mob)
	if(ruined)
		return

	if(tgui_alert(user, "Do I want to rip the poster from the wall?","You think...",list("Yes","No")) == "Yes")
		if(ruined || !user.Adjacent(src))
			return

		visible_message(span_warning("[user] rips [src] in a single, decisive motion!") )
		playsound(src, 'sound/items/poster_ripped.ogg', 100, 1)
		ruined = TRUE
		icon_state = "poster_ripped"
		name = "ripped poster"
		desc = "You can't make out anything from the poster's original print. It's ruined."
		add_fingerprint(user)

/// Creates a poster item using roll_type as the path, and qdels the wall poster
/obj/structure/sign/poster/proc/roll_and_drop(turf/newloc)
	SHOULD_NOT_OVERRIDE(TRUE)
	var/obj/item/poster/P = new roll_type(newloc, poster_decl)
	P.loc = newloc
	qdel(src)
