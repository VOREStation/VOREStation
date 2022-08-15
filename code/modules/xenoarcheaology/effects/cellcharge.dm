//todo
/datum/artifact_effect/cellcharge
	name = "cell charge"
	effect_type = EFFECT_ELECTRO
	var/last_message

	effect_color = "#ffee06"

/datum/artifact_effect/cellcharge/DoEffectTouch(var/mob/user)
	if(user)
		if(isrobot(user))
			var/mob/living/silicon/robot/R = user
			for (var/obj/item/weapon/cell/D in R.contents)
				D.charge += rand() * 100 + 50
				to_chat(R, "<font color='blue'>SYSTEM ALERT: Large energy boost detected!</font>")
			return 1

/datum/artifact_effect/cellcharge/DoEffectAura()
	var/atom/holder = get_master_holder()
	if(holder)
		var/turf/T = get_turf(holder)
		for (var/obj/machinery/power/apc/C in GLOB.apcs)
<<<<<<< HEAD
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
=======
			if(get_dist(holder, C) <= 200)
				for (var/obj/item/cell/B in C.contents)
					B.charge += 25
		for (var/obj/machinery/power/smes/S in GLOB.smeses)
			if(get_dist(holder, S) <= src.effectrange)
				S.charge += 25
		for (var/mob/living/silicon/robot/M in global.silicon_mob_list)
			if(get_dist(holder, M) < 50)
				for (var/obj/item/cell/D in M.contents)
					D.charge += 25
					if(world.time - last_message > 200)
						to_chat(M, "<font color='blue'>SYSTEM ALERT: Energy boost detected!</font>")
						last_message = world.time
>>>>>>> b50ad202b42... Merge pull request #8672 from Atermonera/cellcharge-iteration
		return 1

/datum/artifact_effect/cellcharge/DoEffectPulse()
	var/atom/holder = get_master_holder()
	if(holder)
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
				if(world.time - last_message > 200)
					to_chat(M, "<font color='blue'>SYSTEM ALERT: Energy boost detected!</font>")
					last_message = world.time
		return 1
