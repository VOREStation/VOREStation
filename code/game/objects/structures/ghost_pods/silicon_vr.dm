/obj/structure/ghost_pod/manual/lost_drone/dogborg
	remains_active = TRUE

/obj/structure/ghost_pod/manual/lost_drone/dogborg/create_occupant(var/mob/M)
	var/response = alert(M, "What type of lost drone are you? Do note, that dogborgs may have experienced different type of corruption ((High potential for having vore-related laws))", "Drone Type", "Regular", "Dogborg")
	if(!(response == "Dogborg"))	// No response somehow or Regular
		return ..()
	else
		density = FALSE
		var/mob/living/silicon/robot/stray/randomlaws/R = new(get_turf(src))
		R.adjustBruteLoss(rand(5, 30))
		R.adjustFireLoss(rand(5, 10))
		if(M.mind)
			M.mind.transfer_to(R)
		// Put this text here before ckey change so that their laws are shown below it, since borg login() shows it.
		to_chat(M, "<span class='notice'>You are a <b>Stray Drone</b>, discovered inside the wreckage of your previous home. \
		Something has reactivated you, with their intentions unknown to you, and yours unknown to them. They are a foreign entity, \
		however they did free you from your pod...</span>")
		to_chat(M, "<span class='notice'><b>Be sure to examine your currently loaded lawset closely.</b>  Remember, your \
		definiton of 'the station' is where your pod is, and unless your laws say otherwise, the entity that released you \
		from the pod is not a crewmember.</span>")
		R.ckey = M.ckey
		visible_message("<span class='warning'>As \the [src] opens, the eyes of the robot flicker as it is activated.</span>")
		R.Namepick()
		log_and_message_admins("successfully opened \a [src] and got a Stray Drone.")
		used = TRUE
		return TRUE