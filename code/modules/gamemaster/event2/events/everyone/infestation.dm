/datum/event2/meta/infestation
	event_class = "infestation"
	departments = list(DEPARTMENT_EVERYONE)

/datum/event2/meta/infestation/get_weight()
	return metric.count_people_in_department(DEPARTMENT_EVERYONE) * 10

/datum/event2/meta/infestation/rodents
	name = "infestation - rodents"
	event_type = /datum/event2/event/infestation/rodents

/datum/event2/meta/infestation/lizards
	name = "infestation - lizards"
	event_type = /datum/event2/event/infestation/lizards

/datum/event2/meta/infestation/spiderlings
	name = "infestation - spiders"
	event_type = /datum/event2/event/infestation/spiderlings


/datum/event2/event/infestation
	var/vermin_string = null
	var/max_vermin = 0
	var/list/things_to_spawn = list()

	var/list/turfs = list()

/datum/event2/event/infestation/rodents
	vermin_string = "rodents"
	max_vermin = 12
	things_to_spawn = list(
		/mob/living/simple_mob/animal/passive/mouse/gray,
		/mob/living/simple_mob/animal/passive/mouse/brown,
		/mob/living/simple_mob/animal/passive/mouse/black,
		/mob/living/simple_mob/animal/passive/mouse/white,
		/mob/living/simple_mob/animal/passive/mouse/rat
	)

/datum/event2/event/infestation/lizards
	vermin_string = "lizards"
	max_vermin = 6
	things_to_spawn = list(
		/mob/living/simple_mob/animal/passive/lizard,
		/mob/living/simple_mob/animal/passive/lizard/large,
		/mob/living/simple_mob/animal/passive/lizard/large/defensive
	)

/datum/event2/event/infestation/spiderlings
	vermin_string = "spiders"
	max_vermin = 3
	things_to_spawn = list(/obj/effect/spider/spiderling/non_growing)

/datum/event2/event/infestation/cockroaches
	vermin_string = "cockroaches"
	max_vermin = 6
	things_to_spawn = list(/mob/living/simple_mob/animal/passive/cockroach)

/datum/event2/event/infestation/set_up()
	turfs = find_random_turfs(max_vermin)
	if(!turfs.len)
		log_debug("Infestation event failed to find any valid turfs. Aborting.")
		abort()
		return

/datum/event2/event/infestation/announce()
	var/turf/T = turfs[1]
	command_announcement.Announce("Bioscans indicate that [vermin_string] have been breeding \
	in \the [T.loc]. Clear them out, before this starts to affect productivity.", "Vermin infestation")


/datum/event2/event/infestation/start()
	var/vermin_to_spawn = rand(2, max_vermin)
	for(var/i = 1 to vermin_to_spawn)
		var/turf/T = pick(turfs)
		turfs -= T
		var/spawn_type = pick(things_to_spawn)
		new spawn_type(T)
