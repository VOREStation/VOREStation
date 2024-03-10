#define VERM_MICE 0
#define VERM_LIZARDS 1

/datum/event/infestation
	announceWhen = 10
	endWhen = 11
	var/locstring
	var/vermin
	var/vermstring
	var/list/spawned_vermin = list()
	var/spawn_types
	var/num_groups
	var/prep_size_min
	var/prep_size_max
	var/vermin_cap = 40
	var/list/spawn_locations = list()

/datum/event/infestation/start()
	vermin = rand(0,1)
	switch(vermin)
		if(VERM_MICE)
			spawn_types = /mob/living/simple_mob/animal/passive/mouse/gray
			prep_size_min = 1
			prep_size_max = 4
			vermstring = "mice"
		if(VERM_LIZARDS)
			spawn_types = /mob/living/simple_mob/animal/passive/lizard
			prep_size_min = 1
			prep_size_max = 3
			vermstring = "lizards"
	// Check if any landmarks exist!
	for(var/obj/effect/landmark/C in landmarks_list)
		if(C.name == "verminstart")
			spawn_locations.Add(C.loc)


/datum/event/infestation/tick()
	if(activeFor % 5 != 0)
		return // Only process every 10 seconds.
	if(count_spawned_vermin() < vermin_cap)
		spawn_vermin(rand(4,10), prep_size_min, prep_size_max)

/datum/event/infestation/proc/spawn_vermin(var/num_groups, var/group_size_min, var/group_size_max)
	if(spawn_locations.len) // Okay we've got landmarks, lets use those!
		shuffle_inplace(spawn_locations)
		num_groups = min(num_groups, spawn_locations.len)
		for (var/i = 1, i <= num_groups, i++)
			var/group_size = rand(group_size_min, group_size_max)
			for (var/j = 0, j < group_size, j++)
				spawn_one_vermin(spawn_locations[i])
		return

// Spawn a single vermin at given location.
/datum/event/infestation/proc/spawn_one_vermin(var/loc)
	var/mob/living/simple_mob/animal/M = new spawn_types(loc)
	RegisterSignal(M, COMSIG_OBSERVER_DESTROYED, PROC_REF(on_vermin_destruction))
	spawned_vermin.Add(M)
	return M

// Counts living vermin spawned by this event.
/datum/event/infestation/proc/count_spawned_vermin()
	. = 0
	for(var/mob/living/simple_mob/animal/M as anything in spawned_vermin)
		if(!QDELETED(M) && M.stat != DEAD)
			. += 1

// If vermin is kill, remove it from the list.
/datum/event/infestation/proc/on_vermin_destruction(var/mob/M)
	spawned_vermin -= M
	UnregisterSignal(M, COMSIG_OBSERVER_DESTROYED)



/datum/event/infestation/announce()
	command_announcement.Announce("Bioscans indicate that [vermstring] have been breeding all over the facility. Clear them out, before this starts to affect productivity.", "Vermin infestation")

#undef VERM_MICE
#undef VERM_LIZARDS
