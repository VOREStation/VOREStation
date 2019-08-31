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
/obj/item/weapon/telecube
	name = "locus"
	desc = "A strange metallic cube that pulses silently."
	description_info = "Ctrl-Clicking on this object will attempt to activate its unique ability."
	icon = 'icons/obj/props/telecube.dmi'
	icon_state = "cube"
	w_class = ITEMSIZE_SMALL
	origin_tech = list(TECH_MATERIAL = 7, TECH_POWER = 6, TECH_BLUESPACE = 7, TECH_ANOMALY = 2, TECH_PRECURSOR = 2)

	catalogue_data = list(/datum/category_item/catalogue/anomalous/precursor_a/telecube)

	slowdown = 5

	throw_range = 2

	var/obj/item/weapon/telecube/mate = null

	var/start_paired = FALSE
	var/mirror_colors = FALSE

	var/randomize_colors = FALSE

	var/glow_color = "#FFFFFF"
	var/image/glow = null
	var/image/charge = null

	var/shell_color = "#FFFFFF"
	var/image/shell = null

	var/cooldown_time = 30 SECONDS
	var/last_teleport = 0

// How far the cube will search for things to teleport. 0 = only contacting objects / mobs.
	var/teleport_range = 0 // For all that is holy, do not change this unless you know what you're doing.

	var/omniteleport = FALSE // Will this teleport anchored things too?

/obj/item/weapon/telecube/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)
	last_teleport = world.time

	glow = image(icon = icon, icon_state = "[icon_state]-ready")
	glow.plane = PLANE_LIGHTING_ABOVE
	charge = image(icon = icon, icon_state = "[icon_state]-charging")
	charge.plane = PLANE_LIGHTING_ABOVE
	shell = image(icon = icon, icon_state = "[icon_state]")

	if(teleport_range)
		description_info += "<br>"
		description_info += "Alt-Clicking on this object will utilize its second unique ability."

	if(randomize_colors)
		glow_color = rgb(rand(0, 255),rand(0, 255),rand(0, 255))
		shell_color = rgb(rand(0, 255),rand(0, 255),rand(0, 255))

	if(start_paired)
		mate = new(src.loc)
		if(mirror_colors)
			mate.glow_color = shell_color
			mate.shell_color = glow_color
		else
			mate.glow_color = glow_color
			mate.shell_color = shell_color
		mate.pair_cube(src)

	glow.color = glow_color
	charge.color = glow_color
	shell.color = shell_color

	return

/obj/item/weapon/telecube/process()
	..()
	update_icon()

/obj/item/weapon/telecube/update_icon()
	. = ..()
	glow.color = glow_color
	charge.color = glow_color
	shell.color = shell_color

	if(shell.color != initial(shell.color))
		cut_overlay(shell)
		add_overlay(shell)

	if(world.time < (last_teleport + cooldown_time))
		cut_overlay(charge)
		cut_overlay(glow)
		add_overlay(charge)
	else
		cut_overlay(glow)
		cut_overlay(charge)
		add_overlay(glow)

/obj/item/weapon/telecube/Destroy()
	STOP_PROCESSING(SSobj, src)
	if(mate)
		var/turf/T = get_turf(mate)
		mate.visible_message("<span class='critical'>\The [mate] collapses into itself!</span>")
		mate.mate = null
		mate = null
		explosion(T,1,3,7)

	..()

/obj/item/weapon/telecube/proc/pair_cube(var/obj/item/weapon/telecube/M)
	if(mate)
		return 0
	else
		mate = M
		update_icon()
		return 1

/obj/item/weapon/telecube/proc/teleport_to_mate(var/atom/movable/A, var/areaporting = FALSE)
	. = FALSE

	if(!A)
		return .

	if(A == src || A == mate)
		A.visible_message("<span class='alien'>\The [A] distorts and fades, before popping back into existence.</span>")
		return .

	var/mob/living/L = src.loc

	if(istype(L))
		L.drop_from_inventory(src)
		forceMove(get_turf(src))

	if(world.time < (last_teleport + cooldown_time))
		return .

	if((A.anchored && !omniteleport) || !mate)
		A.visible_message("<span class='alien'>\The [A] distorts for a moment, before reforming in the same position.</span>")
		return .

	var/turf/TLocate = get_turf(mate)

	var/turf/T1 = get_turf(locate(TLocate.x + (A.x - x), TLocate.y + (A.y - y), TLocate.z))

	if(T1)
		A.visible_message("<span class='alien'>\The [A] fades out of existence.</span>")
		A.forceMove(T1)
		. = TRUE
		A.visible_message("<span class='alien'>\The [A] fades into existence.</span>")
	else
		return .

	if(teleport_range && !areaporting)
		for(var/atom/movable/M in orange(teleport_range, A))
			teleport_to_mate(M, TRUE)

/obj/item/weapon/telecube/proc/swap_with_mate()
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

/obj/item/weapon/telecube/CtrlClick(mob/user)
	if(Adjacent(user))
		if(teleport_to_mate(user))
			last_teleport = world.time
	return

/obj/item/weapon/telecube/AltClick(mob/user)
	if(Adjacent(user))
		if(swap_with_mate())
			last_teleport = world.time
			mate.last_teleport = world.time
	return

/obj/item/weapon/telecube/Bump(atom/movable/AM)
	if(teleport_to_mate(AM))
		last_teleport = world.time
	. = ..()

/obj/item/weapon/telecube/Bumped(atom/movable/M as mob|obj)
	if(teleport_to_mate(M))
		last_teleport = world.time
	. = ..()

// Subtypes

/obj/item/weapon/telecube/mated
	start_paired = TRUE

/obj/item/weapon/telecube/randomized
	randomize_colors = TRUE

/obj/item/weapon/telecube/randomized/mated
	start_paired = TRUE

/obj/item/weapon/telecube/precursor
	glow_color = "#FF1D8E"
	shell_color = "#2F1B26"

/obj/item/weapon/telecube/precursor/mated
	start_paired = TRUE

/obj/item/weapon/telecube/precursor/mated/zone
	teleport_range = 2

/obj/item/weapon/telecube/precursor/mated/mirrorcolor
	mirror_colors = TRUE
