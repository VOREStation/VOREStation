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
			for (var/obj/item/cell/D in R.contents)
				D.charge += rand() * 100 + 50
				to_chat(R, "<font color='blue'>SYSTEM ALERT: Large energy boost detected!</font>")
			return 1

/datum/artifact_effect/cellcharge/DoEffectAura()
	var/atom/holder = get_master_holder()
	if(holder)
		var/turf/T = get_turf(holder)
<<<<<<< HEAD
		for (var/obj/machinery/power/apc/C in GLOB.apcs)
			if(T.z != C.z)
				continue
			if(get_dist(T, C) > 200)
				continue
			for (var/obj/item/weapon/cell/B in C.contents)
=======
		for (var/obj/machinery/power/apc/C in range(200, T))
			for (var/obj/item/cell/B in C.contents)
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
				B.charge += 25
		for (var/obj/machinery/power/smes/S in GLOB.smeses)
			if(T.z != S.z)
				continue
			if(get_dist(T, S) > src.effectrange)
				continue
			S.charge += 25
<<<<<<< HEAD
		for (var/mob/living/silicon/robot/M in silicon_mob_list)
			if(T.z != M.z)
				continue
			if(get_dist(T, M) > 50)
				continue
			for (var/obj/item/weapon/cell/D in M.contents)
=======
		for (var/mob/living/silicon/robot/M in range(50, T))
			for (var/obj/item/cell/D in M.contents)
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
				D.charge += 25
				if(world.time - last_message > 200)
					to_chat(M, "<font color='blue'>SYSTEM ALERT: Energy boost detected!</font>")
					last_message = world.time
		return 1

/datum/artifact_effect/cellcharge/DoEffectPulse()
	var/atom/holder = get_master_holder()
	if(holder)
		var/turf/T = get_turf(holder)
<<<<<<< HEAD
		for (var/obj/machinery/power/apc/C in GLOB.apcs)
			if(T.z != C.z)
				continue
			if(get_dist(T, C) > 200)
				continue
			for (var/obj/item/weapon/cell/B in C.contents)
=======
		for (var/obj/machinery/power/apc/C in range(200, T))
			for (var/obj/item/cell/B in C.contents)
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
				B.charge += rand() * 100
		for (var/obj/machinery/power/smes/S in GLOB.smeses)
			if(T.z != S.z)
				continue
			if(get_dist(T, S) > src.effectrange)
				continue
			S.charge += 250
<<<<<<< HEAD
		for (var/mob/living/silicon/robot/M in silicon_mob_list)
			if(T.z != M.z) 
				continue
			if(get_dist(T, M) > 100)
				continue
			for (var/obj/item/weapon/cell/D in M.contents)
=======
		for (var/mob/living/silicon/robot/M in range(100, T))
			for (var/obj/item/cell/D in M.contents)
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
				D.charge += rand() * 100
				if(world.time - last_message > 200)
					to_chat(M, "<font color='blue'>SYSTEM ALERT: Energy boost detected!</font>")
					last_message = world.time
		return 1
