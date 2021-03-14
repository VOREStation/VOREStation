/datum/job/centcom_officer //For Business
	title = "CentCom Officer"
	departments = list("Central Command")
	department_accounts = list(DEPARTMENT_COMMAND, DEPARTMENT_ENGINEERING, DEPARTMENT_MEDICAL, DEPARTMENT_RESEARCH, DEPARTMENT_SECURITY, DEPARTMENT_CARGO, DEPARTMENT_PLANET, DEPARTMENT_CIVILIAN)
	faction = "Station"
	total_positions = 2
	spawn_positions = 1
	supervisors = "company officials and Corporate Regulations"
	selection_color = "#1D1D4F"
	access = list()
	minimal_access = list()
	minimal_player_age = 14
	economic_modifier = 20
	whitelist_only = 1
	latejoin_only = 1
	outfit_type = /decl/hierarchy/outfit/job/centcom_officer
	job_description = "A Central Command Officer is there on official business. Most of time. Whatever it is, they're a VIP."

	minimum_character_age = 25
	ideal_character_age = 40

	pto_type = PTO_CIVILIAN

	get_access()
		return get_all_accesses().Copy()

/datum/job/emergency_responder //For staff managing/leading ERTs
	title = "Emergency Responder"
	departments = list("Central Command")
	department_accounts = list(DEPARTMENT_COMMAND, DEPARTMENT_ENGINEERING, DEPARTMENT_MEDICAL, DEPARTMENT_RESEARCH, DEPARTMENT_SECURITY, DEPARTMENT_CARGO, DEPARTMENT_PLANET, DEPARTMENT_CIVILIAN)
	faction = "Station"
	total_positions = 2
	spawn_positions = 1
	supervisors = "company officials and Corporate Regulations"
	selection_color = "#1D1D4F"
	access = list()
	minimal_access = list()
	minimal_player_age = 14
	economic_modifier = 20
	whitelist_only = 1
	latejoin_only = 1
	outfit_type = /decl/hierarchy/outfit/job/emergency_responder
	job_description = "Emergency Responders are usually called in to deal with on-station emergencies that the crew require assistance to deal with."

	minimum_character_age = 18
	ideal_character_age = 30

	pto_type = PTO_CIVILIAN

	get_access()
		return get_all_accesses().Copy()

/datum/job/clown
	title = "Clown"
	flag = CLOWN
	departments = list(DEPARTMENT_CIVILIAN)
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the spirit of laughter"
	selection_color = "#515151"
	economic_modifier = 1
	job_description = "A Clown is there to entertain the crew and keep high morale using various harmless pranks and ridiculous jokes!"
	whitelist_only = 1
	latejoin_only = 0
	outfit_type = /decl/hierarchy/outfit/job/clown
	pto_type = PTO_CIVILIAN
	alt_titles = list("Jester" = /datum/alt_title/jester, "Fool" = /datum/alt_title/fool)

/datum/alt_title/jester
	title = "Jester"

/datum/alt_title/fool
	title = "Fool"

/datum/job/clown/get_access()
	if(config.assistant_maint)
		return list(access_maint_tunnels, access_entertainment, access_clown, access_tomfoolery)
	else
		return list(access_entertainment, access_clown, access_tomfoolery)

/datum/job/mime
	title = "Mime"
	flag = MIME
	departments = list(DEPARTMENT_CIVILIAN)
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the spirit of performance"
	selection_color = "#515151"
	economic_modifier = 1
	job_description = "A Mime is there to entertain the crew and keep high morale using unbelievable performances and acting skills!"
	alt_titles = list("Poseur" = /datum/alt_title/poseur)
	whitelist_only = 1
	latejoin_only = 0
	outfit_type = /decl/hierarchy/outfit/job/mime
	pto_type = PTO_CIVILIAN

/datum/alt_title/poseur
	title = "Poseur"

/datum/job/mime/get_access()
	if(config.assistant_maint)
		return list(access_maint_tunnels, access_entertainment, access_tomfoolery, access_mime)
	else
		return list(access_entertainment, access_tomfoolery, access_mime)
