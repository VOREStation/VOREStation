/datum/artifact_effect/hurt
	name = "hurt"
	effect_type = EFFECT_ORGANIC
	effect_color = "#6d1212"

<<<<<<< HEAD
/datum/artifact_effect/hurt/DoEffectTouch(var/mob/toucher)
	if(toucher)
		var/weakness = GetAnomalySusceptibility(toucher)
		if(iscarbon(toucher) && prob(weakness * 100))
			var/mob/living/carbon/C = toucher
=======

/datum/artifact_effect/uncommon/hurt/DoEffectTouch(mob/living/user)
	if (user)
		var/weakness = GetAnomalySusceptibility(user)
		if (iscarbon(user) && prob(weakness * 100))
			var/mob/living/carbon/C = user
>>>>>>> 37cfcfc45fa... Merge pull request #8685 from Spookerton/spkrtn/cng/tweak-effect-aura
			to_chat(C, "<span class='danger'>A painful discharge of energy strikes you!</span>")
			C.adjustOxyLoss(rand(5,25) * weakness)
			C.adjustToxLoss(rand(5,25) * weakness)
			C.adjustBruteLoss(rand(5,25) * weakness)
			C.adjustFireLoss(rand(5,25) * weakness)
			C.adjustBrainLoss(rand(1,5) * weakness)
			C.apply_effect(25 * weakness, IRRADIATE)
			C.adjust_nutrition(-50 * weakness)
			C.nutrition -= min(50 * weakness, C.nutrition)
			C.make_dizzy(6 * weakness)
			C.weakened += 6 * weakness

<<<<<<< HEAD
/datum/artifact_effect/hurt/DoEffectAura()
=======

/datum/artifact_effect/uncommon/hurt/DoEffectAura()
>>>>>>> 37cfcfc45fa... Merge pull request #8685 from Spookerton/spkrtn/cng/tweak-effect-aura
	var/atom/holder = get_master_holder()
	if (holder)
		var/turf/T = get_turf(holder)
		for (var/mob/living/carbon/C in range(src.effectrange,T))
			var/weakness = GetAnomalySusceptibility(C)
			if (prob(weakness * 100))
				if (prob(10))
					to_chat(C, "<span class='danger'>You feel a painful force radiating from something nearby.</span>")
				C.adjustBruteLoss(1 * weakness)
				C.adjustFireLoss(1 * weakness)
				C.adjustToxLoss(1 * weakness)
				C.adjustOxyLoss(1 * weakness)
				C.adjustBrainLoss(0.1 * weakness)
				C.updatehealth()

<<<<<<< HEAD
/datum/artifact_effect/hurt/DoEffectPulse()
=======

/datum/artifact_effect/uncommon/hurt/DoEffectPulse()
>>>>>>> 37cfcfc45fa... Merge pull request #8685 from Spookerton/spkrtn/cng/tweak-effect-aura
	var/atom/holder = get_master_holder()
	if (holder)
		var/turf/T = get_turf(holder)
		for (var/mob/living/carbon/C in range(effectrange, T))
			var/weakness = GetAnomalySusceptibility(C)
			if (prob(weakness * 100))
				to_chat(C, "<span class='danger'>A wave of painful energy strikes you!</span>")
				C.adjustBruteLoss(3 * weakness)
				C.adjustFireLoss(3 * weakness)
				C.adjustToxLoss(3 * weakness)
				C.adjustOxyLoss(3 * weakness)
				C.adjustBrainLoss(0.1 * weakness)
				C.updatehealth()
