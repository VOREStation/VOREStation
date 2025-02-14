//Acts like the map edge, can use this to divide up zlevels into 'fake' multiz areas.
//Keep in mind that the entire zlevel 'moves' when the ship does, so don't try to make DIFFERENT ships share a zlevel.
/turf/space/internal_edge
	icon_state = "arrow"
	opacity = 1
	density = 1
	blocks_air = TRUE

/turf/space/internal_edge/Initialize()
	. = ..()
	opacity = 1 // This will get reset due to using appearances that are precreated in SSskybox, and apps have opacity = 0
	density = 1

/turf/space/internal_edge/top
	dir = NORTH
	forced_dirs = NORTH
/turf/space/internal_edge/bottom
	dir = SOUTH
	forced_dirs = SOUTH
/turf/space/internal_edge/left
	dir = WEST
	forced_dirs = WEST
/turf/space/internal_edge/right
	dir = EAST
	forced_dirs = EAST
/turf/space/internal_edge/topleft
	dir = NORTHWEST
	forced_dirs = NORTHWEST
/turf/space/internal_edge/topright
	dir = NORTHEAST
	forced_dirs = NORTHEAST
/turf/space/internal_edge/bottomleft
	dir = SOUTHWEST
	forced_dirs = SOUTHWEST
/turf/space/internal_edge/bottomright
	dir = SOUTHEAST
	forced_dirs = SOUTHEAST

//These are fake stairs, that when you try to go up them, they shove you to
//  their 'connected' friend! Try to use the appropriate top/bottom ones for good looks.
/obj/structure/fake_stairs
	name = "use a subtype! - stairs"
	icon = 'icons/obj/structures/multiz.dmi'
	icon_state = "stair"
	density = 1
	opacity = 0
	anchored = 1
	plane = TURF_PLANE
	layer = ABOVE_TURF_LAYER
	appearance_flags = PIXEL_SCALE|KEEP_TOGETHER

	var/_stair_tag //Make this match another one and they'll connect!

	var/obj/structure/fake_stairs/target //Don't set this manually, let it do it!
	var/stepoff_dir

/obj/structure/fake_stairs/Initialize(mapload)
	. = ..()

	for(var/obj/structure/fake_stairs/FS in world)
		if(FS == src)
			continue //hi
		if(FS._stair_tag == _stair_tag)
			target = FS
	if(!target && mapload)
		to_world(span_danger("Fake stairs at [x],[y],[z] couldn't get a target!"))

/obj/structure/fake_stairs/Destroy()
	if(target)
		target.target = null
	target = null
	return ..()

/obj/structure/fake_stairs/Bumped(var/atom/movable/AM)
	if(!target)
		return
	target.take(AM)

/obj/structure/fake_stairs/proc/take(var/atom/movable/AM)
	var/dir_to_use = stepoff_dir ? stepoff_dir : dir
	var/turf/T = get_step(src, dir_to_use)
	if(!T)
		log_debug("Fake stairs at [x],[y],[z] couldn't move someone to their destination.")
		return
	AM.forceMove(T)
	spawn AM.set_dir(dir_to_use)
	if(isliving(AM))
		var/mob/living/L = AM
		if(L.pulling)
			L.pulling.forceMove(T)
			spawn L.pulling.set_dir(dir_to_use)

/obj/structure/fake_stairs/north/top
	name = "stairs"
	dir = NORTH
	color = "#B0B0B0"
	pixel_y = -32

/obj/structure/fake_stairs/north/bottom
	name = "stairs"
	dir = NORTH
	stepoff_dir = SOUTH
	pixel_y = -32

/obj/structure/fake_stairs/south/top
	name = "stairs"
	dir = SOUTH
	color = "#B0B0B0"

/obj/structure/fake_stairs/south/bottom
	name = "stairs"
	dir = SOUTH
	stepoff_dir = NORTH

/obj/structure/fake_stairs/east/top
	name = "stairs"
	dir = EAST
	color = "#B0B0B0"
	pixel_x = -32

/obj/structure/fake_stairs/east/bottom
	name = "stairs"
	dir = EAST
	stepoff_dir = WEST
	pixel_x = -32

/obj/structure/fake_stairs/west/top
	name = "stairs"
	dir = WEST
	color = "#B0B0B0"

/obj/structure/fake_stairs/west/bottom
	name = "stairs"
	dir = WEST
	stepoff_dir = EAST

//Inactive stairs are completely cosmetic versions of fake_stairs
/obj/structure/inactive_stairs
	name = "use a subtype! - stairs"
	icon = 'icons/obj/structures/multiz.dmi'
	icon_state = "stair"
	density = 0
	opacity = 0
	anchored = 1
	plane = TURF_PLANE
	layer = ABOVE_TURF_LAYER
	appearance_flags = PIXEL_SCALE|KEEP_TOGETHER

/obj/structure/inactive_stairs/north/top
	name = "stairs"
	dir = NORTH
	color = "#B0B0B0"
	pixel_y = -32

/obj/structure/inactive_stairs/north/bottom
	name = "stairs"
	dir = NORTH
	pixel_y = -32

/obj/structure/inactive_stairs/south/top
	name = "stairs"
	dir = SOUTH
	color = "#B0B0B0"

/obj/structure/inactive_stairs/south/bottom
	name = "stairs"
	dir = SOUTH

/obj/structure/inactive_stairs/east/top
	name = "stairs"
	dir = EAST
	color = "#B0B0B0"
	pixel_x = -32

/obj/structure/inactive_stairs/east/bottom
	name = "stairs"
	dir = EAST
	pixel_x = -32

/obj/structure/inactive_stairs/west/top
	name = "stairs"
	dir = WEST
	color = "#B0B0B0"

/obj/structure/inactive_stairs/west/bottom
	name = "stairs"
	dir = WEST
