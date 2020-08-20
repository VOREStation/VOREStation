/datum/job/bartender
	pto_type = PTO_CIVILIAN

/datum/job/chef
	total_positions = 2 //IT TAKES A LOT TO MAKE A STEW
	spawn_positions = 2 //A PINCH OF SALT AND LAUGHTER, TOO
	pto_type = PTO_CIVILIAN

/datum/job/hydro
	spawn_positions = 2
	pto_type = PTO_CIVILIAN

/datum/job/qm
	pto_type = PTO_CARGO
	dept_time_required = 20

/datum/job/cargo_tech
	total_positions = 3
	spawn_positions = 3
	pto_type = PTO_CARGO

/datum/job/mining
	total_positions = 4
	spawn_positions = 4
	pto_type = PTO_CARGO

/datum/job/janitor //Lots of janitor substations on station.
	total_positions = 3
	spawn_positions = 3
	alt_titles = list("Custodian" = /datum/alt_title/custodian, "Sanitation Technician" = /datum/alt_title/sanitation_tech, "Maid" = /datum/alt_title/maid)
	pto_type = PTO_CIVILIAN

/datum/alt_title/sanitation_tech
	title = "Sanitation Technician"

/datum/alt_title/maid
	title = "Maid"

/datum/job/librarian
	total_positions = 2
	spawn_positions = 2
	alt_titles = list("Journalist" = /datum/alt_title/journalist, "Writer" = /datum/alt_title/writer, "Historian" = /datum/alt_title/historian, "Professor" = /datum/alt_title/professor)
	pto_type = PTO_CIVILIAN

/datum/alt_title/historian
	title = "Historian"
	title_blurb = "The Historian uses the Library as a base of operation to record any important events occuring on station."

/datum/alt_title/professor
	title = "Professor"
	title_blurb = "The Professor uses the Library as a base of operations to share their vast knowledge with the crew."

/datum/job/lawyer
	disallow_jobhop = TRUE
	pto_type = PTO_CIVILIAN

/datum/job/chaplain
	pto_type = PTO_CIVILIAN



//////////////////////////////////
//			Entertainer
//////////////////////////////////

/datum/job/entertainer
	title = "Entertainer"
	flag = ENTERTAINER
	departments = list(DEPARTMENT_CIVILIAN)
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 4
	spawn_positions = 4
	supervisors = "the Head of Personnel"
	selection_color = "#515151"
	access = list(access_entertainment)
	minimal_access = list(access_entertainment)
	pto_type = PTO_CIVILIAN

	outfit_type = /decl/hierarchy/outfit/job/assistant
	job_description = "An entertainer does just that, entertains! Put on plays, play music, sing songs, tell stories, or read your favorite fanfic."
	alt_titles = list("Performer" = /datum/alt_title/performer, "Musician" = /datum/alt_title/musician, "Stagehand" = /datum/alt_title/stagehand)

// Entertainer Alt Titles
/datum/alt_title/performer
	title = "Performer"
	title_blurb = "A Performer is someone who performs! Acting, dancing, wrestling, etc!"

/datum/alt_title/musician
	title = "Musician"
	title_blurb = "A Musician is someone who makes music! Singing, playing instruments, slam poetry, it's your call!"

/datum/alt_title/stagehand
	title = "Stagehand"
	title_blurb = "A Stagehand typically performs everything the rest of the entertainers don't. Operate lights, shutters, windows, or narrate through your voicebox!"