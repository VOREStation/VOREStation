/mob/living/silicon/Topic(href, href_list) //For Robots and pAI's. And possibly AI's too.
	if(href_list["ooc_notes"])
		src.Examine_OOC()
		return 1
	return ..()

// For handling any custom visibility in borgo sensor modes, like sleeve implants - not needed anymore but leaving anyways - Tank
///mob/living/silicon/toggle_sensor_mode()
//	. = ..()
//	switch(hudmode) // This is set in parent
//		if ("Security")
//			//Disable Medical planes
//			plane_holder?.set_vis(VIS_CH_BACKUP,FALSE)
//
//		if ("Medical")
//			//Enable Medical planes
//			plane_holder?.set_vis(VIS_CH_BACKUP,TRUE)
//
//		if ("Disable")
//			//Disable Medical planes
//			plane_holder?.set_vis(VIS_CH_BACKUP,FALSE)
