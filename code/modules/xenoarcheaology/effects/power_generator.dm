// Unticking this from the .dme until it has some custom sounds and is modified.
// This works as is, but is EXTREMELY dangerous and I want it to only show up on LARGE artifacts, not small ones.
/datum/artifact_effect/generator
	name = "Power Generation"
	effect_type = EFFECT_GENERATOR
	effect_color = "#fff134"
	activated = 0
	var/gen_rate = 0
	var/gen_level = 0
	var/mode = 0
	var/obj/structure/cable/attached
	var/list/spark_sounds = list('sound/effects/sparks1.ogg','sound/effects/sparks2.ogg','sound/effects/sparks3.ogg','sound/effects/sparks4.ogg','sound/effects/sparks5.ogg','sound/effects/sparks6.ogg')
	harvestable = 0

/datum/artifact_effect/generator/New()
	..()
	gen_level = rand(1,10) // levels from 1-10
	gen_rate = 500000 * 1.0715 ** ((gen_level-1)*10 + rand(0,10))
	trigger = TRIGGER_TOUCH
	effect = EFFECT_TOUCH
	activated = TRUE //We are ALWAYS on.
	START_PROCESSING(SSprocessing, src)


/datum/artifact_effect/generator/ToggleActivate()
	return //We can not be turned off.

/datum/artifact_effect/generator/DoEffectTouch(var/mob/living/carbon/human/user)
	var/obj/holder = get_master_holder()
	if (..())
		return
	var/obj/item/organ/external/affected = user.get_organ(check_zone(BP_L_HAND))
	user.electrocute_act(gen_level*9, src, user.get_siemens_coefficient_organ(affected), affected) //In case you touch it without insuls.
	if(mode == 0)
		var/turf/T = get_turf(holder)
		if(isturf(T))
			attached = locate() in T
			if(!attached)
				to_chat(user, "No exposed cable here to attach to.")
			else
				holder.anchored = TRUE
				mode = 2
				holder.visible_message("[holder] connects itself to the cable. Weird.")
				// playsound(holder, 'x', 75, TRUE) //TODO: Get sounds here
				holder.set_light(gen_level, 25, effect_color)
		else
			to_chat(user, "[holder] must be placed over a cable to attach to it.")
	else
		holder.anchored = FALSE
		mode = 0
		attached = 0
		to_chat(user, "[holder] disconnects itself from the cable.")
		// playsound(holder, 'X', 75, TRUE, 0, 2) //TODO: Get sounds here
		holder.set_light(FALSE)

/datum/artifact_effect/generator/process(var/obj/holder)
	holder = get_master_holder()
	if(attached)
		var/datum/powernet/PN = attached.powernet
		if(PN)
			PN.newavail += gen_rate
			var/turf/T = get_turf(holder)
			// playsound(holder, 'X', 75, TRUE, 0, 1) //TODO: Get sounds here
			if (prob(5))
				// playsound(holder, 'X', 75, TRUE) //TODO: Get sounds here
				var/turf/location = holder.loc
				if(isturf(location))
					var/obj/effect/decal/cleanable/liquid_fuel/flamethrower_fuel/fuel_spill = new /obj/effect/decal/cleanable/liquid_fuel/flamethrower_fuel(location)
					fuel_spill.amount = 15
					fuel_spill.Spread()
					location.hotspot_expose(1000,500,1)
				holder.visible_message(span_alert("[holder] erupts in flame!"))
			if (prob(3))
				// playsound(holder, 'X', 75, TRUE) //TODO: Get sounds here
				holder.visible_message(span_alert("[holder] rumbles!"))
				for (var/mob/M in range(min(5,gen_level),T))
					shake_camera(M, 5, 8)
					M.weakened += 1
				for (var/turf/TF in range(min(5,gen_level),T))
					holder.animate_shake()
				if (gen_level >= 5)
					for (var/obj/structure/window/W in range(min(5,gen_level), T))
						W.health = 0
						W.shatter()
			if (prob(5))
				// playsound(holder, 'X', 75, TRUE) //TODO: Get sounds here
				holder.visible_message(span_alert("[holder] sparks violently!"))
				for (var/mob/living/M in view(min(5,gen_level),T))
					if(ishuman(M))
						var/mob/living/carbon/human/target = M
						var/obj/item/organ/external/affected = target.get_organ(check_zone(BP_TORSO))
						target.electrocute_act(gen_level*9, src, target.get_siemens_coefficient_organ(affected), affected)
					else
						M.electrocute_act(gen_level*9, src)
	else
		if(prob(5))
			playsound(holder, pick(spark_sounds), 75, 1)
