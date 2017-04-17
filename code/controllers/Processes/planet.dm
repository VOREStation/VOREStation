var/datum/controller/process/planet/planet_controller = null

/datum/controller/process/planet
	var/list/planets = list()

/datum/controller/process/planet/setup()
	name = "planet"
	planet_controller = src
	schedule_interval = 600 // every minute
	var/list/planet_datums = typesof(/datum/planet) - /datum/planet
	for(var/P in planet_datums)
		var/datum/planet/NP = new P()
		planets.Add(NP)

/datum/controller/process/planet/doWork()
	for(var/datum/planet/P in planets)
		P.process(schedule_interval / 10)