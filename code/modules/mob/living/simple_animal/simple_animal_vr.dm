/mob/living/simple_animal
	// List of targets excluded (for now) from being eaten by this mob.
	var/list/prey_exclusions = list()
	var/icon_rest

/mob/living/simple_animal/cat
	isPredator = 1

/mob/living/simple_animal/fluffy/lay_down() // Turns sprite into sleeping and back upon using "Rest".
	..()
	icon_state = resting ? "fluffy_sleep" : "fluffy"
