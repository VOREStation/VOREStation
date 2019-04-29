/datum/map_template/underdark
	name = "Underdark Content"
	desc = "For seeding submaps in Underdark"
	allow_duplicates = TRUE

/datum/map_template/underdark/normal_mob
	name = "Underdark Normal Mob Spawn"
	mappath = 'normal_mob.dmm'
	cost = 5

/datum/map_template/underdark/hard_mob
	name = "Underdark Hard Mob Spawn"
	mappath = 'hard_mob.dmm'
	cost = 15

/datum/map_template/underdark/underhall
	name = "Underdark Golden Hall"
	mappath = 'goldhall.dmm'
	cost = 15
	allow_duplicates = FALSE

/*
/datum/map_template/underdark/boss_mob
	name = "Underdark Boss Mob Spawn"
	mappath = 'boss_mob.dmm'
	cost = 60
	allow_duplicates = FALSE

/datum/map_template/underdark/whatever_treasure
	name = "Some Kinda Treasure" //A name, only visible to admins
	mappath = 'hard_mob.dmm' //The .dmm file for this template (in this folder)
	cost = 10 //How 'valuable' this template is
*/