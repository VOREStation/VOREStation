//Picture in picture

/obj/screen/movable/pic_in_pic/ai
	var/mob/living/silicon/ai/ai
	var/list/highlighted_mas = list()
	var/highlighted = FALSE
	var/mob/observer/eye/aiEye/pic_in_pic/aiEye

/obj/screen/movable/pic_in_pic/ai/Initialize()
	. = ..()
	aiEye = new /mob/observer/eye/aiEye/pic_in_pic()
	aiEye.screen = src

/obj/screen/movable/pic_in_pic/ai/Destroy()
	. = ..()
	if(!QDELETED(aiEye))
		QDEL_NULL(aiEye)
	else
		aiEye = null
	set_ai(null)

/obj/screen/movable/pic_in_pic/ai/Click()
	..()
	if(ai)
		ai.select_main_multicam_window(src)

/obj/screen/movable/pic_in_pic/ai/make_backgrounds()
	..()
	var/mutable_appearance/base = new /mutable_appearance()
	base.icon = 'icons/misc/pic_in_pic.dmi'
	base.layer = DISPOSAL_LAYER
	base.plane = PLATING_PLANE
	base.appearance_flags = PIXEL_SCALE

	for(var/direction in cardinal)
		var/mutable_appearance/dir = new /mutable_appearance(base)
		dir.dir = direction
		dir.icon_state = "background_highlight_[direction]"
		highlighted_mas += dir

/obj/screen/movable/pic_in_pic/ai/add_background()
	if((width > 0) && (height > 0))
		if(!highlighted)
			return ..()

		for(var/mutable_appearance/dir in highlighted_mas)
			var/matrix/M = matrix()
			var/x_scale = 1
			var/y_scale = 1

			var/x_off = 0
			var/y_off = 0

			if(dir.dir & (NORTH|SOUTH))
				x_scale = width
				x_off = (width-1)/2 * world.icon_size
				if(dir.dir & NORTH)
					y_off = ((height-1) * world.icon_size) + 3
				else
					y_off = -3

			if(dir.dir & (EAST|WEST))
				y_scale = height
				y_off = (height-1)/2 * world.icon_size
				if(dir.dir & EAST)
					x_off = ((width-1) * world.icon_size) + 3
				else
					x_off = -3

			M.Scale(x_scale, y_scale)
			M.Translate(x_off, y_off)
			dir.transform = M
			add_overlay(dir)

/obj/screen/movable/pic_in_pic/ai/set_view_size(width, height, do_refresh = TRUE)
	if(!aiEye) // Exploit fix
		qdel(src)
		return
	aiEye.static_visibility_range =	(round(max(width, height) / 2) + 1)
	if(ai)
		ai.camera_visibility(aiEye)
	..()

/obj/screen/movable/pic_in_pic/ai/set_view_center(atom/target, do_refresh = TRUE)
	..()
	if(!aiEye) // Exploit Fix
		qdel(src)
		return
	aiEye.setLoc(get_turf(target))

/obj/screen/movable/pic_in_pic/ai/refresh_view()
	..()
	if(!aiEye) // Exploit Fix
		qdel(src)
		return
	aiEye.setLoc(get_turf(center))

/obj/screen/movable/pic_in_pic/ai/proc/highlight()
	if(highlighted)
		return
	if(!aiEye)
		qdel(src)
		return
	highlighted = TRUE
	cut_overlays()
	add_background()
	add_buttons()

/obj/screen/movable/pic_in_pic/ai/proc/unhighlight()
	if(!highlighted)
		return
	if(!aiEye)
		qdel(src)
		return
	highlighted = FALSE
	cut_overlays()
	add_background()
	add_buttons()

/obj/screen/movable/pic_in_pic/ai/proc/set_ai(mob/living/silicon/ai/new_ai)
	if(!aiEye && !QDELETED(src))
		if(new_ai)
			to_chat(new_ai, "<span class='danger'><h2>You've run into a unfixable bug with AI eye code. \
In order to create a new multicam, you will have to select a different camera first before trying to add one, or ask an admin to fix you. \
Whatever you did that made the last camera window disappear-- don't do that again.</h2></span>")
		qdel(src)
		return
	if(ai)
		ai.multicam_screens -= src
		ai.all_eyes -= aiEye
		if(ai.master_multicam == src)
			ai.master_multicam = null
		if(ai.multicam_on)
			unshow_to(ai.client)
	ai = new_ai
	if(new_ai)
		new_ai.multicam_screens += src
		ai.all_eyes += aiEye
		if(new_ai.multicam_on)
			show_to(new_ai.client)

//Turf, area, and landmark for the viewing room

/turf/unsimulated/ai_visible
	name = ""
	icon = 'icons/misc/pic_in_pic.dmi'
	icon_state = "room_background"
	flags = NOJAUNT
	plane = SPACE_PLANE
	layer = AREA_LAYER + 0.1

/turf/unsimulated/ai_visible/Initialize()
	. = ..()

/area/ai_multicam_room
	name = "AI Multicam Room"
	icon_state = "ai_camera_room"
	dynamic_lighting = FALSE
	ambience = list()

GLOBAL_DATUM(ai_camera_room_landmark, /obj/effect/landmark/ai_multicam_room)

/obj/effect/landmark/ai_multicam_room
	name = "ai camera room"
	icon_state = "x"

/obj/effect/landmark/ai_multicam_room/Initialize()
	. = ..()
	qdel(GLOB.ai_camera_room_landmark)
	GLOB.ai_camera_room_landmark = src

/obj/effect/landmark/ai_multicam_room/Destroy()
	if(GLOB.ai_camera_room_landmark == src)
		GLOB.ai_camera_room_landmark = null
	return ..()

//Dummy camera eyes

/mob/observer/eye/aiEye/pic_in_pic
	name = "Secondary AI Eye"
	var/obj/screen/movable/pic_in_pic/ai/screen
	var/list/cameras_telegraphed = list()
	var/telegraph_cameras = TRUE
	var/telegraph_range = 7

/mob/observer/eye/aiEye/pic_in_pic/GetViewerClient()
	if(screen && screen.ai)
		return screen.ai.client

/mob/observer/eye/aiEye/pic_in_pic/setLoc(turf/T)
	T = get_turf(T)
	forceMove(T)
	if(screen && screen.ai)
		screen.ai.camera_visibility(src)
	else
		cameranet.visibility(src)
	update_camera_telegraphing()

/mob/observer/eye/aiEye/pic_in_pic/proc/update_camera_telegraphing()
	if(!telegraph_cameras)
		return
	var/list/obj/machinery/camera/add = list()
	var/list/obj/machinery/camera/remove = list()
	var/list/obj/machinery/camera/visible = list()
	for(var/datum/chunk/camera/CC as anything in visibleChunks)
		for(var/obj/machinery/camera/C as anything in CC.cameras)
			if (!C.can_use() || (get_dist(C, src) > telegraph_range))
				continue
			visible |= C

	add = visible - cameras_telegraphed
	remove = cameras_telegraphed - visible

	for(var/obj/machinery/camera/C as anything in remove)
		if(QDELETED(C))
			continue
		cameras_telegraphed -= C
		C.in_use_lights--
		C.update_icon()
	for(var/obj/machinery/camera/C as anything in add)
		if(QDELETED(C))
			continue
		cameras_telegraphed |= C
		C.in_use_lights++
		C.update_icon()

/mob/observer/eye/aiEye/pic_in_pic/proc/disable_camera_telegraphing()
	telegraph_cameras = FALSE
	for(var/obj/machinery/camera/C as anything in cameras_telegraphed)
		if(QDELETED(C))
			continue
		C.in_use_lights--
		C.update_icon()
	cameras_telegraphed.Cut()

/mob/observer/eye/aiEye/pic_in_pic/Destroy()
	disable_camera_telegraphing()
	if(screen && screen.ai)
		screen.ai.all_eyes -= src
	if(!QDELETED(screen))
		QDEL_NULL(screen)
	else
		screen = null
	return ..()

//AI procs

/mob/living/silicon/ai/proc/drop_new_multicam(silent = FALSE)
	if(!multicam_allowed)
		if(!silent)
			to_chat(src, "<span class='warning'>This action is currently disabled. Contact an administrator to enable this feature.</span>")
		return
	if(!eyeobj)
		return
	if(multicam_screens.len >= max_multicams)
		if(!silent)
			to_chat(src, "<span class='warning'>Cannot place more than [max_multicams] multicamera windows.</span>")
		return
	var/obj/screen/movable/pic_in_pic/ai/C = new /obj/screen/movable/pic_in_pic/ai()
	C.set_view_size(3, 3, FALSE)
	C.set_view_center(get_turf(eyeobj))
	C.set_ai(src)
	if(!silent)
		to_chat(src, "<span class='notice'>Added new multicamera window.</span>")
	return C

/mob/living/silicon/ai/proc/toggle_multicam()
	if(!multicam_allowed)
		to_chat(src, "<span class='warning'>This action is currently disabled. Contact an administrator to enable this feature.</span>")
		return
	if(multicam_on)
		end_multicam()
	else
		start_multicam()

/mob/living/silicon/ai/proc/start_multicam()
	if(multicam_on || aiRestorePowerRoutine || !isturf(loc))
		return
	if(!GLOB.ai_camera_room_landmark)
		to_chat(src, "<span class='warning'>This function is not available at this time.</span>")
		return
	multicam_on = TRUE
	refresh_multicam()
	to_chat(src, "<span class='notice'>Multiple-camera viewing mode activated.</span>")

/mob/living/silicon/ai/proc/refresh_multicam()
	reset_view(GLOB.ai_camera_room_landmark)
	if(client)
		for(var/obj/screen/movable/pic_in_pic/P as anything in multicam_screens)
			P.show_to(client)

/mob/living/silicon/ai/proc/end_multicam()
	if(!multicam_on)
		return
	multicam_on = FALSE
	select_main_multicam_window(null)
	if(client)
		for(var/obj/screen/movable/pic_in_pic/P as anything in multicam_screens)
			P.unshow_to(client)
	reset_view()
	to_chat(src, "<span class='notice'>Multiple-camera viewing mode deactivated.</span>")


/mob/living/silicon/ai/proc/select_main_multicam_window(obj/screen/movable/pic_in_pic/ai/P)
	if(master_multicam == P)
		return

	if(master_multicam)
		master_multicam.set_view_center(get_turf(eyeobj), FALSE)
		master_multicam.unhighlight()
		master_multicam = null

	if(P)
		P.highlight()
		eyeobj.setLoc(get_turf(P.center))
		P.set_view_center(eyeobj)
		master_multicam = P
