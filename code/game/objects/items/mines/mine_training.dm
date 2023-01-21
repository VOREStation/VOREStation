/obj/item/mine/training
	name = "training mine"
	desc = "A mine with its payload removed, for EOD training and demonstrations."
	payload = /datum/mine_payload/training

/datum/mine_payload/training
	do_sparks = FALSE
	destroy_self_on_trigger = FALSE

/datum/mine_payload/training/trigger_payload(var/obj/item/mine/owner, var/atom/trigger)
	..()
	owner.visible_message("\The [owner]'s light flashes rapidly as it 'explodes'.")
