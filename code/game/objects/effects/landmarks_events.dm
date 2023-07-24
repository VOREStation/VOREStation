/*
Landmark to be spawned by GMs and admins when running events.
Do NOT directly spawn "" or buildmode spawn this.
Use the "Manage Event Triggers" verb under "Eventkit" category.
Admin verb is called by code\modules\admin\verbs\event_triggers.dm
*/
/obj/effect/landmark/event_trigger
	name = "ONLY FOR EVENTS. DO NOT USE WHEN MAPPING"
	desc = "Please notify staff if you see this!"
	var/creator_ckey = ""
	var/isTeamwork = FALSE //Whether to notify creator or whole team.
	var/isRepeating = FALSE
	var/coordinates = ""
	var/cooldown = 0 //in seconds
	var/last_trigger = 0
	var/isLoud = FALSE
	var/isNarrate = FALSE

/obj/effect/landmark/event_trigger/New()
	..()
	coordinates = "(X:[loc.x];Y:[loc.y];Z:[loc.z])"
	invisibility = 100

/obj/effect/landmark/event_trigger/proc/set_vars(mob/M)
	name = sanitize(tgui_input_text(M, "Input Name for the trigger", "Naming", "Event Trigger"))
	creator_ckey = M.ckey
	if(!event_triggers[creator_ckey])
		event_triggers[creator_ckey] = list()
	event_triggers[creator_ckey] |= list(src)
	isTeamwork = (tgui_alert(M, "Notify rest of team?", "Teamwork", list("No", "Yes")) == "Yes" ? TRUE : FALSE)
	if(!isTeamwork)
		isLoud = (tgui_alert(M, "Should it make a bwoink when triggered for YOU?", "bwoink", list("No", "Yes")) == "Yes" ? TRUE : FALSE)
	isRepeating = (tgui_alert(M, "Make it fire repeatedly?", "Repetition", list("No", "Yes")) == "Yes" ? TRUE : FALSE)
	if(isRepeating)
		cooldown = tgui_input_number(M, "Set cooldown in seconds. Minimum 5 seconds!", "Cooldown", 60, min_value = 5)
		cooldown = cooldown SECONDS
	else
		delete_me = TRUE
	log_admin("[M.ckey] has created a [isNarrate ? "Narrtion" : "Notification"] landmark trigger at [coordinates]")

/obj/effect/landmark/event_trigger/Destroy()
	if(event_triggers[creator_ckey])
		event_triggers[creator_ckey] -= src
	..()

/obj/effect/landmark/event_trigger/Crossed(var/atom/movable/AM)
	if(isobserver(AM) || !isliving(AM))
		return FALSE
	var/mob/living/L = AM
	if(!L.ckey) return FALSE

	if(world.time < (last_trigger + cooldown))
		return FALSE
	if(!isRepeating && last_trigger) //Used to avoid spam if qdel(src) fires too slowly
		return FALSE
	last_trigger = world.time

	if(!creator_ckey)	//For some reason, the user didn't have a ckey. Let's clean up
		qdel(src)
		return FALSE
	var/mob/creator_reference = GLOB.directory[creator_ckey]
	if(!creator_reference || isTeamwork)	//If logged/crashed, we default to teamwork mode
		message_admins("Player [L.name] ([L.ckey]) has triggered event narrate landmark [name] of type \
			[isNarrate ? "Narration" : "Notification"]. \n \
			The landmark was created by [creator_ckey], and it [isRepeating ? \
			"will be possible to trigger after [cooldown / (1 SECOND)] seconds" : "has self-deleted"]\n \
			COORDINATES: [coordinates]")
	else
		if(isLoud)
			creator_reference << 'sound/effects/adminhelp.ogg'
		to_chat(creator_reference, SPAN_WARNING("Player [L.name] ([L.ckey]) has triggered event \
			narrate landmark [name] of type [isNarrate ? "Narration" : "Notification"]. \n \
			It [isRepeating ? "will be possible to trigger after [cooldown / (1 SECOND)] seconds" : "has self-deleted"] \n \
			COORDINATES: [coordinates]"))
	if(!isNarrate)
		if(!isRepeating)
			qdel(src)
		return FALSE
	else
		return L


/obj/effect/landmark/event_trigger/auto_narrate
	var/message
	var/isVis_or_isAud = 0	//0 for vis, 1 for aud
	var/message_range	//Leave at 0 for world.view
	var/isPersonal = FALSE	//Overrides isVis/isAud, to_chats the player
	var/isWarning = FALSE 	//For personal messages
	isNarrate = TRUE

/obj/effect/landmark/event_trigger/auto_narrate/New()
	message_range = world.view
	..()

/obj/effect/landmark/event_trigger/auto_narrate/set_vars(mob/M)
	..()
	message = encode_html_emphasis(sanitize(tgui_input_text(M, "What should the automatic narration say?", "Message"), encode = FALSE))
	isPersonal = (tgui_alert(M, "Should it send directly to the player, or send to the turf?", "Target", list("Player", "Turf")) == "Player" ? TRUE : FALSE)
	if(isPersonal)
		isWarning = (tgui_alert(M, "Should it be a normal message or a big scary red text?", "Scary Red", list("Big Red", "Normal")) == "Big Red" ? TRUE : FALSE)
	else
		isVis_or_isAud = (tgui_alert(M, "Should it be visible or audible?", "Mode", list("Visible", "Audible")) == "Audible" ? 1 : 0)
		var/range = tgui_input_number(M, "Give narration range! Input value over 10 to use world.view", "Range",default = 11, min_value = 0)
		if(range <= 10)
			message_range = range





/obj/effect/landmark/event_trigger/auto_narrate/Crossed(var/atom/movable/AM)
	. = ..()	//Checks if AM is mob/living and notifies admin(s)
	if(!.)
		return
	var/mob/living/L = .
	if(isPersonal)
		if(isWarning)
			to_chat(L, SPAN_DANGER(message))
		else
			to_chat(L, message)
	else
		var/turf/T = get_turf(src)
		switch(isVis_or_isAud)
			if(0)
				T.visible_message(message, range = message_range, runemessage = message)
			if(1)
				T.audible_message(message, hearing_distance = message_range, runemessage= message)
	if(!isRepeating)
		qdel(src)
