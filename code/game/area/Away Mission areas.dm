/area/awaymission
	name = "\improper Unknown Location"
	icon_state = "away"
	var/list/valid_spawn_turfs = list()
	var/list/valid_mobs = list()
	var/list/valid_flora = list()
	var/mobcountmax = 0
	var/floracountmax = 0

/area/awaymission/proc/EvalValidSpawnTurfs()
	//Adds turfs to the valid)turfs list, used for spawning.
	if(mobcountmax || floracountmax)
		for(var/turf/simulated/floor/F in src)
			valid_spawn_turfs += F
		for(var/turf/unsimulated/floor/F in src)
			valid_spawn_turfs += F

/area/awaymission/LateInitialize()
	..()
	EvalValidSpawnTurfs()
		
	if(!valid_spawn_turfs.len && (mobcountmax || floracountmax))
		to_world_log("Error! [src] does not have any turfs!")
		return TRUE

	//Handles random mob placement for mobcountmax, as defined/randomized in initialize of each individual area.
	if(mobcountmax)
		spawn_mob_on_turf()

	//Handles random flora placement for floracountmax, as defined/randomized in initialize of each individual area.
	if(floracountmax)
		spawn_flora_on_turf()
	
	to_world("Away mission spawning done.")

/area/awaymission/proc/spawn_mob_on_turf()
	if(!valid_mobs.len)
		to_world_log("[src] does not have a set valid mobs list!")
		return TRUE
		
	var/mob/M
	var/turf/Turf
	for(var/mobscount = 0 to mobcountmax)
		M = pick(valid_mobs)
		Turf = pick(valid_spawn_turfs)
		valid_spawn_turfs -= Turf
		new M(Turf)

/area/awaymission/proc/spawn_flora_on_turf()
	if(!valid_flora.len)
		to_world_log("[src] does not have a set valid flora list!")
		return TRUE
		
	var/obj/F
	var/turf/Turf
	for(var/floracount = 0 to floracountmax)
		F = pick(valid_flora)
		Turf = pick(valid_spawn_turfs)
		valid_spawn_turfs -= Turf
		new F(Turf)