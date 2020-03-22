/datum/gm_action/security_screening
	name = "security screening"
	departments = list(DEPARTMENT_SECURITY, DEPARTMENT_EVERYONE)

	var/list/species_weights = list(
	SPECIES_SKRELL = 9,
	SPECIES_UNATHI = 15,
	SPECIES_HUMAN_VATBORN = 6,
	SPECIES_TESHARI = 2,
	SPECIES_TAJ = 3,
	SPECIES_DIONA = 1,
	SPECIES_ZADDAT = 25,
	SPECIES_HUMAN = 3,
	SPECIES_PROMETHEAN = 30
	)

	var/list/synth_weights = list(
	"Cybernetic" = 15,
	"Drone" = 30,
	"Positronic" = 25
	)

	var/list/end_weights = list()

/datum/gm_action/security_screening/set_up()
	for(var/species_name in species_weights)
		var/giveweight = 0

		for(var/datum/data/record/R in data_core.general)
			if(R.fields["species"] == species_name)
				giveweight += species_weights[species_name]

		end_weights[species_name] = giveweight

	for(var/bottype in synth_weights)
		var/giveweight = 0

		for(var/datum/data/record/R in data_core.general)
			if(R.fields["brain_type"] == bottype)
				giveweight += synth_weights[bottype]

		end_weights[bottype] = giveweight

/datum/gm_action/security_screening/announce()
	spawn(rand(1 MINUTE, 2 MINUTES))
		command_announcement.Announce("[pick("A nearby Navy vessel", "A Solar official", "A Vir-Gov official", "A NanoTrasen board director")] has requested the screening of [pick("every other", "every", "suspicious", "willing")] [pickweight(end_weights)] personnel onboard \the [station_name()].", "Security Advisement")

/datum/gm_action/security_screening/get_weight()
	return max(-20, 10 + round(gm.staleness * 1.5) - (gm.danger * 2)) + (metric.count_people_in_department(DEPARTMENT_SECURITY) * 10) + (metric.count_people_in_department(DEPARTMENT_EVERYONE) * 1.5)
