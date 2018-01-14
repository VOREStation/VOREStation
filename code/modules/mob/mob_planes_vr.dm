/datum/plane_holder/New(mob/this_guy)
	..()
	plane_masters[VIS_CH_STATUS_R] 		= new /obj/screen/plane_master{plane = PLANE_CH_STATUS_R}			//Right-side status icon
	plane_masters[VIS_CH_HEALTH_VR] 	= new /obj/screen/plane_master{plane = PLANE_CH_HEALTH_VR}			//Health bar but transparent at 100
	plane_masters[VIS_CH_BACKUP] 		= new /obj/screen/plane_master{plane = PLANE_CH_BACKUP}				//Backup implant status
	plane_masters[VIS_CH_VANTAG] 		= new /obj/screen/plane_master{plane = PLANE_CH_VANTAG}				//Vore Antags