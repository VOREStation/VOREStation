/datum/gear/utility/saddlebag
	display_name = "saddle bag, horse"
	path = /obj/item/storage/backpack/saddlebag
	slot = slot_back
	cost = 2

/datum/gear/utility/saddlebag_common
	display_name = "saddle bag, common"
	path = /obj/item/storage/backpack/saddlebag_common
	slot = slot_back
	cost = 2

/datum/gear/utility/saddlebag_common/robust
	display_name = "saddle bag, robust"
	path = /obj/item/storage/backpack/saddlebag_common/robust
	slot = slot_back
	cost = 2

/datum/gear/utility/saddlebag_common/vest
	display_name = "taur duty vest (backpack)"
	path = /obj/item/storage/backpack/saddlebag_common/vest
	slot = slot_back
	cost = 1

/datum/gear/utility/dufflebag
	display_name = "dufflebag"
	path = /obj/item/storage/backpack/dufflebag
	slot = slot_back
	cost = 2

/datum/gear/utility/dufflebag/black
	display_name = "black dufflebag"
	path = /obj/item/storage/backpack/dufflebag/fluff

/datum/gear/utility/dufflebag/med
	display_name = "medical dufflebag"
	path = /obj/item/storage/backpack/dufflebag/med
	allowed_roles = list(JOB_MEDICAL_DOCTOR,JOB_CHIEF_MEDICAL_OFFICER,JOB_CHEMIST,JOB_PARAMEDIC,JOB_GENETICIST,JOB_PSYCHIATRIST)

/datum/gear/utility/dufflebag/med/emt
	display_name = "EMT dufflebag"
	path = /obj/item/storage/backpack/dufflebag/emt

/datum/gear/utility/dufflebag/sec
	display_name = "security Dufflebag"
	allowed_roles = list(JOB_HEAD_OF_SECURITY,JOB_WARDEN,JOB_DETECTIVE,JOB_SECURITY_OFFICER)
	path = /obj/item/storage/backpack/dufflebag/sec

/datum/gear/utility/dufflebag/eng
	display_name = "engineering dufflebag"
	allowed_roles = list(JOB_CHIEF_ENGINEER,JOB_ATMOSPHERIC_TECHNICIAN,JOB_ENGINEER)
	path = /obj/item/storage/backpack/dufflebag/eng

/datum/gear/utility/dufflebag/sci
	display_name = "science dufflebag"
	allowed_roles = list(JOB_RESEARCH_DIRECTOR,JOB_SCIENTIST,JOB_ROBOTICIST,JOB_XENOBIOLOGIST,JOB_XENOBOTANIST)
	path = /obj/item/storage/backpack/dufflebag/sci

/datum/gear/utility/dufflebag/explorer
	display_name = "away team dufflebag"
	path = /obj/item/storage/backpack/dufflebag/explorer

/datum/gear/utility/dufflebag/talon
	display_name = "Talon dufflebag"
	path = /obj/item/storage/backpack/dufflebag/explorer

/datum/gear/utility/ID
	display_name = "contractor identification card"
	path = /obj/item/card/id/event/polymorphic/altcard
	cost = 1

/datum/gear/utility/bs_bracelet
	display_name = "bluespace bracelet"
	path = /obj/item/clothing/gloves/bluespace
	cost = 2

/datum/gear/utility/walkpod
	display_name = "podzu music player"
	path = /obj/item/walkpod
	cost = 2
