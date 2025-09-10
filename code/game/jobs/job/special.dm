/datum/job/centcom_officer //For Business
	title = "CentCom Officer"
	departments = list("Central Command")
	department_accounts = list(DEPARTMENT_COMMAND, DEPARTMENT_ENGINEERING, DEPARTMENT_MEDICAL, DEPARTMENT_RESEARCH, DEPARTMENT_SECURITY, DEPARTMENT_CARGO, DEPARTMENT_PLANET, DEPARTMENT_CIVILIAN)
	faction = FACTION_STATION
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

/datum/job/centcom_officer/get_access()
	return get_all_accesses().Copy()

/datum/job/emergency_responder //For staff managing/leading ERTs
	title = "Emergency Responder"
	departments = list("Central Command")
	department_accounts = list(DEPARTMENT_COMMAND, DEPARTMENT_ENGINEERING, DEPARTMENT_MEDICAL, DEPARTMENT_RESEARCH, DEPARTMENT_SECURITY, DEPARTMENT_CARGO, DEPARTMENT_PLANET, DEPARTMENT_CIVILIAN)
	faction = FACTION_STATION
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

/datum/job/emergency_responder/get_access()
	return get_all_accesses().Copy()

/datum/job/clown
	title = JOB_CLOWN
	flag = CLOWN
	departments = list(DEPARTMENT_CIVILIAN)
	department_flag = ENGSEC
	faction = FACTION_STATION
	total_positions = 1
	spawn_positions = 1
	supervisors = "the spirit of laughter"
	selection_color = "#515151"
	economic_modifier = 1
	job_description = "A " + JOB_CLOWN + " is there to entertain the crew and keep high morale using various harmless pranks and ridiculous jokes!"
	whitelist_only = 1
	latejoin_only = 0
	requestable = FALSE
	outfit_type = /decl/hierarchy/outfit/job/clown
	pto_type = PTO_CIVILIAN
	alt_titles = list(JOB_ALT_JESTER = /datum/alt_title/jester, JOB_ALT_FOOL = /datum/alt_title/fool)

/datum/alt_title/jester
	title = JOB_ALT_JESTER

/datum/alt_title/fool
	title = JOB_ALT_FOOL

/datum/job/clown/get_access()
	if(CONFIG_GET(flag/assistant_maint))
		return list(ACCESS_MAINT_TUNNELS, ACCESS_ENTERTAINMENT, ACCESS_CLOWN, ACCESS_TOMFOOLERY)
	else
		return list(ACCESS_ENTERTAINMENT, ACCESS_CLOWN, ACCESS_TOMFOOLERY)

/datum/job/mime
	title = JOB_MIME
	flag = MIME
	departments = list(DEPARTMENT_CIVILIAN)
	department_flag = ENGSEC
	faction = FACTION_STATION
	total_positions = 1
	spawn_positions = 1
	supervisors = "the spirit of performance"
	selection_color = "#515151"
	economic_modifier = 1
	job_description = "A " + JOB_MIME + " is there to entertain the crew and keep high morale using unbelievable performances and acting skills!"
	alt_titles = list(JOB_ALT_PASEUR = /datum/alt_title/poseur)
	whitelist_only = 1
	latejoin_only = 0
	requestable = FALSE
	outfit_type = /decl/hierarchy/outfit/job/mime
	pto_type = PTO_CIVILIAN

/datum/alt_title/poseur
	title = JOB_ALT_PASEUR

/datum/job/mime/get_access()
	if(CONFIG_GET(flag/assistant_maint))
		return list(ACCESS_MAINT_TUNNELS, ACCESS_ENTERTAINMENT, ACCESS_TOMFOOLERY, ACCESS_MIME)
	else
		return list(ACCESS_ENTERTAINMENT, ACCESS_TOMFOOLERY, ACCESS_MIME)

/obj/item/card/id/civilian/lurker
	desc = "A rather old and scuffed-looking ID. It seems legit, but something also seems very off somehow. Say, what's the issue/expiry date..?"
	assignment = "NO DATA"
	rank = JOB_MAINT_LURKER

/datum/job/maint_lurker
	title = JOB_MAINT_LURKER
	departments = list(DEPARTMENT_CIVILIAN)
	faction = FACTION_STATION
	total_positions = -1
	spawn_positions = -1
	supervisors = "nobody save your own common sense and good judgement, though Security may get upset if you're not careful"
	selection_color = "#515151"
	account_allowed = FALSE	//let's not give the game away by creating accounts that someone might stumble across
	job_description = "You are a maintenance lurker! You shouldn't be able to see this description anyway! Go prank the CMO or eat the RD's hat or something instead of looking at this."
	whitelist_only = 1
	latejoin_only = 1
	requestable = FALSE
	outfit_type = /decl/hierarchy/outfit/maint_lurker
	access = list(ACCESS_MAINT_TUNNELS)
	minimal_access = list(ACCESS_MAINT_TUNNELS)
