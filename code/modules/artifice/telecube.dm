/*
 * Home of the telecube.
 */

/datum/category_item/catalogue/anomalous/precursor_a/telecube
	name = "Quantomatically Entangled Digicube"

	desc = "An enigmatic cube that appears superficially similar to a Positronic Cube. \
	However, the similarities hopefully end there, as this device emits no sound during \
	operation or observation. Its alloy composition is unknown, though it is incredibly \
	dense, as it resists any and all forms of radiation.<br>\
	Upon physical contact, however, the device will translocate the offending entity to a \
	matching twin cube, generating no detectable radiation. This process occurs at speeds \
	unmatched even by modern predictions of Bluespace technology, and with no visible power \
	source."

	value = CATALOGUER_REWARD_HARD

// Standard one needs to be smacked onto another one to link together.
/obj/item/telecube
	name = "locus"
	desc = "A strange metallic cube that pulses silently."
	description_info = "Ctrl-Clicking on this object will attempt to activate its unique ability."
	icon = 'icons/obj/props/telecube.dmi'
	icon_state = "cube"
	w_class = ITEMSIZE_SMALL
	origin_tech = list(TECH_MATERIAL = 7, TECH_POWER = 6, TECH_BLUESPACE = 7, TECH_ANOMALY = 2, TECH_PRECURSOR = 2)

	catalogue_data = list(/datum/category_item/catalogue/anomalous/precursor_a/telecube)

	slowdown = 2.5

	throw_range = 2

	var/obj/item/telecube/mate = null

	var/start_paired = FALSE
	var/mirror_colors = FALSE

	var/randomize_colors = FALSE

	var/glow_color = "#FFFFFF"
	var/image/glow = null
	var/image/charge = null

	var/cooldown_time = 30 SECONDS
	var/ready = TRUE

// How far the cube will search for things to teleport. 0 = only contacting objects / mobs.
	var/teleport_range = 0 // For all that is holy, do not change this unless you know what you're doing.

	var/omniteleport = FALSE // Will this teleport anchored things too?

/obj/item/telecube/Initialize()
	. = ..()

	glow = image("[icon_state]-ready")
	glow.appearance_flags = KEEP_APART
	charge = image("[icon_state]-charging")
	charge.appearance_flags = KEEP_APART

	if(teleport_range)
		description_info += "<br>"
		description_info += "Alt-Clicking on this object will utilize its second unique ability."

	if(randomize_colors)
		glow_color = rgb(rand(0, 255),rand(0, 255),rand(0, 255))
		color = rgb(rand(30, 255),rand(30, 255),rand(30, 255))

	if(start_paired)
		mate = new(src.loc)
		if(mirror_colors)
			mate.glow_color = color
			mate.color = glow_color
		else
			mate.glow_color = glow_color
			mate.color = color
		mate.pair_cube(src)

	update_icon()

/obj/item/telecube/update_icon()
	. = ..()

	if(isturf(loc))
		glow.plane = PLANE_LIGHTING_ABOVE
		charge.plane = PLANE_LIGHTING_ABOVE
	else //So it shows up in inventory looking ok
		glow.plane = initial(glow.plane)
		charge.plane = initial(glow.plane)

	if(glow_color != glow.color)
		glow.color = glow_color
		charge.color = glow_color

	if(!ready)
		cut_overlays()
		add_overlay(charge)
	else
		cut_overlays()
		add_overlay(glow)

/obj/item/telecube/Destroy()
	if(mate)
		var/turf/T = get_turf(mate)
		mate.visible_message(span_critical("\The [mate] collapses into itself!"))
		mate.mate = null
		mate = null
		explosion(T,1,3,7)

	return ..()

/obj/item/telecube/equipped()
	. = ..()
	update_icon()

/obj/item/telecube/dropped()
	. = ..()
	update_icon()

/obj/item/telecube/proc/pair_cube(var/obj/item/telecube/M)
	if(mate)
		return 0
	else
		mate = M
		update_icon()
		return 1

/obj/item/telecube/proc/teleport_to_mate(var/atom/movable/A, var/areaporting = FALSE)
	. = FALSE

	if(!istype(A))
		return .

	if(A == src || A == mate)
		A.visible_message(span_alien("\The [A] distorts and fades, before popping back into existence."))
		animate_out(A)
		animate_in(A)
		return .

	var/mob/living/L = src.loc

	if(istype(L))
		L << 'sound/effects/singlebeat.ogg'
		L.drop_from_inventory(src)
		forceMove(get_turf(src))

	if(!ready)
		return .

	if((A.anchored && !omniteleport) || !mate)
		A.visible_message(span_alien("\The [A] distorts for a moment, before reforming in the same position."))
		animate_out(A)
		animate_in(A)
		return .

	var/turf/TLocate = get_turf(mate)

	var/turf/T1 = get_turf(locate(TLocate.x + (A.x - x), TLocate.y + (A.y - y), TLocate.z))

	if(T1)
		A.visible_message(span_alien("\The [A] fades out of existence."))
		animate_out(A)
		A.forceMove(T1)
		animate_in(A)
		. = TRUE
		A.visible_message(span_alien("\The [A] fades into existence."))
	else
		return .

	if(teleport_range && !areaporting)
		for(var/atom/movable/M in orange(teleport_range, A))
			teleport_to_mate(M, TRUE)

/obj/item/telecube/proc/swap_with_mate()
	. = FALSE

	if(!mate || !teleport_range)
		return .

	var/list/objects_near_me = range(teleport_range, get_turf(src))
	var/list/objects_near_mate = range(teleport_range, get_turf(mate))

	for(var/atom/movable/M in objects_near_me)
		teleport_to_mate(M, TRUE)

	for(var/atom/movable/M1 in objects_near_mate)
		mate.teleport_to_mate(M1, TRUE)

	. = TRUE
	return .

/obj/item/telecube/proc/cooldown(var/mate_too = FALSE)
	if(!ready)
		return

	ready = FALSE
	update_icon()
	addtimer(CALLBACK(src, PROC_REF(ready)), cooldown_time)
	if(mate_too && mate)
		mate.cooldown(mate_too = FALSE) //No infinite recursion pls

/obj/item/telecube/proc/ready()
	ready = TRUE
	update_icon()

/obj/item/telecube/proc/animate_out(var/atom/movable/AM)
	//See atom cloak/uncloak animations for comments
	var/atom/movable/target = AM
	var/our_filter_index = target.filters.len+1
	AM.filters += filter(type="blur", size = 0)

	animate(target, alpha = 0, time = 5) //Out
	animate(target.filters[our_filter_index], size = 2, time = 5, flags = ANIMATION_PARALLEL)
	sleep(5)
	target.filters -= filter(type="blur", size = 2)

/obj/item/telecube/proc/animate_in(var/atom/movable/AM)
	//See atom cloak/uncloak animations for comments
	var/atom/movable/target = AM
	var/our_filter_index = target.filters.len+1
	AM.filters += filter(type="blur", size = 2)

	animate(target, alpha = 255, time = 5) //In
	animate(target.filters[our_filter_index], size = 0, time = 5, flags = ANIMATION_PARALLEL)
	sleep(5)
	target.filters -= filter(type="blur", size = 0)

/obj/item/telecube/CtrlClick(mob/user)
	if(Adjacent(user) && teleport_to_mate(user))
		cooldown(mate_too = FALSE)

/obj/item/telecube/AltClick(mob/user)
	if(Adjacent(user) && swap_with_mate())
		cooldown(mate_too = TRUE)

/obj/item/telecube/Bump(var/atom/movable/AM)
	if(teleport_to_mate(AM))
		cooldown(mate_too = FALSE)
	. = ..()

/obj/item/telecube/Bumped(var/atom/movable/M)
	if(teleport_to_mate(M))
		cooldown(mate_too = FALSE)
	. = ..()

// Subtypes

/obj/item/telecube/mated
	start_paired = TRUE

/obj/item/telecube/randomized
	randomize_colors = TRUE

/obj/item/telecube/randomized/mated
	start_paired = TRUE

/obj/item/telecube/precursor
	glow_color = "#FF1D8E"
	color = "#2F1B26"

/obj/item/telecube/precursor/mated
	start_paired = TRUE

/obj/item/telecube/precursor/mated/zone
	teleport_range = 2

/obj/item/telecube/precursor/mated/mirrorcolor
	mirror_colors = TRUE
