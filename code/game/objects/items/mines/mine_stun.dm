/obj/item/mine/stun
	name = "stun mine"
	desc = "A small explosive mine with a lightning bolt symbol on the side."
	payload = /datum/mine_payload/stun

/datum/mine_payload/stun/trigger_payload(var/obj/item/mine/owner, var/atom/trigger)
	..()
	if(ismob(trigger))
		var/mob/M = trigger
		M.Stun(30)
	owner.visible_message("\The [owner] flashes violently before disintegrating!")
