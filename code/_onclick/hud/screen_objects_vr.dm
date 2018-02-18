/obj/screen/proc/Click_vr(location, control, params)
	if(!usr)	return 1
	switch(name)

		//Shadekin
		if("darkness")
			var/mob/living/simple_animal/shadekin/sk = usr
			var/turf/T = get_turf(sk)
			var/darkness = round(1 - T.get_lumcount(),0.1)
			to_chat(usr,"<span class='notice'><b>Darkness:</b> [darkness]</span>")
		if("energy")
			var/mob/living/simple_animal/shadekin/sk = usr
			to_chat(usr,"<span class='notice'><b>Energy:</b> [sk.energy] ([sk.dark_gains])</span>")



		else
			return 0

	return 1