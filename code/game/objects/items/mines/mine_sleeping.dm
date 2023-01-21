/obj/item/mine/sleeping
	name = "nitrous oxide mine"
	desc = "A small explosive mine with three Z's on the side."
	payload = /datum/mine_payload/sleeping

/datum/mine_payload/sleeping/trigger_payload(var/obj/item/mine/owner, var/atom/trigger)
	..()
	for (var/turf/simulated/floor/target in range(1, owner))
		if(!target.blocks_air)
			target.assume_gas("nitrous_oxide", 30)
	owner.visible_message("\The [owner] sprays a cloud of gas!")
