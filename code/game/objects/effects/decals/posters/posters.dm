/proc/get_poster_decl(var/path = null, var/exact = TRUE)
	if(ispath(path))
		if(exact)
			return decls_repository.get_decl(path)
		else
			var/list/L = decls_repository.get_decls_of_type(path)
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
	var/decl/poster/poster_decl = null
	var/poster_type = /obj/structure/sign/poster

/obj/item/poster/Initialize(var/mapload, var/decl/poster/poster_decl = null)
	if(ispath(src.poster_decl))
		src.poster_decl = get_poster_decl(src.poster_decl, TRUE)
	else if(istype(poster_decl))
		src.poster_decl = poster_decl
	else if(ispath(poster_decl))
		src.poster_decl = get_poster_decl(poster_decl, TRUE)
	else
		src.poster_decl = get_poster_decl(/decl/poster, FALSE)
		while (istype(src.poster_decl, /decl/poster/lewd))
			src.poster_decl = get_poster_decl(/decl/poster, FALSE)

	name += " - [src.poster_decl.name]"
	return ..()

//Places the poster on a wall
/obj/item/poster/afterattack(var/atom/A, var/mob/user, var/adjacent, var/clickparams)
	if(!adjacent)
		return FALSE

	//must place on a wall and user must not be inside a closet/mecha/whatever
	var/turf/W = A
	if(!iswall(W) || !isturf(user.loc))
		to_chat(user, "<span class='warning'>You can't place this here!</span>")
		return FALSE

	var/placement_dir = get_dir(user, W)
	if(!(placement_dir in cardinal))
		to_chat(user, "<span class='warning'>You must stand directly in front of the wall you wish to place that on.</span>")
		return FALSE

	//just check if there is a poster on or adjacent to the wall
	var/stuff_on_wall = 0
	if(locate(/obj/structure/sign/poster) in W)
		stuff_on_wall = 1

	//crude, but will cover most cases. We could do stuff like check pixel_x/y but it's not really worth it.
	for (var/dir in cardinal)
		var/turf/T = get_step(W, dir)
		if (locate(/obj/structure/sign/poster) in T)
			stuff_on_wall = 1
			break

	if(stuff_on_wall)
		to_chat(user, "<span class='notice'>There is already a poster there!</span>")
		return FALSE

	to_chat(user, "<span class='notice'>You start placing the poster on the wall...</span>") //Looks like it's uncluttered enough. Place the poster.

	var/obj/structure/sign/poster/P = new poster_type(user.loc, get_dir(user, W), src)

	if(do_after(user, 17)) //Let's check if everything is still there
		to_chat(user, "<span class='notice'>You place the poster!</span>")
		qdel(src)
		return TRUE

	P.roll_and_drop(P.loc)
	qdel(src)
	return FALSE

//NT subtype
/obj/item/poster/nanotrasen
	icon_state = "rolled_poster_nt"
	poster_type = /obj/structure/sign/poster/nanotrasen

/obj/item/poster/nanotrasen/Initialize(turf/loc, var/decl/poster/P = null)
	if(!ispath(src.poster_decl) && !ispath(P) && !istype(P))
		src.poster_decl = get_poster_decl(/decl/poster/nanotrasen, FALSE)
	return ..()

//Selectable subtype
/obj/item/poster/custom
	name = "rolled-up poly-poster"
	desc = "The poster comes with its own automatic adhesive mechanism, for easy pinning to any vertical surface. This one is made from some kind of e-paper, and could display almost anything!"
	poster_type = /obj/structure/sign/poster/custom

/obj/item/poster/custom/verb/select_poster()
	set name = "Set Poster type"
	set category = "Object"
	set desc = "Click to choose a poster to display."

	var/mob/M = usr
	var/list/options = list()
	var/list/decl/poster/posters = decls_repository.get_decls_of_type(/decl/poster)
	for(var/option in posters)
		options[posters[option].name] = posters[option]

	var/choice = tgui_input_list(M, "Choose a poster!", "Customize Poster", options)
	if(src && choice && !M.stat && in_range(M,src))
		poster_decl = options[choice]
		name = "rolled-up poly-poster - [src.poster_decl.name]"
		to_chat(M, "The poster is now: [choice].")



//############################## THE ACTUAL DECALS ###########################

/obj/structure/sign/poster
	name = "poster"
	desc = "A large piece of space-resistant printed paper. "
	icon = 'icons/obj/contraband_vr.dmi' //VOREStation Edit
	icon_state = "poster" //VOREStation Edit
	anchored = TRUE
	var/decl/poster/poster_decl = null
	var/target_poster_decl_path = /decl/poster
	var/roll_type = /obj/item/poster
	var/ruined = FALSE

/obj/structure/sign/poster/Initialize(var/newloc, var/placement_dir = null, var/obj/item/poster/P = null)
	. = ..()

	if(ispath(src.poster_decl))
		src.poster_decl = get_poster_decl(src.poster_decl, TRUE)
	else if(istype(P))
		src.poster_decl = P.poster_decl
		roll_type = P.type
	else if(ispath(P))
		src.poster_decl = get_poster_decl(P, TRUE)
	else
		src.poster_decl = get_poster_decl(/decl/poster, FALSE)
		while (istype(src.poster_decl, /decl/poster/lewd))
			src.poster_decl = get_poster_decl(/decl/poster, FALSE)

	name = "[initial(name)] - [poster_decl.name]"
	desc = "[initial(desc)] [poster_decl.desc]"
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

	flick("poster_being_set", src)

/obj/structure/sign/poster/attackby(obj/item/W as obj, mob/user as mob)
	if(W.has_tool_quality(TOOL_WIRECUTTER))
		playsound(src, W.usesound, 100, 1)
		if(ruined)
			to_chat(user, "<span class='notice'>You remove the remnants of the poster.</span>")
			qdel(src)
		else
			to_chat(user, "<span class='notice'>You carefully remove the poster from the wall.</span>")
			roll_and_drop(get_turf(user))
		return

/obj/structure/sign/poster/attack_hand(mob/user as mob)

	if(ruined)
		return

	if(tgui_alert(usr, "Do I want to rip the poster from the wall?","You think...",list("Yes","No")) == "Yes")

		if(ruined || !user.Adjacent(src))
			return

		visible_message("<span class='warning'>[user] rips [src] in a single, decisive motion!</span>" )
		playsound(src, 'sound/items/poster_ripped.ogg', 100, 1)
		ruined = TRUE
		icon_state = "poster_ripped"
		name = "ripped poster"
		desc = "You can't make out anything from the poster's original print. It's ruined."
		add_fingerprint(user)

/obj/structure/sign/poster/proc/roll_and_drop(turf/newloc)
	var/obj/item/poster/P = new roll_type(newloc, poster_decl)
	P.loc = newloc
	qdel(src)

// NT poster subtype.
/obj/structure/sign/poster/nanotrasen
	roll_type = /obj/item/poster/nanotrasen
	target_poster_decl_path = /decl/poster/nanotrasen

// Non-Random Posters
/obj/structure/sign/poster/custom
	roll_type = /obj/item/poster/custom
