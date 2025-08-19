/obj/item/endoware/plane_overlay/ar_hud
	name = "Integrated Corneal Display: AR HUD"
	desc = "FSDFSD TODO"

/obj/item/endoware/plane_overlay/ar_hud/proc/redetermine_planes(var/mob/living/carbon/human/human)
	var/list/dict = list(
		DEPARTMENT_COMMAND = list(VIS_CH_ID,VIS_CH_HEALTH_VR,VIS_CH_STATUS_R,VIS_CH_BACKUP,VIS_CH_WANTED,VIS_AUGMENTED),
		DEPARTMENT_SECURITY = list(VIS_CH_ID,VIS_CH_HEALTH_VR,VIS_CH_WANTED,VIS_AUGMENTED),
		DEPARTMENT_ENGINEERING = list(VIS_CH_ID,VIS_CH_HEALTH_VR,VIS_AUGMENTED),
		DEPARTMENT_MEDICAL = list(VIS_CH_ID,VIS_CH_HEALTH_VR,VIS_CH_STATUS_R,VIS_CH_BACKUP,VIS_AUGMENTED),
		DEPARTMENT_RESEARCH = list(VIS_CH_ID,VIS_CH_HEALTH_VR,VIS_AUGMENTED),
		DEPARTMENT_CARGO = list(VIS_CH_ID,VIS_CH_HEALTH_VR,VIS_AUGMENTED),
		DEPARTMENT_CIVILIAN = list(VIS_CH_ID,VIS_CH_HEALTH_VR,VIS_AUGMENTED),
		DEPARTMENT_PLANET = list(VIS_CH_ID,VIS_CH_HEALTH_VR,VIS_AUGMENTED),
		DEPARTMENT_SYNTHETIC = list(VIS_CH_ID,VIS_CH_HEALTH_VR,VIS_CH_WANTED,VIS_AUGMENTED) //not possible afaik but whatever I have all the others already
	)
	var/list/outplanes = list()
	var/list/departments = list(DEPARTMENT_COMMAND, DEPARTMENT_SECURITY, DEPARTMENT_ENGINEERING, DEPARTMENT_MEDICAL, DEPARTMENT_RESEARCH, DEPARTMENT_CARGO, DEPARTMENT_CIVILIAN, DEPARTMENT_PLANET, DEPARTMENT_SYNTHETIC)
	if(!human.mind || !human.mind.assigned_role) //sanity check
		return dict[DEPARTMENT_CIVILIAN]
	for(var/dept in departments)
	//TODO: refactor this. what the fuck. there's a assigned_job datum. it's just never assigned???? why? who?
		if(human.mind.assigned_role in SSjob.get_job_titles_in_department(dept))
			outplanes |= dict[dept]
	planes_to_add = outplanes

/obj/item/endoware/plane_overlay/ar_hud/get_vision_planes()
	if(host)
		redetermine_planes(host)
	.=..()
