///// A mob that gets used when prey dominate predators. Will automatically delete itself if it's not inside a mob.

/mob/living/dominated_brain
	name = "dominated brain"
	desc = "Someone who has taken a back seat within their own body."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "brain1"
	var/mob/living/prey_body		//The body of the person who dominated the brain
	var/prey_ckey					//The ckey of the person who dominated the brain
	var/prey_name					//In case the body is missing. ;3c
	var/mob/living/pred_body		//The body of the person who was dominated
	var/pred_ckey					//The ckey of the person who was dominated

/mob/living/dominated_brain/New(loc, var/mob/living/pred, preyname, var/mob/living/prey)
	. = ..()
	name = pred.name
	prey_name = preyname
	if(prey)
		prey_body = prey
	pred_body = pred

/mob/living/dominated_brain/Initialize()
	if(!isliving(loc))
		qdel(src)
		return
	. = ..()
	lets_register_our_signals()
	verbs += /mob/living/dominated_brain/proc/resist_control


/mob/living/dominated_brain/proc/lets_register_our_signals()
	if(prey_body)
		RegisterSignal(prey_body, COMSIG_PARENT_QDELETING, .proc/prey_was_deleted, TRUE)
	RegisterSignal(pred_body, COMSIG_PARENT_QDELETING, .proc/pred_was_deleted, TRUE)

/mob/living/dominated_brain/proc/lets_unregister_our_signals()
	prey_was_deleted()
	pred_was_deleted()

/mob/living/dominated_brain/proc/prey_was_deleted()
	if(prey_body)
		UnregisterSignal(prey_body, COMSIG_PARENT_QDELETING)
		prey_body = null

/mob/living/dominated_brain/proc/pred_was_deleted()
	if(pred_body)
		UnregisterSignal(pred_body, COMSIG_PARENT_QDELETING)
		pred_body = null

/mob/living/dominated_brain/Destroy()
	lets_unregister_our_signals()
	. = ..()

/mob/living/dominated_brain/say(var/message, var/datum/language/speaking = null, var/whispering = 0)

	if (src.client)
		if(client.prefs.muted & MUTE_IC)
			to_chat(src, "<font color='red'>You cannot speak in IC (muted).</font>")
			return

	if(loc == pred_body)

		message = sanitize(message)
		if (!message)
			return
		log_say(message,src)
		if (stat == 2)
			return say_dead(message)

		to_chat(src, "<span class='changeling'>You think, \"[message]\"</span>")
		to_chat(pred_body, "<span class='changeling'>The captive mind of \the [src] thinks, \"[message]\"</span>")
		for(var/I in pred_body.contents)
			if(istype(I, /mob/living/dominated_brain) && I != src)
				var/mob/living/dominated_brain/db
				to_chat(db, "<span class='changeling'>The captive mind of \the [src] thinks, \"[message]\"</span>")

		for (var/mob/M in player_list)
			if (istype(M, /mob/new_player))
				continue
			else if(M.stat == DEAD && M.is_preference_enabled(/datum/client_preference/ghost_ears))
				to_chat(M, "The captive mind of [src] whispers, \"[message]\"")

/mob/living/dominated_brain/me_verb(message as text)
	if (src.client)
		if(client.prefs.muted & MUTE_IC)
			to_chat(src, "<span class='warning'>You cannot speak in IC (muted).</span>")
			return

	if(loc == pred_body)

		message = sanitize(message)
		if (!message)
			return
		log_emote(message,src)
		if (stat == 2)
			return say_dead(message)

		to_chat(src, "<span class='changeling'><i>\The [src] [message]</i></span>")
		to_chat(pred_body, "<span class='changeling'><i>\The [src] [message]</i></span>")
		for(var/I in pred_body.contents)
			if(istype(I, /mob/living/dominated_brain) && I != src)
				var/mob/living/dominated_brain/db
				to_chat(db, "<span class='changeling'><i>\The [src] [message]</i></span>")

		for (var/mob/M in player_list)
			if (istype(M, /mob/new_player))
				continue
			else if(M.stat == DEAD && M.is_preference_enabled(/datum/client_preference/ghost_ears))
				to_chat(M, "<span class='changeling'><i>\The [src] [message]</i></span>")
	return

/mob/living/dominated_brain/emote(var/message)
	if (src.client)
		if(client.prefs.muted & MUTE_IC)
			to_chat(src, "<span class='warning'>You cannot speak in IC (muted).</span>")
			return

	if(loc == pred_body)

		message = sanitize(message)
		if (!message)
			return
		log_emote(message,src)
		if (stat == 2)
			return say_dead(message)

		to_chat(src, "<span class='changeling'><i>\The [src] [message]</i></span>")
		to_chat(pred_body, "<span class='changeling'><i>\The [src] [message]</i></span>")
		for(var/I in pred_body.contents)
			if(istype(I, /mob/living/dominated_brain) && I != src)
				var/mob/living/dominated_brain/db
				to_chat(db, "<span class='changeling'><i>\The [src] [message]</i></span>")

		for (var/mob/M in player_list)
			if (istype(M, /mob/new_player))
				continue
			else if(M.stat == DEAD && M.is_preference_enabled(/datum/client_preference/ghost_ears))
				to_chat(M, "<span class='changeling'><i>\The [src] [message]</i></span>")
	return

/mob/living/dominated_brain/process_resist()
	//Resisting control by an alien mind.
	if(pred_body.ckey == pred_ckey)
		dominate_predator()		
		return
	if(tgui_alert(src, "Do you want to wrest control over your body back from \the [prey_name]?", "Regain Control",list("No","Yes")) != "Yes")
		return

	to_chat(src, "<span class='danger'>You begin to resist \the [prey_name]'s control!!!</span>")
	to_chat(pred_body, "<span class='danger'>You feel the captive mind of [src] begin to resist your control.</span>")

	if(do_after(src, 10 SECONDS, exclusive = TRUE))
		restore_control()
	else
		to_chat(src, "<span class='notice'>Your attempt to regain control has been interrupted...</span>")
		to_chat(pred_body, "<span class='notice'>The dominant sensation fades away...</span>")
	..()

/mob/living/dominated_brain/proc/restore_control(ask = TRUE)

	if(ask && disconnect_time || client && ((client.inactivity / 10) / 60 > 10))
		if(tgui_alert(src, "Your predator's mind does not seem to be active presently. Releasing control in this state may leave you stuck in whatever state you find yourself in. Are you sure?", "Release Control",list("No","Yes")) != "Yes")
			return
	var/pred_id = src.computer_id
	var/pred_ip = src.lastKnownIP
	var/prey_id = pred_body.computer_id
	var/prey_ip = pred_body.lastKnownIP
	var/mob/living/prey_goes_here

	if(prey_body && prey_body.loc.loc == pred_body)	//The prey body exists and is here, let's handle the prey!

		prey_goes_here = prey_body
		pred_body.verbs -= /mob/living/proc/psay
		pred_body.verbs -= /mob/living/proc/pme

		src.computer_id = null
		src.lastKnownIP = null

	else if(prey_body)	//It exists, but it's not here, let's spawn them a temporary home.
		var/mob/living/dominated_brain/ndb = new /mob/living/dominated_brain(pred_body, pred_body, prey_name, prey_body)
		ndb.prey_ckey = src.prey_ckey
		ndb.pred_ckey = src.pred_ckey
		ndb.handle_langs()

		prey_goes_here = ndb

	else		//The prey body does not exist, let's put them in the back seat instead!
		var/mob/living/dominated_brain/ndb = new /mob/living/dominated_brain(pred_body, pred_body, prey_name)
		ndb.prey_ckey = src.prey_ckey
		ndb.pred_ckey = src.pred_ckey
		ndb.handle_langs()
	
		prey_goes_here = ndb
	
	///////////////////
	if(!prey_goes_here.computer_id)
		prey_goes_here.computer_id = prey_id

	if(!prey_goes_here.lastKnownIP)
		prey_goes_here.lastKnownIP = prey_ip


	// Handle Pred
	pred_body.verbs -= /mob/living/proc/release_predator

	pred_body.computer_id = null
	pred_body.lastKnownIP = null
	

	if(!pred_body.computer_id)
		pred_body.computer_id = pred_id

	if(!pred_body.lastKnownIP)
		pred_body.lastKnownIP = pred_ip

	//Now actually put the people in the mobs
	log_and_message_admins("I am going to try to set [prey_goes_here] ckey to [prey_ckey] and [pred_body] ckey to [pred_ckey]")
	prey_goes_here.ckey = src.prey_ckey
	pred_body.ckey = src.pred_ckey
	log_and_message_admins("I set [prey_goes_here] ckey to [prey_goes_here.ckey] and [pred_body] ckey to [pred_body.ckey]")
	log_and_message_admins("I'n deleting [src]. They have [ckey] for a ckey")
	qdel(src)

/mob/living/dominated_brain/proc/handle_langs()
	var/list/addlangs = list()
	var/list/thinglist = list()
	thinglist += pred_body
	for(var/i in loc)
		if(istype(i,/mob/living/dominated_brain))
			thinglist += i
	for(var/mob/living/p in thinglist)
		for(var/L in p.languages)
			if(L in p.temp_languages)
				p.languages -= L
				p.temp_languages -= L
			else
				addlangs += L
	for(var/mob/living/p in thinglist)
		for(var/L in addlangs)
			if(L in p.languages)
				continue
			else
				p.temp_languages += L
				p.languages += L

//Welcome to the adapted borer code.
/mob/living/proc/dominate_predator()
	set category = "Abilities"
	set name = "Dominate Predator"
	set desc = "Connect to and dominate the brain of your predator."

	var/mob/living/pred

	if(isbelly(src.loc))
		pred = loc.loc
	else if(isliving(src.loc))
		pred = loc
	else
		to_chat(src, "<span class='notice'>You are not inside anyone.</span>")
		return

	if(src.stat == DEAD)
		to_chat(src, "<span class='warning'>You cannot do that in your current state.</span>")
		return

	if(!pred.ckey)
		to_chat(src, "<span class='notice'>\The [pred] isn't able to be dominated.</span>")
		return

	for(var/mob/living/dominated_brain/L in pred.contents)
		if(istype(L, /mob/living/dominated_brain))
			if(L.pred_ckey != pred.ckey)
				to_chat(src, "<span class='warning'>\The [pred] is already dominated, and cannot be controlled at this time.</span>")
				return

	if(tgui_alert(src, "You are attempting to take over [pred], are you sure? Ensure that their preferences align with this kind of play.", "Take Over Predator",list("No","Yes")) != "Yes")
		return
	to_chat(src, "<span class='notice'>You attempt to exert your control over \the [pred]...</span>")
	log_admin("[key_name_admin(src)] attempted to take over [pred].")
	if(tgui_alert(pred, "\The [src] has elected to attempt to take control of you. Is this something you will allow to happen?", "Allow Prey Domination",list("No","Yes")) != "Yes")
		to_chat(src, "<span class='warning'>\The [pred] declined your request for control.</span>")
		return
	if(tgui_alert(pred, "Are you sure? If you should decide to revoke this, you will have the ability to do so in your 'Abilities' tab.", "Allow Prey Domination",list("No","Yes")) != "Yes")
		return
	to_chat(pred, "<span class='warning'>You can feel the will of another overwriting your own, control of your body being sapped away from you...</span>")
	to_chat(src, "<span class='warning'>You can feel the will of your host diminishing as you exert your will over them!</span>")
	if(!do_after(src, 10 SECONDS, exclusive = TRUE))
		to_chat(src, "<span class='notice'>Your attempt to regain control has been interrupted...</span>")
		to_chat(pred_body, "<span class='notice'>The dominant sensation fades away...</span>")
		return

	to_chat(src, "<span class='danger'>You plunge your conciousness into \the [pred], assuming control over their very body, leaving your own behind within \the [pred]'s [loc].</span>")
	to_chat(pred, "<span class='danger'>You feel your body move on its own, as you are pushed to the background, and an alien consciousness displaces yours.</span>")
	var/mob/living/dominated_brain/pred_brain
	if(istype(src, /mob/living/dominated_brain))
		pred_brain = new /mob/living/dominated_brain(pred, pred, name)	//We have to play musical chairs with 3 bodies, or everyone gets d/ced
	else
		pred_brain = new /mob/living/dominated_brain(pred, pred, name, src)
	
	pred_brain.prey_ckey = src.ckey
	pred_brain.pred_ckey = pred.ckey
	pred_brain.handle_langs()

	// pred -> brain
	var/pred_id = pred.computer_id
	var/pred_ip = pred.lastKnownIP
	pred.computer_id = null
	pred.lastKnownIP = null

	if(!pred_brain.computer_id)
		pred_brain.computer_id = pred_id

	if(!pred_brain.lastKnownIP)
		pred_brain.lastKnownIP = pred_ip

	// prey -> pred
	
	var/prey_id = src.computer_id
	var/prey_ip = src.lastKnownIP
	src.computer_id = null
	src.lastKnownIP = null
	
	if(!pred.computer_id)
		pred.computer_id = prey_id

	if(!pred.lastKnownIP)
		pred.lastKnownIP = prey_ip

	pred.verbs += /mob/living/proc/release_predator
	pred.verbs += /mob/living/proc/psay
	pred.verbs += /mob/living/proc/pme

	//Now actually put the people in the mobs
	pred_brain.ckey = pred_brain.pred_ckey
	pred.ckey = pred_brain.prey_ckey

/mob/living/proc/release_predator()
	set category = "Abilities"
	set name = "Restore Control"
	set desc = "Release control of your predator's body."

	for(var/I in contents)
		if(istype(I, /mob/living/dominated_brain))
			var/mob/living/dominated_brain/db = I
			db.restore_control()
			return
	to_chat(src, "<span class='danger'>You haven't been taken over, and shouldn't have this verb. I'll clean that up for you. Report this on the github, it is a bug.</span>")
	verbs -= /mob/living/proc/release_predator

/mob/living/dominated_brain/proc/resist_control()
	set category = "Abilities"
	set name = "Resist Control"
	set desc = "Attempt to resist control."
	log_and_message_admins("I am going to try to process the resist verb. I have [pred_body]'s ckey as [pred_body.ckey] and [pred_ckey] as the pred's ckey.")
	if(pred_body.ckey == pred_ckey)
		log_and_message_admins("I think the pred is in control of their own body so I'll just run dominate_predator instead of restore_control.")
		dominate_predator()		
		return
	log_and_message_admins("I am going to run restore_control, as [pred_body.ckey] is not the same as [pred_ckey]")
	to_chat(src, "<span class='danger'>You begin to resist \the [prey_name]'s control!!!</span>")
	to_chat(pred_body, "<span class='danger'>You feel the captive mind of [src] begin to resist your control.</span>")

	if(do_after(src, 10 SECONDS, exclusive = TRUE))
		restore_control()
	else
		to_chat(src, "<span class='notice'>Your attempt to regain control has been interrupted...</span>")
		to_chat(pred_body, "<span class='notice'>The dominant sensation fades away...</span>")

/mob/living/proc/psay(message as text|null)
	set category = "Abilities"
	set name = "Prey Say (psay)"
	set desc = "Emote to a dominated predator/prey."

	if (src.client)
		if(client.prefs.muted & MUTE_IC)
			to_chat(src, "<span class='warning'>You cannot speak in IC (muted).</span>")
			return
	message = sanitize(message)
	if (!message)
		message = input(usr, "Type a message to emote.","Emote to prey") as text|null
	if (!message)
		return		

	var/f = FALSE
	for(var/I in contents)
		if(istype(I, /mob/living/dominated_brain))
			var/mob/living/dominated_brain/db = I
			to_chat(db, "<span class='changeling'>\The [src] thinks, \"[message]\"</span>")
			f = TRUE
	if(f)
		to_chat(src, "<span class='changeling'>You think \"[message]\"</span>")
		for (var/mob/M in player_list)
			if (istype(M, /mob/new_player))
				continue
			else if(M.stat == DEAD && M.is_preference_enabled(/datum/client_preference/ghost_ears))
				to_chat(M, "<span class='changeling'>\The [src] thinks, \"[message]\"</span>")
		log_say(message,src)
	else
		to_chat(src, "<span class='warning'>There is no one inside you to talk to...</span>")
	return

/mob/living/proc/pme(message as text|null)
	set category = "Abilities"
	set name = "Prey Emote (pme)"
	set desc = "Emote to a dominated predator/prey."

	if (src.client)
		if(client.prefs.muted & MUTE_IC)
			to_chat(src, "<span class='warning'>You cannot speak in IC (muted).</span>")
			return
	message = sanitize(message)
	if (!message)
		message = input(usr, "Type a message to emote.","Emote to prey") as text|null
	if (!message)
		return		
	var/f = FALSE
	for(var/I in contents)
		if(istype(I, /mob/living/dominated_brain))
			var/mob/living/dominated_brain/db = I
			to_chat(db, "<span class='changeling'><i>\The [src] [message]</i></span>")
			f = TRUE
	if(f)
		to_chat(src, "<span class='changeling'><i>\The [src] [message]</i></span>")
		for (var/mob/M in player_list)
			if (istype(M, /mob/new_player))
				continue
			else if(M.stat == DEAD && M.is_preference_enabled(/datum/client_preference/ghost_ears))
				to_chat(M, "<span class='changeling'><i>\The [src] [message]</i></span>")
		log_emote(message,src)
	else
		to_chat(src, "<span class='warning'>There is no one inside you to talk to...</span>")
	return