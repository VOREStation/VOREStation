//////////////////////////////
// The zonemaster object, spawned to track the zone and
// clean/populate the zone with asteroids and loot
//////////////////////////////

/datum/rogue/zonemaster
	//our area
	var/area/asteroid/rogue/myarea

	//world.time
	var/prepared_at = 0
	var/expires_at = 0

	//accepting shuttles
	var/ready = 0

	//completely empty
	var/clean = 1

	//in-use spawns from the area
	var/obj/asteroid_spawner/list/spawns = list()

/datum/rogue/zonemaster/New(var/area/A)
	ASSERT(A)
	myarea = A

///////////////////////////////
///// Utility Procs ///////////
///////////////////////////////

/datum/rogue/zonemaster/proc/is_occupied()
	var/humans = 0
	for(var/mob/living/carbon/human/H in myarea)
		if(H.stat < DEAD) //Bodies don't count, no.
			humans++
	return humans

/datum/rogue/zonemaster/proc/has_shuttle()
	var/shuttles = 0 //Shh.
	for(var/obj/machinery/computer/shuttle_control/C in myarea)
		shuttles ++
	return shuttles

///////////////////////////////
///// Asteroid Generation /////
///////////////////////////////
/datum/rogue/zonemaster/proc/generate_asteroid(var/core_min = 2, var/core_max = 5)
	var/datum/rogue/asteroid/A = new(rand(core_min,core_max))
	rm_controller.dbg("ZM(ga): New asteroid with C:[A.coresize], TW:[A.type_wall].")

	//Add the core to the asteroid's map
	var/start = A.coresize+1
	rm_controller.dbg("ZM(ga): My starting point for the core is [start].")
	for(var/x = 1; x <= A.coresize, x++)
		rm_controller.dbg("ZM(ga): Doing core x[x].")
		for(var/y = 1; y <= A.coresize, y++)
			rm_controller.dbg("ZM(ga): Doing core y[y], about to spot_add [start+x],[start+y], [A.type_wall].")
			A.spot_add(start+x, start+y, A.type_wall)

	//Add the arms to the asteroid's map
	//Bottom arms
	for(var/x = A.coresize+1, x <= A.coresize*2, x++) //Basically for the width of the core, make arms.
		rm_controller.dbg("ZM(ga): Bottom. My starting point for the first arm is x[x].")
		var/curr_arm = rand(0,A.coresize)
		rm_controller.dbg("ZM(ga): Bottom. Going to make an arm of length [curr_arm] for x[x].")
		for(var/y = A.coresize, y > A.coresize-curr_arm, y--) //Start at bottom edge of the core, work down
			A.spot_add(x,y,A.type_wall)

	//Top arms
	for(var/x = A.coresize+1, x <= A.coresize*2, x++) //Basically for the width of the core, make arms.
		rm_controller.dbg("ZM(ga): Top. My starting point for the first arm is x[x].")
		var/curr_arm = rand(0,A.coresize)
		rm_controller.dbg("ZM(ga): Top. Going to make an arm of length [curr_arm] for x[x].")
		for(var/y = (A.coresize*2)+1, y < ((A.coresize*2)+1)+curr_arm, y++) //Start at top edge of the core, work up.
			A.spot_add(x,y,A.type_wall)

	//Right arms
	for(var/y = A.coresize+1, y <= A.coresize*2, y++) //Basically for the height of the core, make arms.
		rm_controller.dbg("ZM(ga): Right. My starting point for the first arm is y[y].")
		var/curr_arm = rand(0,A.coresize)
		rm_controller.dbg("ZM(ga): Right. Going to make an arm of length [curr_arm] for y[y].")
		for(var/x = (A.coresize*2)+1, x <= ((A.coresize*2)+1)+curr_arm, x++) //Start at right edge of core, work right.
			A.spot_add(x,y,A.type_wall)

	//Left arms
	for(var/y = A.coresize+1, y <= A.coresize*2, y++) //Basically for the width of the core, make arms.
		rm_controller.dbg("ZM(ga): Left. My starting point for the first arm is y[y].")
		var/curr_arm = rand(0,A.coresize)
		rm_controller.dbg("ZM(ga): Left. Going to make an arm of length [curr_arm] for y[y].")
		for(var/x = A.coresize, x > A.coresize-curr_arm, x--)
			A.spot_add(x,y,A.type_wall)

	//Diagonals

	rm_controller.dbg("ZM(ga): Asteroid generation done.")
	return A

/datum/rogue/zonemaster/proc/enrich_asteroid(var/list/asteroid)

/datum/rogue/zonemaster/proc/place_asteroid(var/datum/rogue/asteroid/A,var/obj/asteroid_spawner/SP)
	ASSERT(SP && A)

	rm_controller.dbg("ZM(pa): Placing at point [SP.x],[SP.y],[SP.z].")
	SP.myasteroid = A

	//Bottom-left corner of our bounding box
	var/BLx = SP.x - (A.width/2)
	var/BLy = SP.y - (A.width/2)
	rm_controller.dbg("ZM(pa): BLx is [BLx], BLy is [BLy].")

	rm_controller.dbg("ZM(pa): The asteroid has [A.map.len] X-lists.")

	for(var/Ix=1, Ix <= A.map.len, Ix++)
		var/list/curr_x = A.map[Ix]
		rm_controller.dbg("ZM(pa): Now doing X:[Ix] which has [curr_x.len] Y-lists.")

		for(var/Iy=1, Iy <= curr_x.len, Iy++)
			var/list/curr_y = curr_x[Iy]
			rm_controller.dbg("ZM(pa): Now doing Y:[Iy] which has [curr_y.len] items.")

			for(var/T in curr_y)
				rm_controller.dbg("ZM(pa): Doing entry [T] in Y-list [Iy].")
				if(ispath(T,/turf)) //We're spawning a turf
					rm_controller.dbg("ZM(pa): Turf-generate mode.")
					var/turf/P = locate(BLx+Ix,BLy+Iy,SP.z) //Find previous turf
					rm_controller.dbg("ZM(pa): Checking [BLx+Ix],[BLy+Iy],[SP.z] for turf.")
					rm_controller.dbg("ZM(pa): Replacing [P.type] with [T].")
					P.ChangeTurf(T)
					//TODO spawn everything else. XD

///////////////////////////////
///// Zone Population /////////
///////////////////////////////

//Overall 'prepare' proc (marks as ready)
/datum/rogue/zonemaster/proc/prepare_zone(var/delay = 0)
	clean = 0

	//TODO take difficulty into account
	rm_controller.dbg("ZM(p): Randomizing spawns.")
	randomize_spawns()
	rm_controller.dbg("ZM(p): [spawns.len] picked.")
	for(var/obj/asteroid_spawner/SP in spawns)
		rm_controller.dbg("ZM(p): Spawning at [SP.x],[SP.y],[SP.z].")
		var/datum/rogue/asteroid/A = generate_asteroid()
		rm_controller.dbg("ZM(p): Placing asteroid.")
		place_asteroid(A,SP)

	rm_controller.dbg("ZM(p): Zone generation done.")
	ready = 1

//Randomize the landmarks that are enabled
/datum/rogue/zonemaster/proc/randomize_spawns(var/chance = 50)
	rm_controller.dbg("ZM(rs): Previously [spawns.len] spawns.")
	spawns.Cut()
	rm_controller.dbg("ZM(rs): Now [spawns.len] spawns.")
	for(var/obj/asteroid_spawner/SP in myarea.asteroid_spawns)
		if(prob(chance))
			spawns += SP
	rm_controller.dbg("ZM(rs): Picked [spawns.len] new spawns with [chance]% chance.")

//Call asteroid generation and place over and over proc

///////////////////////////////
///// Zone Cleaning ///////////
///////////////////////////////

//Overall 'destroy' proc (marks as unready)
//Lazy mostly-destroy proc aimed at landmarks
//Faster destroy-everything-else proc

///////////////////////////////
///// Mysterious Mystery //////
///////////////////////////////

//Generate an "interesting" asteroid instead of a normal one
//Throw a meteor at a player in the zone