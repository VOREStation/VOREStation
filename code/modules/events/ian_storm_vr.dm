/datum/event/ianstorm //VORESTATION AI TEMPORARY REMOVAL
	announceWhen = 1
	startWhen = 2
	endWhen = 3

/datum/event/ianstorm/announce()
	command_announcement.Announce("It has come to our attention that the [using_map.facility_type] passed through an ion storm.  Please monitor all electronic equipment for malfunctions.", "Anomaly Alert", 'sound/AI/ian_storm.ogg')
	spawn(7 SECONDS)
		command_announcement.Announce("Wait. No, that's wrong.  The station passed through an IAN storm!.", "Ian Alert")

/datum/event/ianstorm/start()
	spawn()
		for(var/mob/living/carbon/human/C in living_mob_list)
			var/turf/T = get_turf(C)
			if(!T)
				continue
			if(!(T.z in using_map.station_levels))
				continue
			var/area/A = get_area(T)
			if(A.flag_check(RAD_SHIELDED | BLUE_SHIELDED))
				continue
			place_ian(T)

/datum/event/ianstorm/proc/place_ian(var/turf/T)
	// Try three times to place an Ian
	for(var/i = 0, i < 3, i++)
		var/turf/target = get_step(T, pick(alldirs))
		if(target && istype(target, /turf/simulated/floor))
			var/mob/living/simple_mob/animal/passive/dog/corgi/Ian/doge = new(target)
			doge.name = "Ian " + pick("Alpha", "Beta", "Chi", "Delta", "Epsilon", "Phi",
				"Gamma", "Eta", "Iota", "Kappa", "Lambda", "Omicron", "Theta",
				"Rho", "Sigma", "Tau", "Upsilon", "Omega", "Psi", "Zeta")
			// Poof them onto the station!
			var/datum/effect/effect/system/steam_spread/s = new
			s.set_up(3, 0, target)
			s.start()
			return
	// Sadly no ian feasible.
