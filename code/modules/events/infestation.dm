#define LOC_KITCHEN 0
#define LOC_ATMOS 1
#define LOC_CHAPEL 2
#define LOC_LIBRARY 3
#define LOC_HYDRO 4
#define LOC_CONSTR 5
#define LOC_TECH 6
#define LOC_GARDEN 7
#define LOC_STEMNGR 8
#define LOC_RESEARCH 9

#define VERM_MICE 0
#define VERM_LIZARDS 1
#define VERM_SPIDERS 2

/datum/event/infestation
	announceWhen = 10
	endWhen = 11
	var/location
	var/locstring
	var/vermin
	var/vermstring

/datum/event/infestation/start()

	location = rand(0,9)
	var/list/turf/simulated/floor/turfs = list()
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
		if(LOC_CONSTR)
			spawn_area_type = /area/construction
			locstring = "the construction area"
		if(LOC_TECH)
			spawn_area_type = /area/storage/tech
			locstring = "technical storage"
		if(LOC_GARDEN)
			spawn_area_type = /area/hydroponics/garden
			locstring = "the public garden"
		if(LOC_STEMNGR)
			spawn_area_type = /area/crew_quarters/captain
			locstring = "the site manager's office"
		if(LOC_RESEARCH)
			spawn_area_type = /area/rnd/research
			locstring = "the research division"

	for(var/areapath in typesof(spawn_area_type))
		var/area/A = locate(areapath)
		for(var/turf/simulated/floor/F in A.contents)
			//VOREStation Edit - Fixes event
			var/blocked = FALSE
			for(var/atom/movable/AM in F)
				if(AM.density)
					blocked = TRUE
			if(!blocked)
				turfs += F
			//VOREStation Edit - Fixes event

	var/list/spawn_types = list()
	var/max_number
	vermin = rand(0,2)
	switch(vermin)
		if(VERM_MICE)
			spawn_types = list(/mob/living/simple_mob/animal/passive/mouse/gray, /mob/living/simple_mob/animal/passive/mouse/brown, /mob/living/simple_mob/animal/passive/mouse/white)
			max_number = 12
			vermstring = "mice"
		if(VERM_LIZARDS)
			spawn_types = list(/mob/living/simple_mob/animal/passive/lizard)
			max_number = 6
			vermstring = "lizards"
		if(VERM_SPIDERS)
			spawn_types = list(/obj/effect/spider/spiderling)
			max_number = 3
			vermstring = "spiders"

	spawn(0)
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


/datum/event/infestation/announce()
	command_announcement.Announce("Bioscans indicate that [vermstring] have been breeding in [locstring]. Clear them out, before this starts to affect productivity.", "Vermin infestation")

#undef LOC_KITCHEN
#undef LOC_ATMOS
#undef LOC_CHAPEL
#undef LOC_LIBRARY
#undef LOC_HYDRO
#undef LOC_TECH
#undef LOC_GARDEN
#undef LOC_STEMNGR
#undef LOC_RESEARCH

#undef VERM_MICE
#undef VERM_LIZARDS
#undef VERM_SPIDERS
