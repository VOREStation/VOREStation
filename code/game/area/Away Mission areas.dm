/area/awaymission
	name = "\improper Unknown Location"
	icon_state = "away"
	var/list/valid_spawn_turfs = list()
	var/list/valid_mobs = list()
	var/list/valid_flora = list()
	var/mobcountmax = 0
	var/floracountmax = 0

/area/awaymission/New()
	..()
	sleep(60)
	//Adds turfs to the valid)turfs list, used for spawning.
	for(var/turf/simulated/floor/F in src)
		valid_spawn_turfs |= F
	for(var/turf/unsimulated/floor/F in src)
		valid_spawn_turfs |= F

	if(!valid_spawn_turfs.len)
		world << "Error! [src] does not have any turfs!"
		return TRUE

	//Handles random mob placement for mobcount, as defined/randomized in New of each individual area.
	for(var/mobscount = 0 to mobcountmax)
		spawn_mob_on_turf()

	//Handles random mob placement for mobcount, as defined/randomized in New of each individual area.
	for(var/floracount = 0 to floracountmax)
		spawn_flora_on_turf()

/area/awaymission/proc/spawn_mob_on_turf()
	if(!valid_mobs.len)
		world << "[src] does not have a set valid mobs list!"
		return TRUE
	var/mob/M = pick(valid_mobs)
	var/turf/Turf = pick(valid_spawn_turfs)
	valid_spawn_turfs -= Turf
	new M(Turf)

/area/awaymission/proc/spawn_flora_on_turf()
	if(!valid_flora.len)
		world << "[src] does not have a set valid flora list!"
		return TRUE
	var/obj/F = pick(valid_flora)
	var/turf/Turf = pick(valid_spawn_turfs)
	valid_spawn_turfs -= Turf
	new F(Turf)