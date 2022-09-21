/datum/artifact_effect/cellcharge
	name = "cell charge"
	effect_type = EFFECT_ELECTRO
	effect_color = "#ffee06"
	var/last_message


/datum/artifact_effect/cellcharge/DoEffectTouch(var/mob/living/user)
	if (user)
		if (istype(user, /mob/living/silicon/robot))
			var/mob/living/silicon/robot/R = user
			for (var/obj/item/weapon/cell/D in R.contents)
				D.charge += rand() * 100 + 50
				to_chat(R, "<font color='blue'>SYSTEM ALERT: Large energy boost detected!</font>")


/datum/artifact_effect/cellcharge/DoEffectAura()
	var/atom/holder = get_master_holder()
	if(!holder)
		return
	var/turf/turf = get_turf(holder)
	if(!turf)
		return
	for (var/obj/machinery/power/apc/apc as anything in GLOB.apcs)
		if (get_dist(turf, apc) <= 200)
			for (var/obj/item/weapon/cell/cell in apc.contents)
				cell.charge += 25
	for (var/obj/machinery/power/smes/smes as anything in GLOB.smeses)
		if (get_dist(turf, smes) <= effectrange)
			smes.charge += 25
	var/charged_robots
	for (var/mob/living/silicon/robot/robot as anything in global.silicon_mob_list)
		if (get_dist(turf, robot) < 50)
			var/charged_cells
			for (var/obj/item/weapon/cell/cell in robot.contents)
				cell.charge += 25
				charged_cells = TRUE
			if (charged_cells)
				to_chat(robot, "<font color='blue'>SYSTEM ALERT: Energy boost detected!</font>")
				charged_robots = TRUE
	if (charged_robots)
		last_message = world.time


/datum/artifact_effect/cellcharge/DoEffectPulse()
	var/atom/holder = get_master_holder()
	if(holder)
		var/turf/T = get_turf(holder)
		for (var/obj/machinery/power/apc/C in range(200, T))
			for (var/obj/item/weapon/cell/B in C.contents)
				B.charge += rand() * 100
		for (var/obj/machinery/power/smes/S in range (src.effectrange,src))
			S.charge += 250
		for (var/mob/living/silicon/robot/M in range(100, T))
			for (var/obj/item/weapon/cell/D in M.contents)
				D.charge += rand() * 100
				if(world.time - last_message > 200)
					to_chat(M, "<font color='blue'>SYSTEM ALERT: Energy boost detected!</font>")
					last_message = world.time
