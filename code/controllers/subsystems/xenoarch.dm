#define XENOARCH_SPAWN_CHANCE 0.5
#define DIGSITESIZE_LOWER 4
#define DIGSITESIZE_UPPER 12
#define ARTIFACTSPAWNNUM_LOWER 18 	//This used to be 6-12 when xenoarch was performed on mostly a single Z level: The mining asteroid.
#define ARTIFACTSPAWNNUM_UPPER 36 	//Due to the increasing complexity of the game, that number resulted in current-day xenaorcheologists possibly being able to find one or maybe two artifacts a Z level.
									//This meant that xenoarch, an already tedious job, would be made even slower and more tedious and find very few large artifacts, which is the 'bulk' of their job. This should help alleviate that.
									//Ideally, this should be replaced with Z level specific (i.e. spawn 3-6 artifacts per Z level) spawns, but that is for the future.
									//For now, this is functional.
#define PROCEDURAL_LOWER 5			//These are high as the generation of them can could be laggy if spammed. This ONLY happens if the entire Z level has been depleted of large artifacts.
#define PROCEDURAL_UPPER 10			//It's easier to just go 'Here's more artifacts to dig up' and give xenoarch more to do.

//
// Xenoarch subsystem handles initialization of Xenoarcheaology artifacts and digsites.
//
SUBSYSTEM_DEF(xenoarch)
	name = "Xenoarch"
	init_order = INIT_ORDER_XENOARCH
	flags = SS_NO_FIRE
	var/list/artifact_spawning_turfs = list()
	var/list/digsite_spawning_turfs = list()

/datum/controller/subsystem/xenoarch/Initialize()
	SetupXenoarch()
	return SS_INIT_SUCCESS

/datum/controller/subsystem/xenoarch/Recover()
	if (istype(SSxenoarch.artifact_spawning_turfs))
		artifact_spawning_turfs = SSxenoarch.artifact_spawning_turfs
	if (istype(SSxenoarch.digsite_spawning_turfs))
		digsite_spawning_turfs = SSxenoarch.digsite_spawning_turfs

/datum/controller/subsystem/xenoarch/stat_entry(msg)
	if (!GLOB.Debug2)
		return // Only show up in stat panel if debugging is enabled.
	return ..()

/datum/controller/subsystem/xenoarch/proc/SetupXenoarch()
	for(var/turf/simulated/mineral/M in world) //This selects every mineral turf in the world
		if(!M.density) //Checks to see if it's a mineral wall
			continue

		if((M.z in using_map.xenoarch_exempt_levels) || !prob(XENOARCH_SPAWN_CHANCE)) //Now we roll the dice. Base chance is 1/200 for a mineral turf to spawn a digsite. If it doesn't roll that chance, we skip this rock.
			continue

		var/farEnough = 1
		for(var/turf/T as anything in digsite_spawning_turfs) //Did any other digsites within 5 tiles roll lucky on their chance?
			if(T in range(5, M))
				farEnough = 0
				break
		if(!farEnough) //If they did, let's not crowd the area with digsites. Skip this rock, even if it rolled well.
			continue

		digsite_spawning_turfs.Add(M) //This rock was lucky enough to be selected and not near any other sites!

		var/digsite = get_random_digsite_type() //What type of artifact site is this? Dictates what items will spawn.
		var/target_digsite_size = rand(DIGSITESIZE_LOWER, DIGSITESIZE_UPPER) //What the minimum size our digsite will be.

		var/list/processed_turfs = list()
		var/list/turfs_to_process = list(M)

		var/list/viable_adjacent_turfs = list()
		if(target_digsite_size > 1)
			for(var/turf/simulated/mineral/T in orange(2, M)) //With the rock being the center, check every rock around us within 2 tiles in each direction. So 5x5 square with our rock as the center.
				if(!T.density) //Is it an actual mineral wall?
					continue
				if(T.finds) //If the rock being checked has an artifact in it already, skip it.
					continue
				if(T in processed_turfs) //The rock has already been processed...This shouldn't happen since farEnough above ensures digsites can't be next to each other. Presumably, this is a failsafe.
					continue
				viable_adjacent_turfs.Add(T) //Add to the list of rocks we can select for this site.

			//Below determines how many artifacts containing tiles will actually spawn.
			target_digsite_size = min(target_digsite_size, viable_adjacent_turfs.len) //Min((4-12),25) with base settings, if there are tiles all around the deposit. If there are less tiles around the deposit, it'll be smaller than the target_size.effectively.

		for(var/i = 1 to target_digsite_size) //Go through all the selected turfs and let's start processing them!
			turfs_to_process += pick_n_take(viable_adjacent_turfs)

		while(turfs_to_process.len)
			var/turf/simulated/mineral/archeo_turf = pop(turfs_to_process)

			//Here, we start to see how many artifacts will spawn in the selected rock. 1-3 artifacts per.
			processed_turfs.Add(archeo_turf)
			if(isnull(archeo_turf.finds))
				archeo_turf.finds = list()
				if(prob(50))
					archeo_turf.finds.Add(new /datum/find(digsite, rand(10, 190)))	//Dictates how far one has to dig to properly excavate the artifact. From 10-190
				else if(prob(75))
					archeo_turf.finds.Add(new /datum/find(digsite, rand(10, 90)))	//High chance of being visible, alerting xenoarch to a digsite location.
					archeo_turf.finds.Add(new /datum/find(digsite, rand(110, 190)))
				else
					archeo_turf.finds.Add(new /datum/find(digsite, rand(10, 50)))
					archeo_turf.finds.Add(new /datum/find(digsite, rand(60, 140)))
					archeo_turf.finds.Add(new /datum/find(digsite, rand(150, 190)))

				//sometimes a find will be close enough to the surface to show
				var/datum/find/F = archeo_turf.finds[1]
				if(F.excavation_required <= F.view_range) //view_range is by default 40.
					archeo_turf.archaeo_overlay = "overlay_archaeo[rand(1,3)]"
					archeo_turf.update_icon()

			//have a chance for an artifact to spawn here, but not in animal or plant digsites
			if(isnull(M.artifact_find) && digsite != DIGSITE_GARDEN)
				artifact_spawning_turfs.Add(archeo_turf)

		//Larger maps will convince byond this is an infinite loop, so let go for a second
		CHECK_TICK

	//create artifact machinery. Colloquially known as large artifacts.
	//Any artifact turfs except for garden & animal digsites can be selected.
	var/num_artifacts_spawn = rand(ARTIFACTSPAWNNUM_LOWER, ARTIFACTSPAWNNUM_UPPER)
	while(artifact_spawning_turfs.len > num_artifacts_spawn)
		pick_n_take(artifact_spawning_turfs)

	//Actually adds the large artifacts to the areas, now that we have our selected locations.
	var/list/artifacts_spawnturf_temp = artifact_spawning_turfs.Copy()
	while(artifacts_spawnturf_temp.len > 0)
		var/turf/simulated/mineral/artifact_turf = pop(artifacts_spawnturf_temp)
		artifact_turf.artifact_find = new()

/// This is the proc that is used when a Z level runs out of artifacts. This means you have 'completed' your job and now you get bonus goodies to keep you occupied.
/datum/controller/subsystem/xenoarch/proc/continual_generation(var/mob/living/caller)

	/// So, to preface this, I had to do a lot of testing with this to ensure it wouldn't cause mass lag and that it properly functioned.
	/// At first, I tried to make it scan mineral in the user's Z. There's not really any preexisting functionality for this that I could find, so that was a negative.
	/// Next, I saw what would happen if it did 'in world' and then went 'if M.z != caller.z continue' and that caused...A lot of lag. For a long time.
	/// This range(100) was for me was completely lagless. It gives a good amount of artifacts to keep digging and keep archeo working so they don't 'run out' of things to do.
	for(var/turf/simulated/mineral/M in range(100, caller))

		if(!M.density)
			continue

		if(M.artifact_find)
			continue

		if(!prob(XENOARCH_SPAWN_CHANCE))
			continue

		var/farEnough = 1
		for(var/turf/T as anything in digsite_spawning_turfs)
			if(T in range(5, M))
				farEnough = 0
				break
		if(!farEnough)
			continue

		digsite_spawning_turfs.Add(M) //This rock was lucky enough to be selected and not near any other sites!

		var/digsite = get_random_digsite_type() //What type of artifact site is this? Dictates what items will spawn.
		var/target_digsite_size = rand(DIGSITESIZE_LOWER, DIGSITESIZE_UPPER) //What the minimum size our digsite will be.

		var/list/processed_turfs = list()
		var/list/turfs_to_process = list(M)

		var/list/viable_adjacent_turfs = list()
		if(target_digsite_size > 1)
			for(var/turf/simulated/mineral/T in orange(2, M)) //With the rock being the center, check every rock around us within 2 tiles in each direction. So 5x5 square with our rock as the center.
				if(!T.density) //Is it an actual mineral wall?
					continue
				if(T.finds) //If the rock being checked has an artifact in it already, skip it.
					continue
				if(T in processed_turfs) //The rock has already been processed...This shouldn't happen since farEnough above ensures digsites can't be next to each other. Presumably, this is a failsafe.
					continue
				viable_adjacent_turfs.Add(T) //Add to the list of rocks we can select for this site.

			//Below determines how many artifacts containing tiles will actually spawn.
			target_digsite_size = min(target_digsite_size, viable_adjacent_turfs.len) //Min((4-12),25) with base settings, if there are tiles all around the deposit. If there are less tiles around the deposit, it'll be smaller than the target_size.effectively.

		for(var/i = 1 to target_digsite_size) //Go through all the selected turfs and let's start processing them!
			turfs_to_process += pick_n_take(viable_adjacent_turfs)

		while(turfs_to_process.len)
			var/turf/simulated/mineral/archeo_turf = pop(turfs_to_process)

			//Here, we start to see how many artifacts will spawn in the selected rock. 1-3 artifacts per.
			processed_turfs.Add(archeo_turf)
			if(isnull(archeo_turf.finds))
				archeo_turf.finds = list()
				if(prob(50))
					archeo_turf.finds.Add(new /datum/find(digsite, rand(10, 190)))	//Dictates how far one has to dig to properly excavate the artifact. From 10-190
				else if(prob(75))
					archeo_turf.finds.Add(new /datum/find(digsite, rand(10, 90)))	//High chance of being visible, alerting xenoarch to a digsite location.
					archeo_turf.finds.Add(new /datum/find(digsite, rand(110, 190)))
				else
					archeo_turf.finds.Add(new /datum/find(digsite, rand(10, 50)))
					archeo_turf.finds.Add(new /datum/find(digsite, rand(60, 140)))
					archeo_turf.finds.Add(new /datum/find(digsite, rand(150, 190)))

				//sometimes a find will be close enough to the surface to show
				var/datum/find/F = archeo_turf.finds[1]
				if(F.excavation_required <= F.view_range) //view_range is by default 40.
					archeo_turf.archaeo_overlay = "overlay_archaeo[rand(1,3)]"
					archeo_turf.update_icon()

			//have a chance for an artifact to spawn here, but not in animal or plant digsites
			if(isnull(M.artifact_find) && digsite != DIGSITE_GARDEN)
				artifact_spawning_turfs.Add(archeo_turf)

		//Larger maps will convince byond this is an infinite loop, so let go for a second
		CHECK_TICK

	//create artifact machinery. Colloquially known as large artifacts.
	//Any artifact turfs except for garden & animal digsites can be selected.
	var/num_artifacts_spawn = rand(PROCEDURAL_LOWER, PROCEDURAL_UPPER) //Our random generation will spawn fewer new large artifacts. Remember, this is for our Z level, not the whole map!
	while(artifact_spawning_turfs.len > num_artifacts_spawn)
		pick_n_take(artifact_spawning_turfs)

	//Actually adds the large artifacts to the areas, now that we have our selected locations.
	var/list/artifacts_spawnturf_temp = artifact_spawning_turfs.Copy()
	while(artifacts_spawnturf_temp.len > 0)
		var/turf/simulated/mineral/artifact_turf = pop(artifacts_spawnturf_temp)
		artifact_turf.artifact_find = new()

#undef XENOARCH_SPAWN_CHANCE
#undef DIGSITESIZE_LOWER
#undef DIGSITESIZE_UPPER
#undef ARTIFACTSPAWNNUM_LOWER
#undef ARTIFACTSPAWNNUM_UPPER
#undef PROCEDURAL_LOWER
#undef PROCEDURAL_UPPER
