/area/submap/spa
	name = "\improper Space Spa"
	requires_power = 0
	dynamic_lighting = 0




// NEVER EVER use these on an actual included map.
// These are for admins to use when they make quick maps and upload the .dmm files for loading
// during a round. They're just generic areas so they can use them and have them exist without
// using real map areas.
/area/submap/admin_upload
	name = "\improper Unknown Area AU" //Nobody will know what this means if they see it, anyway.
	requires_power = 1
	dynamic_lighting = 1
	power_equip = FALSE
	power_environ = FALSE
	power_light = FALSE
	base_turf = /turf/simulated/mineral/floor/cave

/area/submap/admin_upload/pow
	name = "\improper Unknown Area AU+P"
	requires_power = 0
/area/submap/admin_upload/lit
	name = "\improper Unknown Area AU+L"
	requires_power = 1
	dynamic_lighting = 0
	power_equip = FALSE
	power_environ = FALSE
	power_light = FALSE
/area/submap/admin_upload/powlit
	name = "\improper Unknown Area AU+PL"
	requires_power = 0
	dynamic_lighting = 0

/area/submap/admin_upload/AU2
	name = "\improper Unknown Area A"
	requires_power = 1
	dynamic_lighting = 1
	power_equip = FALSE
	power_environ = FALSE
	power_light = FALSE

/area/submap/admin_upload/AU3
	name = "\improper Unknown Area B"
	requires_power = 1
	dynamic_lighting = 1
	power_equip = FALSE
	power_environ = FALSE
	power_light = FALSE

/area/submap/admin_upload/AU4
	name = "\improper Unknown Area C"
	requires_power = 1
	dynamic_lighting = 1
	power_equip = FALSE
	power_environ = FALSE
	power_light = FALSE

/area/submap/admin_upload/AU5
	name = "\improper Unknown Area D"
	requires_power = 1
	dynamic_lighting = 1
	power_equip = FALSE
	power_environ = FALSE
	power_light = FALSE

/area/submap/admin_upload/AU6
	name = "\improper Unknown Area E"
	requires_power = 1
	dynamic_lighting = 1
	power_equip = FALSE
	power_environ = FALSE
	power_light = FALSE

/area/submap/admin_upload/AU7
	name = "\improper Unknown Area F"
	requires_power = 1
	dynamic_lighting = 1
	power_equip = FALSE
	power_environ = FALSE
	power_light = FALSE

/area/submap/admin_upload/AU8
	name = "\improper Unknown Area G"
	requires_power = 1
	dynamic_lighting = 1
	power_equip = FALSE
	power_environ = FALSE
	power_light = FALSE

/area/submap/admin_upload/AU9
	name = "\improper Unknown Area H"
	requires_power = 1
	dynamic_lighting = 1
	power_equip = FALSE
	power_environ = FALSE
	power_light = FALSE

/area/submap/admin_upload/AU10
	name = "\improper Unknown Area I"
	requires_power = 1
	dynamic_lighting = 1
	power_equip = FALSE
	power_environ = FALSE
	power_light = FALSE

/area/submap/admin_upload/AU11
	name = "\improper Unknown Area J"
	requires_power = 1
	dynamic_lighting = 1
	power_equip = FALSE
	power_environ = FALSE
	power_light = FALSE

/area/submap/admin_upload/AU12
	name = "\improper Unknown Area K"
	requires_power = 1
	dynamic_lighting = 1
	power_equip = FALSE
	power_environ = FALSE
	power_light = FALSE

/area/submap/admin_upload/AU13
	name = "\improper Unknown Area L"
	requires_power = 1
	dynamic_lighting = 1
	power_equip = FALSE
	power_environ = FALSE
	power_light = FALSE

/area/submap/admin_upload/AU14
	name = "\improper Unknown Area M"
	requires_power = 1
	dynamic_lighting = 1
	power_equip = FALSE
	power_environ = FALSE
	power_light = FALSE

/area/submap/admin_upload/AU15
	name = "\improper Unknown Area N"
	requires_power = 1
	dynamic_lighting = 1
	power_equip = FALSE
	power_environ = FALSE
	power_light = FALSE

/area/submap/admin_upload/AU16
	name = "\improper Unknown Area O"
	requires_power = 1
	dynamic_lighting = 1
	power_equip = FALSE
	power_environ = FALSE
	power_light = FALSE

/area/submap/admin_upload/lo
	name = "\improper Unknown Area AA"
	requires_power = 1
	dynamic_lighting = 1
	lightswitch = 0
	power_equip = FALSE
	power_environ = FALSE
	power_light = FALSE

/area/submap/admin_upload/lo/one
	name = "\improper Unknown Area AB"

/area/submap/admin_upload/lo/two
	name = "\improper Unknown Area AC"


/area/submap/admin_upload/lo/three
	name = "\improper Unknown Area AD"

/area/submap/admin_upload/lo/four
	name = "\improper Unknown Area AE"

/area/submap/admin_upload/lo/pow
	name = "\improper Unknown Area AF"
	requires_power = 0

/area/submap/admin_upload/lo/pow/one
	name = "\improper Unknown Area AG"

/area/submap/admin_upload/lo/pow/two
	name = "\improper Unknown Area AH"

/area/submap/admin_upload/lo/pow/three
	name = "\improper Unknown Area AI"

/area/submap/admin_upload/lo/pow/four
	name = "\improper Unknown Area AJ"


// Adminbuse things for overmap sectors

// This is a stationary overmap sector, you can spawn it in any zlevel and it will pop onto the overmap to represent those zlevels. It always moves to 2,2 on the overmap and you can move it elsewhere.
/obj/effect/overmap/visitable/admin_use
	name = "REPLACE ME"
	desc = "Some space destination!"
	scanner_desc = @{"[i]Registration[/i]: REPLACE ME
[i]Class[/i]: REPLACE ME
[i]Transponder[/i]: REPLACE ME
[b]Notice[/b]: REPLACE ME"} //Uses the paper/book syntax
	start_x = 2
	start_y = 2
	known = FALSE

// It notifies admins when you spawn it and gives you a 'JMP' and 'VV' link in the message so you can find it easily.
/obj/effect/overmap/visitable/admin_use/Initialize()
	. = ..()
	message_admins("An uploaded sector [ADMIN_JMP(src)][ADMIN_VV(src)] has been placed on the overmap. Don't forget to rename and set cool scanner info on it!")

/obj/effect/overmap/visitable/admin_use/dark

	skybox_icon = 'icons/skybox/anomaly.dmi'
	skybox_icon_state = "dark"
	skybox_pixel_x = 0
	skybox_pixel_y = 0

/obj/effect/overmap/visitable/admin_use/dark_star

	skybox_icon = 'icons/skybox/anomaly.dmi'
	skybox_icon_state = "dark_star"
	skybox_pixel_x = 0
	skybox_pixel_y = 0

/obj/effect/overmap/visitable/admin_use/seven

	skybox_icon = 'icons/skybox/anomaly.dmi'
	skybox_icon_state = "seven"
	skybox_pixel_x = 0
	skybox_pixel_y = 0


/obj/effect/overmap/visitable/admin_use/bluespace_shimmer

	name = "Bluespace Shimmer"
	skybox_icon = 'icons/skybox/anomaly.dmi'
	skybox_icon_state = "shimmer_b"
	skybox_pixel_x = 0
	skybox_pixel_y = 0

/obj/effect/overmap/visitable/admin_use/redspace_shimmer

	name = "Redspace Shimmer"
	skybox_icon = 'icons/skybox/anomaly.dmi'
	skybox_icon_state = "shimmer_r"
	skybox_pixel_x = 0
	skybox_pixel_y = 0


// This is the same, but makes a whole spaceship!
/obj/effect/overmap/visitable/ship/admin_use
	name = "REPLACE ME"
	desc = "Spacefaring vessel."
	scanner_desc = @{"[i]Registration[/i]: REPLACE ME
[i]Class[/i]: REPLACE ME
[i]Transponder[/i]: REPLACE ME
[b]Notice[/b]: REPLACE ME"}
	vessel_mass = 8000
	vessel_size = SHIP_SIZE_LARGE //Mostly so it's obviously visible on the map.
	fore_dir = NORTH //You may need to edit this ingame if you want your ship to fly correctly!
	start_x = 2
	start_y = 2
	known = FALSE

// Similarly notifies you
/obj/effect/overmap/visitable/ship/admin_use/Initialize()
	. = ..()
	message_admins("An uploaded ship [ADMIN_JMP(src)][ADMIN_VV(src)] has been placed on the overmap. Don't forget to rename and set cool scanner info on it!")

/obj/effect/overmap/visitable/ship/admin_use/space_dog
	skybox_icon = 'icons/skybox/anomaly.dmi'
	skybox_icon_state = "space_dog"
	skybox_pixel_x = 0
	skybox_pixel_y = 0

/obj/effect/overmap/visitable/ship/admin_use/space_dog/Crossed(var/obj/effect/overmap/visitable/ship/enterer)
	. = ..()
	if(istype(enterer))
		for(var/mob/potential_mob as anything in player_list)
			if(potential_mob.z in enterer.map_z)
				SEND_SOUND(potential_mob, 'sound/ambience/boy.ogg')

/obj/effect/overmap/visitable/ship/admin_use/space_whale
	skybox_icon = 'icons/skybox/anomaly.dmi'
	skybox_icon_state = "space_whale"
	skybox_pixel_x = 0
	skybox_pixel_y = 0

// These landmarks, placed in any map that is being represented by an overmap sector, will add themselves to landable destinations in that map!
// Note the names, pick whichever makes the most sense for your map. No need to use them in any particular order or use any/all of them.
/obj/effect/shuttle_landmark/automatic/admin_use1
	name = "Landing Zone"
	landmark_tag = "adminuse_lz_alpha"

/obj/effect/shuttle_landmark/automatic/admin_use2
	name = "Parking Area"
	landmark_tag = "adminuse_lz_beta"

/obj/effect/shuttle_landmark/automatic/admin_use3
	name = "Docking Node"
	landmark_tag = "adminuse_lz_gamma"
