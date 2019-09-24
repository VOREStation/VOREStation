/datum/map_template/asteroid_belt
	name = "Belt Miner Content"
	desc = "For seeding submaps in the Asteroid Belt"
	allow_duplicates = TRUE

/datum/map_template/asteroid_belt/normal_mob
	name = "Belt Normal Mob Spawn"
	mappath = 'normal_mob.dmm'
	cost = 5

/datum/map_template/asteroid_belt/hard_mob
	name = "Belt Hard Mob Spawn"
	mappath = 'hard_mob.dmm'
	cost = 15

/*
/datum/map_template/asteroid_belt/whatever_treasure
	name = "Some Kinda Treasure" //A name, only visible to admins
	mappath = 'hard_mob.dmm' //The .dmm file for this template (in this folder)
	cost = 10 //How 'valuable' this template is
*/
