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
	var/armsize 	= 3		//(max)Length of the 'arms' on the sides
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
	var/list/map = list()

//Builds an empty map
/datum/rogue/asteroid/New(var/core, var/arm, var/tw, var/tu)
	if(core)
		coresize = core
	if(arm)
		armsize = arm
	if(tw)
		type_wall = tw
	if(tu)
		type_under = tu

	width = coresize+(armsize*2)

	world << "calling xy_lists with [width]"
	xy_lists(width)


//Adds something to a spot in the asteroid map
/datum/rogue/asteroid/proc/spot_add(var/x,var/y,var/thing)
	if(!x || !y || !thing)
		return

	var/list/work = map[x][y]
	work += thing

//Removes something from a spot in the asteroid map
/datum/rogue/asteroid/proc/spot_remove(var/x,var/y,var/thing)
	if(!x || !y || !thing)
		return

	var/list/work = map[x][y]
	work -= thing

//Just removes everything from a spot in the asteroid map
/datum/rogue/asteroid/proc/spot_clear(var/x,var/y)
	if(!x || !y)
		return

	var/list/work = map[x][y]
	work.Cut()

//Given a size it will create the lists if they don't already exist
/datum/rogue/asteroid/proc/xy_lists(var/gridsize)
	map = list()

	world << "Now in xy_lists"
	for(var/Ix=0, Ix < gridsize, Ix++)
		world << "Making new 'x' list for x=[Ix]"
		var/list/curr_x = list()
		for(var/Iy=0, Iy < gridsize, Iy++)
			world << "Making new 'y' list for y=[Iy]"
			var/list/curr_y = list()
			curr_x[++curr_x.len] = curr_y
			world << "Inserted new 'y', x=[Ix] list now [curr_x.len] long"
		map[++map.len] = curr_x
		world << "Inserted new 'x', map now [map.len] long"

	return map
