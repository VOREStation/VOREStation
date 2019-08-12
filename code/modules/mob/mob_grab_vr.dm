//TFF 12/8/19 - Port ChompStation facesitting
/obj/item/weapon/grab/handle_eye_mouth_covering(mob/living/carbon/target, mob/user, var/target_zone)
	var/announce = (target_zone != last_hit_zone) //only display messages when switching between different target zones
	last_hit_zone = target_zone

	switch(target_zone)
		if(BP_HEAD)
			if(force_down)
				if(announce)
					assailant.visible_message("<span class='warning'>[assailant] moves their ass to [target]'s head, sitting down on them, making them unable to see anything else than [assailant]'s butt!</span>")
				if(target.silent < 3)
					target.silent = 3
				if(target.eye_blind < 3)
					target.Blind(3)