/datum/gm_action/radiation_storm
	name = "radiation storm"
	departments = list(ROLE_EVERYONE)
	reusable = TRUE

	var/enterBelt			= 30
	var/radIntervall		= 5
	var/leaveBelt			= 80
	var/revokeAccess		= 165
	var/activeFor			= 0
	var/postStartTicks 		= 0
	var/active				= FALSE

/datum/gm_action/radiation_storm/announce()
	command_announcement.Announce("High levels of radiation detected near \the [station_name()]. Please evacuate into one of the shielded maintenance tunnels.", "Anomaly Alert", new_sound = 'sound/AI/radiation.ogg')

/datum/gm_action/radiation_storm/set_up()
	active = TRUE

/datum/gm_action/radiation_storm/start()
	..()
	make_maint_all_access()

	while(active)
		sleep(1 SECOND)
		activeFor ++
		if(activeFor == enterBelt)
			command_announcement.Announce("The station has entered the radiation belt. Please remain in a sheltered area until we have passed the radiation belt.", "Anomaly Alert")
			radiate()

		if(activeFor >= enterBelt && activeFor <= leaveBelt)
			postStartTicks++

		if(postStartTicks == radIntervall)
			postStartTicks = 0
			radiate()

		else if(activeFor == leaveBelt)
			command_announcement.Announce("The station has passed the radiation belt. Please allow for up to one minute while radiation levels dissipate, and report to medbay if you experience any unusual symptoms. Maintenance will lose all access again shortly.", "Anomaly Alert")

/datum/gm_action/radiation_storm/proc/radiate()
	var/radiation_level = rand(15, 35)
	for(var/z in using_map.station_levels)
		radiation_repository.z_radiate(locate(1, 1, z), radiation_level, 1)

	for(var/mob/living/carbon/C in living_mob_list)
		var/area/A = get_area(C)
		if(!A)
			continue
		if(A.flags & RAD_SHIELDED)
			continue
		if(istype(C,/mob/living/carbon/human))
			var/mob/living/carbon/human/H = C
			if(prob(5))
				if (prob(75))
					randmutb(H) // Applies bad mutation
					domutcheck(H,null,MUTCHK_FORCED)
				else
					randmutg(H) // Applies good mutation
					domutcheck(H,null,MUTCHK_FORCED)

/datum/gm_action/radiation_storm/end()
	spawn(revokeAccess SECONDS)
		revoke_maint_all_access()

/datum/gm_action/radiation_storm/get_weight()
	var/people_in_space = 0
	for(var/mob/living/L in player_list)
		if(!(L.z in using_map.station_levels))
			continue // Not on the right z-level.
		var/turf/T = get_turf(L)
		if(istype(T, /turf/space) && istype(T.loc,/area/space))
			people_in_space++
	return 20 + (metric.count_people_in_department(ROLE_MEDICAL) * 10) + (people_in_space * 40) + (metric.count_people_in_department(ROLE_EVERYONE) * 20)
