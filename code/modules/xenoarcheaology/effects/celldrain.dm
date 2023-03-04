//todo
/datum/artifact_effect/celldrain
	name = "cell drain"
	effect_type = EFFECT_ELECTRO
	var/last_message

<<<<<<< HEAD
	effect_state = "pulsing"
	effect_color = "#fbff02"

/datum/artifact_effect/celldrain/DoEffectTouch(var/mob/user)
	if(user)
		if(istype(user, /mob/living/silicon/robot))
			var/mob/living/silicon/robot/R = user
			for (var/obj/item/weapon/cell/D in R.contents)
				D.charge = max(D.charge - rand() * 100, 0)
				to_chat(R, "<font color='blue'>SYSTEM ALERT: Energy drain detected!</font>")
			return 1

		return 1

/datum/artifact_effect/celldrain/DoEffectAura()
	var/atom/holder = get_master_holder()
	if(holder)
		var/turf/T = get_turf(holder)
		for (var/obj/machinery/power/apc/C in GLOB.apcs)
			if(T.z != C.z)
				continue
			if(get_dist(T, C) > 200)
				continue
			for (var/obj/item/weapon/cell/B in C.contents)
				B.charge = max(B.charge - 50,0)
		for (var/obj/machinery/power/smes/S in GLOB.smeses)
			if(T.z != S.z)
				continue
			if(get_dist(T, S) > src.effectrange)
				continue
			S.charge = max(S.charge - 100,0)
		for (var/mob/living/silicon/robot/M in silicon_mob_list)
			if(T.z != M.z)
				continue
			if(get_dist(T, M) > 50)
				continue
			for (var/obj/item/weapon/cell/D in M.contents)
				D.charge = max(D.charge - 50,0)
				if(world.time - last_message > 200)
					to_chat(M, "<font color='red'>SYSTEM ALERT: Energy drain detected!</font>")
					last_message = world.time
	return 1

/datum/artifact_effect/celldrain/DoEffectPulse()
	var/atom/holder = get_master_holder()
	if(holder)
		var/turf/T = get_turf(holder)
		for (var/obj/machinery/power/apc/C in GLOB.apcs)
			if(T.z != C.z)
				continue
			if(get_dist(T, C) > 200)
				continue
			for (var/obj/item/weapon/cell/B in C.contents)
				B.charge = max(B.charge - rand() * 150,0)
		for (var/obj/machinery/power/smes/S in GLOB.smeses)
			if(T.z != S.z)
				continue
			if(get_dist(T, S) > src.effectrange)
				continue
			S.charge = max(S.charge - 250,0)
		for (var/mob/living/silicon/robot/M in silicon_mob_list)
			if(T.z != M.z) 
				continue
			if(get_dist(T, M) > 100)
				continue
			for (var/obj/item/weapon/cell/D in M.contents)
				D.charge = max(D.charge - rand() * 150,0)
				if(world.time - last_message > 200)
					to_chat(M, "<font color='red'>SYSTEM ALERT: Energy drain detected!</font>")
					last_message = world.time
	return 1
=======
/datum/artifact_effect/uncommon/celldrain/proc/drain_cells(var/amount = 25)
	var/atom/holder = get_master_holder()
	if (!holder)
		return
	var/turf/turf = get_turf(holder)
	if (!turf)
		return

	var/messaged_robots
	for(var/atom/movable/AM in range(effectrange, turf))
		if(isliving(AM))
			var/mob/living/L = AM
			var/obj/item/cell/C = L.get_cell()

			if(C)
				if(issilicon(L) && ((last_message + (1 MINUTE)) < world.time))
					messaged_robots = TRUE
					to_chat(L, SPAN_WARNING("SYSTEM ALERT: Energy drain detected!"))
				C.charge = min(C.maxcharge, C.charge - amount)
			continue

		var/obj/item/cell/C = AM.get_cell()
		if(C)
			C.charge = min(C.maxcharge, C.charge - amount)

	if(messaged_robots)
		last_message = world.time

/datum/artifact_effect/uncommon/celldrain/DoEffectTouch(mob/living/user)
	if(!user)
		return
	drain_cells(100)

/datum/artifact_effect/uncommon/celldrain/DoEffectAura()
	drain_cells()

/datum/artifact_effect/uncommon/celldrain/DoEffectPulse()
	drain_cells(50)
>>>>>>> 318bc4daa5b... Fix various anomaly bugs and oversights.  (#8941)
