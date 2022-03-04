///// A mob that gets used when prey dominate predators. Will automatically delete itself if it's not inside a mob.

/mob/living/dominated_brain
    name = "dominated brain"
    desc = "Someone who has taken a back seat within their own body."
    icon = 'icons/obj/surgery.dmi'
	icon_state = "brain1"
    var/original_body       //The body this brain originally belongs to
    var/dominating_body     //The body that dominated this brain
    var/original_ckey
    var/dominating_ckey

/mob/living/dominated_brain/New(loc, var/mob/living/prey, var/mob/living/pred)
    . = ..()
    name = pred.name
    original_body = pred
    dominating_body = prey
    original_ckey = pred.ckey
    dominating_ckey = prey.ckey

/mob/living/dominated_brain/Initialize()
	if(!isliving(loc))
        qdel(src)
        return
    . = ..()
	RegisterSignal(original_body, COMSIG_PARENT_QDELETING, .proc/ob_was_deleted, TRUE)
	RegisterSignal(dominating_body, COMSIG_PARENT_QDELETING, .proc/db_was_deleted, TRUE)

/mob/living/dominated_brain/proc/ob_was_deleted()
    if(original_body)
	    UnregisterSignal(original_body, COMSIG_PARENT_QDELETING)
	    original_body = null

/mob/living/dominated_brain/proc/db_was_deleted()
    if(dominating_body)
	    UnregisterSignal(dominating_body, COMSIG_PARENT_QDELETING)
	    dominating_body = null

/mob/living/dominated_brain/Destroy()
    ob_was_deleted()
    db_was_deleted()
    . = ..()

/mob/living/captive_brain/say(var/message, var/datum/language/speaking = null, var/whispering = 0)

	if (src.client)
		if(client.prefs.muted & MUTE_IC)
			to_chat(src, "<font color='red'>You cannot speak in IC (muted).</font>")
			return

	if(loc = original_body)

		message = sanitize(message)
		if (!message)
			return
		log_say(message,src)
		if (stat == 2)
			return say_dead(message)

		var/mob/living/simple_mob/animal/borer/B = src.loc
		to_chat(src, "You whisper silently, \"[message]\"")
		to_chat(B.host, "The captive mind of [src] whispers, \"[message]\"")

		for (var/mob/M in player_list)
			if (istype(M, /mob/new_player))
				continue
			else if(M.stat == DEAD && M.is_preference_enabled(/datum/client_preference/ghost_ears))
				to_chat(M, "The captive mind of [src] whispers, \"[message]\"")

/mob/living/captive_brain/me_verb(message as text)
	if (src.client)
		if(client.prefs.muted & MUTE_IC)
			to_chat(src, "<font color='red'>You cannot speak in IC (muted).</font>")
			return

	to_chat(src, "<span class='danger'>You cannot emote as a captive mind.</span>")
	return

/mob/living/captive_brain/emote(var/message)
	if (src.client)
		if(client.prefs.muted & MUTE_IC)
			to_chat(src, "<font color='red'>You cannot speak in IC (muted).</font>")
			return

	to_chat(src, "<span class='danger'>You cannot emote as a captive mind.</span>")
	return

/mob/living/captive_brain/process_resist()
	//Resisting control by an alien mind.
	if(istype(src.loc, /mob/living/simple_mob/animal/borer))
		var/mob/living/simple_mob/animal/borer/B = src.loc
		var/mob/living/captive_brain/H = src

		to_chat(H, "<span class='danger'>You begin doggedly resisting the parasite's control (this will take approximately sixty seconds).</span>")
		to_chat(B.host, "<span class='danger'>You feel the captive mind of [src] begin to resist your control.</span>")

		spawn(rand(200,250)+B.host.brainloss)
			if(!B || !B.controlling) return

			B.host.adjustBrainLoss(rand(0.1,0.5))
			to_chat(H, "<span class='danger'>With an immense exertion of will, you regain control of your body!</span>")
			to_chat(B.host, "<span class='danger'>You feel control of the host brain ripped from your grasp, and retract your probosci before the wild neural impulses can damage you.</span>")
			B.detatch()
			verbs -= /mob/living/carbon/proc/release_control
			verbs -= /mob/living/carbon/proc/punish_host
			verbs -= /mob/living/carbon/proc/spawn_larvae

		return

	..()

