//Sol

/datum/locations/sol
	name = "Sol"
	desc = "The home system of humanity."

/datum/locations/sol/New(var/creator)
	contents.Add(
		new /datum/locations/mercury(src),
		new /datum/locations/venus(src),
		new /datum/locations/earth(src),
		new /datum/locations/mars(src),
		new /datum/locations/jupiter(src),
		new /datum/locations/saturn(src),
		new /datum/locations/uranus(src),
		new /datum/locations/neptune(src)
		)
	..(creator)

/datum/locations/mercury
	name = "Mercury"

/datum/locations/venus
	name = "Venus"

/datum/locations/earth
	name = "Earth"

/datum/locations/mars
	name = "Mars"

/datum/locations/jupiter
	name = "Jupiter"

/datum/locations/saturn
	name = "Saturn"

/datum/locations/uranus
	name = "Uranus"

/datum/locations/neptune
	name = "Neptune"