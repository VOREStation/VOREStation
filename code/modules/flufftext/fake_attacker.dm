/obj/effect/fake_attacker // I did want to use /image/client_only but this needs to be somewhat more complex
	name = ""
	desc = ""
	density = FALSE
	anchored = TRUE
	opacity = 0
	VAR_PRIVATE/list/clients = list()
	VAR_PRIVATE/list/image/dir_images = list()

/obj/effect/fake_attacker/process()
	. = ..()
	// Passive cleanup
	for(var/datum/weakref/C in clients)
		var/client/CW = C?.resolve()
		if(isnull(CW))
			clients.Remove(C)
	if(!clients.len)
		qdel(src)

/obj/effect/fake_attacker/set_dir(newdir)
	if(!(newdir in GLOB.cardinal))
		newdir &= ~(EAST|WEST) // Don't allow diagonals, prefer north/south
		if(!newdir)
			newdir = SOUTH
	var/updatesprite = (dir != newdir)
	. = ..()
	if(updatesprite)
		for(var/datum/weakref/C in clients)
			var/client/CW = C?.resolve()
			clear_images_from_client(CW)
			assign_image_to_client(CW)

/obj/effect/fake_attacker/Moved(atom/old_loc, direction, forced, movetime)
	. = ..()
	var/turf_move = isturf(loc) && isturf(old_loc)
	for(var/img in dir_images)
		var/image/G = dir_images[img]
		G.loc = loc
		if(turf_move)
			var/MT = 0.7 SECONDS
			G.pixel_x = (old_loc.x - loc.x) * WORLD_ICON_SIZE
			G.pixel_y = (old_loc.y - loc.y) * WORLD_ICON_SIZE
			animate(G, pixel_x = 0, time = MT, flags = ANIMATION_PARALLEL)
			animate(G, pixel_y = 0, time = MT, flags = ANIMATION_PARALLEL)

/obj/effect/fake_attacker/Destroy(force)
	. = ..()
	clear_every_clients_images()
	qdel_all_images()

/obj/effect/fake_attacker/proc/create_images_from(var/atom/clone)
	SHOULD_NOT_OVERRIDE(TRUE)
	dir_images["[NORTH]"] = image(clone,dir = NORTH)
	dir_images["[SOUTH]"] = image(clone,dir = SOUTH)
	dir_images["[EAST]"] = image(clone,dir = EAST)
	dir_images["[WEST]"] = image(clone,dir = WEST)
	for(var/img in dir_images)
		var/image/G = dir_images[img]
		G.layer = clone.layer
		G.plane = clone.plane
		G.appearance_flags = clone.appearance_flags
		G.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
		G.loc = loc

/obj/effect/fake_attacker/proc/append_client(var/client/C)
	SHOULD_NOT_OVERRIDE(TRUE)
	clients.Add(WEAKREF(C))
	assign_image_to_client(C)

/obj/effect/fake_attacker/proc/assign_image_to_client(var/client/C)
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_OVERRIDE(TRUE)
	if(!C)
		return
	if(!dir_images.len)
		return
	var/image/I = dir_images["[dir]"]
	if(I)
		C.images += I

/obj/effect/fake_attacker/proc/clear_every_clients_images()
	for(var/datum/weakref/C in clients)
		clear_images_from_client(C?.resolve())

/obj/effect/fake_attacker/proc/clear_images_from_client(var/client/C)
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_OVERRIDE(TRUE)
	if(!C)
		return
	if(!dir_images.len)
		return
	for(var/img in dir_images)
		C.images -= dir_images[img]

/obj/effect/fake_attacker/proc/qdel_all_images()
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_OVERRIDE(TRUE)
	for(var/img in dir_images)
		qdel_null(dir_images[img])
	dir_images.Cut()



//////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Hallucination attackers with AI behaviors
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
/mob/proc/create_hallucination_attacker(var/turf/T = null,var/mob/living/carbon/human/clone = null, var/forced_type = null)
	SHOULD_NOT_OVERRIDE(TRUE)
	if(!client)
		return null

	if(!clone)
		// Get a randomized clone from the living mob's list, must be standing
		var/list/possible_clones = new/list()
		for(var/mob/living/carbon/human/H in living_mob_list)
			if(H.stat || H.lying)
				continue
			possible_clones += H
		if(!possible_clones.len)
			return null
		clone = pick(possible_clones)
	if(!clone)
		return null

	if(!T)
		// Get the target's turf, then make some random steps to get away from them, respecting walls
		T = get_turf(clone)
		var/turf/CT = T
		for(var/i = 0 to 8)
			var/Cdir = pick(GLOB.cardinal)
			if(prob(30))
				Cdir = clone.dir // Results in hallucinations somewhat being in front of you
			var/turf/NT = get_step(CT,Cdir)
			if(!NT.density)
				CT = NT
		T = CT

	if(!forced_type)
		// Picking from all available options
		var/list/get_types = subtypesof(/obj/effect/fake_attacker/human)
		forced_type = pick(get_types)
	// Finally! After a thousand years I'm finally free to conquer EARTH!
	return new forced_type(T,src,clone)

/obj/effect/fake_attacker/human
	VAR_PROTECTED/datum/weakref/target = null
	var/requires_hallucinating = TRUE // Mob will qdel if the target is not hallucinating if this is true

/obj/effect/fake_attacker/human/Initialize(mapload,var/mob/targeting_mob,var/atom/clone_appearance_from)
	. = ..()
	START_PROCESSING(SSobj, src)
	set_target(targeting_mob)
	create_images_from(clone_appearance_from)
	append_client(targeting_mob.client)
	name = clone_appearance_from.name
	// Usually we want to face our target for maximum spooky effect
	set_dir(get_dir(src,targeting_mob))

/obj/effect/fake_attacker/human/Destroy()
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/effect/fake_attacker/human/process()
	// check if valid
	var/mob/living/M = target?.resolve()
	if(!M)
		qdel(src)
		return null
	if(requires_hallucinating)
		if(!ishuman(M))
			qdel(src)
			return null
		var/mob/living/carbon/human/H = M
		if(!H.hallucination)
			qdel(src)
			return null

	return M

/obj/effect/fake_attacker/human/proc/set_target(var/mob/M)
	target = WEAKREF(M)


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Attacker: Performs hostile shoves and attacks
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
/obj/effect/fake_attacker/human/attacker/process()
	var/mob/living/M = ..()

	if(get_dist(src,M) > 1)
		step_towards(src,M)

	else if(prob(15))
		M << sound(pick('sound/weapons/punch1.ogg','sound/weapons/punch2.ogg','sound/weapons/punch3.ogg','sound/weapons/punch4.ogg'))
		M.show_message(span_bolddanger("\The [src] has punched \the [M]!"), 1)
		M.halloss += 4

	if(prob(15))
		step_away(src,M)


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Fleeing: Runs away when you get close
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
/obj/effect/fake_attacker/human/fleeing
	VAR_PRIVATE/flee = FALSE

/obj/effect/fake_attacker/human/fleeing/process()
	var/mob/living/M = ..()
	set_dir(get_dir(src,M))

	if(get_dist(src,M) < 6 || flee)
		flee = TRUE
		step_away(src,M)

	if(get_dist(src,M) > 10 || get_dist(src,M) < 2 || (flee && prob(10)))
		target = null
		qdel(src)
