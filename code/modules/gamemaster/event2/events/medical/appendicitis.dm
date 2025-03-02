/datum/event2/meta/appendicitis
	name = "appendicitis"
	departments = list(DEPARTMENT_MEDICAL)
	chaos = 40
	chaotic_threshold = EVENT_CHAOS_THRESHOLD_MEDIUM_IMPACT
	event_type = /datum/event2/event/appendicitis

/datum/event2/meta/appendicitis/get_weight()
	var/list/doctors = GLOB.metric.get_people_with_job(/datum/job/doctor)

	doctors -= GLOB.metric.get_people_with_alt_title(/datum/job/doctor, /datum/alt_title/nurse)
	doctors -= GLOB.metric.get_people_with_alt_title(/datum/job/doctor, /datum/alt_title/virologist)
	doctors += GLOB.metric.get_people_with_job(/datum/job/cmo)

	return doctors.len * 10



/datum/event2/event/appendicitis/start()
	for(var/mob/living/carbon/human/H in shuffle(living_mob_list))
		// Don't do it to SSD people.
		if(!H.client)
			continue

		// Or antags / bellied.
		if(player_is_antag(H.mind) || isbelly(H.loc))
			continue

		// Or doctors (otherwise it could be possible for the only surgeon to need surgery).
		if(H in GLOB.metric.get_people_with_job(/datum/job/doctor) )
			continue

		if(H.appendicitis())
			log_debug("Appendicitis event gave appendicitis to \the [H].")
			return
	log_debug("Appendicitis event could not find a valid victim.")
