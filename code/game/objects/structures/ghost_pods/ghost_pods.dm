// These are used to spawn a specific mob when triggered, with the mob controlled by a player pulled from the ghost pool, hense its name.
/obj/structure/ghost_pod
	name = "Base Ghost Pod"
	desc = "If you can read me, someone don goofed."
	icon = 'icons/obj/structures.dmi'
	var/ghost_query_type = null
	var/icon_state_opened = null	// Icon to switch to when 'used'.
	var/used = FALSE
	var/busy = FALSE // Don't spam ghosts by spamclicking.
	var/needscharger //For drone pods that want their pod to turn into a charger.
	unacidable = TRUE

// Call this to get a ghost volunteer.
/obj/structure/ghost_pod/proc/trigger(var/alert, var/adminalert)
	if(!ghost_query_type)
		return FALSE
	if(busy)
		return FALSE

	if(alert)
		visible_message(alert)
	if(adminalert)
		log_and_message_admins(adminalert)
	busy = TRUE
	var/datum/ghost_query/Q = new ghost_query_type()
	var/list/winner = Q.query()
	busy = FALSE
	if(winner.len)
		var/mob/observer/dead/D = winner[1]
		create_occupant(D)
		icon_state = icon_state_opened
		if(needscharger)
			new /obj/machinery/recharge_station/ghost_pod_recharger(src.loc)
			qdel(src)
		return TRUE
	else
		return FALSE

// Override this to create whatever mob you need. Be sure to call ..() if you don't want it to make infinite mobs.
/obj/structure/ghost_pod/proc/create_occupant(var/mob/M)
	used = TRUE
	//VOREStation Addition Start
	if(src in active_ghost_pods)
		active_ghost_pods -= src
	//VOREStation Addition End
	return TRUE


// This type is triggered manually by a player discovering the pod and deciding to open it.
/obj/structure/ghost_pod/manual
	var/confirm_before_open = FALSE // Recommended to be TRUE if the pod contains a surprise.

/obj/structure/ghost_pod/manual/attack_hand(var/mob/living/user)
	if(!used)
		if(confirm_before_open)
			if(tgui_alert(user, "Are you sure you want to touch \the [src]?", "Confirm", list("No", "Yes")) != "Yes")
				return
		trigger()
		// VOREStation Addition Start
		if(!used)
			activated = TRUE
			ghostpod_startup(FALSE)
		// VOREStation Addition End

/obj/structure/ghost_pod/manual/attack_ai(var/mob/living/silicon/user)
	if(Adjacent(user))
		attack_hand(user) // Borgs can open pods.

// This type is triggered on a timer, as opposed to needing another player to 'open' the pod.  Good for away missions.
/obj/structure/ghost_pod/automatic
	var/delay_to_self_open = 10 MINUTES // How long to wait for first attempt.  Note that the timer by default starts when the pod is created.
	var/delay_to_try_again = 20 MINUTES // How long to wait if first attempt fails.  Set to 0 to never try again.

/obj/structure/ghost_pod/automatic/Initialize()
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(trigger)), delay_to_self_open)

/obj/structure/ghost_pod/automatic/trigger()
	. = ..()
	if(. == FALSE) // If we failed to get a volunteer, try again later if allowed to.
		if(delay_to_try_again)
			addtimer(CALLBACK(src, PROC_REF(trigger)), delay_to_try_again)

// This type is triggered by a ghost clicking on it, as opposed to a living player.  A ghost query type isn't needed.
/obj/structure/ghost_pod/ghost_activated
	description_info = "A ghost can click on this to return to the round as whatever is contained inside this object."

/obj/structure/ghost_pod/ghost_activated/attack_ghost(var/mob/observer/dead/user)
	//VOREStation Add Start
	if(jobban_isbanned(user, JOB_GHOSTROLES))
		to_chat(user, "<span class='warning'>You cannot inhabit this creature because you are banned from playing ghost roles.</span>")
		return

	//No OOC notes
	if (not_has_ooc_text(user))
		return

	//VOREStation Add End
	if(used)
		to_chat(user, "<span class='warning'>Another spirit appears to have gotten to \the [src] before you.  Sorry.</span>")
		return

	var/choice = tgui_alert(user, "Are you certain you wish to activate this pod?", "Control Pod", list("Yes", "No"))

	if(!choice || choice == "No")
		return

	else if(used)
		to_chat(user, "<span class='warning'>Another spirit appears to have gotten to \the [src] before you.  Sorry.</span>")
		return

	create_occupant(user)
