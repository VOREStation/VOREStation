/datum/artifact_effect
	var/name = "unknown"
	var/effect = EFFECT_TOUCH
	var/effectrange = 4
	var/trigger = TRIGGER_TOUCH
	var/datum/component/artifact_master/master
	var/activated = 0
	var/chargelevel = 1
	var/chargelevelmax = 10
	var/artifact_id = ""
	var/effect_type = 0
	var/req_type = /atom/movable
	var/image/active_effect
	var/effect_icon = 'icons/effects/effects.dmi'
	var/effect_state = "sparkles"
	var/effect_color = "#ffffff"
<<<<<<< HEAD

	// The last time the effect was toggled.
=======
>>>>>>> 37cfcfc45fa... Merge pull request #8685 from Spookerton/spkrtn/cng/tweak-effect-aura
	var/last_activation = 0


/datum/artifact_effect/Destroy()
	if (master)
		master = null
<<<<<<< HEAD
	..()

/datum/artifact_effect/proc/get_master_holder()	// Return the effectmaster's holder, if it is set to an effectmaster. Otherwise, master is the target object.
	if(istype(master))
		return master.holder
	else
		return master
=======
	return ..()

>>>>>>> 37cfcfc45fa... Merge pull request #8685 from Spookerton/spkrtn/cng/tweak-effect-aura

/datum/artifact_effect/New(datum/component/artifact_master/newmaster)
	..()
	master = newmaster
	effect = rand(0, MAX_EFFECT)
	trigger = rand(0, MAX_TRIGGER)
	if (effect_icon && effect_state)
		if (effect_state == "sparkles")
			effect_state = "sparkles_[rand(1,4)]"
		active_effect = image(effect_icon, effect_state)
		active_effect.color = effect_color
	artifact_id = "[pick("kappa","sigma","antaeres","beta","omicron","iota","epsilon","omega","gamma","delta","tau","alpha")]-[rand(100,999)]"
	switch (pick(100;1, 50;2, 25;3))
		if (1) //short range, short charge time
			chargelevelmax = rand(3, 20)
			effectrange = rand(1, 3)
		if (2) //medium range, medium charge time
			chargelevelmax = rand(15, 40)
			effectrange = rand(5, 15)
		if (3) //large range, long charge time
			chargelevelmax = rand(20, 120)
			effectrange = rand(20, 100) //VOREStation Edit - Map size.


/datum/artifact_effect/process()
	if (chargelevel < chargelevelmax)
		chargelevel++
	if (activated)
		if (effect == EFFECT_AURA)
			DoEffectAura()
		else if (effect == EFFECT_PULSE && chargelevel >= chargelevelmax)
			chargelevel = 0
			DoEffectPulse()


/// Return the effectmaster's holder, if it is set to an effectmaster. Otherwise, master is the target object.
/datum/artifact_effect/proc/get_master_holder()
	if (istype(master))
		return master.holder
	else
		return master


/datum/artifact_effect/proc/ToggleActivate(reveal_toggle = TRUE)
	set waitfor = FALSE
	var/atom/target = get_master_holder()
	if (world.time - last_activation > 1 SECOND)
		last_activation = world.time
		if (activated)
			activated = 0
		else
			activated = 1
		if (reveal_toggle && target)
			if (!isliving(target))
				target.update_icon()
			var/display_msg
			if (activated)
				display_msg = pick("momentarily glows brightly!","distorts slightly for a moment!","flickers slightly!","vibrates!","shimmers slightly for a moment!")
			else
				display_msg = pick("grows dull!","fades in intensity!","suddenly becomes very still!","suddenly becomes very quiet!")
			if (active_effect)
				if (activated)
					target.underlays.Add(active_effect)
				else
					target.underlays.Remove(active_effect)
			var/atom/toplevelholder = target
			while (!istype(toplevelholder.loc, /turf))
				toplevelholder = toplevelholder.loc
			toplevelholder.visible_message("<font color='red'>\icon[toplevelholder][bicon(toplevelholder)] [toplevelholder] [display_msg]</font>")


/datum/artifact_effect/proc/DoEffectTouch(mob/living/user)
	return


/datum/artifact_effect/proc/DoEffectAura()
	return


/datum/artifact_effect/proc/DoEffectPulse()
	return


/datum/artifact_effect/proc/UpdateMove()
	return


/datum/artifact_effect/proc/getDescription()
	. = "<b>"
	switch (effect_type)
		if (EFFECT_ENERGY)
			. += "Concentrated energy emissions"
		if (EFFECT_PSIONIC)
			. += "Intermittent psionic wavefront"
		if (EFFECT_ELECTRO)
			. += "Electromagnetic energy"
		if (EFFECT_PARTICLE)
			. += "High frequency particles"
		if (EFFECT_ORGANIC)
			. += "Organically reactive exotic particles"
		if (EFFECT_BLUESPACE)
			. += "Interdimensional/bluespace? phasing"
		if (EFFECT_SYNTH)
			. += "Atomic synthesis"
		else
			. += "Low level energy emissions"
	. += "</b> have been detected <b>"
	switch (effect)
		if (EFFECT_TOUCH)
			. += "interspersed throughout substructure and shell."
		if (EFFECT_AURA)
			. += "emitting in an ambient energy field."
		if (EFFECT_PULSE)
			. += "emitting in periodic bursts."
		else
			. += "emitting in an unknown way."
	. += "</b>"
	switch (trigger)
		if (TRIGGER_TOUCH, TRIGGER_WATER, TRIGGER_ACID, TRIGGER_VOLATILE, TRIGGER_TOXIN)
			. += " Activation index involves <b>physical interaction</b> with artifact surface."
		if (TRIGGER_FORCE, TRIGGER_ENERGY, TRIGGER_HEAT, TRIGGER_COLD)
			. += " Activation index involves <b>energetic interaction</b> with artifact surface."
		if (TRIGGER_PHORON, TRIGGER_OXY, TRIGGER_CO2, TRIGGER_NITRO)
			. += " Activation index involves <b>precise local atmospheric conditions</b>."
		else
			. += " Unable to determine any data about activation trigger."

<<<<<<< HEAD
//returns 0..1, with 1 being no protection and 0 being fully protected
/proc/GetAnomalySusceptibility(var/mob/living/carbon/human/H)
	if(!istype(H))
		return 1
	var/area/A = get_area(H)
	if(A.forbid_events)
		return 0
	var/protected = 0

	//anomaly suits give best protection, but excavation suits are almost as good
	if(istype(H.back,/obj/item/weapon/rig/hazmat))
		var/obj/item/weapon/rig/hazmat/rig = H.back
		if(rig.suit_is_deployed() && !rig.offline)
			protected += 1

	if(istype(H.wear_suit,/obj/item/clothing/suit/bio_suit/anomaly))
		protected += 0.6
	else if(istype(H.wear_suit,/obj/item/clothing/suit/space/anomaly))
		protected += 0.5

	if(istype(H.head,/obj/item/clothing/head/bio_hood/anomaly))
		protected += 0.3
	else if(istype(H.head,/obj/item/clothing/head/helmet/space/anomaly))
		protected += 0.2

	//latex gloves and science goggles also give a bit of bonus protection
	if(istype(H.gloves,/obj/item/clothing/gloves/sterile))
		protected += 0.1

	if(istype(H.glasses,/obj/item/clothing/glasses/science))
		protected += 0.1

	return 1 - protected
=======

/// returns 0..1, with 1 being no protection and 0 being fully protected
/proc/GetAnomalySusceptibility(mob/living/carbon/human/H)
	if (!istype(H))
		return 1
	var/susceptibility = 1
	if (istype(H.back,/obj/item/rig/hazmat))
		var/obj/item/rig/hazmat/rig = H.back
		if (!rig.offline && rig.suit_is_deployed())
			return 0
	if (istype(H.wear_suit, /obj/item/clothing/suit/bio_suit/anomaly))
		susceptibility -= 0.6
	else if (istype(H.wear_suit, /obj/item/clothing/suit/space/anomaly))
		susceptibility -= 0.5
	if (istype(H.head, /obj/item/clothing/head/bio_hood/anomaly))
		susceptibility -= 0.3
	else if (istype(H.head, /obj/item/clothing/head/helmet/space/anomaly))
		susceptibility -= 0.2
	if (istype(H.gloves, /obj/item/clothing/gloves/sterile))
		susceptibility -= 0.1
	if (istype(H.glasses, /obj/item/clothing/glasses/science))
		susceptibility -= 0.1
	return clamp(susceptibility, 0, 1)
>>>>>>> 37cfcfc45fa... Merge pull request #8685 from Spookerton/spkrtn/cng/tweak-effect-aura
