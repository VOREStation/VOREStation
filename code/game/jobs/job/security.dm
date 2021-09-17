//////////////////////////////////
//		Head of Security
//////////////////////////////////
/datum/job/hos
	title = "Head of Security"
	flag = HOS
	departments_managed = list(DEPARTMENT_SECURITY)
	departments = list(DEPARTMENT_SECURITY, DEPARTMENT_COMMAND)
	sorting_order = 2
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Site Manager"
	selection_color = "#8E2929"
	req_admin_notify = 1
	economic_modifier = 10
	access = list(access_security, access_eva, access_sec_doors, access_brig, access_armory,
			            access_forensics_lockers, access_morgue, access_maint_tunnels, access_all_personal_lockers,
			            access_research, access_engine, access_mining, access_medical, access_construction, access_mailsorting,
			            access_heads, access_hos, access_RC_announce, access_keycard_auth, access_gateway, access_external_airlocks)
	minimal_access = list(access_security, access_eva, access_sec_doors, access_brig, access_armory,
			            access_forensics_lockers, access_morgue, access_maint_tunnels, access_all_personal_lockers,
			            access_research, access_engine, access_mining, access_medical, access_construction, access_mailsorting,
			            access_heads, access_hos, access_RC_announce, access_keycard_auth, access_gateway, access_external_airlocks)
	minimum_character_age = 25
	min_age_by_species = list(SPECIES_HUMAN_VATBORN = 14)
	minimal_player_age = 14
	ideal_character_age = 50
	ideal_age_by_species = list(SPECIES_HUMAN_VATBORN = 20)
	banned_job_species = list(SPECIES_TESHARI, SPECIES_DIONA, SPECIES_PROMETHEAN, SPECIES_ZADDAT, "digital", SPECIES_UNATHI, "mechanical")

	outfit_type = /decl/hierarchy/outfit/job/security/hos
	job_description = "	The Head of Security manages the Security Department, keeping the station safe and making sure the rules are followed. They are expected to \
						keep the other Department Heads, and the rest of the crew, aware of developing situations that may be a threat. If necessary, the HoS may \
						perform the duties of absent Security roles, such as distributing gear from the Armory."
	alt_titles = list("Security Commander" = /datum/alt_title/sec_commander, "Chief of Security" = /datum/alt_title/sec_chief)


// Head of Security Alt Titles
/datum/alt_title/sec_commander
	title = "Security Commander"

/datum/alt_title/sec_chief
	title = "Chief of Security"

//////////////////////////////////
//			Warden
//////////////////////////////////
/datum/job/warden
	title = "Warden"
	flag = WARDEN
	departments = list(DEPARTMENT_SECURITY)
	sorting_order = 1
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Head of Security"
	selection_color = "#601C1C"
	economic_modifier = 5
	access = list(access_security, access_eva, access_sec_doors, access_brig, access_armory, access_maint_tunnels, access_morgue, access_external_airlocks)
	minimal_access = list(access_security, access_eva, access_sec_doors, access_brig, access_armory, access_maint_tunnels, access_external_airlocks)
	minimal_player_age = 5
	banned_job_species = list(SPECIES_ZADDAT, SPECIES_PROMETHEAN, SPECIES_TESHARI, SPECIES_DIONA)

	outfit_type = /decl/hierarchy/outfit/job/security/warden
	job_description = "The Warden watches over the physical Security Department, making sure the Brig and Armoury are secure and in order at all times. They oversee \
						prisoners that have been processed and brigged, and are responsible for their well being. The Warden is also in charge of distributing \
						Armoury gear in a crisis, and retrieving it when the crisis has passed. In an emergency, the Warden may be called upon to direct the \
						Security Department as a whole."

//////////////////////////////////
//			Detective
//////////////////////////////////
/datum/job/detective
	title = "Detective"
	flag = DETECTIVE
	departments = list(DEPARTMENT_SECURITY)
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the Head of Security"
	selection_color = "#601C1C"
	access = list(access_security, access_sec_doors, access_forensics_lockers, access_morgue, access_maint_tunnels, access_eva, access_external_airlocks, access_brig) //Vorestation edit - access_brig
	minimal_access = list(access_security, access_sec_doors, access_forensics_lockers, access_morgue, access_maint_tunnels, access_eva, access_external_airlocks)
	economic_modifier = 5
	minimal_player_age = 3
	banned_job_species = list(SPECIES_ZADDAT, SPECIES_PROMETHEAN, SPECIES_DIONA)

	outfit_type = /decl/hierarchy/outfit/job/security/detective
	job_description = "A Detective works to help Security find criminals who have not properly been identified, through interviews and forensic work. \
						For crimes only witnessed after the fact, or those with no survivors, they attempt to piece together what they can from pure evidence."
	alt_titles = list("Forensic Technician" = /datum/alt_title/forensic_tech)

// Detective Alt Titles
/datum/alt_title/forensic_tech
	title = "Forensic Technician"
	title_blurb = "A Forensic Technician works more with hard evidence and labwork than a Detective, but they share the purpose of solving crimes."
	title_outfit = /decl/hierarchy/outfit/job/security/detective/forensic

//////////////////////////////////
//		Security Officer
//////////////////////////////////
/datum/job/officer
	title = "Security Officer"
	flag = OFFICER
	departments = list(DEPARTMENT_SECURITY)
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 4
	spawn_positions = 4
	supervisors = "the Head of Security"
	selection_color = "#601C1C"
	economic_modifier = 4
	access = list(access_security, access_eva, access_sec_doors, access_brig, access_maint_tunnels, access_morgue, access_external_airlocks)
	minimal_access = list(access_security, access_eva, access_sec_doors, access_brig, access_maint_tunnels, access_external_airlocks)
	minimal_player_age = 3
	banned_job_species = list(SPECIES_ZADDAT, SPECIES_TESHARI, SPECIES_DIONA)

	outfit_type = /decl/hierarchy/outfit/job/security/officer
	job_description = "A Security Officer is concerned with maintaining the safety and security of the station as a whole, dealing with external threats and \
						apprehending criminals. A Security Officer is responsible for the health, safety, and processing of any prisoner they arrest. \
						No one is above the Law, not Security or Command."
	alt_titles = list("Junior Officer" = /datum/alt_title/junior_officer)

	min_age_by_species = list(SPECIES_PROMETHEAN = 3)

// Security Officer Alt Titles
/datum/alt_title/junior_officer
	title = "Junior Officer"
	title_blurb = "A Junior Officer is an inexperienced Security Officer. They likely have training, but not experience, and are frequently \
					paired off with a more senior co-worker. Junior Officers may also be expected to take over the boring duties of other Officers \
					including patrolling the station or maintaining specific posts."