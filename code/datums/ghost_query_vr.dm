/*
/datum/ghost_query/morph
	role_name = "Morph"
	be_special_flag = BE_MORPH
	question = "A weird morphic creature has appeared in maintenance. Do you want to play as it? ((You get to play as a weird shapeshifting \'morph\' that can mimic objects and people.))"
	cutoff_number = 1

/datum/ghost_query/maints_pred
	role_name = "Maintenance Critter"
	be_special_flag = BE_MAINTPRED
	question = "It appears a critter of some kind, possibly predatory, is lurking in maintenance. Do you want to play as it? ((You get to choose from a wide range of critters.))"
	cutoff_number = 1

/datum/ghost_query/maints_lurker
	role_name = "Maintenance Lurker"
	be_special_flag = BE_MAINTLURKER
	question = "It appears a strange individual is lurking in maintenance. Do you want to play as them? ((You can spawn as your currently loaded character slot, but your arrival will not be announced and you will not appear on the manifest.))"
	cutoff_number = 1
*/

/datum/ghost_query/maints_spawner
	role_name = "Maintenance Spawner"
	be_special_flag = BE_MAINTCRITTER
	question = "An opportunity to spawn as a Maintenance Critter has appeared. You can spawn as your choice of a mob (from a fairly large list), a morph (a shapeshifting creature capable of mimicking objects or other creatures), or your currently loaded character slot in a special \'lurker\' role."
	cutoff_number = 1
