//todo
/datum/artifact_effect/uncommon/celldrain
	name = "cell drain"
	effect_type = EFFECT_ELECTRO
	var/last_message

	effect_state = "pulsing"
	effect_color = "#fbff02"

/datum/artifact_effect/uncommon/celldrain/DoEffectTouch(var/mob/user)
	if(user)
		if(istype(user, /mob/living/silicon/robot))
			var/mob/living/silicon/robot/R = user
			for (var/obj/item/weapon/cell/D in R.contents)
				D.charge = max(D.charge - rand() * 100, 0)
				to_chat(R, "<font color='blue'>SYSTEM ALERT: Energy drain detected!</font>")
			return 1

		return 1

/datum/artifact_effect/uncommon/celldrain/DoEffectAura()
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

/datum/artifact_effect/uncommon/celldrain/DoEffectPulse()
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
