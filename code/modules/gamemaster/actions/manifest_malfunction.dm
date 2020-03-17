/datum/gm_action/manifest_malfunction
	name = "manifest malfunction"
	enabled = TRUE
	departments = list(DEPARTMENT_SECURITY, DEPARTMENT_SYNTHETIC, DEPARTMENT_EVERYONE)
	chaotic = 3
	reusable = FALSE
	length = 0

	var/recordtype

/datum/gm_action/manifest_malfunction/set_up()
	severity = pickweight(EVENT_LEVEL_MUNDANE = 6,
		EVENT_LEVEL_MODERATE = 2,
		EVENT_LEVEL_MAJOR = 1
		)

	recordtype = pickweight("medical" = 10,"security" = (severity * 15))

	return

/datum/gm_action/manifest_malfunction/get_weight()
	. = -10

	var/security = metric.count_people_in_department(DEPARTMENT_SECURITY)

	if(security && data_core)
		. += (metric.count_people_in_department(DEPARTMENT_EVERYONE) * 5) - (metric.count_people_in_department(DEPARTMENT_SYNTHETIC) * 5)

	return .

/datum/gm_action/manifest_malfunction/start()
	..()

	var/manifest_cut_count = 1 * severity

	for(var/I = 1 to manifest_cut_count)
		var/datum/data/record/R

		switch(recordtype)
			if("security")
				R = pick(data_core.security)

			if("medical")
				R = pick(data_core.medical)

		qdel(R)

/datum/gm_action/manifest_malfunction/announce()
	if(prob(30 * severity))
		spawn(rand(5 MINUTES, 10 MINUTES))
			command_announcement.Announce("An ongoing mass upload of malware for [recordtype] record cores has been detected onboard  [station_name()]", "Data Breach Alert")
	return
