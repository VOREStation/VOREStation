#define SKYBOX_PADDING	4	// How much larger we want the skybox image to be than client's screen (in turfs)
#define SKYBOX_PIXELS	736	// Size of skybox image in pixels
#define SKYBOX_TURFS	(SKYBOX_PIXELS/WORLD_ICON_SIZE)

// Skybox screen object.
/obj/screen/skybox
	name = "skybox"
	icon = null
	vis_flags = NONE
	appearance_flags = TILE_BOUND|PIXEL_SCALE
	mouse_opacity = 0
	anchored = TRUE
	simulated = FALSE
	screen_loc = "CENTER,CENTER"
	layer = BACKGROUND_LAYER
	plane = SKYBOX_PLANE
	blend_mode = BLEND_MULTIPLY // You actually need to do it this way or you see it in occlusion.

// Adjust transform property to scale for client's view var. We assume the skybox is 736x736 px
/obj/screen/skybox/proc/scale_to_view(var/view)
	var/matrix/M = matrix()
	// Translate to center the icon over us!
	M.Translate(-(SKYBOX_PIXELS - WORLD_ICON_SIZE) / 2)
	// Scale appropriately based on view size.  (7 results in scale of 1)
	view = text2num(view) || 7 // Sanitize
	M.Scale(((min(MAX_CLIENT_VIEW, view) + SKYBOX_PADDING) * 2 + 1) / SKYBOX_TURFS)
	src.transform = M

/client
	var/obj/screen/skybox/skybox

/client/proc/update_skybox(rebuild)
	if(!skybox)
		skybox = new()
		skybox.scale_to_view(src.view)
		screen += skybox
		rebuild = 1

	var/turf/T = get_turf(eye)
	if(T)
		if(rebuild)
			skybox.cut_overlays()
			skybox.add_overlay(SSskybox.get_skybox(T.z))
			screen |= skybox
		skybox.screen_loc = "CENTER:[(world.maxx>>1) - T.x],CENTER:[(world.maxy>>1) - T.y]"

/mob/Login()
	. = ..()
	client.update_skybox(TRUE)

/mob/onTransitZ(old_z, new_z)
	..()
	if(old_z != new_z)
		client?.update_skybox(TRUE)

/mob/Moved()
	. = ..()
	client?.update_skybox()

/mob/set_viewsize()
	. = ..()
	if (. && client)
		client.update_skybox()
		client.skybox?.scale_to_view(client.view)

#undef SKYBOX_PADDING
#undef SKYBOX_PIXELS
#undef SKYBOX_TURFS
