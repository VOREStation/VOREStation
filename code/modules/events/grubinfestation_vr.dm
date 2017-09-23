/datum/event/grub_infestation
	announceWhen = 10
	endWhen = 11
	var/location
	var/locstring

/datum/event/grub_infestation/start()

	location = rand(0,8)
	var/list/turf/simulated/floor/turfs = list()
	var/spawn_area_type
	spawn_area_type = /area/gateway/prep_room
	locstring = "the solar farm"

	for(var/areapath in typesof(spawn_area_type))
		var/area/A = locate(areapath)
		for(var/turf/simulated/floor/F in A.contents)
			if(turf_clear(F))
				turfs += F

	var/list/spawn_types = list()
	spawn_types = list(/mob/living/simple_animal/retaliate/solargrub)
	var/max_number = 8

	spawn(0)
		var/num = rand(2,max_number)
		while(turfs.len > 0 && num > 0)
			var/turf/simulated/floor/T = pick(turfs)
			turfs.Remove(T)
			num--
			var/spawn_type = pick(spawn_types)
			new spawn_type(T)

/datum/event/grub_infestation/announce()
	command_announcement.Announce("Bioscans indicate that solar grubs have somehow entered through the gateway. Clear them out, before this starts to affect the powergrid.", "Vermin infestation")
