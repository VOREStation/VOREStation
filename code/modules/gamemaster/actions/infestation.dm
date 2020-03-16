#define LOC_KITCHEN 0
#define LOC_ATMOS 1
#define LOC_CHAPEL 2
#define LOC_LIBRARY 3
#define LOC_HYDRO 4
#define LOC_VAULT 5
#define LOC_CONSTR 6
#define LOC_TECH 7
#define LOC_GARDEN 8

#define VERM_MICE 0
#define VERM_LIZARDS 1
#define VERM_SPIDERS 2

/datum/gm_action/infestation
	name = "animal infestation"
	departments = list(DEPARTMENT_EVERYONE)
	var/location
	var/locstring
	var/vermin
	var/vermstring

	var/list/turf/simulated/floor/turfs = list()

	var/spawn_types
	var/max_number

/datum/gm_action/infestation/set_up()
	location = rand(0,8)
	turfs.Cut()
	var/spawn_area_type
	switch(location)
		if(LOC_KITCHEN)
			spawn_area_type = /area/crew_quarters/kitchen
			locstring = "the kitchen"
		if(LOC_ATMOS)
			spawn_area_type = /area/engineering/atmos
			locstring = "atmospherics"
		if(LOC_CHAPEL)
			spawn_area_type = /area/chapel/main
			locstring = "the chapel"
		if(LOC_LIBRARY)
			spawn_area_type = /area/library
			locstring = "the library"
		if(LOC_HYDRO)
			spawn_area_type = /area/hydroponics
			locstring = "hydroponics"
		if(LOC_VAULT)
			spawn_area_type = /area/security/nuke_storage
			locstring = "the vault"
		if(LOC_CONSTR)
			spawn_area_type = /area/construction
			locstring = "the construction area"
		if(LOC_TECH)
			spawn_area_type = /area/storage/tech
			locstring = "technical storage"
		if(LOC_GARDEN)
			spawn_area_type = /area/hydroponics/garden
			locstring = "the public garden"

	for(var/areapath in typesof(spawn_area_type))
		var/area/A = locate(areapath)
		for(var/turf/simulated/floor/F in A.contents)
			if(turf_clear(F))
				turfs += F

	spawn_types = list()
	max_number = 0
	vermin = rand(0,2)
	switch(vermin)
		if(VERM_MICE)
			spawn_types = list(/mob/living/simple_mob/animal/passive/mouse/gray, /mob/living/simple_mob/animal/passive/mouse/brown, /mob/living/simple_mob/animal/passive/mouse/white, /mob/living/simple_mob/animal/passive/mouse/rat)
			max_number = 12
			vermstring = "mice"
		if(VERM_LIZARDS)
			spawn_types = list(/mob/living/simple_mob/animal/passive/lizard, /mob/living/simple_mob/animal/passive/lizard, /mob/living/simple_mob/animal/passive/lizard/large, /mob/living/simple_mob/animal/passive/lizard/large/defensive)
			max_number = 6
			vermstring = "lizards"
		if(VERM_SPIDERS)
			spawn_types = list(/obj/effect/spider/spiderling)
			max_number = 3
			vermstring = "spiders"

/datum/gm_action/infestation/start()
	spawn()
		var/num = rand(2,max_number)
		while(turfs.len > 0 && num > 0)
			var/turf/simulated/floor/T = pick(turfs)
			turfs.Remove(T)
			num--

			if(vermin == VERM_SPIDERS)
				var/obj/effect/spider/spiderling/S = new(T)
				S.amount_grown = -1
			else
				var/spawn_type = pick(spawn_types)
				new spawn_type(T)

/datum/gm_action/infestation/announce()
	command_announcement.Announce("Bioscans indicate that [vermstring] have been breeding in [locstring]. Clear them out, before this starts to affect productivity.", "Vermin infestation")

/datum/gm_action/infestation/get_weight()
	return 5 + (metric.count_people_in_department(DEPARTMENT_EVERYONE) * 20)

#undef LOC_KITCHEN
#undef LOC_ATMOS
#undef LOC_CHAPEL
#undef LOC_LIBRARY
#undef LOC_HYDRO
#undef LOC_VAULT
#undef LOC_TECH
#undef LOC_GARDEN

#undef VERM_MICE
#undef VERM_LIZARDS
#undef VERM_SPIDERS