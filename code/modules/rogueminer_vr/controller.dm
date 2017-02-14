//////////////////////////////
// Tracks mining zone progress and decay
// Makes mining zones more difficult as you enter new ones
// THIS IS THE FIRST UNIT INITIALIZED THAT STARTS EVERYTHING
//////////////////////////////
var/datum/controller/rogue/rm_controller = new()

/datum/controller/rogue
	var/list/datum/rogue/zonemaster/all_zones = list()

	//So I don't have to do absurd list[list[thing]] over and over.
	var/list/diffstep_nums = list(
		100,
		200,
		300,
		450,
		600,
		800)

	var/list/diffstep_strs = list(
		"Low",
		"Moderate",
		"High",
		"Very High",
		"Extreme",
		"ERROR!!@MEM:CH@05R31GN5")

	//The ever-changing difficulty
	var/difficulty = 100

	//Info about our current step
	var/diffstep = 1

	//The current mining zone that the shuttle goes to and whatnot
	var/datum/rogue/zonemaster/current = null

	// The world.time at which the scanner was last run (for cooldown)
	var/last_scan = 0

	var/debugging = 0

	///// Prefab Asteroids /////
	var/prefabs = list(
		"tier1" = list(/datum/rogue/asteroid/predef/cargo),
		"tier2" = list(/datum/rogue/asteroid/predef/cargo,/datum/rogue/asteroid/predef/cargo/angry),
		"tier3" = list(/datum/rogue/asteroid/predef/cargo/angry,/datum/rogue/asteroid/predef/cargo_large),
		"tier4" = list(/datum/rogue/asteroid/predef/cargo/angry,/datum/rogue/asteroid/predef/cargo_large),
		"tier5" = list(/datum/rogue/asteroid/predef/cargo/angry,/datum/rogue/asteroid/predef/cargo_large),
		"tier6" = list(/datum/rogue/asteroid/predef/cargo/angry,/datum/rogue/asteroid/predef/cargo_large)
	)

	///// Monster Lists /////
	var/mobs = list(
		"tier1" = list(/mob/living/simple_animal/hostile/carp,/mob/living/simple_animal/hostile/goose),
		"tier2" = list(/mob/living/simple_animal/hostile/carp,/mob/living/simple_animal/hostile/goose),
		"tier3" = list(/mob/living/simple_animal/hostile/carp,/mob/living/simple_animal/hostile/goose,/mob/living/simple_animal/hostile/vore/bear),
		"tier4" = list(/mob/living/simple_animal/hostile/carp,/mob/living/simple_animal/hostile/goose,/mob/living/simple_animal/hostile/vore/bear),
		"tier5" = list(/mob/living/simple_animal/hostile/carp,/mob/living/simple_animal/hostile/goose,/mob/living/simple_animal/hostile/vore/bear),
		"tier6" = list(/mob/living/simple_animal/hostile/carp,/mob/living/simple_animal/hostile/goose,/mob/living/simple_animal/hostile/vore/bear)
	)

/datum/controller/rogue/New()
	//How many zones are we working with here
	for(var/area/asteroid/rogue/A in world)
		all_zones += new /datum/rogue/zonemaster(A)
	decay()

/datum/controller/rogue/proc/decay(var/manual = 0)
	adjust_difficulty(RM_DIFF_DECAY_AMT*-1)

	if(!manual) //If it was called manually somehow, then don't start the timer, just decay now.
		spawn(RM_DIFF_DECAY_TIME)
			decay()
	return difficulty

/datum/controller/rogue/proc/dbg(var/message)
	ASSERT(message) //I want a stack trace if there's no message
	if(debugging)
		world << "<span class='warning'>[message]</span>"

/datum/controller/rogue/proc/adjust_difficulty(var/amt)
	ASSERT(amt)

	difficulty = max(difficulty+amt, diffstep_nums[1]) //Can't drop below the lowest level.

	if(difficulty < diffstep_nums[diffstep])
		diffstep--
	else if(difficulty >= diffstep_nums[diffstep+1])
		diffstep++