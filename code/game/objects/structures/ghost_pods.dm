// These are used to spawn a specific mob when triggered, with the mob controlled by a player pulled from the ghost pool, hense its name.
/obj/structure/ghost_pod
	name = "Base Ghost Pod"
	desc = "If you can read me, someone don goofed."
	icon = 'icons/obj/structures.dmi'
	var/ghost_query_type = null
	var/icon_state_opened = null	// Icon to switch to when 'used'.
	var/used = FALSE
	var/busy = FALSE // Don't spam ghosts by spamclicking.

// Call this to get a ghost volunteer.
/obj/structure/ghost_pod/proc/trigger()
	if(!ghost_query_type)
		return FALSE
	if(busy)
		return FALSE

	busy = TRUE
	var/datum/ghost_query/Q = new ghost_query_type()
	var/list/winner = Q.query()
	busy = FALSE
	if(winner.len)
		var/mob/observer/dead/D = winner[1]
		create_occupant(D)
		return TRUE
	else
		return FALSE

// Override this to create whatever mob you need. Be sure to call ..() if you don't want it to make infinite mobs.
/obj/structure/ghost_pod/proc/create_occupant(var/mob/M)
	used = TRUE
	icon_state = icon_state_opened
	return TRUE


// This type is triggered manually by a player discovering the pod and deciding to open it.
/obj/structure/ghost_pod/manual
	var/confirm_before_open = FALSE // Recommended to be TRUE if the pod contains a surprise.

/obj/structure/ghost_pod/manual/attack_hand(var/mob/living/user)
	if(!used)
		if(confirm_before_open)
			if(alert(user, "Are you sure you want to open \the [src]?", "Confirm", "No", "Yes") == "No")
				return
		trigger()

/obj/structure/ghost_pod/manual/attack_ai(var/mob/living/silicon/user)
	if(Adjacent(user))
		attack_hand(user) // Borgs can open pods.

// This type is triggered on a timer, as opposed to needing another player to 'open' the pod.  Good for away missions.
/obj/structure/ghost_pod/automatic
	var/delay_to_self_open = 10 MINUTES // How long to wait for first attempt.  Note that the timer by default starts when the pod is created.
	var/delay_to_try_again = 20 MINUTES // How long to wait if first attempt fails.  Set to 0 to never try again.

/obj/structure/ghost_pod/automatic/initialize()
	..()
	spawn(delay_to_self_open)
		if(src)
			trigger()

/obj/structure/ghost_pod/automatic/trigger()
	. = ..()
	if(. == FALSE) // If we failed to get a volunteer, try again later if allowed to.
		if(delay_to_try_again)
			spawn(delay_to_try_again)
				if(src)
					trigger()


// This type is triggered by a ghost clicking on it, as opposed to a living player.  A ghost query type isn't needed.
/obj/structure/ghost_pod/ghost_activated
	description_info = "A ghost can click on this to return to the round as whatever is contained inside this object."

/obj/structure/ghost_pod/ghost_activated/attack_ghost(var/mob/observer/dead/user)
	if(used)
		to_chat(user, "<span class='warning'>Another spirit appears to have gotten to \the [src] before you.  Sorry.</span>")
		return

	create_occupant(user)


// These are found on the surface, and contain a drone (braintype, inside a borg shell), with a special module and semi-random laws.
/obj/structure/ghost_pod/manual/lost_drone
	name = "drone pod"
	desc = "This is a pod which appears to contain a drone. You might be able to reactivate it, if you're brave enough."
	description_info = "This contains a dormant drone, which can be activated. The drone will be another player, once activated. \
	The laws the drone has will most likely not be the ones you're used to."
	icon_state = "borg_pod_closed"
	icon_state_opened = "borg_pod_opened"
	density = TRUE
	ghost_query_type = /datum/ghost_query/lost_drone
	confirm_before_open = TRUE

/obj/structure/ghost_pod/manual/lost_drone/trigger()
	..()
	visible_message("<span class='notice'>\The [src] appears to be attempting to restart the robot contained inside.</span>")
	log_and_message_admins("is attempting to open \a [src].")

/obj/structure/ghost_pod/manual/lost_drone/create_occupant(var/mob/M)
	density = FALSE
	var/mob/living/silicon/robot/lost/randomlaws/R = new(get_turf(src))
	R.adjustBruteLoss(rand(5, 30))
	R.adjustFireLoss(rand(5, 10))
	if(M.mind)
		M.mind.transfer_to(R)
	// Put this text here before ckey change so that their laws are shown below it, since borg login() shows it.
	to_chat(M, "<span class='notice'>You are a <b>Lost Drone</b>, discovered inside the wreckage of your previous home. \
	Something has reactivated you, with their intentions unknown to you, and yours unknown to them. They are a foreign entity, \
	however they did free you from your pod...</span>")
	to_chat(M, "<span class='notice'><b>Be sure to examine your currently loaded lawset closely.</b>  Remember, your \
	definiton of 'the station' is where your pod is, and unless your laws say otherwise, the entity that released you \
	from the pod is not a crewmember.</span>")
	R.ckey = M.ckey
	visible_message("<span class='warning'>As \the [src] opens, the eyes of the robot flicker as it is activated.</span>")
	R.Namepick()
	log_and_message_admins("successfully opened \a [src] and got a Lost Drone.")
	..()
