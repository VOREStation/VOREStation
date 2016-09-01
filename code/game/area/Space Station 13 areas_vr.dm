/area/crew_quarters/sleep/vistor_room_1
	flags = RAD_SHIELDED

/area/crew_quarters/sleep/vistor_room_2
	flags = RAD_SHIELDED

/area/crew_quarters/sleep/vistor_room_3
	flags = RAD_SHIELDED

/area/crew_quarters/sleep/vistor_room_4
	flags = RAD_SHIELDED

/area/crew_quarters/sleep/vistor_room_5
	flags = RAD_SHIELDED

/area/crew_quarters/sleep/vistor_room_6
	flags = RAD_SHIELDED

/area/crew_quarters/sleep/vistor_room_7
	flags = RAD_SHIELDED

/area/crew_quarters/sleep/vistor_room_8
	flags = RAD_SHIELDED

/area/crew_quarters/sleep/vistor_room_9
	flags = RAD_SHIELDED

/area/crew_quarters/sleep/vistor_room_10
	flags = RAD_SHIELDED

/area/crew_quarters/sleep/vistor_room_11
	flags = RAD_SHIELDED

/area/crew_quarters/sleep/vistor_room_12
	flags = RAD_SHIELDED

/area/awaymission
	name = "\improper Strange Location"
	icon_state = "away"
	var/list/valid_mobs = list()
	var/list/valid_turfs = list()
	var/list/valid_flora = list()
	var/mobcount
	var/floracount

 /area/awaymission/New()
	..()
	//Adds turfs to the valid)turfs list, used for spawning.
	for(var/turf/T in src)
		valid_turfs |= T

	//Handles random mob placement for mobcount, as defined/randomized in New of each individual area.
	var/mobs
	while(mobs < mobcount)
		if(spawn_mob_on_turf())
			mobs++

	//Handles random mob placement for mobcount, as defined/randomized in New of each individual area.
	var/flora
	while(flora < floracount)
		if(spawn_flora_on_turf())
			flora++

/area/awaymission/proc/spawn_mob_on_turf()
	var/mob/M = pick(valid_mobs)
	var/turf/T = pick(valid_turfs)
	valid_turfs - T
	if(istype(T, /turf/simulated/floor) || istype(T, /turf/unsimulated/floor))
		new M(T)
		return TRUE

/area/awaymission/proc/spawn_flora_on_turf()
	var/obj/F = pick(valid_flora)
	var/turf/T = pick(valid_turfs)
	valid_turfs - T
	if(istype(T, /turf/simulated/floor) || istype(T, /turf/unsimulated/floor))
		new F(T)
		return TRUE