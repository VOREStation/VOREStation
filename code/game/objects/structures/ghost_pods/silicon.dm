
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
	needscharger = TRUE

/obj/structure/ghost_pod/manual/lost_drone/trigger()
	..("<span class='notice'>\The [src] appears to be attempting to restart the robot contained inside.</span>", "is attempting to open \a [src].")

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

/obj/structure/ghost_pod/automatic/gravekeeper_drone
	name = "drone pod"
	desc = "This is a pod which appears to contain a drone. You might be able to reactivate it, if you're brave enough."
	description_info = "This contains a dormant drone, which may activate at any moment. The drone will be another player, once activated. \
	The laws the drone has will most likely not be the ones you're used to."
	icon_state = "borg_pod_closed"
	icon_state_opened = "borg_pod_opened"
	density = TRUE
	ghost_query_type = /datum/ghost_query/gravekeeper_drone
	needscharger = TRUE

/obj/structure/ghost_pod/automatic/gravekeeper_drone/create_occupant(var/mob/M)
	density = FALSE
	var/mob/living/silicon/robot/gravekeeper/R = new(get_turf(src))
	if(M.mind)
		M.mind.transfer_to(R)
	// Put this text here before ckey change so that their laws are shown below it, since borg login() shows it.
	to_chat(M, "<span class='notice'>You are a <b>Gravekeeper Drone</b>, activated once again to tend to the restful dead.</span>")
	to_chat(M, "<span class='notice'><b>Be sure to examine your currently loaded lawset closely.</b>  Remember, your \
	definiton of 'your gravesite' is where your pod is.</span>")
	R.ckey = M.ckey
	visible_message("<span class='warning'>As \the [src] opens, the eyes of the robot flicker as it is activated.</span>")
	R.Namepick()
	..()

/obj/structure/ghost_pod/ghost_activated/swarm_drone
	name = "drone shell"
	desc = "A heavy metallic ball."
	icon = 'icons/mob/swarmbot.dmi'
	icon_state = "swarmer_unactivated"
	density = FALSE
	anchored = FALSE

	var/drone_class = "general"
	var/drone_type = /mob/living/silicon/robot/drone/swarm

/obj/structure/ghost_pod/ghost_activated/swarm_drone/create_occupant(var/mob/M)
	var/mob/living/silicon/robot/drone/swarm/R = new drone_type(get_turf(src))
	if(M.mind)
		M.mind.transfer_to(R)
	to_chat(M, "<span class='cult'>You are <b>[R]</b>, the remnant of some distant species, mechanical or flesh, living or dead.</span>")
	R.ckey = M.ckey
	visible_message("<span class='cult'>As \the [src] shudders, it glows before lifting itself with three shimmering limbs!</span>")
	spawn(3 SECONDS)
		to_chat(R,"<span class='notice'>Many of your tools are standard drone devices, however others provide you with particular benefits.</span>")
		to_chat(R,"<span class='notice'>Unlike standard drones, you are capable of utilizing 'zero point wells', found in your 'spells' tab.</span>")
		to_chat(R,"<span class='notice'>Here you will also find your replication ability(s), depending on the type of drone you are.</span>")
		to_chat(R,"<span class='notice'>Gunners have a special anti-personnel gun capable of shocking or punching through armor with low damage.</span>")
		to_chat(R,"<span class='notice'>Impalers have an energy-lance.</span>")
		to_chat(R,"<span class='notice'>General drones have the unique ability to produce one of each of these two types of shells per generation.</span>")
	if(!QDELETED(src))
		qdel(src)

/obj/structure/ghost_pod/ghost_activated/swarm_drone/event/Initialize()
	. = ..()

	var/turf/T = get_turf(src)
	say_dead_object("A <span class='notice'>[drone_class] swarm drone</span> shell is now available in \the [T.loc].", src)

/obj/structure/ghost_pod/ghost_activated/swarm_drone/event/gunner
	name = "gunner shell"

	drone_class = "gunner"
	drone_type = /mob/living/silicon/robot/drone/swarm/gunner

/obj/structure/ghost_pod/ghost_activated/swarm_drone/event/melee
	name = "impaler shell"

	drone_class = "impaler"
	drone_type = /mob/living/silicon/robot/drone/swarm/melee
