/datum/gear/uniform/suit/permit
	display_name = "nudity permit"
	path = /obj/item/clothing/under/permit

//KHI Uniforms
/datum/gear/uniform/job_khi/cmd
	display_name = "kin uniform, cmd"
	path = /obj/item/clothing/under/rank/khi/cmd
	allowed_roles = list("Colony Director","Head of Personnel")

/datum/gear/uniform/job_khi/sec
	display_name = "kin uniform, sec"
	path = /obj/item/clothing/under/rank/khi/sec
	allowed_roles = list("Head of Security", "Warden", "Detective", "Security Officer")

/datum/gear/uniform/job_khi/med
	display_name = "kin uniform, med"
	path = /obj/item/clothing/under/rank/khi/med
	allowed_roles = list("Chief Medical Officer","Medical Doctor","Chemist","Paramedic","Geneticist")

/datum/gear/uniform/job_khi/eng
	display_name = "kin uniform, eng"
	path = /obj/item/clothing/under/rank/khi/eng
	allowed_roles = list("Chief Engineer","Atmospheric Technician","Station Engineer")

/datum/gear/uniform/job_khi/sci
	display_name = "kin uniform, sci"
	path = /obj/item/clothing/under/rank/khi/sci
	allowed_roles = list("Research Director","Scientist", "Roboticist", "Xenobiologist")

//Federation jackets
/datum/gear/suit/job_fed/sec
	display_name = "fed uniform, sec"
	path = /obj/item/clothing/suit/storage/fluff/fedcoat
	allowed_roles = list("Head of Security", "Warden", "Detective", "Security Officer")

/datum/gear/suit/job_fed/medsci
	display_name = "fed uniform, med/sci"
	path = /obj/item/clothing/suit/storage/fluff/fedcoat/fedblue
	allowed_roles = list("Chief Medical Officer","Medical Doctor","Chemist","Paramedic","Geneticist","Research Director","Scientist", "Roboticist", "Xenobiologist")

/datum/gear/suit/job_fed/eng
	display_name = "fed uniform, eng"
	path = /obj/item/clothing/suit/storage/fluff/fedcoat/fedeng
	allowed_roles = list("Chief Engineer","Atmospheric Technician","Station Engineer")
