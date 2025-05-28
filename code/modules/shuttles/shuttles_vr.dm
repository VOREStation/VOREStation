/datum/shuttle
	var/move_direction //Null is legacy behavior, otherwise people are thrown in the opposite direction

/datum/shuttle/proc/throw_a_mob(var/mob/living/carbon/M, direction)
	direction = turn(direction, 180)
	var/atom/target
	switch(direction)
		if(NORTH)
			var/y = (M.y + world.view) > world.maxy ? world.maxy : M.y + world.view
			target = locate(M.x, y, M.z)
		if(SOUTH)
			var/y = (M.y - world.view) < 1 ? 1 : M.y - world.view
			target = locate(M.x, y, M.z)
		if(EAST)
			var/x = (M.x + world.view) > world.maxx ? world.maxx : M.x + world.view
			target = locate(x, M.y, M.z)
		if(WEST)
			var/x = (M.x - world.view) < 1 ? 1 : M.x - world.view
			target = locate(x, M.y, M.z)
	if(target)
		M.throw_at(target, world.view, 1)

/obj/machinery/computer/shuttle_control/multi/admin
	name = "centcom shuttle control console"
	req_access = list(access_cent_general)
	shuttle_tag = "Administration"

/obj/machinery/computer/shuttle_control/multi/awaymission
	name = "exploration shuttle control console"
	req_access = list(access_gateway)
	shuttle_tag = "AwayMission"

/obj/machinery/computer/shuttle_control/belter
	name = "belter control console"
	req_one_access = list(access_mining, access_medical_equip) //Allows xenoarch, miners AND doctors to use it.
	shuttle_tag = "Belter" //The scanning console needs to enable/disable this at will.
	ai_control = TRUE

/obj/machinery/computer/shuttle_control/mining
	name = "mining elevator control console"

/obj/machinery/computer/shuttle_control/engineering
	name = "engineering elevator control console"

/obj/machinery/computer/shuttle_control/research
	name = "research elevator control console"
