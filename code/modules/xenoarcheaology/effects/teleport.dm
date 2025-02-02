/// Modified to work with the Artifact Harvester
/datum/artifact_effect/teleport
	name = "Teleportation"
	effect_type = EFFECT_TELEPORT
	effect_state = "pulsing"
	effect_color = "#88ffdb"

/datum/artifact_effect/teleport/DoEffectTouch(var/mob/user)
	var/atom/holder = get_master_holder()
	var/weakness = GetAnomalySusceptibility(user)
	if(prob(100 * weakness))
		to_chat(user, span_red("You are suddenly zapped away elsewhere!"))
		if (user.buckled)
			user.buckled.unbuckle_mob()

		var/datum/effect/effect/system/spark_spread/sparks = new /datum/effect/effect/system/spark_spread()
		sparks.set_up(3, 0, get_turf(user))
		sparks.start()

		user.Move(pick(trange(50, get_turf(holder))))

		sparks = new /datum/effect/effect/system/spark_spread()
		sparks.set_up(3, 0, user.loc)
		sparks.start()

/datum/artifact_effect/teleport/DoEffectAura()
	var/atom/holder = get_master_holder()
	if(istype(holder, /obj/item/anobattery))
		var/obj/item/anobattery/battery = holder
		battery.stored_charge = max(0, battery.stored_charge-250) //Slow your roll. This takes a LOT of energy.
	if(holder)
		var/turf/T = get_turf(holder)
		for (var/mob/living/M in range(src.effectrange,T))
			var/weakness = GetAnomalySusceptibility(M)
			if(prob(100 * weakness))
				to_chat(M, span_red("You are displaced by a strange force!"))
				if(M.buckled)
					M.buckled.unbuckle_mob(M)

				var/datum/effect/effect/system/spark_spread/sparks = new /datum/effect/effect/system/spark_spread()
				sparks.set_up(3, 0, get_turf(M))
				sparks.start()

				M.Move(pick(trange(50, T)))
				sparks = new /datum/effect/effect/system/spark_spread()
				sparks.set_up(3, 0, M.loc)
				sparks.start()

/datum/artifact_effect/teleport/DoEffectPulse()
	var/atom/holder = get_master_holder()
	if(istype(holder, /obj/item/anobattery))
		var/obj/item/anobattery/battery = holder
		battery.stored_charge = max(0, battery.stored_charge-500) //Slow your roll. This takes a LOT of energy.
	if(holder)
		var/turf/T = get_turf(holder)
		for (var/mob/living/M in range(src.effectrange, T))
			var/weakness = GetAnomalySusceptibility(M)
			if(prob(100 * weakness))
				to_chat(M, span_red("You are displaced by a strange force!"))
				if(M.buckled)
					M.buckled.unbuckle_mob()

				var/datum/effect/effect/system/spark_spread/sparks = new /datum/effect/effect/system/spark_spread()
				sparks.set_up(3, 0, get_turf(M))
				sparks.start()

				M.Move(pick(trange(50, T)))
				sparks = new /datum/effect/effect/system/spark_spread()
				sparks.set_up(3, 0, M.loc)
				sparks.start()
