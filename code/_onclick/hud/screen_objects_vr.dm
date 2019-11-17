/obj/screen/proc/Click_vr(location, control, params)
	if(!usr)	return 1
	switch(name)

		//Shadekin
		if("darkness")
			var/turf/T = get_turf(usr)
			var/darkness = round(1 - T.get_lumcount(),0.1)
			to_chat(usr,"<span class='notice'><b>Darkness:</b> [darkness]</span>")
		if("energy")
			var/mob/living/simple_mob/shadekin/SK = usr
			if(istype(SK))
				to_chat(usr,"<span class='notice'><b>Energy:</b> [SK.energy] ([SK.dark_gains])</span>")
			var/mob/living/carbon/human/H = usr
			if(istype(H) && istype(H.species, /datum/species/shadekin))
				to_chat(usr,"<span class='notice'><b>Energy:</b> [H.shadekin_get_energy(H)]</span>")



		else
			return 0

	return 1