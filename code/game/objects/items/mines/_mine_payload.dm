/datum/mine_payload
	var/do_sparks = TRUE
	var/destroy_self_on_trigger = TRUE

/datum/mine_payload/proc/trigger_payload(var/obj/item/mine/owner, var/atom/trigger)
	if(do_sparks)
		var/datum/effect_system/spark_spread/s = new
		s.set_up(3, 1, owner)
		s.start()
	if(destroy_self_on_trigger)
		if(!QDELETED(owner))
			QDEL_IN(owner, 1)
	else
		owner.disarm() // some mines can be reused

/datum/mine_payload/proc/remove_from_mine()
	return

/datum/mine_payload/explosive/trigger_payload(var/obj/item/mine/owner, var/atom/trigger)
	..()
	owner.visible_message("\The [owner] detonates!")
	explosion(owner.loc, 0, 2, 3, 4) //land mines are dangerous, folks.
