/datum/gear/eyes/medical
	allowed_roles = list("Medical Doctor","Chief Medical Officer","Chemist","Paramedic","Geneticist", "Psychiatrist")

/datum/gear/eyes/arglasses
	display_name = "AR glasses"
	path = /obj/item/clothing/glasses/omnihud

/datum/gear/eyes/arglasses/visor
	display_name = "AR visor"
	path = /obj/item/clothing/glasses/omnihud/visor

/datum/gear/eyes/arglasses/visor/New()
	..()
	gear_tweaks = list(gear_tweak_free_color_choice)
/datum/gear/eyes/arglassespres
	display_name = "AR glasses, prescription"
	path = /obj/item/clothing/glasses/omnihud/prescription

/datum/gear/eyes/arglasses/sec
	display_name = "AR-Security glasses"
	path = /obj/item/clothing/glasses/omnihud/sec
	allowed_roles = list(JOB_SECURITY_OFFICER,JOB_HEAD_OF_SECURITY,JOB_WARDEN,JOB_DETECTIVE)

/datum/gear/eyes/arglasses/sci
	display_name = "AR-Research glasses"
	path = /obj/item/clothing/glasses/omnihud/rnd
	allowed_roles = list(JOB_RESEARCH_DIRECTOR,"Scientist","Xenobiologist","Xenobotanist","Roboticist")

/datum/gear/eyes/arglasses/eng
	display_name = "AR-Engineering glasses"
	path = /obj/item/clothing/glasses/omnihud/eng
	allowed_roles = list(JOB_ENGINEER,JOB_CHIEF_ENGINEER,JOB_ATMOSPHERIC_TECHNICIAN)

/datum/gear/eyes/arglasses/med
	display_name = "AR-Medical glasses"
	path = /obj/item/clothing/glasses/omnihud/med
	allowed_roles = list("Medical Doctor","Chief Medical Officer","Chemist","Paramedic","Geneticist", "Psychiatrist")

/datum/gear/eyes/arglasses/all
	display_name = "AR-Command glasses"
	path = /obj/item/clothing/glasses/omnihud/all
	cost = 2
	allowed_roles = list(JOB_SITE_MANAGER,JOB_HEAD_OF_PERSONNEL)

/datum/gear/eyes/spiffygogs
	display_name = "slick orange goggles"
	path = /obj/item/clothing/glasses/fluff/spiffygogs

/datum/gear/eyes/science_proper
	display_name = "science goggles (no overlay)"
	path = /obj/item/clothing/glasses/fluff/science_proper

/datum/gear/eyes/bigshot
	display_name = "Big Shot's Glasses"
	path = /obj/item/clothing/glasses/sunglasses/bigshot
