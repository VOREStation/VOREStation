/obj/item/mine/dnascramble
	name = "radiation mine"
	desc = "A small explosive mine with a radiation symbol on the side."
	payload = /datum/mine_payload/dnascramble

/datum/mine_payload/dnascramble/trigger_payload(var/obj/item/mine/owner, var/atom/trigger)
	..()
	if(ismob(trigger))
		var/mob/M = trigger
		M.radiation += 50
		randmutb(M)
		domutcheck(M,null)
	owner.visible_message("\The [owner] flashes violently before disintegrating!")
