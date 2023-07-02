/area
	name = "\improper Unknown Location"
	icon_state = "away"
	var/list/valid_spawn_turfs = list()
	var/list/valid_mobs = list()
	var/list/valid_flora = list()
	var/mobcountmax = 0
	var/floracountmax = 0
	var/semirandom = FALSE
	var/semirandom_groups = 0
	var/semirandom_group_min = 0
	var/semirandom_group_max = 10
	var/mob_intent = "default"	//"default" uses default settings, use "hostile", "retaliate", or "passive" respectively

/area/proc/EvalValidSpawnTurfs()
	//Adds turfs to the valid)turfs list, used for spawning.
	if(mobcountmax || floracountmax || semirandom)
		for(var/turf/simulated/floor/F in src)
			valid_spawn_turfs += F
		for(var/turf/unsimulated/floor/F in src)
			valid_spawn_turfs += F

/area/LateInitialize()
	..()
	EvalValidSpawnTurfs()

	if(!valid_spawn_turfs.len && (mobcountmax || floracountmax))
		log_and_message_admins("Error! [src] does not have any turfs!")
		return TRUE

	//Handles random mob placement for mobcountmax, as defined/randomized in initialize of each individual area.
	if(mobcountmax || semirandom)
		spawn_mob_on_turf()

	//Handles random flora placement for floracountmax, as defined/randomized in initialize of each individual area.
	if(floracountmax)
		spawn_flora_on_turf()

	message_admins("Away mission spawning done.")

/area/proc/spawn_mob_on_turf()
	if(!valid_mobs.len)
		to_world_log("[src] does not have a set valid mobs list!")
		return TRUE

	var/mob/M
	var/turf/Turf
	if(semirandom)
		for(var/groupscount = 0 to (semirandom_groups - 1))
			var/ourgroup = pickweight(valid_mobs)
			var/goodnum = rand(semirandom_group_min, semirandom_group_max)
			for(var/mobscount = 0 to (goodnum - 1))
				M = pickweight(ourgroup)
				Turf = pick(valid_spawn_turfs)
				valid_spawn_turfs -= Turf
				var/mob/ourmob = new M(Turf)
				adjust_mob(ourmob)
	else
		for(var/mobscount = 0 to mobcountmax)
			M = pickweight(valid_mobs)
			Turf = pick(valid_spawn_turfs)
			valid_spawn_turfs -= Turf
			var/mob/ourmob = new M(Turf)
			adjust_mob(ourmob)

/area/proc/adjust_mob(var/mob/living/M)
	if(!isliving(M))
		log_admin("[src] spawned [M.type], which is not mob/living, FIXIT")
		return
	var/datum/ai_holder/AI = M.ai_holder
	switch(mob_intent)
		if("default")
			return
		if("hostile")
			AI.hostile = TRUE
			AI.retaliate = TRUE
		if("retaliate")
			AI.hostile = FALSE
			AI.retaliate = TRUE
		if("passive")
			AI.hostile = FALSE
			AI.retaliate = FALSE

/area/proc/spawn_flora_on_turf()
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
