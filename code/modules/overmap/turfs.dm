//Dimension of overmap (squares 4 lyfe)
var/global/list/map_sectors = list()

/area/overmap/
	name = "System Map"
	icon_state = "start"
	requires_power = 0
	base_turf = /turf/unsimulated/map

/turf/unsimulated/map
	icon = 'icons/turf/space.dmi'
	icon_state = "map"
	initialized = FALSE // TODO - Fix unsimulated turf initialization so this override is not necessary!

/turf/unsimulated/map/edge
	opacity = 1
	density = 1

/turf/unsimulated/map/Initialize()
	. = ..()
	name = "[x]-[y]"
	var/list/numbers = list()

	if(x == 1 || x == global.using_map.overmap_size)
		numbers += list("[round(y/10)]","[round(y%10)]")
		if(y == 1 || y == global.using_map.overmap_size)
			numbers += "-"
	if(y == 1 || y == global.using_map.overmap_size)
		numbers += list("[round(x/10)]","[round(x%10)]")

	for(var/i = 1 to numbers.len)
		var/image/I = image('icons/effects/numbers.dmi',numbers[i])
		I.pixel_x = 5*i - 2
		I.pixel_y = world.icon_size/2 - 3
		if(y == 1)
			I.pixel_y = 3
			I.pixel_x = 5*i + 4
		if(y == global.using_map.overmap_size)
			I.pixel_y = world.icon_size - 9
			I.pixel_x = 5*i + 4
		if(x == 1)
			I.pixel_x = 5*i - 2
		if(x == global.using_map.overmap_size)
			I.pixel_x = 5*i + 2
		add_overlay(I)

/turf/unsimulated/map/Entered(var/atom/movable/O, var/atom/oldloc)
	..()
	if(istype(O, /obj/effect/overmap/visitable/ship))
		GLOB.overmap_event_handler.on_turf_entered(src, O, oldloc)

/turf/unsimulated/map/Exited(var/atom/movable/O, var/atom/newloc)
	..()
	if(istype(O, /obj/effect/overmap/visitable/ship))
		GLOB.overmap_event_handler.on_turf_exited(src, O, newloc)

//list used to track which zlevels are being 'moved' by the proc below
var/list/moving_levels = list()
//Proc to 'move' stars in spess
//yes it looks ugly, but it should only fire when state actually change.
//null direction stops movement
proc/toggle_move_stars(zlevel, direction)
	if(!zlevel)
		return

	if (moving_levels["[zlevel]"] != direction)
		moving_levels["[zlevel]"] = direction

		var/list/spaceturfs = block(locate(1, 1, zlevel), locate(world.maxx, world.maxy, zlevel))
		for(var/turf/space/T in spaceturfs)
			T.toggle_transit(direction)
			CHECK_TICK
