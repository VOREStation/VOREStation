/*
	MERCENARY ROUNDTYPE
*/

GLOBAL_LIST_EMPTY(nuke_disks)

/datum/game_mode/nuclear
	name = "Mercenary"
	round_description = "A mercenary strike force is approaching the station!"
	extended_round_description = "The Company's majority control of phoron in the system has marked the \
		station to be a highly valuable target for many competing organizations and individuals. Being a \
		colony of sizable population and considerable wealth causes it to often be the target of various \
		attempts of robbery, fraud and other malicious actions."
	config_tag = "mercenary"
	required_players = 12
	required_players_secret = 12
	required_enemies = 3
	end_on_antag_death = 0
	var/nuke_off_station = 0 //Used for tracking if the syndies actually haul the nuke to the station
	var/syndies_didnt_escape = 0 //Used for tracking if the syndies got the shuttle off of the z-level
	antag_tags = list(MODE_MERCENARY)

//delete all nuke disks not on a station zlevel
/datum/game_mode/nuclear/proc/check_nuke_disks()
	for(var/obj/item/disk/nuclear/N in GLOB.nuke_disks)
		if(isNotStationLevel(N.z)) qdel(N)

//checks if L has a nuke disk on their person
/datum/game_mode/nuclear/proc/check_mob(mob/living/L)
	for(var/obj/item/disk/nuclear/N in GLOB.nuke_disks)
		if(N.storage_depth(L) >= 0)
			return 1
	return 0

/datum/game_mode/nuclear/declare_completion()
	if(CONFIG_GET(flag/objectives_disabled))
		..()
		return
	var/disk_rescued = 1
	for(var/obj/item/disk/nuclear/D in GLOB.nuke_disks)
		var/disk_area = get_area(D)
		if(!is_type_in_list(disk_area, centcom_areas))
			disk_rescued = 0
			break
	var/crew_evacuated = (emergency_shuttle.returned())

	if(!disk_rescued &&  station_was_nuked && !syndies_didnt_escape)
		feedback_set_details("round_end_result","win - syndicate nuke")
		to_world(span_filter_system(span_large(span_bold("Mercenary Major Victory!"))))
		to_world(span_filter_system(span_bold("[syndicate_name()] operatives have destroyed [station_name()]!")))

	else if (!disk_rescued &&  station_was_nuked && syndies_didnt_escape)
		feedback_set_details("round_end_result","halfwin - syndicate nuke - did not evacuate in time")
		to_world(span_filter_system(span_large(span_bold("Total Annihilation"))))
		to_world(span_filter_system(span_bold("[syndicate_name()] operatives destroyed [station_name()] but did not leave the area in time and got caught in the explosion.") + " Next time, don't lose the disk!"))

	else if (!disk_rescued && !station_was_nuked &&  nuke_off_station && !syndies_didnt_escape)
		feedback_set_details("round_end_result","halfwin - blew wrong station")
		to_world(span_filter_system(span_large(span_bold("Crew Minor Victory"))))
		to_world(span_filter_system(span_bold("[syndicate_name()] operatives secured the authentication disk but blew up something that wasn't [station_name()].") + " Next time, don't lose the disk!"))

	else if (!disk_rescued && !station_was_nuked &&  nuke_off_station && syndies_didnt_escape)
		feedback_set_details("round_end_result","halfwin - blew wrong station - did not evacuate in time")
		to_world(span_filter_system(span_large(span_bold("[syndicate_name()] operatives have earned Darwin Award!"))))
		to_world(span_filter_system(span_bold("[syndicate_name()] operatives blew up something that wasn't [station_name()] and got caught in the explosion.") + " Next time, don't lose the disk!"))

	else if (disk_rescued && mercs.antags_are_dead())
		feedback_set_details("round_end_result","loss - evacuation - disk secured - syndi team dead")
		to_world(span_filter_system(span_large(span_bold("Crew Major Victory!"))))
		to_world(span_filter_system(span_bold("The Research Staff has saved the disc and killed the [syndicate_name()] Operatives")))

	else if ( disk_rescued                                        )
		feedback_set_details("round_end_result","loss - evacuation - disk secured")
		to_world(span_filter_system(span_large(span_bold("Crew Major Victory"))))
		to_world(span_filter_system(span_bold("The Research Staff has saved the disc and stopped the [syndicate_name()] Operatives!")))

	else if (!disk_rescued && mercs.antags_are_dead())
		feedback_set_details("round_end_result","loss - evacuation - disk not secured")
		to_world(span_filter_system(span_large(span_bold("Mercenary Minor Victory!"))))
		to_world(span_filter_system(span_bold("The Research Staff failed to secure the authentication disk but did manage to kill most of the [syndicate_name()] Operatives!")))

	else if (!disk_rescued && crew_evacuated)
		feedback_set_details("round_end_result","halfwin - detonation averted")
		to_world(span_filter_system(span_large(span_bold("Mercenary Minor Victory!"))))
		to_world(span_filter_system(span_bold("[syndicate_name()] operatives recovered the abandoned authentication disk but detonation of [station_name()] was averted.") + " Next time, don't lose the disk!"))

	else if (!disk_rescued && !crew_evacuated)
		feedback_set_details("round_end_result","halfwin - interrupted")
		to_world(span_filter_system(span_large(span_bold("Neutral Victory"))))
		to_world(span_filter_system(span_bold("Round was mysteriously interrupted!")))

	..()
	return
