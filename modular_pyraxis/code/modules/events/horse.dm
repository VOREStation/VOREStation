/datum/event/horse
	var/obj/machinery/door/the_door

/datum/event/horse/start()
	var/list/candidates
	var/mob/living/carbon/human/is_here

	for(var/mob/living/carbon/human/victim in GLOB.human_mob_list)
		if(victim.mind && victim.stat != DEAD && victim.is_client_active(5))
			candidates += victim

	is_here = pick(candidates)
	var/area/area = get_area(is_here)

	var/obj/machinery/door/the_door = pick(area.all_doors)

	if(!is_here || the_door)
		return

	new /mob/living/simple_mob/vore/horse(get_turf(the_door))
	the_door.open()
