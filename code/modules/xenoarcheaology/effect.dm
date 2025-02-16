/datum/artifact_effect
	var/name = "unknown"
	var/effect = EFFECT_TOUCH //This is simply if the effect occurs on touch, in an aura, or a pulse AOE. Horribly named variable.
	var/effectrange = 4 //How far the effect will hit something.
	var/trigger = TRIGGER_TOUCH //This decides how the artifact is actually activated. Ex: Splashing water on it.
	var/datum/component/artifact_master/master //This code is handled in effect_master.dm
	var/activated = 0
	var/chargelevel = 1
	var/chargelevelmax = 10
	var/artifact_id = ""
	var/effect_type = 0 //This is what the artifact does. This is used to generating a description when inspected.
	var/harvestable = 1 //If we can be harvested or not

	var/req_type = /atom/movable

	var/image/active_effect
	var/effect_icon = 'icons/effects/effects.dmi'
	var/effect_state = "sparkles"
	var/effect_color = "#ffffff"

	// The last time the effect was toggled.
	var/last_activation = 0

/datum/artifact_effect/Destroy()
	master = null //Master still exists even if our effect gets destroyed. No need to qdel_null.
	qdel_null(active_effect)
	..()

/datum/artifact_effect/proc/get_master_holder()	// Return the effectmaster's holder, if it is set to an effectmaster. Otherwise, master is the target object.
	if(istype(master))
		return master.holder
	else
		return master

/datum/artifact_effect/New(var/datum/component/artifact_master/newmaster)
	..()

	master = newmaster
	effect = rand(EFFECT_TOUCH, MAX_EFFECT) //This can be overwritten per artifact, in case you want one to only be touch, aura, or pulse!
	trigger = rand(TRIGGER_TOUCH, MAX_TRIGGER) //Same for this! You can make artifacts that can ONLY be activated through XYZ!

	if(effect_icon && effect_state)
		if(effect_state == "sparkles")
			effect_state = "sparkles_[rand(1,4)]"
		active_effect = image(effect_icon, effect_state)
		active_effect.color = effect_color

	//this will be replaced by the excavation code later, but it's here just in case
	artifact_id = "[pick("kappa","sigma","antaeres","beta","omicron","iota","epsilon","omega","gamma","delta","tau","alpha")]-[rand(100,999)]"

	//random charge time and distance
	switch(pick(100;1, 50;2, 25;3))
		if(1)
			//short range, short charge time
			chargelevelmax = rand(3, 20)
			effectrange = rand(1, 3)
		if(2)
			//medium range, medium charge time
			chargelevelmax = rand(15, 40)
			effectrange = rand(5, 15)
		if(3)
			//large range, long charge time
			chargelevelmax = rand(20, 120)
			effectrange = rand(20, 100) //VOREStation Edit - Map size.

/datum/artifact_effect/proc/ToggleActivate(var/reveal_toggle = 1)
	//so that other stuff happens first
	set waitfor = FALSE

	var/atom/target = get_master_holder()

	if(world.time - last_activation > 1 SECOND)
		last_activation = world.time
		if(activated)
			activated = 0
		else
			activated = 1
		if(reveal_toggle && target)
			if(!isliving(target))
				target.update_icon()
			var/display_msg
			if(activated)
				display_msg = pick("momentarily glows brightly!","distorts slightly for a moment!","flickers slightly!","vibrates!","shimmers slightly for a moment!")
			else
				display_msg = pick("grows dull!","fades in intensity!","suddenly becomes very still!","suddenly becomes very quiet!")

			if(active_effect)
				if(activated)
					target.underlays.Add(active_effect)
				else
					target.underlays.Remove(active_effect)

			var/atom/toplevelholder = target
			while(!istype(toplevelholder.loc, /turf))
				toplevelholder = toplevelholder.loc
			toplevelholder.visible_message(span_filter_notice("[span_red("[icon2html(toplevelholder, viewers(toplevelholder))] [toplevelholder] [display_msg]")]"))

/datum/artifact_effect/proc/DoEffectTouch(var/mob/user)
/datum/artifact_effect/proc/DoEffectAura(var/atom/holder)
/datum/artifact_effect/proc/DoEffectPulse(var/atom/holder)
/datum/artifact_effect/proc/UpdateMove()

/datum/artifact_effect/process()
	if(chargelevel < chargelevelmax)
		chargelevel++

	if(activated)
		if(effect == EFFECT_AURA)
			DoEffectAura()
		else if(effect == EFFECT_PULSE && chargelevel >= chargelevelmax)
			chargelevel = 0
			DoEffectPulse()

/datum/artifact_effect/proc/getDescription()
	. = "<br><br>This object has been detected to: "
	switch(effect_type)
		if(EFFECT_UNKNOWN)
			. += span_bold("have an unknown effect") //Should never happen but you know, whatever. Failsafe.
		if(EFFECT_ANIMATE)
			. += span_bold("have intermittent movement either towards or away from an individual")
		if(EFFECT_FEELINGS)
			. += span_bold("cause subjects to feel a certain way")
		if(EFFECT_CELL)
			. += span_bold("charges or drains electronic devices in range")
		if(EFFECT_TEMPERATURE)
			. += span_bold("adjust the thermal energy in an area")
		/* //Not Yet Implemented
		if(EFFECT_DNASWITCH)
			. += "scramble the DNA of a subject, resulting in rampant genetic mutation"
		*/
		if(EFFECT_ELECTIC_FIELD)
			. += "discharge concentrated electrical energy"
		if(EFFECT_EMP)
			. += "discharge electromagnetic energy"
		if(EFFECT_FEYSIGHT)
			. += "invoke visions in subjects" //spooky.
		if(EFFECT_FORCEFIELD)
			. += "create a forcefield within a short range"
		if(EFFECT_GAIA)
			. += "transfer healing energies to nearby flora"
		if(EFFECT_GAS)
			. += "emits gas of some type"
		if(EFFECT_GRAVIATIONAL_WAVES)
			. += "create local gravitational distortions"
		if(EFFECT_HEALTH)
			. += "transfer energies into subjects, harming or healing them"
		if(EFFECT_POLTERGEIST)
			. += "cause local movement phenomena"
		if(EFFECT_RADIATE)
			. += "transfer high energy gamma rays into subjects"
		if(EFFECT_RESURRECT)
			. += "transfer the lifeforce from one entity to another, potentially allowing the ressurection of deceased entities"
		if(EFFECT_ROBOT_HEALTH)
			. += "transfer energies into synthetic lifeforms, harming or healing them"
		if(EFFECT_SLEEPY)
			. += "invoke drowsiness in subjects"
		if(EFFECT_STUN)
			. += "discharge non-lethal amounts of energy into subjects"
		if(EFFECT_TELEPORT)
			. += "displace subjects using bluespace phenomena"
		if(EFFECT_VAMPIRE)
			. += "drain the blood of subjects, creating creatures or anomalous artifacts in the process"
		if(EFFECT_DNASWITCH)
			. += "mutate the cells of the organism that touches it, resulting in rampant mutations"
		else
			. += "have no previously-known anomalous properties"

	. += ". The method of the dispersion of the object's effect seems to be through "

	switch(effect)
		if(EFFECT_TOUCH)
			. += span_bold(" contact with the object.")
		if(EFFECT_AURA)
			. += span_bold(" occasional, short ranged pulses of energy.")
		if(EFFECT_PULSE)
			. += span_bold(" occasional, long ranged pulses of energy.")
		else
			. += ""

	. += "<br>"

	switch(trigger)
		if(TRIGGER_TOUCH) //This one should be self explanatory.
			. += "Activation index involves " + span_bold("physical interaction") + " with artifact surface."
		if(TRIGGER_WATER, TRIGGER_ACID, TRIGGER_VOLATILE, TRIGGER_TOXIN) //No xenoarch would know how to activate these without code digging.
			. += " Activation index involves " + span_bold("chemical interaction with artifact surface.") + " Water/Hydrogen, sulfuric acid, Thermite/Phoron, and toxin/toxic substances (such as lead, phoron, fertilizers, among others) are potential triggers."

		if(TRIGGER_FORCE, TRIGGER_ENERGY) //Did you know multitools can activate energy artifacts?
			. += " Activation index involves " + span_bold("forceful or energetic interaction with artifact surface.") + " Potential triggers are a pulse from a multitool or battering the artifact with a strong object."

		if(TRIGGER_HEAT, TRIGGER_COLD) //Heat is easy to activate. Smack it with a welder. Cold? Have to cool the area.
			. += " Activation index involves " + span_bold("precise temperature conditions.") + " Heating/Cooling the atmosphere (>[ARTIFACT_HEAT_TRIGGER]K or <[ARTIFACT_COLD_TRIGGER]K) or using a welder are potential triggers."
		else
			. += " Unable to determine any data about activation trigger."

//returns 0..1, with 1 being no protection and 0 being fully protected
/proc/GetAnomalySusceptibility(var/mob/living/carbon/human/H)
	if(!istype(H))
		return 1
	var/area/A = get_area(H)
	if(A.flag_check(AREA_FORBID_EVENTS))
		return 0
	var/protected = 0

	//anomaly suits give best protection, but excavation suits are almost as good
	if(istype(H.back,/obj/item/rig/hazmat))
		var/obj/item/rig/hazmat/rig = H.back
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
