#define POINT_TIME (2.5 SECONDS)

/atom/movable/proc/point_at(atom/pointed_atom)
	if(!isturf(loc))
		return

	if (pointed_atom in src)
		create_point_bubble(pointed_atom)
		return

	var/turf/tile = get_turf(pointed_atom)
	if (!tile)
		return

	var/turf/our_tile = get_turf(src)
	var/obj/visual = new /obj/effect/temp_visual/point(our_tile, invisibility)

	animate(visual, pixel_x = (tile.x - our_tile.x) * world.icon_size + pointed_atom.pixel_x, pixel_y = (tile.y - our_tile.y) * world.icon_size + pointed_atom.pixel_y, time = 1.7, easing = EASE_OUT)

/atom/movable/proc/create_point_bubble(atom/pointed_atom)
	var/mutable_appearance/thought_bubble = mutable_appearance(
		'icons/effects/effects.dmi',
		"thought_bubble",
		plane = PLANE_RUNECHAT,
		appearance_flags = KEEP_APART,
	)

	var/mutable_appearance/pointed_atom_appearance = new(pointed_atom.appearance)
	pointed_atom_appearance.blend_mode = BLEND_INSET_OVERLAY
	pointed_atom_appearance.plane = FLOAT_PLANE
	pointed_atom_appearance.layer = FLOAT_LAYER
	pointed_atom_appearance.pixel_x = 0
	pointed_atom_appearance.pixel_y = 0
	thought_bubble.overlays += pointed_atom_appearance

	thought_bubble.pixel_x = 16
	thought_bubble.pixel_y = 32
	thought_bubble.alpha = 200
	thought_bubble.mouse_opacity = MOUSE_OPACITY_TRANSPARENT

	var/mutable_appearance/point_visual = mutable_appearance(
		'icons/mob/screen1.dmi',
		"arrow"
	)

	thought_bubble.overlays += point_visual

	add_overlay(thought_bubble)
	LAZYADD(update_on_z, thought_bubble)
	addtimer(CALLBACK(src, PROC_REF(clear_point_bubble), thought_bubble), POINT_TIME)

/atom/movable/proc/clear_point_bubble(mutable_appearance/thought_bubble)
	LAZYREMOVE(update_on_z, thought_bubble)
	cut_overlay(thought_bubble)

/obj/effect/temp_visual/point
	name = "pointer"
	icon = 'icons/mob/screen1.dmi'
	icon_state = "arrow"
	plane = ABOVE_PLANE
	duration = POINT_TIME

/obj/effect/temp_visual/point/Initialize(mapload, set_invis = 0)
	. = ..()
	var/atom/old_loc = loc
	abstract_move(get_turf(src))
	pixel_x = old_loc.pixel_x
	pixel_y = old_loc.pixel_y
	invisibility = set_invis

#undef POINT_TIME

/mob/verb/pointed(atom/A as mob|obj|turf in view())
	set name = "Point To"
	set category = "Object"

	if(istype(A, /obj/effect/temp_visual/point))
		return FALSE

	DEFAULT_QUEUE_OR_CALL_VERB(VERB_CALLBACK(src, PROC_REF(_pointed), A))

/mob/proc/_pointed(atom/pointing_at)
	if(client && !(pointing_at in view(client.view, src)))
		return FALSE

	point_at(pointing_at)

	SEND_SIGNAL(src, COMSIG_MOB_POINTED, pointing_at)
	face_atom(pointing_at)
	return TRUE
