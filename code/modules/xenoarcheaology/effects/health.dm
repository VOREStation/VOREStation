/// Modified to work with the Artifact Harvester
#define EFFECT_HEAL 1
#define EFFECT_HARM 2
/datum/artifact_effect/health
	name = "Health"
	effect_type = EFFECT_HEALTH
	effect_color = "#4649ff"
	var/health_type = EFFECT_HEAL

/datum/artifact_effect/health/New()
	..()
	health_type = pick(EFFECT_HEAL, EFFECT_HARM)
	if(health_type == EFFECT_HEAL)
		effect_color = "#4649ff"
	else
		effect_color = "#6d1212"

/datum/artifact_effect/health/DoEffectTouch(var/mob/toucher)
	var/atom/holder = get_master_holder()
	if(istype(holder, /obj/item/anobattery))
		var/obj/item/anobattery/battery = holder
		battery.stored_charge = max(0, battery.stored_charge-50) //This artifact uses charge at an accelrated rate. It makes you nigh invincvible while it's up OR kills you extremely quickly while it's up.
	if(toucher && iscarbon(toucher))
		var/weakness = GetAnomalySusceptibility(toucher)
		if(prob(weakness * 100))
			var/mob/living/carbon/C = toucher
			if(health_type == EFFECT_HEAL)
				to_chat(C, span_blue("You feel a soothing energy invigorate you."))
				if(ishuman(toucher))
					var/mob/living/carbon/human/H = toucher
					for(var/obj/item/organ/external/affecting in H.organs)
						if(affecting && istype(affecting))
							affecting.heal_damage(25 * weakness, 25 * weakness)
					H.vessel.add_reagent(REAGENT_ID_BLOOD,5)
					H.adjust_nutrition(50 * weakness)
					H.adjustBrainLoss(-25 * weakness)
					H.radiation -= min(H.radiation, 25 * weakness)
					H.bodytemperature = initial(H.bodytemperature)
					H.fixblood()
				C.adjustOxyLoss(-25 * weakness)
				C.adjustToxLoss(-25 * weakness)
				C.adjustBruteLoss(-25 * weakness)
				C.adjustFireLoss(-25 * weakness)
				C.regenerate_icons()
			else
				to_chat(C, span_danger("A painful discharge of energy strikes you!"))
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
			return 1

/datum/artifact_effect/health/DoEffectAura()
	var/atom/holder = get_master_holder()
	//This is where I would make it drain charge at an accelerated rate, but...A passive 1 heal per 2 seconds is weak and fine.
	if(holder)
		var/turf/T = get_turf(holder)
		for (var/mob/living/carbon/C in range(src.effectrange,T))
			var/weakness = GetAnomalySusceptibility(C)
			if(prob(weakness * 100))
				if(health_type == EFFECT_HEAL)
					if(prob(10))
						to_chat(C, span_blue("You feel a soothing energy radiating from something nearby."))
					C.adjustBruteLoss(-1 * weakness)
					C.adjustFireLoss(-1 * weakness)
					C.adjustToxLoss(-1 * weakness)
					C.adjustOxyLoss(-1 * weakness)
					C.adjustBrainLoss(-1 * weakness)
					C.updatehealth()
				else
					if(prob(10))
						to_chat(C, span_danger("You feel a painful force radiating from something nearby."))
					C.adjustBruteLoss(1 * weakness)
					C.adjustFireLoss(1 * weakness)
					C.adjustToxLoss(1 * weakness)
					C.adjustOxyLoss(1 * weakness)
					C.adjustBrainLoss(0.1 * weakness)
					C.updatehealth()

/datum/artifact_effect/health/DoEffectPulse()
	var/atom/holder = get_master_holder() //I'm not touching the below line because it's FUNNY that a 'todo:' has been sitting there for 12 years.
	//todo: check over this properly
	//Anyways, this is where you'd put accelerated drain code, but it already drains at 200 a tick, meaning you get 2-3 uses at most before having to recharge.
	if(holder)
		var/turf/T = get_turf(holder)
		for (var/mob/living/carbon/C in range(src.effectrange,T))
			var/weakness = GetAnomalySusceptibility(C)
			if(prob(weakness * 100))
				if(health_type == EFFECT_HEAL)
					to_chat(C, span_blue("A wave of energy invigorates you."))
					C.adjustBruteLoss(-25 * weakness)
					C.adjustFireLoss(-25 * weakness)
					C.adjustToxLoss(-25 * weakness)
					C.adjustOxyLoss(-25 * weakness)
					C.adjustBrainLoss(-25 * weakness)
					C.updatehealth()
				else
					to_chat(C, span_danger("A wave of painful energy strikes you!"))
					C.adjustBruteLoss(3 * weakness)
					C.adjustFireLoss(3 * weakness)
					C.adjustToxLoss(3 * weakness)
					C.adjustOxyLoss(3 * weakness)
					C.adjustBrainLoss(0.1 * weakness)
					C.updatehealth()

#undef EFFECT_HEAL
#undef EFFECT_HARM
