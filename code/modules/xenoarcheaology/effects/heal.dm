/// Modified to work with the Artifact Harvester
/datum/artifact_effect/heal
	name = "Healing"
	effect_type = EFFECT_HEAL
	effect_color = "#4649ff"

/datum/artifact_effect/heal/DoEffectTouch(var/mob/toucher)
	var/atom/holder = get_master_holder()
	if(istype(holder, /obj/item/anobattery))
		var/obj/item/anobattery/battery = holder
		battery.stored_charge = max(0, battery.stored_charge-50) //This artifact uses charge at an accelrated rate. It makes you nigh invincvible while it's up.
	if(toucher && iscarbon(toucher))
		var/weakness = GetAnomalySusceptibility(toucher)
		if(prob(weakness * 100))
			var/mob/living/carbon/C = toucher
			to_chat(C, span_blue("You feel a soothing energy invigorate you."))

			if(ishuman(toucher))
				var/mob/living/carbon/human/H = toucher
				for(var/obj/item/organ/external/affecting in H.organs)
					if(affecting && istype(affecting))
						affecting.heal_damage(25 * weakness, 25 * weakness)
				//H:heal_organ_damage(25, 25)
				H.vessel.add_reagent(REAGENT_ID_BLOOD,5)
				H.adjust_nutrition(50 * weakness)
				H.adjustBrainLoss(-25 * weakness)
				H.radiation -= min(H.radiation, 25 * weakness)
				H.bodytemperature = initial(H.bodytemperature)
				H.fixblood()
			//
			C.adjustOxyLoss(-25 * weakness)
			C.adjustToxLoss(-25 * weakness)
			C.adjustBruteLoss(-25 * weakness)
			C.adjustFireLoss(-25 * weakness)
			//
			C.regenerate_icons()
			return 1

/datum/artifact_effect/heal/DoEffectAura()
	var/atom/holder = get_master_holder()
	//This is where I would make it drain charge at an accelerated rate, but...A passive 1 heal per 2 seconds is weak and fine.
	if(holder)
		var/turf/T = get_turf(holder)
		for (var/mob/living/carbon/C in range(src.effectrange,T))
			var/weakness = GetAnomalySusceptibility(C)
			if(prob(weakness * 100))
				if(prob(10))
					to_chat(C, span_blue("You feel a soothing energy radiating from something nearby."))
				C.adjustBruteLoss(-1 * weakness)
				C.adjustFireLoss(-1 * weakness)
				C.adjustToxLoss(-1 * weakness)
				C.adjustOxyLoss(-1 * weakness)
				C.adjustBrainLoss(-1 * weakness)
				C.updatehealth()

/datum/artifact_effect/heal/DoEffectPulse()
	var/atom/holder = get_master_holder() //I'm not touching the below line because it's FUNNY that a 'todo:' has been sitting there for 12 years.
	//todo: check over this properly
	//Anyways, this is where you'd put accelerated drain code, but it already drains at 200 a tick, meaning you get 2-3 uses at most before having to recharge.
	if(holder)
		var/turf/T = get_turf(holder)
		for (var/mob/living/carbon/C in range(src.effectrange,T))
			var/weakness = GetAnomalySusceptibility(C)
			if(prob(weakness * 100))
				to_chat(C, span_blue("A wave of energy invigorates you."))
				C.adjustBruteLoss(-25 * weakness)
				C.adjustFireLoss(-25 * weakness)
				C.adjustToxLoss(-25 * weakness)
				C.adjustOxyLoss(-25 * weakness)
				C.adjustBrainLoss(-25 * weakness)
				C.updatehealth()
