/obj/item/mine/frag
	name = "fragmentation mine"
	desc = "A small explosive mine with 'FRAG' and a grenade symbol on the side."
	payload = /datum/mine_payload/frag

/datum/mine_payload/frag
	var/fragment_types = list(/obj/item/projectile/bullet/pellet/fragment)
	var/num_fragments = 20  //total number of fragments produced by the grenade
	//The radius of the circle used to launch projectiles. Lower values mean less projectiles are used but if set too low gaps may appear in the spread pattern
	var/spread_range = 7

/datum/mine_payload/frag/trigger_payload(var/obj/item/mine/owner, var/atom/trigger)
	..()
	var/turf/O = get_turf(owner)
	if(O)
		owner.fragmentate(O, num_fragments, spread_range, fragment_types)
	owner.visible_message("\The [owner] detonates!")
