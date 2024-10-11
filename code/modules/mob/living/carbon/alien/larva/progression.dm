/mob/living/carbon/alien/larva/get_status_tab_items() //Specified where progression stats come from, because for some reason it doesn't work right in carbon/alien
	. = ..()
	if(.)
		. += ""
		. += "Larva Growth: [round(amount_grown)]/[max_grown]"

/mob/living/carbon/alien/larva/confirm_evolution()

	to_chat(src, span_notice("<b>You are growing into a beautiful alien! It is time to choose a caste.</b>"))
	to_chat(src, span_notice("There are three to choose from:"))
	to_chat(src, "<B>Hunters</B> <span class='notice'> are strong and agile, able to hunt away from the hive and rapidly move through ventilation shafts. Hunters generate plasma slowly and have low reserves.</span>")
	to_chat(src, "<B>Sentinels</B> <span class='notice'> are tasked with protecting the hive and are deadly up close and at a range. They are not as physically imposing nor fast as the hunters.</span>")
	to_chat(src, "<B>Drones</B> <span class='notice'> are the working class, offering the largest plasma storage and generation. They are the only caste which may evolve again, turning into the dreaded alien queen.</span>")
	var/alien_caste = tgui_alert(src, "Please choose which alien caste you shall belong to.","Alien Choice",list("Hunter","Sentinel","Drone"))
	return alien_caste ? "Xenomorph [alien_caste]" : null

/mob/living/carbon/alien/larva/show_evolution_blurb()
	return
