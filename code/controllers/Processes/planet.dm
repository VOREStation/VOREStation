/datum/controller/process/planet
	var/list/planets = list()

/datum/controller/process/planet/setup()
	name = "planet"
	schedule_interval = 600 // every minute
	planet_sif = new()
	planets.Add(planet_sif)

/datum/controller/process/planet/doWork()
	for(var/datum/planet/P in planets)
		P.process(schedule_interval / 10)