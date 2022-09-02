/datum/artifact_effect/teleport
	name = "teleport"
	effect_type = EFFECT_BLUESPACE
	effect_state = "pulsing"
	effect_color = "#88ffdb"

<<<<<<< HEAD
/datum/artifact_effect/teleport/DoEffectTouch(var/mob/user)
=======

/datum/artifact_effect/rare/teleport/DoEffectTouch(mob/living/user)
>>>>>>> 37cfcfc45fa... Merge pull request #8685 from Spookerton/spkrtn/cng/tweak-effect-aura
	var/atom/holder = get_master_holder()
	var/weakness = GetAnomalySusceptibility(user)
	if (prob(100 * weakness))
		to_chat(user, "<font color='red'>You are suddenly zapped away elsewhere!</font>")
		if (user.buckled)
			user.buckled.unbuckle_mob()
<<<<<<< HEAD

		var/datum/effect/effect/system/spark_spread/sparks = new /datum/effect/effect/system/spark_spread()
=======
		var/datum/effect_system/spark_spread/sparks = new /datum/effect_system/spark_spread()
>>>>>>> 37cfcfc45fa... Merge pull request #8685 from Spookerton/spkrtn/cng/tweak-effect-aura
		sparks.set_up(3, 0, get_turf(user))
		sparks.start()
		user.Move(pick(trange(50, get_turf(holder))))
<<<<<<< HEAD

		sparks = new /datum/effect/effect/system/spark_spread()
		sparks.set_up(3, 0, user.loc)
		sparks.start()

/datum/artifact_effect/teleport/DoEffectAura()
=======
		sparks = new /datum/effect_system/spark_spread()
		sparks.set_up(3, 0, user.loc)
		sparks.start()


/datum/artifact_effect/rare/teleport/DoEffectAura()
>>>>>>> 37cfcfc45fa... Merge pull request #8685 from Spookerton/spkrtn/cng/tweak-effect-aura
	var/atom/holder = get_master_holder()
	if (holder)
		var/turf/T = get_turf(holder)
		for (var/mob/living/M in range(src.effectrange,T))
			var/weakness = GetAnomalySusceptibility(M)
			if (prob(100 * weakness))
				to_chat(M, "<font color='red'>You are displaced by a strange force!</font>")
				if (M.buckled)
					M.buckled.unbuckle_mob()
<<<<<<< HEAD

				var/datum/effect/effect/system/spark_spread/sparks = new /datum/effect/effect/system/spark_spread()
=======
				var/datum/effect_system/spark_spread/sparks = new /datum/effect_system/spark_spread()
>>>>>>> 37cfcfc45fa... Merge pull request #8685 from Spookerton/spkrtn/cng/tweak-effect-aura
				sparks.set_up(3, 0, get_turf(M))
				sparks.start()
				M.Move(pick(trange(50, T)))
				sparks = new /datum/effect/effect/system/spark_spread()
				sparks.set_up(3, 0, M.loc)
				sparks.start()

<<<<<<< HEAD
/datum/artifact_effect/teleport/DoEffectPulse()
=======

/datum/artifact_effect/rare/teleport/DoEffectPulse()
>>>>>>> 37cfcfc45fa... Merge pull request #8685 from Spookerton/spkrtn/cng/tweak-effect-aura
	var/atom/holder = get_master_holder()
	if (holder)
		var/turf/T = get_turf(holder)
		for (var/mob/living/M in range(src.effectrange, T))
			var/weakness = GetAnomalySusceptibility(M)
			if (prob(100 * weakness))
				to_chat(M, "<font color='red'>You are displaced by a strange force!</font>")
				if (M.buckled)
					M.buckled.unbuckle_mob()
<<<<<<< HEAD

				var/datum/effect/effect/system/spark_spread/sparks = new /datum/effect/effect/system/spark_spread()
=======
				var/datum/effect_system/spark_spread/sparks = new /datum/effect_system/spark_spread()
>>>>>>> 37cfcfc45fa... Merge pull request #8685 from Spookerton/spkrtn/cng/tweak-effect-aura
				sparks.set_up(3, 0, get_turf(M))
				sparks.start()
				M.Move(pick(trange(50, T)))
				sparks = new /datum/effect/effect/system/spark_spread()
				sparks.set_up(3, 0, M.loc)
				sparks.start()
