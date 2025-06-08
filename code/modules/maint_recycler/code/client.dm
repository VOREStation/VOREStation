/datum/preference/numeric/recycler_points
	savefile_key = "RECYCLER_POINTS"
	minimum = -999 //if you get here you deserve it.
	maximum = 999
	savefile_identifier = PREFERENCE_PLAYER
	can_randomize =  FALSE
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED

/datum/preference/numeric/recycler_points/create_default_value()
	return 50 //a treat
