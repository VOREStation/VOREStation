//Minimum limit is 18
/datum/category_item/player_setup_item/get_min_age()
	var/min_age = 18
	var/datum/species/S = GLOB.all_species[pref.species ? pref.species : "Human"]
	if(!is_FBP() && S.min_age > 18)
		min_age = S.min_age
	return min_age
