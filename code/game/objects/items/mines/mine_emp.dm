/obj/item/mine/emp
	name = "emp mine"
	desc = "A small explosive mine with a lightning bolt symbol on the side."
	payload = /datum/mine_payload/emp

/datum/mine_payload/emp/trigger_payload(var/obj/item/mine/owner, var/atom/trigger)
	..()
	owner.visible_message("\The [owner] flashes violently before disintegrating!")
	empulse(owner.loc, 2, 4, 7, 10, 1) // As strong as an EMP grenade
