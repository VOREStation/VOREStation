/datum/plane_holder/New(mob/this_guy)
	my_mob = this_guy
	plane_masters[VIS_CH_STATUS_R] 		= new /obj/screen/plane_master{plane = PLANE_CH_STATUS_R}			//Right-side status icon
	plane_masters[VIS_CH_HEALTH_VR] 	= new /obj/screen/plane_master{plane = PLANE_CH_HEALTH_VR}			//Health bar but transparent at 100
	plane_masters[VIS_CH_BACKUP] 		= new /obj/screen/plane_master{plane = PLANE_CH_BACKUP}				//Backup implant status
	plane_masters[VIS_CH_VANTAG] 		= new /obj/screen/plane_master{plane = PLANE_CH_VANTAG}				//Vore Antags
	plane_masters[VIS_CH_STOMACH] 		= new /obj/screen/plane_master{plane = PLANE_CH_STOMACH}				//Stomach
	plane_masters[VIS_SOULCATCHER] 		= new /obj/screen/plane_master{plane = PLANE_SOULCATCHER}				// Soulcatcher

	plane_masters[VIS_AUGMENTED]		= new /obj/screen/plane_master/augmented(M = my_mob)				//Augmented reality
	..()

/////////////////
//AR planemaster does some special image handling
/obj/screen/plane_master/augmented
	plane = PLANE_AUGMENTED
	var/state = FALSE //Saves cost with the lists
	var/mob/my_mob

/obj/screen/plane_master/augmented/New(null, var/mob/M)
	..()
	my_mob = M

/obj/screen/plane_master/augmented/Destroy()
	entopic_users -= my_mob
	my_mob = null
	. = ..()

/obj/screen/plane_master/augmented/set_visibility(var/want = FALSE)
	. = ..()
	state = want
	apply()

/obj/screen/plane_master/augmented/proc/apply()
	if(!my_mob.client)
		return

	if(state)
		entopic_users |= my_mob
		if(my_mob.client)
			my_mob.client.images |= entopic_images
	else
		entopic_users -= my_mob
		if(my_mob.client)
			my_mob.client.images -= entopic_images

/mob/Destroy()
	. = ..()
	entopic_users -= src
