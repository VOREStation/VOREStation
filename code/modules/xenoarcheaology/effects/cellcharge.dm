<<<<<<< HEAD
//todo
/datum/artifact_effect/cellcharge
=======
/datum/artifact_effect/uncommon/cellcharge
>>>>>>> 37cfcfc45fa... Merge pull request #8685 from Spookerton/spkrtn/cng/tweak-effect-aura
	name = "cell charge"
	effect_type = EFFECT_ELECTRO
	effect_color = "#ffee06"
	var/last_message


<<<<<<< HEAD
/datum/artifact_effect/cellcharge/DoEffectTouch(var/mob/user)
	if(user)
		if(isrobot(user))
=======
/datum/artifact_effect/uncommon/cellcharge/DoEffectTouch(mob/living/user)
	if (user)
		if (istype(user, /mob/living/silicon/robot))
>>>>>>> 37cfcfc45fa... Merge pull request #8685 from Spookerton/spkrtn/cng/tweak-effect-aura
			var/mob/living/silicon/robot/R = user
			for (var/obj/item/weapon/cell/D in R.contents)
				D.charge += rand() * 100 + 50
				to_chat(R, "<font color='blue'>SYSTEM ALERT: Large energy boost detected!</font>")


/datum/artifact_effect/cellcharge/DoEffectAura()
	var/atom/holder = get_master_holder()
<<<<<<< HEAD
	if(holder)
		var/turf/T = get_turf(holder)
		for (var/obj/machinery/power/apc/C in GLOB.apcs)
			if(T.z != C.z)
				continue
			if(get_dist(T, C) > 200)
				continue
			for (var/obj/item/weapon/cell/B in C.contents)
				B.charge += 25
		for (var/obj/machinery/power/smes/S in GLOB.smeses)
			if(T.z != S.z)
				continue
			if(get_dist(T, S) > src.effectrange)
				continue
			S.charge += 25
		for (var/mob/living/silicon/robot/M in silicon_mob_list)
			if(T.z != M.z)
				continue
			if(get_dist(T, M) > 50)
				continue
			for (var/obj/item/weapon/cell/D in M.contents)
				D.charge += 25
				if(world.time - last_message > 200)
					to_chat(M, "<font color='blue'>SYSTEM ALERT: Energy boost detected!</font>")
					last_message = world.time
		return 1
=======
	if (!holder)
		return
	var/turf/turf = get_turf(holder)
	if (!turf)
		return
	for (var/obj/machinery/power/apc/apc as anything in GLOB.apcs)
		if (get_dist(turf, apc) <= 200)
			for (var/obj/item/cell/cell in apc.contents)
				cell.charge += 25
	for (var/obj/machinery/power/smes/smes as anything in GLOB.smeses)
		if (get_dist(turf, smes) <= effectrange)
			smes.charge += 25
	var/charged_robots
	for (var/mob/living/silicon/robot/robot as anything in global.silicon_mob_list)
		if (get_dist(turf, robot) < 50)
			var/charged_cells
			for (var/obj/item/cell/cell in robot.contents)
				cell.charge += 25
				charged_cells = TRUE
			if (charged_cells)
				to_chat(robot, "<font color='blue'>SYSTEM ALERT: Energy boost detected!</font>")
				charged_robots = TRUE
	if (charged_robots)
		last_message = world.time

>>>>>>> 37cfcfc45fa... Merge pull request #8685 from Spookerton/spkrtn/cng/tweak-effect-aura

/datum/artifact_effect/cellcharge/DoEffectPulse()
	var/atom/holder = get_master_holder()
	if (holder)
		var/turf/T = get_turf(holder)
		for (var/obj/machinery/power/apc/C in GLOB.apcs)
			if(T.z != C.z)
				continue
			if(get_dist(T, C) > 200)
				continue
			for (var/obj/item/weapon/cell/B in C.contents)
				B.charge += rand() * 100
		for (var/obj/machinery/power/smes/S in GLOB.smeses)
			if(T.z != S.z)
				continue
			if(get_dist(T, S) > src.effectrange)
				continue
			S.charge += 250
		for (var/mob/living/silicon/robot/M in silicon_mob_list)
			if(T.z != M.z) 
				continue
			if(get_dist(T, M) > 100)
				continue
			for (var/obj/item/weapon/cell/D in M.contents)
				D.charge += rand() * 100
				if (world.time - last_message > 200)
					to_chat(M, "<font color='blue'>SYSTEM ALERT: Energy boost detected!</font>")
					last_message = world.time
