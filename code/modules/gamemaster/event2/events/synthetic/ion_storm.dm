/datum/event2/meta/ion_storm
	name = "ion storm"
	departments = list(DEPARTMENT_SYNTHETIC)
	chaos = 40
	chaotic_threshold = EVENT_CHAOS_THRESHOLD_MEDIUM_IMPACT
	event_type = /datum/event2/event/ion_storm

/datum/event2/meta/ion_storm/get_weight()
	var/list/bots = GLOB.metric.get_people_in_department(DEPARTMENT_SYNTHETIC)
	. = 5 // A small chance even if no synths are on, since it can still emag beepsky.
	for(var/mob/living/silicon/S in bots)
		if(istype(S, /mob/living/silicon/robot/drone)) // Drones don't get their laws screwed with, so don't count them.
			continue
		. += 40


/datum/event2/event/ion_storm
	announce_delay_lower_bound = 7 MINUTES
	announce_delay_upper_bound = 15 MINUTES
	var/bot_emag_chance = 30 // This is rolled once, instead of once a second for a minute like the old version.
	var/announce_odds = 50 // Probability of an announcement actually happening after the delay.

/datum/event2/event/ion_storm/start()
	// Ion laws.
	for(var/mob/living/silicon/target in silicon_mob_list)
		if(target.z in get_location_z_levels())
			// Don't ion law drons.
			if(istype(target, /mob/living/silicon/robot/drone))
				continue

			// Or borgs with an AI (they'll get their AI's ion law anyways).
			if(isrobot(target))
				var/mob/living/silicon/robot/R = target
				if(R.connected_ai)
					continue
				if(R.shell)
					continue

			// Crew member names, and excluding off station antags, are handled by `generate_ion_law()` automatically.
			var/law = target.generate_ion_law()
			target.add_ion_law(law)
			target.show_laws()

	// Emag bots.
	for(var/mob/living/bot/B in mob_list)
		if(B.z in get_location_z_levels())
			if(prob(bot_emag_chance))
				B.emag_act(1)

	// Messaging server spam filters.
	// This might be better served as a seperate event since it seems more like a hacker attack than a natural occurance.
	if(message_servers)
		for(var/obj/machinery/message_server/MS in message_servers)
			if(MS.z in get_location_z_levels())
				MS.spamfilter.Cut()
				for (var/i = 1, i <= MS.spamfilter_limit, i++)
					MS.spamfilter += pick("warble","help","almach","ai","liberty","freedom","drugs", "[using_map.station_short]", \
						"admin","sol","security","meow","_","monkey","-","moron","pizza","message","spam",\
						"director", "Hello", "Hi!"," ","nuke","crate","taj","xeno")

/datum/event2/event/ion_storm/announce()
	if(prob(announce_odds))
		command_announcement.Announce("An ion storm was detected within proximity to \the [location_name()] recently. \
		Check all AI controlled equipment for corruption.", "Anomaly Alert", new_sound = 'sound/AI/ionstorm.ogg')

// Fake variant used by traitors.
/datum/event2/event/ion_storm/fake
	// Fake ion storms announce instantly, so the traitor can time it to make the AI look suspicious.
	announce_delay_lower_bound = 0
	announce_delay_upper_bound = 0
	announce_odds = 100

/datum/event2/event/ion_storm/fake/start()
	return
