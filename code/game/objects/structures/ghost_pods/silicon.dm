
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

/obj/structure/ghost_pod/manual/corgi
	name = "glowing rune"
	desc = "This rune slowly lights up and goes dim in a repeating pattern, like a slow heartbeat. It's almost as if it's calling out to you to touch it..."
	description_info = "This will summon some manner of creature through quite dubious means. The creature will be controlled by a player."
	icon_state = "corgirune"
	icon_state_opened = "corgirune-inert"
	density = FALSE
	anchored = TRUE
	ghost_query_type = /datum/ghost_query/corgi_rune
	confirm_before_open = TRUE

/obj/structure/ghost_pod/manual/corgi/trigger()
	..("<span class='warning'>\The [usr] places their hand on the rune!</span>", "is attempting to summon a corgi.")

/obj/structure/ghost_pod/manual/corgi/create_occupant(var/mob/M)
	density = FALSE
	var/mob/living/simple_animal/corgi/R = new(get_turf(src))
	if(M.mind)
		M.mind.transfer_to(R)
	to_chat(M, "<span class='notice'>You are a <b>Corgi</b>! Woof!</span>")
	R.ckey = M.ckey
	visible_message("<span class='warning'>With a bright flash of light, \the [src] disappears, and in its place stands a small corgi.</span>")
	log_and_message_admins("successfully touched \a [src] and summoned a corgi.")
	..()

/obj/structure/ghost_pod/manual/cursedblade
	name = "abandoned blade"
	desc = "A red crystal blade that someone jammed deep into a stone. If you try hard enough, you might be able to remove it."
	icon_state = "soulblade-embedded"
	icon_state_opened = "soulblade-released"
	density = TRUE
	anchored = TRUE
	ghost_query_type = /datum/ghost_query/cursedblade
	confirm_before_open = TRUE

/obj/structure/ghost_pod/manual/cursedblade/trigger()
	..("<span class='warning'>\The [usr] attempts to pull out the sword!</span>", "is activating a cursed blade.")

/obj/structure/ghost_pod/manual/cursedblade/create_occupant(var/mob/M)
	density = FALSE
	var/obj/item/weapon/melee/cursedblade/R = new(get_turf(src))
	to_chat(M, "<span class='notice'>You are a <b>Cursed Sword</b>, discovered by a hapless explorer. \
	You were once an explorer yourself, when one day you discovered a strange sword made from a red crystal. As soon as you touched it,\
	your body was reduced to ashes and your soul was cursed to remain trapped in the blade forever. \
	Now it is up to you to decide whether you want to be a faithful companion, or a bitter prisoner of the blade.</span>")
	R.ghost_inhabit(M)
	visible_message("<span class='warning'>The blade shines brightly for a brief moment as [usr] pulls it out of the stone!</span>")
	log_and_message_admins("successfully acquired a cursed sword.")
	..()