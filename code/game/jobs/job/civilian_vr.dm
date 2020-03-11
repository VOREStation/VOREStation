/datum/job/chef
	total_positions = 2 //IT TAKES A LOT TO MAKE A STEW
	spawn_positions = 2 //A PINCH OF SALT AND LAUGHTER, TOO

/datum/job/hydro
	spawn_positions = 2

/datum/job/cargo_tech
	total_positions = 3
	spawn_positions = 3

/datum/job/mining
	total_positions = 4
	spawn_positions = 4

/datum/job/janitor //Lots of janitor substations on station.
	total_positions = 3
	spawn_positions = 3
	alt_titles = list("Janitor" = /datum/alt_title/janitor,
					  "Custodian" = /datum/alt_title/custodian,
					  "Sanitation Technician" = /datum/alt_title/sanitation_tech,
					  "Maid" = /datum/alt_title/maid)

/datum/alt_title/sanitation_tech
	title = "Sanitation Technician"

/datum/alt_title/maid
	title = "Maid"

//TFF 5/9/19 - restore librarian job slot to 2
/datum/job/librarian
	total_positions = 2
	spawn_positions = 2
	alt_titles = list("Librarian" = /datum/alt_title/librarian, "Journalist" = /datum/alt_title/journalist, "Writer" = /datum/alt_title/writer, "Historian" = /datum/alt_title/historian)

/datum/alt_title/historian
	title = "Historian"
	title_blurb = "The Historian uses the Library as a base of operation to record any important events occuring on station."

/datum/job/lawyer
	disallow_jobhop = TRUE



