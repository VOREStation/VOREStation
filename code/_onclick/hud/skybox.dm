// Skybox screen object.
/obj/skybox
	name = "skybox"
	mouse_opacity = 0
	anchored = TRUE
	simulated = FALSE
	screen_loc = "CENTER:-352,CENTER:-352" // (736/2 - 32/2)
	plane = SKYBOX_PLANE
	blend_mode = BLEND_MULTIPLY // You actually need to do it this way or you see it in occlusion.

/client
	var/obj/skybox/skybox

/client/proc/update_skybox(rebuild)
	if(!skybox)
		skybox = new()
		screen += skybox
		rebuild = 1

	var/turf/T = get_turf(eye)
	if(T)
		if(rebuild)
			skybox.overlays.Cut()
			skybox.overlays += SSskybox.get_skybox(T.z)
			screen |= skybox
		skybox.screen_loc = "CENTER:[-352 + (world.maxx>>1) - T.x],CENTER:[-352 + (world.maxy>>1) - T.y]"

/mob/Login()
	. = ..()
	client.update_skybox(TRUE)

/mob/Move()
	var/old_z = get_z(src)
	. = ..()
	if(. && client)
		client.update_skybox(old_z != get_z(src))

/mob/forceMove()
	var/old_z = get_z(src)
	. = ..()
	if(. && client)
		client.update_skybox(old_z != get_z(src))
