//////////////////////////////
// An asteroid object, could be spawned in, or not
// May or may not include phat lewt
//////////////////////////////

/datum/rogue/asteroid
	//Composition
	var/type_wall	= /turf/simulated/mineral		//Type of turf used to generate the asteroid
	var/type_under	= /turf/simulated/mineral/floor	//Type of turf that's under the normal one

	//Dimensions
	var/coresize 	= 3		//The size of the center square
	var/width		= 9

	//Other Attribs
	var/hollow 		= 0		//Might be hollow for loot injection purposes
	var/spawned 	= 0		//Is this asteroid in-play right now
	var/difficulty	= 0		//Difficulty this asteroid was created at

	//Locational stats
	var/obj/effect/landmark/asteroid_spawn/mylandmark	//The landmark I'm spawned at, if any.

	//Asteroid map
	//The map struct is:
	// map list()
	//  0 = list()
	//  1 = list() //These are x coordinates
	//  2 = list()
	//    ^0 = list()
	//     1 = list() //These are y coordinates at x2
	//     2 = list()
	//       ^type1
	//        type2 //These are items/objects at the coordinate
	//        type3 //This would be object 3 at x2,y2
	var/list/map

//Builds an empty map
/datum/rogue/asteroid/New(var/core, var/tw, var/tu)
	rm_controller.dbg("A(n): New asteroid, with: C:[core], TW:[tw], TU:[tu].")

	if(core)
		coresize = core
	if(tw)
		type_wall = tw
	if(tu)
		type_under = tu

	width = coresize*3
	rm_controller.dbg("A(n): My width is [width].")

	map = new/list(width,width,0)
	rm_controller.dbg("A(n): Created empty map lists. Map now has [map.len] X-lists.")

//Adds something to a spot in the asteroid map
/datum/rogue/asteroid/proc/spot_add(var/x,var/y,var/thing)
	if(!x || !y || !thing)
		return

	rm_controller.dbg("A(sa): Adding [thing] at [x],[y] in the map.")
	var/list/work = map[x][y]
	work.Add(thing)
	rm_controller.dbg("A(n): [x],[y] now contains [work.len] items.")

//Removes something from a spot in the asteroid map
/datum/rogue/asteroid/proc/spot_remove(var/x,var/y,var/thing)
	if(!x || !y || !thing)
		return

	var/list/work = map[x][y]
	work.Add(thing)

//Just removes everything from a spot in the asteroid map
/datum/rogue/asteroid/proc/spot_clear(var/x,var/y)
	if(!x || !y)
		return

	var/list/work = map[x][y]
	work.Cut()
