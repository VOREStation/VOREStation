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
/datum/rogue/zonemaster/proc/generate_asteroid(var/core_min = 2, var/core_max = 5, var/arm_min = 1, var/arm_max = 3)
	var/datum/rogue/asteroid/A = new(rand(core_min,core_max),rand(arm_min,arm_max))

	//Find the bounding box, basically
	A.width = A.coresize+(A.armsize*2)

	//Add the core to the asteroid's map
	var/start = round((A.width-A.coresize)/2)
	for(var/x = 1; x <= A.coresize, x++)
		for(var/y = 1; y <= A.coresize, y++)
			A.spot_add(start+x, start+y, A.type_wall)

	//Add the arms to the asteroid's map
	//TODO

	return A

/datum/rogue/zonemaster/proc/enrich_asteroid(var/list/asteroid)

/datum/rogue/zonemaster/proc/place_asteroid(var/datum/rogue/asteroid/A,var/obj/asteroid_spawner/SP)
	SP.myasteroid = A

	//Top-left corner of our bounding box
	var/TLx = SP.x - (A.width/2)
	var/TLy = SP.y - (A.width/2)

	for(var/x in A.map)
		for(var/y in A.map[x])
			for(var/turf/T in A.map[x][y])
				var/turf/P = locate(TLx+x,TLy+y,SP.z) //Find previous turf
				P.ChangeTurf(T)
            //TODO spawn everything that's not a turf

///////////////////////////////
///// Zone Population /////////
///////////////////////////////

//Overall 'prepare' proc (marks as ready)
/datum/rogue/zonemaster/proc/prepare_zone()
	clean = 0

	//TODO take difficulty into account
	randomize_spawns()
	for(var/obj/asteroid_spawner/SP in spawns)
		var/datum/rogue/asteroid/A = generate_asteroid()
		place_asteroid(A,SP)

	ready = 1

//Randomize the landmarks that are enabled
/datum/rogue/zonemaster/proc/randomize_spawns(var/chance = 50)
	spawns.Cut()
	for(var/obj/asteroid_spawner/SP in myarea.asteroid_spawns)
		if(prob(chance))
			spawns += SP

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