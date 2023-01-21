/obj/item/mine/kick
	name = "kick mine"
	desc = "Concentrated war crimes. Handle with care."
	payload = /datum/mine_payload/kick

/datum/mine_payload/kick/trigger_payload(var/obj/item/mine/owner, var/atom/trigger)
	..()
	if(istype(trigger, /obj/mecha))
		var/obj/mecha/E = trigger
		trigger = E.occupant
	if(ismob(trigger))
		var/mob/M = trigger
		qdel(M.client)
